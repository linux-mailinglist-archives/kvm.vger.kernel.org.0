Return-Path: <kvm+bounces-58009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C5EB852EB
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:22:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 245607A33C5
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 14:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D54823E35B;
	Thu, 18 Sep 2025 14:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HQOoYOzg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9727C17B506;
	Thu, 18 Sep 2025 14:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758204947; cv=fail; b=sd177TlScNtMjX/1AGHR8qZg/YKwRrUaH2nn6+DhaTTVk75VjIHMtLz9knHXR+hBciDD/s4fNu1p3BwJ2+eV7obsfpXPso1oOT8OEwnIz8B1KwV4a2gTYLot/pNURgiNmuI37KM2oQvSZE7qCeLZOCItGs5gFb7UNad+3HcriC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758204947; c=relaxed/simple;
	bh=0iYAYK5lDQlHpCkYThgF2XpMI37quNx/KVaaxRT4mJg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ogqc5IgWLgmUdynh9o7YL9XLB4cyaDM5AnwlTsFDhhGsTbnyb9xx+tC4DG2Q+Ml+g3kqKv99AI9QRR/OQR3qYeVXiD1lIkY6xBymLBtew6e91qJcgkUG80puC6FSdXoHRRVAIfnDXWD+OCrhb1lFFH/VlKiMZKFYovYbT2iYM0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HQOoYOzg; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758204946; x=1789740946;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0iYAYK5lDQlHpCkYThgF2XpMI37quNx/KVaaxRT4mJg=;
  b=HQOoYOzghy1NrOYXWU5XID223n2P9+xpn849AQKmE3lb0YA69+PageGG
   E4elqsUx7r3xNtBUol3pqTBhxjyfi/H8HKmVSBsC/0ojmoypRW9OUuA22
   ukYOTF8PHY9WaXlu5+WvxUxkzokN33YEgcCogHErTdkH6TwR/G3VTPQp3
   J5/n2YgTzU6plDM44zt5bTT5+bWFoH6656FoVO9GoR7G8GcRkb6KOGB/h
   POp3LvxxZRhbdGtVoBFOX10X9K2jnq6kqgB8zqw8GGfK5D2rAWw/kNdxP
   pD3iMQNkOZmuY+tbEs+nGgIDN6ItyCkfq+tlp12p7WMrqOULo6Vhr0SAZ
   Q==;
X-CSE-ConnectionGUID: 6KiJPMprTYOKXSv6p0vzSg==
X-CSE-MsgGUID: +dv00UCsRrmxbHMKxAL6Mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60424571"
X-IronPort-AV: E=Sophos;i="6.18,275,1751266800"; 
   d="scan'208";a="60424571"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 07:15:19 -0700
