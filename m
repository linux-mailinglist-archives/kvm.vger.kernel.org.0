Return-Path: <kvm+bounces-47343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B415EAC033C
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 05:55:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE4123BC7C2
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 03:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E9C15B54C;
	Thu, 22 May 2025 03:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="feGiT7CD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067E9155382;
	Thu, 22 May 2025 03:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747886118; cv=fail; b=EBPIwNvYUBUhnL5qYqxgLa5Y+kCJskyl4/lkycpEAPfNNrq/TW2IMDrqJsiN1B4Atbrsrh4QBehDvrH8yOAFq5sR63K1E+16K4hYZZTxOV8wx8G1cT8imXVc1XqmFH5cdemhS/5b70JhpOX1ns8ZvkfcMzd5DsfQv66mBDfao9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747886118; c=relaxed/simple;
	bh=lOXP+uVK6RzffAT7p6lgvsK1+4hvExkE7n3z7PK/kWI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oIGVXFbRGeW6gbQ/lFxac4uNXMdD8vMx1M9EOivvMvcaO4Zt0lHJr6yq492hx4cSn/uBEMOm1FezQkNPwaICmxrJIZXsL1K8SSiwnVMwDvzl5cMRZt4hsuMpSca90ti3MT5Xezs8BpZIMso2I15Eb+H+yOpZ1cD+okyEJQquTtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=feGiT7CD; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747886116; x=1779422116;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=lOXP+uVK6RzffAT7p6lgvsK1+4hvExkE7n3z7PK/kWI=;
  b=feGiT7CDmdvuoRQEicJ6moEz3htKR25HyL3/F0AIyHkasrgXamzVgLgW
   ZJXrO43f/YkIP+xRncCOKfLmz31oUaxx2o5hmmRmTm0zDk627cvhuaSXo
   nK06j+qUCz60CPu/x9joo3cF6XDWzTyHgxXrY5Lm0+seelZrJvmVj6RBd
   pmB4RqEq5otrAFSknozB0l+ScwCxpCXqyWqJ75O0L4FVtfk6ftXAQRSXP
   QJNIP6ML8aFWeqsQkA1jumfjAhZJhpG6Onv0tFznb0MV6yqER/LxwTX3K
   1Xn3y/83eRs2z7PMn7eTZ3Od11xsKVPA9KHu+HWs/4fl2JxsQ8elBeVkB
   w==;
