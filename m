Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6D030112
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 19:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfE3R2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 13:28:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44276 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfE3R2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 13:28:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id n2so2387988pgp.11;
        Thu, 30 May 2019 10:28:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BflUr6rKdpr90b/xnrg7SuYvVoPW3SrHX1BWPnESWU4=;
        b=dVIQnWhekN3xb7mGXiHWYSLwp6AEBqjSOXmHi79/5hf8vjisVnhUwH1xh8s7/KPgNu
         by19n277vaZJWrPPuDBZ7S0RE6YkdLC8ydooKu3CZtSBGGAlEQa6Ltumqa1DbXyDw58Z
         u989d75UlWYPFd5+RssnO4AMcynn5g4WPZn+lhvH9GndfznsZEE8eJvJ1pt1DPenXpJg
         2omyZTwE2KkQjQ5U8XJSr8Lfrdu3sdQtXsAIz+6VmA8lf3UhL7MispcVFbIQLkCRPQ0K
         DlxFERvVy2/ebtI7D3FFehWC1X5MQ0Sd68aQgc8NkcNU37GkOKA+sVYUbQG0N68i7bd6
         2zOw==
X-Gm-Message-State: APjAAAXqum33M9oExcJUzIN15iXiPa3kLFDvlrztMi6vTD85zk4q/Kpy
        vH0Ws6zc9+EGuNFrYT/+fkQ=
X-Google-Smtp-Source: APXvYqxYwulWOdqze7jLG0lDh0QFnMWrHijpHoWBnnsxuObzIyHqBOgmKbOybUmS8t7zEPvLNx5Fqg==
X-Received: by 2002:a63:e708:: with SMTP id b8mr4809033pgi.168.1559237314488;
        Thu, 30 May 2019 10:28:34 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id q7sm3405191pjb.0.2019.05.30.10.28.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 10:28:33 -0700 (PDT)
Subject: Re: [PATCH 2/2] virtio_scsi: implement request batching
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-3-pbonzini@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <79490df1-0145-5b40-027a-7e8fb96854d4@acm.org>
Date:   Thu, 30 May 2019 10:28:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190530112811.3066-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/19 4:28 AM, Paolo Bonzini wrote:
> @@ -531,7 +547,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
>   		req_size = sizeof(cmd->req.cmd);
>   	}
>   
> -	ret = virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd));
> +	kick = (sc->flags & SCMD_LAST) != 0;
> +	ret = virtscsi_add_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd), kick);

Have you considered to have the SCSI core call commit_rqs() if bd->last 
is true? I think that would avoid that we need to introduce the 
SCMD_LAST flag and that would also avoid that every SCSI LLD that 
supports a commit_rqs callback has to introduce code to test the 
SCMD_LAST flag.

Thanks,

Bart.
