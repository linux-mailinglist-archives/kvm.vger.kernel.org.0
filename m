Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79455E781A
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 12:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiIWKST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 06:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiIWKSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 06:18:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A70712FF24
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 03:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663928290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=scxMExLJuSOk6YialsYqvXx9LKNtmFAx0mLOa4lR8dk=;
        b=JlgakQkP3rKub2wA3aVpjVdyg1c9GVW40RjvujfGT5sV7u/W8IIUTxEmSd6wb4VO1/dtcY
        z1ck0b8P3BjN2I0Z16VkY7eDixqAuv79Pyttx6HvdRmFEm0g6lhNvfUsMpCM2ii6Cp+CX2
        fO7903xOPHwPh3gqeXEtPi2OsQnWWNs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-erE-49j_PxWKQuVe7RIHRw-1; Fri, 23 Sep 2022 06:18:06 -0400
X-MC-Unique: erE-49j_PxWKQuVe7RIHRw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C060F3826A41;
        Fri, 23 Sep 2022 10:18:05 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4562D492B07;
        Fri, 23 Sep 2022 10:18:04 +0000 (UTC)
Message-ID: <746314ef0b65c23f6748f5aa7c83328627d641e5.camel@redhat.com>
Subject: Re: [PATCH v2 04/23] KVM: x86: Inhibit AVIC SPTEs if any vCPU
 enables x2APIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Fri, 23 Sep 2022 13:18:03 +0300
In-Reply-To: <Yynva7GV+XpU0Llx@google.com>
References: <20220903002254.2411750-1-seanjc@google.com>
         <20220903002254.2411750-5-seanjc@google.com>
         <8a24c36efebfa4fb302587a74e3bc1e088e17be8.camel@redhat.com>
         <Yyngcg3ainoD0fNc@google.com> <Yynva7GV+XpU0Llx@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-09-20 at 16:50 +0000, Sean Christopherson wrote:
> On Tue, Sep 20, 2022, Sean Christopherson wrote:
> > On Tue, Sep 20, 2022, Maxim Levitsky wrote:
> > > On Sat, 2022-09-03 at 00:22 +0000, Sean Christopherson wrote:
> > > > Reintroduce APICV_INHIBIT_REASON_X2APIC as a "partial" inhibit for AMD
> > > > to fix a bug where the APIC access page is visible to vCPUs that have
> > > > x2APIC enabled, i.e. shouldn't be able to "see" the xAPIC MMIO region.
> > > > 
> > > > On AMD, due to its "hybrid" mode where AVIC is enabled when x2APIC is
> > > > enabled even without x2AVIC support, the bug occurs any time AVIC is
> > > > enabled as x2APIC is fully emulated by KVM.  I.e. hardware isn't aware
> > > > that the guest is operating in x2APIC mode.
> > > > 
> > > > Opportunistically drop the "can" while updating avic_activate_vmcb()'s
> > > > comment, i.e. to state that KVM _does_ support the hybrid mode.  Move
> > > > the "Note:" down a line to conform to preferred kernel/KVM multi-line
> > > > comment style.
> > > > 
> > > > Leave Intel as-is for now to avoid a subtle performance regression, even
> > > > though Intel likely suffers from the same bug.  On Intel, in theory the
> > > > bug rears its head only when vCPUs share host page tables (extremely
> > > > likely) and x2APIC enabling is not consistent within the guest, i.e. if
> > > > some vCPUs have x2APIC enabled and other does do not (unlikely to occur
> > > > except in certain situations, e.g. bringing up APs).
> > > 
> > > Are you sure about this?
> > 
> > Ah, no.  The key on Intel is the separate VMCS control for virtualizing xAPIC
> > accesses.  As you note below, KVM will provide memory semantics, which is technically
> > wrong.
> > 
> > > This is what I am thinking will happen, I might be wrong but I am not sure:
> > 
> > ...
> > 
> > > 3. guest accesses the 0xfee00xxx, assuming APICv/x2avic, the hardware won't redirect
> > > the access to apic backing page, but will instead just use that SPTE and let the guest
> > > read/write the private page that we mapped in the range, which is wrong.
> > > 
> > > Am I missing something?
> > 
> > No, I don't believe so.  I'm still hesitant to add the effetive inhibit to Intel,
> > though that's probably just pure paranoia at this point.  Probably makes sense to
> > just do it and verify that x2APIC virtualization still works.
> 
> Scratch that, Intel can end up with memory semantics irrespective of x2APIC, e.g.
> if APICv is enabled but a vCPU disables its APIC.  We could force a bus error by
> inhibiting APICv if any vCPU has its APIC hardware disabled, but IMO that's a bad
> tradeoff as there are legitimate reasons to disable the APIC on select vCPUs.
> 
> So, I'll omit Intel from the x2APIC pseudo-inhibit, and maybe add a KVM erratum
> to document that KVM may provide memory semantics for APIC_BASE when APICv/AVIC
> is enabled.
> 

I can agree with this - disabled APIC is indeed a valid use case, if a VM doesn't
use all the vCPUs it was assigned, and hotplugs them later.

Thus I can agree to leave it as is for Intel, although if our goal is to be as
close to x86 spec as possible as you said, then it is more correct to do it as I suggested,
because it is still better to be compliant to the x86 spec in one case of two,
that to be compliant in none of the cases.

I am not going to argue about this though.


Best regards,
	Maxim Levitsky

