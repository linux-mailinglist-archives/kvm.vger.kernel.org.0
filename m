Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5FC62207C
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 00:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiKHXx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 18:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiKHXxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 18:53:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E970A5E9C9
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 15:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667951576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oVnbsMQuohpGlkVlpHHCbpF7rU92xLtMbImV8X2HL+o=;
        b=fXO982iQRwa6FsIDHdm1IjIRDPQsIBlawUMVIc0tlGC/7pX6ydB24/oH0EUPsq2i4sKdnx
        MpoJj2kx0QGuXnBybEZVcp4oc110XrC1/4tDZ/xKFOpzoKvi4v37mb+clfVqT5MEHSIMTA
        SMY0GhSHBbGtjnlg2mn3NnxQDUDiXeI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-119-AmtkfStqM2SqUDkFYIq6OQ-1; Tue, 08 Nov 2022 18:52:55 -0500
X-MC-Unique: AmtkfStqM2SqUDkFYIq6OQ-1
Received: by mail-io1-f71.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so10178334ioz.8
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 15:52:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVnbsMQuohpGlkVlpHHCbpF7rU92xLtMbImV8X2HL+o=;
        b=Zpx4tmpcjDCMnZRaZ3aZbWRd2o6amnOyvnbMG+eCiG6a2fzY8hfN239M+y5msujoyu
         6YzC6LAU0SYeoLHVFkgtV2x06wG5WZrPuVwXpv0w7d9iv0eUAN09tjbMF5Z9pwtJwD/t
         f9KIXW6YF22oIcfhiAvE7h1XujwI8scZgdnfpvNzrzuaq/htyPp6VSLeG+bUruPond31
         HS1DMZOqWg3IkWIdLOu6OeXP/0yop4Uj+WgwWm2I9v9Dldz5TWyhOiCb2MjC8D+W7QTD
         et+QYaBwvxGZ4ByX/nWjF1VfRlAJGeTCka42K8yQRbshYMELzItPpJOSaA1sjnwGs9oN
         o6pQ==
X-Gm-Message-State: ACrzQf3WeaLmLCaijaYhmnG1m/6a+iyinmdsoCxjdK5/H543OkUpriX+
        Tcj1tYgQqNHPUt6FsgvCIs8LpNR4Y+iZTJOisbxdqwKMSGwWvhuXe7qB/+8lZzYwTyFHoKwtd46
        RUyVrCHe6233A
X-Received: by 2002:a05:6e02:530:b0:2f9:a951:6480 with SMTP id h16-20020a056e02053000b002f9a9516480mr1277414ils.117.1667951574798;
        Tue, 08 Nov 2022 15:52:54 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7vRUkqb0kg42RpK2zEoARRgBQQ2mRJzftxKggGUR7Q7Ewjo44eYHhhSjlxF4k/Q+gKSKTq3A==
X-Received: by 2002:a05:6e02:530:b0:2f9:a951:6480 with SMTP id h16-20020a056e02053000b002f9a9516480mr1277410ils.117.1667951574531;
        Tue, 08 Nov 2022 15:52:54 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p16-20020a056e02105000b002f966e3900bsm4231379ilj.80.2022.11.08.15.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 15:52:54 -0800 (PST)
Date:   Tue, 8 Nov 2022 16:52:52 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Anthony DeRossi <ajderossi@gmail.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: Re: [PATCH v5 2/3] vfio: Export the device set open count
Message-ID: <20221108165252.4b4dfeb2.alex.williamson@redhat.com>
In-Reply-To: <20221105224458.8180-3-ajderossi@gmail.com>
References: <20221105224458.8180-1-ajderossi@gmail.com>
        <20221105224458.8180-3-ajderossi@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat,  5 Nov 2022 15:44:57 -0700
Anthony DeRossi <ajderossi@gmail.com> wrote:

> The open count of a device set is the sum of the open counts of all
> devices in the set. Drivers can use this value to determine whether
> shared resources are in use without tracking them manually or accessing
> the private open_count in vfio_device.
> 
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
> ---
>  drivers/vfio/vfio_main.c | 11 +++++++++++
>  include/linux/vfio.h     |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 9a4af880e941..ab34faabcebb 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -125,6 +125,17 @@ static void vfio_release_device_set(struct vfio_device *device)
>  	xa_unlock(&vfio_device_set_xa);
>  }
>  
> +unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set)
> +{
> +	struct vfio_device *cur;
> +	unsigned int open_count = 0;

This can only be called while holding the dev_set->lock, so we should
have an assert here:

	lockdep_assert_held(&dev_set->lock);

The series looks ok to me otherwise, hopefully we'll get some
additional reviews.  Thanks,

Alex

> +
> +	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> +		open_count += cur->open_count;
> +	return open_count;
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_set_open_count);
> +
>  /*
>   * Group objects - create, release, get, put, search
>   */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e7cebeb875dd..fdd393f70b19 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -189,6 +189,7 @@ int vfio_register_emulated_iommu_dev(struct vfio_device *device);
>  void vfio_unregister_group_dev(struct vfio_device *device);
>  
>  int vfio_assign_device_set(struct vfio_device *device, void *set_id);
> +unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
>  
>  int vfio_mig_get_next_state(struct vfio_device *device,
>  			    enum vfio_device_mig_state cur_fsm,

