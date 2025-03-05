Return-Path: <kvm+bounces-40184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6009DA50E6D
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 23:18:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E2AA188CBA4
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 22:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F1E26658C;
	Wed,  5 Mar 2025 22:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VjhQAOpj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E661C1FF61B;
	Wed,  5 Mar 2025 22:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741213067; cv=fail; b=FDtTasiuZqfwbXxs3axN2vzE0yDlCICZLHAbO0JFSl9XBAGG0QBnCFqlihpsGRi77q1RUIaLuN7VrZeyvgV569mh57lbItdMkaTYs451VOGO2U/wSvPhEDgo0inJWynwHD0b5yW5y1TsXuLagCnijP/yGSRRreiUH8Wy6OYABwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741213067; c=relaxed/simple;
	bh=4APFVzlGEAFAq/TCJehrc8iz3brWh//LIiV++bXYy/o=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rXrW3egvzP3AqKJ4ad/Kzb933nH+nHxneO3opCRb2hyGmfMXlG7Uli32njZBAA6HfnCyutPjTgWpynZageepuflpEIC+vPk43qdWGC9jkXd2k2o0nLOhGHslwG1gHyOyVuhKhkPNsadleTObJ3EECzPumR/4T/Ch81LypnyG56w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VjhQAOpj; arc=fail smtp.client-ip=40.107.244.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kgM1rQNHwian3pbAV+PCRD1vPn5CPfi4WOa0j4oMmUQxymBOVqi+9Xyr2SwMXb39mLYdwE5Pix4tTDF9A0iLwNH7327oRMwwVO2fCj8XUM/EbcCLuPBSSmgi8gZUXL2md+MKyNVsAm1IdYR2ln6ZV/gkqH3loClHRkfwAQgcqIkUIjvGrUulQ2/EW+Cz/wv7XG04llDboeyZXtAkSEXgRAd/m5YclLIWyt7KDtTBX/ZpIjWdj16+xxv0LYAbbYYqUhelUW2mkSeTuZOh4c6dA9nxIbaHxe+ZV1DEwxB5+Ri/vIy2oJvskAUtTITHTrtJBzXfD6DkDZ8x+cPi+O+KAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QoOjp5abgQr/OroP8QQEgN1WbEH8edCHZRrthl25aMU=;
 b=CP9tLnWZDELCOGH3Kn3ek/hLk9HXKoiLJSZDUKYLz6urN6gP6ckChxPiRAMRVxEwopdsLb3rSY84bIhtDBvAvO1fR2Qryd0OpT3eGYikdTGRrYHB2R4uZ7yzP57AgCE1Jud55CWhBClh6OLU7itCcg6CHDS2FYkAOsr5rUq7pBzAUydvVTEufSF64PeRDFwLw/+jxDsi556mnv0c228HMc/yC+ABE0xGpDbg09zWU8f8Rzyc9utInuboUTHnMN5E9t7a3nU1iLyK7KHK4Gd5t8yHv/3/T5nr6IJNf7r7EwKGz2wyZJozjMGeeOQaZCQc6O1l2R5j6+Ctb+6Y+dCXkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QoOjp5abgQr/OroP8QQEgN1WbEH8edCHZRrthl25aMU=;
 b=VjhQAOpjIEALytJYXdIZbs2ZHdmFPUwCEmdNpZA27qhI9xuGl8VnICIHRfCfeaD2xohwxMGdG7VIk9cmdp7GmGZUuATMDqFY0Q6e//4kHfRCsFrYdpP4TU0e9b0g7Vr/0KmxfsbP4D9ezoO7qDllgPyXMLRq1BY36JzX4OPX3C0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA0PR12MB7652.namprd12.prod.outlook.com (2603:10b6:208:434::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Wed, 5 Mar
 2025 22:17:42 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 22:17:42 +0000
