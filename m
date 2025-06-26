Return-Path: <kvm+bounces-50816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB163AE9943
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 10:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41DC03A9B55
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 08:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F44294A11;
	Thu, 26 Jun 2025 08:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QI5aMsVo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428692C0327;
	Thu, 26 Jun 2025 08:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750928193; cv=fail; b=IwVlZEODDCBLOmubzLmKmIpGQ/rwTbT9jI/PV5qDOrq2BYDgl/emERKBL08f6U4YbeUnO3OAPRMT5uWUGkPU5eXnNAbdRG7SdMva2bH8sB0WJkfFEdJUJt2VSxYcAGU9OLGErczCChN4ciYYOcJYHHe/vILmfsHsuDBMJTSiCaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750928193; c=relaxed/simple;
	bh=FDKM3T6zTpvFzb/yZjC4Wp9Q/qIwc436xAuQSnXFtgQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VJgxraQQubqn31qiboniyE9WJ6nu84dNQqoX5+Eac5/COJNgU2Qv1aWEjeTDgHRffcfjeI2t4O0DQDG3lw5caWARuUFZ7ZzljD/xErWKBKGF/KT+E2bnhHIT4UU3/onzDvDOTGX0F4DuiQh3Cq2tkuIvhRXZfQkQ3zbllszXRns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QI5aMsVo; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750928191; x=1782464191;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=FDKM3T6zTpvFzb/yZjC4Wp9Q/qIwc436xAuQSnXFtgQ=;
  b=QI5aMsVoZLb7x3PTjoGIK0YNfFq6+ssTY8q8yzbxNsIZG9sGr+EomWKV
   K7hKIT9uaI9sBMdH1wYY5TH37R5MMNFC6Xll6f597XJWFyRJ/R4nTysWU
   7OJvrAUiKzohhGJTkK8vt3NM1bZVp8Pyh8wGx8JqqdQZ8pz8wIj5iY3+y
   nsOkcaKv/DEit74uEEEXoz6Lzh8z4hg0TcSURpouaYI3kxTxfzHH3J1m4
   z+QSIwgSn1lfl8awGqqefsJo2Qcy/CBLPK41TPMtqEsNrrcP9rU4j6prO
   n3irO9y5n8982oznnJ4WOy//ZieZnCSMeI3eN6flg7i7n+NLLXbiUMGrm
   A==;
