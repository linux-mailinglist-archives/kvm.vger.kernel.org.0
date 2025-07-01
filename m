Return-Path: <kvm+bounces-51154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60667AEED97
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 07:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A9237AC0AB
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83AF472601;
	Tue,  1 Jul 2025 05:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EqgURDQI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240841E5B6D
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 05:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751347896; cv=fail; b=YN35kMyfTfOhKAkh8rd1rmgIYixWOmR9FcG62eG9fS11frj/6sQUeUptOndQW1NYNBNnaABiVaiEhBTjAedJGeLCTQuB2wOJryoP/z8CdvdoftqsPqc6RJZpa08Bl5IpAJEvOcNFCrzzzOBfseKHA6o01hoQY0ubYi5bR4gAc1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751347896; c=relaxed/simple;
	bh=4gWjXA6UpMUktw1TXEFAL0BoY4MH+oUIIktYTNJ9aqk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cPaXWofameEND6qISVSu4iuxZwUz/o2OeaHwuGKhkLzJhjw/cpFZWpZUXrC93iDww560B0GdBeAiGEX+C3nsS5ltOeqSrz9Wd30rIs+RVjKUaWAAfEtLp7d/MPh7D75mNQwFhVqMSubmJ+CFYzs3wWGkPUcxA+/O0VHwUTTJ3hM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EqgURDQI; arc=fail smtp.client-ip=40.107.94.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpJTGwkAoHwceHwqrtpVukKAOmszmNhpxWw1AkGnpIJhcqQ2rtv0iFQ8hpHucp2UgVYbQ+LU1Cn8m133OpddPX5uzsGGrlJXqnkg1w42rwtbXcPyfESDJf+jkUFZIIPblfvvpDrEqSnwFmGxf2KC7aM0SoM9xlPFb/ioIZZinCDYGKDVz7iUHrQlqaV8Tbz8GHZJaUhxe+KPcEoRa+DAa3VCtktwF/9AGLTBmNOj70uvC8zeZLd04CAnUF3BhlugvFxqo7OQR0TRfXRhotysxWA8cNGv9N2S3HASGBAfvIo+Pu+Mv48GT+32sRs9+WU2vBeeQmVUrEk2oqP15HMI6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xsFQLwIQ2O13SaTjijxhncXZ9Eya8LA8zkLjfJYXDqU=;
 b=TUxHab1BW50NQXeVYotwyi07ppdqFo8uv1raLPP+ljUWIMTw7BQTUjd3RzFSjxnSpVI0gNhGBbcQu12dGRgv8OsjmLI1m+Yzba7jeBpgsNaS3otgMmmhggSuBgdbx13Z2reT3gQwKyBkiU09M6odH5jWOcz/JppDnxJcDz5LQ+sCCW/05NOkUg35V9o9BJTI2WsgrgZl/B8FuRV5O0PAMaCKMzlTmuzYcYtpnLKf7ZObeEFmXM4s/wyU1dIcl3/tXiGl1jtjtFZxDvx7swlZndw5cc22Z3vq38x3Mv1iNYzJCtUBbGQylN9O4YEkJWPUqptRX5TZt6larSDs9x7PYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsFQLwIQ2O13SaTjijxhncXZ9Eya8LA8zkLjfJYXDqU=;
 b=EqgURDQIUzWmLNpGBXqpTxNVBaLCzn5BDYxdplRSs3CVUHJXz2wpIxZjzqvznWPyyXHikbrBFcDVUM7vqV9Scbm2EYcs9CHQ0lYYv8EUPfyz7BAM+2pesjPbB4y00ngfRZguPBArS8k7/ToNK35S2WzAyFESRdSj4UXFttYxgBE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by MW4PR12MB7309.namprd12.prod.outlook.com (2603:10b6:303:22f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.30; Tue, 1 Jul
 2025 05:31:32 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%6]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 05:31:32 +0000
Message-ID: <1cbd9a5a-1c15-4d32-87b2-6a82d41ff175@amd.com>
Date: Tue, 1 Jul 2025 11:01:25 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] KVM: SVM: Enable Secure TSC for SNP guests
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "vaishali.thakkar@suse.com" <vaishali.thakkar@suse.com>,
 "santosh.shukla@amd.com" <santosh.shukla@amd.com>,
 "bp@alien8.de" <bp@alien8.de>
