Return-Path: <kvm+bounces-71529-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6HdAADnLnGlHKQQAu9opvQ
	(envelope-from <kvm+bounces-71529-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:48:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61CBB17DBA2
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:48:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 121F03158E8A
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 21:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38CF13793B9;
	Mon, 23 Feb 2026 21:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BbCyAJ2k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251802641C6;
	Mon, 23 Feb 2026 21:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771883077; cv=fail; b=HPmevDVrMnTBB/j8ISeXUGiMLBu6xloFE6oVY9zUAgq9lPHORAFjbPsDSxRAGPOVAY2rsGHX0K0JxYJZjs2hhnHumHBwAYoMXgpQW7+/zyKoy9X3Ci4bsCOXtN2XEyowzrSQh/npnuvkUxzxq5Y7JEkeELB+QGsMrYBxMfXmD6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771883077; c=relaxed/simple;
	bh=M/f/aeb57Baqs/wRPGOxkF8Zbfvof6yQRxiBcJ8AUjg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dmxOCTe8pk1BcKh5a6UTnNXFpphL4XoIK0+oToY7N3ttaf+ItpV3Z8hzc3DdWd7wzt+QF/1y6HmvknheAkQOSBbF1/TeuX4MHcHYyh9oWENc9F9EAOmiqDCCPZlAl0xRv+QYI92yn/zmJoNS9fuqYEA8Twff6hXLt6t9RHDalrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BbCyAJ2k; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771883075; x=1803419075;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=M/f/aeb57Baqs/wRPGOxkF8Zbfvof6yQRxiBcJ8AUjg=;
  b=BbCyAJ2kUGe+JMbpLJDhGBVEFlfLMTJyPVZPJ41LhmTZS5MXGEwARcfz
   5komKvrJzHu846+Lyuzl+TGsWgImVpeEHKBZGmFEJtqMBHJ1ljrd2zlfO
   RGdIHEyIJtGnL0w9n3/69FNWuoQJLo4mr0pf6JVWdT6VIq+gLgwlj9dFS
   QHK+sXvp5CsRRpKaEIfau4+8wBEbVOopssytkdr/jcp6qX4kqFckV9QC2
   J2QNCg7AJ++OvM+ztIviNY9MSwOLq1opNKak/c9ZFvc/V3TqZ/FfEE33t
   659OYteih2mE19f6cM+zsTde/Ok20NjEMlzQRd4gkmQmf+PxkwDQn9mS4
   g==;
X-CSE-ConnectionGUID: HmmeUpbwS/OOaQ1rDiISRQ==
X-CSE-MsgGUID: ydw9Z1tNTsWkdZC2BYciZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="72766947"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="72766947"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 13:44:35 -0800
X-CSE-ConnectionGUID: Wgb3lTCGQIC2qyoogP6GbQ==
X-CSE-MsgGUID: K6qgstV6Rr6N+QTdJlRdpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="219802502"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 13:44:34 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 13:44:34 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 13:44:34 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.33) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 13:44:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hz/GJbii5v5UXXPbjlM/lzYFwABYYUoNTUQQUV57MpTlG27EN3h77cfgMYh45q15jXN2kK+ilnGaIADX7cxqIjgaOv2YjXdI27rmbM+QJS+WhwAGJEg3zEpOiOZ4YFDNdWNb9MhIuTNRjAeXmEOMOaBOnJ33o+ZFzsazkdaefL+3F2O1DrMUyPiPiqQ9GMvi10trPr8AEkEhVwtniR+p4Csjp6Ico7mXM65UyCvuWWDP14x80Wv9lI2M2Iu2OUSu/CZ4AmHWlUJFJWpryRS96VNBefc/kgSfIOBYbigLLHedtF0BxwObT/FVxp02JCidWBO9Z2rN3qTFqlH0aumIfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/f/aeb57Baqs/wRPGOxkF8Zbfvof6yQRxiBcJ8AUjg=;
 b=fzPRGn/26gKdHEjXxWDMdIZ1Cai+YhZ/71eFQOIwECdtQD8HEiZOqJ02W7uH/Kr5Dwxhc1J4iSLbF+KmX140felaKkyO13xkmTSli0xo/e8h7yEs8+k9Iqg6A2gwPZBHHHxS+LO2jlST4bJ4EcSjL4rvOl+SYomOo/cT6o2AsCirGHcWIHAcCBCx9QKrXlDtxqNsuZ1R1pEraVRVGajHgk+7bXVNYE+cwrQ1TCkvqo6vPcU07ZrgLHow8wOTsV3/kSkNU9YBVw9c/gezHmj3XmG3jVHM2Ea2mQ1fS39f01rAzVLA7kNEHJpTcQ68+zq/PwGyz87ky4t61Nt15i3jww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 CH3PR11MB8415.namprd11.prod.outlook.com (2603:10b6:610:17b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 21:44:31 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 21:44:31 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "yosry.ahmed@linux.dev"
	<yosry.ahmed@linux.dev>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Thread-Topic: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Thread-Index: AQHcoTXmp0GPnRCoRk2Vv+i+XQkxSrWQKC+AgABfr4CAAEE8AIAACnMAgAAFMYA=
Date: Mon, 23 Feb 2026 21:44:31 +0000
Message-ID: <9d8f23914c70fec9b14d4b61cd1469c71383506e.camel@intel.com>
References: <20260219002241.2908563-1-seanjc@google.com>
	 <5a826ae2c3549303c205817520623fe3fc4699ec.camel@intel.com>
	 <aZyGY41LybO8mVBT@google.com>
	 <9e899034687731c7ee6d431ae49dbe3f5ca13a6c.camel@intel.com>
	 <aZzF4C1L9EdEBViW@google.com>
In-Reply-To: <aZzF4C1L9EdEBViW@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|CH3PR11MB8415:EE_
x-ms-office365-filtering-correlation-id: 676f6b1a-37d4-433b-ba03-08de7324ba2f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Q3Q2Y2pqRnI3eWFDQUM5MElwSEEzaDdKQnNmTGtEOVFWc3loZ3BhcVNkaTl6?=
 =?utf-8?B?V1NDWldmY05yUWV5RGtnbkNPTHYxbFdJVjZ2S0Jvb0Jwc2d2NlhsQ3JGdm9l?=
 =?utf-8?B?c0cyY0NteDA4dko5Y3JsbUgrdmVQYlBMV0cycDBiSTRINWxsZ0wyRnpZcWZx?=
 =?utf-8?B?MEZMRHUvdzRzSlo2YWdhWFJxVzY2WlYvSmt5cGlWcjkxNjRvWlgvTk9rQzR2?=
 =?utf-8?B?bDVVdzdWMi9WeThVa0JRYlpLc1pFR0lvWXM4SmNoaitJamtHYTZoZ21pc0NC?=
 =?utf-8?B?d1oxRVJJSjBCOGFjYXl6RDltMDZVeEZLVlJYWDc1emlVK0k4QSsvRFIyVDJh?=
 =?utf-8?B?YzIxYUZFTVcybTJPcUdYdm1aN01XVnZLaXhicFhuMlBPOEZzM0x6TVdleXFX?=
 =?utf-8?B?TGs5Q2V5dllSV25ISlNlNHNMR1FPNEpKZVZSSjhJTmEralNiRWd0dWpvakRa?=
 =?utf-8?B?RG0vK1psbnpxTzRrempBd1htL3JqWDlXQzhhSHJwak14cUZEUFUxSjJGMity?=
 =?utf-8?B?NjRhYkNOWUZsYlIvY28wakJZampJb0RCbHQ4eHdPd3haYTdXQk5zZlVsaTg2?=
 =?utf-8?B?WGRSdE5xYStvRkhZRElGZzZRTXJkWTJLNHlmNVZ5VEhHblNaWnd2SFIrOG1j?=
 =?utf-8?B?S0pCRUpkamtKSTQwY1lYWVBBNzhSdHk2bzBpbnQycTd2YlJGSW02bzJkRHNR?=
 =?utf-8?B?K1JIbWdEUXo5aG12M2NqeHM1bFArbE1ZQUlpTkk3SnRjVk1YNGxDMHlDTDF6?=
 =?utf-8?B?Q2ROV0g1SFp6bytJcXNFOWsvTVlWeThOLy92QWNOQXNuYlRvN3RZdUg3Nlcv?=
 =?utf-8?B?SHRTZnBnMW9HVmZFd2liVDhlZDF0aGNNcEJSeEw0bVpUcmNwZkRHWlNpVlRM?=
 =?utf-8?B?NHI0ZFBEUHlXbDB6cldoRkdUTDFpajc3a0FpY2VZUzBWSjFvUEdSZW1yQVIr?=
 =?utf-8?B?cnVXUnJxMGxibVA4MG1aMWZJdWxFZlo5czM3UktCczU0M3pTUnBiUExhd0ht?=
 =?utf-8?B?Y1NiL3o5Y1FGTGRpUzY1aDZXeVdxdGZWY3pyL2R1dmlkUldhejJvT0tUcVR2?=
 =?utf-8?B?Q1Rkc3BlSnRTWS92KzFyYmVTRW90MmxvdDVNZmt0cktCaUdmTDVGL2pTNEJV?=
 =?utf-8?B?UTEybzh2ZnNkdVR0djNTYTU5ZUNhU2N4T2R0cjdLMGt1VHJjQitra1RwN0Ni?=
 =?utf-8?B?bFIzckJUY0pXdW9VMUlQUDRuQ1Q3STByOGttUjFTS09jemxIaGdGc0d2dmE4?=
 =?utf-8?B?dzRnM054cHhaVmViTEM4R0hGWkZHNlVtN0lSK296MkJyZThTYlB2OGtiRG1B?=
 =?utf-8?B?OEVJMDZsYytuN0pCN0NPMnE4a3B3ZW00bWZqaUlmV1VaR1lpNTB5cW1ROGpl?=
 =?utf-8?B?N0pDVnM1djI1d3FGRDFKVU5yR2JYV2gwVDdUa0xsbE5nem1TdnJjb0F1UFI3?=
 =?utf-8?B?REdXMzBuWlZkTWkrcVd0SlJyNW44aGg2Wk5aMXZCUjNUSXdxNHN2NVJCZ2lG?=
 =?utf-8?B?eDUra0NmWFRnZUVKdnBNTzZHMWdIdXdSOEtHQmVIY3VuZUFaeEc0UHkya3RW?=
 =?utf-8?B?amloM3FRR3h5ditZZ2tBeWlZMDBGd1dTWTBwVTUzZHpKZXlENXhQNlZTakxZ?=
 =?utf-8?B?eXVVUUZZclN1anVzVTNNM3FzdXhJY0pxTTJIZzMxemNKVEJvUjhXMENZTUFv?=
 =?utf-8?B?UWNqYXAyczlFZjRtaWoxL2tVNkJ4OXBpTjF6b2ZYK2dkWEZFcnB1RFhKVHBx?=
 =?utf-8?B?akNPaklVVE15U0U5SXJXcmpGbHVwSHVUMVpqcTdoOTBjd1ZxaVc4dmk3ODFN?=
 =?utf-8?B?NTk0N2ltaU0ySW4rOEtkcUxNUHhXZi83UVVCQWljZElSRDh2c1pqOTJubkZi?=
 =?utf-8?B?d0xYTmpZZEEvcGk5VE5FWVk3ZWNpQVRyMXZtZWFtVjE4L0Q4NEcvQ25McGRw?=
 =?utf-8?B?OHVYdyt5bFAreGQ1elZ4c1Q5cFozYjlqOER4UG1PU01Lb2U1NGFOeUdHRWVN?=
 =?utf-8?B?R2ZzS0QydjJidGRuZlRhM3QrYlIreEtDajF3L1JUaUV5TmZ1ckNPSitZWC9n?=
 =?utf-8?B?VkVsSTZIVkF1Y295SUQvRkh6Ri9KSm1CRlUrckhwbkFPSXhvbW1OZC9aZGdF?=
 =?utf-8?B?bmY4Tng5Vm5kcjRPT0FsdDBqYWZBa2ZYUDZQcnZwcVpLY0lPSTBPaDl6Z1Ra?=
 =?utf-8?Q?xzzZLbHmC3Rzph8/njYzhW0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWh2MmpWem5qVG4rM1RPL1MyRnlwRmNRa2xuUDhHcGJxejNFTCtPbGF4enJR?=
 =?utf-8?B?aE1BbEtXejI1aVRNb0MwMFl4VVpEcHhYa21WdW0xYWRVeEU4dHpQOVozOGk0?=
 =?utf-8?B?MkR1ZUVYbWlrYlBCZC92dFpKK0Fyb1EwR2JERTYxVU5lblRMR3NmaUp1VVpN?=
 =?utf-8?B?VllQSk8zWElYQlZvSlpPRnJ2SFErbEF3UGkrbTdUaHNaNFNXUVBUZ25HMUN0?=
 =?utf-8?B?OWd5UFc1RFp0c2NWMUtEbWRvb2lFS1hqUWE5aDFlYlVpdk5vUEYvOVFENGYr?=
 =?utf-8?B?cHArS0hVZkhhNDN6M0dvcmt2OW5JaUIvM1VkRmVzeklQckx4c0s3Tm1PM2Nq?=
 =?utf-8?B?M213MDQxNS93VFlaUlU3SWVrODNXNDFYNUVETCttcmhIc1JLaG5aN3pEUitl?=
 =?utf-8?B?U2JRWU52bWUwcmVVbU5VY2cvVmd0UGdnYTZDdmIrZExUbFYrYS9vblVkNDZP?=
 =?utf-8?B?ZlUzb0ZhRkUra0k2eGhZNnFQeDNtZnZ3U2pLS2VBOGZUN3JMUTd6N3VHZVVV?=
 =?utf-8?B?Y3BGWXhtZFRvUmpGQTVranp4R3VYdzVNajdqR0gwS2w3TEUrckZuUmFEc3l1?=
 =?utf-8?B?QjJlalNDT0FKN2JXM2Z3SlJHM2N5djJWT1FWQnNBSFhQZEpTUnV6WUMwenBx?=
 =?utf-8?B?OVpyNm9MWFI4U2lnY3JGYzRuVklKNFJ3K1pOWjhzYmorVnR0UFdSKzZYcEw2?=
 =?utf-8?B?cVY5a0JQVnVLNjZMZFI2eXdhUHBSd3BDQ3d0THJ5VWVad1dxNG1ZZkw2cHNh?=
 =?utf-8?B?NDd2TFdVeVhib3BJSFRLbTdiY21YSU4xZ3ZYZTg0cWF1Z1o5L0NqVXhkYldK?=
 =?utf-8?B?MEp5S3I5bXZqQm1xaG5FSE9VUXV4UW0waWprQlFqQlFXQ2oxblZWUlBxOVBk?=
 =?utf-8?B?aHNSQncyRUpUTmlWSC9XQmM3d1BQZk5mMmRLKytOdkRIMWZwbEpoblNNaGsz?=
 =?utf-8?B?bTFSWU85bkpUNHRhenU1ZWNCb1VjK1AvaGV4eW5HK1FqQ3dMUDRiMXlyL0U0?=
 =?utf-8?B?TXJPV2g1cEhNdXFJVTRWekxaWUNyUHVzN2VPa1FnQTYwYUd3QU9xTEloWjRR?=
 =?utf-8?B?NHpnNVk5eXhmeHh1bzBadnNOeHZvZXhZYk53eUQxOXhVV2NScExkbUUxOHBO?=
 =?utf-8?B?NEdOdGlVdnIvVXQ1OUtPd29PSWxxb2JWZUxBUEN6OFltb3c5bnRNdHo5d1ZN?=
 =?utf-8?B?R3FoT1JPL3R0eE93SGxKSXRqK0E5emJkRkF3MTdnTHlLMjBYMkMvazJBYTdo?=
 =?utf-8?B?N25qN0hualFVdjZ4QXIwckFPZWw1ZzNRVGpiUnBnUjRybG9CN1g3TFVEbFQ0?=
 =?utf-8?B?dnlXQnlWTC9pdXNsQjZFLzZlbHlaenNIWWo1dW50UnFyQzk2eFFyZ1dGYmNy?=
 =?utf-8?B?akN1TkE4NGM0TW9PSnh0VGx6RmF5eFYrbUp5Rk1QREZrRzJXam1ad1p5VDlG?=
 =?utf-8?B?QU1BSlgrTHlQdUtadDZQNDlnaFZmcjJ6b1BPKzFhaHBqeUY4aXFlT0IrUmhl?=
 =?utf-8?B?U2EwWlU0VE43MVpXTkgxV3dRb2wrRDYyWGJoYnF5UTRoY3ZRRjAwZ0VHNENY?=
 =?utf-8?B?aytBREVTeWM1Wi9EcGtmUVcxM0ZWelBvaWhRdUgvK3E2RXBYSlBMWDliUXNZ?=
 =?utf-8?B?OTFuc3BKU0dDUkFYMWJQMUhTUWVsMTBWK2RRQUJUeDJ1akpUN1g0b0pVUWkx?=
 =?utf-8?B?aFJsTy9VUFd0SWFZVUZNU2RKbFVUNytLL05TUWpIbys0WkhKOHhXRHhiMXIv?=
 =?utf-8?B?NE1memEyaC9jeXNrb3ZDRkovK045dmRWbGplNjJ1QnlZUGE0UTd4T0hTK3hk?=
 =?utf-8?B?Z0hJeUlTZllZR2RDa0Z2WTF1NXRrSHdtV1BqaWtGMU1sYWVJZldNdDJ4dVAv?=
 =?utf-8?B?bEJhN3FMWWgvSVdDdDcrYS91RTArMzZIUmxBZllCYVVvcktrQk5NTlpWZHg4?=
 =?utf-8?B?TWJYR3lHNStqM1AycDNMU0JyY2xSN0ljZjZKNXFNeUt3bGxndlZLVzVxNU12?=
 =?utf-8?B?TGkvZzlkQzlGTkJsVmhLY1pEakxEakhNdlhOK1NpL2NJSUU0Z2dlc3MvdHJu?=
 =?utf-8?B?MFFqeWRlaHlVUzhxeE1IeDNwZnprQ2F1dUh5dkJQdGs1WGZTWnNoYkFLUS96?=
 =?utf-8?B?QWozTzg3U3IwdDhwR0dpRFpXZW84dWdKRmtBSWNkZXdJM2IzaTlidUpCZWpD?=
 =?utf-8?B?QWNrU3Nvb3licFdXSThKUC9uUDRlQ3dBdTZHSkQ5S0VoUGVjeVhobHl2cmRQ?=
 =?utf-8?B?cERNTWJLZWFySzlFQUdYblMydXZ0SnJwZllsM1Jja0lUd1Foc2ZxT1ZkelVy?=
 =?utf-8?B?UkpkeURFQlBOVDE1QStRTWR1eHB4UVhSeEJTTnBnbU1taElhcXBCQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B402C51FB58375479B02A7C11A19CC4E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 676f6b1a-37d4-433b-ba03-08de7324ba2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2026 21:44:31.2788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lCIbrvFVA6uAw+J9o9m06i1GoSP8McvQ68X+umkJ4hzmOPUWEViHFvYHiJEfFqkmzBC5GVf80HYZ9cYP/juMUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8415
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71529-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 61CBB17DBA2
X-Rspamd-Action: no action

T24gTW9uLCAyMDI2LTAyLTIzIGF0IDEzOjI1IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIEZlYiAyMywgMjAyNiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIE1v
biwgMjAyNi0wMi0yMyBhdCAwODo1NCAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIE1vbiwgRmViIDIzLCAyMDI2LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+IEJ1
dCB0aGUgb2RkIGlzIGlmIHRoZSBmYXVsdC0+YWRkciBpcyBMMiBHUEEgb3IgTDIgR1ZBLCB0aGVu
IHRoZSBzaGFyZWQgYml0DQo+ID4gPiA+ICh3aGljaCBpcyBjb25jZXB0IG9mIEwxIGd1ZXN0KSBk
b2Vzbid0IGFwcGx5IHRvIGl0Lg0KPiA+ID4gPiANCj4gPiA+ID4gQnR3LCBmcm9tIGhhcmR3YXJl
J3MgcG9pbnQgb2YgdmlldywgZG9lcyBFUFQvTlBUIHNpbGVudGx5IGRyb3BzIGhpZ2gNCj4gPiA+
ID4gdW5tYXBwYWJsZSBiaXRzIG9mIEdQQSBvciBpdCBnZW5lcmF0ZXMgc29tZSBraW5kYSBFUFQg
dmlvbGF0aW9uL21pc2NvbmZpZz8NCj4gPiA+IA0KPiA+ID4gRVBUIHZpb2xhdGlvbi4gIFRoZSBT
RE0gc2F5czoNCj4gPiA+IA0KPiA+ID4gICBXaXRoIDQtbGV2ZWwgRVBULCBiaXRzIDUxOjQ4IG9m
IHRoZSBndWVzdC1waHlzaWNhbCBhZGRyZXNzIG11c3QgYWxsIGJlIHplcm87DQo+ID4gPiAgIG90
aGVyd2lzZSwgYW4gRVBUIHZpb2xhdGlvbiBvY2N1cnMgKHNlZSBTZWN0aW9uIDMwLjMuMykuDQo+
ID4gPiANCj4gPiA+IEkgY2FuJ3QgZmluZCBhbnl0aGluZyBpbiB0aGUgQVBNIChzaG9ja2VyLCAv
cykgdGhhdCBjbGFyaWZpZXMgdGhlIGV4YWN0IE5QVA0KPiA+ID4gYmVoYXZpb3IuICBJdCBiYXJl
bHkgZXZlbiBhbGx1ZGVzIHRvIHRoZSB1c2Ugb2YgaENSNC5MQTU3IGZvciBjb250cm9sbGluZyB0
aGUNCj4gPiA+IGRlcHRoIG9mIHRoZSB3YWxrLiAgQnV0IEknbSBmYWlybHkgY2VydGFpbiBOUFQg
YmVoYXZlcyBpZGVudGljYWxseS4NCj4gPiANCj4gPiBUaGVuIGluIGNhc2Ugb2YgbmVzdGVkIEVQ
VCAoZGl0dG8gZm9yIE5QVCksIHNob3VsZG4ndCBMMCBlbXVsYXRlIGFuIFZNRVhJVA0KPiA+IHRv
IEwxIGlmIGZhdWx0LT5hZGRyIGV4Y2VlZHMgbWFwcGFibGUgYml0cz8NCj4gDQo+IEh1aC4gIFll
cywgZm9yIHN1cmUuICBJIHdhcyBleHBlY3RpbmcgRk5BTUUod2Fsa19hZGRyX2dlbmVyaWMpIHRv
IGhhbmRsZSB0aGF0LA0KPiBidXQgQUZBSUNUIGl0IGRvZXNuJ3QuIMKgDQo+IA0KDQpBRkFJQ1Qg
dG9vLiAgSXQgZ29lcyB0byBwYWdlIHRhYmxlIHdhbGsgZGlyZWN0bHkgdy9vIGNoZWNraW5nIGJl
Zm9yZWhhbmQuDQoNCj4gQXNzdW1pbmcgSSdtIG5vdCBtaXNzaW5nIHNvbWV0aGluZywgdGhhdCBz
aG91bGQgYmUgZml4ZWQNCj4gYmVmb3JlIGxhbmRpbmcgdGhpcyBwYXRjaCwgb3RoZXJ3aXNlIEkg
YmVsaWV2ZSBLVk0gd291bGQgdGVybWluYXRlIHRoZSBlbnRpcmUgVk0NCj4gaWYgTDIgYWNjZXNz
ZXMgbWVtb3J5IHRoYXQgTDEgY2FuJ3QgbWFwLg0KDQpZZWFoIGFncmVlZC4NCg==

