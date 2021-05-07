Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E3C3793AB
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhEJQZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:25:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231553AbhEJQZC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 12:25:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620663837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P2vj3NODEAJFkjQoNo9vCplQyIjKM21IbWPxOEOj3Ns=;
        b=ZKFr0LAreixNic9B7KSZSED0JrEG7xVw9n3GGzB44ntJn2GSCOO/YnUcahFREkikaSrV7O
        Udswxz5dDGIS/+gQ67uEBNsXJoMXzBHKBpfyD+Lxc1SH/HB8zRTmNTaigaey0wfvoCSMum
        L8Q6u65iS5J1LgsfW2BWZvIOGdsaosk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-QDslovsoMjeb8-mc8tqllw-1; Mon, 10 May 2021 12:23:55 -0400
X-MC-Unique: QDslovsoMjeb8-mc8tqllw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A2C3802939;
        Mon, 10 May 2021 16:23:54 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-8.gru2.redhat.com [10.97.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB849100164A;
        Mon, 10 May 2021 16:23:46 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 06A2A41887F4; Fri,  7 May 2021 19:08:32 -0300 (-03)
Date:   Fri, 7 May 2021 19:08:31 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <20210507220831.GA449495@fuller.cnet>
References: <20210507130609.269153197@redhat.com>
 <20210507130923.528132061@redhat.com>
 <YJV3P4mFA7pITziM@google.com>
 <YJWVAcIsvCaD7U0C@t490s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJWVAcIsvCaD7U0C@t490s>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 03:29:05PM -0400, Peter Xu wrote:
> On Fri, May 07, 2021 at 05:22:07PM +0000, Sean Christopherson wrote:
> > On Fri, May 07, 2021, Marcelo Tosatti wrote:
> > > Index: kvm/arch/x86/kvm/vmx/posted_intr.c
> > > ===================================================================
> > > --- kvm.orig/arch/x86/kvm/vmx/posted_intr.c
> > > +++ kvm/arch/x86/kvm/vmx/posted_intr.c
> > > @@ -203,6 +203,25 @@ void pi_post_block(struct kvm_vcpu *vcpu
> > >  	local_irq_enable();
> > >  }
> > >  
> > > +int vmx_vcpu_check_block(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> > > +
> > > +	if (!irq_remapping_cap(IRQ_POSTING_CAP))
> > > +		return 0;
> > > +
> > > +	if (!kvm_vcpu_apicv_active(vcpu))
> > > +		return 0;
> > > +
> > > +	if (!kvm_arch_has_assigned_device(vcpu->kvm))
> > > +		return 0;
> > > +
> > > +	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR)
> > > +		return 0;
> > > +
> > > +	return 1;
> > 
> > IIUC, the logic is to bail out of the block loop if the VM has an assigned
> > device, but the blocking vCPU didn't reconfigure the PI.NV to the wakeup vector,
> > i.e. the assigned device came along after the initial check in vcpu_block().
> > That makes sense, but you can add a comment somewhere in/above this function?
> 
> Wondering whether we should add a pi_test_on() check in kvm_vcpu_has_events()
> somehow, so that even without customized ->vcpu_check_block we should be able
> to break the block loop (as kvm_arch_vcpu_runnable will return true properly)?

static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
{
        int ret = -EINTR;
        int idx = srcu_read_lock(&vcpu->kvm->srcu);

        if (kvm_arch_vcpu_runnable(vcpu)) {
                kvm_make_request(KVM_REQ_UNHALT, vcpu); <---
                goto out;
        }

Don't want to unhalt the vcpu.