X-CSE-ConnectionGUID: u7NHX1aET9O5k/lCrG7QrQ==
X-CSE-MsgGUID: B+FO7NLNRICqnjbHTc3gxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="53154371"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="53154371"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 01:56:30 -0700
X-CSE-ConnectionGUID: z8KI4XOvRmCG+zmSObwcxg==
X-CSE-MsgGUID: wpOn9ttuQ3mg+4FmvA8UYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="152963379"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 01:56:30 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 01:56:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 01:56:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.79) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 01:56:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uI3DPJGp4lxZbDnWMmjoU2dXmw9rPs/EOQcY4KceCo8GQ534VUlIdv/FUREtt+d7jJz5n89sjnKjRjsIzxosYRm8955aLVYtnXYJTFag5gJnn2ON2Rq2MCIKv9R7/p+/ORaXRzAFHc1n4+ds1zVyKk13s4HRxXfb0/Dx9gy3LY2/F9id86aPg8JcVCQCObiOPkWMSq9FpRmoCcFNROGsoeLYNGuydaUeKfzLFgUoTf8AIol53KSBG0AzTrK7SOxa0sJfwXU+PZx86NZjVK5VNIaO/65jciL20vRHFiTCR3RZWZ6MQbBvVj9AgL6mpKNqRbNiQdp1CRwFIG24qVlzmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ybp9+RtjTF5F/PoLbPuw5nRDucJ4n0YzJ3h+/19ZUjg=;
 b=VOTDRcMW++o9vuqpZvrDzuhy3Exw9G6gDxPW9JDMi7wMIUi3VBxsQo4wchJLL9xAFHuWKTK8q6Q1qKIFGRu1h62JkDsywkQuU4ZttCMUsKX1DhitseLKLXr8capSIS7tifpeZzsGiBuLgoipj6NCG8opUIo+lxzwfbbHFFpjv/QBdL/58tpfjsj5Ow7jHXehlohXDgQX2rwZnx2iAsdPWWEsOTvvQ3sXQExaU9JkqXBN2UKMYul6u1u2y30zSNkXmQecFEeFP5pJivk6JDQlHq5YfBpM/ldMvgOMcfpPBjv61ezOB93v1+Lj0pSlV4NcI3xq3knfqDS6Oblxff72Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8525.namprd11.prod.outlook.com (2603:10b6:510:304::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Thu, 26 Jun
 2025 08:55:59 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8857.025; Thu, 26 Jun 2025
 08:55:59 +0000
Date: Thu, 26 Jun 2025 16:53:23 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"tabba@google.com" <tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aF0Kg8FcHVMvsqSo@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
 <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com>
 <aFWM5P03NtP1FWsD@google.com>
 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
 <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
 <0930ae315759558c52fd6afb837e6a8b9acc1cc3.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0930ae315759558c52fd6afb837e6a8b9acc1cc3.camel@intel.com>
X-ClientProxiedBy: SG2P153CA0027.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::14)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8525:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f28a8e1-00a3-4d48-9aee-08ddb48f4512
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?xxZUlxIC/jaiNsBDoANDPrST3xzqGKsBNv/P3tctP0AnR9r8HFkBxQir8s?=
 =?iso-8859-1?Q?WaMXWtDAET+2mFUtf+GRjRwM5v8oZhIABmQAz0yace9s1eG8pGtjSqEz7+?=
 =?iso-8859-1?Q?F7X1OdZRs8oytIeIClemYzWsHLdb7/67U3GlG2hmU6q4ASP8EWk6ty9C/n?=
 =?iso-8859-1?Q?Evuz7GtUKaeZycyPHNoODY9AcAOybLvVzR68qBQZBV2n47CWYN3FdY2kUi?=
 =?iso-8859-1?Q?WKM0SAuqXyz8xwbfFz488XOW4DQ8nw/KJOUbPzUegeIBIy1FIFm/76WmLx?=
 =?iso-8859-1?Q?Kt/T4U+8U5uUBNFXYO6bt46PNxl3+vipwC9QZkhvyeoLCA/DVXo3KQW3kp?=
 =?iso-8859-1?Q?/E3LL8Lw3jdFeBAIuR+oSjb6n3jzWdSRmYOEEnPU8HkbHV1w17NbkXAqel?=
 =?iso-8859-1?Q?z9w/Y6e62kQvcyapdJKOzpgLlwTPtPO3a4swgG7fwaeNQWpR8GW5Pf+Lch?=
 =?iso-8859-1?Q?z/GkGN7ZO7UMllPXiYGcA2kQV9z86/qbj6v3YuuX6ZUFcjR67TYHMqzoy+?=
 =?iso-8859-1?Q?vDPJI89PIjW5CtFatL3rDlf2DkR3O6/5Oa30zojCFp4jju9nKZjkdwds/7?=
 =?iso-8859-1?Q?LP3F10e/8hiwcUsBGS1j3m1TeVWiFS8GDWngDzsgCGjZxzrsaYkoy5kmoW?=
 =?iso-8859-1?Q?jhf/LngSLgyPZdcyhXMqp5Z3kUR+IVx/8peTose3LK5VcLAXppClNSxgAh?=
 =?iso-8859-1?Q?HrnyAKLW34tsNHZf9FtYq5gxGNqfM73628O5BdGa9kBxG1WfVhixDTF3Co?=
 =?iso-8859-1?Q?r0qEHlgYdxjFpR+gmjY/DX38tcXr0sx4p/0fh6AHUkMwbXjyaPIaQOkOXV?=
 =?iso-8859-1?Q?bZoI3Rb/R2wvc2zi03Stbn+MPBSL9UwYvprF2d6msJSZeErnNUroZ8RDpU?=
 =?iso-8859-1?Q?MaI88I209/LqkhHpuUAirSLj/H6oGS+j8Ggi/414qim9MJu0i6zAGRgBM7?=
 =?iso-8859-1?Q?axqYXpLuiRFbdSo2T2iaTp0tU8cD9FaxRWam6CDg2EfGJa/fy685CyG27D?=
 =?iso-8859-1?Q?JbsJgkNeGkQqiKKwk8XsZF6NNHeVb+wffz4eyTfFSXGu7jYgvlZUIvtX03?=
 =?iso-8859-1?Q?RGNWbT9eGKa6I3LLgzpNqDsvhorjW3Ugi/352gjyP0pnlqIVhsnredXWGR?=
 =?iso-8859-1?Q?/rV2RIV90Srai+kXcVmeyymfr3JKcWTfsbcmfmieA8dAoc4Do2xQQaaGd2?=
 =?iso-8859-1?Q?zCaFfRWH79a6nCOt1VcNPYQDGZ6Q29CWu5px91sgl41h3tG+TJ0Rool2yo?=
 =?iso-8859-1?Q?IWBSAR7T378MuB33D4dOD6+ROKs5EyrK7NdSlZp6TvgMWlCJ/GzoJMYbJw?=
 =?iso-8859-1?Q?xd6SH3rLQkahD9IK7pOUUWBL/p3IVCw2lYloZbDR2NMEXtXVWcmk7eNcX1?=
 =?iso-8859-1?Q?b/oBBxGIePAvy0B5eWjTJO8Why0RxgzZMnuDEXn/kwTRJrAzT0dATooplk?=
 =?iso-8859-1?Q?xNXqIV7SOhlO8f2AhzIlfE9WAwn7DJmQHx9QaLNV8Y6zXIBkxAN2kZxLjK?=
 =?iso-8859-1?Q?o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?V7U+0Btiiyu2BadThvPEqlh8WwZ++QGsTOXrGS1aYsSCyS4wRXln1ig485?=
 =?iso-8859-1?Q?cW77zX4RMU+lZrxG3opyAEAoNF0Cw+z4OMMsvueQbIy8Qp9AQ/+TJjwfCI?=
 =?iso-8859-1?Q?r2hkPHmEBfutJX/m0ywsNr/12n0hl3ftCh8XP9VF+a0UD5Qp2TtHRT1zxr?=
 =?iso-8859-1?Q?OEBEHXlu+jkPJYzwQ7gA021qdlnF10cRR9PTzGsqq/n00W41vHb8Aeerfx?=
 =?iso-8859-1?Q?lLjBFlzjqUmSq10vySSMgud53ftsGlJeTodYXUNzsFIZ4Gmw7UGPdmk8SD?=
 =?iso-8859-1?Q?B0hD+bXE1zQ2lm1DiHqGSVJ0RwAqSnP2noRuKj+k5tODBdD47h5XEtIa3v?=
 =?iso-8859-1?Q?nhS+HX6X9H+ewY9ZLeHRr+u92mJiC9SmOtd/cfD4qTsk+rapHY3FgLqs9x?=
 =?iso-8859-1?Q?INEFdlHe3YSOAgUgUFLo/r5AWMhLY7opYgHird1WqJr/RIlsRrnAWqvZQn?=
 =?iso-8859-1?Q?2EGHIgTc48n27RY85TYuTpi+qKZwqbrn9jrFBxCXD7u7KDX6dfbw3L+5Ye?=
 =?iso-8859-1?Q?pca7ceRrKhh9vghgQXC1tU3H0KnovRYuT3Ezh/GLo633/EywrCDD0pwl0y?=
 =?iso-8859-1?Q?J6pxBhvlXrWXm6ryOt2du/RIbG9Qzv1xbyQTtzJdD5MOvkL706dLa0jwqa?=
 =?iso-8859-1?Q?jau7lsBvnCgBOsOCDhDLtMVJ9/xQjYUQgNfW5bhW+DDD0xvJmHBs//B4j/?=
 =?iso-8859-1?Q?lg7FmzPnWYQNS466iaMmd849IalGv21RegrJtN/YiKr4pRhqENTaNzrpDn?=
 =?iso-8859-1?Q?4zlO/7VfsqAJVjqGKGWAbU+fCshVtNH33JzISD7YIH1LHeREeNjnlY/RcA?=
 =?iso-8859-1?Q?rLoPQ+nhlESV+PxQACvHc3p7aYobkUGqdlW9F0YGStO40bne+GegaBvi6Z?=
 =?iso-8859-1?Q?f6JE8oJNl8Xqtu8jx0vPVmtMPjlK0zwFSaAlZ472+svHLjz+KBdY4OV+Xy?=
 =?iso-8859-1?Q?YQ47X7cDBMWUaT81ewEVAEJcxfYY1l7zmWpjOS+ALwRFqYmWfTlKpysN+f?=
 =?iso-8859-1?Q?nrNjTkSZP0eNxZ2kQkgi0/OPM57ijq15hItHk53wKf0BDP3comQhFAeD/8?=
 =?iso-8859-1?Q?+JaIArhN3JG+CgkXdjjODITI6kWlzqYTloeCPUdyzVsnExhBuQjnOLjILh?=
 =?iso-8859-1?Q?unPus2sOzHSNELlJgUvTOL/ocr19cRceize0G7f65wRL5Y3VeKxPqRsvlv?=
 =?iso-8859-1?Q?NmzIYGBc9HXA1xPjEgreDIrDcKRjRNIXrowmo6JDybMyKykrhL9o5wdRU+?=
 =?iso-8859-1?Q?mHgZEU8mO0o8H/bkOszisDLsSWwLbiI8Ib9u6kTmgiOsIz3EEdfrmHsq+Q?=
 =?iso-8859-1?Q?dLxLbNFAIOE9wTQQNEU+zQ462UxO76aDeeTBdWxKlRTDxITbFGnzOGMVsr?=
 =?iso-8859-1?Q?gO0R4jREksbOENzQpBG3WhMMTAIx+b3UQpGXmzb8NrtfttZOdTGriECMzz?=
 =?iso-8859-1?Q?k7b/A6RhB1mnSiJ66Gro6cJ0oUZFn3q4/Q7W6AmuwFoK7OdQgx0OoNUox7?=
 =?iso-8859-1?Q?zr+s7qFFXb/jfb89/zVQMXP3XTYzJHP2RdmHaIma6tkSv4N6yW8/TfsduK?=
 =?iso-8859-1?Q?QDWBFNU4TICE8n8QhR3+rib75nWBaYrosaIVSiHHQ1ztNrnkA6hFKP7RB0?=
 =?iso-8859-1?Q?k82T3P5lehi8tkFnGjl8cI8VQvx7Gf78qD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f28a8e1-00a3-4d48-9aee-08ddb48f4512
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 08:55:59.0683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZzDzDLfAp4Zyuk1YGwTI2U21tSBhKdWqKSHE8VB+qBvxSaHxyRQ+C6sVkzCBBThdtlhagwwutm4+VdBUAp5KTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8525
X-OriginatorOrg: intel.com

