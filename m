Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0FB6BC03A
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 23:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbjCOWzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 18:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbjCOWzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 18:55:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04EE22787
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 15:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678920801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PmBI1DpvKaVXYXtA6gtpu5ckoov61ccQSRAX+aljBe0=;
        b=UHzgbVPcVB/geUuo6e2MCgogV9jjNhRDW1tqSIXihzmaWfKgfeUEfYYYNqOUBtzK5hqvXs
        8f2454ixsxiQ16TYcl1EzNBSODyqACVhAD58LDffbq1mBN3Z8CG0foERkNhTPscCQLNlCm
        yakFp5IgsAU2mB+qETW76jCfT/V0s8Q=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-sVRHDUHoO6mlnh19GjAseA-1; Wed, 15 Mar 2023 18:53:19 -0400
X-MC-Unique: sVRHDUHoO6mlnh19GjAseA-1
Received: by mail-il1-f198.google.com with SMTP id j24-20020a056e02219800b00322f108a4cfso29361ila.2
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 15:53:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678920794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PmBI1DpvKaVXYXtA6gtpu5ckoov61ccQSRAX+aljBe0=;
        b=kHtXTJRzeEyFbXctMOhz0iikf12Zhc0PT0iHq7kD/aLzybDBxhvHEMcEtLTVGX7i83
         6S+7BwDPhF6yzlwNFFwygJxN4EvV4WLpZ4stsDsQ/Wm0yiwP42B77Dwnxpyp8zSnpsI9
         n1peIWzbaadco4b1HhjFQA5XBshEvGU2nKn5d91L0zBktYCj12hpJ9wiu8EcnapxQjHv
         wFuhyJ88daujRe0u0YSCx9BbZF1P0RzCQx0cIU4CNxG4xJs9e9vFzFSIexlTKOh25lNI
         Io3aqWFeXOjzBgDxgvQtrdcPOuBrdgp1+O0vnKbFIJBHJ5WfeYeuCvRf6nHuLd6/RQoH
         xOGw==
X-Gm-Message-State: AO0yUKXG4+zECTewTs2riwePix7/nMTILDZXRK9XzRLj3lKgq3SeeY4r
        in2rAh16rVLuEdrJUaHWB3SI0nlc3xhxQQI4PW2Qc3GRhy5F8jhkio3Om7gCID4fmmxEUMhn0dq
        NZFLSDL2VMf/D
X-Received: by 2002:a92:da05:0:b0:323:70c:ba7a with SMTP id z5-20020a92da05000000b00323070cba7amr6320945ilm.0.1678920794162;
        Wed, 15 Mar 2023 15:53:14 -0700 (PDT)
X-Google-Smtp-Source: AK7set+yni0unT0KaphMd3Dk9lb2xPshPnISgvaAGSRatSEhctfH2YsA/aYF25RNbXHTAq4r4BmLNg==
X-Received: by 2002:a92:da05:0:b0:323:70c:ba7a with SMTP id z5-20020a92da05000000b00323070cba7amr6320918ilm.0.1678920793895;
        Wed, 15 Mar 2023 15:53:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x1-20020a0566380ca100b003c5157c8b2csm209087jad.47.2023.03.15.15.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 15:53:12 -0700 (PDT)
Date:   Wed, 15 Mar 2023 16:53:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array
 in VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <20230315165311.01f32bfe.alex.williamson@redhat.com>
In-Reply-To: <20230308132903.465159-13-yi.l.liu@intel.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
        <20230308132903.465159-13-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  8 Mar 2023 05:28:51 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> This is another method to issue PCI hot reset for the users that bounds
> device to a positive iommufd value. In such case, iommufd is a proof of
> device ownership. By passing a zero-length fd array, user indicates kernel
> to do ownership check with the bound iommufd. All the opened devices within
> the affected dev_set should have been bound to the same iommufd. This is
> simpler and faster as user does not need to pass a set of fds and kernel
> no need to search the device within the given fds.

Couldn't this same idea apply to containers?

I'm afraid this proposal reduces or eliminates the handshake we have
with userspace between VFIO_DEVICE_GET_PCI_HOT_RESET_INFO and
VFIO_DEVICE_PCI_HOT_RESET, which could promote userspace to ignore the
_INFO ioctl altogether, resulting in drivers that don't understand the
scope of the reset.  Is it worth it?  What do we really gain?

> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index d80141969cd1..382d95455f89 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -682,6 +682,11 @@ struct vfio_pci_hot_reset_info {
>   * The ownership can be proved by:
>   *   - An array of group fds
>   *   - An array of device fds
> + *   - A zero-length array
> + *
> + * In the last case all affected devices which are opened by this user
> + * must have been bound to a same iommufd_ctx.  This approach is only
> + * available for devices bound to positive iommufd.
>   *
>   * Return: 0 on success, -errno on failure.
>   */

There's no introspection that this feature is supported, is that why
containers are not considered?  ie. if the host supports vfio cdevs, it
necessarily must support vfio-pci hot reset w/ a zero-length array?
Thanks,

Alex