X-CSE-ConnectionGUID: QPRi/Z7rSuGosedJbsJWew==
X-CSE-MsgGUID: k44Ri4NFSuydx0iPgoipSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="67447130"
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="67447130"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 20:55:15 -0700
X-CSE-ConnectionGUID: 3TGPdkihQRaVm9I1+veA7w==
X-CSE-MsgGUID: HdmxCdsmQpCxk/j3Bp07LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="141454069"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 20:55:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 20:55:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 20:55:14 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 20:55:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I8Fuz5jb+riodvPY0Gtyk3UursF9inVmnIJwFgF2C2SJGW0DdCQy6nswXv0Dn6nXdMnOSMjtuVPTzdjozYpLaB4ytaIs6mDfAi4lKScszbwaBTyozEtzlQHxJzye8L9e3MA7pPcph9UZogaVZTcd+NtARTxfvbGL+ZWYM0ugzLoZPWEEe1ltnd1yAJyTDd2a8CgYLVdmy7pg0g7x54Bz0EidLyN+4v+sGFQD90oddhkgqel/x2eFNtZ6Qa+sX9OXLtKvAYcAnpWGjQIs9IW8wqIUt1o2l0XuVseLJHhRVLi/ON58rV1lQ1+Ag/9vDy2zxkHv+IdL2ijsPDQZohSlbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LodVXZ/falutJCtrlGd2Z8Zdu5QRv+bvQB4f3XnmvSU=;
 b=KcT6b9mGdkb5+yfj3cgmPhLhsOv3jWMiLdZOsKtqoBJ+JmvOnx2D0vzBlJMxtfpfckWBoEaqE+tZ/yTI6UM9GYrmbiYFYqgDhmbCu2YdTNFOpHbf0zrVHsjP+/zP4UmX+0CBZPNz0ZErz0zmCQV1R3bwqinpw28oSiSMMD0cjscLgk4sGQTbWpqikNHS1ERB+SGwDI7dIrsDehgyzbtOfs4/uTtsOVxQQCa+OACLISbUK0DmP0h2MG0RWbxBtkbO3U0/uayQGosJFfCxsVy/1DPmdIZbd0+vnHMPyd83Uvp/yObQSKSPpV8G0hS07vz/X0xafCUnkM+H8PBIR6qajw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM3PR11MB8681.namprd11.prod.outlook.com (2603:10b6:0:49::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.32; Thu, 22 May 2025 03:55:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 03:55:09 +0000
Date: Thu, 22 May 2025 11:52:56 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aC6fmIuKgDYHcaLp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030618.352-1-yan.y.zhao@intel.com>
 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
 <d922d322901246bd3ee0ba745cdbe765078e92bd.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d922d322901246bd3ee0ba745cdbe765078e92bd.camel@intel.com>
X-ClientProxiedBy: SG2PR01CA0144.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::24) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM3PR11MB8681:EE_
X-MS-Office365-Filtering-Correlation-Id: 1daca822-3fd4-45f6-bad7-08dd98e4725d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?Jb+aE/y9kqxqUN3Q5sGQzO3gMLEpKeYvNyU+wLm0mgxGjBfY6u2JhTzylM?=
 =?iso-8859-1?Q?PkqA9VEaZ7ty/HHz0yI50HqlVvnxN7mLTq0MFC1rmsOA6ghV3G7R5mVRfQ?=
 =?iso-8859-1?Q?FIlOgPEcooXPlXzikEr3daHuuq+OO57cAgn3akLl/8CIk4BgybKGes5XnH?=
 =?iso-8859-1?Q?HVFfFnhHglLcM1G4xESk2hQW8538FC+lCs8YbvIVdDv3fC5a5NQNafp429?=
 =?iso-8859-1?Q?ptdqaAvPt3BKUr+yAVzYSryXPgQiXnFbqQiZ73Ojpyda1q8woBB+c4hiHe?=
 =?iso-8859-1?Q?v8iOuDbUIULOqDGR+6F1LJO8XyeuC3uv6tMQBqrU5k6WBGFRXkiBEdSf+U?=
 =?iso-8859-1?Q?or0IAdHqR1F6JTpFIZyIsXJ0wvk1ckjiqY5FStg8PxsnkEDhi+5IWqRA5Y?=
 =?iso-8859-1?Q?3iLXeOV0l6kSWAlaIXVZFmiVnGbfdxJglS9tjEJnkiRWpVIV0jiznbijNe?=
 =?iso-8859-1?Q?Ex9PIKimgc2vDtVb75OybsBeEN2/ltk+sSZXBiNahpHbYS3ckgOF9z62ZS?=
 =?iso-8859-1?Q?KsaLSYbKxa/F3Dwn/4JgAmjD+jEpTFkaRJeNRTudFpBEARB2iz3ZDeLc3W?=
 =?iso-8859-1?Q?mBgtDX9GzAIfOrYEdXsXYn1CgRs316DqFRK1s5MjkayZejXW8Pi+Jhy9E7?=
 =?iso-8859-1?Q?LiQsZd10k3PsU/TWNS36IMpk5OELZY8r8Z/C3dffjdZMXFKmt3zUz64tth?=
 =?iso-8859-1?Q?tMLjjLLLA3RLi1m3/Ci9oDmjtJxnUW2GgToWLZuFPR33VyAjHNjZLIanxn?=
 =?iso-8859-1?Q?OuEZXQ7u1PCbYz5JqE1u23CbCZ3cTEBRr76UmaBl5+Fjh4L2OclnDzsM7c?=
 =?iso-8859-1?Q?0TEewrmcgkIbCquU20Ej0vWskhohTbPrUBzIBvP3Hpm0wW1+71RZlWfN/2?=
 =?iso-8859-1?Q?gCraI3gS8XtyFb1DM0r6OSp+v2HY5+4JW+1BhotpCJiM3MSu1mm7adFd1x?=
 =?iso-8859-1?Q?eqymcCCXjf/ZKsO0QWOkA9YDklwmJyX3ZJXMbZQF7OqSIvgaS6APzCK27Q?=
 =?iso-8859-1?Q?bw9yeKrpGYUKoJkWh8/nEjlEeMs77ejmOiWiWI+9GMg48nGec87gVgb9gL?=
 =?iso-8859-1?Q?TW1OG2/f1zZ9qDBIzjgrCBT5xKhRXdRtLup46tRQNn1tJPz0ZwKzLzYA4R?=
 =?iso-8859-1?Q?abJbinrU07cDuA7Cu2Qoykggwsu3Y+6oJYdZ/i3cpyR9A7IQBhmRe9rXeJ?=
 =?iso-8859-1?Q?vh04z6qPslReABUYSDS9Q0w8GIF2MkiKK4PloK/QxdDUbxxj1xn0MKT7Ts?=
 =?iso-8859-1?Q?8ejGtGCDZmxkXO3gtH69RSnNO/ayT4rzq1SbUqjrwBgtgbM/UWZvFBzHo7?=
 =?iso-8859-1?Q?5qKsRRvjrl8VXONZm1hojnq4dHjh+SNVe/FQL/X7KH7dttia1FYl8L2Jgq?=
 =?iso-8859-1?Q?nPl9feowT6ag+MaWnC82hDvquJ0DqYuxuHBIokvui9dXO4q0ZNd0j2T/KD?=
 =?iso-8859-1?Q?dDn0XqhWZ7j20bVh?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Pr9NSXUxpDOyeWkBQGjj19LlT6bQj2chsqmBPhuUf8DW2v5s3jR5Rt/UN2?=
 =?iso-8859-1?Q?ircVxbtvHR+VzbRc+WwUU+qzQYRccxaQ2pARQ1GIZJUEpSucbuJb+eWZeu?=
 =?iso-8859-1?Q?+LuQemTivR9bJE2Y40l8ueJduUEuft+q1ZlZmQSdyguyEYRdZ61HnNvrgp?=
 =?iso-8859-1?Q?bLBoFhPE3Z1VbfQK8QusfZSZvvYfB2U0Bv8pMRiF88nZmaP+PBkf//Eno/?=
 =?iso-8859-1?Q?Txif1FWzvNgo/Vi4yRitetjA3zl6VESh5abaNkBieZ+WDdVkGkaVy43MJe?=
 =?iso-8859-1?Q?g/r/cDSSVQDmbwiRkdB5f60HJPaRrDK+0HwW04rlmphmw8QlII8pP6UBph?=
 =?iso-8859-1?Q?exUTXs5K6Srqh8DMQVrO0NhUMqU7jUcO9IuPHfT4Z9UeyQRrBdeVJo7Taw?=
 =?iso-8859-1?Q?AUMy5gVPokgpTR3vqNZKIDIRVW7lwllH/qgzmtrQyq0P27W4LSvpOvKbBv?=
 =?iso-8859-1?Q?3EQOkprZtkSreBO6bAlaO4v7hj/HNY8tHJnaFVkRc4DOLOYfV5bz87SqZo?=
 =?iso-8859-1?Q?yMBQQb0ygWEIAHOVs0MCQ6HG1x3eBaG3VpLT4tBsTUORsdwYfXq3wpsh91?=
 =?iso-8859-1?Q?xyeMoiuJyY11VAro7E7SkWgaODo8Sf9CwfoTOkNYkS9LBygRSrpifDE4gy?=
 =?iso-8859-1?Q?vZqo78yjv5UGoTp78viSrXG3YX/4Z8VU8yndKzg3whk9qcUQhoA1qtNplW?=
 =?iso-8859-1?Q?2YB6gYfhhmlbWlwlsrcLiIlMGrGQbKZwvGhR+vgeu5bU07IcUzYHJlld4L?=
 =?iso-8859-1?Q?ZAaZ3ankH8l0veVRHA6frsY+Rg94D+4lbpYKa7EACmLeVc0Evge/JyS95j?=
 =?iso-8859-1?Q?hf6sH0DEYLL0HuBziBOOAQCZSz3mw67RMfNP0jvYSUBayNFfifbfiAnxtv?=
 =?iso-8859-1?Q?3QibWI/WxRqfuFUpP+gCbfDy7z4YWZB1AQlKYDl/dlWlhMA0UO/EgCnuFu?=
 =?iso-8859-1?Q?Jofdy/8qKYuQOcZM292buNwf4FdCKVDOZekjwLKbaAZVTZ9MuGH9MIo1+2?=
 =?iso-8859-1?Q?auj7qKvbTVA1Xj6+9ne5/ldYaQJj9J9KN0LJnml0pWmqAOwxj9QHKFiWdB?=
 =?iso-8859-1?Q?w8cRa7y2sI6/A3YRPHtoRNlaCmqhymD+eHjFMpZpRx79V+2pxZ5f2Iy14W?=
 =?iso-8859-1?Q?JxDwEuix4ErQnCp0UKH2LhVvXIHbiQBqDZgJDLp7SIX1QaGOaX83hOe/kt?=
 =?iso-8859-1?Q?ayedyBH78qiNyOgF0zFEGWmwXKni6s/zoUfIodeB37g5uiO0FJtFjH9DAZ?=
 =?iso-8859-1?Q?+dwCkMIXSzNkoAu5uPGckD3Qhtse989/II1EWbJWktJz94PmKuEdpCoJYP?=
 =?iso-8859-1?Q?9hcN2CcH8nSyFwYV32dWZDTQl1nKp7zkqNtpiKFHDbkFXTlG5Hhday0TfN?=
 =?iso-8859-1?Q?ap2sOc/v3luL78unyj2kgWNCcW9lNxG3vEcMi3Xn2v/2Cm4LZTUcbog+7x?=
 =?iso-8859-1?Q?UvK3v6Jnrx/cwKlXZTJIKEqwd8l3TYaPh/br7VlvnVbcE8s+LIjznhSVQn?=
 =?iso-8859-1?Q?xOnbGnMn9gA9sWxQsC4DkuM5SdznPrFg/7lD/ybrjRNx3uH7cvV/Fnei9Z?=
 =?iso-8859-1?Q?np5yf8XyjjWdz2s9K6nJyln24c0VmXdzJ5aOJsPQALr8P6a7okJwx1c5ga?=
 =?iso-8859-1?Q?DQVhye8xsv5JEDa4B4MBVbAs8vXPsHS6Yq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1daca822-3fd4-45f6-bad7-08dd98e4725d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 03:55:09.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tGsatk9ZVwXyM8Q3c26uT+HAZkh3j6MF6lwUYdp9mLf3JWqimftDn0MaEw0Gq+FKRMB9DgfEwStCW8cqMmfVcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8681
