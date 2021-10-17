Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F96D430721
	for <lists+kvm@lfdr.de>; Sun, 17 Oct 2021 09:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241481AbhJQH4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Oct 2021 03:56:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54695 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234234AbhJQH4h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 17 Oct 2021 03:56:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634457267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+0osY3/SAm8vFbOEyznQ3BBtqYdhl6eYu7QQs/YzIGE=;
        b=bhtjJvOCBwpW4PmCSKdCGOupZZ9Nb/GVVIshEkwd7zm2ToQK2dWEoUEXOcdgSgKq8Y82GU
        wtRbUPbG9VkRLQJYWidNif3U2REMf+7rKk3ISPLbu5uj0mYY+zMxCWBLJ9dYJOjcYmek0Q
        H+2umQ2qGL2hThiIiP7eCYqJSNfhbaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-lYQW2WO-P8Cx1coOwejEIA-1; Sun, 17 Oct 2021 03:54:22 -0400
X-MC-Unique: lYQW2WO-P8Cx1coOwejEIA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03F3B800685;
        Sun, 17 Oct 2021 07:54:21 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F78F5C1C5;
        Sun, 17 Oct 2021 07:54:17 +0000 (UTC)
Message-ID: <eaddf15f13aa688c03d53831c2309a60957bb7f4.camel@redhat.com>
Subject: Re: [PATCH RFC] KVM: SVM: reduce guest MAXPHYADDR by one in case
 C-bit is a physical bit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Matlack <dmatlack@google.com>,
        linux-kernel@vger.kernel.org
Date:   Sun, 17 Oct 2021 10:54:16 +0300
In-Reply-To: <YWmdLPsa6qccxtEa@google.com>
References: <20211015150524.2030966-1-vkuznets@redhat.com>
         <YWmdLPsa6qccxtEa@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-15 at 15:24 +0000, Sean Christopherson wrote:
> On Fri, Oct 15, 2021, Vitaly Kuznetsov wrote:
> > Several selftests (memslot_modification_stress_test, kvm_page_table_test,
> > dirty_log_perf_test,.. ) which rely on vm_get_max_gfn() started to fail
> > since commit ef4c9f4f65462 ("KVM: selftests: Fix 32-bit truncation of
> > vm_get_max_gfn()") on AMD EPYC 7401P:
> > 
> >  ./tools/testing/selftests/kvm/demand_paging_test
> >  Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> >  guest physical test memory offset: 0xffffbffff000
> 
> This look a lot like the signature I remember from the original bug[1].  I assume
> you're hitting the magic HyperTransport region[2].  I thought that was fixed, but
> the hack-a-fix for selftests never got applied[3].

Hi Vitaly and everyone!

You are the 3rd person to suffer from this issue :-( Sean Christopherson was first, I was second.

I reported this, then I think we found out that it is not the HyperTransport region after all,
and I think that the whole thing lost in 'trying to get answers from AMD'.

https://lore.kernel.org/lkml/ac72b77c-f633-923b-8019-69347db706be@redhat.com/


I'll say, a hack to reduce it by 1 bit is still better that failing tests,
at least until AMD explains to us, about what is going on.

Sorry that you had to debug this.

Best regards,
	Maxim Levitsky 


> 
> [1] https://lore.kernel.org/lkml/20210623230552.4027702-4-seanjc@google.com/
> [2] https://lkml.kernel.org/r/7e3a90c0-75a1-b8fe-dbcf-bda16502ace9@amd.com
> [3] https://lkml.kernel.org/r/20210805105423.412878-1-pbonzini@redhat.com
> 
> >  Finished creating vCPUs and starting uffd threads
> >  Started all vCPUs
> >  ==== Test Assertion Failure ====
> >    demand_paging_test.c:63: false
> >    pid=47131 tid=47134 errno=0 - Success
> >       1	0x000000000040281b: vcpu_worker at demand_paging_test.c:63
> >       2	0x00007fb36716e431: ?? ??:0
> >       3	0x00007fb36709c912: ?? ??:0
> >    Invalid guest sync status: exit_reason=SHUTDOWN
> > 
> > The commit, however, seems to be correct, it just revealed an already
> > present issue. AMD CPUs which support SEV may have a reduced physical
> > address space, e.g. on AMD EPYC 7401P I see:
> > 
> >  Address sizes:  43 bits physical, 48 bits virtual
> > 
> > The guest physical address space, however, is not reduced as stated in
> > commit e39f00f60ebd ("KVM: x86: Use kernel's x86_phys_bits to handle
> > reduced MAXPHYADDR"). This seems to be almost correct, however, APM has one
> > more clause (15.34.6):
> > 
> >   Note that because guest physical addresses are always translated through
> >   the nested page tables, the size of the guest physical address space is
> >   not impacted by any physical address space reduction indicated in CPUID
> >   8000_001F[EBX]. If the C-bit is a physical address bit however, the guest
> >   physical address space is effectively reduced by 1 bit.
> > 
> > Implement the reduction.
> > 
> > Fixes: e39f00f60ebd (KVM: x86: Use kernel's x86_phys_bits to handle reduced MAXPHYADDR)
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---
> > - RFC: I may have misdiagnosed the problem as I didn't dig to where exactly
> >  the guest crashes.
> > ---
> >  arch/x86/kvm/cpuid.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 751aa85a3001..04ae280a0b66 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -923,13 +923,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >  		 *
> >  		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
> >  		 * provided, use the raw bare metal MAXPHYADDR as reductions to
> > -		 * the HPAs do not affect GPAs.
> > +		 * the HPAs do not affect GPAs. The value, however, has to be
> > +		 * reduced by 1 in case C-bit is a physical bit (APM section
> > +		 * 15.34.6).
> >  		 */
> > -		if (!tdp_enabled)
> > +		if (!tdp_enabled) {
> >  			g_phys_as = boot_cpu_data.x86_phys_bits;
> > -		else if (!g_phys_as)
> > +		} else if (!g_phys_as) {
> >  			g_phys_as = phys_as;
> >  
> > +			if (kvm_cpu_cap_has(X86_FEATURE_SEV) &&
> > +			    (cpuid_ebx(0x8000001f) & 0x3f) < g_phys_as)
> > +				g_phys_as -= 1;
> 
> This is incorrect, non-SEV guests do not see a reduced address space.  See Tom's
> explanation[*]
> 
> [*] https://lkml.kernel.org/r/324a95ee-b962-acdf-9bd7-b8b23b9fb991@amd.com
> 
> > +		}
> > +
> >  		entry->eax = g_phys_as | (virt_as << 8);
> >  		entry->edx = 0;
> >  		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
> > -- 
> > 2.31.1
> > 


