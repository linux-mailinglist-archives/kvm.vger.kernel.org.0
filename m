Return-Path: <kvm+bounces-31623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE659C5BA7
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:17:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2BDF281859
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 15:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C5E200B86;
	Tue, 12 Nov 2024 15:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EOHIQCMi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFE42003C7;
	Tue, 12 Nov 2024 15:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731424609; cv=fail; b=OeyT64aB/MtBemhkcuMD9BgXiek0Kdq7oD6oiSzc9k0M2wmUpA9qpskqlhdv86NJOglYkK+ylXIxxM78sLhdgCFVKFDgw6JhV69+yA5elqoQWjI9UrgJHOSR6ZLIvxrEud2hUg2PS2/u4byx92KYo8pIM0FswRNkhNi4boF/F9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731424609; c=relaxed/simple;
	bh=mRv0zbrHh+DTvCRESbka2nMZF+qBmxLrmAAr4wpNTJA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YgoOkyYrtSicXJ4EIFPlyQp91LlD8+WR2rBRS/WJb7TqzP01bACqWIxT1K8axX+bhyBP0ETl/Mc1WVzjQIU8HUPxkZz9vi/uIfj1ImVKkfqiVXEwmmc1+2I3Oh85S6f0oAbNNL5wXLLvr/RVuNDU3pe5Kbn2GOgvqJNsI7AHYY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EOHIQCMi; arc=fail smtp.client-ip=40.107.93.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PlqVFplgg9wO3DpLHprlv9+70uHj/w8duOJDlRLzIAAyE02ZQ9qPUr9K+mO0ZHUcjTvOktsGC+dgPQuFjvE60Ip7hC8Ao94VRZHCIpXrHKYzjid/HJK+Xk0Oow9/nIHgZ4aTpMHFonuWvvBgat60Lha7PQV2pJGiLwMwe8zS0FDL4XjzG153JopT8VZovA4LWguwLuwIcesmr0JWOWEvo+n5JenEqfwKQme8NMdeLGBtPd+OGO28lVrRMDxDmbkY60C75yO+YHf4KyMDu0wpKFmX0vGNMh48EpU4Qi5V46E4v2sJBK14WKEk2/bn+5Kt7E7njfKK98eWdct2XIaOAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mRv0zbrHh+DTvCRESbka2nMZF+qBmxLrmAAr4wpNTJA=;
 b=VsCT8GnLp/JuQSVJm/YchKX5Z4O3ROFHpOf+DPqJxz5caoNW/3YdEgMBSa7p9ckuCHwrfigcrHi+3Ocyfy0ihr/aM7ZcL3ujPgSZcgOmV54uk0y2Rl97xpBVT8WFd9RyCnDpddQe6jk5+lP+Qr1EdxOHS5wWYfCZfbUX2QLV7KYocAafNWXR2xChb0r/cKK6psq5DqzMBL9F+JMFbBoDJQ5GIEImYNisIUxjX0HMpoQL+h2nTfOqEp/WLSYmMzsgHJb9rObYIquMF0cVvEzDuOAJswQqWSlwgMtBsRXDjm09Zmphdc54NvtWq4s2cisIBRhC9rukVLCIHJTMYvLR+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRv0zbrHh+DTvCRESbka2nMZF+qBmxLrmAAr4wpNTJA=;
 b=EOHIQCMiaMsb0iCspL9AgfwMgBdn54fySF4Zmb9DHdc7avQ6r6pHUdURLBEnOnAVqUicaexuMZ3QYk2a6dsQErqd5TDH1LaxQfVnMFU6XkV2ix+CWk90dZ4i+UIm6SGcmtj8EZhSkL6yTIs9ujuu261cpte0E4n6kDo7w2INUds=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by CYXPR12MB9444.namprd12.prod.outlook.com (2603:10b6:930:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Tue, 12 Nov
 2024 15:16:44 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%7]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 15:16:44 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "jpoimboe@kernel.org" <jpoimboe@kernel.org>, "amit@kernel.org"
	<amit@kernel.org>, "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, "Kaplan, David"
	<David.Kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Thread-Topic: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Thread-Index: AQHbNFhQwY6CJIvrmU2tNHgQpSE0v7KyeFwAgABS0QCAABWWAIAA4k+A
Date: Tue, 12 Nov 2024 15:16:44 +0000
Message-ID: <073c4e1e2c677f88fd51e64e9b461ce4399b1883.camel@amd.com>
References: <20241111163913.36139-1-amit@kernel.org>
	 <20241111163913.36139-2-amit@kernel.org>
	 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
	 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
	 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
