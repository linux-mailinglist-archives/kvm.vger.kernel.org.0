Return-Path: <kvm+bounces-6429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20AB1831E72
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 18:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A56171F22377
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 17:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1E42D786;
	Thu, 18 Jan 2024 17:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qC+PgI3e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85E82D788
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 17:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705599213; cv=none; b=omxn1d7kq6+x6nnAJf4AY/rVnUGkUALbXczexv3K6K9QYNmk1uLN7QycdhjE2Mf+Z3PUhomuHRWdc6/i9rBySNYd4nrSIw6f/rejmqGJcrs9lYjL7JpNa/B3Y6s5lzVTalnECUNaUxH0++7VEqFRr23F69rUkOmjwPENRmri7Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705599213; c=relaxed/simple;
	bh=g2ihxYR0jMFIfw024Hzp+NZffZG3sqLyR4dYxJC9+8c=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=eSLaUdIqTfPoBxVP4NV6+hhByV5Iea/bOkOXpeoKEyMayCafKpFAupimge7CqqumE03J4jqyGG3cIFAdyARDDXX48lOuAc8f7ILXGQWXzF1ALeNCVhj0OHQZ1xxY3jsvlSVQl/PieamtAyOS/AGjgeJFWGwVI/Ay6Huksllq4j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qC+PgI3e; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc221ed88d9so4967719276.3
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 09:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705599211; x=1706204011; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oBJZf1LE/5X4g4KhTT5Os40N2yCWBiph02v2+TzxgRE=;
        b=qC+PgI3eZhE4ts3ZRAsuaW1USeHvjwSMpk913Z4qyHNrv0nhjORwlrviiyc6qtoDA+
         G4ov0dUvlvW6W0I/Ux33jSITBllvfbUf2yxLd276U5t7/mG6i1iUZuTINLXeoZK/WUL3
         NVCmMNL+O3L2YpPgJi+GTtHQ2TJr/oWbyk2bdkbDuSNWZg/c45CSpc6XDxP1D6pCHkhS
         Sv+HgWdEeVG/0VEnoWt9bxS2YvyUQVN4Ykf8A6HP9EDTmYR9olsKxRoPbpwkWgFFsVdV
         PnAHyuloYGKykddnnPAsbblzDkQBy5M0afMR5lC2zhPlejzLV3K+8YrypH536rUfLRBu
         F6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705599211; x=1706204011;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oBJZf1LE/5X4g4KhTT5Os40N2yCWBiph02v2+TzxgRE=;
        b=Y9ivNUDOpxAN14Ec5B+2oTNQBgb0RF9/3ltUZ8AoFgjj+9S0nrC2HmofoTSR5AqOkn
         rMEAZtYqCW5f4kMoLlWktOy4Vn0sKc1vn/b4PKNJ5Eay/9jpoLhZeu9UwBziVumWCPGU
         cylMjxhaOFQsKGolSAjwDSdRiTm7xC4yWbgtao65bp3ctjsLeS961gpLb6P8z6C5+iVE
         9FTBwiLvS6hhFfN1+tUuvPcuC7hj7BnIYHIrJa1JKBbU1LMmUQVl1TeaJj1ZXDFKe66W
         pj8iSI6LLKJ9iGlYCmdWny8NYMXrEC+w6NCEWGGgGKtntx9ijtH8SxbGkTjdNMySd4Za
         onbA==
X-Gm-Message-State: AOJu0YxOtnfpAVxMgn6JXlkWVtmhcHBL+C/CiPNlnOboYg+GYaTcS3wG
	gZiNSKan2tvk80Wqr1gfRKzJVGkLHe7A15Osz/nSnNovmF7ULYtmtiSkU7A6iVNEzyytiwUzlSw
	Qpg==
X-Google-Smtp-Source: AGHT+IEvyLNJgiC1Ob51GHOPvh3eIxRdUFAu33JenRa2llkKRTJk79qMN6F87V6uETIf5u5Is3/jgjvHSdU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:f08:b0:dbe:a0c2:df25 with SMTP id
 et8-20020a0569020f0800b00dbea0c2df25mr71287ybb.8.1705599210927; Thu, 18 Jan
 2024 09:33:30 -0800 (PST)