References: <20250630104426.13812-1-nikunj@amd.com>
 <20250630104426.13812-3-nikunj@amd.com>
 <bbee145d51971683255536feabf10e5d2ffefb44.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <bbee145d51971683255536feabf10e5d2ffefb44.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0059.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::34) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|MW4PR12MB7309:EE_
X-MS-Office365-Filtering-Correlation-Id: fa94cdac-5745-4c58-ef54-08ddb8608969
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWQ0SXR3S2pSY2FoRWUxMVN0d1E3eEpLQkRaTlc0VzZSQVJXeE9GTGs3Nnl4?=
 =?utf-8?B?Zk1tcnVXQ1p4NDJoaWVqZkpsUUtYaWpuc2hKSFFXcnA5UUg0bnNCZnVKOE51?=
 =?utf-8?B?VHI0dHNqejhUNnVXMFFrYnFmUmFMZ2Nta2krZlFvc1cxS3A0T1lSUFVZZzE1?=
 =?utf-8?B?SXl2RGxXNVIxckhxejd0RHNXaHAzcmsxQzRxQk12NHpoZDNJTnhTSWNXOWxH?=
 =?utf-8?B?ZTFYOU0zSFVoZGJ1ako2RXZMdkVUZVBtMnpPV1BWdXVKa0JKMUhhNG03Ujli?=
 =?utf-8?B?T0xxYko1N3BrZTJ0aFI2WGVSQzdkblpYR2FHRVE4SFR2Z3NBZ3hjUkNZK3l0?=
 =?utf-8?B?SUd3bGtDN21PZWNUKzBWcEkyRGlNQVhQek1QKzJMOVlCZGpqRkxQUWx5WWJm?=
 =?utf-8?B?cnVlZEEzWmtFaURaQzJuWlFJcEVIYUR4S01nY3dGVm91K3BiNVY0ZnZxcnNr?=
 =?utf-8?B?ZUo2dHBRWTgxNFU4N2Iwc2ltQ1N4dzV6SVZHaXArY2krS0MrRDJJRXdFKzdB?=
 =?utf-8?B?REE4M2xjR0FodU54YU5VTVQxMjdDRmY2a1lPK0NuYUZDOFBrSFJnL1FoWWl0?=
 =?utf-8?B?Q1IvUTNOU1UxNU5ZY2ljSGExUngwdWhiWDhpZm50Z1lwTGpOTFhMVmV0bFBj?=
 =?utf-8?B?aWlHMmVGbXdmdllSVW8zSS8wRERrakRPblFzbjU5d1piR3F0ZFMvWUJuRUxS?=
 =?utf-8?B?SXRabHRBYkN1andaRzdKbWtEYTFYVndhL0NzU1I4TTdBQ0JwaDU4a0QyQnhL?=
 =?utf-8?B?MHhaLy8zRW42Rk1tSzZMeGl5UmRzM1lJNEFKUEVFRXluUVZjaTNkWm9SVU1H?=
 =?utf-8?B?WTlYL3h3THRXTHN4aURGeVAwSmMwNGVnSEdUSGtvYkkxN2JqaklqL3pYNy9j?=
 =?utf-8?B?bER0dStJVFJuYW14S3JnbkRFeWJjbTJ6bU5qWjBzWldFY3U2bVIxdWN1Y2Rk?=
 =?utf-8?B?OVl0a2hhcVd1MlBaVzdiNVN6ZjVjTGY5L2J3MlJORjFyd0RCeG5QQnBnNmtz?=
 =?utf-8?B?TnhSclo0WlNoSUQwVWY4NFJteXBZYkVIc0VraGJkUTJIU2tpT0JTeVhzRDBl?=
 =?utf-8?B?dlBlbjZwOC91d1JsVXVhMDRHZVpFRVdVTDcxb0VzcFRnbEN2cExFdVRyb0I4?=
 =?utf-8?B?eE5telcrYnhBM3lnc1FZWllqVkRSaUw5UXFuU2RKckg0dVk0QTBxZWtuVGVU?=
 =?utf-8?B?bjdzam83V2N2VXR2RGFNYVdFTzJhbUF5dkdhaVo5azc5Uzd2eXZnVzgyQlhl?=
 =?utf-8?B?Z0xEODBweW5QWEtIYmt5Q2dvQjJHSHFIQVlud0dZMURwektHM201aHVJeE13?=
 =?utf-8?B?QjZKYmhKT2pLNWZwRWo0ZlB1MElsUEJFcE1yLzZsYnh3cDZyeFhIZEZ2ZER2?=
 =?utf-8?B?eWNqN1JwNzg2VktmYmdvZWFrcUQxMlE4cWJpbUhucnh3SjRQdEtLRTB5cWRy?=
 =?utf-8?B?TVIvamdLdHZRam1scitYZHZYWkNmZ2NCVnd3YnFGaGxZSzFFUU9hd0Rjd1VZ?=
 =?utf-8?B?eWNoU0NRR1p1M2Q4NHJZcGxKRmRKYXJ2dGxaY095eGJFTTJnYUlya21NeG1V?=
 =?utf-8?B?TzhmdEowSjFvQXdheVpEcDJPVmdGNjNLWUt5enFWUldZcW90ckNaZDR4ZHVH?=
 =?utf-8?B?TUpvb3lJTWwzQTduVzBwTWR2bjV3ak5MNmpPWENsRFBSVldUUDBFWW5NczMy?=
 =?utf-8?B?bW0rajFweXBvTVFKWG9tYUpic2E4R29wMzE2RlJJekJtVTJRL0ZaQnlwdUlp?=
 =?utf-8?B?Umx2Z0RPOGNtbFNOQ0IxdUJrUnI0ajg2NEdBUXY2aVlIaWVCRTRtYldOd1Iv?=
 =?utf-8?B?OGNBSVU0ellydC93eTV0WFg3SE1NZGdXZ1d1dHVMTXl1MHViRTQ4U2hxZGJO?=
 =?utf-8?B?T3hnU0FKK2NiR2Vud2tMR3dWNnFSbXRjM0k1R2U0SUlDVjRuNWttblg1aFYv?=
 =?utf-8?Q?IAbpO+oiMEs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eW11czBaMFZYYys3TWNZMnpZV2hnWXJSeHlKbDVRdVZDRHJiQnQzaTYxZ1JT?=
 =?utf-8?B?SHdOOHUxVC85VFdkUXI5czk4NnhrVC9QSG01dnNucFlQSUpKZ2c4WmJQd3ZT?=
 =?utf-8?B?SFFBdUkrSnBNelpBZ1ZhcllaemgvYlFvODRkT29oZ0lVSUM3a1RyRDdPcDZi?=
 =?utf-8?B?dmxVQ2V1ZEdaWUl1UFRpN1BtNG43cFIzZTd0Z2c2MHJLY0JONDlNd1VtcEpu?=
 =?utf-8?B?SlliSWxTUEROZFVXNDc5cDkxLzJSVFJ3UkRhSWhremxVUFpvSmpOQm5mdjBj?=
 =?utf-8?B?ZU9vZ3BJbDY2RUUvV1piVjlCME9RSWdwVmZxaEovUGRMcTRnRmtiQWFhd2Zq?=
 =?utf-8?B?UTh2dEJOZXZOQXh6eWVGRGphOWY2MHNyM0RUSm9RWnhHUm1YU3Z3RE1uWCtU?=
 =?utf-8?B?OWpWQkMwank5K2huZy8vWWYvQU5LZ2swc1VGQVI2clBuY2xVMFhWODZmNU9L?=
 =?utf-8?B?Nm1FNU5EK3Bnd2JhMmk0QzF2QTR3dzlqN0cyc1lDdkRzeUUwaWJwbmVZRFV0?=
 =?utf-8?B?VGcxa0E3ejBxWU93L0E5Und4U3QydXk2UjdSWmF4QzNiNHk0Qi9VSTc5cGM2?=
 =?utf-8?B?NnhQb0xpWTloaGJWeWY1WTdUR2ZOWmM0cDN0NjNuQ3IyRk9XVStaWDBLRkxP?=
 =?utf-8?B?eFFlMW5kZkRYZGphVWNCaXR4V0k2Y3drWGZYaTV5RFFCZlFmMXYzWHpFT2VB?=
 =?utf-8?B?ZkE5YldrY1Vrc0JyUlNGc0ptK0xTcnJxc3VucGViakpVN0NHaUlId0pzSkd4?=
 =?utf-8?B?cnVmRDk2U003M05SWWJqV0M3Ly9QWlArdXFJVkYyKzlFN3VMZyszU1V6bFZk?=
 =?utf-8?B?Rm9hbGtHc1AvZGRnZnBCd2Q0SzhoZ2piZFFXWUt2OHB5VE5JNndzZnRMZVUr?=
 =?utf-8?B?c25GbUc1NnFyQWJmckhFVC9ORGR5eHpUQjJVaktYTllIUmlhSVBLOU5GS3Rl?=
 =?utf-8?B?eWxndHdXVXZBL0F3Qk9rUG1CdEZtcHRYbnNHREtTUWl3aTYrK3VmWDJZVW9H?=
 =?utf-8?B?UEt0allSdGFCWERGYkoyVVRtSFdNOG5oWCtBOEo5NlN2em9HcDBZR00rS25W?=
 =?utf-8?B?T2g5QUFCT2JNeXpGc3g2Ymw2UGNVZ1c4MUJ3KzYrKzkyWHNBNDA1dG41MEQx?=
 =?utf-8?B?NWF3Z1o3aTYwT0ZJVlNnYmR3OVQwNWE3V2NtMVY2dHFmT0tGRkpxRitkbSsz?=
 =?utf-8?B?NmZ1ODJJYmRrejdOZ1VjUjBvMXhqUWF6Um5BbnZJWmo5dFVFbjBQUUI4UFZa?=
 =?utf-8?B?RjJpTXRxL05iNVFMV1Y1QTNMd0E4RXJURWF0Lzh5Y3RuRWphM3JpamRyeU9G?=
 =?utf-8?B?bXFkUmRxNWd6d0dTMGRPNTNQeWpxSTZHMkxKYmxYaVdmTFpqQXRUc0RLUVNW?=
 =?utf-8?B?bjAyWnR0eFNlWlJRUHdRbHJSTGd5WDhBNXFTQzZFeWszRVFaZWlLMURrbllY?=
 =?utf-8?B?TzI1dkdra28rMkFKU0hIQkdzakdOMmpodkZoTHBLZjNrWm81THI2MjhvTG1G?=
 =?utf-8?B?NjE1OHVEaEJYV3RtTGxtWlYxRXRybHduVjA3MEhzSVo1eEM5WGVhZk1QK1JG?=
 =?utf-8?B?UEMvS0k2YXJ6eHNmNWxjaWljS0xjdE0ySDVJajVJbUFDRGtBTDZ3cFJnN3hE?=
 =?utf-8?B?ZytEcXZOY0pqVGV0QzBSRXhEeGY2YUVBSW8rNWpQdlJIZGl5RDZxNHZJYzBK?=
 =?utf-8?B?OTlRN2QyMjR3UkR0UUVqdncrU2psVkoxcksvZUZQayt5VDNRS1pRbWR0TEJC?=
 =?utf-8?B?Unowc3dCa1NzRDVkR2NFb0pTUXE0Lzd5ZzVEd3UzNVJNNGdIRThQekVORGZs?=
 =?utf-8?B?M2d5MklGNFBjcWw3Y0pLaVJ0WnY4MHA1RWFhSmF3Rmg4ZWltT2hHT2tlc1ll?=
 =?utf-8?B?cHN5Sk95QjJrOVVOcWVpdTZudFRvOURQOVpMRjhoZVovNVJFTTBiN2FGRXRz?=
 =?utf-8?B?RjdEVUh3ZnJ0VnJRdHo1Um8yek9MOG9paG9acXQrMCtldzV4bkgwUHVDaUxI?=
 =?utf-8?B?Mm0wWkhXcHRDNTFMYTQwbWtmOEtjQ3d6a3Z4L1RRdU13S01UYzZmY3VRNXpZ?=
 =?utf-8?B?L21XNGVUaGVHRGNtOU1sTTVzWTBWT1FQZjBWNDl0eVZMbitJOWJ2cENiL3E1?=
 =?utf-8?Q?ZdEdc/enLKtMkcR3biprZOb80?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa94cdac-5745-4c58-ef54-08ddb8608969
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 05:31:32.1822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJJn4H0Q8OV4smsoR9T83Mt3svHbBu8+17PU68wj+XvuYBYSdGRU7gogitq+1t39gxn4AXrNqzEor5upTaMjqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7309

