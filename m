Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F39B61C8E
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 11:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbfGHJsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 05:48:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44943 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbfGHJsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 05:48:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so5118759wrf.11;
        Mon, 08 Jul 2019 02:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NwlWZnZ7zBN6lMDrY9iRaKbV18Be9yKKcDp04eaQZqw=;
        b=L4X9uWXbU6RiKrYoUg2tgRwaWORYDiSTVLOeYpeJuxAruwz0azPyvOk8Jf4yhJqizT
         Sjoag1bsd1lnxDMWoqWXLrdD3yVIUh57JZAPA2c3H3H2zbBYt8B67jd6Pel/2AgEa4gP
         UaPzoeGUom5LJOBnL8pK/c/SnqUrKVpurbOn9VAskieXCXaYvjvzLjXxB8RiP3Z+TCF2
         +S//IhKshMXkeWfHs9dFTv19u1RT3CyGreaY1P1dNUic3NzRB4JNQfiBJ+2VqzfRAsMr
         ppKkr0g9JXj/PxeiIUrvGdln+1TpbzM9iqSsIbUChjswX3i3/1qDjh4PNGHFEs0oVxrK
         0PxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NwlWZnZ7zBN6lMDrY9iRaKbV18Be9yKKcDp04eaQZqw=;
        b=EXHQ+bBHIbGMhQofgKY3URGs8vyMe7T5152Tt0f7vnrrin8aXb4Ca6e2QpZ7b0oHf3
         uODp1M5mHGFGob6HxziiEcZ7r+C1CsG1l1Y6tZkSyXvI1sYwOpvW4eBWN7hs21S5eXMB
         2JnEnVf4d6Qdr7U3BpTS13v8EWCuAVC5f9Jga3PxLyCvV78YUKf/e7ZqmbSh+lJQDw4F
         F5s/f5ZL1o3UgecaTTZf2XqyffBYfbFPraTPx7QnrAvL0H5NpTsH+T49loAkacY0K9Dw
         0TjWlJjora6uBqH5mAjRcMV/7mIAX/4qv4EVyBg9FVX6mwXAe0woswjM8eWjo+7KpXwn
         jy5Q==
X-Gm-Message-State: APjAAAWSECR/XzS8smlkSYFIvxBw7hSF1oxU53U8vwsYPEshKCgTZvJt
        F1ZTjDqoImPY9WU0f7xT2FSmJXemPFBFbM22L3o=
X-Google-Smtp-Source: APXvYqxE67dD1GsBy6jRCG+SGo9SeaPdmJ0+fghvBxDKCiPovhUbI/A/avBvpADnzJyDg0CyZ7K+xQiy1/iVQCXybjo=
X-Received: by 2002:a05:6000:1011:: with SMTP id a17mr18005281wrx.0.1562579286243;
 Mon, 08 Jul 2019 02:48:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190530112811.3066-1-pbonzini@redhat.com> <20190530112811.3066-3-pbonzini@redhat.com>
