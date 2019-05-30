Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A954D2FF87
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 17:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfE3Pgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 11:36:33 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:37019 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfE3Pgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 11:36:33 -0400
Received: by mail-pg1-f178.google.com with SMTP id 20so2241951pgr.4;
        Thu, 30 May 2019 08:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1yMsWBa2LYm1ILpkgQW8NI9YdDqB00cGkBtVNDeSeMg=;
        b=iejAcWWk/sgsNXqodzj0a7bpwEeVKrnkka8LoYxVwqX1b1hrsRoKfUI9phfaDNEQGC
         HMlANp1GMWvPKbut3t0fzrbKpPa2fPq3pB2paHORRaVDdut0uJwS+2WUJZmg/Lp5Gq9p
         guImv2uyJKE6z8u31Vksl18eQQJ9zhvV+84KlcmYNE0Oq4fsbdbPN7yjMsCaWfylxmxQ
         ZVjKiIDORAe/p/C/M4eqEV3f1OkYlpeCF91gyMTChUwSzLAR9b7rEEnC7haqNKP31PGI
         y2OAmzgF2NYsF4kO8GO4vmnhmNeWAGgbFtnP127uFubOYvQZMrUgFT2zJ5JHY26+qph6
         rMBA==
X-Gm-Message-State: APjAAAViyBM7Xvr0gno7ovCSrBqlXBGg+wsGo9cW+Kk7HzTJC10cLz9X
        Dzr+pP8BZ+2GNP3P4T+C03M=
X-Google-Smtp-Source: APXvYqwseK44AapTJu1In2XK3PtnbTcjNqAN7PFnhrcVu/mm9Jxmi3dTNPUz+Mpk7IptXTRS0gUnEQ==
X-Received: by 2002:a63:2706:: with SMTP id n6mr4412443pgn.238.1559230592594;
        Thu, 30 May 2019 08:36:32 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id m24sm2458298pgh.75.2019.05.30.08.36.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 08:36:31 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ad0578b0-ce73-85ed-b67d-70c5d8176a23@acm.org>
Date:   Thu, 30 May 2019 08:36:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190530112811.3066-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/19 4:28 AM, Paolo Bonzini wrote:
> +static const struct blk_mq_ops scsi_mq_ops_no_commit = {
> +	.get_budget	= scsi_mq_get_budget,
> +	.put_budget	= scsi_mq_put_budget,
> +	.queue_rq	= scsi_queue_rq,
> +	.complete	= scsi_softirq_done,
> +	.timeout	= scsi_timeout,
> +#ifdef CONFIG_BLK_DEBUG_FS
> +	.show_rq	= scsi_show_rq,
> +#endif
> +	.init_request	= scsi_mq_init_request,
> +	.exit_request	= scsi_mq_exit_request,
> +	.initialize_rq_fn = scsi_initialize_rq,
> +	.busy		= scsi_mq_lld_busy,
> +	.map_queues	= scsi_map_queues,
> +};
> +
> +static void scsi_commit_rqs(struct blk_mq_hw_ctx *hctx)
> +{
> +	struct request_queue *q = hctx->queue;
> +	struct scsi_device *sdev = q->queuedata;
> +	struct Scsi_Host *shost = sdev->host;
> +
> +	shost->hostt->commit_rqs(shost, hctx->queue_num);
> +}
> +
>   static const struct blk_mq_ops scsi_mq_ops = {
>   	.get_budget	= scsi_mq_get_budget,
>   	.put_budget	= scsi_mq_put_budget,
>   	.queue_rq	= scsi_queue_rq,
> +	.commit_rqs	= scsi_commit_rqs,
>   	.complete	= scsi_softirq_done,
>   	.timeout	= scsi_timeout,
>   #ifdef CONFIG_BLK_DEBUG_FS

Hi Paolo,

Have you considered to modify the block layer such that a single 
scsi_mq_ops structure can be used for all SCSI LLD types?

Thanks,

Bart.
