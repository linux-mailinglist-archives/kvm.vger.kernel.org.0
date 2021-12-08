Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0342C46D65B
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 16:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhLHPHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 10:07:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229496AbhLHPHV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 10:07:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638975829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2jrd2Kf9So+x8Xz8AeO7h4+6EIMVdYK/e/smQ/H8MM=;
        b=f6Aq8dbIU1Gh0qzz5/zABRu0zkITXm0KVFJ/0RD3i4DQTNZYNpM9SgArRGcKE40xXhQFI/
        J9KxuNbY+Po0k23gfuE5FJJTPzxV47aPkFaSW+uymOgrxdQkSP8wXHryduB4sYddALsvpl
        SuwBcaKYJP0+/oHVTOwS6HoaZmWmn30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-cf0uzvLzM2eUCw3rji32Lg-1; Wed, 08 Dec 2021 10:03:45 -0500
X-MC-Unique: cf0uzvLzM2eUCw3rji32Lg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6647802C99;
        Wed,  8 Dec 2021 15:03:42 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E4F019724;
        Wed,  8 Dec 2021 15:03:38 +0000 (UTC)
Message-ID: <f5b75c4d99c1f9e94ab9e639bc2fc8fddb9c7366.camel@redhat.com>
Subject: Re: [PATCH v3 21/26] KVM: SVM: Drop AVIC's intermediate
 avic_set_running() helper
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 08 Dec 2021 17:03:37 +0200
In-Reply-To: <e1c4ec6a-7c1e-b96c-63e6-d07b35820def@redhat.com>
References: <20211208015236.1616697-1-seanjc@google.com>
         <20211208015236.1616697-22-seanjc@google.com>
         <e1c4ec6a-7c1e-b96c-63e6-d07b35820def@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-12-08 at 15:43 +0100, Paolo Bonzini wrote:
> On 12/8/21 02:52, Sean Christopherson wrote:
> > +	/*
> > +	 * Unload the AVIC when the vCPU is about to block,_before_  the vCPU
> > +	 * actually blocks.  The vCPU needs to be marked IsRunning=0 before the
> > +	 * final pass over the vIRR via kvm_vcpu_check_block().  Any IRQs that
> > +	 * arrive before IsRunning=0 will not signal the doorbell, i.e. it's
> > +	 * KVM's responsibility to ensure there are no pending IRQs in the vIRR
> > +	 * after IsRunning is cleared, prior to scheduling out the vCPU.
> 
> I prefer to phrase this around paired memory barriers and the usual 
> store/smp_mb/load lockless idiom:
> 
> 	/*
> 	 * Unload the AVIC when the vCPU is about to block, _before_
> 	 * the vCPU actually blocks.
> 	 *
> 	 * Any IRQs that arrive before IsRunning=0 will not cause an
> 	 * incomplete IPI vmexit on the source, therefore vIRR will also
> 	 * be checked by kvm_vcpu_check_block() before blocking.  The
> 	 * memory barrier implicit in set_current_state orders writing

If I understand correctly this is a full memory barrier and not only a write barrier?

 
Also, just to document, I also found out that lack of subsequent vIRR checking
in the 'KVM: SVM: Unconditionally mark AVIC as running on vCPU load (with APICv)'
is what made AVIC totally unusable on my systems.
That patch would set is_running right in the middle of schedule() and then
no vIRR check would be done afterwards.
 
Small update on my adventures with AVIC: On two Milan machines I got my hands on,
on both AVIC is disabled in CPUID, but seems to work. None of my reproducers
manage to hit that errata and on top of that I have set of patches that make
AVIC co-exist with nesting and it appears to work while stress tested with
my KVM unit test which I updated to run a nested guest on one of the vCPUs.
I mostly testing the second machine though this week.
 
I'll post my patches as soon as I rebase them on top of this patch series,
after I review it.
I’ll post the unit test soon too.
 
Still my gut feeling is that the errata is still there - I am still waiting for
AMD to provide any info they could on this.


Best regards,
	Maxim Levitsky


> 	 * IsRunning=0 before reading the vIRR.  The processor needs a
> 	 * matching memory barrier on interrupt delivery between writing
> 	 * IRR and reading IsRunning; the lack of this barrier might be
> 	 * the cause of errata #1235).
> 	 */
> 
> Is there any nuance that I am missing?
> 
> Paolo
> 
> > +	 */
> > +	avic_vcpu_put(vcpu);
> > +