X-OriginatorOrg: intel.com

On Wed, May 21, 2025 at 11:40:15PM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-05-20 at 17:34 +0800, Yan Zhao wrote:
> > So, you want to disallow huge pages for non-Linux TDs, then we have no need
> > to support splitting in the fault path, right?
> > 
> > I'm OK if we don't care non-Linux TDs for now.
> > This can simplify the splitting code and we can add the support when there's a
> > need.
> 
> We do need to care about non-Linux TDs functioning, but we don't need to
> optimize for them at this point. We need to optimize for things that happen
> often. Pending-#VE using TDs are rare, and don't need to have huge pages in
> order to work.
> 
> Yesterday Kirill and I were chatting offline about the newly defined
> TDG.MEM.PAGE.RELEASE. It is kind of like an unaccept, so another possibility is:
> 1. Guest accepts at 2MB
> 2. Guest releases at 2MB (no notice to VMM)
> 3. Guest accepts at 4k, EPT violation with expectation to demote
> 
> In that case, KVM won't know to expect it, and that it needs to preemptively map
> things at 4k.
> 
> For full coverage of the issue, can we discuss a little bit about what demote in
> the fault path would look like?
For demote in the fault path, it will take mmu read lock.

So, the flow in the fault path is
1. zap with mmu read lock.
   ret = tdx_sept_zap_private_spte(kvm, gfn, level, page, true);
   if (ret <= 0)
       return ret;