In-Reply-To: <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|CYXPR12MB9444:EE_
x-ms-office365-filtering-correlation-id: 747dfbcf-1395-439e-006b-08dd032d04c3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WHpuS29TQ0hNeGNIZmQ4OWxGWWlGK3B0STVObjRoT0w1WUZweWZiRFFDT2Ra?=
 =?utf-8?B?SHRwVk9TQlhZaEVBYjdNSVRXYk5IMlMrRnQvRWlEOXNFQi9Ublh5U1pCQ1dh?=
 =?utf-8?B?cUs2ZTZKdTk5L3J6NDdrRmpWRWd3bmF1aGlsY0cydGE1ZXJ2dCtCUHRvL20w?=
 =?utf-8?B?Y05DdDZnNWZPTktBYVVDZ3F2cVVXbjcranVoeWZ3bmNmYjBJT1ZJWGVoQnJv?=
 =?utf-8?B?cm42N3FmNmlBa3AranRFbXBodFc0SEJsK3RmTGw0blZWVmE2TnJzZ0Y2RjlH?=
 =?utf-8?B?SUViaTBzbm1TNEJlV3lkVU15bThCUEVCcFpsakJDYURjUVJESnBCaTl2Z3lm?=
 =?utf-8?B?bUhhb0FSYWlRQlVIQlBmWU1CYzNwcTdTVEdobjBFRzNMb2RESktKMkY0bnk2?=
 =?utf-8?B?LzdiZkhnNUVyL2EzTU5xUmtBRXpvYStYZytaNHFYcWhMaW5xT084SFJnS3B4?=
 =?utf-8?B?dEZqUWYxbEpBTVNCTlBCcEo5eXQzanRiOTZKRkdHeDlWR0E4OS80dllwU2Jv?=
 =?utf-8?B?L2FCdmwxajNUbkF4RVZJSWlPYzFMNDdEYTJ5WWZVN0xtK3ZVY2dzeDNXT2Jt?=
 =?utf-8?B?SW5Pb0phUmEzSFpxT3Fja1pWNGN5MTBDM1RqWC9nNjFUQVY2Yko3R2EwVUlR?=
 =?utf-8?B?YUNCZzFJNFVhVHJjUW90SEZqU2NqVFJNek14eGE2TWFnT1hJUCtLeGh0SStM?=
 =?utf-8?B?NTFBdDJmRDM4cmhvNTd1L0xmUGNHZmV1ZEwrYk9TR0NTeVhBT1dkUzllODV2?=
 =?utf-8?B?ejdLTTdqQ1pzUDBTREZ0SDU4bXYweEh1UGhNMERSSzZaYWZyMnhSdXV0NnB3?=
 =?utf-8?B?cWlmLzA2NytWOUIwMHdabVhlRnZXdVlKckxHNGQyTFdCdnBnUUxTeGs1Qm9y?=
 =?utf-8?B?RTVWVGhPQkJsTXRYQ2ZFK1dualhlNG8rTVcxM2NweC9WMCtFTHducTQ0Q0Mw?=
 =?utf-8?B?TmRyN2FLMHNqYTRCdE1RbGVRdGtzMDBDR1RiMDQ3RzVkV1JxNlFESHZzY0VF?=
 =?utf-8?B?YVh2cWU4dlkzdHo4TjlQdzI4bkdIRDNYWEFUY3FjNDVYVnRlSW5acit4OVp3?=
 =?utf-8?B?MXlJZ2JYRGlXMU0rdWhGK01vL1Q5QkdZS3lLTklvZjNFbVNiV2syVmVMS2FY?=
 =?utf-8?B?WVM0MEFBNzFHTGtrc001RXF2UzJwR2NNZDE5N0M4bC9neC85dDViZEhiRFFV?=
 =?utf-8?B?cGZmNHRuZ3dkTWlJNG4wM3g1WTlHQytzS1JLN0lRMHdERGhpTGZHdHhrd1Rv?=
 =?utf-8?B?YkI3TGd2cmo3b2VMWWF1QnhBRlNjUENvdkIyMXJ5am1Yb1BEK1F0ODdlYzdt?=
 =?utf-8?B?UmtXazBucE8vR0VwTmFJcnNwMjhBNkxwbVhJaUpRb0dBelhjTENmT2Z2cjl4?=
 =?utf-8?B?eExoVzlJVzhyekliQ0FGMTZWYm1JYjY2RlBhUHlUNzczcjNLeWNOZTlEekcy?=
 =?utf-8?B?TG8zdW45bXplL0xMbkViUUN2NU1DSk9tS0hyNTNrQ1RtMVpoeHp5WnVQbkwz?=
 =?utf-8?B?VVA1R2E3K2V0Ly81Y1pXS1JwS1B1QXJwVHhONXFlZVFkZHdxR3hSbm5MREJq?=
 =?utf-8?B?L016SFZYR1kycm4zRzlwakdRTXdWVlBMMFZpRVJ2RERRVXpCRWV3MDlCYWhG?=
 =?utf-8?B?M2tSWFo5QnZ6QU5SRlF0MWt3QUwzYnVoMkp6M0ZvV0FHdFVDR0hVOGlNVWFp?=
 =?utf-8?B?bHJiNUs3TXQ0cHZCblZnRnpXWmFiVjI2V01pTlRiYkhVSnZQQTk2MGdvRmxL?=
 =?utf-8?B?cldnODlNTkE4WXBRZFBtdVlZSFNYMjRQZzU3U0MwcmIyam0zeHBSdmhDSDlu?=
 =?utf-8?Q?LvjW8n/G0Ovpcy/V1l5BXu2V8TkTk8fXI8XbI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SW9JdEFaZlMxdWJ5Rmorcld4ZnFEaFFwVksweDEvKzlNMUJpRjQrbkRxTVdn?=
 =?utf-8?B?YnIvaXprdFVxT1M5eXNyTnVOUGIzejBDaHR2ZXBWM0ovS1M1RS9wZnNzNXpa?=
 =?utf-8?B?QlRlVnc3Q2NValhLdXU2MzJyU09RSm1YZnNEVnZLU25UZm5vYytrdjZDZkFU?=
 =?utf-8?B?eDB3R005Ny9GUHVncFlZRENIMC9UV2NVdmdIeUYrNExvdForS1dYTUo5Y2tF?=
 =?utf-8?B?ZXRjcU1vN3phWHlNYVRXK1RveTkxM0c2S0JDVHdNR2p0aVZVU0UwODN5YjFl?=
 =?utf-8?B?UWdmN2ZwNjlYTU9IblpDWStkWS84Rmt5YXpiZ2tNT2RMTXpCVGdwd0I3M0d6?=
 =?utf-8?B?SitqdS9sNk5UUDJoS2VtalRUZWJvV2pYV2xOQ3ROSk9TOWptOUFsTm5LR2tr?=
 =?utf-8?B?WEdoNzQwSWNWZmIyM1R4akFjaGlZZnU1WDkza2E3YlZ1Z2V4K0QzbVlFeFRn?=
 =?utf-8?B?SG9rcDhGK2dSWU1xWk4yS2RvWERGVExIT3R5NXpsNHRMVDVmanJWZDhLQkI0?=
 =?utf-8?B?V2dFT2FCYjdHUTdqTHd1cHI2U1ZkVjV5N3dXeDRTZDRoaTE5QWVrZTNJMDVl?=
 =?utf-8?B?Wnk2eUJDMXNTV0s4SzBweGFub05nMDZtamJmTVVqWm5CWGNNbG83MjRyUnJj?=
 =?utf-8?B?SVhoY2t3S2ZnQ1IvT0x2QWFKM3BHWWJndFZqYjBMTjM1Q1dxQUJaaFZTQTh5?=
 =?utf-8?B?TDJSWWxMc1hDT2RqRmRpYnBNUWN4NHRCZmlTYnV5ODNiRG5MaUM3dklvVEZr?=
 =?utf-8?B?Z0JDN0VQWDZJM2VIcTBTOStVSjc5cDRzbE44aDZENDMyaXhNLy9XQVJIR1lo?=
 =?utf-8?B?U1V3Y2hiMEpwNmxsbklZWktyUThFYnhjUENCVDVqWVhDL2hPTHNwRStOV1Y5?=
 =?utf-8?B?bHkxUE93a1phSEpsV3djYUNEK29SU2M2eCtWQXg5MHQ3cm82RVhHdUxRcnBl?=
 =?utf-8?B?dzl6ejdKY2tjNDd0WC9DdThYb05NRUFhQjViaVR6d0FjK283YVhUTCsrR2VR?=
 =?utf-8?B?OC9nOUdnRlhLRU5UYU15MjJBRlVhWkJ4TVNLMEF6enBMcW85Sjd4bXFjenVj?=
 =?utf-8?B?YTZvTDU2N1dqb2w1cDd2OFNvY2dSeEUzaVI1OE9iak00aTNYN3hHaXU1cjVT?=
 =?utf-8?B?Z1ZSSjdHMVdyTm9kNlZSS0tKaUw5eW9ETTBqeDlqRzJkRU9hUXVZWmRva1Np?=
 =?utf-8?B?NVNZdGtXUGtETDJXclZQZFBpNmZBNEp2bnJHZDhsUERNVE16TUlGSVBGZ2RG?=
 =?utf-8?B?SkJOSHJGNWp0MUg2RGhUVGt6b1JxS052Z3FrUWU2R0loY3FJOXgvUTRIcG1s?=
 =?utf-8?B?RTRIVU52TWZYTEkvbkFGREpQbVo4ODF1SVl1UFhiTlFSUnRmSG5ZdXp2dHZL?=
 =?utf-8?B?V3lsL2RzRTQycEVoeDRJbytKWlhJVXJmcmVNNHRDREE0R0RCNEN1NzRVbUtQ?=
 =?utf-8?B?Vk9qL21iUU5UK2ZnZHdxL1NDdHFqVXNZOWtzK3ZSVXRScllURFdsRitHZkR5?=
 =?utf-8?B?RklyNWlQa015UUt6WmFKSGRqMnRobVdzRGRzUjF2N1dvWHR4emQzTlB3VVow?=
 =?utf-8?B?Ni9ISi9xNHp3NzRnWkxHZm9zMEsweWx4YVZPbHBZUEUwMEZMZE1jVkxISHd0?=
 =?utf-8?B?VUpMSHcrS1ZyR094ZXVHRjVRUy9rMUFQYzlMMk9yb0JyWHNYZkpLajlreGxw?=
 =?utf-8?B?ZVlzdmNLWFdhMFN1THhhUXFSQzVueDBXM0dhY2pLc2t6dmxYYU95R0pSdUlJ?=
 =?utf-8?B?OUx2SkppWXluVmUxenhxZ1Q5dUl1TjVpS2RxZmo2VFdFUGU1OG0rSCs5S3h5?=
 =?utf-8?B?Z2UwcXEvcHhHczlzOWFUY1hZb1h1MUdPeEtNdjE0cEt6a2JuWWNVbVJ3Q25h?=
 =?utf-8?B?NHhHd1ROa0hwdTljcVFFR1o3RTl4VVI5MmU1QThuSXhTMGh6dzNMRm1vdzdM?=
 =?utf-8?B?WGZKK05UbTVMbjRsQnVVUWZvRE01alBJN1NjZUVGMXhJL1puZ0RUQnhiYVo1?=
 =?utf-8?B?d3BGUGRSRGdhejB6Y2pCcEdGRU9qMEMwK3hlOEdqaHNSOUhvL3IzVHMycXdW?=
 =?utf-8?B?NWhpZldaZnRDemN0ckZjRDZCY2xFdmc3RXJpUTNBcmdpV2RsbjF0aEtiVGxp?=
 =?utf-8?Q?/dQ+Z7V5ptrg2CKJacWC4gFt3?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <79CE668625DDCA4FA00F1D02BA457794@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6945.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 747dfbcf-1395-439e-006b-08dd032d04c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2024 15:16:44.4719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k7Aw8wUNbe5c6TiGnJxwCggPfvKEt7Aq8FqLTIq/Cjo1upWhbrITwGhSqFyvOspW2SH+Q/00lRn0eSntq48Pmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9444

