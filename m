Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06496D5721
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 05:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjDDDTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 23:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbjDDDTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 23:19:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953B010D0
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 20:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680578325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4kPxZDkkystFBCsDS3qDO/YGM0kXe5GGtejQTxI3hEQ=;
        b=G55UXTt3XlVtmiLzh+wEdbGb0kUVkehpGToohUI8xtinsHMiC2b3tB50t9INeCk36KvjjU
        pLxBxgKJpVsMYkYH9vnpqWaLXy4ec/yLTsNR2nEaPtBvPmjUEgz9FJzfzVNSM0d9ichkIk
        9uzGg4yZXVrWOoNKV1jw4/hVUyQKm0k=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-TWtvLFiQPMe4pRmVsUVsEA-1; Mon, 03 Apr 2023 23:18:44 -0400
X-MC-Unique: TWtvLFiQPMe4pRmVsUVsEA-1
Received: by mail-io1-f71.google.com with SMTP id j4-20020a6b5504000000b00758646159fbso19293506iob.20
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 20:18:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680578323;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4kPxZDkkystFBCsDS3qDO/YGM0kXe5GGtejQTxI3hEQ=;
        b=vKi5cDIIpvKdKStO37yx5G0cupg3ZoSnrrb4CSBioZwyapCa4sb7xOJsMLyHVjDvNm
         w0ymIKIU7WBdOxEja9B7eEsRdmZIUMlg0VBxRToNXXYzPT3Xs46wl5uU98EUb2Eg0p4k
         TK1SBFIB5QRKgbCZNf3Rg5cH8pPecLjgQms797gRx30OxncGtKoTo5YvZ9hmbjF3p6SA
         rxGKc+CsO0T5gejD/A84cWmC8mwtM4dj9Hd+j87GW6zT4hnHuLLDPhD02oq5+n1rCOX4
         4Lop5V9xOle+iu/MFVfDWIkO9K2ww7EOgk9SaHtSNhpwkaqXkInAumIqj5TRt0zaIAAm
         AuVA==
X-Gm-Message-State: AAQBX9dU5LPmze3tlQfoB9Bwfp2r8o+ZACfcM+I/nrFAU+n1d2uUQL3d
        Ox7vG6JwlLxKLq2T8riF2H+GssI5ywdb+7PjXZVJpIVyFMlqBnnhaAzBQmVcfh/AAKGIuMDdM3/
        +kPc+gUe/hrjx
X-Received: by 2002:a5d:9f1a:0:b0:751:e48c:7eed with SMTP id q26-20020a5d9f1a000000b00751e48c7eedmr1360504iot.11.1680578323590;
        Mon, 03 Apr 2023 20:18:43 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZICVjdeUUfWAvC83xdBsqclzRsTJt+s4p6vg2fN05pSzDQCDBAqM6LhEe07UXDH3HImJG+EQ==
X-Received: by 2002:a5d:9f1a:0:b0:751:e48c:7eed with SMTP id q26-20020a5d9f1a000000b00751e48c7eedmr1360486iot.11.1680578323253;
        Mon, 03 Apr 2023 20:18:43 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r22-20020a056638131600b0040b1ada219fsm2906066jad.26.2023.04.03.20.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 20:18:42 -0700 (PDT)
Date:   Mon, 3 Apr 2023 21:18:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Message-ID: <20230403211841.0e206b67.alex.williamson@redhat.com>
In-Reply-To: <57a8c701-bf97-fddd-9ac0-fc4d09e3cb16@intel.com>
References: <cover.1680038771.git.reinette.chatre@intel.com>
        <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
        <20230330164050.0069e2a5.alex.williamson@redhat.com>
        <20230330164214.67ccbdfa.alex.williamson@redhat.com>
        <688393bf-445c-15c5-e84d-1c16261a4197@intel.com>
        <20230331162456.3f52b9e3.alex.williamson@redhat.com>
        <e15d588e-b63f-ab70-f6ae-91ceea8be79a@intel.com>
        <20230403142227.1328b373.alex.williamson@redhat.com>
        <57a8c701-bf97-fddd-9ac0-fc4d09e3cb16@intel.com>
Organization: Red Hat
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