On Wed, Jun 25, 2025 at 10:47:47PM +0800, Edgecombe, Rick P wrote:
> On Wed, 2025-06-25 at 17:28 +0800, Yan Zhao wrote:
> > On Wed, Jun 25, 2025 at 02:35:59AM +0800, Edgecombe, Rick P wrote:
> > > On Tue, 2025-06-24 at 17:57 +0800, Yan Zhao wrote:
> > > > Could we provide the info via the private_max_mapping_level hook (i.e. via
> > > > tdx_gmem_private_max_mapping_level())?
> > > 
> > > This is one of the previous two methods discussed. Can you elaborate on what you
> > > are trying to say?
> > I don't get why we can't use the existing tdx_gmem_private_max_mapping_level()
> > to convey the max_level info at which a vendor hopes a GFN to be mapped.
> > 
> > Before TDX huge pages, tdx_gmem_private_max_mapping_level() always returns 4KB;
> > after TDX huge pages, it returns
> > - 4KB during the TD build stage
> > - at TD runtime: 4KB or 2MB
> > 
> > Why does KVM need to care how the vendor determines this max_level?
> > I think a vendor should have its freedom to decide based on software limitation,
> > guest's wishes, hardware bugs or whatever.
> 
> I don't see that big of a difference between "KVM" and "vendor". TDX code is KVM
> code. Just because it's in tdx.c doesn't mean it's ok for it to be hard to trace
> the logic.
> 
> I'm not sure what Sean's objection was to that approach, or if he objected to
> just the weird SIZE_MISMATCH behavior of TDX module. I think you already know
> why I don't prefer it:
>  - Requiring demote in the fault handler. This requires an additional write lock
> inside the mmu read lock, or TDX module changes. Although now I wonder if the
> interrupt error code related problems will get worse with this solution. The
> solution is currently not settled.
>  - Requiring passing args on the vCPU struct, which as you point out will work
> functionally today only because the prefault stuff will avoid seeing it. But
> it's fragile
>  - The page size behavior is a bit implicit
Hmm, strictly speaking, all the 3 are not the fault of
tdx_gmem_private_max_mapping_level().