2. track with mmu read lock
   ret = tdx_track(kvm, true);
   if (ret)
       return ret;
3. demote with mmu read lock
   ret = tdx_spte_demote_private_spte(kvm, gfn, level, page, true);
   if (ret)
       goto err;
4. return success or unzap as error fallback.
   tdx_sept_unzap_private_spte(kvm, gfn, level);

Steps 1-3 will return -EBUSY on busy error (which will not be very often as we
will introduce kvm_tdx->sept_lock. I can post the full lock analysis if
necessary).
Step 4 will be ensured to succeed.

Here's the detailed code for step 1, 3 and 4.

static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
                                     enum pg_level level, struct page *page,
                                     bool mmu_lock_shared)
{
        int tdx_level = pg_level_to_tdx_sept_level(level);
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
        gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
        u64 err, entry, level_state;

        /* Before TD runnable, large page is not supported */
        WARN_ON_ONCE(kvm_tdx->state != TD_STATE_RUNNABLE && level != PG_LEVEL_4K);

        if (mmu_lock_shared)
                lockdep_assert_held_read(&kvm->mmu_lock);
        else
                lockdep_assert_held_write(&kvm->mmu_lock);

        write_lock(&kvm_tdx->sept_lock);
        err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
        write_unlock(&kvm_tdx->sept_lock);

        if (unlikely(tdx_operand_busy(err))) {
                if (mmu_lock_shared)
                        return -EBUSY;

                /* After no vCPUs enter, the second retry is expected to succeed */
                write_lock(&kvm_tdx->sept_lock);
                tdx_no_vcpus_enter_start(kvm);
                err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
                tdx_no_vcpus_enter_stop(kvm);
                write_unlock(&kvm_tdx->sept_lock);
        }

        if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
            !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
                atomic64_dec(&kvm_tdx->nr_premapped);
                return 0;
        }

        if (KVM_BUG_ON(err, kvm)) {
                pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
                return -EIO;
        }
        return 1;
}

