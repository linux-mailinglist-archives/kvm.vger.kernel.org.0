Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C43D6D6BFD
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 20:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236482AbjDDS26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 14:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236226AbjDDS2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 14:28:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7326283F1
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 11:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680632688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r7qkJ3kGFig3GmLpy8FM3sy/Mc2VBWhX0DsSyyZtPrM=;
        b=DF+n96IFWXyKhY9/h69z/RSycLvQOSAcPpVH2fk6lWgd2mvztya4O8RVAaXajU46QPjRRG
        Z74+nFZMBMLWgINBSuVpxo6M0jQu22mOjDRG6hry6PclYmqh2a5UwccQduQF6uAj/JRa9L
        ngnt/XGwwsEq+jwstz4MUdpUNvmyUrs=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-WRoGlJQrMF6AD58-91Eaag-1; Tue, 04 Apr 2023 14:24:47 -0400
X-MC-Unique: WRoGlJQrMF6AD58-91Eaag-1
Received: by mail-il1-f200.google.com with SMTP id h19-20020a056e021d9300b00318f6b50475so21628805ila.21
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 11:24:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r7qkJ3kGFig3GmLpy8FM3sy/Mc2VBWhX0DsSyyZtPrM=;
        b=SJy76/YIwDoHi/33jqkDJL3Mlbz6a7biMkG0hpvIo7ppBvnCbQU1SJzsCVMSZIYhCo
         sX5SYqma267pqvW5muxEU09FRPF48XY7166YQTMUTfAqUKRRxj1pkaGikf0yBMZD6htR
         ujejN0aACQlQ87ClP3XlYV3IwLywIL7cYViRm/DxHqqlYtMShTO2kiLQ/LVuWrBoaXfn
         lYGZHKTEq9nkBTKp3ajRqMJd2WCjGj1ys8U1+Q1JZpIHcXJinx0uf4gj3LmLxlhzFsFy
         inxAw+Gnbcxxygrhr0v1G2s3kVoo88cvnC6secnztEYGzhtcR4PlkcdvR881GpR7/Uar
         UbAw==
X-Gm-Message-State: AAQBX9cdrDZwk7rUCd30qPEQ9L/NeScAfNOIsy5N7X/Inr4d1qwcqZIU
        4QaooLAC+XNGsJynqZxljlA8RMkDp19CW2IyCPKmpRaR2YLFOOvxEZxNdlHjrSbJXXYD+4sZ61N
        r3wFGPuG1jiFk
X-Received: by 2002:a05:6602:330d:b0:758:55ff:5314 with SMTP id b13-20020a056602330d00b0075855ff5314mr2952012ioz.0.1680632686535;
        Tue, 04 Apr 2023 11:24:46 -0700 (PDT)
X-Google-Smtp-Source: AKy350azKYThQ1mAA0lmj4BDScAXCqFFq+kCgLoRnuuRBHPnfWUSziEYvyq6+YuYd+DYXcmviqPqrg==
X-Received: by 2002:a05:6602:330d:b0:758:55ff:5314 with SMTP id b13-20020a056602330d00b0075855ff5314mr2952003ioz.0.1680632686253;
        Tue, 04 Apr 2023 11:24:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g27-20020a02271b000000b003e9e5e1aacasm3598588jaa.143.2023.04.04.11.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:24:45 -0700 (PDT)