Message-ID: <8d3771fc-b486-4655-a9a1-30a8f1134d1e@amd.com>
Date: Wed, 5 Mar 2025 16:17:38 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 Peter Gonda <pgonda@google.com>
References: <cover.1740512583.git.ashish.kalra@amd.com>
 <27a491ee16015824b416e72921b02a02c27433f7.1740512583.git.ashish.kalra@amd.com>
 <Z8IBHuSc3apsxePN@google.com> <cf34c479-c741-4173-8a94-b2e69e89810b@amd.com>
 <Z8I5cwDFFQZ-_wqI@google.com> <8dc83535-a594-4447-a112-22b25aea26f9@amd.com>
 <Z8YV64JanLqzo-DS@google.com> <217bc786-4c81-4a7a-9c66-71f971c2e8fd@amd.com>
 <Z8d3lDKfN1ffZbt5@google.com> <a0feef4a-1e12-445c-8a17-0f2ecc4d7c85@amd.com>
Content-Language: en-US
In-Reply-To: <a0feef4a-1e12-445c-8a17-0f2ecc4d7c85@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0065.namprd04.prod.outlook.com
 (2603:10b6:806:121::10) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA0PR12MB7652:EE_
X-MS-Office365-Filtering-Correlation-Id: f098a91c-7d9e-4b04-6c87-08dd5c338c3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3oyR3dPQ2RNdFVRM1VqNFFvNkJ0eUxXQlRJL1FaeFNpT2ErdkhWTlNsd29X?=
 =?utf-8?B?UTZCWXdna1g2eG5XU0wwR1RNRHNTQUFvZVl0WFpFRXhiYWozZDNxZlE5d2VR?=
 =?utf-8?B?THkybWRMc2pMZVlJMUpHb1pIQkloYjdBQm4xRnpEMkpkcll2czRtYlJiRW40?=
 =?utf-8?B?K3lnNEZqSnhWaDkrNjJja2F4WUt5UDJoQjB0ZUI5SkNwOTN1UXJVN0dEQjVl?=
 =?utf-8?B?bk11VVpuOXE5ak1DMk9UeENWbk82UWVrZWpkNnZGS0tMM0VnVzFaTjdWTCtS?=
 =?utf-8?B?dUhETmExb3Z5bytUSjhNN05xajRGSFJIV2NLbTVGMVRDUVhFbDJ5Mmx5bVcx?=
 =?utf-8?B?WHhpWGVGTm9ZRVNpK3oxVWJDTUJPZDVJSkRwaEgwYUFGYlF2Qyt0TVNTWlBh?=
 =?utf-8?B?VHdiTXlIcmxSSlpXUHFmaTRvUVJINUlPemV4Y0hsZEtscWUvRE1NeGVTdk5z?=
 =?utf-8?B?QXZxNzNBQzdHaXRRdUxoY3BwSUFGTGFjeklHak1ZT01hOEo1MGc5UmpFemdm?=
 =?utf-8?B?dHVzMXlCV2o2VnVvcUNSQ0Z0c21aUXdCV2xDNEdidDY1OFNxWmh3a1dobjVW?=
 =?utf-8?B?LzRiVk02ZVBna1lUMnp5RkxaeGd2WlRIdFlLZS9ROFVDTVpCMGV0QWFBOVJZ?=
 =?utf-8?B?WEpjeGtWaGFnMXVxWWpKWnZmOFNPL01mTCtFcjVrS3dzTTJKQTQ5QXhZVXRw?=
 =?utf-8?B?NXU2NFRRRzg2aUwzcUg5WGd6SEFORFEvZkU5dStGVW51SjZYVHh3U09PM3FF?=
 =?utf-8?B?TmprZGlLQU95aHNhRVpWOXdGSVhlNUgycE4wU1FTOGJ5eXNjeWd1cFVKWEJO?=
 =?utf-8?B?d0ptRS9Dc0E0S3p3eW5OazBRUVFsdGR3ZXRHV2hTMWVBZ3hVQmswUnNXV2s0?=
 =?utf-8?B?WFR3ekdXT1FkZ3M0MXo3Yi9haTNpSzlCUnJqV2xNcTNJcWdSbzNiaFQ5NC8x?=
 =?utf-8?B?cWE3SmhXMi9ZNHhmMDM1OVV1OVdCRzhOeUVGM2lSSG5kcmEzWDRqOUVQYXJS?=
 =?utf-8?B?TWE3NDNOR0llNm0wZExQYnM4VklVVXNUNDZOMzRKRGFaQmp2K29CVTNVT3px?=
 =?utf-8?B?MXp3dkNFc0RqMVVxL3JsY1NGQ2FBMHhSelFndVJrNXNDNlk4TVcwM1Y0QWJV?=
 =?utf-8?B?a2ZTelpMTzJNQ3VnSitwU0dtTk5zUzVweTd6T2R6bmQwellGNXE4dDlNcGlk?=
 =?utf-8?B?NDZDSUhlMHRxcDh2SXVUVU9wbGRCTnpLVWgya05McXhWZ0x2OUYyc1Y5ZG4w?=
 =?utf-8?B?L3ZHLzAwalBXTmg2KytOYlRuNHhnY2xJbFV6RjQ5c24vaDhuK00vWUZrbXFX?=
 =?utf-8?B?QzM1Nlc0UXVmWk9CWEdYZFR5QUQwb05IU01IZ0dPWDUxTkYwd1JzRUZvekFE?=
 =?utf-8?B?dEE3eDNwR1k4Wk5zOXBkK2x6bkNmN1dUdE9YNTdIbXFyeHlIdEJxNWJIMCts?=
 =?utf-8?B?MnNxM0tWTVUySGo4eWJBWVoyVVFObENzaThYbWxXb0QyL05hUU5XaVVjdld4?=
 =?utf-8?B?a3lRSTd5VkpFd2l1R0hzemJ6ZnlVc3FJaVdiT0dGRW9DR1lFSERCazN0REVr?=
 =?utf-8?B?cWMvWkdwYWJKY1pqRHZmL2hqbFlxcDlzcGl6dTkwSUtKeDA2OXk1MGdtejlV?=
 =?utf-8?B?cHI2ck5xMjJVMFNua0ZoeVR5RkpPUE10UWh0aFhKVUM4MnJTZjlOTTM4d0k5?=
 =?utf-8?B?cUI1d3BMcVMycHZPb0J3SDdpT01UODN0Z2N6Y1VGSS9tNVNKVEN2UVFwbjJM?=
 =?utf-8?B?SHNMN1dDUFlLQ1Zad0tVR0ZKK2dkdmd5dFpCbDNOcExMNENxWTErTHpKU3U5?=
 =?utf-8?B?dHdJZVhTc1BPKytMYU4wZHVmTXd5UXdwQWlRUXIxWk43UzRqaEQ2Y0lQc2Fl?=
 =?utf-8?Q?fmCyyp9KLaYzF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXN3d0ZPeGZHeW5vMFpQQ2Y4Q2Yvb1dKb0dNbGJSVThQZ3FNMUdLVnl5TkJw?=
 =?utf-8?B?QlEwZTh0eVptRXh6cDdJT2JDVVE4U09RMENrQktDcEhsRGhnL0JPTGZ3eExJ?=
 =?utf-8?B?bTlSN2JNTzNJZE1hdVU0cEdPMHc5cStyUmphcUVZd0x4OCtEOWNaQzFjUHFm?=
 =?utf-8?B?NlpuNGlxNTQ4d0VnRTZVTzlGeHBNZ3N4U1J3Uk03TFcyd3hmb2puSlZjdFI5?=
 =?utf-8?B?ZjRCTDNqaWpiNTZFVlA1aDl3cHdGVDl6Ym9CU0xzQWpvTW1kRzN6aXE0Uytx?=
 =?utf-8?B?N0xKdldUT25KeXZJVmxLYkRRSTd1UXFEZ01YUXpFMXZsUlAzRGlYM09OcEJV?=
 =?utf-8?B?WGoxaGlQUWJmOGJvN1JRbDVnc0VvMHdIamdoMTJ1c0ZBaUNuWlE4c1dYQlFl?=
 =?utf-8?B?bnFwRkwvSDlmeEo0N0dnYTVYUXI5VzRSWTA2N243RnY1SC9PYTZFak03KzVI?=
 =?utf-8?B?MXFJSjBtNUVXUmtLVzFaYkhsbk5wL01TenVjem9WTXd3dVZtVkZ1R3g1Q2x5?=
 =?utf-8?B?bTg5aEk4K2J2dEpaSUo2WmZHSXlVOVJEeXU2TGNjYXlLK3lLTHlEVDhsVG9L?=
 =?utf-8?B?bld3TW96ak9pZmpTN3R5TGtYdFFSQm9GNXF6QkRyQ29OanZ3QjI4ZjBYUWFB?=
 =?utf-8?B?dFpKRHBIVGpncStJc2YvOFN2NjZ4WFp6RGZ4OWR4YkcwQVFyV0o0aEExMTY3?=
 =?utf-8?B?ZjF0WERZYXhtSzdaUzl1UVZvQlJDT29NeDJwNXErK1lOK2pka1Q0bEZCNXpu?=
 =?utf-8?B?dFNHczVNUjh3OEQrRWNENWFjQmJUR2JCY1RxaVlOamNxS29WdmwzWElvT1dD?=
 =?utf-8?B?K0RreGQxai8vNEV6VXczbHpueXRyWnNpaEdEVnhlVVJrNkdXN0Jzb1V4UlhU?=
 =?utf-8?B?Q0xmbUJVTDhuRGQ0aE5XOVUvQ1RmcFhxQUNYNzVqeDdWb09lb3ZSQ1BpWnNu?=
 =?utf-8?B?UWNwWUZ2ZlRUUSsreTZibFdYT0pPbHE1M0g1elZkSXZCeDRRcTRjZVptZFNy?=
 =?utf-8?B?aFcwMUYrc1ducWNZd2QrcEE5eU5tSmlRUFpRRldGNDlPWDBRbDVxb0RZaVdy?=
 =?utf-8?B?bGM2T0lWOGxmOHhDWlNrSGJvWU8wdURXR2FxQU5RdUZ0SjNwcGZqUTczc0hP?=
 =?utf-8?B?eVR4TU9Ed2NGZkZ6SWtYdFlwckVHYTFlQmdSTllEWWYvVVdJazF4RWtlRGFz?=
 =?utf-8?B?NmVLWW40SDMyeHhNaTZyV21XVmUxUjVDNUMzZDY1Ly9lb2ZDRnc5empRMTRD?=
 =?utf-8?B?cDkra2FPNm93d0FIYXljV0tuZWxtVnUybXVDU2dqVWFaMDJ0WExrTTc3c1Jv?=
 =?utf-8?B?TUQyQjNQcmZ4d3pxWTRzNytKcWR3OC9mL3dVUjhQd3JFbDJ0NFF1WEdLS0Uv?=
 =?utf-8?B?MXZVMkJkUVNUbGs1dGlvYVpoa1VyajlHVjZTK0gxdFBGQnNRZ3MyZE42OGRr?=
 =?utf-8?B?RHEreGdHdjZlY3cvQnVzSmFpclRRVk5lZnhINUFsdlNBaWQyMmxHTktxVGp5?=
 =?utf-8?B?bi96NVd4NG84OUtRby9MT0R5bGhmZEZyWFVhTGwyY0FQcGZTR2ZodytmRjVH?=
 =?utf-8?B?Z0s2djhVVmcvL1lxWC8xa3dTYXg1SGJ0Tml4eHJhbG1NUWxDZTJnRlV1RUZG?=
 =?utf-8?B?WVBtclpTbGpsY1Zjb1NhNFZJbkF1RVdES0hwRWd0SEUrem02STgybVhaOVlC?=
 =?utf-8?B?dGtwbnNzN1ZhVGxNTm51cDVWQlhMcVd2WjJ3YlZpTG5vUS9Ra1JSV1NuQ2ZE?=
 =?utf-8?B?K3dvcVlYcUhmditQL3p1WGRNRHZzc2lseGNjVDVHWjBzNkh5VWVwamJnUURD?=
 =?utf-8?B?N3l3d0NWcWQwYWZMM2VsWWk2ZGFId3ZVTjVveWlZelpCQWRTTnRXR0cvNnor?=
 =?utf-8?B?MURGbk5xTk5sdkNkYWVEZ2tlajQ2Z1dNOTlBMitRaEJ3QWhoN0ZLQndETDBG?=
 =?utf-8?B?ZXA5ODE5TDNZUUR4TE1sK0p3a1ZYOEY1VXFoR2JFVG9od212RVN5MnkxTnhX?=
 =?utf-8?B?dXFhWE5QdjQ3UzRRMXgzL2tuSTQybWMydVViZDFOSFV5eTA5MTRzMUx5dHA3?=
 =?utf-8?B?N1pHNC9MUmNFSU13NjJaRWpxTm9nTjlyRFRWTUtZbUFSRzI2cmlYQTZEL2Fn?=
 =?utf-8?Q?DIDwRm+4GTVZFOodp4lUKBWQT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f098a91c-7d9e-4b04-6c87-08dd5c338c3d
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 22:17:42.5654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: omUrrwgiHQpe+UFXfcxgfMR8NE/zaj7hcgOw8hQIJ5SKwhKojYMOkH1AEjz5jGbMuqOB5s4hgI3AVh+nUDc2PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7652


