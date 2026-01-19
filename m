Return-Path: <kvm+bounces-68474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB12D39E51
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 07:21:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 16E81303CF7D
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 06:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2FAF26ED28;
	Mon, 19 Jan 2026 06:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZQeMIi37"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DC026C3A2;
	Mon, 19 Jan 2026 06:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768803689; cv=fail; b=UUCNuruC/SEJP0T7585AF2EEhZZnTCvahCK3TH7fJbON+2xmtl7sE9p3mztvqi8W3f5DMRmUnFAvU+TyEDuLkaMt+8Af73VTpIOlm1/haQXC4wO5VcS3XoZfX9uRH2lzpR9zSSzkdMYbmrlbsy3+lWW6oyHrYCM8x3bfFALGwZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768803689; c=relaxed/simple;
	bh=ox0amW2x0SbnnL0gXhrpm/fTfBcut9i53wesSUN52gQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k8MSYqSWvdszisPqUHYOaLiVOkNerDgUIFa9dcRvIfCeBWi2fDG8XCsoAkeFbGpvsLA9UmxVvalL7Mre56yVYt7ezLB8ZVlYBpX2VEm2Afp5IDQrmS+631jSRo+oHKDv2yV1yT9V0ho83u8vs+EXRG9dCGs8Buci0LRwxD81g54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZQeMIi37; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768803678; x=1800339678;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ox0amW2x0SbnnL0gXhrpm/fTfBcut9i53wesSUN52gQ=;
  b=ZQeMIi37d/0jCKCdn/dLla1C9IQhNcHxsUWc/O8jp2eA2fNNfjZqL31r
   oBgdyXbP3s4BHwqvXANZLx30xe6d+McmHopNO5IKCz4emimkEg8Kyf0b7
   NDTBfKxoyCOaV/1GfrpKH+wE2+gip/jGdbKONoeS4vTIoLf64T+NStE/C
   sYAsNf5L91j3kQ2wXc7804lsmQYfCpF53IW68H2s04fVEQC8Asc5JLbA4
   ZpMyhnIRKnfgjKI4/2JqqNXQzAHX1suwF0BkXPh7E0rKhyySaAIoMnDf4
   pPZW4cdDxe3LDJei0Kra4N6zS530+54eJu2ZSJRTCPL4B3aQV43C9VATO
   w==;
