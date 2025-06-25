Return-Path: <kvm+bounces-50616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8DCAE7729
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 08:34:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6679D1BC100F
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 06:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A6C01FAC4B;
	Wed, 25 Jun 2025 06:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="fqOFkK9n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D2C1F8755;
	Wed, 25 Jun 2025 06:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750833218; cv=none; b=FghMB3HfBTjkt3PWFlGdkVdzkJQ5kaKmUVwTsgaoaHITPl2QO7EkGqvgKV4i3rtD3zOR/BdNIU2tOmXmqLBJe/YnJZalSjr01HeEe2BR7GmEOXgrAYs60iDcYIQi4m9ZGjaYmcbvzvtKLAeUMDI+hM8JkBegt6TbTGSuO6sTiLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750833218; c=relaxed/simple;
	bh=RMqAKar/qsoF0HBR+956qoiEnTuyBiK0mhtIN2pC9LE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XDnA7J7kw4U8nAEicryB+hzW2V3ck5Fb3ifxhJaIQmitgTuM+K1ygZAl6Rgg/8puYqRLR82VXacnnPA7ZEJ/NQQogrwt4IAHwrj0tikggzclTGR+ssv0GOSOyrhJ1VrfDyKisbm2HtwgLNvUAzbQqFcZ4BRRbJKFEYyFJm5MCVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=fqOFkK9n; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1750833217; x=1782369217;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gEnofzmJb8uW1A9eqx0GnHV9D0Z+YeKzOjQZvrEpJsI=;
  b=fqOFkK9nAAM0CRfEbmgMRWWR3dR8/cxymgTsltwviIcJAM7ONeoWokPm
   RLfDcjXA9SGrnV/uG9afJ6rDrDgoRIZQK9c4NipffmI7LZnRJh65XVNtr
   bOJjDnF4sgDRKzMJzdfHUL467HCbUsNgS2tbDt/xu41tr184to8rRnVCl
   5PruEIuzNw/QH2s3YwpCs3ebsfrCbiucJPWdNNtcCH49+oVbnBEi3l6Oq
   aORLgT9G7VAAlgS8bkEqhS6BV6dW39cYPYRxNOozbtTyWY1sAxtQUlDAd
   88jVtQh9NsbDgvsDZZSXamrkzlm7CJlrBKpmVV7PwgIJrH+/Pq0vdREnD
   w==;
X-IronPort-AV: E=Sophos;i="6.16,264,1744070400"; 
   d="scan'208";a="419636510"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 06:33:34 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:43950]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.47.53:2525] with esmtp (Farcaster)
 id 9c25cafc-d2d9-4c9e-8525-84daf9e38da7; Wed, 25 Jun 2025 06:33:32 +0000 (UTC)
X-Farcaster-Flow-ID: 9c25cafc-d2d9-4c9e-8525-84daf9e38da7
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 25 Jun 2025 06:33:31 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 25 Jun 2025 06:33:31 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.1544.014; Wed, 25 Jun 2025 06:33:31 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "ackerleytng@google.com" <ackerleytng@google.com>, Sean Christopherson
	<seanjc@google.com>, Fuad Tabba <tabba@google.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
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
 Patrick" <roypat@amazon.co.uk>, "shuah@kernel.org" <shuah@kernel.org>,
	"steven.price@arm.com" <steven.price@arm.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "vannapurve@google.com" <vannapurve@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "wei.w.wang@intel.com" <wei.w.wang@intel.com>,
	"will@kernel.org" <will@kernel.org>, "willy@infradead.org"
	<willy@infradead.org>, "xiaoyao.li@intel.com" <xiaoyao.li@intel.com>,
	"yilun.xu@intel.com" <yilun.xu@intel.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>
Subject: Re: [PATCH v12 04/18] KVM: x86: Rename kvm->arch.has_private_mem to
 kvm->arch.supports_gmem
Thread-Topic: [PATCH v12 04/18] KVM: x86: Rename kvm->arch.has_private_mem to
 kvm->arch.supports_gmem
