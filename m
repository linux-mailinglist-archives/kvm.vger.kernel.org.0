Return-Path: <kvm+bounces-33377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 295F39EA635
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 04:10:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0812F188BDD6
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 03:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230AD1C242C;
	Tue, 10 Dec 2024 03:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZqXyXUaV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AE813B58C
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 03:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733800221; cv=fail; b=cU2ftMZMFuRrFmy3YoUYxwPPuF0y9YOmrpPCJ1O/MYaOc49kDwUfUaAm3FnBXondxYiZ0Ug36luQEFtvyMpyAWkNfsQPHqG4R2y1Ka/XYbPrO0D/Y2HIGECM0HMTsFgxem1hrH/JW8k7hmN2z6K1HLDFhkcMWZPRZIfzhETyNTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733800221; c=relaxed/simple;
	bh=BV3pjZuBwrIil9mws5TId11LSdPBTfYXDAPP384TIkc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q7/bznNNwan71Hj8+0qvBzudbTAzQUxZt9Fdj57Z6BSHiuWK3G6mqgMAF6eGlJ88BmLXZILirqwSMhmbYDhThHi5R/R2rYnNFnTfViDIRo6qQUzlk203BI6c+jLhcUVlzYc1erIFVwqcOJm+ooZjVec0ShMrCGbZzzIcpBQ1F3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZqXyXUaV; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733800220; x=1765336220;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BV3pjZuBwrIil9mws5TId11LSdPBTfYXDAPP384TIkc=;
  b=ZqXyXUaVdHDD9lA6b9LZOSFPKf3d9bCTnM8GsTx9bOF8XUcdGOTuZRXh
   Lm0W9eyrenpTAHk8oXxm0mar5ZGw0lFb0VoIFVGKMM+FSHpu0rRxvjvWR
   viFK7lP0eKggMVjzkZOnsgsGWK+YpAzzGl8Xu6td40ghGpk84JMP9z6S4
   GzkJz5Nd1KRBNeWiJF0aLNBThMJPvdFYpzhPqWkdpZlWE9mxMPJe+IGf3
   6bhT1KhHbnsTOyKhfidFtWn0wp11/pEvSLEYsHZIOL4jrdvB9fcTn2tF9
   GLKP6nqSBdm+OrX/JGHhWLmBLEtT6Cw3H1S3xNsoZyvNul44fom6DH23g
   g==;
