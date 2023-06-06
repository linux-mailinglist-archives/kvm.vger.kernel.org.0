Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5647249C1
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 19:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbjFFRGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 13:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjFFRF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 13:05:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC25310F2
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 10:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686071114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Klr9ojsS6vgNV/bJIZFbnwpXw/q2jytqsbFFwKeEH40=;
        b=bLLr6INGpCJs/tD9MOjM4omqohJGWszokUMLrBBTEKiQIiMwBXwJkq4KeOXtcGtbh3Y1/8
        8FJOJlFNHsfvi9VTmj9dkGOVXGLi9zwZjiUXyQsnDUl7KlZcKt3tsP0ECsIP0zwvjaEEuA
        8z7QwG5Nd2oSiQNkyeCbjlCTKUjtaA4=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-vr2uQTNWOzOuoZFFYpj5Gg-1; Tue, 06 Jun 2023 13:05:13 -0400
X-MC-Unique: vr2uQTNWOzOuoZFFYpj5Gg-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7775a282e25so436278739f.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 10:05:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686071112; x=1688663112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Klr9ojsS6vgNV/bJIZFbnwpXw/q2jytqsbFFwKeEH40=;
        b=O7qjP3z595VIph9Di5aOaZd3Cmtu4f6VDN1PcE96RkS7YuNX0X6Dck9NZTCPH/wjec
         yBxWqq0f42d58TWJ9yn0Wfu4yPkTn2/i9opYnStBf3VHM494uNhUsVWU32WHY9RFyBWN
         bSRFfmMzaLnXXRPd+HHnZ2fFJbmsH+0Rpo/V7v5JHJlgYM3TIGoic6KgJYkpi938xX3I
         qV8MNeqKPH3c/n39GWJ0luzga7l9pCPDfWGrIvMO5mlUaZZKwnfgoOQ/MayLL4ujQeNo
         OoNoLcLpFlwSzQcSIDp/wA1nQaIxkWfFOQ9pGu/mBUhQ5aO1fO2VS22oc2GFnmXd3pCZ
         S0Dw==
X-Gm-Message-State: AC+VfDyrbkZHxwHM9KJFsXfd15GWAu6ICsUEgwAUd8NvZs8MTOTtKb7V
        Nh8YSMbGNhXz7ExJHij5QX/MiJ/uN/mOb6TiPT4GKO28SK2ADom4jzQ+3HvYgkI/VajxZom7s/k
        g1+/7sToLbCUn
X-Received: by 2002:a92:dc8b:0:b0:335:c544:a1a7 with SMTP id c11-20020a92dc8b000000b00335c544a1a7mr2871911iln.0.1686071112406;
        Tue, 06 Jun 2023 10:05:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5yq6k08lcp3LSMa8oKyF/fjsPILIefcMLDuqKrnu3BgvX/2jpbtzwjN8wvkImSfQ4fBctN/A==
X-Received: by 2002:a92:dc8b:0:b0:335:c544:a1a7 with SMTP id c11-20020a92dc8b000000b00335c544a1a7mr2871886iln.0.1686071112145;
        Tue, 06 Jun 2023 10:05:12 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z11-20020a92d6cb000000b0033bea7559ffsm3112615ilp.53.2023.06.06.10.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 10:05:11 -0700 (PDT)
Date:   Tue, 6 Jun 2023 11:05:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230606110510.0f87952c.alex.williamson@redhat.com>
In-Reply-To: <ZH9RfXhbuED2IUgJ@nvidia.com>
References: <20230606025320.22647-1-ankita@nvidia.com>
        <20230606083238.48ea50e9.alex.williamson@redhat.com>
        <ZH9RfXhbuED2IUgJ@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Jun 2023 12:32:13 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 06, 2023 at 08:32:38AM -0600, Alex Williamson wrote:
> > On Mon, 5 Jun 2023 19:53:20 -0700
> > <ankita@nvidia.com> wrote:
> >   
> > > From: Ankit Agrawal <ankita@nvidia.com>
> > > 
> > > NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> > > for the on-chip GPU that is the logical OS representation of the
> > > internal proprietary cache coherent interconnect.
> > > 
> > > This representation has a number of limitations compared to a real PCI
> > > device, in particular, it does not model the coherent GPU memory
> > > aperture as a PCI config space BAR, and PCI doesn't know anything
> > > about cacheable memory types.
> > > 
> > > Provide a VFIO PCI variant driver that adapts the unique PCI
> > > representation into a more standard PCI representation facing
> > > userspace. The GPU memory aperture is obtained from ACPI using
> > > device_property_read_u64(), according to the FW specification,
> > > and exported to userspace as a separate VFIO_REGION. Since the device
> > > implements only one 64-bit BAR (BAR0), the GPU memory aperture is mapped
> > > to the next available PCI BAR (BAR2). Qemu will then naturally generate a
> > > PCI device in the VM with two 64-bit BARs (where the cacheable aperture
> > > reported in BAR2).
> > > 
> > > Since this memory region is actually cache coherent with the CPU, the
> > > VFIO variant driver will mmap it into VMA using a cacheable mapping. The
> > > mapping is done using remap_pfn_range().
> > > 
> > > PCI BAR are aligned to the power-of-2, but the actual memory on the
> > > device may not. The physical address from the last device PFN up to the
> > > next power-of-2 aligned PA thus is mapped to a dummy PFN through
> > > vm_operations fault.  
> > 
> > As noted in the QEMU series, this all suggests to me that we should
> > simply expose a device specific region for this coherent memory which
> > QEMU can then choose to expose to the VM as a BAR, or not.    
> 
> It doesn't expose as a BAR on bare metal due to a HW limitation. When
> we look toward VFIO CXL devices I would expect them to have proper
> BARs and not this ACPI hack.
> 
> So the approach is to compartmentalize the hack to the bare metal
> kernel driver and let the ABI and qemu parts be closer to what CXL
> will eventually need.
> 
> > It's clearly not a BAR on bare metal, so if we need to go to all the
> > trouble to create ACPI tables to further define the coherent memory
> > space,  
> 
> The ACPI tables shouldn't relate to the "BAR", they are needed to
> overcome the NUMA problems in the kernel in the same way real device
> FW does.
> 
> > what's the benefit of pretending that it's a PCI BAR?  ie. Why should a
> > VM view this as a BAR rather than follow the same semantics as bare
> > metal?  
> 
> Primarily it is a heck of a lot simpler in qemu and better aligned
> with where things are going.

It actually seems more complicated this way.  We're masquerading this
region as a BAR, but then QEMU needs to know based on device IDs that
it's really not a BAR, it has special size properties, mapping
attributes, error handling, etc.  Maybe we should have taken the hint
that it's not affected by the PCI config space memory enable bit that a
BAR region is not the right way for vfio to compose the device.

It's really beside the point whether you want QEMU to expose the memory
region to the VM as a BAR, but the more I see how this works the more
it makes sense to me that this should be a device specific region that
is the trigger for QEMU to setup these special properties.  It is
trivial for QEMU to expose a region as a BAR and then it can manage the
size issues for mapping, keeping things like an overflow page out of
the kernel.

> > We can then have a discussion whether this even needs to be a variant
> > driver versus a vfio-pci quirk if this device specific region is the
> > only feature provided (ie. is migration in the future for this
> > driver?).    
> 
> There is alot more here, go back to the original v1 posting to see it
> all. This is way too much to be just a quirk.

I'm not privy to a v1, the earliest I see is this (v3):

https://lore.kernel.org/all/20230405180134.16932-1-ankita@nvidia.com/

That outlines that we have a proprietary interconnect exposing cache
coherent memory which requires use of special mapping attributes vs a
standard PCI BAR and participates in ECC.  All of which seems like it
would be easier to setup in QEMU if the vfio-pci representation of the
device didn't masquerade this regions as a standard BAR.  In fact it
also reminds me of NVlink2 coherent RAM on POWER machines that was
similarly handled as device specific regions.  Thanks,

Alex