Thanks for the review.

On 7/1/2025 6:21 AM, Huang, Kai wrote:
> On Mon, 2025-06-30 at 16:14 +0530, Nikunj A Dadhania wrote:
>> Add support for Secure TSC, allowing userspace to configure the Secure TSC
>> feature for SNP guests. Use the SNP specification's desired TSC frequency
>> parameter during the SNP_LAUNCH_START command to set the mean TSC
>> frequency in KHz for Secure TSC enabled guests.
>>
>> As the frequency needs to be set in the SNP_LAUNCH_START command, userspace
>> should set the frequency using the KVM_CAP_SET_TSC_KHZ VM ioctl instead of
> 				     ^
> 
> I believe you meant KVM_SET_TSC_KHZ ioctl?  Since I am not able to find
> KVM_CAP_SET_TSC_KHZ. :-)

Yes, will update.

> 
>> the VCPU ioctl. The desired_tsc_khz defaults to kvm->arch.default_tsc_khz.
> 
> IIRC the KVM_SET_TSC_KHZ ioctl updates the kvm->arch.default_tsc_khz, and
> the snp_launch_start() always just uses it.

Correct

> The last sentence is kinda confusing since it sounds like that
> desired_tsc_khz is used by the SEV command and it could have a different
> value from kvm->arch.default_tsc_khz.