X-CSE-ConnectionGUID: lBu9awDSQWSGskBKTNNxVA==
X-CSE-MsgGUID: On2nip/TQFeJSyiHNlEQWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="59521387"
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="59521387"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 19:10:19 -0800
X-CSE-ConnectionGUID: GlwUScUwTF+QDVCK9F0dVA==
X-CSE-MsgGUID: q8hxFgqBQBSzj+lSVYjqLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="100301732"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Dec 2024 19:10:19 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Dec 2024 19:10:18 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Dec 2024 19:10:18 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Dec 2024 19:10:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yme4yVKt2pUXg8ZswWhiSJ7LgXQGOv/XgWmmdTOwLsTcDDz+m/fDQvxiPAx5QeFPPosPDQO+8WIs5uMzJPi8iyr0TM/YrrWGVdNZOC2z8Ga1PfcYRt48JhV+2/ro3eq1h4lH95ZbWXnuao0f/ncbtp7RHj7jsASmQuOv0teQiNyfoRaPDyxQ7onkWHqUkH3wOenKkPjV0QrpXhE74dbWvfFqZqy9J/0xjtQt1CHE9IGQLdirCA8LEnZe7Q9CMjqolRkGN5mufMRYk8fQkxTLXccEh63XMnbDHqpXimmaH7aKwRa7uNTgk0R117o2y9/E0317gdhrETDvGicNoALR2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vXjuRdCE4d/W0XX1c2hks+7MWh2S2UavOjO0B077j3E=;
 b=yz+UwlkrX4ZAWuzY4E9c7ZdJ1IpaLHNaHRxeZFABOg5JMJrYrtpflpRV8jjvI+G1mgSJ2bWmu5xKYUug7Xv3pBHd3iAdSJuv9nsLYYbB3jnei62g3sBaIFCNx6HoUUQFODncaxcJC3yoHvswn7oZERxDDZZfDT4NVbIYs8OptXq32kHcb0CRhChcLIc32i/WmD1JeMiWXf3obiY058/Uf5jdYPYCo7EIwj5ehmElxWUlFGmyItR55UfWrS7hSrBEVY2J1G1L536PGPKZ3M5DB4Tb7lL8yo4gcgQpLv7Qt6bUjRzod4LYtHBd4nfbOO2rWXwGUw/wr83jyyyGoYvFJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB4776.namprd11.prod.outlook.com (2603:10b6:510:30::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.17; Tue, 10 Dec
 2024 03:10:15 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8230.010; Tue, 10 Dec 2024
 03:10:15 +0000
Message-ID: <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
Date: Tue, 10 Dec 2024 11:15:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<alex.williamson@redhat.com>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
	<kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
 <20241206175804.GQ1253388@nvidia.com>
 <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241209145718.GC2347147@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::23) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB4776:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df803c7-17b8-4bfb-518b-08dd18c82ac9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QWFtMWhnY0JhSFdEaUhOUTlwRStiMUd3SEV6eTF1UmUrNGU2cW5Md29scllF?=
 =?utf-8?B?dkYrQUpFSnFrN1JnZk9uR2lnc1hOdGtFd2dPNnZMSmxrTTNKNUZXV2JaUDF2?=
 =?utf-8?B?VGNyRHVweUNPMkNiTU5wT3lHaFlJOGJhRjlaY3ZuaU5ENkxCNk1rUnVXQ1U2?=
 =?utf-8?B?WXFBR1pLY21xMmhjcmlyRVBEK3FkZW1WbGxvcGhBaldHYzM4T2Z1S3llSXE5?=
 =?utf-8?B?cWpadzdCZUhKWVFITncxSGVGZmM4TnZ1TThBU0lkSWNGM2dPemVTbHZvcVEw?=
 =?utf-8?B?bmRUMlM0K0t3eUJqSURtUjluYnNiSWorbnUxSC8rR1UwYzY3MmVrT1o4a29h?=
 =?utf-8?B?RTIxL3ZNM3Q5Nm1vU0x3ZHJDSWNSUDN4Mk85WHNhM0VnSFVwUEJpa2MrWDF5?=
 =?utf-8?B?VFlqYUJhREFFUE1oaHBzME4xTHoxVWVUU29wNzZjc1VzT1RUVE1XWTNCQTNQ?=
 =?utf-8?B?dlg3L09VUFVEbmFXWE04YkFZZ1N6SXRjYTliVFJDQkZvQllOU0tQMkc0WXRM?=
 =?utf-8?B?UHYrTVhtUWhvNjI5UU5YRElvR1F4SDdGcEJxQlg3WjU1dW1aYzd1aHcwdFh2?=
 =?utf-8?B?ZDFHUkNraFFLOUlhd3lCSi90UlNVOGNSbi85bDNHZ2o0c2IxQ3BhRm50bU9C?=
 =?utf-8?B?LzE3SFJvajdZM2tQVURjL0I2UEdEMnFJLzFFMXBUVjQ5TGttVnBNSFpVVW1t?=
 =?utf-8?B?ZU5MOFhhZHRCaDNsMWRoS09HbC9oTENtTnNLTDZub2tDOFpqdmw1L1NxamZN?=
 =?utf-8?B?SHNISFBWa0NHS1U0M1Y0OUdGUzFsa3pNOGNsc2s4R2V5YXR6NVJ5enQ1cXBV?=
 =?utf-8?B?dVA3WEMrbzFWMTJadzloSnVpR0VrUEM4RktwNmVkRDVUWitRc0dPZmNNSkVa?=
 =?utf-8?B?UXg5dUthYk9sa3hMK01vQ0lUdHNna0J3bCtMc3NoK1pTZFBJWjBheUVqMVFY?=
 =?utf-8?B?Vnc0c29RYW5SdkRmL0J1RXcvaWFVK0JNMldadHFvZzVZbm11YWdaV2dOK3B6?=
 =?utf-8?B?NjVoOUdWUVl1SGhSeXZCMzA2ZGMzK01oMllLSytMR0U3d3ViKzgyVkcyRDE0?=
 =?utf-8?B?M1ovUHBpL2JNY0RHYVJFajVPVnZEMERQa0VxNW9hemdqekVZM1Q1VFZKMnFF?=
 =?utf-8?B?VldxK3hnUkNYYVZ6S0V3WFFTSzJsR2M2N1M1cEhmTm44OEl2Y2hMRDFmK1p3?=
 =?utf-8?B?OEpFWkhKZ05GR3J1Ly94ZXN2R1hjS25TbXF0MjZqaHA0KzRYZG5JT3hnR2Ju?=
 =?utf-8?B?YjJod3U2YVpxcXdtSDJLSkVET0pOaXQrdjROVFJkWXIwR0I4RXZuNkV0blhj?=
 =?utf-8?B?RldJcW5aTDE4TEdSWUk1eUFoSzFZc013TGJVYW9SaHRMdTN6WU1lZ1hRaVZM?=
 =?utf-8?B?b1FnWWg2SFY3MXJKTGs5T1dpTis3WTJ0ZDFiV0VtODdWR3BXcXZEbnlXVWtR?=
 =?utf-8?B?RWV0ODkvSnZoNmhLMlptQ2oxUk9GK0l6UnVvZHJNcEcrSWsxc2NjTkI5VStI?=
 =?utf-8?B?Y2tCd3NxMkRpdXdQK2k5YlZoK2xXTldLaEwydEFiYTVIbGlFZGxmdlhZN3ZG?=
 =?utf-8?B?TFVmdHB2TlA0NFVFQkt4UU4rdlRHaG5ZcnpTbzBDcHgyb3RrK1RwUVFYd29u?=
 =?utf-8?B?T0g5NHFyay9FS0h1V2JwWWVUVHhPeFNZOGUvVG9ZajFxdGJJOGpDV25iZ1la?=
 =?utf-8?B?REs2ZFJoZDVWQXNTNE5qUDFleDQ3UC94TFdzeW5BcnQybCs1L1RqRGFHVHF6?=
 =?utf-8?B?UGY2VkV2bG9Rbmk0cVZmTjB3NndaVkdzbVI1R0U4cndMMnBWbkZ6Uk9XS2hB?=
 =?utf-8?B?NEZXSzZHZHBuVnRubjk5QT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXBDWHhXZ25PUG9HS1ByY1VKNm5PeERLWlg0YjZvTHJ1aitibms4WG9HcTdT?=
 =?utf-8?B?dU9HSEtpK0RkTUtFTy9SUkt2QkdFT1dWcFNVU2UrOE45VldVZ1NsemNzZ0cw?=
 =?utf-8?B?LzAzcjI0dXlDUEdFM1JNMnlTbGhVaVZIZU9EdlEraGNBRXdVZHd4OWtaV2ha?=
 =?utf-8?B?UFlrRUZMUi91bVA2cXc1VHkzZzlyTkhUMTJIVDFtNnFTTHV3V2lSYXh3ZC9s?=
 =?utf-8?B?UFhTVkpSbWlPNGRGMDd2OHYvcXNBMnE3cnE1UFdBMkkvTVd4ODhUd3FNYlBm?=
 =?utf-8?B?MTZLMEhiQ0VWMDA3eG8wQ0VCbURlMTRrc2xSZnVsejhrZ0pJMHFMSUVmTWNO?=
 =?utf-8?B?MTgvUzNJTzlsb3lVYVMxRndtcGd6Z0hoTFZ4OHhudjRLMFFQOGdTU29oVHow?=
 =?utf-8?B?Z242QUlyUUpsMGpjc0wyNHFIOWlEc2p0cy9wcGVzSVNkZVBQNHBQdlBHNkt3?=
 =?utf-8?B?MHlaQVlsYjFObUtxMXliZUdad1dRTlZyZWxPNHFBMjV2Q1MySmdrYnFuUVFT?=
 =?utf-8?B?U01FSlBnSlFkQjFGN2N6T21OSlBLdG1JNUxqS2RkVDlpci9nZmxVQVROMVo3?=
 =?utf-8?B?SmNzYVkvYTFFQitnaW4wL3hFcDlsS295b2E2eDlNZ2JJWXdURUxyOXZwYzE5?=
 =?utf-8?B?L0s2OVBMMDg2QngyejdDdExLVStJV3ZkRi91R0dKRmZTbEoyc0c5VmpxVFRJ?=
 =?utf-8?B?ZHZTZTBkSU1jS3BwUGdvSkJhZC93VTFjNmJJb3Z0S0I1bG94TnN5akswdWd2?=
 =?utf-8?B?M29ISkJNdFdVY3RhelhXelR5UHhNOHZIY3lPcVAwV01SQkdPM3RBbUFFblEx?=
 =?utf-8?B?WUloVlFNYVlmT3M4VGl5TGdQUXZRZFFmeUN3cFBZS1JMWGllaDQ2cXBZN3NU?=
 =?utf-8?B?b1RCVHdJdUdRVDR5VVp3MFB5cWdHTWVaZ0RzeXRleXYrc21sOWxBTVlWamFw?=
 =?utf-8?B?UVp2dCtCSHd2K0o4SmVIUmNXRWNPQ1NkcDY2emMwaEk3WVJRT0trbzRrMERZ?=
 =?utf-8?B?YnpsZ2s0dWkwa1RPYzBJekM0emFuNzlZQk1jU1pSUEwwZFlDaUJaRGRPVkR6?=
 =?utf-8?B?NHNQeEgxc29mWTFON3pBaUNwV0oramR5VHJpaTN3UEkveFhlbm9HV3h5Z0h1?=
 =?utf-8?B?OWdGV3RIRzA0TnZkRlJIN2RUNW9iVlI4UXk2TVhWeHdCc3MyczRzaXlIaFhu?=
 =?utf-8?B?RXg5WSs5RDdIYzd2NGhyTUIyV255cWJvbkNRN2dCR1NKUDVOVUdmN2hvcE14?=
 =?utf-8?B?ZTFIV204SmlUYnBZYW1kRnluOWpWdEJBVW94ZWl0bXZYU3JUcmRwbldsZllp?=
 =?utf-8?B?QVYwdzlYc2NOb0hWTFRvWVVTd1JHZWh6RXVNQzRXeG12TktHMXpOeC9ieEhH?=
 =?utf-8?B?QXNYK0hZWjVpNXpDVUV4eFQ1WXFqdHlJZzlNcFNERm15T2VrZWZHclVFcXVU?=
 =?utf-8?B?Q3Y5d1dtVGpnYWVRdTA0cFdacU9BeXdUYzhKQ0ZMSkpUQTJqQmRoSDJNamgz?=
 =?utf-8?B?YXFMMzQ5UXRsLzBLYlFaWld3akdPY05WazZSaHVlV01SY2MyWDVtYkZCSHZx?=
 =?utf-8?B?ZjVpbkhNbmF4ak5mdFQ5U2pJeWovaC9tTUxvTlduNFlPZlFZd1VyL2dWY2sz?=
 =?utf-8?B?TjU0T3dKanN1bWdoVEdUalF5ZUZQQnA0bU1la1E2VWtDTmtITm9RQy9oZWh3?=
 =?utf-8?B?YmRvaUY5SmN4TTc2alRpSHNDQjRQWEJVYVJlbGF0NUJUVDI4N2MwRWZ4alEy?=
 =?utf-8?B?RmFSQTJBem83cVBsUXc2Ym9KODdkdVNEcVZldlRWMkNvZUU0QVlsMXpYSW8z?=
 =?utf-8?B?T1RsclNGZm1iNVJRMVlQR3lvYW54SFpGdEhXeXVRUVdubjBKQ3JhcmZqc080?=
 =?utf-8?B?T0V4dTJnWHJKekVsUVE0NE12TkRLNDFwY092bTd5Mlg5dk5kTmZxMG1CZDJz?=
 =?utf-8?B?TVpzZXBrWUE4UXhub1dUQVdSSUpiZmNDRTNROFg5eFVvYU5Rb3pHWnQ3QmxQ?=
 =?utf-8?B?RjhSbW10UXdUcXRLQWt4MGNTdWdTajltRXRmU0JUZWxWNnZZd1NKOXV4Yk5R?=
 =?utf-8?B?a2tOam5TTVVLeGU4blpzTnRFVkJYeUV1d2pUL2FTRFY5SGZzWjJsYjVLMEFM?=
 =?utf-8?Q?1JHalZFsXTAy1Z0ycyr0IDMqA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df803c7-17b8-4bfb-518b-08dd18c82ac9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 03:10:15.0224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LaMUd0L0O8TwhZyxH8RbJO7zEap7/J9hvbYBzSbaeqg/G5hh+kme5PY3vBlzv9UbHC7SBuThYLjv8G4Rtf2KNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4776
