Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88C45A1CAB
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 00:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237117AbiHYWq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 18:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiHYWq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 18:46:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00C1C6529
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 15:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661467614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uqKD+aCTNkWDNnveoC2FpK22eYkx9sFAuDbWp9S4k98=;
        b=eie86jL6TZEAArsrHWcS/szTwbXIzaR3zpcu7beq02qXbG8eB2DNMTyKMuX0MIomKMcucH
        vqaoNpgOjKB6Z85X75TVdxaUiQilEEyB1cnwuw32BSY5FBZ/UjcK5w8JkT2JcyRplJgn5X
        OXgAT+hWVAc52ypLqlU4J+YUMrwPU34=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-HbuT-FbVPjibJrjuJHp9Xw-1; Thu, 25 Aug 2022 18:46:53 -0400
X-MC-Unique: HbuT-FbVPjibJrjuJHp9Xw-1
Received: by mail-io1-f71.google.com with SMTP id i14-20020a5d934e000000b006892db5bcd4so12189786ioo.22
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 15:46:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=uqKD+aCTNkWDNnveoC2FpK22eYkx9sFAuDbWp9S4k98=;
        b=HZLtmXPbb0uhF3H8meVap3u1mBJXdiGxCSUOxlpqBsDGm2HRgrp6m4DpLCfsVsdWyg
         mtgCjo4QuhhiveDEbMoCb9reZppijlmjbSlu3aDbDuOVRTB+uf0Ao1q4XlG4vIhO2xpB
         3cyuhkOFTQEb2t98tUyMMBbi1QXbY9ssq8BQwGUhjm70skCl/sYDjGKZhZ9vENb10QVy
         w0WFLexnz2AcqzVbPftkFVDhqoWzRYHvQH0xbnelO6Detb8llc6vLn/Q1AoRicSRGSnP
         N7NbebMCUWJY0DuYwcjXB0QnKMhrXPbc1QWms/baI+yPBiPogGywI9DD6DKb1EgYUDkb
         M7ug==
X-Gm-Message-State: ACgBeo3qrG40a1YGiJPbC+PB29Tr5CLkr0laN7XK0rOi5SHnYv4yAxeb
        0t6y0WsPfDdXSzCSrEGiNqkGDl8tDN0oLMOrC8K4lRjKE3BQqjH9tmxuvHNRXgvQ63LU0Bap7N5
        MHQL1jMqvuVbr
X-Received: by 2002:a05:6e02:194d:b0:2ea:373a:cbe4 with SMTP id x13-20020a056e02194d00b002ea373acbe4mr2812324ilu.127.1661467612893;
        Thu, 25 Aug 2022 15:46:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7G6uZF/Oy4Zo7uASD5B5uM03NtH89MksJbC4xi2D2xDl1qqgFc1KtFhyZCcfwXXDiYgEtQsQ==
X-Received: by 2002:a05:6e02:194d:b0:2ea:373a:cbe4 with SMTP id x13-20020a056e02194d00b002ea373acbe4mr2812309ilu.127.1661467612664;
        Thu, 25 Aug 2022 15:46:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g11-20020a056602072b00b00688509947e4sm226460iox.17.2022.08.25.15.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 15:46:52 -0700 (PDT)
Date:   Thu, 25 Aug 2022 16:46:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V4 vfio 05/10] vfio: Introduce the DMA logging feature
 support
Message-ID: <20220825164651.384bf099.alex.williamson@redhat.com>
In-Reply-To: <8342117f-87ab-d38e-6fcd-aaa947dbeaaf@oracle.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
        <20220815151109.180403-6-yishaih@nvidia.com>
        <20220825144944.237eb78f.alex.williamson@redhat.com>
        <8342117f-87ab-d38e-6fcd-aaa947dbeaaf@oracle.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Aug 2022 23:26:04 +0100
Joao Martins <joao.m.martins@oracle.com> wrote:

> On 8/25/22 21:49, Alex Williamson wrote:
> > On Mon, 15 Aug 2022 18:11:04 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:  
> >> +static int
> >> +vfio_ioctl_device_feature_logging_report(struct vfio_device *device,
> >> +					 u32 flags, void __user *arg,
> >> +					 size_t argsz)
> >> +{
> >> +	size_t minsz =
> >> +		offsetofend(struct vfio_device_feature_dma_logging_report,
> >> +			    bitmap);
> >> +	struct vfio_device_feature_dma_logging_report report;
> >> +	struct iova_bitmap_iter iter;
> >> +	int ret;
> >> +
> >> +	if (!device->log_ops)
> >> +		return -ENOTTY;
> >> +
> >> +	ret = vfio_check_feature(flags, argsz,
> >> +				 VFIO_DEVICE_FEATURE_GET,
> >> +				 sizeof(report));
> >> +	if (ret != 1)
> >> +		return ret;
> >> +
> >> +	if (copy_from_user(&report, arg, minsz))
> >> +		return -EFAULT;
> >> +
> >> +	if (report.page_size < PAGE_SIZE || !is_power_of_2(report.page_size))  
> > 
> > Why is PAGE_SIZE a factor here?  I'm under the impression that
> > iova_bitmap is intended to handle arbitrary page sizes.  Thanks,  
> 
> Arbritary page sizes ... which are powers of 2. We use page shift in iova bitmap.
> While it's not hard to lose this restriction (trading a shift over a slower mul)
> ... I am not sure it is worth supporting said use considering that there aren't
> non-powers of 2 page sizes right now?
> 
> The PAGE_SIZE restriction might be that it's supposed to be the lowest possible page_size.

Sorry, I was unclear.  Size relative to PAGE_SIZE was my only question,
not that we shouldn't require power of 2 sizes.  We're adding device
level dirty tracking, where the device page size granularity might be
4K on a host with a CPU 64K page size.  Maybe there's a use case for
that.  Given the flexibility claimed by the iova_bitmap support,
requiring reported page size less than system PAGE_SIZE seems
unjustified.  Thanks,

Alex

> >> +		return -EINVAL;
> >> +
> >> +	ret = iova_bitmap_iter_init(&iter, report.iova, report.length,
> >> +				    report.page_size,
> >> +				    u64_to_user_ptr(report.bitmap));
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	for (; !iova_bitmap_iter_done(&iter) && !ret;
> >> +	     ret = iova_bitmap_iter_advance(&iter)) {
> >> +		ret = device->log_ops->log_read_and_clear(device,
> >> +			iova_bitmap_iova(&iter),
> >> +			iova_bitmap_length(&iter), &iter.dirty);
> >> +		if (ret)
> >> +			break;
> >> +	}
> >> +
> >> +	iova_bitmap_iter_free(&iter);
> >> +	return ret;
> >> +}  
> >   
> 