With tdx_gmem_private_max_mapping_level() to pass in the level, we can track
KVM_LPAGE_GUEST_INHIBIT with tdx.c without changing lpage_info.
tdx.c then has the freedom to change KVM_LPAGE_GUEST_INHIBIT to some more
flexible scheme in future while keeping KVM MMU core intact.

But with lpage_info, looks we can save some memory.
The downside is that we may need to update TDX MMU core in case of future
changes.

> I'm coming back to this draft after PUCK. Sean shared his thoughts there. I'll
> try to summarize. He didn't like how the page size requirements were passed
> through the fault handler in a "transient" way. That "transient" property covers
> both of the two options for passing the size info through the fault handler that
> we were debating. He also didn't like how TDX arch requires KVM to map at a
> specific host size around accept. Michael Roth brought up that SNP has the same
> requirement, but it can do the zap and refault approach.
> 
> We then discussed this lpage_info idea. He was in favor of it, but not, I'd say,
> overly enthusiastic. In a "least worst option" kind of way.
> 
> I think the biggest downside is the MMU write lock. Our goal for this series is
> to help performance, not to get huge page sizes. So if we do this idea, we can't
> fully waive our hands that any optimization is pre-mature. It *is* an
> optimization. We need to either convince ourselves that the overall benefit is
> still there, or have a plan to adopt the guest to avoid 4k accepts. Which we
> were previously discussing of requiring anyway.
> 
> But I much prefer the deterministic behavior of this approach from a
> maintainability perspective.
> 
> > 
> > > > Or what about introducing a vendor hook in __kvm_mmu_max_mapping_level() for a
> > > > private fault?
> > > > 
> > > > > Maybe we could have EPT violations that contain 4k accept sizes first update the
> > > > > attribute for the GFN to be accepted or not, like have tdx.c call out to set
> > > > > kvm_lpage_info->disallow_lpage in the rarer case of 4k accept size? Or something
> > > > Something like kvm_lpage_info->disallow_lpage would disallow later page
> > > > promotion, though we don't support it right now.
> > > 
> > > Well I was originally thinking it would not set kvm_lpage_info->disallow_lpage
> > > directly, but rely on the logic that checks for mixed attributes. But more
> > > below...
> > > 
> > > > 
> > > > > like that. Maybe set a "accepted" attribute, or something. Not sure if could be
> > > > Setting "accepted" attribute in the EPT violation handler?
> > > > It's a little odd, as the accept operation is not yet completed.
> > > 
> > > I guess the question in both of these comments is: what is the life cycle. Guest
> > > could call TDG.MEM.PAGE.RELEASE to unaccept it as well. Oh, geez. It looks like
> > > TDG.MEM.PAGE.RELEASE will give the same size hints in the EPT violation. So an
> > > accept attribute is not going work, at least without TDX module changes.
> > > 
> > > 
> > > Actually, the problem we have doesn't fit the mixed attributes behavior. If many
> > > vCPU's accept at 2MB region at 4k page size, the entire 2MB range could be non-
> > > mixed and then individual accepts would fail.
> > > 
> > > 
> > > So instead there could be a KVM_LPAGE_GUEST_INHIBIT that doesn't get cleared
> > Set KVM_LPAGE_GUEST_INHIBIT via a TDVMCALL ?
> > 
> > Or just set the KVM_LPAGE_GUEST_INHIBIT when an EPT violation contains 4KB
> > level info?
> 
> Yes, that's the idea. 2MB accepts can behave like normal.
> 
> > 
> > I guess it's the latter one as it can avoid modification to both EDK2 and Linux
> > guest.  I observed ~2710 instances of "guest accepts at 4KB when KVM can map at
> > 2MB" during the boot-up of a TD with 4GB memory.
> 
> Oh, wow that is more than I expected. Did you notice how many vCPUs they were
> spread across? What memory size did you use? What was your guest memory
> configuration?
The guest memory is 4GB, 8 vCPUs.
The memory slots layout is:
slot 1: base gfn=0, npages=0x80000
slot 2: base gfn=0x100000, npages=0x80000
slot 3: base gfn=0xffc00, npages=0x400

