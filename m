Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3FE2306F8
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 05:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfEaD2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 23:28:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46841 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfEaD2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 23:28:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so226082wrw.13;
        Thu, 30 May 2019 20:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cdoYxYQXllz6fT2zV23F9oA4lywNBkDt8+j3yf5Nll4=;
        b=GrvkN6pr6W34zjzkdaAI+fJ7LQwQIYEEkeIxXRy9sk+35SIx9ySeflmUxcvIt3lZT1
         Gr52S1zdOY5KvgANjNLmCCDjrFrzMBJTt2p8y4sYgjxSvf6AQPaU8815u61Sso/+gh93
         uI6hyLDYjN2fyZ9N+aEy+KjILLPrKc8WPFGLfy7lPfvo4n7RmjIIYeGkO0NZ+S8zZp9G
         /uN2mOC3T1ur1EJUqg7s3HhQ7Vhg0BA4vq1ozRDdt3ZxbADy6oP5UkLuM1B/i3E8/cN5
         cs69ZEeaDbozCcDo+ZbKBDJRMQC0b2l5dzqBKnEMI4XGHoamuiDfw2V1oHnIY18qw93a
         3oxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cdoYxYQXllz6fT2zV23F9oA4lywNBkDt8+j3yf5Nll4=;
        b=jOGkBuHwsydRrwsNlbmofwQDH5povdecuqozIoU3tTqTmSB4+E1dpcmFmCFmkbfeG3
         aOM6lAElQFQBpqPRgb+mD9+9dPbBZKlrVZqqTPqV0xQt7agJ0pBhYlJR9AYFjU6wRO+Q
         LlN+DjQvg+NZwhpO7vkO3z9lpA+8y5nyN8WbmGbFuaO7dPOSnFRjohj0D8GMmZB1iaT3
         yZyIe2iLhpfNxcUV8jlLw1LxnT2AV88ukdHZrGg0pLsFH+xd1/5wWiznEt4IwiGqwqiS
         QX/tQINuWofIsuKE6VoCkaMuC1EWlQgISjb4aQS14SZy7yqerI9oB03x7OJ69aOiitHS
         Sy/Q==
X-Gm-Message-State: APjAAAWEfBMtpMg8DZWGNFmUuqAXiXXdMAwY95vRLvJschNpYMtkO2Ps
        sJks5+g5PERTJUmrpH666Vdoh7k6lsxpJYMY8aI=
X-Google-Smtp-Source: APXvYqzL5LExQSerZyFlXgXDv4tTzhO6UGwA+xmIbrT/jan5FG8C7J7iIe1JE7NeuDx/5WlgPUTRDBjq9AvQqqFjj7o=
X-Received: by 2002:a5d:68cd:: with SMTP id p13mr4703190wrw.0.1559273286083;
 Thu, 30 May 2019 20:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190530112811.3066-1-pbonzini@redhat.com> <20190530112811.3066-2-pbonzini@redhat.com>
In-Reply-To: <20190530112811.3066-2-pbonzini@redhat.com>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Fri, 31 May 2019 11:27:54 +0800
Message-ID: <CACVXFVP-B7uKUGn75rZdu0e4QxUOsSqv8FL0vY2ubmuucvxqjQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM General <kvm@vger.kernel.org>, jejb@linux.ibm.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 30, 2019 at 7:28 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> This allows a list of requests to be issued, with the LLD only writing
> the hardware doorbell when necessary, after the last request was prepared.
> This is more efficient if we have lists of requests to issue, particularly
> on virtualized hardware, where writing the doorbell is more expensive than
> on real hardware.
>
> The use case for this is plugged IO, where blk-mq flushes a batch of
> requests all at once.
>
> The API is the same as for blk-mq, just with blk-mq concepts tweaked to
> fit the SCSI subsystem API: the "last" flag in blk_mq_queue_data becomes
> a flag in scsi_cmnd, while the queue_num in the commit_rqs callback is
> extracted from the hctx and passed as a parameter.
>
> The only complication is that blk-mq uses different plugging heuristics
> depending on whether commit_rqs is present or not.  So we have two
> different sets of blk_mq_ops and pick one depending on whether the
> scsi_host template uses commit_rqs or not.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c  | 37 ++++++++++++++++++++++++++++++++++---
>  include/scsi/scsi_cmnd.h |  1 +
>  include/scsi/scsi_host.h | 16 ++++++++++++++--
>  3 files changed, 49 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 601b9f1de267..eb4e67d02bfe 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1673,10 +1673,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>                 blk_mq_start_request(req);
>         }
>
> +       cmd->flags &= SCMD_PRESERVED_FLAGS;
>         if (sdev->simple_tags)
>                 cmd->flags |= SCMD_TAGGED;
> -       else
> -               cmd->flags &= ~SCMD_TAGGED;
> +       if (bd->last)
> +               cmd->flags |= SCMD_LAST;
>
>         scsi_init_cmd_errh(cmd);
>         cmd->scsi_done = scsi_mq_done;
> @@ -1807,10 +1808,37 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>  }
>  EXPORT_SYMBOL_GPL(__scsi_init_queue);
>
> +static const struct blk_mq_ops scsi_mq_ops_no_commit = {
> +       .get_budget     = scsi_mq_get_budget,
> +       .put_budget     = scsi_mq_put_budget,
> +       .queue_rq       = scsi_queue_rq,
> +       .complete       = scsi_softirq_done,
> +       .timeout        = scsi_timeout,
> +#ifdef CONFIG_BLK_DEBUG_FS
> +       .show_rq        = scsi_show_rq,
> +#endif
> +       .init_request   = scsi_mq_init_request,
> +       .exit_request   = scsi_mq_exit_request,
> +       .initialize_rq_fn = scsi_initialize_rq,
> +       .busy           = scsi_mq_lld_busy,
> +       .map_queues     = scsi_map_queues,
> +};
> +
> +
> +static void scsi_commit_rqs(struct blk_mq_hw_ctx *hctx)
> +{
> +       struct request_queue *q = hctx->queue;
> +       struct scsi_device *sdev = q->queuedata;
> +       struct Scsi_Host *shost = sdev->host;
> +
> +       shost->hostt->commit_rqs(shost, hctx->queue_num);
> +}

It should be fine to implement scsi_commit_rqs() as:

 if (shost->hostt->commit_rqs)
       shost->hostt->commit_rqs(shost, hctx->queue_num);

then scsi_mq_ops_no_commit can be saved.

Because .commit_rqs() is only called when BLK_STS_*_RESOURCE is
returned from scsi_queue_rq(), at that time shost->hostt->commit_rqs should
have been hit from cache given .queuecommand is called via
host->hostt->queuecommand.

Not mention BLK_STS_*_RESOURCE is just often returned for small queue depth
device.

Thanks,
Ming Lei