X-OriginatorOrg: intel.com

On 2024/12/9 22:57, Jason Gunthorpe wrote:
> On Sat, Dec 07, 2024 at 06:49:04PM +0800, Yi Liu wrote:
>> yeah, the dev->iommu->max_pasids indicates if a device can enable pasid
>> or not. It already counts in the iommu support. Since all known iommu
>> drivers will enable it once it is supported, can we say
>> dev->iommu->max_pasids also means enabled? If so, in the HW_INFO path[1],
>> we only need check it instead of checking pci config space.
> 
> That would be nice, and it is better than checking config space
> 
>>
>>>> - Nest parent domain should never be pasid-compatible?
>>>
>>> Up to the driver.
>>>
>>>>     I think the AMD iommu uses the V1 page table format for the parent
>>>>     domain. Hence parent domain should not be allocated with the
>>>>     IOMMU_HWPT_ALLOC_PASID flag. Otherwise, it does not work. Should this
>>>>     be enforced in iommufd?
>>>
>>> Enforced in the driver.
>>
>> ok. BTW. Should we update the below description to be "the rule is only
>> applied to the domains that will be attached to pasid-capable device"?
>> Otherwise, a 'poor' userspace might consider any domains allocated for
>> pasid-capable device must use this flag.
>>
>>   * @IOMMU_HWPT_ALLOC_PASID: Requests a domain that can be used with PASID. The
>>   *                          domain can be attached to any PASID on the device.
>>   *                          Any domain attached to the non-PASID part of the
>>   *                          device must also be flaged, otherwise attaching a
>>   *                          PASID will blocked.
>>   *                          If IOMMU does not support PASID it will return
>>   *                          error (-EOPNOTSUPP).
> 
> I'm not sure, I think we should not make it dependent on the device
> capability. There may be multiple devices in the iommufd and some of
> them may be PASID capable. The PASID capable domains should interwork
> with all of the devices. Thus I'd also expect to be able to allocate a
> PASID capable domain on a non-pasid capable device. Even though that
> would be pointless on its own.

