Return-Path: <kvm+bounces-1946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E593E7EF31B
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 13:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65A561F23F16
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 12:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98AC33032D;
	Fri, 17 Nov 2023 12:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BZObCewy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3483D6A;
	Fri, 17 Nov 2023 04:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700225800; x=1731761800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3xhBxTyJsGv9IzkFKcQ69qE+nzKlrUfdG1Ih6UkfisE=;
  b=BZObCewydmXtzZx5aGVSBZmODoznemDLMyYYF6o2QtRIhhEt3/rWH1jn
   ggya22H83JnQ3kNE28Ir3ZUXUGdyraPY4yDIM73lfwZzbVc/awafzpg19
   QD8O1h3vQvWcpqas8p2DeIS2eX+BJSr0njh5R5iTt7RNYElcI4Op0R4jZ
   SA4XjYUEBcc/HNfBV293Rp/Gx5VffgenHfmSJxu4v9QEcPHELJCCmlHVV
   P2B2vYgclIHlFW1TYN0V1RUa7HJNNCm+dkP2P5MftC3iNQNjnFbmS65zG
   fS+qOmzXzrongXAb2dZA1Ewfx7m+uUl85RDqX2WzN8YTZKP6FHOoD3Vra
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="391078525"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="391078525"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 04:56:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="715536484"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="715536484"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Nov 2023 04:56:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 17 Nov 2023 04:56:39 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 17 Nov 2023 04:56:39 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 17 Nov 2023 04:56:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEEBjJ7i2xlnLFdU+rnz5XHFZyz2BQghN/M5E5r1cS+cdIbiqLJuZ0LPWb8nUpygoKaxDK1F0OibPrPyjbIY2JlOWy0ncEaGqrK2Gesh1zp+pGPd+yc93o45kzgeGDtqsX+cqG3Xgqp9mZ2l9gRyccdw7LMbVigO7hHYM2jiq2ro55MPjqddHAfaEfWP3GqmwxvzQKlIJp0pn+sccomv7YlnhibuZuem0T8j1YJUzdvJ3KryGQym46x3awZc5FCtK8sIfA36/UkK8hEwRd4+CFMlGTUWg9sDF159cbRvboJJLcC5g8IjZLt/4SKneE1xvMJJnkwVEIM/odZpgsaMkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+UvWr2CTVKUfao+tLLkdPZ6s6M8jW49q5xfvF4zDfg=;
 b=Lc8tAftxW7Tr37EBTGw79GdvvXx0lrIzfChPRgx8HE8g37Ak0nAt622aG9RgPdpzas9Rcfa17GycOPlk7oPW2yDvAMjSRkT3q588jO2y3cGujTk5sbcA5TTmv8e68FGe0Q6U+5S35ccv+TDGfPXfceKNHoo0n7EJRKn4D9kNIh+UAI/pBwxk3/HhW2GffVTq5rGCdGKU8IOGrg2GHoDuoJTjB0dWhuUX4BuvyaeMVtCUNNKFtGj6vPqAE/e7ZXUINiJqSHOn0NAUJwcbXLIIE1KlHsrwNXDdyVo8K/mWr4mhlltuvENAUlpey33AvsSShPpTCkS3sOa5iXtxUE2s1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SA1PR11MB6848.namprd11.prod.outlook.com (2603:10b6:806:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.23; Fri, 17 Nov
 2023 12:56:33 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::6a55:3e93:ac5f:7b6d]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::6a55:3e93:ac5f:7b6d%4]) with mapi id 15.20.6933.026; Fri, 17 Nov 2023
 12:56:33 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Christopherson,, Sean" <seanjc@google.com>,
	"Shahar, Sagi" <sagis@google.com>, David Matlack <dmatlack@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang,
 Tina" <tina.zhang@intel.com>, "gkirkpatrick@google.com"
	<gkirkpatrick@google.com>
Subject: RE: [PATCH v16 059/116] KVM: TDX: Create initial guest memory
Thread-Topic: [PATCH v16 059/116] KVM: TDX: Create initial guest memory
Thread-Index: AQHaAEyrBpVPWseLVU+0s47fedmgi7B+Z8cg
Date: Fri, 17 Nov 2023 12:56:32 +0000
Message-ID: <DS0PR11MB6373EC1033F88008D3B71568DCB7A@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
 <edccd3a8ee2ca8d96baca097546bc131f1ef3b79.1697471314.git.isaku.yamahata@intel.com>
