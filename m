Return-Path: <kvm+bounces-52240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D466B02F3B
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 09:28:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 064DF7A7543
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 07:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE911DE2A5;
	Sun, 13 Jul 2025 07:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iXetQwqf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB701A2545;
	Sun, 13 Jul 2025 07:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752391690; cv=fail; b=KyEmxaRTbFhvLMyJHRimSClTg3yVSH7CQyfFVQSE5EqiuBHo/ligRyAIlkgz+htGwLX8N3Mfo0vi+ET1E6EHmpwPiwjTWXad/XJpw49yl7lMwdLlEeM+kew9IgEAlRoqhQcl5JYsqBKiQTf96WxBkVGCks81WgTYvuY16DtuTiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752391690; c=relaxed/simple;
	bh=T6LYJFeKoRQNTMMjKv3KfSULRqe7ZwhlGR+rofBOoV8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LXlGzbY49a/ehGMK/YO4Dt6DXfuoS2+Lk1GQ6JWjp5iK5TBJyH+zI4FrTVpM8M6lomqg8HxH5O6aVROikUfDVlBo8mQRhZkIWHjVwDRyZJZ17r+n4A3+ufmQUMeOGpjjIay6SKuZkhuQ2mvQiT88XJBXjRIfufnxEwnNafuQXiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iXetQwqf; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752391688; x=1783927688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=T6LYJFeKoRQNTMMjKv3KfSULRqe7ZwhlGR+rofBOoV8=;
  b=iXetQwqfSKH1KUqRAydfh648ayd6W97TDCeVMVxe7iewTCF/7JCnwGiW
   /y8kDtuzNXqOcM8qztOSi56LSh9ew7fNB/I4ef2ZIo64sVD88v05PUxK5
   bcpyOBCFCPx0zp061pkeAKy+N6HOMvAHEIDSXWEqRtT9Opsi3csI+5J9w
   UpiFPYd9+9Q2CUgg0+p/AIkM4IYrRcjwb9Jz7PU+KRaGQ0BC6UFZ1UhNt
   +qCMlduD5p6jYRF4qabRa1evU4f9WBXfu/JejtP3eSp+THfrCUuiSc76S
   SM1n8NWVE9GPyFL+rdNnMmTfwIExjf6IHLUv4DB0lpy3Wk8uft6tu9zA1
   g==;
X-CSE-ConnectionGUID: owM/sdCzSneskOmFerhbTQ==
X-CSE-MsgGUID: dWbthxZ+Rq2cPfGmR3H9jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="65974152"
X-IronPort-AV: E=Sophos;i="6.16,308,1744095600"; 
   d="scan'208";a="65974152"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 00:28:08 -0700
X-CSE-ConnectionGUID: MMsK7Z+VR/y9DoWckXwXiQ==
X-CSE-MsgGUID: 1dwVsQhwTUqhStdtCA+8dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,308,1744095600"; 
   d="scan'208";a="157415947"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 00:28:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 13 Jul 2025 00:28:06 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 13 Jul 2025 00:28:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.43)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 13 Jul 2025 00:28:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZmDOFgilXM9hUW0q2QHc4aunZV89CtrGuBWcwWnzCtKxf47cmQAK013roSs55OP9szXzaCv9dd/5utrEytZI/T9uwgpMHwFewfGAy5urhxMePXYTMc6cGfBnbpGCVxu4BeJ3B/LScM9LXpnpEhX10+/aOy7AXmz509RRhsUQQKJ8fJ3bp5gNx1dGMKNCIe6uBtQeGg90LdZRK+opGfajfvyUNPJZ0WveO8G4luyCA2giTinMS0InwKMnglZjr6AsfmIabgRFg59vwEsF+MR/5JD55Yw7Sl18OPaybcLogvqeBJCz/ia7P2nOIyzj7DuCXZMO2bZBqc1+2BZ9NiJphg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T6LYJFeKoRQNTMMjKv3KfSULRqe7ZwhlGR+rofBOoV8=;
 b=oMmYfS3UKzrvDRgFTRTvxFORwlcsBTY5v41+eK+ixBKM2OkJdr1hXvtoFhRM5Ad6wFEjFm/dJ1/S8R4pmCpQuaSaATL6o+Haf/dSqy7Z6aVz9aXfD1MJLw9epjMuUNM2ckxTw9ZyspYVZQAhvRbpm0jfkJYP5meSMY8M6oxTyaeEMXnz3djUqMuNgoQmG8hZeg6AsXSBNGQZvMWx211KdJz/wieamDN2zDZu7uh9qLuNZzqB2hNME3y5+rmGWBJcga9HVLbLmxCnAisaU5LFfB8T9/Gkrw3RATCOnfMl69mzP/aOUwh3xHb6GiLxtJuFeOJ9VkCdhV0U8N28tszSbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6794.namprd11.prod.outlook.com (2603:10b6:510:1b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Sun, 13 Jul
 2025 07:27:51 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8922.025; Sun, 13 Jul 2025
 07:27:50 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/2] KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC
 protected guest
