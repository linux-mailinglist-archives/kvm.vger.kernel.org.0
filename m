Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F9327CF7E
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 15:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbgI2Nj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 09:39:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730363AbgI2Nj5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 09:39:57 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601386796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B9TkhrmyyZDsjRPmcvznIh/VnqkIyiWZGCewhMqECL4=;
        b=LtjS6UKMPZrGBTxdgeCHrBuQCRtJKLtZhjP0+NNi1GjN4h77s6fVtgIJBV3rRxd+c6t/RU
        u67+uIwG9tRbFpHsOIKhvMh3J12/71ttZMtxUcff0qlNib6v7D90RdK/6QzdZORz4CZ+hY
        zE952hzqpvod5gUkxzuausQqgEjKzE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-SeQCGutKOAuvTDSF4FFZew-1; Tue, 29 Sep 2020 09:39:54 -0400
X-MC-Unique: SeQCGutKOAuvTDSF4FFZew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D80AE10A7AED;
        Tue, 29 Sep 2020 13:39:51 +0000 (UTC)
Received: from ovpn-66-32.rdu2.redhat.com (ovpn-66-32.rdu2.redhat.com [10.10.66.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FAE873663;
        Tue, 29 Sep 2020 13:39:47 +0000 (UTC)
Message-ID: <2063b592f82f680edf61dad575f7c092d11d8ba3.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address
 space support user-configurable
From:   Qian Cai <cai@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 29 Sep 2020 09:39:46 -0400
In-Reply-To: <ebcd39a5-364f-c4ac-f8c7-41057a3d84be@redhat.com>
References: <20200903141122.72908-1-mgamal@redhat.com>
         <1f42d8f084083cdf6933977eafbb31741080f7eb.camel@redhat.com>
         <e1dee0fd2b4be9d8ea183d3cf6d601cf9566fde9.camel@redhat.com>
         <ebcd39a5-364f-c4ac-f8c7-41057a3d84be@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-09-29 at 14:26 +0200, Paolo Bonzini wrote:
> On 29/09/20 13:59, Qian Cai wrote:
> > WARN_ON_ONCE(!allow_smaller_maxphyaddr);
> > 
> > I noticed the origin patch did not have this WARN_ON_ONCE(), but the
> > mainline
> > commit b96e6506c2ea ("KVM: x86: VMX: Make smaller physical guest address
> > space
> > support user-configurable") does have it for some reasons.
> 
> Because that part of the code should not be reached.  The exception
> bitmap is set up with
> 
>         if (!vmx_need_pf_intercept(vcpu))
>                 eb &= ~(1u << PF_VECTOR);
> 
> where
> 
> static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
> {
>         if (!enable_ept)
>                 return true;
> 
>         return allow_smaller_maxphyaddr &&
> 		 cpuid_maxphyaddr(vcpu) < boot_cpu_data.x86_phys_bits;
> }
> 
> We shouldn't get here if "enable_ept && !allow_smaller_maxphyaddr",
> which implies vmx_need_pf_intercept(vcpu) == false.  So the warning is
> genuine; I've sent a patch.

Care to provide a link to the patch? Just curious.

