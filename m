Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95156AEF8A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 18:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436783AbfIJQ1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 12:27:55 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:55174 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436679AbfIJQ1z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Sep 2019 12:27:55 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5CA3A307483A;
        Tue, 10 Sep 2019 19:27:52 +0300 (EEST)
Received: from localhost (unknown [195.210.5.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3C3B8303A562;
        Tue, 10 Sep 2019 19:27:52 +0300 (EEST)
From:   Adalbert =?iso-8859-2?b?TGF643I=?= <alazar@bitdefender.com>
Subject: Re: [RFC PATCH v6 69/92] kvm: x86: keep the page protected if tracked
 by the introspection tool
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?iso-8859-2?b?S3LobeH4?= <rkrcmar@redhat.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C <yu.c.zhang@intel.com>,
        Mihai =?UTF-8?b?RG9uyJt1?= <mdontu@bitdefender.com>
In-Reply-To: <20190910142642.GC5879@char.us.oracle.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
        <20190809160047.8319-70-alazar@bitdefender.com>
        <20190910142642.GC5879@char.us.oracle.com>
Date:   Tue, 10 Sep 2019 19:28:19 +0300
Message-ID: <15681328990.F582D7fCB.15355@host>
User-agent: void
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Sep 2019 10:26:42 -0400, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Fri, Aug 09, 2019 at 07:00:24PM +0300, Adalbert Lazăr wrote:
> > This patch might be obsolete thanks to single-stepping.
> 
> sooo should it be skipped from this large patchset to easy
> review?

I'll add a couple of warning messages to check if this patch is still
needed, in order to skip it from the next submission (which will be smaller:)

However, on AMD, single-stepping is not an option.

Thanks,
Adalbert

> 
> > 
> > Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
> > ---
> >  arch/x86/kvm/x86.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 2c06de73a784..06f44ce8ed07 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -6311,7 +6311,8 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
> >  		indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
> >  		spin_unlock(&vcpu->kvm->mmu_lock);
> >  
> > -		if (indirect_shadow_pages)
> > +		if (indirect_shadow_pages
> > +		    && !kvmi_tracked_gfn(vcpu, gpa_to_gfn(gpa)))
> >  			kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> >  
> >  		return true;
> > @@ -6322,7 +6323,8 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
> >  	 * and it failed try to unshadow page and re-enter the
> >  	 * guest to let CPU execute the instruction.
> >  	 */
> > -	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> > +	if (!kvmi_tracked_gfn(vcpu, gpa_to_gfn(gpa)))
> > +		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> >  
> >  	/*
> >  	 * If the access faults on its page table, it can not
> > @@ -6374,6 +6376,9 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
> >  	if (!vcpu->arch.mmu->direct_map)
> >  		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
> >  
> > +	if (kvmi_tracked_gfn(vcpu, gpa_to_gfn(gpa)))
> > +		return false;
> > +
> >  	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> >  
> >  	return true;