The GFN spread for the ~2710 instances is:
GFNs 0x806-0x9ff (1 time for each of 506 pages)
GFNs 0x7e800-0x7e9ff (1 time for each of 512 pages)
GFN: 0x7d3ff~0x7e7fe (repeated private-to-shared, and shared-to-private are
                      conducted on this range), with the top 3 among them being:
     0x7d9da (476 times)
     0x7d9d9 (156 times)
     0x7d9d7 (974 times)

All those instances are from vCPU 0, when the guest is in EDK2 and during early
kernel boot.

Based on my observation, the count of these instances does not scale with guest
memory. In other words, the count remains roughly the same even when the guest
memory is increased to 8GB.

> > But does it mean TDX needs to hold write mmu_lock in the EPT violation handler
> > and set KVM_LPAGE_GUEST_INHIBIT on finding a violation carries 4KB level info?
> 
> I think so. I didn't check the reason, but the other similar code took it. Maybe
> not? If we don't need to take mmu write lock, then this idea seems like a clear
> winner to me.
Hmm,  setting KVM_LPAGE_GUEST_INHIBIT needs trying splitting to be followed.
So, if we don't want to support splitting under read mmu_lock, we need to take
write mmu_lock.

I drafted a change as below (will refine some parts of it later).
The average count to take write mmu_lock is 11 during VM boot.