In-Reply-To: <20190530112811.3066-3-pbonzini@redhat.com>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Mon, 8 Jul 2019 17:47:54 +0800
Message-ID: <CACVXFVPE7vX1pEPH0G_C_eZW8eztdTEg8Xr=8+D=9-eVeMNZ_g@mail.gmail.com>
Subject: Re: [PATCH 2/2] virtio_scsi: implement request batching
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
> Adding the command and kicking the virtqueue so far was done one after
> another.  Make the kick optional, so that we can take into account SCMD_LAST.
> We also need a commit_rqs callback to kick the device if blk-mq aborts
> the submission before the last request is reached.
>
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 55 +++++++++++++++++++++++++++-----------
>  1 file changed, 40 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 8af01777d09c..918c811cea95 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -375,14 +375,7 @@ static void virtscsi_event_done(struct virtqueue *vq)
>         virtscsi_vq_done(vscsi, &vscsi->event_vq, virtscsi_complete_event);
>  };
>
> -/**
> - * virtscsi_add_cmd - add a virtio_scsi_cmd to a virtqueue
> - * @vq         : the struct virtqueue we're talking about
> - * @cmd                : command structure
> - * @req_size   : size of the request buffer
> - * @resp_size  : size of the response buffer
> - */
> -static int virtscsi_add_cmd(struct virtqueue *vq,
> +static int __virtscsi_add_cmd(struct virtqueue *vq,
>                             struct virtio_scsi_cmd *cmd,
>                             size_t req_size, size_t resp_size)
>  {
> @@ -427,17 +420,39 @@ static int virtscsi_add_cmd(struct virtqueue *vq,
>         return virtqueue_add_sgs(vq, sgs, out_num, in_num, cmd, GFP_ATOMIC);
>  }
>
> -static int virtscsi_kick_cmd(struct virtio_scsi_vq *vq,
> +static void virtscsi_kick_vq(struct virtio_scsi_vq *vq)
> +{
> +       bool needs_kick;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&vq->vq_lock, flags);
> +       needs_kick = virtqueue_kick_prepare(vq->vq);
> +       spin_unlock_irqrestore(&vq->vq_lock, flags);
> +
> +       if (needs_kick)
> +               virtqueue_notify(vq->vq);
> +}
> +
> +/**
> + * virtscsi_add_cmd - add a virtio_scsi_cmd to a virtqueue, optionally kick it
> + * @vq         : the struct virtqueue we're talking about
> + * @cmd                : command structure
> + * @req_size   : size of the request buffer
> + * @resp_size  : size of the response buffer
> + * @kick       : whether to kick the virtqueue immediately
> + */
> +static int virtscsi_add_cmd(struct virtio_scsi_vq *vq,
>                              struct virtio_scsi_cmd *cmd,
> -                            size_t req_size, size_t resp_size)
> +                            size_t req_size, size_t resp_size,
> +                            bool kick)
>  {
>         unsigned long flags;
>         int err;
>         bool needs_kick = false;
>
>         spin_lock_irqsave(&vq->vq_lock, flags);
> -       err = virtscsi_add_cmd(vq->vq, cmd, req_size, resp_size);
> -       if (!err)
> +       err = __virtscsi_add_cmd(vq->vq, cmd, req_size, resp_size);
> +       if (!err && kick)
>                 needs_kick = virtqueue_kick_prepare(vq->vq);
>
>         spin_unlock_irqrestore(&vq->vq_lock, flags);
> @@ -502,6 +517,7 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
>         struct virtio_scsi *vscsi = shost_priv(shost);
>         struct virtio_scsi_vq *req_vq = virtscsi_pick_vq_mq(vscsi, sc);
>         struct virtio_scsi_cmd *cmd = scsi_cmd_priv(sc);
> +       bool kick;
>         unsigned long flags;
>         int req_size;
>         int ret;
> @@ -531,7 +547,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
>                 req_size = sizeof(cmd->req.cmd);
>         }
>
> -       ret = virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd));
> +       kick = (sc->flags & SCMD_LAST) != 0;
> +       ret = virtscsi_add_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd), kick);
>         if (ret == -EIO) {
>                 cmd->resp.cmd.response = VIRTIO_SCSI_S_BAD_TARGET;
>                 spin_lock_irqsave(&req_vq->vq_lock, flags);
> @@ -549,8 +566,8 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
>         int ret = FAILED;
>
>         cmd->comp = &comp;
> -       if (virtscsi_kick_cmd(&vscsi->ctrl_vq, cmd,
> -                             sizeof cmd->req.tmf, sizeof cmd->resp.tmf) < 0)
> +       if (virtscsi_add_cmd(&vscsi->ctrl_vq, cmd,
> +                             sizeof cmd->req.tmf, sizeof cmd->resp.tmf, true) < 0)
>                 goto out;
>
>         wait_for_completion(&comp);
> @@ -664,6 +681,13 @@ static int virtscsi_map_queues(struct Scsi_Host *shost)
>         return blk_mq_virtio_map_queues(qmap, vscsi->vdev, 2);
>  }
>
> +static void virtscsi_commit_rqs(struct Scsi_Host *shost, u16 hwq)
> +{
> +       struct virtio_scsi *vscsi = shost_priv(shost);
> +
> +       virtscsi_kick_vq(&vscsi->req_vqs[hwq]);
> +}
> +
>  /*
>   * The host guarantees to respond to each command, although I/O
>   * latencies might be higher than on bare metal.  Reset the timer
> @@ -681,6 +705,7 @@ static struct scsi_host_template virtscsi_host_template = {
>         .this_id = -1,
>         .cmd_size = sizeof(struct virtio_scsi_cmd),
>         .queuecommand = virtscsi_queuecommand,
> +       .commit_rqs = virtscsi_commit_rqs,
>         .change_queue_depth = virtscsi_change_queue_depth,
>         .eh_abort_handler = virtscsi_abort,
>         .eh_device_reset_handler = virtscsi_device_reset,
> --
> 2.21.0
>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming Lei
