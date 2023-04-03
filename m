Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542996D523C
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 22:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbjDCUXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 16:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjDCUXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 16:23:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E1C3586
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 13:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680553353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S7rPZVgCNxYpms8L6srVacst89M/965rzuu68j74ShQ=;
        b=MxVFSQXpE1yDvQdRsVgQI5eiMSw8okNEdeYjOIXHu1oKjcDhwDm360EZuekNOyP49fkgkL
        6wIKjWloCvbos6rNc5E2EjV8TqvSIBEjRDe3e8XncjZf3+W8Y6CPT92Kp/WrZ9gHsdUoXv
        cBibeH/1KeTDRaVT6tFfoS4XBIIW0a0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-qcusORVfPBCq1QvgBPiKfA-1; Mon, 03 Apr 2023 16:22:31 -0400
X-MC-Unique: qcusORVfPBCq1QvgBPiKfA-1
Received: by mail-il1-f198.google.com with SMTP id h1-20020a92d841000000b0031b4d3294dfso19896225ilq.9
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 13:22:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680553351;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S7rPZVgCNxYpms8L6srVacst89M/965rzuu68j74ShQ=;
        b=AoCK8dD+eKqfBbrkNp0LfB6WFdpYF+Ne9AVfEo/x5QdvvYkJ0knKapSuAayPJqz3gz
         U5ihV7M7pbteJmhw0KxQEAafCbncRKEtCzMo/gLw73DK1Tc+gnYkdQ3acO/6W0urgUze
         RigSVr5+dwNQ9qK8PnXF6Jkcbtg4ANZf8VuSSlR3AtbzMdCawpPw3xSJFn404FudZKAp
         mr/gjtlHc9C9YoRd4/IX0s+biiJ7QXLwxkydRh2D3Ygw1PfatGebqcoyZXOuuQ36mMBN
         RG7CZtRjXw+py8U3cKpafSTtu97wy6WT9Z3rxxL6eG93Jq9TTyS1N9evTpYOPwiDqIiO
         81eQ==
X-Gm-Message-State: AAQBX9ftxxebxT60TR9/Osg3LndmJycfY2Y0/vEuB/so7pgPpNSZziAO
        7jwBl7CiUgMa3lzlTP2NS9X4dbcgdaNpnaDOJNpkQI377UqTtFY0MBWUbFCjvWkMzVz3Pfds4wR
        ECcfnxHzb26ao
X-Received: by 2002:a92:d28f:0:b0:325:b60b:e2fc with SMTP id p15-20020a92d28f000000b00325b60be2fcmr259887ilp.5.1680553351138;
        Mon, 03 Apr 2023 13:22:31 -0700 (PDT)
X-Google-Smtp-Source: AKy350a8n73fR0AsmRQ+fkeyssYMI9r59U0Zgbvv0cUqAVRqPsNVu/XWz5p7fAdegvqaeMHPjs/SUQ==
X-Received: by 2002:a92:d28f:0:b0:325:b60b:e2fc with SMTP id p15-20020a92d28f000000b00325b60be2fcmr259865ilp.5.1680553350833;
        Mon, 03 Apr 2023 13:22:30 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t8-20020a056638204800b003eafd76dc3fsm2928827jaj.23.2023.04.03.13.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:22:30 -0700 (PDT)
Date:   Mon, 3 Apr 2023 14:22:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Message-ID: <20230403142227.1328b373.alex.williamson@redhat.com>
In-Reply-To: <e15d588e-b63f-ab70-f6ae-91ceea8be79a@intel.com>
References: <cover.1680038771.git.reinette.chatre@intel.com>
        <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
        <20230330164050.0069e2a5.alex.williamson@redhat.com>
        <20230330164214.67ccbdfa.alex.williamson@redhat.com>
        <688393bf-445c-15c5-e84d-1c16261a4197@intel.com>
        <20230331162456.3f52b9e3.alex.williamson@redhat.com>
        <e15d588e-b63f-ab70-f6ae-91ceea8be79a@intel.com>
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

