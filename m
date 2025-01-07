Return-Path: <kvm+bounces-34703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B70E9A049A4
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 19:53:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94CF67A0F6F
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 18:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B681F4276;
	Tue,  7 Jan 2025 18:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZNyCiv5v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764641F190E;
	Tue,  7 Jan 2025 18:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736276018; cv=fail; b=OEwDDCr5vYsmOlWVWUl4iwkSzxoaaPuIpgZEg0MUiPr0QRkFVlB/FXdakzzECiq0pY7xhtFFSPlmUjYk58aBrdXhBvp99RezfkM4KaAd1GsvHGMSY4R7qWxtgp8dyH+qsv/UMIhsoX9cvrI9aVnj3C8E9wPSBwU9lJPScVnjc78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736276018; c=relaxed/simple;
	bh=dSeWIpJfRX5jKe714uxUMgDj/APdsbwUFM3jxVWq52o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Zxytx2N2V+pktPXiFZlfDasTOEa+WIav1EpTzQPqIaNHV7YopjzLIFOZq5gg1ucYobY+vbP2Mn2fOuZ4XRbaEAG+5Qk2DUfAlheTEK9tMU7FK0BRg8xFeIvM6+ipksdPQI9VNOut83tN0ODwmNHTfl3Fc0sMWT2bhkBsPzaN6B4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZNyCiv5v; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NV7VsaXzQ7+i1/CQDwZlIaWcAa0TBow0po2PmTLVOw0jzVDNILPtMg5Yh+PTD11Z9Ux5Ah5SZBTEiOjmedfFakms9BmfTmbXL0vo3VgBl9HGo4w+sWSCRYOQzfdva+C8yp8njbA9wUrtRq8AohN1NswYxhtAhrgUlyPGxg4SNHrDzmH7/MujfCMQP5dK5/lBTTiQr624dq7Q3eg23si56XrvDo7fR+NQTaI2CCiwClntkacqYozZxDdb1QTqLVnh5o5fSASYTVs4IHBD746k3TwB9N3FbL/fr+gZM3vhCLCRBa01/JBGU0FWdrQ7F1g57yXvTCEuQAJVkHGOJ5ep8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vpKu/wvKWleLdwYLPOQcw77//bYHls232UDvLJPXso=;
 b=F2W0MDm9t5o+WoCt8W8Qp6uO4A2q3+oNV3H3JMuFkuAtJTItyULe1xZnG5EHY0+zAdpG9J91Ur9t02ao67WoZz+3y1M3kxy8CjoHhbEk0BozR8wR3Rc3TECbhkjv98OaK4XBU709WHb1bIXvvFIMGWIz71rOu1zkAHVxuvL5DKxEq78dOS48PFBDTVKIP307hX8/CNySAItLF50k5R5SbCUWxQuRoKCn4OzosaoqTFw9qbbDaXAF+5/6p+osRYsFzoVuoPfdX8Z5RjZHlzpRPjrtsv6yGauigVFtVJCRZtRDa5xJyQ/tdyV3k3j35leZk93J8WQ3RcyaKzKPYf4ywQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vpKu/wvKWleLdwYLPOQcw77//bYHls232UDvLJPXso=;
 b=ZNyCiv5vt/sv8jFEtDYoQvstwbtEfWwq88EATvylS4bkMpwSuffUoUtx0wC5qk7fcwEecR4cUAVi7r9llyjDz/KEy/qw4gm1fKNd1sU41pHSWJEOM7C4kNVZxBL7MBr8gqyBsV7Hc9XSynu928UFM4Z0+VvaN3uV5yXFX4ct68c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY1PR12MB8448.namprd12.prod.outlook.com (2603:10b6:a03:534::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 18:53:28 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 18:53:28 +0000
Message-ID: <32359d64-357b-2104-59e8-4d3339a2197c@amd.com>
Date: Tue, 7 Jan 2025 12:53:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v16 05/13] x86/sev: Add Secure TSC support for SNP guests
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com,
 francescolavra.fl@gmail.com
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-6-nikunj@amd.com>
 <20250107104227.GEZ30FE1kUWP2ArRkD@fat_crate.local>
 <465c5636-d535-453b-b1ea-4610a0227715@amd.com>
 <20250107123711.GEZ30f9_OzOcJSF10o@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250107123711.GEZ30f9_OzOcJSF10o@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0227.namprd04.prod.outlook.com
 (2603:10b6:806:127::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY1PR12MB8448:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e92bf36-1713-4004-972f-08dd2f4c92b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eDlzZ1l6ZXFQZ0ZPWmtGc2ozWnh5czhLMG5RczduTXl1cmgybk1lSnNscWlq?=
 =?utf-8?B?WkhycVdXNGZ6TUEwU0hEYXJaY1RGTnBMUFhNTlQxVStkSzFLbURjRHRaL1Bs?=
 =?utf-8?B?MXlxNS92RmtGUXZGOXV4a09SeUg4SkZnZEFZUGRNYkIvRERMMHBPYXRRaHFE?=
 =?utf-8?B?NlRxT1U0aVdQam9JdnZVMG1wclltNHZ4TGRsOFM1NWNTZThsQlMzZ2Z4OUtQ?=
 =?utf-8?B?ZnNSRVlGd2NsUnpReFEyQjIwdHNQQzlaR0RJV0UxU29EeFZxelVVVmY1TE4w?=
 =?utf-8?B?MkZTQkw2aWxVOCtzdzdSMHZRVlNhS2IzSW40MGg2c21XRnBkZzJQTVJVYW1p?=
 =?utf-8?B?cHRZQnNSTkJsK0NjWDA3cDJKcWNKeXRDVWNVcG8zZlJEczBoYkQ2cElFQXND?=
 =?utf-8?B?N2dlOStiWVJzNWtlMys2VWx5WExXWDJEdWN2elYvRUE0OXFwRy81K2RFeEY0?=
 =?utf-8?B?a2xsUHl4a1FGMGVZSEV2MVVVUEFnR01qMUVhNVBzT1BueUZubklDbnRqdDNS?=
 =?utf-8?B?TDBvY0YvZG1iYXgvYlAxdXp4VVJSZkhkWVJURU5janhWSUZQMlNrN1VuT2Zx?=
 =?utf-8?B?UlZ2WThYTEZjZmRDd2xXcnJJS09aRGdOQnFROEZlM3Zqc2ZKODdMTUl1Y3ZR?=
 =?utf-8?B?Wld5YmNvZDFTRHJiSS9YcVdpS2o1T05STnZZNVpsSVhubVVENlEyRGtPWUox?=
 =?utf-8?B?b0lpQzhmN055TlNDZWtYK2VjUzZwUUtYUzUrVWlSSFJKdEM2dUxzVFFMMHUy?=
 =?utf-8?B?ck1VUVBmRG5BaGlYbEc5YlE1VDNaVVRiY1BTQjdkVzJKS2MyL211TkpGSWha?=
 =?utf-8?B?US91ZUtQRkJEaVkwb0h2Z09KQ3ZaVjNtcnJmdk1GYWFzeEIyTnRtUENaQmxG?=
 =?utf-8?B?Ynp3Y3ZWazFhVkNHZHZHQUdveHp5ZEpSeTYyWm96bWFRSWR1WUJWV3RnNHpM?=
 =?utf-8?B?b3h5RjZJcXRlWE9Oc0M1anQyd1VrUkYvelJRZmVYNUhmVmJZL3FrSzNRUUVy?=
 =?utf-8?B?TnhZendMdGRJSEVHeE56ek1DWXJrUzBLWTlnQ0dGZTBUblJ0emF6QW1YeE0z?=
 =?utf-8?B?ZEtRRWRYMW5DNTZsK21JTWdKcnMrYVJwbTVQM21lYUUxSndsVVFIOEdhMlRz?=
 =?utf-8?B?NUJoZkRHMnkxcnlWM1JqRVZoRHNIODRFUVRqOVJxYnBQMGJielFYTGQ1TXl1?=
 =?utf-8?B?VGFuWXNkajBVYnlDK2V0ZkdwWS9xWDRxTGxOcTBWWFRlQ2RwUzQ5V3BLLzkz?=
 =?utf-8?B?M1hzNzNMRzNzaU5yQmNadTR5ZWtkN1czbnRCL2F5NVNpZzRJa09uRVhadlox?=
 =?utf-8?B?MEpGT1JwSy9sL2R4TFgydzFnaGZHNlFYWjRMeUxCSVd3ejNINkprWXZvSG9G?=
 =?utf-8?B?V1BkNlkyRXdIaTdQckpLbHVpMFB4cm1PREx1VjI3Wmd5RzBlOGZKNTBHaFU0?=
 =?utf-8?B?OW12c2E0YkgySi8vakxER3YvTm45b1g0NWZDOW93RWJBSFovbWNkbXBVZWlO?=
 =?utf-8?B?K2Y4UUYvYm5iYkJyTFlxRXVNaXJTS29McXErd216Y0dHckhNTXRuYWJvaTZN?=
 =?utf-8?B?cFFBa0FCc05OMnlzS2RUZmliSmx6dGtuTXRQcnVLSnZ4Z1BrYTNMeW9GdXhV?=
 =?utf-8?B?LzhtdDNMZkZ5alBsS2QrUnRJSndwZUs3bjQ1MXQrcVI0alRTaDNzTjhKMlcz?=
 =?utf-8?B?ZVRITlNLU0xEVkxNUjBGZXIwT1BpaStPRU44ZGJvZis2QWhHYi9yNVppS3Zn?=
 =?utf-8?B?STBqWDV3UXhXRHk4YllQN0ZyVCtHdytEdWhUeHltUzA4K1NrV3dRVFJ3Z1VC?=
 =?utf-8?B?R1k1S2dOSGVCQms2SXNpb2RYSnhqTFVVWk5lWk1EVnZpME5ZdFQ3SUQwR1B6?=
 =?utf-8?Q?uWij4LPRZGnST?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akhCVDF5MEltY1Q5YTJwLzRrMEgrK3RpcGZxbUxNcjlOQnNXQmVGeTJkSVQ3?=
 =?utf-8?B?aktuUGNYeTRndUlWSlY4RmI4RXFQVFBoNm9Qa2dTS2M3djlhSjYxcXpCK1Nv?=
 =?utf-8?B?U3JMSGdObnNTSW5sbFBuby9mbXk2REFsWTBnNXl5R2FFRkNzNzJDbWdIbWt2?=
 =?utf-8?B?R1lMMkJkRzNZM05RcVc2ZTA3UXhPdGcyZS9aVFowN0dCTjNCSU9zNkdDZ0p2?=
 =?utf-8?B?NWJlL05obVJudlhxdUd6V3R4MytTOHFPSjBUYnJlOXYyOWppMk12SDMxdE9G?=
 =?utf-8?B?UmNCQW5OTEc2Z2NXVDdVcjlpSytrbXpsQmwrSG8yekhHN1c2SUcrTWdWZ3h6?=
 =?utf-8?B?WXZRSXRFTllOT2t3OGdJOXhpQURwdXRHcG9wWFg4Qzgxbk4zZ1JOd2JmWW8y?=
 =?utf-8?B?eXFQcGI5S1VwdUgwemtoamp6ZjRZcXNpZU5WR3hzRm00SmlwZlAwV2VSVVFV?=
 =?utf-8?B?K09YV2NJUk9keTNJNDFUZCtQb09ueUpLNVV3YS9jNzFxbkNaMXp5bDd4TVRU?=
 =?utf-8?B?L24wT01QQUJkbnNpWlB1em9MT2gvcHB1ZXJGV2w5Y2VjOGorc3Z5UmpOQ2h5?=
 =?utf-8?B?bTNnZFBIUHlGb2ZOV2F1UDVLaHVJZ1FaQVNERGxwcU52QTBTaUZTOEx2QUdt?=
 =?utf-8?B?dEwvQVFJMmVPOGljcVZ4T2dZb243a2pqalN4aFpsTXRBd0tWc2NHSXhWUVRN?=
 =?utf-8?B?TVFLMGN0d2djb3VmNGlBVU9qYXcwSXh1aG9BaXZLM2gyN1BXTkh1SG5OWTZp?=
 =?utf-8?B?eHdqRnhWVjdLcnVNdnVMc014K2kyWDBWK295TjBBZDVINFNYczNQS2FUK1RB?=
 =?utf-8?B?ckRTSkRZNVJWS1cvTVI1Umt4alduUjFtVkJGUDBIV3RNdmEvOEJUdmtvWFU4?=
 =?utf-8?B?UUdwQjBTT1RpUDl1UFYxbXp0YUlVdGIwS0pQTUZRNmFKcG13WmZIVjQyRHV3?=
 =?utf-8?B?aGJWYjNCRTRQWDhyeHhCNFBnZlR4Mk52ZjhMaUYvMVJKT0ZQSitBSnpqeGtX?=
 =?utf-8?B?TFFrWXQyOHVLTHdUQm1BQmloSytBRFE3YklrNldqeisxekhJOEdmbGVwbE9v?=
 =?utf-8?B?cmJuVVo0Qm1jdmRkOEpjN2VhRE04aFdZWTczU0FtcGYxdGh4NEtXT3NqL1Nz?=
 =?utf-8?B?QmhMZDh3cjRqQXhseDZEMU1oOXdVYXJhVzZqcVUvbGN5WFpVTlpsMERhYWp2?=
 =?utf-8?B?OUhsTnlYaTRSVnh1NHI3SVhWRytCR2ljUEEyT21pakJYL1ZuQjV0dGpQUG9k?=
 =?utf-8?B?NjlOTHJlaGxDOGN5dnl4aTBhSU1uL05DOGZyeXBlanZHWWYxNjFPSGNsNTJE?=
 =?utf-8?B?aXJrOUxJQVIzWWdKYmJmVFlzWmhXTkRHMHkvV2IzQXloa1FLUG5uNy9uVzZa?=
 =?utf-8?B?enRwQ3A0TXVpZDFDSWdSc2NzT0pXTXNkNWxGQU14MkhqalZBRWwzVjY3QW50?=
 =?utf-8?B?NWM4ZUZoWjBaU2d6cHFpN3BGNDhqN3gzanRVV1hQQk5QNnkzWDYyYmVkd1ZF?=
 =?utf-8?B?YXg0R3ZLcXk1ekVSbGpET1lYeWVpRnpaV1Bac0xZanVoSGhCWSsyUEtYdHRq?=
 =?utf-8?B?dmVCcVE0T1V1OTNjZ0JhaFMrUk1qZGVCUjFFdDlwM3NsUEVsYUQyQm9xRG1x?=
 =?utf-8?B?bWRmVURmbnNydGFoYmZrZ2c5MWtjT1c3LzNOZzJGN1FJOVA4N3phQ1FoaHp2?=
 =?utf-8?B?aEVndTNaVVVEMmVmaHdaeFA2Z2xwWVRRRWVhamtaY3VRdDZOWkpEcmVxaHRh?=
 =?utf-8?B?WVFpWWJEbCt3aWJ1QlYrNGxxQnNHR1ovYnRWblNCSmlieXlyZ0YyaUtjZUZC?=
 =?utf-8?B?dXpGRFBjUGR4S2Z3bTdMM1lnUTZVZjdUOFllRk5nVm00Nk1pNExOaXl2SlBz?=
 =?utf-8?B?K2Y3NkxpNVZlVGNscGgvcEx0N2M4c2U1Sk1xa1M0TDZ5cVR2Yk5pMmlBa3pa?=
 =?utf-8?B?Y1hmMW1ZNldSWXA1clpLV3J4cmJmMm1wQzR0SGxHbjZORUJYbmIzQWJwZWVZ?=
 =?utf-8?B?ZHNzUC9QdVpaSUY2UXlOa2hvUXE2cWlJQ1pKcDhmQWpOMHJyR29kT2gvT1VY?=
 =?utf-8?B?Y2ZlU095a1d4VE1NZW9kbFliVzVTc25WS3k4cjdvNDNmaXJBTUF4bW0zZ0ht?=
 =?utf-8?Q?yJv5BNRJEQG6OFwRY/8/gYbmv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e92bf36-1713-4004-972f-08dd2f4c92b3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 18:53:28.3577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YXNNpBspWO5CNXVkjgU1sIww09i39UaroJG4JPW1UyN3MCZ6tFla3Rq4OpXFZ8RN6NRO0m8OLIfMrtoLxqDS7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR12MB8448

On 1/7/25 06:37, Borislav Petkov wrote:
> On Tue, Jan 07, 2025 at 05:13:03PM +0530, Nikunj A. Dadhania wrote:
>>>> +	case CC_ATTR_GUEST_SNP_SECURE_TSC:
>>>> +		return (sev_status & MSR_AMD64_SEV_SNP_ENABLED) &&
>>>
>>> This is new here?
>>
>> Yes, this was suggested by Tom here [1]
> 
> Either of you care to explain why this is needed?
> 
>>>> +			(sev_status & MSR_AMD64_SNP_SECURE_TSC);
> 
> I would strongly assume that whatever sets MSR_AMD64_SNP_SECURE_TSC will have
> checked/set MSR_AMD64_SEV_SNP_ENABLED already.

Yes, but from a readability point of view this makes it perfectly clear
that Secure TSC is only for SNP guests.

It's not on a fast path, so I don't think it hurts anything by having
the extra check. But if you prefer the previous check, I'm ok with that.

Thanks,
Tom

> 

