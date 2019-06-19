Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF48E4B635
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 12:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbfFSKcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 06:32:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39179 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfFSKcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 06:32:03 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so1247982wma.4
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2019 03:32:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DJZLFd0c94DNMXPW5hr0a4XsSq32KXr9fHp7tjVQYOI=;
        b=QEGqB6/cmx3QyAycXeBbJ1s2452+DEf41ielZ/iVhrjfsGVERxNJqp60nQegodWYGt
         KNt8pskKb1xeSk2V7Y48OuEd7181EWIBu+e1lPZ4Ytb3D/eX9Ror7i3o4gNmi6GjgpA/
         9A8tdgQJWE+8JEBy28khUu/Dw/BNrM0C/GF4j3l53kx2eCX4tXXVdLFgIhBv6L1YnG3V
         VOk/HGNtOOjqthfAobviJFrQVBfAczl8Qvr633ePmsRHWsjSR+6nHhsScJfb9/HXhXhH
         xOXJ6LIPEUAaQAK/wCyuJaVEWx8vmoegTV7thavQCxhgd1fAO0TmwUtitlXsm5z6c6gk
         2H8A==
X-Gm-Message-State: APjAAAXIMLJx8R5iDLfpozVY3iHmFosSdDAuoe629VpSEN1RMiX9Il6F
        MZ0g4uxY+vQ6bZGnf08BqfJT7A==
X-Google-Smtp-Source: APXvYqztQsarVOnhB1yn83G7nO8rSTu5dtmeGmfn81Fkc/B/fzXj77GL4jJHvj+ldJrIJDkfNiY3wQ==
X-Received: by 2002:a1c:2c41:: with SMTP id s62mr7728299wms.8.1560940320046;
        Wed, 19 Jun 2019 03:32:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51c0:d03f:68e:1f6d? ([2001:b07:6468:f312:51c0:d03f:68e:1f6d])
        by smtp.gmail.com with ESMTPSA id s8sm23922522wra.55.2019.06.19.03.31.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 03:31:58 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
To:     Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
 <760164a0-589d-d9fa-fb63-79b5e0899c00@suse.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aaa344bf-af29-0485-4e83-5442331a2c9c@redhat.com>