Thread-Index: AQHb5ZsRh+1QiHl0MkWMiF4y2LWD7A==
Date: Wed, 25 Jun 2025 06:33:31 +0000
Message-ID: <20250625063328.28063-1-roypat@amazon.co.uk>
References: <diqzh604lv6n.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzh604lv6n.fsf@ackerleytng-ctop.c.googlers.com>
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
Hi Ackerley!=0A=
=0A=
On Tue, 2025-06-24 at 21:51 +0100, Ackerley Tng wrote:> Sean Christopherson=
 <seanjc@google.com> writes:=0A=
> =0A=
=0A=
[...]=0A=
=0A=
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_=
host.h=0A=
>> index 3d69da6d2d9e..4bc50c1e21bd 100644=0A=
>> --- a/arch/x86/include/asm/kvm_host.h=0A=
>> +++ b/arch/x86/include/asm/kvm_host.h=0A=
>> @@ -1341,7 +1341,7 @@ struct kvm_arch {=0A=
>>       unsigned int indirect_shadow_pages;=0A=
>>       u8 mmu_valid_gen;=0A=
>>       u8 vm_type;=0A=
>> -     bool has_private_mem;=0A=
>> +     bool supports_gmem;=0A=
>>       bool has_protected_state;=0A=
>>       bool pre_fault_allowed;=0A=
>>       struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];=0A=
>> @@ -2270,7 +2270,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_fo=
rced_root_level,=0A=
>>=0A=
>>=0A=
>>  #ifdef CONFIG_KVM_GMEM=0A=
>> -#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.has_private_mem)=0A=
>> +#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)=0A=
>>  #else=0A=
>>  #define kvm_arch_supports_gmem(kvm) false=0A=
>>  #endif=0A=
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c=0A=
>> index e7ecf089780a..c4e10797610c 100644=0A=
>> --- a/arch/x86/kvm/mmu/mmu.c=0A=
>> +++ b/arch/x86/kvm/mmu/mmu.c=0A=
>> @@ -3488,7 +3488,7 @@ static bool page_fault_can_be_fast(struct kvm *kvm=
, struct kvm_page_fault *fault=0A=
>>        * on RET_PF_SPURIOUS until the update completes, or an actual spu=
rious=0A=
>>        * case might go down the slow path. Either case will resolve itse=
lf.=0A=
>>        */=0A=
>> -     if (kvm->arch.has_private_mem &&=0A=
>> +     if (kvm->arch.supports_gmem &&=0A=
>>           fault->is_private !=3D kvm_mem_is_private(kvm, fault->gfn))=0A=
>>               return false;=0A=
>>=0A=
> =0A=
> This check should remain as a check on has_private_mem.=0A=
> =0A=
> If the VM supports private memory, skip fast page faults on fault type=0A=
> and KVM memory privacy status mismatches.=0A=
=0A=
...=0A=
 =0A=
> Patrick, Nikita, am I right that for KVM_X86_DEFAULT_VM to work with=0A=
> mmap-able guest_memfd, the usage in page_fault_can_be_fast() need not be=
=0A=
> updated, and that patch 10/18 in this series will be sufficient?=0A=
 =0A=
Yeah, since KVM_X86_DEFAULT_VM does not and won't ever (?) support private=
=0A=
memory in guest_memfd (e.g. it always has to be used in all-shared mode) fr=
om=0A=
my understanding, the fault->is_private !=3D kvm_mem_is_private(kvm, fault-=
>gfn))=0A=
check should never succeed anyway. kvm_mem_is_private() will always return=
=0A=
false, and fault->is_private should always be false, too (unless the guest =
does=0A=
something it should not be doing, and even then the worst case is that we w=
on't=0A=
be handling this weirdness "fast").=0A=
=0A=
In my testing with earlier iterations of this series where=0A=
page_fault_can_be_fast() was untouched I also never saw any problems relate=
d to=0A=
page faults on x86.=0A=
=0A=
Best, =0A=
Patrick=0A=