On Mon, 3 Apr 2023 15:50:54 -0700
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Alex,
> 
> On 4/3/2023 1:22 PM, Alex Williamson wrote:
> > On Mon, 3 Apr 2023 10:31:23 -0700
> > Reinette Chatre <reinette.chatre@intel.com> wrote:
> >   
> >> Hi Alex,
> >>
> >> On 3/31/2023 3:24 PM, Alex Williamson wrote:  
> >>> On Fri, 31 Mar 2023 10:49:16 -0700
> >>> Reinette Chatre <reinette.chatre@intel.com> wrote:    
> >>>> On 3/30/2023 3:42 PM, Alex Williamson wrote:    
> >>>>> On Thu, 30 Mar 2023 16:40:50 -0600
> >>>>> Alex Williamson <alex.williamson@redhat.com> wrote:
> >>>>>       
> >>>>>> On Tue, 28 Mar 2023 14:53:34 -0700
> >>>>>> Reinette Chatre <reinette.chatre@intel.com> wrote:
> >>>>>>      
> >>
> >> ...
> >>  
> >>>>>>> +		msix_map.index = vector;
> >>>>>>> +		msix_map.virq = irq;
> >>>>>>> +		pci_msix_free_irq(pdev, msix_map);
> >>>>>>> +	}
> >>>>>>> +	vfio_pci_memory_unlock_and_restore(vdev, cmd);
> >>>>>>>  out_put_eventfd_ctx:
> >>>>>>>  	eventfd_ctx_put(trigger);
> >>>>>>>  out_free_name:
> >>>>>>>  	kfree(ctx->name);
> >>>>>>>  	ctx->name = NULL;
> >>>>>>> +out_free_ctx:
> >>>>>>> +	if (allow_dyn_alloc && new_ctx)
> >>>>>>> +		vfio_irq_ctx_free(vdev, ctx, vector);
> >>>>>>>  	return ret;
> >>>>>>>  }
> >>>>>>>          
> >>>>>>
> >>>>>> Do we really need the new_ctx test in the above cases?  Thanks,      
> >>>>
> >>>> new_ctx is not required for correctness but instead is used to keep
> >>>> the code symmetric. 
> >>>> Specifically, if the user enables MSI-X without providing triggers and
> >>>> then later assign triggers then an error path without new_ctx would unwind
> >>>> more than done in this function, it would free the context that
> >>>> was allocated within vfio_msi_enable().     
> >>>
> >>> Seems like we already have that asymmetry, if a trigger is unset we'll
> >>> free the ctx allocated by vfio_msi_enable().  Tracking which are    
> >>
> >> Apologies, but could you please elaborate on where the asymmetry is? I am
> >> not able to see a flow in this solution where the ctx allocated by
> >> vfio_msi_enable() is freed if the trigger is unset.  
> > 
> > The user first calls SET_IRQS to enable MSI-X with some number of
> > vectors with (potentially) an eventfd for each vector.  The user later
> > calls SET_IRQS passing a -1 eventfd for one or more of the vectors with
> > an eventfd initialized in the prior step.  Given that we find the ctx,
> > the ctx has a trigger, and assuming dynamic allocation is supported, the
> > ctx is freed and vfio_msi_set_vector_signal() returns w/o allocating a
> > new ctx.  We've de-allocated both the irq and context initialized from
> > vfio_msi_enable().  
> 
> This is correct. The comment I responded to was in regards to an unset
> trigger. The flow you describe is when a trigger is set. Not that
> it changes your point though, which is that vfio_msi_set_vector_signal()
> frees memory allocated by vfio_msi_enable(). This is clear to me. This
> is intended behavior. My concern is/was with the error path where a function
> failing may not be expected to change state, you address that concern below.
> 
> >>> allocated where is unnecessarily complex, how about a policy that    
> >>
> >> I do not see this as tracking where allocations are made. Instead I
> >> see it as containing/compartmentalizing state changes with the goal of
> >> making the code easier to understand and maintain. Specifically, new_ctx
> >> is used so that if vfio_msi_set_vector_signal() fails, the state 
> >> before and after vfio_msi_set_vector_signal() will be the same.  
> > 
> > That's not really possible given how we teardown the existing ctx
> > before configuring the new one and unwind to disable contexts in
> > vfio_msi_set_block()  
> 
> Very unlikely indeed. I agree.
> 
> >> I do agree that it makes vfio_msi_set_vector_signal() more complex
> >> and I can remove new_ctx if you find that this is unnecessary after
> >> considering the motivations behind its use.   
> > 
> > If the goal is to allow the user to swap one eventfd for another, where
> > the result will always be the new eventfd on success or the old eventfd
> > on error, I don't see that this code does that, or that we've ever
> > attempted to make such a guarantee.  If the ioctl errors, I think the
> > eventfds are generally deconfigured.   We certainly have the unwind code
> > that we discussed earlier that deconfigures all the vectors previously
> > touched in the loop (which seems to be another path where we could
> > de-allocate from the set of initial ctxs).  
> 
> Thank you for your patience in hearing and addressing my concerns. I plan
> to remove new_ctx in the next version.
> 
> >>> devices supporting vdev->has_dyn_msix only ever have active contexts
> >>> allocated?  Thanks,    
> >>
> >> What do you see as an "active context"? A policy that is currently enforced
> >> is that an allocated context always has an allocated interrupt associated
> >> with it. I do not see how this could be expanded to also require an
> >> enabled interrupt because interrupt enabling requires a trigger that
> >> may not be available.  
> > 
> > A context is essentially meant to track a trigger, ie. an eventfd
> > provided by the user.  In the static case all the irqs are necessarily
> > pre-allocated, therefore we had no reason to consider a dynamic array
> > for the contexts.  However, a given context is really only "active" if
> > it has a trigger, otherwise it's just a placeholder.  When the
> > placeholder is filled by an eventfd, the pre-allocated irq is enabled.  
> 
> I see.
> 
> > 
> > This proposal seems to be a hybrid approach, pre-allocating some
> > initial set of irqs and contexts and expecting the differentiation to
> > occur only when new vectors are added, though we have some disagreement
> > about this per above.  Unfortunately I don't see an API to enable MSI-X
> > without some vectors, so some pre-allocation of irqs seems to be
> > required regardless.  
> 
> Right. pci_alloc_irq_vectors() or equivalent continues to be needed to
> enable MSI-X. Even so, it does seem possible (within vfio_msi_enable())
> to just allocate one vector using pci_alloc_irq_vectors()
> and then immediately free it using pci_msix_free_irq(). What do you think?