Date:   Wed, 19 Jun 2019 12:31:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <760164a0-589d-d9fa-fb63-79b5e0899c00@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/19 10:11, Hannes Reinecke wrote:
> On 5/30/19 1:28 PM, Paolo Bonzini wrote:
>> This allows a list of requests to be issued, with the LLD only writing
>> the hardware doorbell when necessary, after the last request was prepared.
>> This is more efficient if we have lists of requests to issue, particularly
>> on virtualized hardware, where writing the doorbell is more expensive than
>> on real hardware.
>>
>> The use case for this is plugged IO, where blk-mq flushes a batch of
>> requests all at once.
>>
>> The API is the same as for blk-mq, just with blk-mq concepts tweaked to
>> fit the SCSI subsystem API: the "last" flag in blk_mq_queue_data becomes
>> a flag in scsi_cmnd, while the queue_num in the commit_rqs callback is
>> extracted from the hctx and passed as a parameter.
>>
>> The only complication is that blk-mq uses different plugging heuristics
>> depending on whether commit_rqs is present or not.  So we have two
>> different sets of blk_mq_ops and pick one depending on whether the
>> scsi_host template uses commit_rqs or not.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  drivers/scsi/scsi_lib.c  | 37 ++++++++++++++++++++++++++++++++++---
>>  include/scsi/scsi_cmnd.h |  1 +
>>  include/scsi/scsi_host.h | 16 ++++++++++++++--
>>  3 files changed, 49 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 601b9f1de267..eb4e67d02bfe 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1673,10 +1673,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>>  		blk_mq_start_request(req);
>>  	}
>>  
>> +	cmd->flags &= SCMD_PRESERVED_FLAGS;
>>  	if (sdev->simple_tags)
>>  		cmd->flags |= SCMD_TAGGED;
>> -	else
>> -		cmd->flags &= ~SCMD_TAGGED;
>> +	if (bd->last)
>> +		cmd->flags |= SCMD_LAST;
>>  
>>  	scsi_init_cmd_errh(cmd);
>>  	cmd->scsi_done = scsi_mq_done;
>> @@ -1807,10 +1808,37 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>>  }
>>  EXPORT_SYMBOL_GPL(__scsi_init_queue);
>>  
>> +static const struct blk_mq_ops scsi_mq_ops_no_commit = {
>> +	.get_budget	= scsi_mq_get_budget,
>> +	.put_budget	= scsi_mq_put_budget,
>> +	.queue_rq	= scsi_queue_rq,
>> +	.complete	= scsi_softirq_done,
>> +	.timeout	= scsi_timeout,
>> +#ifdef CONFIG_BLK_DEBUG_FS
>> +	.show_rq	= scsi_show_rq,
>> +#endif
>> +	.init_request	= scsi_mq_init_request,
>> +	.exit_request	= scsi_mq_exit_request,
>> +	.initialize_rq_fn = scsi_initialize_rq,
>> +	.busy		= scsi_mq_lld_busy,
>> +	.map_queues	= scsi_map_queues,
>> +};
>> +
>> +
>> +static void scsi_commit_rqs(struct blk_mq_hw_ctx *hctx)
>> +{
>> +	struct request_queue *q = hctx->queue;
>> +	struct scsi_device *sdev = q->queuedata;
>> +	struct Scsi_Host *shost = sdev->host;
>> +
>> +	shost->hostt->commit_rqs(shost, hctx->queue_num);
>> +}
>> +
>>  static const struct blk_mq_ops scsi_mq_ops = {
>>  	.get_budget	= scsi_mq_get_budget,
>>  	.put_budget	= scsi_mq_put_budget,
>>  	.queue_rq	= scsi_queue_rq,
>> +	.commit_rqs	= scsi_commit_rqs,
>>  	.complete	= scsi_softirq_done,
>>  	.timeout	= scsi_timeout,
>>  #ifdef CONFIG_BLK_DEBUG_FS
>> @@ -1845,7 +1873,10 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>>  		cmd_size += sizeof(struct scsi_data_buffer) + sgl_size;
>>  
>>  	memset(&shost->tag_set, 0, sizeof(shost->tag_set));
>> -	shost->tag_set.ops = &scsi_mq_ops;
>> +	if (shost->hostt->commit_rqs)
>> +		shost->tag_set.ops = &scsi_mq_ops;
>> +	else
>> +		shost->tag_set.ops = &scsi_mq_ops_no_commit;
>>  	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
>>  	shost->tag_set.queue_depth = shost->can_queue;
>>  	shost->tag_set.cmd_size = cmd_size;
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index 76ed5e4acd38..91bd749a02f7 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
>> @@ -57,6 +57,7 @@ struct scsi_pointer {
>>  #define SCMD_TAGGED		(1 << 0)
>>  #define SCMD_UNCHECKED_ISA_DMA	(1 << 1)
>>  #define SCMD_INITIALIZED	(1 << 2)
>> +#define SCMD_LAST		(1 << 3)
>>  /* flags preserved across unprep / reprep */
>>  #define SCMD_PRESERVED_FLAGS	(SCMD_UNCHECKED_ISA_DMA | SCMD_INITIALIZED)
>>  
>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index 2b539a1b3f62..28f1c9177cd2 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -80,8 +80,10 @@ struct scsi_host_template {
>>  	 * command block to the LLDD.  When the driver finished
>>  	 * processing the command the done callback is invoked.
>>  	 *
>> -	 * If queuecommand returns 0, then the HBA has accepted the
>> -	 * command.  The done() function must be called on the command
>> +	 * If queuecommand returns 0, then the driver has accepted the
>> +	 * command.  It must also push it to the HBA if the scsi_cmnd
>> +	 * flag SCMD_LAST is set, or if the driver does not implement
>> +	 * commit_rqs.  The done() function must be called on the command
>>  	 * when the driver has finished with it. (you may call done on the
>>  	 * command before queuecommand returns, but in this case you
>>  	 * *must* return 0 from queuecommand).
>> @@ -109,6 +111,16 @@ struct scsi_host_template {
>>  	 */
>>  	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
>>  
>> +	/*
>> +	 * The commit_rqs function is used to trigger a hardware
>> +	 * doorbell after some requests have been queued with
>> +	 * queuecommand, when an error is encountered before sending
>> +	 * the request with SCMD_LAST set.
>> +	 *
>> +	 * STATUS: OPTIONAL
>> +	 */
>> +	void (*commit_rqs)(struct Scsi_Host *, u16);
>> +
>>  	/*
>>  	 * This is an error handling strategy routine.  You don't need to
>>  	 * define one of these if you don't want to - there is a default
>>
> I'm a bit unsure if 'bd->last' is always set; it's quite obvious that
> it's present if set, but what about requests with 'bd->last == false' ?
> Is there a guarantee that they will _always_ be followed with a request
> with bd->last == true?
> And if so, is there a guarantee that this request is part of the same batch?

It's complicated.  A request with bd->last == false _will_ always be
followed by a request with bd->last == true in the same batch.  However,
due to e.g. errors it may be possible that the last request is not sent.
 In that case, the block layer sends commit_rqs, as documented in the
comment above, to flush the requests that have been sent already.

So, a driver that obeys bd->last (or SCMD_LAST) but does not implement
commit_rqs is bound to have bugs, which is why this patch was not split
further.

Makes sense?

Paolo

> Aside from it: I think it's a good idea to match the '->last' setting
> onto the SCMD_LAST flag; I would even go so far and make this an
> independent patch.

> Once to above points are cleared, that is.
> 
> But if that one is in, why do we need to have the separate 'commit_rqs'
> callback?
> Can't we let the driver decide to issue a doorbell kick (or whatever the
> driver decides to do there)?
> If we ensure that the SCMD_LAST flag is always set for the end of a
> batch (even if this batch consists only of one request), the driver
> simply can evaluate the flag and do its actions.
> Why do we need a new callback here?
> 
> Cheers,
> 
> Hannes
> 