Date:   Tue, 4 Apr 2023 12:24:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Message-ID: <20230404122444.59e36a99.alex.williamson@redhat.com>
In-Reply-To: <5efa361d-012b-bdb6-b5e5-869887bde98d@intel.com>
References: <cover.1680038771.git.reinette.chatre@intel.com>
        <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
        <20230330164050.0069e2a5.alex.williamson@redhat.com>
        <20230330164214.67ccbdfa.alex.williamson@redhat.com>
        <688393bf-445c-15c5-e84d-1c16261a4197@intel.com>
        <20230331162456.3f52b9e3.alex.williamson@redhat.com>
        <e15d588e-b63f-ab70-f6ae-91ceea8be79a@intel.com>
        <20230403142227.1328b373.alex.williamson@redhat.com>
        <57a8c701-bf97-fddd-9ac0-fc4d09e3cb16@intel.com>
        <20230403211841.0e206b67.alex.williamson@redhat.com>
        <5efa361d-012b-bdb6-b5e5-869887bde98d@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Apr 2023 09:54:46 -0700
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Alex,
> 
> On 4/3/2023 8:18 PM, Alex Williamson wrote:
> > On Mon, 3 Apr 2023 15:50:54 -0700
> > Reinette Chatre <reinette.chatre@intel.com> wrote:  
> >> On 4/3/2023 1:22 PM, Alex Williamson wrote:  
> >>> On Mon, 3 Apr 2023 10:31:23 -0700
> >>> Reinette Chatre <reinette.chatre@intel.com> wrote:  
> >>>> On 3/31/2023 3:24 PM, Alex Williamson wrote:    
> >>>>> On Fri, 31 Mar 2023 10:49:16 -0700
> >>>>> Reinette Chatre <reinette.chatre@intel.com> wrote:      
> >>>>>> On 3/30/2023 3:42 PM, Alex Williamson wrote:      
> >>>>>>> On Thu, 30 Mar 2023 16:40:50 -0600
> >>>>>>> Alex Williamson <alex.williamson@redhat.com> wrote:
> >>>>>>>         
> >>>>>>>> On Tue, 28 Mar 2023 14:53:34 -0700
> >>>>>>>> Reinette Chatre <reinette.chatre@intel.com> wrote:
> >>>>>>>>        
> 
> 
> ...
> 
> >>> If the goal is to allow the user to swap one eventfd for another, where
> >>> the result will always be the new eventfd on success or the old eventfd
> >>> on error, I don't see that this code does that, or that we've ever
> >>> attempted to make such a guarantee.  If the ioctl errors, I think the
> >>> eventfds are generally deconfigured.   We certainly have the unwind code
> >>> that we discussed earlier that deconfigures all the vectors previously
> >>> touched in the loop (which seems to be another path where we could
> >>> de-allocate from the set of initial ctxs).    
> >>
> >> Thank you for your patience in hearing and addressing my concerns. I plan
> >> to remove new_ctx in the next version.
> >>  
> >>>>> devices supporting vdev->has_dyn_msix only ever have active contexts
> >>>>> allocated?  Thanks,      
> >>>>
> >>>> What do you see as an "active context"? A policy that is currently enforced
> >>>> is that an allocated context always has an allocated interrupt associated
> >>>> with it. I do not see how this could be expanded to also require an
> >>>> enabled interrupt because interrupt enabling requires a trigger that
> >>>> may not be available.    
> >>>
> >>> A context is essentially meant to track a trigger, ie. an eventfd
> >>> provided by the user.  In the static case all the irqs are necessarily
> >>> pre-allocated, therefore we had no reason to consider a dynamic array
> >>> for the contexts.  However, a given context is really only "active" if
> >>> it has a trigger, otherwise it's just a placeholder.  When the
> >>> placeholder is filled by an eventfd, the pre-allocated irq is enabled.    
> >>
> >> I see.
> >>  
> >>>
> >>> This proposal seems to be a hybrid approach, pre-allocating some
> >>> initial set of irqs and contexts and expecting the differentiation to
> >>> occur only when new vectors are added, though we have some disagreement
> >>> about this per above.  Unfortunately I don't see an API to enable MSI-X
> >>> without some vectors, so some pre-allocation of irqs seems to be
> >>> required regardless.    
> >>
> >> Right. pci_alloc_irq_vectors() or equivalent continues to be needed to
> >> enable MSI-X. Even so, it does seem possible (within vfio_msi_enable())
> >> to just allocate one vector using pci_alloc_irq_vectors()
> >> and then immediately free it using pci_msix_free_irq(). What do you think?  
> > 
> > QEMU does something similar but I think it can really only be described
> > as a hack.  In this case I think we can work with them being allocated
> > since that's essentially the static path.  
> 
> ok. In this case I understand the hybrid approach to be required. Without
> something (a hack) like this I am not able to see how an "active context"
> policy can be enforced though. Interrupts allocated during MSI-X enabling may
> not have eventfd associated and thus cannot adhere to an "active context" policy. I
> understand from  earlier comments that we do not want to track where contexts
> are allocated so I can only see a way to enforce a policy that a context has
> an allocated interrupt, but not an enabled interrupt.