There's no signiticant difference in the count of 2M mappings
During guest kerne booting to login, on average: 
before this patch: 1144 2M mappings 
after this patch:  1143 2M mappings.

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index f999c15d8d3e..d4e98728f600 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -322,4 +322,8 @@ static inline bool kvm_is_gfn_alias(struct kvm *kvm, gfn_t gfn)
 {
        return gfn & kvm_gfn_direct_bits(kvm);
 }
+
+void hugepage_set_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level);
+bool hugepage_test_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level);
+
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f0afee2e283a..28c511d8b372 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -721,6 +721,8 @@ static struct kvm_lpage_info *lpage_info_slot(gfn_t gfn,
  */
 #define KVM_LPAGE_MIXED_FLAG   BIT(31)

+#define KVM_LPAGE_GUEST_INHIBIT_FLAG   BIT(30)
+
 static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
                                            gfn_t gfn, int count)
 {
@@ -732,7 +734,8 @@ static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,

                old = linfo->disallow_lpage;
                linfo->disallow_lpage += count;
-               WARN_ON_ONCE((old ^ linfo->disallow_lpage) & KVM_LPAGE_MIXED_FLAG);
+               WARN_ON_ONCE((old ^ linfo->disallow_lpage) &
+                             (KVM_LPAGE_MIXED_FLAG | KVM_LPAGE_GUEST_INHIBIT_FLAG));
        }
 }

@@ -1653,13 +1656,15 @@ int kvm_split_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range)
        bool ret = 0;

        lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
-                           lockdep_is_held(&kvm->slots_lock));
+                           lockdep_is_held(&kvm->slots_lock) ||
+                           srcu_read_lock_held(&kvm->srcu));

        if (tdp_mmu_enabled)
                ret = kvm_tdp_mmu_gfn_range_split_boundary(kvm, range);

        return ret;
 }
+EXPORT_SYMBOL_GPL(kvm_split_boundary_leafs);

 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
@@ -7734,6 +7739,18 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
                vhost_task_stop(kvm->arch.nx_huge_page_recovery_thread);
 }

+bool hugepage_test_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+       return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_GUEST_INHIBIT_FLAG;
+}
+EXPORT_SYMBOL_GPL(hugepage_test_guest_inhibit);
+
+void hugepage_set_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+       lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_GUEST_INHIBIT_FLAG;
+}
+EXPORT_SYMBOL_GPL(hugepage_set_guest_inhibit);
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
                                int level)
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 244fd22683db..4028423cf595 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1852,28 +1852,8 @@ int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
        if (KVM_BUG_ON(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE || level != PG_LEVEL_2M, kvm))
                return -EINVAL;

