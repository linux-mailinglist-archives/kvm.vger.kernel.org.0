Return-Path: <kvm+bounces-71246-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IFyjHB7LlWlfUwIAu9opvQ
	(envelope-from <kvm+bounces-71246-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 15:22:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CFCBC1570A6
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 15:22:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BBAB13019819
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 14:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C014D33374A;
	Wed, 18 Feb 2026 14:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MdwI/8WB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E5833342A;
	Wed, 18 Feb 2026 14:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771424490; cv=fail; b=gqk5tINJHz7PfiFwz1h5vDkAVmRIa2t3KrYr+TXJXbxigyLJ+YpRIrUzAn2BMNW5gw0q9tOLpe9PTZRYqIJ6klvkOYenz796CafO3ceez3y6VCRWkrwzT9vV8ZUxVoe6bBP33mYDHgLlDMpIylsThPHQTHlwfbwYEN5oHpLn81g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771424490; c=relaxed/simple;
	bh=OQC7idUSjvrOTIv7SeMUI8Tc31hiFHVuYLDSBOGVyzI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=roE/ZK2df8WrTxorLNfIZt0PFU5jhgdVJ4rZEvptHXIFvlg/d0ocd52ZmxgQbeAD5Qa7I1U/7luLdUcZgmP8xGy+80OX5YgTsdlh3fdVJucI/LFpenRNPz0ZiNlYfvnVLfDwps9LMegFygpbRnhXs/wLkEexssDG4JFzy5ustJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MdwI/8WB; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771424488; x=1802960488;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OQC7idUSjvrOTIv7SeMUI8Tc31hiFHVuYLDSBOGVyzI=;
  b=MdwI/8WBMXcf74CoShnck6PGJRceCK2JlXEsC0nnMy3uoAq89kZ2Epsl
   fcqZJhkf1KFIC6i2wUerZRyA2N89uI13ulf+AnXIkZv0f+q8qZJ/mowj/
   fuJsq8chgGfg2lh3/6N4ryc+ShrEvgZCAkHqFuDhHJSZAUfDPXoBHdtHk
   OCw4q0eU1hcDNF/0VUi5CQf3QrQDM4q8QBCABR5A4Oi944nTC4e2sfHaU
   JnlNitPe/q7U2uJHEHIoTUEoP2z6VrtK5n1JW4p5RQzndp4fSo/I4HYeD
   ebaOIvy1K662A8p048sa59PdOD/ZDcHYf3uhZ5/ZKlXraVEcZmmYgNwy+
   Q==;
X-CSE-ConnectionGUID: 6tmvOGj4SACeJCYoPyqmsQ==
X-CSE-MsgGUID: 3BOIRoVhScK87hQTFdvIRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="72388556"
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="72388556"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 06:21:28 -0800
X-CSE-ConnectionGUID: tomTJvQvRz+iiEUWCg9ZXw==
X-CSE-MsgGUID: n/fu30TCRd2IKqb0Yin/bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="218347274"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 06:21:28 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 06:21:27 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 18 Feb 2026 06:21:27 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 06:21:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M1dl5ybamC70g7JjrBR+ELMxFweJ+9y5HEhdoTG7vUsK2wsw5hj+DiKvdEDreb1cM42+CieTQXq1mPyT6uVTs7yqe5MsndFfaG3CVM/8S6TgjEEoZjMc6r9AZlkSA0Q8eMimmMy6gtmWoUST6qcmAk75q9CMmxooclH9LHFKRM1UBy7Zjr0Ul+ci5NZLbF9o+XBRnhw3XkWA9syq9DZuP4712qy07iTQEWH5h+/OcYH6iGVARgMCovDmaYyKe153F+RnIloncc56zBVyF/RFWDevQ+S5sCdby1TrqIX0QKQL2c+zqC+o7BRFepeN79GXqEbJl1gS8spIRSUxoKatQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQC7idUSjvrOTIv7SeMUI8Tc31hiFHVuYLDSBOGVyzI=;
 b=SflakMyPzDtg/fBtbLBecBO/SE5hzCatPDs68d27DsqnG1Txvmwi9ym5q2q+JgUJi0TJPI7zHNMT0vT6Dc8BfdYJRO8kFpWj2lvhgoQnXLQIPxFd+qgahbs8lkMZ8bLU29kPay9WMWzNLkByORZ+pCCstFZMr22H4eYdldZ3AdAdaWBHgQX0Dp3hxFdSIj/40BuKWomxjOS+ryt3VcWxKyQhrUzOOpEn0OrzZQefzTuc4Rdt8WJDEGe8ng+x1MHa/1Dqly3GUNUy22EhDoHqWYTYOClLr/8xkpxJSdDxosAztXdHHdMOjJUnHguBTDZEItCIP2Z84m8u7CVqQa/mPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4853.namprd11.prod.outlook.com (2603:10b6:510:40::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Wed, 18 Feb
 2026 14:21:24 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 14:21:23 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "jgross@suse.com"
	<jgross@suse.com>, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
CC: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 04/16] KVM: x86: Remove the KVM private read_msr()
 function
Thread-Topic: [PATCH v3 04/16] KVM: x86: Remove the KVM private read_msr()
 function
Thread-Index: AQHcoK+uyrhRQNM/rkaMxP5uR4mwVrWIgrWA
Date: Wed, 18 Feb 2026 14:21:23 +0000
Message-ID: <330ed8d57ee5c7574d7bc1b637598bbef5325ee4.camel@intel.com>
References: <20260218082133.400602-1-jgross@suse.com>
	 <20260218082133.400602-5-jgross@suse.com>
In-Reply-To: <20260218082133.400602-5-jgross@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4853:EE_
x-ms-office365-filtering-correlation-id: b8a758e8-4520-48d4-2999-08de6ef8fecf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dEVKQ2g1RmQ5ZlBnOWxMVDZYcmRURmZ5NHlnc3JtREIydHpCbzloQmFydXJ6?=
 =?utf-8?B?WDZPdjVQc2ZyQXEyT0xldDJpbFdmQ0kwNmhLZ0hEVnNmUXBnS3NxbGViYUNU?=
 =?utf-8?B?QTBDd1VpR1FUUElVSUtJTHdPZXVPcXdEcy84UTdEdHVHanVKejhpMDBoaGMz?=
 =?utf-8?B?d1hpRm9zRXFxUWo1Q0g4RjFHaDhoMFJrdnA1REtFWGRZWFVZUUE1eUE3SndQ?=
 =?utf-8?B?WVhNSGV1eGhpdU9ZUExRVFJselRDT2hKeWdESEVRUlNIelRKSmt1azBQc1BV?=
 =?utf-8?B?RTc4dnJFSVFpYmI5VnJvVThKOVJ4MlM2dEQ3RnJ2RUowSlJjdXFpbnFhaU45?=
 =?utf-8?B?QXVHSVlNUmFVYkZsZndIVnlzMk1qam1Pa3hyN3RSSWdsMUdmSTNoWUlJeksv?=
 =?utf-8?B?S3Ura1A1ZVJkVllCNzBBb2FqUk1SUUMxL1MrQmROSS9jWlRWaWVmcW9Na2s4?=
 =?utf-8?B?R21IK0JoMWhObXhYQmxPNThnQmhidXNBU21HNDRyeUkzQ3g3SExLb3JiakZw?=
 =?utf-8?B?cDZ5VkdaNjBmeFh5QVBYa1o0OUl0ZC85K3c1Vms1QmFxRWJUd1VoTEtseFNW?=
 =?utf-8?B?UzVMTHh3ZkJ4dnRablN4MUgwUVUwcDJiS2pjeVFSOVhuM3UyMHVQK082aUlW?=
 =?utf-8?B?Y2ZlTmVyZlVIOHErVEZwYXNHdEljaTkzeXpuSnJjdFcxZCtpTUErYkl3Nndk?=
 =?utf-8?B?bzdTaDdlU0orUFNvRVdWUVQvZnhEbXBtTWVjNVczY2R6bjhVNnZodEhnMVVV?=
 =?utf-8?B?QnBGWUw1bzlxUWgvdXJhelVJcXVOVUhocnMrS1ZiSWFPQ2JDblF1cEw2VEdr?=
 =?utf-8?B?a1d5eE5OcHkrYnhhNlg0RVZQU2x3NEx5YWpOOVhSb21GelhydXhHMjErSExH?=
 =?utf-8?B?Y242clNsK1hzMzF2Zi9wNkhJMWlENjRGMUpndkliRldyQWsrbDVHQy9iYTND?=
 =?utf-8?B?aDV4Rm1sV05JWiszd2s3R3B4Skg0QkdWdlArSG13ZGhuRS9MRWpNb24wVlI4?=
 =?utf-8?B?VW9kVE4xT212dExtZmJFY1RzcHRIbURmSFRUc0dxbnVvdi84QnFyZ3BWY2ZQ?=
 =?utf-8?B?ekpFVllTQkRKdHV6R2FCQ01Ea2MwS215Rmp3T1Q5d2RMQzd2Y1BIcHNNODBl?=
 =?utf-8?B?bG1hSVVDYytYejBsZ1BUVWRlb3NrVldPZ2VGL0JlcEdaOXoyT2FBREhibmxT?=
 =?utf-8?B?am5ZeklqeFltQzVpOEtaZzhKR2JwdVczai9SdXFvTUhzREkwSVRLMHhoam5I?=
 =?utf-8?B?cmF2WXpLSDBWU3F6NEUzKzE2YUFQZEZTL3hDcGtWR2U2TWdhaGZwVmYvaDFT?=
 =?utf-8?B?dG9YSk9pSHF0RGRtQjZqTUhmYThSLzlzRlR0MGFSMGlXTlBldkExL1IyOENu?=
 =?utf-8?B?KzdDVldOQzJKdjFOQ2V5cTdxU0F3eTd1aFRsMTZ4TERTTXFyZ3RadlQ3VG9k?=
 =?utf-8?B?eXRHUHFSVXhWVE9hZ3daQktXYkRFRE40SWx2c0JkeUVzUnFqUFJOSzA3WE1w?=
 =?utf-8?B?TGZZNWJtNHlwblFSc0hQM3ZPTGdoSmFCQS81NlZRQmxJUzBNREc5TkhEZ1Ri?=
 =?utf-8?B?ZC9RY2VRQlJCUEgyMnRwMldQOUViTmh2czduMDZMdzNYNHp2enU4MytDdk50?=
 =?utf-8?B?SU9qdnViTTJSTkpPYTRJbVd4bTV5RzhRVzA4YUV0MWMyZldWY2VNN3A3VVpx?=
 =?utf-8?B?TzRabFQ1aVBiVXZpY09CYnUwaWtNK3h5bTlTRTM1L3RWekFCS1JFUnNvTGV6?=
 =?utf-8?B?TTFNbkRVcWtZR1p6UjNzWVhMR2FaSnAxR05TcUtpMmJLRzl2QnN0bmZ2eGQ0?=
 =?utf-8?B?L2RSUUtta2lyTmtxUGNSZk5pbktrWkpScDFFZEYzZW9UYTBsMTF0YjEwWDlN?=
 =?utf-8?B?NEFFOC9YSVNiWU1VZEJsdW90a0Y1RkNScnc2RkhjNmRoWkM0cVF4NUhacERp?=
 =?utf-8?B?SnlrTnhPbUlTZjI5ZW9PbE1VeDB5R0Q0bSt6VU1rN2M4eVVYQ2Urc0dQOE0x?=
 =?utf-8?B?UVQ2STJOMHJPSnZGeDg0YUN1WTh1ZERDaTUvNFRKYnQxNGZrb2IxMUFmTE1s?=
 =?utf-8?B?b0tiTHNXcHAxRXFDSDhlazUyY0RXU3V4VkRaV0tQOTdZN1NGdnFrc0J5aDdD?=
 =?utf-8?B?UFhjZ0lxWFlVeGtzY1RqR0dZVmgyUndhVFNsYXBlU1F6MFFXZTdNTkthL3Zv?=
 =?utf-8?Q?z0s5hMiI93KhA2g8c0X+C/E=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWt2SGE3N3Z1ZWNTVC9tZXp4UjlPRktkSGxNMG9MWERsQWlnUEx0L3NnS0cz?=
 =?utf-8?B?Sjd5bHA2ZXZ3WnlkRGNzYUpFdUxqbmkzZjRuLytGSTd5amNZNjgrZU1rNTZL?=
 =?utf-8?B?Yk16WXZYanB5dllMK2RoN05GWndBeG1KYWNmZlJhVWhtMHJuUWxreXJjNUcx?=
 =?utf-8?B?VUFsTmFrRlJIeDltam43WWVFTEMvdWc5bnI5SkZ6M0dEdGdlTnM5eWFReU1u?=
 =?utf-8?B?eWR6WTdBdENzaDhiY1lUZGFLSVVMelBKNENxbEI1c2ZjWi9qVmY5dE5iUzN3?=
 =?utf-8?B?dGwwcnY1eW05UDBoeXF0NVRSTlo2MUVGZVhIV0NvMjZ1L3plMVNLNzFvUUNP?=
 =?utf-8?B?ay9NTWlKcHMyM25sbDdwM1JkaFp1MHlHSC9ibE5tSDErZ2JFSWM4MkF2MTFL?=
 =?utf-8?B?Nk10VmNIY1JOdmIvQ0JEd1cwbEhZNnNsTE9MbzRqWC9CbUkydVVKTXNhOEdo?=
 =?utf-8?B?SGNvM0J4d1o1ZmQwRWlEUkU0VEFXV1IvUW0wWVRCVWtkOWJvMFR1am93SFZr?=
 =?utf-8?B?L2VvcHJPbzYwMHprVENaU2g1NmJ5ZWZKOHVkalV1ek9relF5VkJjamkxVzFK?=
 =?utf-8?B?K0VhbkVZMTB5RDNIYmNQV29VSnVQTWhnV2RTRWsyUjU1YTNlT2xpR3dGYmlF?=
 =?utf-8?B?VVFkeFk4RHg0R3N6bmJsM3ZKbEk3ZDdGbEpWaVF4NU93NHVremhmNjhNcFF3?=
 =?utf-8?B?VzlBdk1vS0N5VWdVa1FXTFNjd0NUa2l6d00yREpKbHZEWGM2VkhrcnlSV3Rt?=
 =?utf-8?B?UFRhRzdkU1grMGY5dXowTThqdDl4S3RTY3VoK29NOGVXQUIwQi8xRzRoVFMy?=
 =?utf-8?B?SS8rbGZJMjQrL0hLaHFtRHVubXlTM3d5STJzUzQxOU5rbFFDOFBDK1Z5SlM1?=
 =?utf-8?B?LzRTdEVCNDVoM1d0dit1Y2FDWkFUbEVOU3RwUXRCT1ExWFNJOWJYV0RQbm9D?=
 =?utf-8?B?Y3Y0YXp1ZnpnY2dOdnlkRUw0SkVBbVppOVdRZHcxOXI4SzlLMEVidlFQbHIx?=
 =?utf-8?B?VW5vM0FORGhsalF3OENnZXN1U3EwelVlVVhUT21iUGJJYUFpQlNSWElCZFc3?=
 =?utf-8?B?S1h3UXVweHNLTUlnSUVkTnNVQ09VMGh2ZFFUa1lGTkhtVzRvbXk5VVpPcEQx?=
 =?utf-8?B?NTl6SnE4cTNPWnF3MCtDclk5SFlFelU5YU9NMnBQVWVtaVFLMUQ4RjdTSmQ4?=
 =?utf-8?B?cjBLMHNDcHl6cUNHSEZCaEwvWnN5QWpHeEpTVURWamNjQ0ZRZWdOdm9QOWo4?=
 =?utf-8?B?T2xmbnI3L21oaGtpNjIxTlhGd0hGN05ROVV5bmZYenltS3V3VHZKT3B0amU2?=
 =?utf-8?B?OEI5TXU3TUtidkpaWXE1dmJkSkpLbVlSUVpZRVZrUWIrOVpmc0Z1V1hrSGN6?=
 =?utf-8?B?NUorN0JxL0dDbkg4a1pGa3BXVWZSQjNjNm1Tc05oRjRUTXdjQ1ZsK1ZrbU1R?=
 =?utf-8?B?dkdQdm9LNWMrckZnRWdncmFGejhXTjBPUXVaeGN2cDhqQ1Uwd3RJVTRqSG9u?=
 =?utf-8?B?Nk9USlJjNUFqWnhTV2tTNlV3QVk2aHRYYWhIemEvZUFNYnBScFdpV3pUMEZt?=
 =?utf-8?B?VTd0WEZTRjJhMkNOMkIxcFFIRzZVTVo2ODVCRFJYaEZLN2YrdnkvTHlydk4r?=
 =?utf-8?B?bUtwUWVvYzZTTkZESEVlWlp3Mm1UZDdDS2lTQjA5NENGZGNaNHpjdTMwOGs1?=
 =?utf-8?B?VUt5SVZ5R3h2a2RWSHV6UXoxczlUWjVBc3VjazlDbzJUSGx0VC9TWDdQQ21x?=
 =?utf-8?B?L2ZRT0o5MlZRbHlCVElJTk5SWHBuRVhoaHRjNmhVUURDUUtNd1ZZTjUvSDFn?=
 =?utf-8?B?RDFoQjMyak96TzExU1ZReXRSNkhEOE5YeXVCUFA3VmJFY3ZSSlJNNUphTEpG?=
 =?utf-8?B?dllRT1dKVlVmeFMyNDFpbXZpOFpYR04rOXZjTmNWQUZJaStzN2lYK3Q2QjJM?=
 =?utf-8?B?Q3hiRWRYdnlLa0tCN1ZOWm1QZWpYWXpvbXZCUndDc0ZhUzZXM1Mrc3B5V1RO?=
 =?utf-8?B?WnNQVmRoLzF3S25hWlN5L2hmOXVsdENpM3RBRTh0K1BxVTZkanA0M0VjNnNu?=
 =?utf-8?B?VC9kREhFeVVUU2xTQWNSVS9Ya0hSeE9GVDRLd09rRW8xWjg1QytJbFloNjNI?=
 =?utf-8?B?N1BjNTVMRWxoQ01lNmk0TVY5MW94SFROaVVrajJ1Tms5YzhxbTUxUmZISWUz?=
 =?utf-8?B?L3BaVTRsMytxWmk4NnN3Z21hQktxRTM3TkpjUElaaGN2RTBGd0dxUEcrSVVL?=
 =?utf-8?B?OWd3eUlVbFYrYkFqNWhaQi8wcElwdXBWUURyVUJZVklOV2VNeFFybjM0akM2?=
 =?utf-8?B?Ri8rNm4xYzV4QmFGeWNHSjArcEE0MHBGd050V1h2eTlQOEJUdEw3Y2VlSXI5?=
 =?utf-8?Q?IzF2tKNbEH5a7q88=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C87BA747A74D24384A85B91F5AA6286@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a758e8-4520-48d4-2999-08de6ef8fecf
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2026 14:21:23.8860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KuvlrZmmh7lhmH/lajRzFWmL9ZCnOEISSbeFxrrS2urEIc/ussQnvGvJhn683mf+QLQ/azz8KPodIL0FuLIgC9bC8H0otI8wmw3wj3kUtbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4853
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71246-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,intel.com:mid,intel.com:dkim,intel.com:email,zytor.com:email];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_ALL(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: CFCBC1570A6
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAyLTE4IGF0IDA5OjIxICswMTAwLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0K
PiBJbnN0ZWFkIG9mIGhhdmluZyBhIEtWTSBwcml2YXRlIHJlYWRfbXNyKCkgZnVuY3Rpb24sIGp1
c3QgdXNlDQo+IHJkbXNycSgpLg0KDQpNaWdodCBiZSBuaWNlIHRvIGluY2x1ZGUgYSBsaXR0bGUg
Yml0IG1vcmUgb24gdGhlICJ3aHkiLCBidXQgdGhlIHBhdGNoDQppcyBwcmV0dHkgc2ltcGxlLg0K
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQo+
IFJldmlld2VkLWJ5OiBILiBQZXRlciBBbnZpbiAoSW50ZWwpIDxocGFAenl0b3IuY29tPg0KDQpS
ZXZpZXdlZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K
DQo=

