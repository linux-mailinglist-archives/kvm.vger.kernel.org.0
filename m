Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E99C4CA885
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 15:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243247AbiCBOvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 09:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243240AbiCBOvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 09:51:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4EDBA38D8D
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 06:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646232649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vyTbPbzLV6BhTjCf6yQIefb7DNZSD/rDYL7+DnSGw1A=;
        b=YYqd7wQfTqxMBqY12F83UMUrPJOz/ybqaQxZIb7MEh4AgSGFBsFu/hrQqPdiMEd+6YVMuf
        yn41kgr25iDbbphzz4whPnKYpinNkNo3UjmSrsL23+iK448L5/T0C/kOOvYpOFaF3SNqFo
        GHgZQXDqpgD8PAmYHTji5U1mbJ6FlJY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-5d5Vs-nINf-WLRt-_TYaUA-1; Wed, 02 Mar 2022 09:50:43 -0500
X-MC-Unique: 5d5Vs-nINf-WLRt-_TYaUA-1
Received: by mail-wr1-f69.google.com with SMTP id h11-20020a5d430b000000b001f01a35a86fso722677wrq.4
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 06:50:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vyTbPbzLV6BhTjCf6yQIefb7DNZSD/rDYL7+DnSGw1A=;
        b=8A8jKun3wz2znRsaDf270jlKAxXKChwy8olkzx0razWdcnHCOG8y2FR7nei/F/RzoR
         NpakiDeKXaSYSjfwPh9eDERhOQz6Vi17DZev0PhrNXypxFqFAef/oV74i0d25vLyR7Iv
         TP+CHoWmBOaD9aqVolSaJUC+qa79LoDtz/7TUwecr3Ct+zHT4KqHVE9KkiAYQbNDUj2z
         ilE6OzvW69iGDC4Wxs4CcO//+AvdHLrtREOdoUmRa+E+YvYaWVjMWonT1KD2l5+bmVdU
         P0st9m0O6HBGPTd+VUOIY7NCEtnqeVCZVg5ey+pgkfNNJLiSSi3aUnGW4QwKJjx9wy0w
         kw4Q==
X-Gm-Message-State: AOAM531LroLaHDqKRUWSfC3f/7oRtC/FTzmcL2RgNs0r8HlxBm8loNil
        mTrATrQ2opr6H1Gk8si7/VAize5SvXli6J0JcrdhYdy/X0S61QQ7KvMYfl5upI5Usjq0VCEHPzD
        /z4G/4KdUWoUG
X-Received: by 2002:adf:f550:0:b0:1f0:2381:ac2c with SMTP id j16-20020adff550000000b001f02381ac2cmr4323639wrp.189.1646232642006;
        Wed, 02 Mar 2022 06:50:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzQNu/fXS905mfblMrRA5G2rPob+EQ5Bu1JcHzO8Z63AfxXQlVwQA2iUhIru+dm9U5yRai4qA==
X-Received: by 2002:adf:f550:0:b0:1f0:2381:ac2c with SMTP id j16-20020adff550000000b001f02381ac2cmr4323627wrp.189.1646232641759;
        Wed, 02 Mar 2022 06:50:41 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id k19-20020adfd233000000b001f0358e47bdsm1971249wrh.50.2022.03.02.06.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 06:50:41 -0800 (PST)
Date:   Wed, 2 Mar 2022 09:50:38 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220302094946-mutt-send-email-mst@kernel.org>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302093446.pjq3djoqi434ehz4@sgarzare-redhat>
 <20220302083413-mutt-send-email-mst@kernel.org>
 <20220302141121.sohhkhtiiaydlv47@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302141121.sohhkhtiiaydlv47@sgarzare-redhat>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 03:11:21PM +0100, Stefano Garzarella wrote:
> On Wed, Mar 02, 2022 at 08:35:08AM -0500, Michael S. Tsirkin wrote:
> > On Wed, Mar 02, 2022 at 10:34:46AM +0100, Stefano Garzarella wrote:
> > > On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > to vhost_get_vq_desc().  All we have to do is take the same lock
> > > > during virtqueue clean-up and we mitigate the reported issues.
> > > >
> > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > 
> > > This issue is similar to [1] that should be already fixed upstream by [2].
> > > 
> > > However I think this patch would have prevented some issues, because
> > > vhost_vq_reset() sets vq->private to NULL, preventing the worker from
> > > running.
> > > 
> > > Anyway I think that when we enter in vhost_dev_cleanup() the worker should
> > > be already stopped, so it shouldn't be necessary to take the mutex. But in
> > > order to prevent future issues maybe it's better to take them, so:
> > > 
> > > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> > > 
> > > [1]
> > > https://syzkaller.appspot.com/bug?id=993d8b5e64393ed9e6a70f9ae4de0119c605a822
> > > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9
> > 
> > 
> > Right. I want to queue this but I would like to get a warning
> > so we can detect issues like [2] before they cause more issues.
> 
> I agree, what about moving the warning that we already have higher up, right
> at the beginning of the function?
> 
> I mean something like this:
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..1721ff3f18c0 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -692,6 +692,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  {
>         int i;
> +       WARN_ON(!llist_empty(&dev->work_list));
> +
>         for (i = 0; i < dev->nvqs; ++i) {
>                 if (dev->vqs[i]->error_ctx)
>                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
> @@ -712,7 +714,6 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>         dev->iotlb = NULL;
>         vhost_clear_msg(dev);
>         wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
> -       WARN_ON(!llist_empty(&dev->work_list));
>         if (dev->worker) {
>                 kthread_stop(dev->worker);
>                 dev->worker = NULL;
> 

Hmm I'm not sure why it matters.

> And maybe we can also check vq->private and warn in the loop, because the
> work_list may be empty if the device is doing nothing.
> 
> Thanks,
> Stefano