In-Reply-To: <edccd3a8ee2ca8d96baca097546bc131f1ef3b79.1697471314.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SA1PR11MB6848:EE_
x-ms-office365-filtering-correlation-id: 030d0376-2dbb-480f-5837-08dbe76c9ffc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t9nFbk72Fc5ftlv8jZ9b3714LI1oKvvduqUIY2xUYlP4/R+LCXBcuKl6Zjvmqw7gEXFTt8J9jG3vPlCQxOW3fozJRMh6ynajI4y3Ub8QVaVjp6HbKRc6gZRbFlYnv8lUOlKVX4EunKKfaj38iom6g05v9c0IJJW1Iq9P3/wEE2QQ7NkkcIyE99RMla7tJFm48DATOgBWTrncUS6NgzakI7z+LVu9retyZnXualw4fwkB9m+wNxCOfV14Iomy2ScXEKF32251fq6kY+aYjQu+ay9oXP6BYDB85lPsp6krGfpXbSd2oDMamgmPqXZh5RmnjMb7cdCsWiTv6KUmDociNbPjAvczqnOvXZ+rhbC98tFIpq7ZgWEhSM1DKd/7WxnErnfnFLzBO3pqI5C8Qg6rml+uxMyDEMApIGZN4l4PmWjnLcPxoi9SC0OZGq6Pvp3O8zSTQfETt+PmXkynp5NDdqDIg7j/GuM+x85ni5UBIIEcDNGYfpxTZ2vMZaSU1BIbrOzpiP92A6rPWLncgJ6jnJ8/w5UQyNfZv7QNZIM2kjliVsvNVL6IhGjyEy6GbQk95SjsbNm+PVZERxDjwcjkqTX/sTrfcsJisLT9UAY2Hwdn7HsR56efqAFkItY+z9i0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(366004)(376002)(136003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(26005)(41300700001)(7416002)(53546011)(7696005)(6506007)(9686003)(82960400001)(71200400001)(38070700009)(2906002)(478600001)(122000001)(33656002)(55016003)(316002)(110136005)(64756008)(54906003)(66446008)(66476007)(66556008)(76116006)(66946007)(52536014)(8676002)(8936002)(4326008)(38100700002)(83380400001)(5660300002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nhuTUdloUVrUL0WSY9Prg8chGxccEkJ/cUXckHNegrMRa/pnHbnJkMZJlG9W?=
 =?us-ascii?Q?Ith4AQsYhgGhGskjwHjghbZ2r7rCFfKMJ1FQzHfjJGhN8JO7kgaC97TAjG1o?=
 =?us-ascii?Q?DAcfGxV8o9hwlppu9OXQ4uAimZ1R7/V1dHTuqaLoBU9cBuRxHcsnGsni05et?=
 =?us-ascii?Q?ktoDM3BdMDKrOU1eCBdmSX7o1Bihxib2ypbj4KlVEduQF09JKvrwhLfgo4IA?=
 =?us-ascii?Q?araKEASLnLlxNIbyn8bCan832yiIzC0IsVrdYqNtNVPYV5CIPZqOsrnX3KcN?=
 =?us-ascii?Q?cKjzjPJ6aBg3ZDMiWnHIlf44IcHguweLyJrTf2iI0CBYMx7gbJvM+VJ1fgcI?=
 =?us-ascii?Q?2BOzXYwKjWBY9JrcROv42sDmoLp+XKeN4iWP2eH74zGbqpQrO8x2VHC7aSjc?=
 =?us-ascii?Q?4vdmV28DetkAksiOeF8lhyW/UNnInkFRlbTAispgb5rIwljuvL4tcyLI0WQz?=
 =?us-ascii?Q?h8zXpcXKRJubnp+nzj6RmnORCJe9AKmI7uJijd7IH3AxBFgT9z3lymdTSGoH?=
 =?us-ascii?Q?YdzBVZiO5TecnWo7axteti3bxKaBOj4oaMxtoeYLMentXcoB2XEfecmChssY?=
 =?us-ascii?Q?vWWKr+7mtlVCcaL4clwJbM6uNdm4LPYD/Z08ru0KbO7AkK/5WzzHL+i1Zz6i?=
 =?us-ascii?Q?hw4NtCUYM//FJFjULgelpSwIjmOOfYGleQ2V2acZN3xO7aiQgDmURrFrh4Lp?=
 =?us-ascii?Q?4dhBFGyME/PnRjdOnpaFchmyygtYU41iunP57IWyEC6yUymVcl59bPC27gsD?=
 =?us-ascii?Q?tlGsuNuAd+aBfkNhmmvTdIt32vRKHeEOFiPYkM5BrNFUVcjvJtVRph+mwHia?=
 =?us-ascii?Q?UUnB8H4a6OGlmCt9CMj9xTKxHF6uFO9KmLmjNY+3IszLJcxqO0oyUn6aNyGh?=
 =?us-ascii?Q?KUlLvwiJ5q2GrDzilONIEZMSzXydynd1V9GxMtLm0A/SC4GchDw2kN47BQ7G?=
 =?us-ascii?Q?VCXid5e7PfW1rylhJIKDyGi2UhfAJ677aB4XLgpNJDwpwrFcZKVoIpN/CbOT?=
 =?us-ascii?Q?D8G3rWzR6a9GudaKF8+q9BptdWbeW52vUmUBZ2xse2zoU8HqCqeYDa2kU1wh?=
 =?us-ascii?Q?mO8XVqXpSpflgsgte4cvzUiiEnhRqaOKIxnTHenQGuRuCNmd30x7oDgQ9Ozq?=
 =?us-ascii?Q?OFFn8xGIUgDa1YqvhS5NntLQ9M8U3yF/fpZ4MwaOVMjPXgRZasKBVtaYdDdU?=
 =?us-ascii?Q?Wmzcrlooc0QYkWlR+uI/Cu1amsq0MbV9wNFQt5IenXcS8VbWANxoAdwv4L//?=
 =?us-ascii?Q?XwKEkoYJ2kP/Um5+Et8nbQcfJnB7s47Yx2N3MjtAQrtbQNoqoHXvyYRcIpIl?=
 =?us-ascii?Q?rzBBBAfXl8DwThmB0YxtHcrzpp/RcuoIQDYvxpI0RxtWEyOlrODSN24VmOvd?=
 =?us-ascii?Q?b9RVpYPfLcrywI1roIwfHqCvQXgWfw7rLUNsIsEUXPG17rtlldAbHx+ELl56?=
 =?us-ascii?Q?yc+cVj4U19c9yhd0nfg/bG5Y9pncUt4TT3rPAOSs6zoEJPxUEJVDpTDFnayy?=
 =?us-ascii?Q?xGjj3ZEZuQ2woC8iDBoJ3SGSk7cf+vRJJpbrCvGTqwQ+TMHet6HxUvZNuRSS?=
 =?us-ascii?Q?b9FIFE1ssq30fdD26JYwAN+PbbpvSIWmWd1G0Q9M?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 030d0376-2dbb-480f-5837-08dbe76c9ffc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2023 12:56:32.9460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2mBsXMvyFi7/sGY6uYlEqN5zTGagdTeytKx/quSG51EA0L8syrkc7e+bcG5yeuIeDhXE8RFtZO2v2oiauiuCEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6848
X-OriginatorOrg: intel.com

On Tuesday, October 17, 2023 12:14 AM, isaku.yamahata@intel.com wrote:
> Because the guest memory is protected in TDX, the creation of the initial=
 guest
> memory requires a dedicated TDX module API, tdh_mem_page_add, instead of
> directly copying the memory contents into the guest memory in the case of
> the default VM type.  KVM MMU page fault handler callback, private_page_a=
dd,
> handles it.
>=20
> Define new subcommand, KVM_TDX_INIT_MEM_REGION, of VM-scoped
> KVM_MEMORY_ENCRYPT_OP.  It assigns the guest page, copies the initial
> memory contents into the guest memory, encrypts the guest memory.  At the
> same time, optionally it extends memory measurement of the TDX guest.  It
> calls the KVM MMU page fault(EPT-violation) handler to trigger the callba=
cks
> for it.
>=20
> Reported-by: gkirkpatrick@google.com
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> ---
> v15 -> v16:
> - add check if nr_pages isn't large with
>   (nr_page << PAGE_SHIFT) >> PAGE_SHIFT
>=20
> v14 -> v15:
> - add a check if TD is finalized or not to tdx_init_mem_region()
> - return -EAGAIN when partial population
> ---
>  arch/x86/include/uapi/asm/kvm.h       |   9 ++
>  arch/x86/kvm/mmu/mmu.c                |   1 +
>  arch/x86/kvm/vmx/tdx.c                | 167 +++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.h                |   2 +
>  tools/arch/x86/include/uapi/asm/kvm.h |   9 ++
>  5 files changed, 185 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/include/uapi/asm/kvm.h
> b/arch/x86/include/uapi/asm/kvm.h index 311a7894b712..a1815fcbb0be
> 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -572,6 +572,7 @@ enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES =3D 0,
>  	KVM_TDX_INIT_VM,
>  	KVM_TDX_INIT_VCPU,
> +	KVM_TDX_INIT_MEM_REGION,
>=20
>  	KVM_TDX_CMD_NR_MAX,
>  };
> @@ -645,4 +646,12 @@ struct kvm_tdx_init_vm {
>  	struct kvm_cpuid2 cpuid;
>  };
>=20
> +#define KVM_TDX_MEASURE_MEMORY_REGION	(1UL << 0)
> +
> +struct kvm_tdx_init_mem_region {
> +	__u64 source_addr;
> +	__u64 gpa;
> +	__u64 nr_pages;
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c index
> 107cf27505fe..63a4efd1e40a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5652,6 +5652,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  out:
>  	return r;
>  }
> +EXPORT_SYMBOL(kvm_mmu_load);
>=20
>  void kvm_mmu_unload(struct kvm_vcpu *vcpu)  { diff --git
> a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c index
> a5f1b3e75764..dc17c212cb38 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -470,6 +470,21 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu,
> hpa_t root_hpa, int pgd_level)
>  	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa &
> PAGE_MASK);  }
>=20
> +static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa) {
> +	struct tdx_module_args out;
> +	u64 err;
> +	int i;
> +
> +	for (i =3D 0; i < PAGE_SIZE; i +=3D TDX_EXTENDMR_CHUNKSIZE) {
> +		err =3D tdh_mr_extend(kvm_tdx->tdr_pa, gpa + i, &out);
> +		if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
> +			pr_tdx_error(TDH_MR_EXTEND, err, &out);
> +			break;
> +		}
> +	}
> +}
> +
>  static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)  {
>  	struct page *page =3D pfn_to_page(pfn);
> @@ -533,6 +548,61 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t
> gfn,
>  	return 0;
>  }
>=20
> +static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
> +			     enum pg_level level, kvm_pfn_t pfn) {
> +	struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> +	hpa_t hpa =3D pfn_to_hpa(pfn);
> +	gpa_t gpa =3D gfn_to_gpa(gfn);
> +	struct tdx_module_args out;
> +	hpa_t source_pa;
> +	bool measure;
> +	u64 err;
> +
> +	/*
> +	 * KVM_INIT_MEM_REGION, tdx_init_mem_region(), supports only 4K
> page
> +	 * because tdh_mem_page_add() supports only 4K page.
> +	 */
> +	if (KVM_BUG_ON(level !=3D PG_LEVEL_4K, kvm))
> +		return -EINVAL;
> +
> +	/*
> +	 * In case of TDP MMU, fault handler can run concurrently.  Note
> +	 * 'source_pa' is a TD scope variable, meaning if there are multiple
> +	 * threads reaching here with all needing to access 'source_pa', it
> +	 * will break.  However fortunately this won't happen, because below
> +	 * TDH_MEM_PAGE_ADD code path is only used when VM is being
> created
> +	 * before it is running, using KVM_TDX_INIT_MEM_REGION ioctl
> (which
> +	 * always uses vcpu 0's page table and protected by vcpu->mutex).
> +	 */
> +	if (KVM_BUG_ON(kvm_tdx->source_pa =3D=3D INVALID_PAGE, kvm)) {
> +		tdx_unpin(kvm, pfn);
> +		return -EINVAL;
> +	}
> +
> +	source_pa =3D kvm_tdx->source_pa &
> ~KVM_TDX_MEASURE_MEMORY_REGION;
> +	measure =3D kvm_tdx->source_pa &
> KVM_TDX_MEASURE_MEMORY_REGION;
> +	kvm_tdx->source_pa =3D INVALID_PAGE;
> +
> +	do {
> +		err =3D tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, hpa,
> source_pa,
> +				       &out);
> +		/*
> +		 * This path is executed during populating initial guest memory
> +		 * image. i.e. before running any vcpu.  Race is rare.
> +		 */
> +	} while (unlikely(err =3D=3D TDX_ERROR_SEPT_BUSY));
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
> +		tdx_unpin(kvm, pfn);
> +		return -EIO;
> +	} else if (measure)
> +		tdx_measure_page(kvm_tdx, gpa);
> +
> +	return 0;
> +
> +}
> +
>  static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  				     enum pg_level level, kvm_pfn_t pfn)  { @@
> -555,9 +625,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gf=
n_t
> gfn,
>  	if (likely(is_td_finalized(kvm_tdx)))
>  		return tdx_sept_page_aug(kvm, gfn, level, pfn);
>=20
> -	/* TODO: tdh_mem_page_add() comes here for the initial memory. */
> -
> -	return 0;
> +	return tdx_sept_page_add(kvm, gfn, level, pfn);
>  }
>=20
>  static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn, @@ -12=
65,6
> +1333,96 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
>  	tdx_track(vcpu->kvm);
>  }
>=20
> +#define TDX_SEPT_PFERR	(PFERR_WRITE_MASK |
> PFERR_GUEST_ENC_MASK)
> +
> +static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd
> +*cmd) {
> +	struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> +	struct kvm_tdx_init_mem_region region;
> +	struct kvm_vcpu *vcpu;
> +	struct page *page;
> +	int idx, ret =3D 0;
> +	bool added =3D false;
> +
> +	/* Once TD is finalized, the initial guest memory is fixed. */
> +	if (is_td_finalized(kvm_tdx))
> +		return -EINVAL;
> +
> +	/* The BSP vCPU must be created before initializing memory regions.
> */
> +	if (!atomic_read(&kvm->online_vcpus))
> +		return -EINVAL;
> +
> +	if (cmd->flags & ~KVM_TDX_MEASURE_MEMORY_REGION)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&region, (void __user *)cmd->data, sizeof(region)))
> +		return -EFAULT;
> +
> +	/* Sanity check */
> +	if (!IS_ALIGNED(region.source_addr, PAGE_SIZE) ||
> +	    !IS_ALIGNED(region.gpa, PAGE_SIZE) ||
> +	    !region.nr_pages ||
> +	    region.nr_pages & GENMASK_ULL(63, 63 - PAGE_SHIFT) ||
> +	    region.gpa + (region.nr_pages << PAGE_SHIFT) <=3D region.gpa ||
> +	    !kvm_is_private_gpa(kvm, region.gpa) ||
> +	    !kvm_is_private_gpa(kvm, region.gpa + (region.nr_pages <<
> PAGE_SHIFT)))
> +		return -EINVAL;
> +
> +	vcpu =3D kvm_get_vcpu(kvm, 0);
> +	if (mutex_lock_killable(&vcpu->mutex))
> +		return -EINTR;
> +
> +	vcpu_load(vcpu);
> +	idx =3D srcu_read_lock(&kvm->srcu);
> +
> +	kvm_mmu_reload(vcpu);
> +
> +	while (region.nr_pages) {
> +		if (signal_pending(current)) {
> +			ret =3D -ERESTARTSYS;
> +			break;
> +		}
> +
> +		if (need_resched())
> +			cond_resched();
> +
> +		/* Pin the source page. */
> +		ret =3D get_user_pages_fast(region.source_addr, 1, 0, &page);
> +		if (ret < 0)
> +			break;
> +		if (ret !=3D 1) {
> +			ret =3D -ENOMEM;
> +			break;
> +		}
> +
> +		kvm_tdx->source_pa =3D pfn_to_hpa(page_to_pfn(page)) |
> +				     (cmd->flags &
> KVM_TDX_MEASURE_MEMORY_REGION);
> +

Is it fundamentally correct to take a userspace mapped page to add as a TD =
private page?
Maybe take the corresponding page from gmem and do a copy to it?
For example:
ret =3D get_user_pages_fast(region.source_addr, 1, 0, &user_page);
...
kvm_gmem_get_pfn(kvm, gfn_to_memslot(kvm, gfn), gfn, &gmem_pfn, NULL);
memcpy(__va(gmem_pfn << PAGE_SHIFT), page_to_virt(user_page), PAGE_SIZE);
kvm_tdx->source_pa =3D pfn_to_hpa(gmem_pfn) |
                                     (cmd->flags & KVM_TDX_MEASURE_MEMORY_R=
EGION);


