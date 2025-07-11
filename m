Return-Path: <kvm+bounces-52117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA150B01908
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:00:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70C2E1CA76AA
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4858E279DA0;
	Fri, 11 Jul 2025 09:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="s2GEQA1a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DF127E1C0;
	Fri, 11 Jul 2025 09:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752227988; cv=none; b=jIRigsgQfMeDZoafUcqjcGyswAcmEDI+9QhGdYyxcm9dyRkREM9V01rt2bm4V/4TnTY3YyVukUQiPHRiqucWoWKA+84sm+rlaZjVfZcbKjo7sqYSuO1128x/UHyEcOZ0PcumMjx1+0G1McNmlElUox5VR0dG7Y/S+4uZJJOOBoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752227988; c=relaxed/simple;
	bh=krDasHiRSh30rhJ1/EMBUsZsXcGIATiUdjtgu2o//cw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m25MCCmjQK1865FqSgET6CiC3XyLqdtRwKgQ3BnrCe2ua4amM2yq9gw3+PrAWuix6anZ3nQ2ayXRkWDuLjuBzAbbuvk7Ex2INW3TLdkVQUBSmo4XiiqED3b679HG/G53NwxBG5mTIwE1Shb30HGzq4IvY0hmIduGGH7b5urHm6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=s2GEQA1a; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1752227986; x=1783763986;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+/Zpf1/MTOfdRdBq85GrohR7Uax1dGacUCh24KsLYOA=;
  b=s2GEQA1aEWIu/FLgEXMWhl5Wr+28GvrdPlElyeiUAiniO3sqX6PrGviM
   L2IcRuN9SAUf5DbouaeHf1g25ZNftmNhBlLAXIiRNrWGwkrwEmE5Zm1Tn
   ZcLtVtAKWVeRdySdHw0pt7FT/mueIy2C1ZP8DLZFMaVu2ax2StQTU3mO1
   aFvOvEufaLl/9owLc/d4RJCkJOnUGlysrQh/d1nYTUm7FZSgKnK4NFfu1
   fGfwPHWX/tvpHPI63ljzp7CxOxRjHJMtYOrIlcjo+OZ6ojcIL3hfjFW20
   OWebpOCR1zL9uN3NzovIUxvBbabkuDwqXhHJ0oGqvaJiNjdsi9YXb0jf6
   A==;
X-IronPort-AV: E=Sophos;i="6.16,303,1744070400"; 
   d="scan'208";a="214020702"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 09:59:40 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:10137]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.40.165:2525] with esmtp (Farcaster)
 id 87c1bc1c-5aca-4746-a8fb-0ccc54f8722b; Fri, 11 Jul 2025 09:59:39 +0000 (UTC)
X-Farcaster-Flow-ID: 87c1bc1c-5aca-4746-a8fb-0ccc54f8722b
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Fri, 11 Jul 2025 09:59:39 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Fri, 11 Jul 2025 09:59:39 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.1544.014; Fri, 11 Jul 2025 09:59:39 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "tabba@google.com" <tabba@google.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"amoorthy@google.com" <amoorthy@google.com>, "anup@brainfault.org"
	<anup@brainfault.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"brauner@kernel.org" <brauner@kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "chenhuacai@kernel.org"
	<chenhuacai@kernel.org>, "david@redhat.com" <david@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "fvdl@google.com"
	<fvdl@google.com>, "hch@infradead.org" <hch@infradead.org>,
	"hughd@google.com" <hughd@google.com>, "ira.weiny@intel.com"
	<ira.weiny@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"isaku.yamahata@intel.com" <isaku.yamahata@intel.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "jthoughton@google.com" <jthoughton@google.com>,
	"keirf@google.com" <keirf@google.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>,
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "mail@maciej.szmigiero.name"
	<mail@maciej.szmigiero.name>, "maz@kernel.org" <maz@kernel.org>,
	"mic@digikod.net" <mic@digikod.net>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "palmer@dabbelt.com"
	<palmer@dabbelt.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"qperret@google.com" <qperret@google.com>, "quic_cvanscha@quicinc.com"
	<quic_cvanscha@quicinc.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "quic_mnalajal@quicinc.com"
	<quic_mnalajal@quicinc.com>, "quic_pderrin@quicinc.com"
	<quic_pderrin@quicinc.com>, "quic_pheragu@quicinc.com"
	<quic_pheragu@quicinc.com>, "quic_svaddagi@quicinc.com"
	<quic_svaddagi@quicinc.com>, "quic_tsoni@quicinc.com"
	<quic_tsoni@quicinc.com>, "rientjes@google.com" <rientjes@google.com>, "Roy,
 Patrick" <roypat@amazon.co.uk>, "seanjc@google.com" <seanjc@google.com>,
	"shuah@kernel.org" <shuah@kernel.org>, "steven.price@arm.com"
	<steven.price@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"wei.w.wang@intel.com" <wei.w.wang@intel.com>, "will@kernel.org"
	<will@kernel.org>, "willy@infradead.org" <willy@infradead.org>,
	"xiaoyao.li@intel.com" <xiaoyao.li@intel.com>, "yilun.xu@intel.com"
	<yilun.xu@intel.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest
 page faults