QEMU does something similar but I think it can really only be described
as a hack.  In this case I think we can work with them being allocated
since that's essentially the static path.

> If I understand correctly this can be done without allocating any context
> and leave MSI-X enabled without any interrupts allocated. This could be a
> way to accomplish the "active context" policy for dynamic allocation.
> This is not a policy that can be applied broadly to interrupt contexts though
> because MSI and non-dynamic MSI-X could still have contexts with allocated
> interrupts without eventfd.

I think we could come up with wrappers that handle all cases, for
example:

int vfio_pci_alloc_irq(struct vfio_pci_core_device *vdev,
		       unsigned int vector, int irq_type)
{
	struct pci_dev *pdev = vdev->pdev;
	struct msi_map map;
	int irq;

	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX)
		return pdev->irq ?: -EINVAL;

	irq = pci_irq_vector(pdev, vector);
	if (irq > 0 || irq_type == VFIO_PCI_MSI_IRQ_INDEX ||
	    !vdev->has_dyn_msix)
		return irq;

	map = pci_msix_alloc_irq_at(pdev, vector, NULL);

	return map.index;
}

void vfio_pci_free_irq(struct vfio_pci_core_device *vdev,
		       unsigned in vector, int irq_type)
{
	struct msi_map map;
	int irq;

	if (irq_type != VFIO_PCI_INTX_MSIX_INDEX ||
	    !vdev->has_dyn_msix)
		return;

	irq = pci_irq_vector(pdev, vector);
	map = { .index = vector, .virq = irq };

	if (WARN_ON(irq < 0))
		return;

	pci_msix_free_irq(pdev, msix_map);
}

At that point, maybe we'd check whether it makes sense to embed the irq
alloc/free within the ctx alloc/free.
 
> > But if non-active contexts were only placeholders in the pre-dynamic
> > world and we now manage them via a dynamic array, why is there any
> > pre-allocation of contexts without knowing the nature of the eventfd to
> > fill it?  We could have more commonality between cases if contexts are
> > always dynamically allocated, which might simplify differentiation of
> > the has_dyn_msix cases largely to wrappers allocating and freeing irqs.
> > Thanks,  
> 
> Thank you very much for your guidance. I will digest this some more and 
> see how wrappers could be used. In the mean time while trying to think how
> to unify this code I do think there is an issue in this patch in that
> the get_cached_msi_msg()/pci_write_msi_msg()
> should not be in an else branch.
> 
> Specifically, I think it needs to be:
> 	if (msix) {
> 		if (irq == -EINVAL) {
> 			/* dynamically allocate interrupt */
> 		}
> 		get_cached_msi_msg(irq, &msg);
> 		pci_write_msi_msg(irq, &msg);
> 	}

Yes, that's looked wrong to me all along, I think that resolves it.
Thanks,

Alex

