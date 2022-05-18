Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5A652C1D1
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 20:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241155AbiERRv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241164AbiERRv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:51:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0B9C344C4
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652896283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uJ+xSRnSFvEGswaWNolRShdcOC68wGWylvI087e+KjY=;
        b=OZvwerDFGv2yJWtXJVWvcHnBdDP9of3jVRVgwVV5ztdUNE0kB4olp3ER+SHJ8VSAXwHtiK
        xayF/ggMsPS3kZ1CxOvUyZDf8GBLsEw+X0HvOcqV05qQVLij3xblvJ4p/P1dg+kkAlv5JB
        ILkIYxYtsVdjtI0YqO14M6dUSVJCPsg=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-_j9VXD3XOFyFStSdMSSokg-1; Wed, 18 May 2022 13:51:21 -0400
X-MC-Unique: _j9VXD3XOFyFStSdMSSokg-1
Received: by mail-il1-f200.google.com with SMTP id x1-20020a056e020f0100b002c98fce9c13so1689283ilj.3
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uJ+xSRnSFvEGswaWNolRShdcOC68wGWylvI087e+KjY=;
        b=KbDmjUYk/v1S5Rmdbdtj5owxSvm5z4W7lBo0HnXOgWlMkRoyA9MvBESoR2KE59Vll4
         C2MPJS7eBvaAXfP4lxyqXdDOYwPaCzFHUwESr+yycDsZtQoRaJO/84N9+hYryUG+wdYO
         +7m3xbrob0DlH6yCdxlzRQfaUyR0xk8ET9AIXdgc1YmI5zXXK3/f7OP/YjiB5s1od75Q
         yNvyKhnRjZDHig/sHV2XYmsEQCEzxnk98CI3dokddTQs0ZzJ27DFrlOjRMe78lW5nCop
         pxHpA8PcjNG9g+FeBk/RAWlLKSYLg3TPWzTUEYnHVilNTKCYg4naGTII1aRhj/PXGCHf
         UGKg==
X-Gm-Message-State: AOAM533smI1W9CpDAylijxQauX6BD+CGVriQjjVxw4YMtssmlJPuGGBO
        BDal8xEZx4ihjm0qvb/pKs/+myMVnBTeiT4VE0PMHmFn1tpi4UXC0fwc1IiBvQHo2ZoQNOWAsAN
        aJT01k06nieQ7
X-Received: by 2002:a05:6638:14d3:b0:32b:66f8:75a7 with SMTP id l19-20020a05663814d300b0032b66f875a7mr404980jak.114.1652896281092;
        Wed, 18 May 2022 10:51:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb4BOk5OcdiFkqhrazR4KqwiZOKrgrLN0MLNaJZAn1o52qCQjbcEGjldKQvBXAMqZP6cTqlQ==
X-Received: by 2002:a05:6638:14d3:b0:32b:66f8:75a7 with SMTP id l19-20020a05663814d300b0032b66f875a7mr404968jak.114.1652896280897;
        Wed, 18 May 2022 10:51:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o4-20020a02b804000000b0032e529ace22sm21448jam.174.2022.05.18.10.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 10:51:20 -0700 (PDT)
Date:   Wed, 18 May 2022 11:51:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/uapi/linux/vfio.h: Fix trivial typo - _IORW
 should be _IOWR instead
Message-ID: <20220518115119.2e618c39.alex.williamson@redhat.com>
In-Reply-To: <20220516101202.88373-1-thuth@redhat.com>
References: <20220516101202.88373-1-thuth@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 May 2022 12:12:02 +0200
Thomas Huth <thuth@redhat.com> wrote:

> There is no macro called _IORW, so use _IOWR in the comment instead.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  include/uapi/linux/vfio.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index fea86061b44e..733a1cddde30 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -643,7 +643,7 @@ enum {
>  };
>  
>  /**
> - * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IORW(VFIO_TYPE, VFIO_BASE + 12,
> + * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 12,
>   *					      struct vfio_pci_hot_reset_info)
>   *
>   * Return: 0 on success, -errno on failure:
> @@ -770,7 +770,7 @@ struct vfio_device_ioeventfd {
>  #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
>  
>  /**
> - * VFIO_DEVICE_FEATURE - _IORW(VFIO_TYPE, VFIO_BASE + 17,
> + * VFIO_DEVICE_FEATURE - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
>   *			       struct vfio_device_feature)
>   *
>   * Get, set, or probe feature data of the device.  The feature is selected

Applied to vfio next branch for v5.19.  Thanks!

Alex

