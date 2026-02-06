Return-Path: <kvm+bounces-70400-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +GeHDjhShWmV/wMAu9opvQ
	(envelope-from <kvm+bounces-70400-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 03:30:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B2696F9525
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 03:30:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6F667304A212
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 02:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6938D2673AA;
	Fri,  6 Feb 2026 02:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FIVLr2YG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9882561A7;
	Fri,  6 Feb 2026 02:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770344967; cv=fail; b=NoI5RKgKR8iwsRoxyW34v4AKmZoTF5DXzir7Z0fw5n5941a9vnLeRWXpgDYXWe7dyU1Oy21MsW7S1doeVA2EEtc3gEtp4+0bqMNnpdXhgSwOJMReaz4KJm6ns0IPE5DtDwBu4DrL7cJWIg0TH5wCsXNjCISlRHveI5AfiDPgZKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770344967; c=relaxed/simple;
	bh=CoGnK2GfWTCyPeoj67X20QJIfiTjV8KJGBLde7dCBpw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TM6dmVp5+RHBYTIbRnT03cwa4sCpYXitamTR6zZyW4bhEV5g4buLJDtnCBhD9B2pYORxWMZM4DCCElSve0oCzh0rzfRcUpuebzCe+3uVZTYBzokpyF8wH+2GeHwDW7Gx3JyFBWV8XGbQN0TcV6JEAVe53ubqRAieA9HJtk2JE3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FIVLr2YG; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770344967; x=1801880967;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=CoGnK2GfWTCyPeoj67X20QJIfiTjV8KJGBLde7dCBpw=;
  b=FIVLr2YGloRNnMEfD7LPVK9aReCr6gpqsMdntHXLpg4Y4uITvN26+zl8
   aQ3VStfDmOXyS4OVaNw38mGQhdO/o+Omw3fwJ/fuUbwLTsw3ZxRioZP1J
   NQe0rOfXWc0tcycnA8MjZKq9w6Bc4gKydOqOL7wE5gob3tBGwvYEYDAGi
   Gj4+LNZjaKTSF0Mj5pHMU8ISEO+vR4O+4v5qRVSCsJJK4NXnnkoyPR8WX
   RELP9Qs3fo0ytwQ19VR+RTY3mn7nQJtrDpBhFpuFboaACD6yvCb4rFMEE
   AA9xcQl7ox7OKpa3TTpldOVVh0jm8k4YUUx2UP6s11hSMPBqyNzoDKngB
   Q==;
X-CSE-ConnectionGUID: ZMFqgxffS5Wt5KBW31COJQ==
X-CSE-MsgGUID: ZUGRJpbPTl2WbjLVbLPwpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="82291411"
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="82291411"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 18:29:26 -0800
X-CSE-ConnectionGUID: /Bv7cpifSrixcjbxzZ4VKw==
X-CSE-MsgGUID: Glg0QL4bRn+//0BPNaDCsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="210050507"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 18:29:26 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 18:29:26 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 5 Feb 2026 18:29:26 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.41) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 18:29:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JQZInI0S8cb+YGumPbSOsWPJFEqf3NecYKmjxLidYOOovOhwGRdc5hmW6uQE5xY9TP1AJ9KCNEUpA13f0cnZj2HbGSkVBi0I123CNo/gevxlGBnadZf0DgfAMrBIvuvDIixbrlCtJ7qZzevKcFNefQ68N7w1OMylXdzruao1nhP4042xP87kq03isxzyg4TakrRgODAjWn7lGVr2ObJVXgrZPHPoz9HkAb9w6BIoichz2r2SzwiT5GS2DepA0guJmt3P1aLfQK8tY6waaEKjGYjZ6KJwwBLTy4NuvxUS5rVtn+mp8kfte8TY0+1RcD0Gios1M6jvjFSXdu1/xfPfiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NYHOAMkUPsnShpIbThV4/aMT19xWxTzFg7HHe+Ct7U=;
 b=C+uz81Q1KRSv9J+yFR5XF5XwKZ4nVscU2sJPFCFuXUIq0V87CqleZusZ6TgG8Ntu5+c5QvWdCvnSNIyaPFPAzTAwHUeZAET3eUFIWFp3dFj+vO5UEAVDXSZUmQI1qhVI1DufkvUHIB/X9gYnpQS3IqqQjCBPO1ntrxwh6lxSAKR6NMraVEm2EwpXZ6ypRJtZsiGdp8O0BmUpB3i9fPEYRwsjoKyNb89sV2zOjTbMHJKAE3HKIBRtJqeVDv2Yipi8e4yfmJLaSGMKpXAruXuDKzkXt7jeK0d9A+XQ52rXGJ0Ryj0lulg+9Z46a3U50KyNo+Nv/zDzoLWj7hEEeIH6kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7892.namprd11.prod.outlook.com (2603:10b6:208:3fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Fri, 6 Feb
 2026 02:29:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Fri, 6 Feb 2026
 02:29:22 +0000
Date: Fri, 6 Feb 2026 10:27:00 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 05/45] KVM: TDX: Drop
 kvm_x86_ops.link_external_spt(), use .set_external_spte() for all
Message-ID: <aYVRdMN+qTKCStf/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-6-seanjc@google.com>
 <aYHLlTPeo2fzh02y@yzhao56-desk.sh.intel.com>
 <aYJU8Som706YkIEO@google.com>
 <aYLqESiqkADxMGf9@yzhao56-desk.sh.intel.com>
 <aYUkVRedz9ngwu_1@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYUkVRedz9ngwu_1@google.com>
X-ClientProxiedBy: SI1PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7892:EE_
X-MS-Office365-Filtering-Correlation-Id: 90404539-5754-48d1-ff2e-08de65278a11
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zM2wvwaGeCb5y8iZn0WYcYdMdz+kJJJySYtTs3NAkMi7Qf71r+mXsQvVtyof?=
 =?us-ascii?Q?XFNCEIQb4EY/D2cJ5fFMK6RxIkoHjPT3zLZ171WD3mKpUvoRo5sFCFXP7vEc?=
 =?us-ascii?Q?a2Osh8dcw+7G1n/LxKGoVxmUJpPsopaqCPWD0EPXuCTFHW6jQ4DhNvVTWheE?=
 =?us-ascii?Q?KpmkUggGKRNTa9tBO7ntpTTAk5DGvD+KPq5xeFbyAiwIOZmTk1gCSK61bYM7?=
 =?us-ascii?Q?osNnjcvKyPB5XAbM7jXRSC1PipeDaqxDrfsPJ2iwiDluQeAzK+tMeq7kqgiN?=
 =?us-ascii?Q?hqyHrr4V1cHmxBeFcxM50LSRGEqIQ5VSoo5jUo7sAWTlzR0U6Rj4BJWdrRIP?=
 =?us-ascii?Q?ClVQPeFOxBED4gZstwpWxdliHnxv8TcRsxSN+im0Fn9ReQ//MIDV/+yr9Yd4?=
 =?us-ascii?Q?r5LT9nU1P/RQJMOIr+1TA/oybvbbpWpCFi8SQeQgpbXo0Fh91kWVIJTh8clW?=
 =?us-ascii?Q?y3w4JqC+lDgDt7EBwPaoYU8Ksf4eliMqjISkgfQ8c7dQHMAWFC7xSfHGsK/z?=
 =?us-ascii?Q?acs6ZqlV7iJFJDHGzrrxqw8Y3cw2rmT8nn5dsz0pMZUTEj2q60o6Fk7qtWp8?=
 =?us-ascii?Q?9nWPUN2dHPD0PnxgcdKf2TVyPcmXEUbVC4qM0URb/eTD5kuA2jJDJcc4G2YZ?=
 =?us-ascii?Q?/BWmzLpz5iSA4vgbm/y3MzjLRcsxSmSEn1BdoUGbVouf3bpK7IDjbNYb6tEE?=
 =?us-ascii?Q?HN5+vWjzVJuLj0KdT5d2pphF8DTkJEaCGpnyV6xTRuS81vrWhK3UP2ddq8X3?=
 =?us-ascii?Q?IxH1oEUqLrKDAetoi9mbLx2sEmnZEeb2f9k4TePl7aKNMoSq29OEH5k/+2Az?=
 =?us-ascii?Q?YHNeNj169IXfQ/ewzK9E3nodItnfuci0m+ZB4LJq++p7XvAZh9hTRLjQx/Wl?=
 =?us-ascii?Q?yv6SyrVWi1GWoUgyM5mAlSUiRYZbYOwGEXUHEOCK8rC7jFgc8Rx2UyczbNYs?=
 =?us-ascii?Q?yf0gXa8twMFD6S5SYX6E0cYxiRORXBpr9gIU1AJuNiLvl2LUeQDDeUaDi2+Z?=
 =?us-ascii?Q?ECD6RNa5ciclQxe5sgToxe0AO9FRv3YoJXSUd315/UE/F1csp+Jcywrgwa62?=
 =?us-ascii?Q?moHdH8+W+A10TmwYm26yj5WPioqJfWeUHVTKqTFVvrau7vCt/hhhrr9sxp9y?=
 =?us-ascii?Q?FF6ftYnzbe/UDtJ5WR53Q5QDbO3WhTG1Jz24t3CvpM3zIpFNugM3iPZbpDDL?=
 =?us-ascii?Q?xNbyNPr7Rrat87YX4QVFaY8RdRVbBJezvr7jeXIWIbmXsGl4te7JTqpdydLs?=
 =?us-ascii?Q?xVebU4qreg4ct55EY1Nn1KoWYcZaDzLo9FGpjZh7PGVlFhp8I1q2PxYiSmCK?=
 =?us-ascii?Q?kolLi3s6i+TakbpXtx+GnN1TratHdCIj0JcVUA7+LxWR2SryoSLtsdeVLVaL?=
 =?us-ascii?Q?ezSyLQS5slHty61LkK+nsYkIABdW6R8cSEASdTfgk5AkV3JlT3v8N7i/HB2/?=
 =?us-ascii?Q?s3M9R21raPczvuD8GcNvcjDUELmk2Dj7kwRGAPo/axy2CLrRmsqHSKkqUSV5?=
 =?us-ascii?Q?+LYt81qM4/zwqJpkJ6YZjgIzeGeilZgyteqR/u6Cs7ja8mAROfav8mmL9CaM?=
 =?us-ascii?Q?8AY9zH8jEdALfnVM0DQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vOY9qbYkTZsF6zxyT6KiYXDZ+tuO2GBJrOSckK2YNt724najvXWI2hGL0/9r?=
 =?us-ascii?Q?oeiRjyMgcQrgnxK0VBonDDcRDMAdBINIEqYy19H7J4Rf9tG4pvW21VrzC7gl?=
 =?us-ascii?Q?4IcbqrGAqLaXUjFmwnms3RtZTmQTwR31WeWCbvIvbSKzvDGOLTF4ny2gY5sZ?=
 =?us-ascii?Q?Tyt3zJNoJ6MMolmwvL6vbv4Hh7cuelqHpByFv9Gvb+UDtHIFTdf+I5TeoR6e?=
 =?us-ascii?Q?LdW4Znck5neE+M2wEyzjhgS4HNNkImP/5N6VFYPbYsnOH3dbedV0THHIKKx2?=
 =?us-ascii?Q?UUe5NHNMP11zL4pPwuBgRDMI12YlQ3i8m8j6Fwe93dFkvWku8Ix60XgMrmUq?=
 =?us-ascii?Q?Z6LQKzo65YegPxk/O35xae/PBwhGCmtQEqbwkPKbTBy2YjwPhthNQru0F3EI?=
 =?us-ascii?Q?/KVFmKyiQ2nrFlhPbb2M8gXCUoTls2HNEJg6y5fOgqRgUYelRNBUxJdrhKyk?=
 =?us-ascii?Q?yTVDLUHELWUZa0dhQja6Ipt8X3RwKvm91Kdh2dU/FgU8Tuw8SEv5Jwa1Nh6p?=
 =?us-ascii?Q?XaWfsxb3ZuIuI7opmAvrbNRq9mHgFRzt+Gkz2iNUvkyrDGQ2V0GaKYKYrxhD?=
 =?us-ascii?Q?FM8pgeLWb7Na0LeHIshUnktpJj2q7x2zD3pUVoKkO/k/GPUE0X+APoEcQzU+?=
 =?us-ascii?Q?/hdRfbJ1xP3fOEvvhr4lL3HTYV5/CB22pi0J8PwLR2PX1c2W/lLj0Xr3PDQe?=
 =?us-ascii?Q?KT7sbr9qVfSl7pl8wQ5d04a1kuhEK1SzBZjFvOL2iqU7W2pPVgT3Slb3S8+X?=
 =?us-ascii?Q?ohqRC+Yts0U2YcBaAKVzHIadYaaFJUpOytnZBXq+D1mYuAKXGGe48j90zrnJ?=
 =?us-ascii?Q?kuMd7kEAAbTfOROwAslZH8HnirjU8ZEZR8uVCviI3nW4KoyFPRVjSKQHsz3J?=
 =?us-ascii?Q?a2dkAxrkxr001wsogk1dBAW3kFSDuYboDT/zSVeIdn3pp+s1jmQwbQUU12zA?=
 =?us-ascii?Q?7aKgyiwTrxSokGh3P//6NaGmDEtyX/zD08c2RpMtZQDEy0F7SXRTLz5azUj8?=
 =?us-ascii?Q?WlRIDRwA4uGO/KvFvf9IVV1O6dC4vL6A0gtR7Jk/aXa6Ea+IBa/4Rpea51pa?=
 =?us-ascii?Q?ghHxjysKnjoP8i4gUmbqGbdaKBDcme09V2ag89qzvNEM2ms+3vL//JNjv2jy?=
 =?us-ascii?Q?1mUTEENyrK20+VcJ8lB7VqIvAQy/eyXxLIZLsTt4KovQB8DyRXvZQqPRLy64?=
 =?us-ascii?Q?T4qiYctkW1J6AAW7m5mUHwNlT1T18+WW9XegDyvni0gda7eWtUpsBNAJVyWE?=
 =?us-ascii?Q?Q6fe7kBKm+T7Voeej5srkvTavGqw0pEzAwY7JsRqIrfGZ6NNjtiKDZuu6ABW?=
 =?us-ascii?Q?Szj+1Uu6rvBen9A4cKh/4QAlDMLrX+cAIyGbjH65MENjN/xEje4vjt45S9km?=
 =?us-ascii?Q?fCazGGZFNl9U6xglk/s8/QqvVs49Yyn+rpx9sYCQTzLx3WZon9c/TLYvzaE0?=
 =?us-ascii?Q?soDxjO7zAGzC4Y5uoXC6QqMWBIf1UHRPN+iL/C+9D+1sPk/qoOrWF8bwnZGB?=
 =?us-ascii?Q?d4QvfaVbiGR75+cwVmREYfLi/zwDbzlrZwRXh0n0/9F89CMr7UYZ5mK6TKO3?=
 =?us-ascii?Q?a5a0+FKCZwz3ViBHOVsEHJWH8TNh+0g/XjnX7o8sT8fkcfArwVR5Jy+pJrn1?=
 =?us-ascii?Q?sCW4UQ5thr4iAYXUv6biiqQCpQE8S6LzIPLeZc2UfsMmogX+SWLiNiWMnaqJ?=
 =?us-ascii?Q?ZmGfTaLZlykbJdb1+pRH6C3aUWvVgAh/GCCcvC9iGkfOg2/EhR9MJCG1wY8j?=
 =?us-ascii?Q?9kMfeAqrag=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90404539-5754-48d1-ff2e-08de65278a11
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 02:29:22.9076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RtavcZ/5iFusDcaSCbhisomsxHTA/qnHaVv5pJoFlXZR5cizUsMuGELmoaB2fpMFL8+E7S+ULzzs2R5WccXdsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7892
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70400-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:replyto,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,yzhao56-desk.sh.intel.com:mid];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: B2696F9525
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 03:14:29PM -0800, Sean Christopherson wrote:
> On Wed, Feb 04, 2026, Yan Zhao wrote:
> > On Tue, Feb 03, 2026 at 08:05:05PM +0000, Sean Christopherson wrote:
> > > On Tue, Feb 03, 2026, Yan Zhao wrote:
> > > > On Wed, Jan 28, 2026 at 05:14:37PM -0800, Sean Christopherson wrote:
> > > > >  static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
> > > > >  						 gfn_t gfn, u64 *old_spte,
> > > > >  						 u64 new_spte, int level)
> > > > >  {
> > > > > -	bool was_present = is_shadow_present_pte(*old_spte);
> > > > > -	bool is_present = is_shadow_present_pte(new_spte);
> > > > > -	bool is_leaf = is_present && is_last_spte(new_spte, level);
> > > > > -	int ret = 0;
> > > > > -
> > > > > -	KVM_BUG_ON(was_present, kvm);
> > > > > +	int ret;
> > > > >  
> > > > >  	lockdep_assert_held(&kvm->mmu_lock);
> > > > > +
> > > > > +	if (KVM_BUG_ON(is_shadow_present_pte(*old_spte), kvm))
> > > > > +		return -EIO;
> > > > Why not move this check of is_shadow_present_pte() to tdx_sept_set_private_spte()
> > > > as well? 
> > > 
> > > The series gets there eventually, but as of this commit, @old_spte isn't plumbed
> > > into tdx_sept_set_private_spte().
> > > 
> > > > Or also check !is_shadow_present_pte(new_spte) in TDP MMU?
> > > 
> > > Not sure I understand this suggestion.
> > Sorry. The accurate expression should be 
> > "what about moving !is_shadow_present_pte(new_spte) to TDP MMU as well?".
> 
> It's already there, in __tdp_mmu_set_spte_atomic():
> 
> 		/*
> 		 * KVM doesn't currently support zapping or splitting mirror
> 		 * SPTEs while holding mmu_lock for read.
> 		 */
> 		if (KVM_BUG_ON(is_shadow_present_pte(iter->old_spte), kvm) ||
> 		    KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
> 			return -EBUSY;

Ok. I was wondering why we don't include it directly in this patch, but it
doesn't matter.

> > > > And as Rick also mentioned, better to remove external in external_spt, e.g.
> > > > something like pt_page.
> > > 
> > > Yeah, maybe sept_spt?
> > Hmm, here sept_spt is of type struct page, while sp->spt and sp->external_spt
> > represents VA. Not sure if it will cause confusion.
> 
> How about sept_pt?
LGTM.

