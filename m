Return-Path: <kvm+bounces-51898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE3F0AFE334
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 10:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28FE6567622
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8464A280308;
	Wed,  9 Jul 2025 08:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="biZJGlQJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A521277C82;
	Wed,  9 Jul 2025 08:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752051126; cv=fail; b=n4JN+eE4maGCcgE5lwVfxlr/Sf7wx8ZwpI59/SFnsWnPnfxY1s+4tm9ucP3lmPLpkENkQCs4ZYneB5RoszUn9T7G6zxsBYMLdfmOFbjf/OLDV/ZuiN3GuEqX1UnB3kxMVynJCEsCUDpzn4sMDDFvnuAWt1fCOVWq/UqMDIXyg1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752051126; c=relaxed/simple;
	bh=0s2uUyH3ESeE5ij206jJ9+R5l0fLteyWxxOcXJC9S9M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZW9CVgyOS+Dq5cG749lGGidXPmqZbKsqNdyVMAvXbl5RwAazSSgsWhIjeQ9Km9dB8Yj8Zx7TUueZ05Hwmm5qNOszggceIHuHAIbQpJtTw2Ax3r3iuIYr/t36EuOt7/zeFfgLR6Rb5taKtl1tcQWSU5nBRFYmB4EfZ4Zl88LHAWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=biZJGlQJ; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ilo3cEZxeNtQ5Wl3/EDPAm+d+3t0Yqs7xKKfWYz0VvZKtmqdSb0osEkG6JGiM0bmw3KmcKUqNJ0UU69/sCFrmM7IjoUhqzHSjRwtvP22q8cGGi0G/Se76czYw2cT0j6qf9Ea8nRL+KnfhMXT7/OXJzBL4aRFol0C2cVU/0BXa10/rdSAF/3xLSACY+lYPjKpn6viNeLPNyTeZuoebe1vactoKtkzpDJ+n6VRBbANcJBRtAfJ8AX7pt0CvxKXr5QTfVJKUA556+8e4KIEfB0TrRrkhuh9NTs8j78Zs0QrCw4dWYhvWcJVdW98R6lVBGZXLh+HFGpQ6k22fWLeegQVMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lj0vnoKZ+3htgK8duLi6GTQncsVqVZvdIryVBvDmv8Y=;
 b=lcXBe2Pl8uPbo/0KOfSF0/+gpy8uiUi2QeJfANmhiHeE2ZtAGtdqincw0flnyMSdaP0Yr38Kiqh5iuWiE05Cq0dGtjXV2pPQtdcQsDKUkdxazoT8P5MLdAkRjb35VYqd/V/7jS7xTT5ls/62r3fu/VjmRk5a0ymZm1Ar5L9W0kVHkccBRNzWiDnNFbckPGEMJqwPq+DoOCHIdzTOOWlpis6IKvFVKofeVviyYnThOh8OTSk0OtWSaciSgkh5r6tuVkVqr2JBZ60sGgiaceeCmVMfLufJvvbmDdn35JT5DNaRpGYQ4CGDsWXHe1dpGcSnWBCtukrks9FWIlYr5n0pVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lj0vnoKZ+3htgK8duLi6GTQncsVqVZvdIryVBvDmv8Y=;
 b=biZJGlQJaY8ay04Ptx5f3/JxoWzI8DCgEfz3vp0Njo/IzobK9ZZNcSDjxGY09TF0d4viBpeOEQvWsOl0gb1AlTyF8Ucv9vCeIcvyyoe2oJTDhchYy9LlyyvYFZPxYugGmBTqAxe/bToq/R9KZPYIRCL0EIIxDB1nm/ozxLv2Gac=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by CYYPR12MB9015.namprd12.prod.outlook.com (2603:10b6:930:c8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 08:52:03 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%6]) with mapi id 15.20.8901.021; Wed, 9 Jul 2025
 08:52:02 +0000
Message-ID: <6513254f-106e-4ed9-9622-8ed20909e1fa@amd.com>
Date: Wed, 9 Jul 2025 14:21:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
To: Kai Huang <kai.huang@intel.com>, seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, rick.p.edgecombe@intel.com,
 linux-kernel@vger.kernel.org
