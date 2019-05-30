Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2378730150
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 19:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfE3RyQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 30 May 2019 13:54:16 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40458 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfE3RyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 13:54:16 -0400
Received: by mail-pl1-f193.google.com with SMTP id g69so2861542plb.7;
        Thu, 30 May 2019 10:54:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DT3jejRxZC9WvUsnuDGX0vv5ag+rjxjKs+Fh8jcJz98=;
        b=lXHTiDB4IamxOOqph0rtarOe1KzFqq/PUdL1MHexSTz6yS7z0oEnsxZMmBbs1eOEnq
         lvKsWc56i+MaoNzWWmEDNwEOYmLchw+0dQ+VuOfOLbCU9geeFtrisyeXt6CEPvfxYKd1
         czot+O7WuIRHJSQswrrSiKeZH3OVS1C/dQnB6vMzpG0/0Zz664CqmbTIO7svnzckuxPi
         YFzyHUaE85sjSCmsDr4hK0azuaQesAmbZeEO06IXEflShhW0e7kV0CAY7kV1LIzh9lpk
         3rZkQs9cxzYKSS633TBreRHV1r1lvcUfRSApvw1ikzVXSwcphFfmPA1ffygk8kpWr2KZ
         qTmg==
X-Gm-Message-State: APjAAAWEsyLEaH7G+49w0t33Htip5Hx72U2EpppojVUKuzWv0nh9SLoj
        0Gommx0qINkXnLbANsXDvZQ=
X-Google-Smtp-Source: APXvYqzK6sgyXCnG5Uz/GrSVTUHD9LMf41xalET7RK+9Ru/R2DFNR9BmKxeezRH+MLP1gT8ibpfuCg==
X-Received: by 2002:a17:902:9a4c:: with SMTP id x12mr4520833plv.298.1559238855334;
        Thu, 30 May 2019 10:54:15 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:fb9c:664d:d2ad:c9b5? ([2620:15c:2c1:200:fb9c:664d:d2ad:c9b5])
        by smtp.gmail.com with ESMTPSA id n70sm3009774pjb.4.2019.05.30.10.54.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 10:54:13 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
 <ad0578b0-ce73-85ed-b67d-70c5d8176a23@acm.org>
 <461fe0cd-c5bc-a612-6013-7c002b92dcdc@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <740d2f33-004e-7a37-1f6e-cf29480439b1@acm.org>
Date:   Thu, 30 May 2019 10:54:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <461fe0cd-c5bc-a612-6013-7c002b92dcdc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/19 8:54 AM, Paolo Bonzini wrote:
> On 30/05/19 17:36, Bart Van Assche wrote:
>> On 5/30/19 4:28 AM, Paolo Bonzini wrote:
>>> +static const struct blk_mq_ops scsi_mq_ops_no_commit = {
>>> +    .get_budget    = scsi_mq_get_budget,
>>> +    .put_budget    = scsi_mq_put_budget,
>>> +    .queue_rq    = scsi_queue_rq,
>>> +    .complete    = scsi_softirq_done,
>>> +    .timeout    = scsi_timeout,
>>> +#ifdef CONFIG_BLK_DEBUG_FS
>>> +    .show_rq    = scsi_show_rq,
>>> +#endif
>>> +    .init_request    = scsi_mq_init_request,
>>> +    .exit_request    = scsi_mq_exit_request,
>>> +    .initialize_rq_fn = scsi_initialize_rq,
>>> +    .busy        = scsi_mq_lld_busy,
>>> +    .map_queues    = scsi_map_queues,
>>> +};
>>> +
>>> +static void scsi_commit_rqs(struct blk_mq_hw_ctx *hctx)
>>> +{
>>> +    struct request_queue *q = hctx->queue;
>>> +    struct scsi_device *sdev = q->queuedata;
>>> +    struct Scsi_Host *shost = sdev->host;
>>> +
>>> +    shost->hostt->commit_rqs(shost, hctx->queue_num);
>>> +}
>>> +
>>>   static const struct blk_mq_ops scsi_mq_ops = {
>>>       .get_budget    = scsi_mq_get_budget,
>>>       .put_budget    = scsi_mq_put_budget,
>>>       .queue_rq    = scsi_queue_rq,
>>> +    .commit_rqs    = scsi_commit_rqs,
>>>       .complete    = scsi_softirq_done,
>>>       .timeout    = scsi_timeout,
>>>   #ifdef CONFIG_BLK_DEBUG_FS
>>
>> Hi Paolo,
>>
>> Have you considered to modify the block layer such that a single
>> scsi_mq_ops structure can be used for all SCSI LLD types?
> 
> Yes, but I don't think it's possible to do it in a nice way.
> Any adjustment we make to the block layer to fit the SCSI subsystem's
> desires would make all other block drivers uglier, so I chose to confine
> the ugliness here.
> 
> The root issue is that the SCSI subsystem is unique in how it sits on
> top of the block layer; this is the famous "adapter" (or "midlayer",
> though that is confusing when talking about SCSI) design that Linux
> usually tries to avoid.

As far as I can see the only impact of defining an empty commit_rqs
callback on the queueing behavior is that blk_mq_make_request() will
queue requests for multiple hwqs on the plug list instead of requests
for a single hwq. The plug list is sorted by hwq before it is submitted
to a block driver. If that helps NVMe performance it should also help
SCSI performance. How about always setting commit_rqs = scsi_commit_rqs
in scsi_mq_ops?

Thanks,

Bart.