static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
                                        enum pg_level level, struct page *page,
                                        bool mmu_lock_shared)
{
       int tdx_level = pg_level_to_tdx_sept_level(level);
       struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
       gpa_t gpa = gfn_to_gpa(gfn);
       u64 err, entry, level_state;

       do {
               read_lock(&kvm_tdx->sept_lock);
               err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
                                       &entry, &level_state);
               read_unlock(&kvm_tdx->sept_lock);
       } while (err == TDX_INTERRUPTED_RESTARTABLE);

       if (unlikely(tdx_operand_busy(err)) {
                unsigned long flags;

                if (mmu_lock_shared)
                        return -EBUSY;

                tdx_no_vcpus_enter_start(kvm);
                read_lock(&kvm_tdx->sept_lock);

                local_irq_save(flags);
                err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
                                          &entry, &level_state);
                local_irq_restore(flags);
                read_unlock(&kvm_tdx->sept_lock);
                tdx_no_vcpus_enter_stop(kvm);
        }

        if (KVM_BUG_ON(err, kvm)) {
                pr_tdx_error_2(TDH_MEM_PAGE_DEMOTE, err, entry, level_state);
                return -EIO;
        }
        return 0;
}

static void tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn,
                                     enum pg_level level)
{
        int tdx_level = pg_level_to_tdx_sept_level(level);
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
        gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
        u64 err, entry, level_state;