On 3/4/2025 7:58 PM, Kalra, Ashish wrote:
> 
> On 3/4/2025 3:58 PM, Sean Christopherson wrote:
>> On Mon, Mar 03, 2025, Ashish Kalra wrote:
>>> On 3/3/2025 2:49 PM, Sean Christopherson wrote:
>>>> On Mon, Mar 03, 2025, Ashish Kalra wrote:
>>>>> On 2/28/2025 4:32 PM, Sean Christopherson wrote:
>>>>>> On Fri, Feb 28, 2025, Ashish Kalra wrote:
>>>>>>> And the other consideration is that runtime setup of especially SEV-ES VMs will not
>>>>>>> work if/when first SEV-ES VM is launched, if SEV INIT has not been issued at 
>>>>>>> KVM setup time.
>>>>>>>
>>>>>>> This is because qemu has a check for SEV INIT to have been done (via SEV platform
>>>>>>> status command) prior to launching SEV-ES VMs via KVM_SEV_INIT2 ioctl. 
>>>>>>>
>>>>>>> So effectively, __sev_guest_init() does not get invoked in case of launching 
>>>>>>> SEV_ES VMs, if sev_platform_init() has not been done to issue SEV INIT in 
>>>>>>> sev_hardware_setup().
>>>>>>>
>>>>>>> In other words the deferred initialization only works for SEV VMs and not SEV-ES VMs.
>>>>>>
>>>>>> In that case, I vote to kill off deferred initialization entirely, and commit to
>>>>>> enabling all of SEV+ when KVM loads (which we should have done from day one).
>>>>>> Assuming we can do that in a way that's compatible with the /dev/sev ioctls.
>>>>>
>>>>> Yes, that's what seems to be the right approach to enabling all SEV+ when KVM loads. 
>>>>>
>>>>> For SEV firmware hotloading we will do implicit SEV Shutdown prior to DLFW_EX
>>>>> and SEV (re)INIT after that to ensure that SEV is in UNINIT state before
>>>>> DLFW_EX.
>>>>>
>>>>> We still probably want to keep the deferred initialization for SEV in 
>>>>> __sev_guest_init() by calling sev_platform_init() to support the SEV INIT_EX
>>>>> case.
>>>>
>>>> Refresh me, how does INIT_EX fit into all of this?  I.e. why does it need special
>>>> casing?
>>>
>>> For SEV INIT_EX, we need the filesystem to be up and running as the user-supplied
>>> SEV related persistent data is read from a regular file and provided to the
>>> INIT_EX command.
>>>
>>> Now, with the modified SEV/SNP init flow, when SEV/SNP initialization is 
>>> performed during KVM module load, then as i believe the filesystem will be
>>> mounted before KVM module loads, so SEV INIT_EX can be supported without
>>> any issues.
>>>
>>> Therefore, we don't need deferred initialization support for SEV INIT_EX
>>> in case of KVM being loaded as a module.
>>>
>>> But if KVM module is built-in, then filesystem will not be mounted when 
>>> SEV/SNP initialization is done during KVM initialization and in that case
>>> SEV INIT_EX cannot be supported. 
>>>
>>> Therefore to support SEV INIT_EX when KVM module is built-in, the following
>>> will need to be done:
>>>
>>> - Boot kernel with psp_init_on_probe=false command line.
>>> - This ensures that during KVM initialization, only SNP INIT is done.
>>> - Later at runtime, when filesystem has already been mounted, 
>>> SEV VM launch will trigger deferred SEV (INIT_EX) initialization
>>> (via the __sev_guest_init() -> sev_platform_init() code path).
>>>
>>> NOTE: psp_init_on_probe module parameter and deferred SEV initialization
>>> during SEV VM launch (__sev_guest_init()->sev_platform_init()) was added
>>> specifically to support SEV INIT_EX case.
>>
>> Ugh.  That's quite the unworkable mess.  sev_hardware_setup() can't determine
>> if SEV/SEV-ES is fully supported without initializing the platform, but userspace
>> needs KVM to do initialization so that SEV platform status reads out correctly.
>>
>> Aha!
>>
>> Isn't that a Google problem?  And one that resolves itself if initialization is
>> done on kvm-amd.ko load?
> 
> Yes, SEV INIT_EX is mainly used/required by Google.
> 
>>
>> A system/kernel _could_ be configured to use a path during initcalls, with the
>> approproate initramfs magic.  So there's no hard requirement that makes init_ex_path
>> incompatible with CRYPTO_DEV_CCP_DD=y or CONFIG_KVM_AMD=y.  Google's environment
>> simply doesn't jump through those hoops.
>>
>> But Google _does_ build kvm-amd.ko as a module.
>>
>> So rather than carry a bunch of hard-to-follow code (and potentially impossible
>> constraints), always do initialization at kvm-amd.ko load, and require the platform
>> owner to ensure init_ex_path can be resolved when sev_hardware_setup() runs, i.e.
>> when kvm-amd.ko is loaded or its initcall runs.
> 
> So you are proposing that we drop all deferred initialization support for SEV, i.e,
> we drop the psp_init_on_probe module parameter for CCP driver, remove the probe
> field from sev_platform_init_args and correspondingly drop any support to skip/defer
> SEV INIT in _sev_platform_init_locked() and then also drop all existing support in
> KVM for SEV deferred initialization, i.e, remove the call to sev_platform_init()
> from __sev_guest_init().
> 

Also looking at the patch commit logs for psp_init_on_probe parameter:
https://lore.kernel.org/lkml/20211115174102.2211126-5-pgonda@google.com/

User may decouple module init from PSP init due to use of the INIT_EX support in
upcoming patch which allows for users to save PSP's internal state to file. The
file may be unavailable at module init.

So it probably makes sense to keep SEV deferred initialization support there, as it may
not only be filesystem unavailability at CCP module load (or KVM module load with new flow),
but user may have the file available only later after module load/init.

Thanks,
Ashish