On Mon, 3 Apr 2023 10:31:23 -0700
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Alex,
> 
> On 3/31/2023 3:24 PM, Alex Williamson wrote:
> > On Fri, 31 Mar 2023 10:49:16 -0700
> > Reinette Chatre <reinette.chatre@intel.com> wrote:  
> >> On 3/30/2023 3:42 PM, Alex Williamson wrote:  
> >>> On Thu, 30 Mar 2023 16:40:50 -0600
> >>> Alex Williamson <alex.williamson@redhat.com> wrote:
> >>>     
> >>>> On Tue, 28 Mar 2023 14:53:34 -0700
> >>>> Reinette Chatre <reinette.chatre@intel.com> wrote:
> >>>>    
> 
> ...
> 
> >>>>> +		msix_map.index = vector;
> >>>>> +		msix_map.virq = irq;
> >>>>> +		pci_msix_free_irq(pdev, msix_map);
> >>>>> +	}
> >>>>> +	vfio_pci_memory_unlock_and_restore(vdev, cmd);
> >>>>>  out_put_eventfd_ctx:
> >>>>>  	eventfd_ctx_put(trigger);
> >>>>>  out_free_name:
> >>>>>  	kfree(ctx->name);
> >>>>>  	ctx->name = NULL;
> >>>>> +out_free_ctx:
> >>>>> +	if (allow_dyn_alloc && new_ctx)
> >>>>> +		vfio_irq_ctx_free(vdev, ctx, vector);
> >>>>>  	return ret;
> >>>>>  }
> >>>>>        
> >>>>
> >>>> Do we really need the new_ctx test in the above cases?  Thanks,    
> >>
> >> new_ctx is not required for correctness but instead is used to keep
> >> the code symmetric. 
> >> Specifically, if the user enables MSI-X without providing triggers and
> >> then later assign triggers then an error path without new_ctx would unwind
> >> more than done in this function, it would free the context that
> >> was allocated within vfio_msi_enable().   
> > 
> > Seems like we already have that asymmetry, if a trigger is unset we'll
> > free the ctx allocated by vfio_msi_enable().  Tracking which are  
> 
> Apologies, but could you please elaborate on where the asymmetry is? I am
> not able to see a flow in this solution where the ctx allocated by
> vfio_msi_enable() is freed if the trigger is unset.

The user first calls SET_IRQS to enable MSI-X with some number of
vectors with (potentially) an eventfd for each vector.  The user later
calls SET_IRQS passing a -1 eventfd for one or more of the vectors with
an eventfd initialized in the prior step.  Given that we find the ctx,
the ctx has a trigger, and assuming dynamic allocation is supported, the
ctx is freed and vfio_msi_set_vector_signal() returns w/o allocating a
new ctx.  We've de-allocated both the irq and context initialized from
vfio_msi_enable().

> > allocated where is unnecessarily complex, how about a policy that  
> 
> I do not see this as tracking where allocations are made. Instead I
> see it as containing/compartmentalizing state changes with the goal of
> making the code easier to understand and maintain. Specifically, new_ctx
> is used so that if vfio_msi_set_vector_signal() fails, the state 
> before and after vfio_msi_set_vector_signal() will be the same.

That's not really possible given how we teardown the existing ctx
before configuring the new one and unwind to disable contexts in
vfio_msi_set_block()

> I do agree that it makes vfio_msi_set_vector_signal() more complex
> and I can remove new_ctx if you find that this is unnecessary after
> considering the motivations behind its use. 

If the goal is to allow the user to swap one eventfd for another, where
the result will always be the new eventfd on success or the old eventfd
on error, I don't see that this code does that, or that we've ever
attempted to make such a guarantee.  If the ioctl errors, I think the
eventfds are generally deconfigured.   We certainly have the unwind code
that we discussed earlier that deconfigures all the vectors previously
touched in the loop (which seems to be another path where we could
de-allocate from the set of initial ctxs).
 
> > devices supporting vdev->has_dyn_msix only ever have active contexts
> > allocated?  Thanks,  
> 
> What do you see as an "active context"? A policy that is currently enforced
> is that an allocated context always has an allocated interrupt associated
> with it. I do not see how this could be expanded to also require an
> enabled interrupt because interrupt enabling requires a trigger that
> may not be available.

A context is essentially meant to track a trigger, ie. an eventfd
provided by the user.  In the static case all the irqs are necessarily
pre-allocated, therefore we had no reason to consider a dynamic array
for the contexts.  However, a given context is really only "active" if
it has a trigger, otherwise it's just a placeholder.  When the
placeholder is filled by an eventfd, the pre-allocated irq is enabled.

This proposal seems to be a hybrid approach, pre-allocating some
initial set of irqs and contexts and expecting the differentiation to
occur only when new vectors are added, though we have some disagreement
about this per above.  Unfortunately I don't see an API to enable MSI-X
without some vectors, so some pre-allocation of irqs seems to be
required regardless.

But if non-active contexts were only placeholders in the pre-dynamic
world and we now manage them via a dynamic array, why is there any
pre-allocation of contexts without knowing the nature of the eventfd to
fill it?  We could have more commonality between cases if contexts are
always dynamically allocated, which might simplify differentiation of
the has_dyn_msix cases largely to wrappers allocating and freeing irqs.
Thanks,

Alex