X-CSE-ConnectionGUID: GOCVADkgQ/29LBGnjfMSuA==
X-CSE-MsgGUID: vtfOsabOTOCkWrBrCpN3qg==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="69743186"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="69743186"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 22:21:15 -0800
X-CSE-ConnectionGUID: i9MTHi6hQ9KJQCxZVNtdsA==
X-CSE-MsgGUID: z57hHepdS2uS1dg1uF1o6Q==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 22:21:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sun, 18 Jan 2026 22:21:11 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sun, 18 Jan 2026 22:21:11 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.12) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 18 Jan 2026 22:21:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hlm5Kl20M9l0J+MH0mAJ7PiqtOqx8VIvYgfP5bKYMGbfYfvLlNylpmpFv4+VJ3Q9LHsAAiuipavIJWgmATK0dATFui/FLGsbVIAyj6WVHnCRok41PYxNqOb7iKiPXM87qzOhtZDgmrsptWChnfAv1z4BQnG5IusQvrG5uM/8/izhS+eaRPt15OSkYsRG8K1j98LIHqxAImiGfnFr3gwBkC5ihbL49anHutaXlsSOsCPv1zOlrK/Mejkb8QvAE9p5N2zN3llVnBiOebcUrSFafRyxUeqrxnTnpbD9oejZ1mvV9+2agYkSWGhqWXpfTrxm/iWl5KdR4oWsJ8WIR/KebQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GbJCHfI9XWeMmBbUexbFdyBvbtwDc3pe6WDrvGwLlTE=;
 b=His1teDb81JoEbIWX3YuJtId3MiNPVpGOk0HNRqPyGQIq90/TbvgImqNYQpKaPf8ThY5JuGd7GBmJeGV92qU0tXncSvCmMiE756ad+/ykkgTPzOZySNMZbFyMdu1SoaLRBDQXgf0XY8uPztL/4dnmp36gj6XN1IWqGIz+US6ce9lPT7EZ6hBYFMNL3aY38tC+hmNQflTe1emRAc6p2A0T+lhr/VBtnbcTLR3gP0UMskweIOW+fJbKx083YAYnP5LPB66PzowVXOMutqgXr38MpLOa3nM42X66zIw1KrSZKxKfAM8zfP0ikQH/FxDJZ6ahpOysO3fgM70QvIvlgo1QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6793.namprd11.prod.outlook.com (2603:10b6:510:1b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.12; Mon, 19 Jan 2026 06:21:07 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 06:21:07 +0000
Date: Mon, 19 Jan 2026 14:18:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "Miao, Jun"
	<jun.miao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Message-ID: <aW3MyZ3M0ugyfsLb@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106101849.24889-1-yan.y.zhao@intel.com>
 <ec1085b898566cc45311342ff7020904e5d19b2f.camel@intel.com>
 <aWn4P2zx1u+27ZPp@yzhao56-desk.sh.intel.com>
 <baf6df2cc63d8e897455168c1bf07180fc9c1db8.camel@intel.com>
 <c9b7b375019873b4bf8fccd93b3b1b53778ca3c0.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c9b7b375019873b4bf8fccd93b3b1b53778ca3c0.camel@intel.com>
X-ClientProxiedBy: KU0P306CA0004.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:17::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6793:EE_
X-MS-Office365-Filtering-Correlation-Id: 009343a7-bc1c-44cb-a77d-08de5722ee1e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?IalUZqcphoEPR0fEFOaBdYxKPWdC4NEa66ELMrWuA6RoU93RUT0gCi73iP?=
 =?iso-8859-1?Q?Xk8UxBpfy4MyOPOu8LneyN8KhmwEu9do/kKmUPCSdG5YzBK2LShamxAokK?=
 =?iso-8859-1?Q?aDDPjyhV6ZaqvkMblLoRjM/nh7BaCdQTAIC+3YqXqLSME8TbDmQj6CfW4v?=
 =?iso-8859-1?Q?p3jvHDOoUlD1v0Rgq6NPgFgzhosCr1Z11xB/mcRPGVkNiVHRRKWht5XrxJ?=
 =?iso-8859-1?Q?lRb+TWHv3C+QVVeJ4o5ZRifi/LhdclB/AeaWghR5kvxy/xCqSF5Yi9cMf5?=
 =?iso-8859-1?Q?TDB53cPxlIxvOlfh4YcUZmOEWzkKfnP7NT+NrfMoVOqeA/hnPyVyYoyZVx?=
 =?iso-8859-1?Q?CsCdtINVqLELyRTVhl9ROtE1htXaanNLf4biLwjPZMMmNB2Pi55u4n1UKp?=
 =?iso-8859-1?Q?D/J54dfxau5H6j/to5IJILHVLlvooIo1UEP05f1aayN6oli57C4fOwR4Bu?=
 =?iso-8859-1?Q?wp/Ibp2ZvL5AiGt9S7eX3jSNeoubdwPEj6MSjI74RIitbn9M6zZ3DtAvI8?=
 =?iso-8859-1?Q?VDavfs73Gz3lRc3TE/h9toiyLAdWdt69JpjDEF7cnTAocI4CN5leJdmrln?=
 =?iso-8859-1?Q?65N4rRo3r2VE8idl6Hl4gtBpFeL71W7h5FPbDBju065ejYVZsg6o1CwFx6?=
 =?iso-8859-1?Q?b0mWGaO+/WM3bVT/xA0IwHxhrUFRZJpTdQmvXms5Xov0HkLLf3ZvOiTmDp?=
 =?iso-8859-1?Q?CoyOkZkuT4AFNqpFnm5jhXIszuqgaEh35WFL5ILpZ9QentwoANHmNzo7TE?=
 =?iso-8859-1?Q?eOfUZyOW2JAstNAZZJ7S0lDIn7oouUBPXjw48tvAP2qwmknSlNdoUP0kQq?=
 =?iso-8859-1?Q?i6Sf0BjpxvlkKSYWyuDZkO/FEFSekuxaBjuZQD1CirYbZksqpVtn1Hn30V?=
 =?iso-8859-1?Q?Vs/ZqzjHBE1Gm+NqUK/zLJTXFquejuo6oPUgwg/juFsTaA5Up96+RpkT9I?=
 =?iso-8859-1?Q?m+VWGyi+OnlB6viGBBFcB+4AtZiS5/GawVpaQYolg54mzaxnX2g+3IjJcu?=
 =?iso-8859-1?Q?TOrwJkYhYym/Nr1bRLzw8yBnH6g3uHmB9ncnPoMl9RFRjAkuCJCiW77Jap?=
 =?iso-8859-1?Q?fjCoEWV94jgM6weFtXhA0zlCzlRTe1YzSACz1i9haxE+WbZ5vJ+A/31tUk?=
 =?iso-8859-1?Q?mUphBpgcCg+fHqhdbclEjbpbhw1ITO/mUZCc3x+/qEXc3uRgcr7CXmK1TK?=
 =?iso-8859-1?Q?OP0b6tqfvHPijoX706dljZpY9m0c5peh7zQJiioHubbXI21/Rrk7pr7frQ?=
 =?iso-8859-1?Q?1yyptm0beskbS9o/lYCYF1nGVDvlLi2H3D1Le/xBEknswd3WDmpikZ+NAD?=
 =?iso-8859-1?Q?hf6V6M+ZRpZGwJGbibE7RvR1s0uv+o0jsEWusKLDhJtxQ9iPcF8uwLGJrI?=
 =?iso-8859-1?Q?ePtOV5uN0TNtg4E0pr3qos4YRzYZ8sVF28f75HcCD5XycVSsUQ40POZ+/R?=
 =?iso-8859-1?Q?0gnNqdezkSUVxi9r3bIxSM96LJ+v/r8vumN0qC19BZBntCm6dhSMxeclnC?=
 =?iso-8859-1?Q?KHntNbCxH3D2DAj6VsdSdSFHQ90Mnk6eeIWT2GcEZ6f4SOEr3MW+Y0cD6D?=
 =?iso-8859-1?Q?4UvDaXMcMdQgv8MKQti99jAdo5Qr2QQOQ2t+Nw89To4g2jqiax+ku8ZIrW?=
 =?iso-8859-1?Q?a27hamm1HJyD8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?RL0FOohzmzPVLi9FpQz3Sl8mkVIVcWWIC9uToknfgH/CY+aRTTqEc+Y7cY?=
 =?iso-8859-1?Q?Vi2EduRHZiDLQUzuaKv6G3DIWj0KbFl6cJYyOADrKPoJR0Rym+PhSXvEXh?=
 =?iso-8859-1?Q?6zao/lYoBb0YVGnWhbIz5z/OUt4p+K+vsl3pInKFUA0LbdhrCFeNkb+Pg9?=
 =?iso-8859-1?Q?GxaFd61TR+0ksVcM5gaPBDHMKFrtDl+7w4qQSzGtY2VwJUAwJMxggrj5Uj?=
 =?iso-8859-1?Q?lyYZjjuI8NTif05W6gHg0C0SeU3NGZmaZXD0VeEM1HOYenmDA9QyG7388c?=
 =?iso-8859-1?Q?ZWPyuoEAiBlAOCvOTSvtVWJ+1qjwm2yeP8/bZy0Wlo0A5oA76QHeMO/wZ/?=
 =?iso-8859-1?Q?R4J0hMbPPTd25D1yQWPs87tguP+A9QqzKkgz0sg5q65EEZzBlTRbKUohxj?=
 =?iso-8859-1?Q?xhkKt/NtFDm7tDpoAai/JTq1f+DbHTBxtXR53KnTb7fnRg3XOoCn7JSH2a?=
 =?iso-8859-1?Q?lAicQveeaZUGNsU8v5+hXiEs1aMEgD0pxHgFRlw4khSuG3I41VpuBNExH6?=
 =?iso-8859-1?Q?mg6v2CE9ryqpSPZGx5hhTRj/7YqB7F1SCq4dzq/qgKSfNL58lh+3qpbyWE?=
 =?iso-8859-1?Q?FzZMsRg1uFD/U110qhXaJ1R2X+gy7NzO3zmzAGGYPxPt8eOy/sPzmGxTy8?=
 =?iso-8859-1?Q?AXmehQtUVP48A3q5wsb6VX7tXeFSI16ywVKHgRVHGwX9Li5n8ja6RBhiWw?=
 =?iso-8859-1?Q?JPg/P7LcBKdOXvRTqsQSKN12kfPXtkRR45be3QPDFO8XC9HhA/omMaJdYp?=
 =?iso-8859-1?Q?GQqk7CL3fpWHOClcTowXFRUloQkcV5CGqy64mBdKhVgA0g1M3WIjk33LPr?=
 =?iso-8859-1?Q?UO6YStQhzbCiPIsz6Up2P8X22TuVwn+35aFHlBM3sKlySRX3x69fGq67Pj?=
 =?iso-8859-1?Q?CGagSx5/JhqZQG2BfdlrysPigWN8BLA/8JF4KY/hxzISpYKHT3S8/mcGU8?=
 =?iso-8859-1?Q?EuWJzzfKFPcidPNiOox2KFOJb/Le3VMID/ZTwnVANku7vjfb66EQCSddIf?=
 =?iso-8859-1?Q?5e6TBy9vrdQvOcDZubg4VDG++VXB8GVk3/EGSE4U5eAqUNVj+ttDZe3s0c?=
 =?iso-8859-1?Q?i8ZKJeos4fhiEp2GzcTcnqokkQojMK1jJf6KzNv67l2WgdDTLnSL3FLKtF?=
 =?iso-8859-1?Q?WWLM96iNqPq/8GKwRGczW+TNeYYxq4QXrT6kZjH7in4aAnwNXanpi4yeEV?=
 =?iso-8859-1?Q?u10bCJL4mU4YULGWezeAHa8qNIP4LflLW1i7aRIeBuwyE6X5bjrCCwFHyr?=
 =?iso-8859-1?Q?uoG8gB2ilfrISwZdZIHnP7pZlB1NtF25WWI5UqueDwuClOgLAH0r7q9hbu?=
 =?iso-8859-1?Q?Uw9AQt0b++lfYJSXkQ2N/xGn2ZhyRDBg8UAJ633Rbdo1P+gVNYMUWxGia9?=
 =?iso-8859-1?Q?M6E0YEmlxEFZr2Gtj+iAtk+ucqhpV7WMYnu9zBjrEpB90AEhZGS3nXopqt?=
 =?iso-8859-1?Q?T5eS2XkUAoH4JGAi8eQKlvKijQfk2RyTxTTYP9ixTIBI+TClEKy7rKLtey?=
 =?iso-8859-1?Q?+1VA4B8ZsOC+yAD5G4dSjOomytYV1v8mvLrPWXXCXhpWe0lDBM6tFjqXVf?=
 =?iso-8859-1?Q?Lus9aMxGPORzS2z7ZAAdWLmFtM+uguc8m5izY6Rcv4m9rbuPuwk+9tCzsd?=
 =?iso-8859-1?Q?foUMTvcrpeIFgNMvkozP7fRcYnvrJMdV6vaieFt5d8LpXgSA0SBCyPEtHs?=
 =?iso-8859-1?Q?I/CwwWI0MeBimpX/Eu9ibDePq4RqCzNP7R53NJ++90YmMS90TNGQBZ7GO5?=
 =?iso-8859-1?Q?gtKLYG/PBQf+JuMdh8Lr+PBU51xwfHsJemq/592w0xYJccSsu6y37mVOmD?=
 =?iso-8859-1?Q?DCjiwHOP5A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 009343a7-bc1c-44cb-a77d-08de5722ee1e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 06:21:06.9607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bFrG8nUG1ZajIyg5p6whIS6OXmNWSsV1/LfvjuNaV8c3I3K8oPKxQ7yCct2gWMX8Pbd/X7GK8YNkqJ+i3nV4aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6793
X-OriginatorOrg: intel.com

On Fri, Jan 16, 2026 at 07:22:33PM +0800, Huang, Kai wrote:
> On Fri, 2026-01-16 at 11:10 +0000, Huang, Kai wrote:
> > W/o the WARN(), the caller _can_ call this wrapper (i.e., not a kernel
> > bug) but it always get a SW-defined error.  Again, maybe it has value for
> > the case where the caller wants to use this to tell whether DEMOTE is
> > available.
> > 
> > With the WARN(), it's a kernel bug to call the wrapper, and the caller
> > needs to use other way (i.e., tdx_supports_demote_nointerrupt()) to tell
> > whether DEMOTE is available.
> > 
> > So if you want the check, probably WARN() is a better idea since I suppose
> > we always want users to use tdx_supports_demote_nointerrupt() to know
> > whether DEMOTE can be done, and the WARN() is just to catch bug.
> 
> Forgot to say, the name tdx_supports_demote_nointerrupt() somehow only
> tells the TDX module *supports* non-interruptible DEMOTE, it doesn't tell
> whether TDX module has *enabled* that.
> 
> So while we know for this DEMOTE case, there's no need to *enable* this
> feature (i.e., DEMOTE is non-interruptible when this feature is reported
> as *supported*), from kernel's point of view, is it better to just use a
> clearer name?
> 
> E.g., tdx_huge_page_demote_uninterruptible()?
> 
> A bonus is the name contains "huge_page" so it's super clear what's the
> demote about.
LGTM. Thanks!