We're talking about the contexts that we now allocate in the xarray to
store the eventfd linkage, right?  We need to pre-allocate some irqs
both to satisfy the API and to support non-dynamic MSI-X devices, but
we don't need to pre-allocate contexts.  The logic that I propose below
supports lookup of the pre-allocated irqs for all cases and falls back
to allocating a new irq only for cases that support it.  irqs and
contexts aren't exactly 1:1 for the dynamic case due to the artifacts
of the API, but the model supports only allocating contexts as they're
used, or "active".
 
> >> If I understand correctly this can be done without allocating any context
> >> and leave MSI-X enabled without any interrupts allocated. This could be a
> >> way to accomplish the "active context" policy for dynamic allocation.
> >> This is not a policy that can be applied broadly to interrupt contexts though
> >> because MSI and non-dynamic MSI-X could still have contexts with allocated
> >> interrupts without eventfd.  
> > 
> > I think we could come up with wrappers that handle all cases, for
> > example:
> > 
> > int vfio_pci_alloc_irq(struct vfio_pci_core_device *vdev,
> > 		       unsigned int vector, int irq_type)
> > {
> > 	struct pci_dev *pdev = vdev->pdev;
> > 	struct msi_map map;
> > 	int irq;
> > 
> > 	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX)
> > 		return pdev->irq ?: -EINVAL;
> > 
> > 	irq = pci_irq_vector(pdev, vector);
> > 	if (irq > 0 || irq_type == VFIO_PCI_MSI_IRQ_INDEX ||
> > 	    !vdev->has_dyn_msix)
> > 		return irq;
> > 
> > 	map = pci_msix_alloc_irq_at(pdev, vector, NULL);
> > 
> > 	return map.index;
> > }
> > 
> > void vfio_pci_free_irq(struct vfio_pci_core_device *vdev,
> > 		       unsigned in vector, int irq_type)
> > {
> > 	struct msi_map map;
> > 	int irq;
> > 
> > 	if (irq_type != VFIO_PCI_INTX_MSIX_INDEX ||
> > 	    !vdev->has_dyn_msix)
> > 		return;
> > 
> > 	irq = pci_irq_vector(pdev, vector);
> > 	map = { .index = vector, .virq = irq };
> > 
> > 	if (WARN_ON(irq < 0))
> > 		return;
> > 
> > 	pci_msix_free_irq(pdev, msix_map);
> > }  
> 
> Thank you very much for taking the time to write this out. I am not able to
> see where vfio_pci_alloc_irq()/vfio_pci_free_irq() would be called for
> an INTx interrupt. Is the INTx handling there for robustness or am I
> missing how it should be used for INTx interrupts?

Mostly just trying to illustrate that all interrupt types could be
supported, if it doesn't make sense for INTx, drop it.

> > At that point, maybe we'd check whether it makes sense to embed the irq
> > alloc/free within the ctx alloc/free.  
> 
> I think doing so would be the right thing to do since it helps
> to enforce the policy that interrupts and contexts are allocated together.
> I think this can be done when switching around the initialization within 
> vfio_msi_set_vector_signal(). I need to look into this more.

Interrupts and contexts allocated together would be ideal, but I think
given the API it's a reasonable and simple compromise given the
non-dynamic support to draw from the initial allocation where we can.
Actually, there could be a latency and reliability advantage to hang on
to the irq when an eventfd is unset, maybe we should only free irqs on
MSI-X teardown and otherwise use the allocated irqs as a cache.  Maybe
worth thinking about.  Thanks,

Alex