        write_lock(&kvm_tdx->sept_lock);
        err = tdh_mem_range_unblock(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
        write_unlock(&kvm_tdx->sept_lock);

        if (unlikely(tdx_operand_busy(err))) {
                write_lock(&kvm_tdx->sept_lock);
                tdx_no_vcpus_enter_start(kvm);
                err = tdh_mem_range_unblock(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
                tdx_no_vcpus_enter_stop(kvm);
                write_unlock(&kvm_tdx->sept_lock);
        }

        if (KVM_BUG_ON(err, kvm)) {
                pr_tdx_error_2(TDH_MEM_RANGE_UNBLOCK, err, entry, level_state);
        }
}


> The current zapping operation that is involved
> depends on mmu write lock. And I remember you had a POC that added essentially a
> hidden exclusive lock in TDX code as a substitute. But unlike the other callers,
Right, The kvm_tdx->sept_lock is introduced as a rw lock. The write lock is held
in a very short period, around tdh_mem_sept_remove(), tdh_mem_range_block(),
tdh_mem_range_unblock().

The read/write status of the kvm_tdx->sept_lock corresponds to that in the TDX
module.

  Resources          SHARED  users              EXCLUSIVE users 
-----------------------------------------------------------------------
 secure_ept_lock   tdh_mem_sept_add            tdh_vp_enter
                   tdh_mem_page_aug            tdh_mem_sept_remove
                   tdh_mem_page_remove         tdh_mem_range_block
                   tdh_mem_page_promote        tdh_mem_range_unblock
                   tdh_mem_page_demote

> the fault path demote case could actually handle failure. So if we just returned
> busy and didn't try to force the retry, we would just run the risk of
> interfering with TDX module sept lock? Is that the only issue with a design that
> would allows failure of demote in the fault path?
The concern to support split in the fault path is mainly to avoid unnecesssary
split, e.g., when two vCPUs try to accept at different levels.

Besides that we need to introduce 3 locks inside TDX:
rwlock_t sept_lock, spinlock_t no_vcpu_enter_lock, spinlock_t track_lock.

To ensure the success of unzap (to restore the state), kicking of vCPUs in the
fault path is required, which is not ideal. But with the introduced lock and the
proposed TDX modules's change to tdg_mem_page_accept() (as in the next comment),
the chance to invoke unzap is very low.

> Let's keep in mind that we could ask for TDX module changes to enable this path.
We may need TDX module's change to let tdg_mem_page_accept() not to take lock on
an non-ACCEPTable entry to avoid contention with guest and the potential error
TDX_HOST_PRIORITY_BUSY_TIMEOUT.

> I think we could probably get away with ignoring TDG.MEM.PAGE.RELEASE if we had
> a plan to fix it up with TDX module changes. And if the ultimate root cause of
> the complication is avoiding zero-step (sept lock), we should fix that instead
> of design around it further.
Ok.

> > > I think this connects the question of whether we can pass the necessary info
> > > into fault via synthetic error code. Consider this new design:
> > > 
> > >   - tdx_gmem_private_max_mapping_level() simply returns 4k for prefetch and pre-
> > > runnable, otherwise returns 2MB
> > Why prefetch and pre-runnable faults go the first path, while
> 
> Because these are either passed into private_max_mapping_level(), or not
> associated with the fault (runnable state).
> 
> > 
> > >   - if fault has accept info 2MB size, pass 2MB size into fault. Otherwise pass
> > > 4k (i.e. VMs that are relying on #VE to do the accept won't get huge pages
> > > *yet*).
> > other faults go the second path?
> 
> This info is related to the specific fault.
> 
> >  
> > > What goes wrong? Seems simpler and no more stuffing fault info on the vcpu.
> > I tried to avoid the double paths.
> > IMHO, it's confusing to specify max_level from two paths.
> > 
> > The fault info in vcpu_tdx isn't a real problem as it's per-vCPU.
> > An existing example in KVM is vcpu->arch.mmio_gfn.
> 
> mmio_gfn isn't info about the fault though, it's info about the gfn being mmio.
> So not fault scoped.
> 
> > 
> > We don't need something like the vcpu->arch.mmio_gen because
> > tdx->violation_gfn_* and tdx->violation_request_level are reset in each
> > tdx_handle_ept_violation().
> > 
> > 
> > BTW, dug into some history:
> > 
> > In v18 of TDX basic series,
> > enforcing 4KB for pre-runnable faults were done by passing PG_LEVEL_4K to
> > kvm_mmu_map_tdp_page().
> > https://lore.kernel.org/all/1a64f798b550dad9e096603e8dae3b6e8fb2fbd5.1705965635.git.isaku.yamahata@intel.com/
> > https://lore.kernel.org/all/97bb1f2996d8a7b828cd9e3309380d1a86ca681b.1705965635.git.isaku.yamahata@intel.com/
> > 
> > For the other faults, it's done by altering max_level in kvm_mmu_do_page_fault(),
> > and Paolo asked to use the tdx_gmem_private_max_mapping_level() path.
> > https://lore.kernel.org/all/CABgObfbu1-Ok607uYdo4DzwZf8ZGVQnvHU+y9_M1Zae55K5xwQ@mail.gmail.com/
> > 
> > For the patch "KVM: x86/mmu: Allow per-VM override of the TDP max page level",
> > it's initially acked by Paolo in v2, and Sean's reply is at
> > https://lore.kernel.org/all/YO3%2FgvK9A3tgYfT6@google.com .
> 
> The SNP case is not checking fault info, it's closer to the other cases. I don't
> see that any of that conversation applies to this case. Can you clarify?
My concern of stuffing the error_code to pass in the fault max_level is that
if it's a good path, the TDX basic enabling code should have been implemented in
that way by always passing in 4KB.

Why Sean said
"
Looks like SNP needs a dynamic check, i.e. a kvm_x86_ops hook, to handle an edge
case in the RMP.  That's probably the better route given that this is a short-term
hack (hopefully :-D).
"
instead of suggesting TDX enable the error code path earlier and hardcode the
level to 4KB?

> On the subject of the whether to pass accept level into the fault, or stuff it
> on the vcpu, I'm still in the camp that it is better to pass it in the error
> code. If you disagree, let's see if we can flag down Sean and Paolo to weigh in.
Ok.

To document for further discussions with Sean and Paolo:

- Passing in max_level in tdx_gmem_private_max_mapping_level()
  Cons:
  a) needs to stuff info in the vcpu to get accept level info.

  Pros:
  a) a uniform approach as to SEV.
  b) dynamic. Can get more fault info, e.g. is_prefetch, gfn, pfn.
  c) can get increased/decreased level for a given gfn similarly to get the
     accept level
  d) flexibility for TDX to implement advanced features. e.g.
     1. determine an accept level after certain negotiation with guest
     2. pre-fetch memory


- To pass in max_level in error_code
  Cons:
  a) still need tdx_gmem_private_max_mapping_level() to get dynamic info.
  b) still need info stuffed on the vcpu under certain conditions. e.g.
     when promotion fails with TDX_EPT_INVALID_PROMOTE_CONDITIONS, we can skip
     the local retry by reducing the max_level.
  c) only effective in the EPT violation path.
  Pros:
     currently easy to pass in accept level info.