X-CSE-ConnectionGUID: ZwiKzzZRTN6n7qwp8NNzIQ==
X-CSE-MsgGUID: sqY8ICnQRx6mCM4UiHlsHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,275,1751266800"; 
   d="scan'208";a="212705063"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 07:15:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 07:15:16 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 07:15:16 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.5) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 07:15:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6NwdXBKrJsNh74ABhkinDkzCGYG/VOQA5gK3uo2ilNzPbdf3BQmX0ufqS12Dc7ySK5/kDXv5a/0Zhnepxot7NfN19G01FGROebH+QLTUR8BGS0EjlQ6FpG3dHm2bpE/SBM9YpSd4/InEyRaHEOKt54j8iJ6nIQSOP/XqKE/mPN3iDtAAY06tyVuXZYuUNutGUlHtBbE38SLUIQ9Nk/SfdOzELJo+pdRBa89wE5+z5vNhLkRNLF4x/DnRqRqM2S9HdITu8uomtytcb6eDmSq///8a11ggdTo7gtOjgFoMKPY8wYTrnlijsIQR0VBaaemf/3T3Jiklb2ed9DeipE6wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+cN9fWRhUWSZoQyYGKOoGPoDFxqzdKxX37dN/FxhnAE=;
 b=kUeurH1we2Dc6w3dUcwuk7owysnakZznQYE7EGe/xLyhzheiPApN9zcNvWYsgFpYhqP5cvoRZ4Uhmec3ENye191brbMoBBDGA3n9TBK8JS0+K5f9G79d3yvJdCXos+Q5csbshwo3C9TB6jPNGvDl0F21O6aOEpwRhrzXzsbTuqSc40nY7w/eAsaBQgG7zcVeUkzEcXDozueIQLfuCykFvmKiJ8L6Dk8cUi+YMXOw8xz9/Rq5Ez4YMWDihHLnMZfFECLW+fTXEoXiM7LK2RcLBWIaAPfE/AI8/bPrZmZpG16Sl6HssGBPX6vzO1MtjwMMb9MYw5kpZMRoIw8JQrSMUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB6860.namprd11.prod.outlook.com (2603:10b6:510:200::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 14:15:13 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9115.022; Thu, 18 Sep 2025
 14:15:12 +0000
Date: Thu, 18 Sep 2025 22:15:02 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause
	<minipli@grsecurity.net>, John Allen <john.allen@amd.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, "Zhang Yi
 Z" <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v15 18/41] KVM: x86: Don't emulate instructions affected
 by CET features
Message-ID: <aMwT5nfXEFLJvvrP@intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-19-seanjc@google.com>
 <55ab5774-0fcc-469a-8edc-59512def2bae@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <55ab5774-0fcc-469a-8edc-59512def2bae@intel.com>
X-ClientProxiedBy: TPYP295CA0037.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB6860:EE_
X-MS-Office365-Filtering-Correlation-Id: 90783995-6645-46a6-64fd-08ddf6bdc821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?KQxIlKKoq8LQGSuM7kkdtHU1HMSh39+3pReHH007A/U6cNCOQ0HeOLMNdT0o?=
 =?us-ascii?Q?z7OlgEax6TzX0piJzotZSj0zCAF70Vpk/5jiMypnpaSxoyHHMZwN4Qto+5Cl?=
 =?us-ascii?Q?Yx+lG2oDhv5ztFZDtTPScUL2UISc0LgY/i90SrTjyC87dvVNnPEKRT6qhBkU?=
 =?us-ascii?Q?4REgkz6I8Qde7AskGNcp4SzjJNkWcavYfreU+foHnKjEFjj8D4Goql/IPJCt?=
 =?us-ascii?Q?+vFbZXwkqQcnRgte6cWUgGm5FZkzShUAUh8yYnQCjXpQ/eyVht4//UslT11g?=
 =?us-ascii?Q?e/CC0aWugQzu2v/hTwzR7d/HAZpN8s5gSanTCq4P237HgaXBSCTuQyN3R+l3?=
 =?us-ascii?Q?BtC++MnnX1ZsTrUN8gom+3iUQtIK8a469r5cBpK4rXvWx87iK6vCbwni6YAz?=
 =?us-ascii?Q?B8apn2Vs0xap4/L6bVrn4gZWGKI7pVEsKDTVN+++tDSSdr1bUdDevMDGSIhV?=
 =?us-ascii?Q?Lf5kr7YYxfcxoZtAlLCgB8S9bqxETmZKCvVHpdeCvquqrDYKdojTLR18qtUM?=
 =?us-ascii?Q?sKRTbR1L9r5ipjXYSqkc/QdLkLDIvIcFilTCxszqXGrEvD720BtrOFq8HFAm?=
 =?us-ascii?Q?a1qUxNXS2ikVmgVxGrMc9fEmz66RJ5KDQzws9GGte8ddRsON4yPuasu5TtXc?=
 =?us-ascii?Q?/kiwkbT3ZCNJeplCJSGGTOLAQcbaYeuAvoaGvV7EDm2a0HozGiiCBY+NFwGI?=
 =?us-ascii?Q?tc4rTe1GPWef+5KpmeAb3p2HxZ8hCiNYovv/Vu1u8xX6oMgfWrl5mbmvGLZ8?=
 =?us-ascii?Q?sdLQqyIyi8hFxk1FqqMIS5hFrWhYPIhx7LnnkXSaB7u5cMv/XkqQvkGX0KWf?=
 =?us-ascii?Q?H9SWShpy7dgGmjcoHj9Yo6Khj67t0r/saYkSjQymRx9pgIqNbjqehCDISWFn?=
 =?us-ascii?Q?IDUaKobkqnEX+tD3BpSYaghs495mxtW4WZ4KMHyw6QIYL4KPLNlK5lPOUUIX?=
 =?us-ascii?Q?kGuiTVkCLf3fmJg8YAOzl/qdSfKUpPjmISZm80ufhhIFoECP3eFBJUk3Ct5f?=
 =?us-ascii?Q?q6iLEHQTNzEF4kggzcjsMcr7d3mYy7ehDdwzE8S7dqQe6aQaT2IH1bhgn7O3?=
 =?us-ascii?Q?U2jnX7DYMJx71AlDBQJHIc7jpwWW9JbUTX0iXsXESZVii8aJ7gwInyxgZQED?=
 =?us-ascii?Q?46MuYtSd2DPO6aag3kXUTVCww2UkWbJw8Ptt6TF1556sTV/O0KnuPfHsWt5T?=
 =?us-ascii?Q?1vMHFG5eGVLH/Tsbk9HmfaiwS1Oea2RpgE/F+u2lmHV9q5cEXEWecJtfj6zA?=
 =?us-ascii?Q?5lTLqQaJVLAyLL+3dRvez1/FM0B3WaEdX3zTEJzZZmK5hKjJd8p6DS5ixbLg?=
 =?us-ascii?Q?+AGEAgbszY3GXcRRygWBwKElCvot2cOCHaBa/7+v3B8h+8O3xrwrGHdagxi4?=
 =?us-ascii?Q?m8jyCivUnEh37wStZzJC01kOT06hvoFKLgEZJna3qEQltyyumw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2QDr1cNuPsN2uckRu92pIvZCUXVhKTsYmsmNLjwlrCdTSk6RZINN3OnfAZEL?=
 =?us-ascii?Q?W2QAFNjBbRHa2qn0QykwC2dNa4gxVOlKimQhb5jBpRK1aazuH0KbxE2aI6h6?=
 =?us-ascii?Q?r4fEgRnKveWMasKH1D4Vej+HH067/0lABy6BQEBwa2deiLm12eLfci4EiYHL?=
 =?us-ascii?Q?R2vze2JHlA7wtjQOhadu/Np3419qlwz745WMPaQv181IhlcQRQITkqUUmrNT?=
 =?us-ascii?Q?s6zR+60kA7mHtoGFcHk1aLS1b5oD/ieEdecAKDkLBIdP6ARE2sVcz1u4VvEi?=
 =?us-ascii?Q?kBEC1+PbgrWi6cg+HH5VISuvtmDNGITJylbHYTc+3tabrioPuOtkQtOccqpz?=
 =?us-ascii?Q?mPxmk4mlmfMw+zJ5Uhfu3pTKHRnUfWAC672y+/x5bXNVl1a4/GpjJndQUT+x?=
 =?us-ascii?Q?Da+VsBkjL/vdB17q7SgAJJ9ZAfAxRyPqwWZ3rDnvjlZ9avJFZY7n93KKKBgZ?=
 =?us-ascii?Q?Pkze1qpl3LiyZ3Iqo/2vZgrNMg1CF22v7fYfNhH/43q7Rz/R4GZYUwe23lAk?=
 =?us-ascii?Q?cTiYjv2aZLNfZZcL16FvS1n9EkmS/TQa0ZnXmVE+mU0FFPhXAbEksztCnDBw?=
 =?us-ascii?Q?BoNzoelW7m50lDygh93tKcg0M25KNoqHDmudI7h3JDIu8XBCKxO0EwiC324U?=
 =?us-ascii?Q?Xdxxy02z8hvft9+zrRL8jhQquWhJA2qwv5bMg7F/96iGyzipozjgyznEe/pC?=
 =?us-ascii?Q?hv9LJPxWehgfiA/o/FGDBPvAhMvcgpw4j6a+M5JA1JakMvXGmj7582TxrRHb?=
 =?us-ascii?Q?Yrrqi10zEnmdsCwD8a/ZOrUFQQmWtRkmdJ7m2NfActX2imifhmTaTMsaFlq/?=
 =?us-ascii?Q?dVm0VBdIQbG+1INhHnzCf7rqI7+wZr75MaUhEf9CeidPUqWnN674TkVwCLHy?=
 =?us-ascii?Q?Q/jRX5MVAR/33dHNqlWjPjynjMA3fvMfqokjwjXeKwvj86YaOwP7drp1mDuU?=
 =?us-ascii?Q?TFYFBOIbTPwlh3Qt0rqMmCnRzdNagw86yYWCfVf1Y4dH8t4hkm/uc5TQyvr0?=
 =?us-ascii?Q?nJ9Z+DPR+SNen2IZAcRLz4kWvYjYBMn73eCQJzHNGUvwvp1IPcPl2wiN9HrM?=
 =?us-ascii?Q?5yE6I9TztZKWJ1REjSxOYtkYpCTgvuOGErVsh+5bIwmwL+8v8xwsldrQeqFq?=
 =?us-ascii?Q?IBIuWvKnPusH+J/OzLIhDDdiZB6GWDqKK7EW8rjokw1nm0ShrDP98oyyiu+M?=
 =?us-ascii?Q?xj3SqfiiKJHtirZ0gQtuG/1mIbUwpjzqqaWiK0G2IBI+aE/GAMP8jCxnX/fn?=
 =?us-ascii?Q?/dCv3BUEP+IVbNZm2BOoU4U0yhikyBtCDGQn1O1YgIoixzgKYGaZccsdO3JN?=
 =?us-ascii?Q?AWNNoDffPAhNB3WZP6X/6Fm6Gn92kDZGgJ16oJSpkVW52fqU1fi7K2CKPbHO?=
 =?us-ascii?Q?ZOPw6NnW+YuiOtmXwqTbCyhSgzuvr2GnsQugoMEDKYlN4LSPtd1LQ1O6PCfU?=
 =?us-ascii?Q?zuf6nma15OdPcINOyFHAy9IiWEzwVTL0+YRabwK8oNDu+eX+pv0wZtvlsGIr?=
 =?us-ascii?Q?zJXr1ZumNuFwfS6K6yl4/UbKyrwOLuATMcaCoAhlG1yktrUMGdHDBNK89zOZ?=
 =?us-ascii?Q?zQDWKCuDnh/4MfGa83vw+eu0jS0RwxNvIRK2bKUD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90783995-6645-46a6-64fd-08ddf6bdc821
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 14:15:12.7573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ENVVGfeaac3jLWpY4IWIAzgXXAR1nP98gL9a86CIeI4A3XIBqo64ryF4TCI429jJhkxC0cgJlPfAdK/lqKi0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6860
X-OriginatorOrg: intel.com

>> 
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 542d3664afa3..e4be54a677b0 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -178,6 +178,8 @@
>>   #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
>>   #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
>>   #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
>> +#define ShadowStack ((u64)1 << 57)  /* Instruction protected by Shadow Stack. */
>> +#define IndirBrnTrk ((u64)1 << 58)  /* Instruction protected by IBT. */
>>   #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>> @@ -4068,9 +4070,9 @@ static const struct opcode group4[] = {
>>   static const struct opcode group5[] = {
>>   	F(DstMem | SrcNone | Lock,		em_inc),
>>   	F(DstMem | SrcNone | Lock,		em_dec),
>> -	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
>> -	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
>> -	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
>> +	I(SrcMem | NearBranch | IsBranch | ShadowStack | IndirBrnTrk, em_call_near_abs),
>> +	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack | IndirBrnTrk, em_call_far),
>> +	I(SrcMem | NearBranch | IsBranch | IndirBrnTrk, em_jmp_abs),
>
>>   	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
>
>It seems this entry for 'FF 05' (Jump far, absolute indirect) needs to set
>ShadowStack and IndirBrnTrk as well?

Yes. I just checked the pseudo code of the JMP instruction in SDM vol2. A far
jump to a CONFORMING-CODE-SEGMENT or NONCONFORMING-CODE-SEGMENT is affected by
both shadow stack and IBT, and a far jump to a call gate is affected by IBT.

