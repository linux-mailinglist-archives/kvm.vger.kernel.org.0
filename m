Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8777CA70B
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 13:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbjJPLxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 07:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbjJPLxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 07:53:04 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329B611D
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 04:52:56 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-323ef9a8b59so4286351f8f.3
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 04:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697457174; x=1698061974; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=StB8x9/9WBld/29xu+feCm7+MvUFzBzwwOhrr6h8fxQ=;
        b=TvvgpxrAODNkfqvRgxksFPsdhRsTeX5RzPV3FTQq2Bpht5X9EiTaZUT6RjeSTV5OpF
         bpNEBL5EIVgWDr00NfcO8yE8S3pjAPS8g7XLcusz6Yjf3Snph90Lp1g5Q4sCvPUYjSjY
         1U+GKcq2xBtv1XnUtQY31h3/w5B5Z5eylBrA8jLlXV9iPYk03ZqzpZjXnCoutYRXZFYD
         SYaPASplcuhiFjJMC7nIFOOc/XR9j6Lyjtd3YpvX7W8CstFeIR7mzz5JwWD81KVqbgx6
         a6oe69fREBNF5np22unxVK4ppQTZCWpEcc7ZhFttnTa6KKdy2JxGFB4vspm7Od/EMyqb
         XCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697457174; x=1698061974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=StB8x9/9WBld/29xu+feCm7+MvUFzBzwwOhrr6h8fxQ=;
        b=vJlPcYTV/wUvUGoxajeA0t/GHz0WRZGbdemR3Harza7NniJ1JvRo5E5b9I3LHwO6K0
         TXRbiCtXTB4kLGmueuf24h4Cv8WEPpryER8DpZogrIJBmsA3ZeIBeI092A6pxQcUdAQp
         Fp23t6plhZoWcjLjJl6sH0Bb94HsysyREDHsSP8SdqfBFN/tim7IykDHh7OzNRMXDoF3
         o+2uVhx/sEslXuZzwC8NWaLT/cCZOqZPIMJX3XbvDCM5jQhzI611nQX1Xpmj9NWP+lhD
         5YUHtQEdUcNFoSUjDdf2Dgnbv5NFPwVsjA0c/Btb9DVZirASfkw9As56FvCEEF94bmTA
         ja5w==
X-Gm-Message-State: AOJu0Yw3FXneWxzJdsjZFyCf09KAQsJeZsZSHOdSlLFPYfp8Rm8r4bAv
        TcnRrDWr1pHlD7e6Q0BpkEEHCQ==
X-Google-Smtp-Source: AGHT+IH94EQlZAAethDVX1SA9H6VGn1Ni33angysLvWJSd5hHNiusnayWV7uHHKJsg+CpuOmNRdTdQ==
X-Received: by 2002:a5d:44cd:0:b0:32d:885f:3f8d with SMTP id z13-20020a5d44cd000000b0032d885f3f8dmr10854951wrr.52.1697457174113;
        Mon, 16 Oct 2023 04:52:54 -0700 (PDT)
Received: from myrica ([2a02:c7c:7290:b00:fd32:2b31:6755:400c])
        by smtp.gmail.com with ESMTPSA id w18-20020a5d5452000000b00323330edbc7sm1244158wrv.20.2023.10.16.04.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 04:52:53 -0700 (PDT)
Date:   Mon, 16 Oct 2023 12:52:59 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Eduardo Bart <edub4rt@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org
Subject: Re: [PATCH kvmtool] virtio: Cancel and join threads when exiting
 devices
Message-ID: <20231016115259.GA835650@myrica>
References: <CABqCASLWAZ5aq27GuQftWsXSf7yLFCKwrJxWMUF-fiV7Bc4LUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABqCASLWAZ5aq27GuQftWsXSf7yLFCKwrJxWMUF-fiV7Bc4LUA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eduardo,

(Cc Will who maintains kvmtool)

On Wed, Oct 04, 2023 at 05:49:45PM -0300, Eduardo Bart wrote:
> I'm experiencing a segmentation fault in lkvm where it may crash after
> powering off a guest machine that uses a virtio network device.
> The crash is hard to reproduce, because looks like it only happens
> when the guest machine is powering off while extra virtio threads is
> doing some work,
> when it happens lkvm crashes in the function virtio_net_rx_thread
> while attempting to read invalid guest physical memory,
> because guest physical memory was unmapped.
> 
> I've isolated the problem and looks like when lkvm exits it unmaps the
> guest memory while virtio device extra threads may still be executing.
> I noticed most virtio devices are not executing pthread_cancel +
> pthread_join to synchronize extra threads when exiting,
> to make sure this happens I added explicit calls to the virtio device
> exit function to all virtio devices,
> which should cancel and join all threads before unmapping guest
> physical memory, fixing the crash for me.
> 
> Below I'm attaching a patch to fix the issue, feel free to apply or
> fix the issue some other way.
> 
> Signed-off-by: Eduardo Bart <edub4rt@gmail.com>

The patch doesn't apply for some reason, there seems to be whitespace
issues, tabs replaced by spaces.

Looks correct otherwise. vCPUs are stopped first, then virtio exit, and
memory is unmapped last. This also fixes runtime virtqueue reset for
virtio-balloon.