Thread-Topic: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest
 page faults
Thread-Index: AQHb8kqDkzEjl5PWm0W/FICPi4jTqw==
Date: Fri, 11 Jul 2025 09:59:39 +0000
Message-ID: <20250711095937.22365-1-roypat@amazon.co.uk>
References: <20250709105946.4009897-17-tabba@google.com>
In-Reply-To: <20250709105946.4009897-17-tabba@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

=0A=
Hi Fuad,=0A=
=0A=
On Wed, 2025-07-09 at 11:59 +0100, Fuad Tabba wrote:> -snip-=0A=
> +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT |=
 KVM_PGTABLE_WALK_SHARED)=0A=
> +=0A=
> +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,=0A=
> +                     struct kvm_s2_trans *nested,=0A=
> +                     struct kvm_memory_slot *memslot, bool is_perm)=0A=
> +{=0A=
> +       bool write_fault, exec_fault, writable;=0A=
> +       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_MEMABORT_F=
LAGS;=0A=
> +       enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;=0A=
> +       struct kvm_pgtable *pgt =3D vcpu->arch.hw_mmu->pgt;=0A=
> +       struct page *page;=0A=
> +       struct kvm *kvm =3D vcpu->kvm;=0A=
> +       void *memcache;=0A=
> +       kvm_pfn_t pfn;=0A=
> +       gfn_t gfn;=0A=
> +       int ret;=0A=
> +=0A=
> +       ret =3D prepare_mmu_memcache(vcpu, true, &memcache);=0A=
> +       if (ret)=0A=
> +               return ret;=0A=
> +=0A=
> +       if (nested)=0A=
> +               gfn =3D kvm_s2_trans_output(nested) >> PAGE_SHIFT;=0A=
> +       else=0A=
> +               gfn =3D fault_ipa >> PAGE_SHIFT;=0A=
> +=0A=
> +       write_fault =3D kvm_is_write_fault(vcpu);=0A=
> +       exec_fault =3D kvm_vcpu_trap_is_exec_fault(vcpu);=0A=
> +=0A=
> +       if (write_fault && exec_fault) {=0A=
> +               kvm_err("Simultaneous write and execution fault\n");=0A=
> +               return -EFAULT;=0A=
> +       }=0A=
> +=0A=
> +       if (is_perm && !write_fault && !exec_fault) {=0A=
> +               kvm_err("Unexpected L2 read permission error\n");=0A=
> +               return -EFAULT;=0A=
> +       }=0A=
> +=0A=
> +       ret =3D kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);=
=0A=
> +       if (ret) {=0A=
> +               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,=
=0A=
> +                                             write_fault, exec_fault, fa=
lse);=0A=
> +               return ret;=0A=
> +       }=0A=
> +=0A=
> +       writable =3D !(memslot->flags & KVM_MEM_READONLY);=0A=
> +=0A=
> +       if (nested)=0A=
> +               adjust_nested_fault_perms(nested, &prot, &writable);=0A=
> +=0A=
> +       if (writable)=0A=
> +               prot |=3D KVM_PGTABLE_PROT_W;=0A=
> +=0A=
> +       if (exec_fault ||=0A=
> +           (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&=0A=
> +            (!nested || kvm_s2_trans_executable(nested))))=0A=
> +               prot |=3D KVM_PGTABLE_PROT_X;=0A=
> +=0A=
> +       kvm_fault_lock(kvm);=0A=
=0A=
Doesn't this race with gmem invalidations (e.g. fallocate(PUNCH_HOLE))?=0A=
E.g. if between kvm_gmem_get_pfn() above and this kvm_fault_lock() a=0A=
gmem invalidation occurs, don't we end up with stage-2 page tables=0A=
refering to a stale host page? In user_mem_abort() there's the "grab=0A=
mmu_invalidate_seq before dropping mmap_lock and check it hasnt changed=0A=
after grabbing mmu_lock" which prevents this, but I don't really see an=0A=
equivalent here.=0A=
=0A=
> +       ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_S=
IZE,=0A=
> +                                                __pfn_to_phys(pfn), prot=
,=0A=
> +                                                memcache, flags);=0A=
> +       kvm_release_faultin_page(kvm, page, !!ret, writable);=0A=
> +       kvm_fault_unlock(kvm);=0A=
> +=0A=
> +       if (writable && !ret)=0A=
> +               mark_page_dirty_in_slot(kvm, memslot, gfn);=0A=
> +=0A=
> +       return ret !=3D -EAGAIN ? ret : 0;=0A=
> +}=0A=
> +=0A=
> -snip-=0A=
=0A=
Best,=0A=
Patrick=0A=
=0A=
=0A=