yes. I also had an offline email to confirm with Vasant, and he confirmed
a non-pasid capable device should be able to use pasid-capable domain (V2
page table.

As far as I know, allocating PASID cpable domain depends on whether
the underlying IOMMU hw supports the page table format (AMD IOMMU V2, Intel
VT-d Stage-1, ARM SMMUv3 Stage-1 page table?) or not. So even for a
non-pasid capable device, allocating pasid-capable domain should succeed if
its IOMMU supports the page table format.

>>> iommufd should enforce that the domain was created with
>>> IOMMU_HWPT_ALLOC_PASID before passing the HWPT to any pasid
>>> attach/replace function.
>>
>> This seems much simpler enforcement than I did in this patch. I even
>> enforced the domains used in the non-pasid path to be flagged with
>> _ALLOC_PASID.
> 
> That seems good too, if it isn't too hard to do.

The non-pasid and pasid shares much code, I think it should be doable.

>> on AMD is not able to be used by pasid, a sane userspace won't do it. So
>> such a domain won't appear in the pasid path on AMD platform. But it can be
>> on Intel as we support attaching nested domain to pasid. So we would need
>> the nested domain be flagged in order to pass this check. Looks like we
>> cannot do this enforcement in iommufd. Put it in the iommu drivers would be
>> better. Is it?
> 
> Why can't it be in iommufd? A PASID domain should be a hwpt_paging
> with the ALLOC_PASID flag, just put a bit in the hwpt_paging struct
> and be done with it. That automatically rejects nested domains from
> pasid.

The problem is Intel side, we allow attaching nested domains to pasid. :(
That's why I'm asking for updating the description of ALLOC_PASID and
the enforcement to be only applicable to paging domains, not applicable for
nested domains.

> I would like to keep this detail out of the drivers as I think drivers
> will have a hard time getting it right. Drivers should implement their
> HW restrictions and if they are more permissive than the iommufd model
> that is OK.
> 
> We want some reasonable compromise to encourage applications to use
> IOMMU_HWPT_ALLOC_PASID properly, but not build too much complexity to
> reject driver-specific behavior.

I'm ok to do it in iommufd as long as it is only applicable to hwpt_paging.
Otherwise, attaching nested domain to pasid would be failed according to
the aforementioned enforcement.

-- 
Regards,
Yi Liu