> 
> ---
>  include/kvm/virtio-9p.h |  1 +
>  virtio/9p.c             | 14 ++++++++++++++
>  virtio/balloon.c        | 11 +++++++++++
>  virtio/blk.c            |  1 +
>  virtio/console.c        |  3 +++
>  virtio/net.c            |  4 ++++
>  virtio/rng.c            |  8 ++++++++
>  7 files changed, 42 insertions(+)
> 
> diff --git a/include/kvm/virtio-9p.h b/include/kvm/virtio-9p.h
> index 1dffc95..09f7e46 100644
> --- a/include/kvm/virtio-9p.h
> +++ b/include/kvm/virtio-9p.h
> @@ -70,6 +70,7 @@ int virtio_9p_rootdir_parser(const struct option
> *opt, const char *arg, int unse
>  int virtio_9p_img_name_parser(const struct option *opt, const char
> *arg, int unset);
>  int virtio_9p__register(struct kvm *kvm, const char *root, const char
> *tag_name);
>  int virtio_9p__init(struct kvm *kvm);
> +int virtio_9p__exit(struct kvm *kvm);
>  int virtio_p9_pdu_readf(struct p9_pdu *pdu, const char *fmt, ...);
>  int virtio_p9_pdu_writef(struct p9_pdu *pdu, const char *fmt, ...);
> 
> diff --git a/virtio/9p.c b/virtio/9p.c
> index 513164e..f536d9e 100644
> --- a/virtio/9p.c
> +++ b/virtio/9p.c
> @@ -1562,6 +1562,20 @@ int virtio_9p__init(struct kvm *kvm)
>  }
>  virtio_dev_init(virtio_9p__init);
> 
> +int virtio_9p__exit(struct kvm *kvm)
> +{
> + struct p9_dev *p9dev, *tmp;
> +
> + list_for_each_entry_safe(p9dev, tmp, &devs, list) {
> + list_del(&p9dev->list);
> + p9dev->vdev.ops->exit(kvm, &p9dev->vdev);

Introducing a virtio_exit(kvm, vdev) helper would look neater. It could
also check if vdev.ops is set

> + free(p9dev);
> + }
> +
> + return 0;
> +}
> +virtio_dev_exit(virtio_9p__exit);
> +
>  int virtio_9p__register(struct kvm *kvm, const char *root, const char
> *tag_name)
>  {
>   struct p9_dev *p9dev;
> diff --git a/virtio/balloon.c b/virtio/balloon.c
> index 01d1982..a36e50e 100644
> --- a/virtio/balloon.c
> +++ b/virtio/balloon.c
> @@ -221,6 +221,13 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
>   return 0;
>  }
> 
> +static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
> +{
> + struct bln_dev *bdev = dev;
> +
> + thread_pool__cancel_job(&bdev->jobs[vq]);
> +}
> +
>  static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
>  {
>   struct bln_dev *bdev = dev;
> @@ -258,6 +265,7 @@ struct virtio_ops bln_dev_virtio_ops = {
>   .get_config_size = get_config_size,
>   .get_host_features = get_host_features,
>   .init_vq = init_vq,
> + .exit_vq = exit_vq,
>   .notify_vq = notify_vq,
>   .get_vq = get_vq,
>   .get_size_vq = get_size_vq,
> @@ -293,6 +301,9 @@ virtio_dev_init(virtio_bln__init);
> 
>  int virtio_bln__exit(struct kvm *kvm)
>  {
> + if (bdev.vdev.ops)
> + bdev.vdev.ops->exit(kvm, &bdev.vdev);
> +
>   return 0;
>  }
>  virtio_dev_exit(virtio_bln__exit);
> diff --git a/virtio/blk.c b/virtio/blk.c
> index a58c745..e34723a 100644
> --- a/virtio/blk.c
> +++ b/virtio/blk.c
> @@ -345,6 +345,7 @@ static int virtio_blk__init_one(struct kvm *kvm,
> struct disk_image *disk)
>  static int virtio_blk__exit_one(struct kvm *kvm, struct blk_dev *bdev)
>  {
>   list_del(&bdev->list);
> + bdev->vdev.ops->exit(kvm, &bdev->vdev);
>   free(bdev);
> 
>   return 0;
> diff --git a/virtio/console.c b/virtio/console.c
> index ebfbaf0..5a71bbc 100644
> --- a/virtio/console.c
> +++ b/virtio/console.c
> @@ -243,6 +243,9 @@ virtio_dev_init(virtio_console__init);
> 
>  int virtio_console__exit(struct kvm *kvm)
>  {
> + if (cdev.vdev.ops)
> + cdev.vdev.ops->exit(kvm, &cdev.vdev);
> +
>   return 0;
>  }
>  virtio_dev_exit(virtio_console__exit);
> diff --git a/virtio/net.c b/virtio/net.c
> index f09dd0a..dc6d89d 100644
> --- a/virtio/net.c
> +++ b/virtio/net.c
> @@ -969,10 +969,14 @@ int virtio_net__exit(struct kvm *kvm)
>   if (ndev->mode == NET_MODE_TAP &&
>       strcmp(params->downscript, "none"))
>   virtio_net_exec_script(params->downscript, ndev->tap_name);
> + if (ndev->mode != NET_MODE_TAP)
> + uip_exit(&ndev->info);

virtio_net_stop() might be nicer here

Thanks,
Jean

> 
>   list_del(&ndev->list);
> + ndev->vdev.ops->exit(kvm, &ndev->vdev);
>   free(ndev);
>   }
> +
>   return 0;
>  }
>  virtio_dev_exit(virtio_net__exit);
> diff --git a/virtio/rng.c b/virtio/rng.c
> index 6b36655..ebdb455 100644
> --- a/virtio/rng.c
> +++ b/virtio/rng.c
> @@ -122,6 +122,13 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
>   return 0;
>  }
> 
> +static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
> +{
> + struct rng_dev *rdev = dev;
> +
> + thread_pool__cancel_job(&rdev->jobs[vq].job_id);
> +}
> +
>  static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
>  {
>   struct rng_dev *rdev = dev;
> @@ -159,6 +166,7 @@ static struct virtio_ops rng_dev_virtio_ops = {
>   .get_config_size = get_config_size,
>   .get_host_features = get_host_features,
>   .init_vq = init_vq,
> + .exit_vq = exit_vq,
>   .notify_vq = notify_vq,
>   .get_vq = get_vq,
>   .get_size_vq = get_size_vq,
> -- 
> 2.42.0