References: <cover.1752038725.git.kai.huang@intel.com>
 <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0044.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:271::14) To CY5PR12MB6321.namprd12.prod.outlook.com
 (2603:10b6:930:22::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|CYYPR12MB9015:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e613bcc-064c-4e41-e6e4-08ddbec5df65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2cwbm13akhVOUxnSkZhaXVrdVhRaHFJUmJ0dDE2OFBkekRzZ1dGQWk0ZnFm?=
 =?utf-8?B?YnlkWEVwZEV5SEhGS2czbitXdnNmWjliRjBlOFJWVlpXK094R3czQjU4Q2tJ?=
 =?utf-8?B?UHF5QVpSK0ZWZWdWYjlkU3A5dzdzbnV3SFMzUitxd1pKeDZOZFNSUkpXRFBp?=
 =?utf-8?B?cWpBUVJCbE5UVWdKRDI0Ky9TSnhDWFJBZFBpaHpVWVZzc21DSE9XcVk2REl2?=
 =?utf-8?B?WGhuS0xRT3lhaGd5SndpejFjMFkwejZHeVowQnhpdHlIREFHN0VNZGZONG4y?=
 =?utf-8?B?bC9CcEJ4T0FKS3VoZkE3dEcwTjhWa28yQWhGeUc1bGJwK0ZNZzI0RGIzdXRW?=
 =?utf-8?B?VDJ4Y1EvWWg2bE9RZCt3QW04TGEyWHJoTWVnK0tsQUxnZEJWbWh3cVdSYlUz?=
 =?utf-8?B?NWljWThlK00yWEFSV1pTUDd1MGs1NktmQmNuMm1BcWlDS1JUbXNKRWdpVElp?=
 =?utf-8?B?SWcyc2FTZ2RKSzZBSEpKMjdUZHkzbytBeFZFOHNIcjNGN0R2RE83cW5pS2pz?=
 =?utf-8?B?dVZhVFBvb1ZLK0cyN05oNVl4RzJjdW5ScVordnZqdy96R3ZUajR3UVhtTzlU?=
 =?utf-8?B?SjFqTjcyeGd0dGZ0eHhNbmVjbkc0SUxqalhSS0FGOUx6YWJiWHpzY0VFZC9B?=
 =?utf-8?B?b09vRGtWWjF5amdQL2NqcVRra1NiaUNvRGtheGdreEsvTk5aSE5ONStYN1Za?=
 =?utf-8?B?NHA3SXdRY0Q0eStFcnJJNzlxUHh6ajNjd1grTmFyK1BWK0hnSWxOcTA4VGV3?=
 =?utf-8?B?UUpGZ3Bremo1Y2dJQ2RmTEkrUU4xTHNhcldzbHBXOXVQOCtMVkc0bE9MU1ho?=
 =?utf-8?B?QVVnUWo4OW9ab3dOR0RWeHNRaUlCOWVQdW9JYTVwTGhXSTBMWDBZVy9TSjVK?=
 =?utf-8?B?ZmRxcUFhNTNUN2hZdkpHSzlxTkV4dHBrK1g1dFllL1F3RXZEQjFNcUpham1L?=
 =?utf-8?B?LzdjQm9yU2hLRFpGWXJNYmgwZUcxalk2ajVrWEQwOThQTDdveU1SK08yaVlW?=
 =?utf-8?B?QTFYSWIvdEJ1R2RoVGEvMEZ5cXNFUkxvWEc5MmF3a1RFNTdBb1kxTWcxNWJp?=
 =?utf-8?B?OUMrRGJwb0JJd3pNcTl5YzdXN1dLMk9FTlpCVkkwVG5vbDVxZTV6WnJXMFdL?=
 =?utf-8?B?eVBNT3dqcmIyVzRNQitFT2FmYmxTVEo1akY1Rks2aTQzTmNqSDJqdlg2VjRF?=
 =?utf-8?B?NkVoYkxQTXFWR0NRejBwN3FaeU96OVBQdG03NlRxQ3hMdEU4NGhlbG9YRXVu?=
 =?utf-8?B?K3NkbkQ3L3NZRUh4M2N1QlBaTTRFc0NIM0FnWWxla2V5NXN1K1htMzdHSHpX?=
 =?utf-8?B?VGIxSHFQckN3T1hHc2VtT3Q3aHBzV2ZTUStNQy92U2hPclJlM2hLYnI5ZWZm?=
 =?utf-8?B?ZExENCtWbS9qcWVWNUhyODBUUlg5QWo4SFZ0bDF6c1h3amMxMzhOcElvKy9M?=
 =?utf-8?B?eFJ1RUZRV3FLbWNYK2J2ZGhiRzdVbkdtNitWblZCamtLRmxJV3poUkJrc1Qx?=
 =?utf-8?B?OHlNQ2plZHJkcS92dm1sMTVCRk92V3NGc0JrRm9EK2srTHpaNmNKcWhqUERo?=
 =?utf-8?B?V3ZXZ1V4SlNnR3lvZ2t3eVBKczUwb2ExWVNRVU9RTGNDWUtuS05mNlAvU0o4?=
 =?utf-8?B?T1R0dlp4aGF5K3BFbFFqclRkMzdZMnBKV2Yxcy9sUHRxd0ZMaTNRK0xMckdu?=
 =?utf-8?B?NFRtK2FGYUFjMGx0WWM3SjVuOEQ5b0JYUTQ3NzlhTXRLeGo2Z0szSjY2bExY?=
 =?utf-8?B?NXJEL0RyYjY5SkFmRHBTQ1NVY2M0aG5USzEreExpMjNVdkMwelFQSSs2WXV6?=
 =?utf-8?B?QUNmK0J1Nm9Cc0t4Z2hDeEloZkNxMERTckxhYkVRWld5dXRsd0dySy9tMmkv?=
 =?utf-8?B?N1BUWVpYMlRnS2s5dkVOangwbWV3S01qdUFKNXNaZll6YTAxL1dGMi9xNHM3?=
 =?utf-8?Q?/Hfq3jjOwj8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmpxdjlXYVVXRTB2dUg3Ym5yM085RVBsYTJwblFhN25VbExGT25nK2hJNGF1?=
 =?utf-8?B?T0tTZVkzQjFqRGQzMUZPK1NqQys5WS9KQVlqZnJ6VkcxOHFKZEtsT2U5NXRl?=
 =?utf-8?B?ZGYxT2xoUVFtTjJyeWJrNHdJcDdZQ0EvSzVZcmpvWHo1WWdBV005T2JKWUdo?=
 =?utf-8?B?T3FjMmFyRFltVnI4ZDJIV3BZQk5Ic3Y0aktKdzBjVTFFL3lPcHdDcEN2RDJG?=
 =?utf-8?B?L1NCVkJFdXJBdVpzM2M1VXg1b0gvK0E2WGdwZTJFZ3Y0TlhURG9SV09Ia3Vo?=
 =?utf-8?B?SG9HRHdPanRpUU1OeW44Uk1nS2hyVy9XNm9yQ0wrSGt1alhZeGE0R1VFUDk5?=
 =?utf-8?B?NjUxV2poTkUwQUtSeFVPN2owb08xQVdSSWVpdjhyaUhmQWFrRUFSZ0krVm5G?=
 =?utf-8?B?ZmdsSG9jREZCUGdpMWh0MnB2eHROTWNuQlZGNVJuWEhaRDBMUkp3WUtGaG5h?=
 =?utf-8?B?Q3Ztd0JnaWhucmw2ZDdWR1hBcTlUS0FhZFg1d0JNTGNJMGxicThCZVpKWGVq?=
 =?utf-8?B?U1FLSUZVTmlEWTBpOHVMbzlSVGFvSUlzTEJUS0x4aWp1U2twOXlXS1lDNE5t?=
 =?utf-8?B?TC9nWm1tVXgwTVc1N1NiZzVnam9XR3p6U1JreE5QRU1TSUNiZFJraVQ1eHc0?=
 =?utf-8?B?eVdUVCt2MFF6SDRhTE1aRkpiTGNNQ2FuYmJBU2xhWFVMK09DVCt5RkgyN3Qx?=
 =?utf-8?B?cjhETWRSZHQzNE05THloSk5nQlJSSlpjQWlYMkhTNjUrODVVb3RRUVg4aWVi?=
 =?utf-8?B?SzFVN0hWQmw5MFhMYy8rTm53d2hxU3FzVkRtQUxYdUgzWUZOUk05a1F4Y3BX?=
 =?utf-8?B?RkQ4RkF4ODltS3NVOS84TVdYV04wUlZ2Snh2dzkvZDY2azM1eFEvaldFSVVx?=
 =?utf-8?B?SFFUbHhOdUxPb3BPeTV1QUw3NWJlT1FHZ2NvUUhsblNQL0s1amZjQlc4eXNE?=
 =?utf-8?B?cGRzeGlVQ2pjK3lkVG1kdSthU3gycFFKbWYwcmRjUzZCajd0Z3RhSDh6WG05?=
 =?utf-8?B?REUzZ1RsNER5RGRKQTJMSWJpRXRYQjhlMEVyUzlFc0tveFlEMHcrZ1pGeFFO?=
 =?utf-8?B?SnhYUkJLbk9tempEaG96T3pydXJaOS9nZVR4MFMrQThudnF0N2NJV0VBY2FV?=
 =?utf-8?B?RVFNRFdNV2NRRGRaQ20rc0FXaUlIdXhHY2hrUzBKRWNoUDZuL0RjT3d2Tm1p?=
 =?utf-8?B?aEZZM3N3a1RxcVdraTZNSU4zeGtaYnduS0ozV296bWhQMDF0Nm9SSlJtWGZK?=
 =?utf-8?B?M3Y2S1EwV0tHMFVQZTFFWVF5NTk3ZXhNT0U4WUg3dTE4Y3locGY1UTFkMG9p?=
 =?utf-8?B?TWZDbGJFNlJ6eFlFN0tEdlVrS1kvY09FUmZyT2I4Ym5NMW0xTjg2UU1NQy9G?=
 =?utf-8?B?ZkYyVWtHSlJ1RWg2NWliQzJobERCVkY5d0Z2NHlwSEhYSGp2cmlDbkpWWG51?=
 =?utf-8?B?Q0tHbFVnQ2w3clVlNWlvZzAwTVRZMEJuYkVyejEvaTkwN3R0U1doSmZEK0M4?=
 =?utf-8?B?QW4vQnVXd0hzV1NScnRMbDFzZFJ3WGFaRGlma3BrTGpERXF6RHRCcE92UUla?=
 =?utf-8?B?cGt1SWVnUDJDSm1rdUlnODVNSCt4aVBUUWVWd0JwTHd0aGxBMHlKcGZwMmI1?=
 =?utf-8?B?cFZRc2lBRVBWOEpGN1IwRDVWOElNVndIdWxuQU0rd2lUenIwWHZVNlZjdHhX?=
 =?utf-8?B?T1REZnhsd1RhQUVmZEdJdkpSUkFxbEk4aklENHBDOFNMOEpLd2RvVHgxc1hu?=
 =?utf-8?B?Y2JRc05TYXZlS0VLQTRENDc3dy9TdUFuakNOMHpJM29vWHR0YlBzVVphMVYz?=
 =?utf-8?B?dDZNbVExTTZYTmdxS1kyWDFjZVMxUTN0K3h3cjlaS3VuNi9lQ1M1Y1VscW1K?=
 =?utf-8?B?MXdkaWpaWWd0MW5BdmFhVWNVZHRNZ0FlUWd4bHlJZ2l2ZnV3YWhWSlFYN1Qw?=
 =?utf-8?B?QVIvQlpualk4YndFNFhYN0FJcExzZ1BpemUxNlkrT1d3TXNCSTVGYnpCeXBX?=
 =?utf-8?B?S1Z6ZDRacGdxQkZucDZFMG12azNuMzlWd1k0azJXbk5aRC8wOGJCVUd4SFd6?=
 =?utf-8?B?R0R0a1JSSU1HeEdtN3BoSXFuNFJ1S3Q1NHdFT1plcUVhQVVYQVN0YzJyRXl1?=
 =?utf-8?Q?kCLCnn35nI8o6o8oUcG+h3BI4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e613bcc-064c-4e41-e6e4-08ddbec5df65
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6321.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 08:52:02.9255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JR0HuYId5bUppsO6MTR9ommmX0iRQBfxcECjF1bDWcKOLpWoMYx/eyWL+QCrJrh0cqaNLe+fvF74gp8p7R0eLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9015



On 7/9/2025 11:08 AM, Kai Huang wrote:
> Reject the KVM_SET_TSC_KHZ VM ioctl when there's vCPU has already been
> created.

Probably the below is clear:

Reject KVM_SET_TSC_KHZ VM ioctl when vCPUs have been created

> 
> The VM scope KVM_SET_TSC_KHZ ioctl is used to set up the default TSC
> frequency that all subsequent created vCPUs use.  It is only intended to
> be called before any vCPU is created.  Allowing it to be called after
> that only results in confusion but nothing good.
> 
> Note this is an ABI change.  But currently in Qemu (the de facto
> userspace VMM) only TDX uses this VM ioctl, and it is only called once
> before creating any vCPU, therefore the risk of breaking userspace is
> pretty low.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/kvm/x86.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 699ca5e74bba..e5e55d549468 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7194,6 +7194,10 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		u32 user_tsc_khz;
>  
>  		r = -EINVAL;
> +
> +		if (kvm->created_vcpus)
> +			goto out;
> +
>  		user_tsc_khz = (u32)arg;
>  
>  		if (kvm_caps.has_tsc_control &&