start.desired_tsc_khz is indeed used as part of SNP_LAUNCH_START command.

How about something like the below:

"In case, user has not set the TSC Frequency, desired_tsc_khz will default to
the host tsc frequency saved in kvm->arch.default_tsc_khz"
 
>>
>> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
>> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
>> guests. Disable interception of this MSR when Secure TSC is enabled. Note
>> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
>> hypervisor context.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
>> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
>> Co-developed-by: Sean Christopherson <seanjc@google.com>
>> ---
>>
>> I have incorporated changes from Sean to prevent the setting of SecureTSC
>> for non-SNP guests. I have added his 'Co-developed-by' acknowledgment, but
>> I have not yet included his 'Signed-off-by'. I will leave that for him to
>> add.
> 
> Well I guess you at least need to put your SoB at the end of the chain. :-)

Sure, will add.

> 
> [...]
> 
>> @@ -2146,6 +2158,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  
>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>>  	start.policy = params.policy;
>> +
>> +	if (snp_secure_tsc_enabled(kvm)) {
>> +		if (!kvm->arch.default_tsc_khz)
>> +			return -EINVAL;
>> +
>> +		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
>> +	}
> 
> I didn't dig the full history so apologize if I missed anything.
> 
> IIUC this code basically only sets start.desired_tsc_khz to default_tsc_khz
> w/o reading anything from params.desired_tsc_khz.
> 
> Actually IIRC params.desired_tsc_khz isn't used at all in this patch, except
> it is defined in the userspace ABI structure.
> 
> Do we actually need it?  Since IIUC the userspace is supposed to use
> KVM_SET_TSC_KHZ ioctl to set the kvm->arch.default_tsc_khz before
> snp_launch_start() so here in snp_launch_start() we can just feed the
> default_tsc_khz to SEV command. 
> 
> Btw, in fact, I was wondering whether this patch can even compile because
> the 'desired_tsc_khz' was added to 'struct kvm_sev_snp_launch_start' but not
> 'struct sev_data_snp_launch_start', while the code:
> 
> 	start.desired_tsc_khz = kvm->arch.default_tsc_khz;
> 
> indicates it is the latter which should have this desired_tsc_khz member.
> 
> Then I found it depends one commit that has already been merged to Sean's
> kvm-x86 tree but not in upstream yet (nor Paolo's tree):
> 
>   51a4273dcab3 ("KVM: SVM: Add missing member in SNP_LAUNCH_START command
> structure"
> 
> IMHO it would be helpful to somehow call this in the coverletter otherwise
> other people may get confused.

I did mention in the v7 change log that patches are rebased on kvm-x86/next.
Next time I will make it more explicit.

Regards
Nikunj

1. https://lore.kernel.org/kvm/Z9BOEtM6bm-ng68c@google.com/