-       /*
-        * Split request with mmu_lock held for reading can only occur when one
-        * vCPU accepts at 2MB level while another vCPU accepts at 4KB level.
-        * Ignore this 4KB mapping request by setting violation_request_level to
-        * 2MB and returning -EBUSY for retry. Then the next fault at 2MB level
-        * would be a spurious fault. The vCPU accepting at 2MB will accept the
-        * whole 2MB range.
-        */
-       if (mmu_lock_shared) {
-               struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-               struct vcpu_tdx *tdx = to_tdx(vcpu);
-
-               if (KVM_BUG_ON(!vcpu, kvm))
-                       return -EOPNOTSUPP;
-
-               /* Request to map as 2MB leaf for the whole 2MB range */
-               tdx->violation_gfn_start = gfn_round_for_level(gfn, level);
-               tdx->violation_gfn_end = tdx->violation_gfn_start + KVM_PAGES_PER_HPAGE(level);
-               tdx->violation_request_level = level;
-
-               return -EBUSY;
-       }
+       if (mmu_lock_shared)
+               return -EOPNOTSUPP;

        ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
        if (ret <= 0)
@@ -1937,28 +1917,51 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
        return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
 }

-static inline void tdx_get_accept_level(struct kvm_vcpu *vcpu, gpa_t gpa)
+static inline int tdx_check_accept_level(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
        struct vcpu_tdx *tdx = to_tdx(vcpu);
+       struct kvm *kvm = vcpu->kvm;
+       gfn_t gfn = gpa_to_gfn(gpa);
+       struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
        int level = -1;
+       u64 eeq_info;

-       u64 eeq_type = tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK;
+       if (!slot)
+               return 0;

-       u32 eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
-                       TDX_EXT_EXIT_QUAL_INFO_SHIFT;
+       if ((tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK) !=
+           TDX_EXT_EXIT_QUAL_TYPE_ACCEPT)
+               return 0;

-       if (eeq_type == TDX_EXT_EXIT_QUAL_TYPE_ACCEPT) {
-               level = (eeq_info & GENMASK(2, 0)) + 1;
+       eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
+                   TDX_EXT_EXIT_QUAL_INFO_SHIFT;

-               tdx->violation_gfn_start = gfn_round_for_level(gpa_to_gfn(gpa), level);
-               tdx->violation_gfn_end = tdx->violation_gfn_start + KVM_PAGES_PER_HPAGE(level);
-               tdx->violation_request_level = level;
-       } else {
-               tdx->violation_gfn_start = -1;
-               tdx->violation_gfn_end = -1;
-               tdx->violation_request_level = -1;
+       level = (eeq_info & GENMASK(2, 0)) + 1;
+
+       if (level == PG_LEVEL_4K) {
+              if (!hugepage_test_guest_inhibit(slot, gfn, PG_LEVEL_2M)) {
+                       struct kvm_gfn_range gfn_range = {
+                               .start = gfn,
+                               .end = gfn + 1,
+                               .slot = slot,
+                               .may_block = true,
+                               .attr_filter = KVM_FILTER_PRIVATE,
+                       };
+
+                       scoped_guard(write_lock, &kvm->mmu_lock) {
+                               int ret;
+
+                               ret = kvm_split_boundary_leafs(kvm, &gfn_range);
+
+                               if (ret)
+                                       return ret;
+
+                               hugepage_set_guest_inhibit(slot, gfn, PG_LEVEL_2M);
+                       }
+              }
        }
+
+       return 0;
 }

 static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
@@ -1987,7 +1990,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
                 */
                exit_qual = EPT_VIOLATION_ACC_WRITE;

-               tdx_get_accept_level(vcpu, gpa);
+               if (tdx_check_accept_level(vcpu, gpa))
+                       return RET_PF_RETRY;

                /* Only private GPA triggers zero-step mitigation */
                local_retry = true;
@@ -3022,9 +3026,6 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)

        vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;

-       tdx->violation_gfn_start = -1;
-       tdx->violation_gfn_end = -1;
-       tdx->violation_request_level = -1;
        return 0;

 free_tdcx:
@@ -3373,14 +3374,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
                                       gfn_t gfn, bool prefetch)
 {
-       struct vcpu_tdx *tdx = to_tdx(vcpu);
-
-       if (unlikely((to_kvm_tdx(vcpu->kvm)->state != TD_STATE_RUNNABLE) || prefetch))
+       if (unlikely((to_kvm_tdx(vcpu->kvm)->state != TD_STATE_RUNNABLE)))
                return PG_LEVEL_4K;

-       if (gfn >= tdx->violation_gfn_start && gfn < tdx->violation_gfn_end)
-               return tdx->violation_request_level;
-
        return PG_LEVEL_2M;
 }

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index acd18a01f63d..3a3077666ee6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2610,6 +2610,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn

        return NULL;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);

 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {

