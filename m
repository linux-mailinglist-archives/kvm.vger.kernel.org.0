Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEB03EF081
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 18:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhHQQ5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 12:57:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229716AbhHQQ5f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 12:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629219421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N8fk9dyqoHqd6thXq2i0r02OOqqMEj92eeCAxjRFg6A=;
        b=EMFEnDtvbkiJ3J4jiiZmxYK3W/2RPEpMP9EyoCFqXJ813H8E7dLqmiJtmJQojJS87wZz53
        PHrOI6q22LsZa3vTM0iqY1PkpYIoo2zsKuNIFX0mN7846uzmZxxLbI0ZFTcC41GfLVRhLU
        uCG2ki/0zBHEklY4xSfqtfRwW12NUVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-hBU-4FelOF-UzLtWZVU1MA-1; Tue, 17 Aug 2021 12:56:59 -0400
X-MC-Unique: hBU-4FelOF-UzLtWZVU1MA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B67541082927;
        Tue, 17 Aug 2021 16:56:57 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 641EA5DAA5;
        Tue, 17 Aug 2021 16:56:56 +0000 (UTC)
Message-ID: <898a20e1021f51492e086c918a2d62334a81732e.camel@redhat.com>
Subject: Re: RFC: Proposal to create a new version of the SVM nested state
 migration blob
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Date:   Tue, 17 Aug 2021 19:56:55 +0300
In-Reply-To: <59a55bd1-6254-311c-b087-ce54f6a9e1e8@redhat.com>
References: <332b6896f595282ea3d261095612fd31ce4cf14f.camel@redhat.com>
         <1ff7a205-283d-d2b3-d130-e40066f59df0@redhat.com>
         <efd07fdb5646e6a983d234a0e0bed8db6da4a890.camel@redhat.com>
         <59a55bd1-6254-311c-b087-ce54f6a9e1e8@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-08-17 at 18:50 +0200, Paolo Bonzini wrote:
> On 17/08/21 18:40, Maxim Levitsky wrote:
> > I proposed that on nested entry we leave the processor values in vmcb01,
> > as is, and backup the guest visible values in say 'svm->nested.hsave.cr*'
> > or something like that.
> > Later on nested VM exit we restore vcpu.arch.cr* values from 'svm->nested.hsave.cr*'
> > and leave the vmcb01 values alone.
> >   
> > That isn't strictly related to nested migration state but it seemed
> > to me that it would be also nice to have both guest visible
> > and cpu visible values of L1 save state in migration state
> > as well while we are at redefining it.
> 
> But the CPU visible values for L1 are useless, aren't they?  They are 
> computed on another system.  So you have to compute them again on the 
> destination.

I understand what you mean, and I agree with you.

> 
> So this idea, which is strictly speaking an optimization of vmexit, is 
> unrelated from migration and I would leave it aside.
> 
> > > So your proposal would basically be to:
> > > 
> > > * do the equivalent of sync_vmcs02_to_vmcs12+sync_vmcs02_to_vmcs12_rare
> > > on KVM_GET_NESTED_STATE
> > > 
> > > * discard the current state on KVM_SET_NESTED_STATE.
> > 
> > I did indeed overlook the fact that vmcb12 save area is not up to date,
> > in fact I probably won't even want to read it from the guest memory
> > at the KVM_GET_NESTED_STATE time. But it can be constructed from the
> > KVM's guest visible CR* values, and values in the VMCB02, roughly like
> > how sync_vmcs02_to_vmcs12, or how nested_svm_vmexit does it.
> 
> Right.
> 
> > The core of my proposal is that while it indeed makes the retrieval of the
> > nested state a bit more complicated, but it makes restore of the nested state
> > much simpler, since it can be treated as if we are just doing a nested entry,
> > eliminating the various special cases we have to have in nested state load on SVM.
> 
> This is true.
> 
> > Security wise, a bug during retrieval, isn't as bad as a bug during loading of the
> > state, so it makes sense to make the load of the state share as much code
> > with normal nested entry.
> > 
> > That means that the whole VMCB12 image can be checked as a whole and loaded
> > replacing most of the existing cpu state, in the same manner to regular
> > nested entry.
> >   
> > This also makes nested state load less dependant on its ordering vs setting of
> > the other cpu state.
> > 
> > So what do you think? Is it worth it for me to write a RFC patch series for this?
> 
> I have a slightly different idea.  Do you think it would make sense to 
> use the current processor state to build the VMCB12?  Such a prototype 
> would show what KVM_SET_NESTED_STATE would look like with your new blob 
> format.  We could use that to see if it worth proceeding further, with 
> three possible answer:
> 
> 1) the new KVM_SET_NESTED_STATE remains complex, so we scrap the idea
> 
> 2) the new KVM_SET_NESTED_STATE is nice, and we decide it's already good 
> enough
> 
> 3) the new KVM_SET_NESTED_STATE is nice, but there is enough ugliness 
> left that the new format seems worthwhile

I like this idea! I will prepare a prototype for this soon.

Thanks a lot for the help!

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


