Return-Path: <kvm+bounces-63630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3A7C6C139
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:03:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 262A94E433B
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92F721A9F91;
	Wed, 19 Nov 2025 00:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SQLkzPxe"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745A0171C9
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 00:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763510539; cv=none; b=pf5s+Roq5xIc88YLyO5VuBI18v5tSoNjC1DqFYeOwIhjUG8i+4Uc/f/2qyO40tcBtjNMVN4/7AddVAq/82ME5bQyBkd0Pe7Ru8iyKou0uh3HUh8YczxH6lxwQKQaEAU+nE41BUSJByEz+SmhQRfvL3+pkMP07ehXiwbMFK5eswQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763510539; c=relaxed/simple;
	bh=HJOC/VaE7XSk55yUzvKu6RDN1QSfhLqjqvoiu5uKexM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c+t4jJJqDB0hZRbGn8KIvp9pZ38zmwEbKbRxh+c34rTyJ+KryQtN2bXHoan4iQ5tnIoEIszukS2Kep/buCjsYQaXyNJNZ4AOt/Z3VvlfTaKdQbnKC2ZSvbzA+lqyzUnpxQHRnxMPZfEbBKsZl9DGOcYLGmtmhMkH0ty2kexj2Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SQLkzPxe; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 19 Nov 2025 00:01:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763510525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVn2BxTNh2F01trRlThXXGZKMzccY0TA4V29KUEg5jo=;
	b=SQLkzPxebn4FqpNt5ajg0r4WO7VCMvikPaonBIMypqNqpCo3MZHZvSYWdYHMEOcVBhMQ0n
	Da2ljjuED8Hj0cKBi3PdHNaV18mwOBOwnVaGXSHzXcrNCHnOTTHyr3O8DiYyVciRQiefD0
	KjedDDWy2ptyGAjCFnIMHJSmjbqYVLc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
Message-ID: <vh3yjo36ortltqjrcsegllzbpkmum2c5ywna25q3ah25txlv74@4edzsqjjs73c>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
 <n5cjwr3klovu7tqcchptvmr6yieyhvnv5muv7zyvcbo5itskew@6rzo4ohctdhv>
 <CALMp9eQuWx--Ef7Sxasq=MZMGPTg2ZUL0CXHH+Hvj7YEL_ipVg@mail.gmail.com>
 <gcyh7dlszzaj3wnp3fu3x6loedfhzds55kxvubxm53deb4yodm@3xk4mt32nf3j>
 <aR0GI81ZASDYeFP_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aR0GI81ZASDYeFP_@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 18, 2025 at 03:49:55PM -0800, Sean Christopherson wrote:
> On Tue, Nov 18, 2025, Yosry Ahmed wrote:
> > On Tue, Nov 18, 2025 at 03:00:26PM -0800, Jim Mattson wrote:
> > > On Tue, Nov 18, 2025 at 2:26 PM Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> > > >
> > > > On Tue, Oct 21, 2025 at 07:47:13AM +0000, Yosry Ahmed wrote:
> > > > > There are multiple selftests exercising nested VMX that are not specific
> > > > > to VMX (at least not anymore). Extend their coverage to nested SVM.
> > > > >
> > > > > This version is significantly different (and longer) than v1 [1], mainly
> > > > > due to the change of direction to reuse __virt_pg_map() for nested EPT/NPT
> > > > > mappings instead of extending the existing nested EPT infrastructure. It
> > > > > also has a lot more fixups and cleanups.
> > > > >
> > > > > This series depends on two other series:
> > > > > - "KVM: SVM: GIF and EFER.SVME are independent" [2]
> > > > > - "KVM: selftests: Add test of SET_NESTED_STATE with 48-bit L2 on 57-bit L1" [3]
> > > >
> > > > v2 of Jim's series switches all tests to use 57-bit by default when
> > > > available:
> > > > https://lore.kernel.org/kvm/20251028225827.2269128-4-jmattson@google.com/
> > > >
> > > > This breaks moving nested EPT mappings to use __virt_pg_map() because
> > > > nested EPTs are hardcoded to use 4-level paging, while __virt_pg_map()
> > > > will assume we're using 5-level paging.
> > > >
> > > > Patch #16 ("KVM: selftests: Use __virt_pg_map() for nested EPTs") will
> > > > need the following diff to make nested EPTs use the same paging level as
> > > > the guest:
> > > >
> > > > diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> > > > index 358143bf8dd0d..8bacb74c00053 100644
> > > > --- a/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > > +++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > > @@ -203,7 +203,7 @@ static inline void init_vmcs_control_fields(struct vmx_pages *vmx)
> > > >                 uint64_t ept_paddr;
> > > >                 struct eptPageTablePointer eptp = {
> > > >                         .memory_type = X86_MEMTYPE_WB,
> > > > -                       .page_walk_length = 3, /* + 1 */
> > > > +                       .page_walk_length = get_cr4() & X86_CR4_LA57 ? 4 : 3, /* + 1 */
> > > 
> > > LA57 does not imply support for 5-level EPT. (SRF, IIRC)
> 
> Yuuuup.  And similarly, MAXPHYADDR=52 doesn't imply 5-level EPT (thank you TDX!).
> 
> > Huh, that's annoying. We can keep the EPTs hardcoded to 4 levels and
> > pass in the max level to __virt_pg_map() instead of hardcoding
> > vm->pgtable_levels.
> 
> I haven't looked at the series in-depth so I don't know exactly what you're trying
> to do, but why not check MSR_IA32_VMX_EPT_VPID_CAP for PWL5?

The second part of the series reuses __virt_pg_map() to be used for
nested EPTs (and NPTs). __virt_pg_map() uses vm->pgtable_levels to find
out how many page table levels we have.

So we need to either:

(a) Always use the same number of levels for page tables and EPTs.

(b) Make __virt_pg_map() take the number of page table levels as a
  parameter, and always pass 4 for EPTs (for now).

I suggested (a) initially, but it doesn't work because we can
technically have LA57 but not MSR_IA32_VMX_EPT_VPID_CAP, so we need to
do (b). We can still check MSR_IA32_VMX_EPT_VPID_CAP and use PWL5 for
EPTs, but that's an orthogonal change at this point.

Anyway, do you prefer that I resend the series on top of Jim's v2, or do
you want to wait and see if you'll fix it up (or apply a part of it
before I rebase the rest)?

