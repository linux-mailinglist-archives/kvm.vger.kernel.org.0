Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D1E6BDB2B
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 22:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCPV5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 17:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCPV5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 17:57:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF9260D60
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 14:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679003810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBfyzuvRoe+QOXGN5SbtszQ6PVd6w0zcMfyA5scQ3Zo=;
        b=BhbG+7xU8eRNHOjTRgeEdxG3RBaawYqQzWTnXWNWrtNDRdsuWQXBCw8ISvJcnJLa9ryrmx
        N4HmRsWOqV4mIXJCiBTlv3SP0zRTKOR0JKuz8ZoDSyU0erClSVtJDOtwx63XS/W/CSVSqv
        pEIYUgaHSAEgF7Y7iABuWlJpKf/fYww=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-fG7OZGx7MSKjTqnkNlBVaA-1; Thu, 16 Mar 2023 17:56:49 -0400
X-MC-Unique: fG7OZGx7MSKjTqnkNlBVaA-1
Received: by mail-io1-f71.google.com with SMTP id t15-20020a5d848f000000b00750c83214cbso1592679iom.0
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 14:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679003808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yBfyzuvRoe+QOXGN5SbtszQ6PVd6w0zcMfyA5scQ3Zo=;
        b=Ji1Adf7q3A28dqIftq1++aw06wqokbi8y2MN9oy3CmvB3mXEAbN0HXbMrR2Pr+6dQL
         aPEkt2SHEnpMJ9gNmci8ZZuFEeQQ5Kskf+KOGPSdeVSQ3c3zjtYlQtG7mpV6gXYcB3aK
         8KWjmz8sig7cjcEYq4jMKtzbVPY4PuSXDrGVMwNnrtRedz0PiipJx5stPD4OFihPlgjD
         5x56iJWakZ3tlNCehfhXThIRQiJttKlGI27RReS0y4SW5GanVg/eMzh+yRCo/SVbudvu
         ngUcoa5LzLXlJoFAQLHhm1znK05i5F62yX9RAKpamHG2gBX5OAzbVV+B0G4t3OgCRCoA
         /YAA==
X-Gm-Message-State: AO0yUKUCoi42Nc9KN7iVdrMKLuCWik+HX65uiDl/idlM2k06WDJ+NoUC
        HslIueDRl0CCS84onOovnS1ywJ8p5snkbtdmhemxt+kcWmmYaUctmW30dea5XW+Ky7vWgWEKuk6
        2BAXtK6yZjXK1
X-Received: by 2002:a92:da8e:0:b0:315:53b6:d293 with SMTP id u14-20020a92da8e000000b0031553b6d293mr8470342iln.21.1679003808585;
        Thu, 16 Mar 2023 14:56:48 -0700 (PDT)
X-Google-Smtp-Source: AK7set8hE9qRjiVkADLNj9Ym+CS3y91gsTlZRJSIxUV9UT3cXYpWiTMNkB+43yCbBxsrCLOPFbEbcA==
X-Received: by 2002:a92:da8e:0:b0:315:53b6:d293 with SMTP id u14-20020a92da8e000000b0031553b6d293mr8470326iln.21.1679003808286;
        Thu, 16 Mar 2023 14:56:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c13-20020a928e0d000000b003157b2c504bsm137825ild.24.2023.03.16.14.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 14:56:47 -0700 (PDT)
Date:   Thu, 16 Mar 2023 15:56:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
Message-ID: <20230316155646.07ae266f.alex.williamson@redhat.com>
In-Reply-To: <cover.1678911529.git.reinette.chatre@intel.com>
References: <cover.1678911529.git.reinette.chatre@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Wed, 15 Mar 2023 13:59:20 -0700
Reinette Chatre <reinette.chatre@intel.com> wrote:

> == Cover letter ==
> 
> Qemu allocates interrupts incrementally at the time the guest unmasks an
> interrupt, for example each time a Linux guest runs request_irq().
> 
> Dynamic allocation of MSI-X interrupts was not possible until v6.2 [1].
> This prompted Qemu to, when allocating a new interrupt, first release all
> previously allocated interrupts (including disable of MSI-X) followed
> by re-allocation of all interrupts that includes the new interrupt.
> Please see [2] for a detailed discussion about this issue.
> 
> Releasing and re-allocating interrupts may be acceptable if all
> interrupts are unmasked during device initialization. If unmasking of
> interrupts occur during runtime this may result in lost interrupts.
> For example, consider an accelerator device with multiple work queues,
> each work queue having a dedicated interrupt. A work queue can be
> enabled at any time with its associated interrupt unmasked while other
> work queues are already active. Having all interrupts released and MSI-X
> disabled to enable the new work queue will impact active work queues.
> 
> This series builds on the recent interrupt sub-system core changes
> that added support for dynamic MSI-X allocation after initial MSI-X
> enabling.
> 
> Add support for dynamic MSI-X allocation to vfio-pci. A flag
> indicating lack of support for dynamic allocation already exist:
> VFIO_IRQ_INFO_NORESIZE and has always been set for MSI and MSI-X. With
> support for dynamic MSI-X the flag is cleared for MSI-X, enabling
> Qemu to modify its behavior.
> 
> == Why is this an RFC ? ==
> 
> vfio support for dynamic MSI-X needs to work with existing user space
> as well as upcoming user space that takes advantage of this feature.
> I would appreciate guidance on the expectations and requirements
> surrounding error handling when considering existing user space.
> 
> For example, consider the following scenario:
> Start: Consider a passthrough device that supports 10 MSI-X interrupts
> 	(0 to 9) and existing Qemu allocated interrupts 0 to 4.
> 
> Scenario: Qemu (hypothetically) attempts to associate a new action to
> 	interrupts 0 to 7. Early checking of this range in
> 	vfio_set_irqs_validate_and_prepare() will pass since it
> 	is a valid range for the device. What happens after the
> 	early checking is considered next:
> 
> Current behavior (before this series): Since the provided range, 0 - 7,
> 	exceeds the allocated range, no action will be taken on existing
> 	allocated interrupts 0 - 4 and the Qemu request will fail without
> 	making any state changes.

I must be missing something, it was described correctly earlier that
QEMU will disable MSI-X and re-enable with a new vector count.  Not
only does QEMU not really have a way to fail this change, pretty much
nothing would work if we did.

What happens in this case is that the QEMU vfio-pci driver gets a
vector_use callback for one of these new vectors {5,6,7},
vfio_msix_vector_do_use() checks that's greater than we have enabled,
disables MSI-X, and re-enables it for the new vector count.  Worst case
we'll do that 3 times if the vectors are presented in ascending order.

> New behavior (with this series): Since vfio supports dynamic MSI-X new
> 	interrupts will be allocated for vectors 5, 6, and 7. Please note
> 	that this changes the behavior encountered by unmodified Qemu: new
> 	interrupts are allocated instead of returning an error. Even more,
> 	since the range provided by Qemu spans 0 - 7, a failure during
> 	allocation of 5, 6, or 7 will result in release of entire range.

As above, QEMU doesn't currently return an error here, nor is there
actually any means to return an error.  MSI-X is not paravirtualized
and the PCI spec definition of MSI-X does not define that a driver
needs to check whether the device accepted unmasking a vector.  All we
can do in QEMU if the host fails to configure the device as directed is
print an error message as a breadcrumb to help debug why the device
stopped working.  In practice, I don't think I've ever seen this.

So really the difference should be transparent to the guest.  The risk
of an error allocating vectors on the host is the same, the only
significant difference should be the amount of disruption at the device
that we can better approximate the request of the guest.
 
> This series aims to maintain existing error behavior for MSI (please see
> "vfio/pci: Remove interrupt context counter") but I would appreciate your
> guidance on whether existing error behavior should be maintained for MSI-X
> and how to do so if it is a requirement.

Based on above, there really can never be an error if we expect the
device to work, so I think there's a misread of the current status.
Dynamic MSI-X support should simply reduce the disruption and chance of
lost interrupts at the device, but the points where we risk that the
host cannot provide the configuration we need are the same.  Thanks,

Alex