Thread-Topic: [PATCH 1/2] KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC
 protected guest
Thread-Index: AQHb8JJLIckCSKhKI0SfYM7v0qBEG7QpeMyAgAKAwwCAAH24AIADNteA
Date: Sun, 13 Jul 2025 07:27:50 +0000
Message-ID: <150fc6eca8e66d97a4280fefcf16ba33ac19ce68.camel@intel.com>
References: <cover.1752038725.git.kai.huang@intel.com>
	 <8aebb276ab413f2e4a6512286bd8b6def3596dfe.1752038725.git.kai.huang@intel.com>
	 <e3da1c7e-fa47-415f-99bf-f372057f0a75@amd.com>
	 <9b2e872b1948df129e5f893c2fbd9b11d0920696.camel@intel.com>
	 <85ms9btfez.fsf@amd.com>
In-Reply-To: <85ms9btfez.fsf@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6794:EE_
x-ms-office365-filtering-correlation-id: 072ad72e-df99-4798-8670-08ddc1dec62e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VFcyUlIrUHRQVUtnQ2xKeGg3cTZaRXF4TnVUYlhzSVNnTFhjN3h2MzFuRmZi?=
 =?utf-8?B?Z3RZRjdNUHlPdVowL244bVNnSVExUTA5b3JFK1RNaFFuNnAyeG90S3pEZFdl?=
 =?utf-8?B?Uk9OUGk1RElteDRhWXNsWi83MUJmN25UaUpqclBsM0ZhczM5MWs1dVAzV09o?=
 =?utf-8?B?eHZQdmtpR25rL29DV0U1WnhHbDE4cDJFUGtLWENrNGJXU0hmTC9HS1VyQzBr?=
 =?utf-8?B?SEhXZkM1RzFzVFNCVE5CdWNxKzlEbnNRdHNmS1ZGQnhVRDErQ2tKOW5yTW1m?=
 =?utf-8?B?VzhwVU1vUUlaWmlYWnpKNjQxQ1BMTWtxZ1hZbVViQzF3aWd6eEZ0MFRVLzNZ?=
 =?utf-8?B?d3lOdk1PY2ZkdnA3Mlp4OW5UR1hMVDY1dzhSZ2ZnZDhKYTEzbnhLc0hxbjgv?=
 =?utf-8?B?VmhZU29lbzNBYnpGWXI3aW1wSFc5Nm1DL1dscEh6bTZPallFSjJ3S25ZZ3g2?=
 =?utf-8?B?ellPVk51QkRDQktGbGtqZmZ6VWJMZVgzVXVFTHFRSGdtNHk1NGdPUzBHaWM0?=
 =?utf-8?B?anBKRGJEekhLbVBuOUVoRTdBbzBJcTkxRGYzUHRUc3dkWE1LUXQ3eExQVHZD?=
 =?utf-8?B?bFZGc0xNSWVNaVBSTi9QZUgyZGZwelpUUlJyYmplV1ZrVjduUzhrSitaRzls?=
 =?utf-8?B?d1JDUVJWZDRySjd3ZCt2ZGVOMzVrVllwOHJqUi95TFAwMjAwWHdqcjllYjRY?=
 =?utf-8?B?aGRyanJRQStxUk5CemJ6WEdIK2VEK1M5VE5HSUt4R3VCbVdBR2Z3ZHc3SStC?=
 =?utf-8?B?YlVNajh2MXZJRFJYL005bnpYNmFhemZrZFRaZkU3bUtHbmFmalZtbEZJTk00?=
 =?utf-8?B?b0hHVFdXMXhOeVFRdXhHYy9XcWJua2ZVTGROZzlTNC9jNEdZcmNDa3Z6VnBJ?=
 =?utf-8?B?M2htWDMybFBBbHFDK2lBekRFbEx5bkVyMW9VRjhtMDNZODlPVWRYdXQrYTN5?=
 =?utf-8?B?VnF3d205TzQyRjlpZTFRa0tPdVI3dGVua2M4bzVDcjBqMWVRMnkrNWRETXVw?=
 =?utf-8?B?N3VXTloxWUtaTlFQSUttVXNPWG9zUHQ5U0w4WFhLTXZPenhUYlhrSDZvUHBq?=
 =?utf-8?B?ZGV2clVSaTQybnZQODlQQVRhQXFsNmxlQ1o1WVMraEhRdndxSXJmU2hoL0NS?=
 =?utf-8?B?UGFuWG1jVmJiQUEvcjNlbE13cUUzcTVzUzVIMmZ1V1lJVzhLeWovSzNCTDRo?=
 =?utf-8?B?dSt1Q0Zhc0JhckRuMzFRM1ovU1RxM3RPL1VZMXZMbDRPUWIvWGlIeDhzN2VX?=
 =?utf-8?B?clV1b3RTcnlsc1ljbUlDaDVaM3Nib1FrQmgvVldUeWVjNHFKcEtsS2I4aEtW?=
 =?utf-8?B?Y0R4WkRaSzBrWXlyeHZoOTVvc3R3blhkR3lVQUp5UE41U2tkZmdEMUlUcU5R?=
 =?utf-8?B?YlBZUHEzTHhKKzkwQXlSQm5GUDM2S251dHdSeDBITThnczdYTXFNU0t0Y2ov?=
 =?utf-8?B?b0pyTHh5OFFiM3M3VjhMZnF2Uk5xR053cWczeWtNbGoraCtPUmxvSTBGbk9K?=
 =?utf-8?B?bFJ3RTVVSjBaWlZzZkZkdFhUb21zS2JjV2dkOXh2b1VIQzBQYWtCNWU1ZFV1?=
 =?utf-8?B?WTFhRGczdHU1emlCN2Y2UjZIZGNiODU2RmZiNGpOMVMzQjF4V1pVd1RBc0Rw?=
 =?utf-8?B?V1BFY05VYW9Md0xQT1grWlJEejVVODNLSXZXREcyeVNvVXZTQXRqaS83VFFN?=
 =?utf-8?B?SEFTNGlzRlNtYnp5Wk84MHJNVWlVWE9EYWtkeXd5V284c0dYNVR6dytHWDFR?=
 =?utf-8?B?eWpCT1FpcW1iTnpnRks3VXdKeEpsWFRTeTBSbzRheDVnemZsRk1iTHRFSnJR?=
 =?utf-8?B?SVBZeDNHYmRCTVgxZjNnV1JjWVpLUGg2aTJnK0tXMlFnYjRPemFYYlpYamtw?=
 =?utf-8?B?OTB6bGxRc29nTzVaVGM5SkxDdkQ5VnZwR2ZEN0FKd0d0NlZzdTlOMmhWcXEv?=
 =?utf-8?B?QjNVa0xTOWxYTHFUVkw0QU05YmdHRzZqZkI5RHl3OVdDTVNvRTFwdnVYUTd2?=
 =?utf-8?Q?i4pm8XKG0dUilCHk6n9D1zfu4Oh+FE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkpxS3V0U1dvWVRQN3RWcmoxM09EM1krVi8rdzlxRFUvbi9Lamp4RC9jSU9M?=
 =?utf-8?B?MmNYTUtTbkRnekpKL3I4OEQzQ2pNUmhBZ05lOE1qaGQ3ZDFDUzRGeDRDUmY4?=
 =?utf-8?B?enJoblIxZ3N6VnREWVJJRzdTOVQ4NTN4Z04yV1NhNCtHZ0hlamlXMmNVZ1FM?=
 =?utf-8?B?WU9ScitUVGxFQ2hNbkRGaFBpRlZBQmJkV0RzMU8xQ1QwOXhWRXF4Smx4STlr?=
 =?utf-8?B?N0wxdFJuVkIrOUxYNGpMNlFrUjhua3RXdHRtZ0YvYTBObjQ5UGNPU3E5M3JD?=
 =?utf-8?B?cTd2c3VwWXFkaUoyNnBwdlh4QUllUkswYmwxNkxiTXVlYkQrV2R0dGcxRytx?=
 =?utf-8?B?Smo3MEdMa3dXbjBzdW5uTldydzRwbmNCejRjdjhYTWRaMXBMaE10V1ZGTmI1?=
 =?utf-8?B?Sy9UZ1F2bVNJTUVaeDBvajIyNElqcDdLTjNzcnlOaXdLQnpLdkYrSHhiKzdn?=
 =?utf-8?B?eHBKbFhtMGUwcjF3cjkvaTJWNTBCTGZMa2xhUW1pOVRITEd3R0J3RWtINWhS?=
 =?utf-8?B?YjRxbm1FZWI4d2F4TENPRnE3aHhYdDNEYXlSbnAzMUtvaGtiWVo3MnQrTnBR?=
 =?utf-8?B?dmJTR3RXTXhZK1NqYm52RVRkU3pOc3RmUTlHWjR2dTBjajlyd0lIMEdNRG5x?=
 =?utf-8?B?Q0FiR1ByVENyNGtpU1BpR3FFU2dqbXFnTGxJMCt3MHJQRzdjTmY5YzgyeU0x?=
 =?utf-8?B?c2RtTTRJR3g2L0h2bTRYbWhQZStBNGFvSTJ6MlJubGViaEQ0NjF4NzJ3R21U?=
 =?utf-8?B?ZFdCNDhiOHU2bm1sU0JkVkYrTzVsMVM5cFlPaGE3NVBIU0NveHIrZTBEMXQ2?=
 =?utf-8?B?T0Y2OVQyV0QwZlJwdVdmOXZRcjd6bTZ5b2cyZ3k4alltU3cvTUlaWVg2Sncv?=
 =?utf-8?B?d2NkWjRjNmlIdmZqcEJMc0V5cFFVUm8zMWtsVENYclh2SGJyaXRiWEFPTndl?=
 =?utf-8?B?OVBtTXBpTkhGMnlkUGF3T0g1R01ETC9sY0M5WkR5aEtwbE1oc3h6TFN3Mnly?=
 =?utf-8?B?TUNOeERSL0x2WU9tam14bEtucXhHRGRGM1hrU0dOVTJ1ZTRhdURWblJkSnhV?=
 =?utf-8?B?akx3VGFWTkR6aEVxNU9sUlBvQmxnS1lmbWNBTU5NbTFqaFpjTU5CczFoeGdh?=
 =?utf-8?B?TlpKWURKWU5JNWwxRmQ0a3hzSkR2TGZQR201VWNlQXhVckhQT1pLMTRBOVRV?=
 =?utf-8?B?QUJrdUxtYkVlWmJGdHpIK0FyN1RvbFkvd1I5SE1XdFQ2TXY3Z2FDRmE1dngz?=
 =?utf-8?B?ZzFsNUdoaVkvMU1LVTFiVUpIbXZMSHJLaUphSHF4TkxuOFhXaVlTRXZzVU5O?=
 =?utf-8?B?NmpUcjR2YWJTQnhzS09hdnNtUFhmTWVKVXB4T0QyMjlRSW1URDVzZDBpYldh?=
 =?utf-8?B?a1E1blVwNHlyc1R4Q01ydnFrRU9ybDBFMk10bnNpZDRWdzg2bCtEajdLTUZE?=
 =?utf-8?B?TVJ5NHQ1OVRadEdvODBaSC9mKzJIK21pWTl2N0poNi9FR3NrRG5JbnFaUG02?=
 =?utf-8?B?OGUyMXN3WTA3RkNSVHNUOXRWU2NDZUQzQ0ZsY3RwSXZTeHpqVHRaTU1SUElN?=
 =?utf-8?B?VXFPOVBSd0RRYnBBNW1EOWRvTGhHdHgrWjh2N0IzaEI4WCtVOHY3R05KdUZ2?=
 =?utf-8?B?TG1MM1RGTDF6SWlNSUJHZmt2Zyt4bE4rWkpNbmxmSXJZK2tTRGRFZUR1M0E2?=
 =?utf-8?B?R0xYY3lEVDVEanBIa1RTMFRpaERQUFU3RW1WLzRKZjJKTThJZ0lXZnRHd3ZF?=
 =?utf-8?B?bW5zN0c2bGEwS0dFMkNvTURGdHpFYzcxdm9IalpqM3ZyVDdqQTdxbDJyVDA4?=
 =?utf-8?B?UmZ5TmhqUEllbS9uOXdKM2dzSEIwUFhSWXgxd3NqejFMVzk2KzVKbzBITnNY?=
 =?utf-8?B?VEdmdzRjaFVmN3E3U0YxUlFNQjB6bGhvMjNieHpyeHBBMzloeDd5Ynl6OUR6?=
 =?utf-8?B?cWdqM20vcnVrRHpUc0N5dUo3cDB1bldhVFA0d1VEVmV1WjBVZXFSS0NCSCtz?=
 =?utf-8?B?MEtvNk9adjc3eWhOdXJFZ1BuQ1FCV0JBYzMyeC9ObXZzK2FzU3p1MllsRkky?=
 =?utf-8?B?ZjgxWmdkclp6WU8zUmJnUWJsaUlLMHMrOVpQckUrckRnNEpudlpzY3VMRGRZ?=
 =?utf-8?Q?EwgCxotAaQUodVVwMe7kUVwrL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB187FBE095212419A181E1BFE3C748F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 072ad72e-df99-4798-8670-08ddc1dec62e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2025 07:27:50.8203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9cptkxsxSxUzI3C98RIkFjICM7F0ppo6Ls2bmC6K0TJkeeYDRpJijCS2EWyAleQi2GWznriy7HtQ08yBSYdKRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6794
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA3LTExIGF0IDA2OjIyICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gIkh1YW5nLCBLYWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cml0ZXM6DQo+IA0KPiA+
IE9uIFdlZCwgMjAyNS0wNy0wOSBhdCAxNDowOSArMDUzMCwgTmlrdW5qIEEuIERhZGhhbmlhIHdy
b3RlOg0KPiA+ID4gDQo+ID4gPiBPbiA3LzkvMjAyNSAxMTowNyBBTSwgS2FpIEh1YW5nIHdyb3Rl
Og0KPiA+ID4gPiBSZWplY3QgS1ZNX1NFVF9UU0NfS0haIHZDUFUgaW9jdGwgaWYgZ3Vlc3QncyBU
U0MgaXMgcHJvdGVjdGVkIGFuZCBub3QNCj4gPiA+ID4gY2hhbmdlYWJsZSBieSBLVk0uDQo+ID4g
PiA+IA0KPiA+ID4gPiBGb3Igc3VjaCBUU0MgcHJvdGVjdGVkIGd1ZXN0cywgZS5nLiBURFggZ3Vl
c3RzLCB0eXBpY2FsbHkgdGhlIFRTQyBpcw0KPiA+ID4gPiBjb25maWd1cmVkIG9uY2UgYXQgVk0g
bGV2ZWwgYmVmb3JlIGFueSB2Q1BVIGFyZSBjcmVhdGVkIGFuZCByZW1haW5zDQo+ID4gPiA+IHVu
Y2hhbmdlZCBkdXJpbmcgVk0ncyBsaWZldGltZS4gIEtWTSBwcm92aWRlcyB0aGUgS1ZNX1NFVF9U
U0NfS0haIFZNDQo+ID4gPiA+IHNjb3BlIGlvY3RsIHRvIGFsbG93IHRoZSB1c2Vyc3BhY2UgVk1N
IHRvIGNvbmZpZ3VyZSB0aGUgVFNDIG9mIHN1Y2ggVk0uDQo+ID4gPiA+IEFmdGVyIHRoYXQgdGhl
IHVzZXJzcGFjZSBWTU0gaXMgbm90IHN1cHBvc2VkIHRvIGNhbGwgdGhlIEtWTV9TRVRfVFNDX0tI
Wg0KPiA+ID4gPiB2Q1BVIHNjb3BlIGlvY3RsIGFueW1vcmUgd2hlbiBjcmVhdGluZyB0aGUgdkNQ
VS4NCj4gPiA+ID4gDQo+ID4gPiA+IFRoZSBkZSBmYWN0byB1c2Vyc3BhY2UgVk1NIFFlbXUgZG9l
cyB0aGlzIGZvciBURFggZ3Vlc3RzLiAgVGhlIHVwY29taW5nDQo+ID4gPiA+IFNFVi1TTlAgZ3Vl
c3RzIHdpdGggU2VjdXJlIFRTQyBzaG91bGQgZm9sbG93Lg0KPiA+ID4gPiANCj4gPiA+ID4gTm90
ZSB0aGlzIGNvdWxkIGJlIGEgYnJlYWsgb2YgQUJJLiAgQnV0IGZvciBub3cgb25seSBURFggZ3Vl
c3RzIGFyZSBUU0MNCj4gPiA+ID4gcHJvdGVjdGVkIGFuZCBvbmx5IFFlbXUgc3VwcG9ydHMgVERY
LCB0aHVzIGluIHByYWN0aWNlIHRoaXMgc2hvdWxkIG5vdA0KPiA+ID4gPiBicmVhayBhbnkgZXhp
c3RpbmcgdXNlcnNwYWNlLg0KPiA+ID4gPiANCj4gPiA+ID4gU3VnZ2VzdGVkLWJ5OiBTZWFuIENo
cmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTog
S2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiA+ID4gDQo+ID4gPiBOZWVkIHRvIGFk
ZCB0aGlzIGluIERvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdCBhcyB3ZWxsLCBzYXlpbmcg
dGhhdA0KPiA+ID4gZm9yIFREWCBhbmQgU2VjdXJlVFNDIGVuYWJsZWQgU05QIGd1ZXN0cywgS1ZN
X1NFVF9UU0NfS0haIHZDUFUgaW9jdGwgaXMNCj4gPiA+IG5vdCB2YWxpZC4NCj4gPiA+IA0KPiA+
ID4gDQo+ID4gDQo+ID4gR29vZCBwb2ludC4gIFRoYW5rcyBmb3IgYnJpbmdpbmcgaXQgdXAuDQo+
ID4gDQo+ID4gSSB3aWxsIGFkZCBiZWxvdyB0byB0aGUgZG9jIHVubGVzcyBzb21lb25lIGhhcyBj
b21tZW50cz8NCj4gPiANCj4gPiBJJ2xsIHByb2JhYmx5IHNwbGl0IHRoZSBkb2MgZGlmZiBpbnRv
IHR3byBwYXJ0cyBhbmQgbWVyZ2UgZWFjaCB0byB0aGUNCj4gPiByZXNwZWN0aXZlIGNvZGUgY2hh
bmdlIHBhdGNoLCBzaW5jZSB0aGUgY2hhbmdlIHRvIHRoZSBkb2MgY29udGFpbnMgY2hhbmdlDQo+
ID4gdG8gYm90aCB2bSBpb2N0bCBhbmQgdmNwdSBpb2N0bC4NCj4gPiANCj4gPiBCdHcsIEkgdGhp
bmsgSSdsbCBub3QgbWVudGlvbiBTZWN1cmUgVFNDIGVuYWJsZWQgU0VWLVNOUCBndWVzdHMgZm9y
IG5vdw0KPiA+IGJlY2F1c2UgaXQgaXMgbm90IGluIHVwc3RyZWFtIHlldC4gIEJ1dCBJIHRyaWVk
IHRvIG1ha2UgdGhlIHRleHQgaW4gYSB3YXkNCj4gPiB0aGF0IGNvdWxkIGJlIGVhc2lseSBleHRl
bmRlZCB0byBjb3ZlciBTZWN1cmUgVFNDIGd1ZXN0cy4NCj4gDQo+IFN1cmUsIEkgY2FuIGFkZCB0
aGF0IGxhdGVyLg0KPiANCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92aXJ0
L2t2bS9hcGkucnN0DQo+ID4gYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QNCj4gPiBp
bmRleCA0M2VkNTdlMDQ4YTguLmFkNjFiY2JhMzc5MSAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVu
dGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3Zt
L2FwaS5yc3QNCj4gPiBAQCAtMjAwNiw3ICsyMDA2LDEzIEBAIGZyZXF1ZW5jeSBpcyBLSHouDQo+
ID4gIA0KPiA+ICBJZiB0aGUgS1ZNX0NBUF9WTV9UU0NfQ09OVFJPTCBjYXBhYmlsaXR5IGlzIGFk
dmVydGlzZWQsIHRoaXMgY2FuIGFsc28NCj4gPiAgYmUgdXNlZCBhcyBhIHZtIGlvY3RsIHRvIHNl
dCB0aGUgaW5pdGlhbCB0c2MgZnJlcXVlbmN5IG9mIHN1YnNlcXVlbnRseQ0KPiA+IC1jcmVhdGVk
IHZDUFVzLg0KPiA+ICtjcmVhdGVkIHZDUFVzLiAgSXQgbXVzdCBiZSBjYWxsZWQgYmVmb3JlIGFu
eSB2Q1BVIGlzIGNyZWF0ZWQuDQo+IA0KPiBzL0l0L1RoZSBWTSBTY29wZSBpb2N0bC8NCg0KT0su
ICBJJ2xsIHVzZSAiVGhlIHZtIGlvY3RsIiwgdGhvdWdoLCB0byBtYWtlIGl0IGNvbnNpc3RlbnQg
d2l0aCB0aGUNCnByZXZpb3VzIHNlbnRlbmNlLg0KDQo+IA0KPiA+ICsNCj4gPiArRm9yIFRTQyBw
cm90ZWN0ZWQgQ29DbyBWTXMgd2hlcmUgVFNDIGlzIGNvbmZpZ3VyZWQgb25jZSBhdCBWTSBzY29w
ZQ0KPiA+IGFuZA0KPiANCj4gcy9Db0NvL0NvbmZpZGVudGlhbCBDb21wdXRpbmcgKENvQ28pLw0K
PiBzL1RTQyBpcy9UU0MgZnJlcXVlbmN5IGlzLw0KDQpPSy4NCg0KPiANCj4gPiArcmVtYWlucyB1
bmNoYW5nZWQgZHVyaW5nIFZNJ3MgbGlmZXRpbWUsIHRoZSBWTSBpb2N0bCBzaG91bGQgYmUgdXNl
ZCB0bw0KPiA+ICtjb25maWd1cmUgdGhlIFRTQyBhbmQgdGhlIHZDUFUgaW9jdGwgZmFpbHMuDQo+
IA0KPiBzL1RTQy9UU0MgZnJlcXVlbmN5Lw0KPiANCj4gcy92Y3B1IGlvY3RsIGZhaWxzL3ZjcHUg
aW9jdGwgaXMgbm90IHN1cHBvcnRlZC8NCg0KT0suDQoNCj4gDQo+ID4gKw0KPiA+ICsNCj4gPiAr
RXhhbXBsZSBvZiBzdWNoIENvQ28gVk1zOiBURFggZ3Vlc3RzLg0KPiANCj4gUmVnYXJkcw0KPiBO
aWt1bmoNCg==