T24gTW9uLCAyMDI0LTExLTExIGF0IDE3OjQ2IC0wODAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gT24gVHVlLCBOb3YgMTIsIDIwMjQgYXQgMTI6Mjk6MjhBTSArMDAwMCwgQW5kcmV3IENvb3Bl
ciB3cm90ZToNCj4gPiBUaGlzIGlzIG15IHRha2UuwqAgT24gQU1EIENQVXMsIHRoZXJlIGFyZSB0
d28gdW5yZWxhdGVkIGlzc3VlcyB0bw0KPiA+IHRha2UNCj4gPiBpbnRvIGFjY291bnQ6DQo+ID4g
DQo+ID4gMSkgU1JTTw0KPiA+IA0KPiA+IEFmZmVjdHMgYW55dGhpbmcgd2hpY2ggZG9lc24ndCBl
bnVtZXJhdGUgU1JTT19OTywgd2hpY2ggaXMgYWxsDQo+ID4gcGFydHMgdG8NCj4gPiBkYXRlIGlu
Y2x1ZGluZyBaZW41Lg0KPiA+IA0KPiA+IFNSU08gZW5kcyB1cCBvdmVyZmxvd2luZyB0aGUgUkFT
IHdpdGggYXJiaXRyYXJ5IEJUQiB0YXJnZXRzLCBzdWNoDQo+ID4gdGhhdCBhDQo+ID4gc3Vic2Vx
dWVudCBnZW51aW5lIFJFVCBmb2xsb3dzIGEgcHJlZGljdGlvbiB3aGljaCBuZXZlciBjYW1lIGZy
b20gYQ0KPiA+IHJlYWwNCj4gPiBDQUxMIGluc3RydWN0aW9uLg0KPiA+IA0KPiA+IE1pdGlnYXRp
b25zIGZvciBTUlNPIGFyZSBlaXRoZXIgc2FmZS1yZXQsIG9yIElCUEItb24tZW50cnkuwqAgUGFy
dHMNCj4gPiB3aXRob3V0IElCUEJfUkVUIHVzaW5nIElCUEItb24tZW50cnkgbmVlZCB0byBtYW51
YWxseSBmbHVzaCB0aGUNCj4gPiBSQVMuDQo+ID4gDQo+ID4gSW1wb3J0YW50bHksIFNNRVAgZG9l
cyBub3QgcHJvdGVjdGlvbiB5b3UgYWdhaW5zdCBTUlNPIGFjcm9zcyB0aGUNCj4gPiB1c2VyLT5r
ZXJuZWwgYm91bmRhcnksIGJlY2F1c2UgdGhlIGJhZCBSQVMgZW50cmllcyBhcmUgYXJiaXRyYXJ5
LsKgDQo+ID4gTmV3DQo+ID4gaW4gWmVuNSBpcyB0aGUgU1JTT19VL1NfTk8gYml0IHdoaWNoIHNh
eXMgdGhpcyBjYXNlIGNhbid0IG9jY3VyIGFueQ0KPiA+IG1vcmUuwqAgU28gb24gWmVuNSwgeW91
IGNhbiBpbiBwcmluY2lwbGUgZ2V0IGF3YXkgd2l0aG91dCBhIFJBUw0KPiA+IGZsdXNoIG9uDQo+
ID4gZW50cnkuDQo+IA0KPiBVcGRhdGVkIHRvIG1lbnRpb24gU1JTTzoNCj4gDQo+IAkvKg0KPiAJ
ICogSW4gZ2VuZXJhbCB0aGVyZSBhcmUgdHdvIHR5cGVzIG9mIFJTQiBhdHRhY2tzOg0KPiAJICoN
Cj4gCSAqIDEpIFJTQiB1bmRlcmZsb3cgKCJJbnRlbCBSZXRibGVlZCIpDQo+IAkgKg0KPiAJICrC
oMKgwqAgU29tZSBJbnRlbCBwYXJ0cyBoYXZlICJib3R0b21sZXNzIFJTQiIuwqAgV2hlbiB0aGUg
UlNCDQo+IGlzIGVtcHR5LA0KPiAJICrCoMKgwqAgc3BlY3VsYXRlZCByZXR1cm4gdGFyZ2V0cyBt
YXkgY29tZSBmcm9tIHRoZSBicmFuY2gNCj4gcHJlZGljdG9yLA0KPiAJICrCoMKgwqAgd2hpY2gg
Y291bGQgaGF2ZSBhIHVzZXItcG9pc29uZWQgQlRCIG9yIEJIQiBlbnRyeS4NCj4gCSAqDQo+IAkg
KsKgwqDCoCBXaGVuIElCUlMgb3IgZUlCUlMgaXMgZW5hYmxlZCwgdGhlICJ1c2VyIC0+IGtlcm5l
bCINCj4gYXR0YWNrIGlzDQo+IAkgKsKgwqDCoCBtaXRpZ2F0ZWQgYnkgdGhlIElCUlMgYnJhbmNo
IHByZWRpY3Rpb24gaXNvbGF0aW9uDQo+IHByb3BlcnRpZXMsIHNvDQo+IAkgKsKgwqDCoCB0aGUg
UlNCIGJ1ZmZlciBmaWxsaW5nIHdvdWxkbid0IGJlIG5lY2Vzc2FyeSB0bw0KPiBwcm90ZWN0IGFn
YWluc3QNCj4gCSAqwqDCoMKgIHRoaXMgdHlwZSBvZiBhdHRhY2suDQo+IAkgKg0KPiAJICrCoMKg
wqAgVGhlICJ1c2VyIC0+IHVzZXIiIGF0dGFjayBpcyBtaXRpZ2F0ZWQgYnkgUlNCIGZpbGxpbmcN
Cj4gb24gY29udGV4dA0KPiAJICrCoMKgwqAgc3dpdGNoLg0KPiAJICoNCj4gCSAqwqDCoMKgIFRo
ZSAiZ3Vlc3QgLT4gaG9zdCIgYXR0YWNrIGlzIG1pdGlnYXRlZCBieSBJQlJTIG9yDQo+IGVJQlJT
Lg0KPiAJICoNCj4gCSAqIDIpIFBvaXNvbmVkIFJTQiBlbnRyeQ0KPiAJICoNCj4gCSAqwqDCoMKg
IElmIHRoZSAnbmV4dCcgaW4ta2VybmVsIHJldHVybiBzdGFjayBpcyBzaG9ydGVyIHRoYW4NCj4g
J3ByZXYnLA0KPiAJICrCoMKgwqAgJ25leHQnIGNvdWxkIGJlIHRyaWNrZWQgaW50byBzcGVjdWxh
dGluZyB3aXRoIGEgdXNlci0NCj4gcG9pc29uZWQgUlNCDQo+IAkgKsKgwqDCoCBlbnRyeS7CoCBQ
b2lzb25lZCBSU0IgZW50cmllcyBjYW4gYWxzbyBiZSBjcmVhdGVkIGJ5DQo+IEJyYW5jaCBUeXBl
DQo+IAkgKsKgwqDCoCBDb25mdXNpb24gKCJBTUQgcmV0YmxlZWQiKSBvciBTUlNPLg0KPiAJICoN
Cj4gCSAqwqDCoMKgIFRoZSAidXNlciAtPiBrZXJuZWwiIGF0dGFjayBpcyBtaXRpZ2F0ZWQgYnkg
U01FUCBhbmQNCj4gZUlCUlMuwqAgQU1EDQo+IAkgKsKgwqDCoCB3aXRob3V0IFNSU09fTk8gYWxz
byBuZWVkcyB0aGUgU1JTTyBtaXRpZ2F0aW9uLg0KPiAJICoNCj4gCSAqwqDCoMKgIFRoZSAidXNl
ciAtPiB1c2VyIiBhdHRhY2ssIGFsc28ga25vd24gYXMgU3BlY3RyZUJIQiwNCj4gcmVxdWlyZXMg
UlNCDQo+IAkgKsKgwqDCoCBjbGVhcmluZy4NCj4gCSAqDQo+IAkgKsKgwqDCoCBUaGUgImd1ZXN0
IC0+IGhvc3QiIGF0dGFjayBpcyBtaXRpZ2F0ZWQgYnkgZWl0aGVyDQo+IGVJQlJTIChub3QNCj4g
CSAqwqDCoMKgIElCUlMhKSBvciBSU0IgY2xlYXJpbmcgb24gdm1leGl0LsKgIE5vdGUgdGhhdCBl
SUJSUw0KPiAJICrCoMKgwqAgaW1wbGVtZW50YXRpb25zIHdpdGggWDg2X0JVR19FSUJSU19QQlJT
QiBzdGlsbCBuZWVkDQo+ICJsaXRlIiBSU0INCj4gCSAqwqDCoMKgIGNsZWFyaW5nIHdoaWNoIHJl
dGlyZXMgYSBzaW5nbGUgQ0FMTCBiZWZvcmUgdGhlIGZpcnN0DQo+IFJFVC4NCj4gCSAqLw0KDQpU
aGFua3MsIEpvc2ggYW5kIEFuZHJldy4gIFRoaXMgcmVhZHMgd2VsbCB0byBtZS4gIEluIHRoZSBj
b250ZXh0IG9mDQpFUkFQUywgSSdsbCBlbmQgdXAgYWRkaW5nIGEgY291cGxlIG1vcmUgc2VudGVu
Y2VzIHRoZXJlIGFzIHdlbGwuDQoNCgkJQW1pdA0K