Date: Thu, 18 Jan 2024 09:33:29 -0800
In-Reply-To: <Zai6hJgTRegDaSfx@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240117064441.2633784-1-tao1.su@linux.intel.com>
 <ZafuSNu3ThHY8rfG@google.com> <Zai6hJgTRegDaSfx@linux.bj.intel.com>
Message-ID: <Zalg6UGBrCe68P-i@google.com>
Subject: Re: [PATCH] KVM: selftests: Add a requirement for disabling numa balancing
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org, 
	yi1.lai@intel.com, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

+David

On Thu, Jan 18, 2024, Tao Su wrote:
> On Wed, Jan 17, 2024 at 07:12:08AM -0800, Sean Christopherson wrote:
>=20
> [...]
>=20
> > > diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitt=
ing_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_te=
st.c
> > > index 634c6bfcd572..f2c796111d83 100644
> > > --- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_tes=
t.c
> > > +++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_tes=
t.c
> > > @@ -212,10 +212,21 @@ static void help(char *name)
> > > =20
> > >  int main(int argc, char *argv[])
> > >  {
> > > +	FILE *f;
> > >  	int opt;
> > > +	int ret, numa_balancing;
> > > =20
> > >  	TEST_REQUIRE(get_kvm_param_bool("eager_page_split"));
> > >  	TEST_REQUIRE(get_kvm_param_bool("tdp_mmu"));
> > > +	f =3D fopen("/proc/sys/kernel/numa_balancing", "r");
> > > +	if (f) {
> > > +		ret =3D fscanf(f, "%d", &numa_balancing);
> > > +		TEST_ASSERT(ret =3D=3D 1, "Error reading numa_balancing");
> > > +		TEST_ASSERT(!numa_balancing, "please run "
> > > +			    "'echo 0 > /proc/sys/kernel/numa_balancing'");
> >=20
> > If we go this route, this should be a TEST_REQUIRE(), not a TEST_ASSERT=
().  The
> > test hasn't failed, rather it has detected an incompatible setup.
>=20
> Yes, previously I wanted to print a more user-friendly prompt, but TEST_R=
EQUIRE()
> can=E2=80=99t customize the output=E2=80=A6

__TEST_REQUIRE()

> > Something isn't right though.  The test defaults to HugeTLB, and the in=
vocation
> > in the changelog doesn't override the backing source.  That suggests th=
at NUMA
> > auto-balancing is zapping HugeTLB VMAs, which AFAIK shouldn't happen, e=
.g. this
> > code in task_numa_work() should cause such VMAs to be skipped:
> >=20
> > 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
> > 			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
> > 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
> > 			continue;
> > 		}
> >=20
> > And the test already warns the user if they opt to use something other =
than
> > HugeTLB.
> >=20
> > 	if (!is_backing_src_hugetlb(backing_src)) {
> > 		pr_info("This test will only work reliably with HugeTLB memory. "
> > 			"It can work with THP, but that is best effort.\n");
> > 	}
> >=20
> > If the test is defaulting to something other than HugeTLB, then we shou=
ld fix
> > that in the test.  If the kernel is doing NUMA balancing on HugeTLB VMA=
s, then
> > we should fix that in the kernel.
>=20
> HugeTLB VMAs are not affected by NUMA auto-balancing through my observati=
on, but
> the backing sources of the test code and per-vCPU stacks are not Huge TLB=
, e.g.
> __vm_create() invokes
>=20
>         vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pa=
ges, 0);
>=20
> So, some pages are possible to be migrated.

Ah, hmm.  Requiring NUMA balancing be disabled isn't going to fix the under=
lying
issue, it's just guarding against one of the more likely culprits.  The bes=
t fix
is likely to have the test precisely validate _only_ the test data pages.  =
E.g.
if we double down on requiring HugeTLB, then the test should be able to ass=
ert
that it has at least N hugepages when dirty logging is disabled, and at lea=
st M
4KiB pages when dirty logging is enabled.

