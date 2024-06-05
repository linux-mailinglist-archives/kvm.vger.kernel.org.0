Return-Path: <kvm+bounces-18889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D73C8FCBE5
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 14:08:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 298C21F21F84
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 12:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BDAF1AED20;
	Wed,  5 Jun 2024 11:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ncxAkJkC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2070.outbound.protection.outlook.com [40.107.96.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACC71AE215;
	Wed,  5 Jun 2024 11:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717588391; cv=fail; b=DsyhpqBYEq9ggLR7HB6tmGWTtc2f5DqYfqE5rfRrl6j3YFkms1e6kok3VrvWegFey+vMejpIz5KKDHqV2zb7bZSMXsdxjf6sOizPdfzAleL9j9lgZFODJIRDj8lZ9pPDYTGLLDmBdhqzPfxBJMI7a0kiPsBMtBsM+Iql/AQqlC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717588391; c=relaxed/simple;
	bh=w+eGZz8YHpzTSCmQlOZR8r31jIbGhMCbbtubiO3Miuc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HfeMar+9i3jZ2BQhm2NpPi/5JOvRaVukbX1IxMOKVYQppH++GLAA/kNbr3+XaYwGMHBhcZRVzazClyEgwqkGscU1ZG4RAjQxuXvoROiiu8HHhmZyqmX54Lx/dwIoxiuG6+qGrlZVJAMcQv0F0fRuyhH45YR3Hk1J5TxtWhCUo/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ncxAkJkC; arc=fail smtp.client-ip=40.107.96.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ydau//CIHC7nDWCP8TTrGoWxRhNCrlRg+H15qDaR810oFXwPiTp/WkUjmwdWBWJ3Sz8v4712YCexFNhAU/cX1s3evxOPgf7n3aJOWitV33uGz2V63pvLr1T2Nq0ny6jV80QSkrld5wHuDMw00m7HCHJ48iwiuIKBwXp0zmb7avwKoyfOiqRR7HpvB5p75TK1V4N0ikYIgc97XmdlgYMVhrbiVJWhy031hMV5g1321ci2qx6xX5ftt05VzXp5dinqNYD9GLFCzD9Ot1cPLOPGJ94g9facTEI5mYw7tMzsZQLPRggR73zQ7pjiOYcZrQA5m2ZReSQ0NKutXtM2N/rWYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7SDZnJ9Od9Pj+vTk/dmciuTZUv0g/O2QLIyejfzh0U=;
 b=N42lvJ0vyRnmNEQiBHdJ3sOwzkRXPIbEoxOgzAKdB1GoUXv7A2xO1NADKMaO2VaWZt6WVeH/U5t2/ESrNvyIfO4G/zQZ/CpeA5Ucxtl/YMhPcxdRhtwGg+m0o32T8yCqKbk59FZw49AZKlwZ3txwb6ftvbY/206XFgpqg0UmZOa5hmTAx6cGksWjyKryoL/HCE6Ma65FysUFlZwJ31LYGkB32VXyCApOBuNFC7O4G4Xn1uX6yGE5eLWDfB0EVWmaOHPHtCMEuT9giHoiogsyp8XwRGjzlkfZG2+B6Zyoo5BVAexW5T3NimcOnDLoEgiD8CvFhIDqDglrCmRAa/P37w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7SDZnJ9Od9Pj+vTk/dmciuTZUv0g/O2QLIyejfzh0U=;
 b=ncxAkJkC620v0LEqxm6DpB5aABbkJYz9+nTRKMwGiRrRRBt+8149sRRTeJr1moNKPVvH8YL15pi5RJlpf6j/8nz3exzNfhrfwXH8fROuFFRcUC3ES8Yxg64trnWtRCAuSM4bAUFI/quY4UTSclaRN2GPisY6+30H+mfdS79734A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13)
 by PH7PR12MB7795.namprd12.prod.outlook.com (2603:10b6:510:278::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Wed, 5 Jun
 2024 11:53:05 +0000
Received: from IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::c819:8fc0:6563:aadf]) by IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::c819:8fc0:6563:aadf%5]) with mapi id 15.20.7633.021; Wed, 5 Jun 2024
 11:53:05 +0000
Message-ID: <fc6a2fb6-4762-4d5b-aa65-8588914221ce@amd.com>
Date: Wed, 5 Jun 2024 17:22:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SNP: Fix LBR Virtualization for SNP guest
Content-Language: en-US
To: Ravi Bangoria <ravi.bangoria@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, nikunj.dadhania@amd.com
Cc: thomas.lendacky@amd.com, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 michael.roth@amd.com, pankaj.gupta@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com
References: <20240531044644.768-4-ravi.bangoria@amd.com>
 <20240605114810.1304-1-ravi.bangoria@amd.com>
From: "Aithal, Srikanth" <sraithal@amd.com>
In-Reply-To: <20240605114810.1304-1-ravi.bangoria@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0001.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::7) To IA1PR12MB6460.namprd12.prod.outlook.com
 (2603:10b6:208:3a8::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6460:EE_|PH7PR12MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: a9caf9a4-6d0a-4b65-06ac-08dc85560f7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K1F2MnZpU1dNT2E2cUcvOXlLalRoQURXQ28zZ0ZiS21vSnFCRXA4aGtOYVE1?=
 =?utf-8?B?SXVuN1QxRFhVVFFxWW9nUll6RWNaNnFZNTZOQk1yMXUxYUFkcHBDN1NhZ0hH?=
 =?utf-8?B?dlZLNDNVSitkM1MvbWt4TWN0MWlRMHhUdGNCVXB1bGdGS3dkYXdsc1hFcWhF?=
 =?utf-8?B?YVV5eDlMR3VWc2xLVlUvaGN6bklhRFVrRDBDRlF6Uk05NVZWSVJFUzFxTk5p?=
 =?utf-8?B?WWQ5YVE5dThVYlJGSktBSmdlVHY4elNSMUFlWEZxdkljTS9ENmx4K2ZBVzhX?=
 =?utf-8?B?bFJhbVFzYUttRFFiMnFMRndJZUFjS2NOaU5acFRKbU41MW01eDVYZFZhU1Zm?=
 =?utf-8?B?d0t0YnpsQm5vVTJPMW5OQXZ6ZkZYQ2JpRVg2dmlibEdwaGpOYi9abnVCSUVM?=
 =?utf-8?B?SlJTKytnQjRRQnRlcm81YzkyV1VhdEpSUE9CbU5uQXFlbnJwMEhicFQ4QWhj?=
 =?utf-8?B?ckhXWGE5bWhuSTZPSjBjOW1saXJtWFhON0x3YjRPSVplMnZETnFXV2kraVpi?=
 =?utf-8?B?UmNSL3l4TlBlVzVic1Ava3NPZ09ncytvV2hFcEdVV2hFWnZwWUI2Qndsemxj?=
 =?utf-8?B?UEQ3SzRNUWFyWW9CTExQZnJTSGFNQklZVE85eFpSOENveDdJVWFjOUpSYzZh?=
 =?utf-8?B?Z0Y1Si9rLzJjWnZmYTdHRmQ1UG8vVW1LUW9Ja1hLZGZ4MlRWa29YSENLNzFX?=
 =?utf-8?B?OGtUZndMYTBndEExUmo3TXM2b3p3ZVBZZkRaZ3ZNWGZKSmo1QnhLWVpZSmkw?=
 =?utf-8?B?aFlUdjhaZXZRQlN0YjlrSnlxdFdiVGRJZ2Y3cVE3ZVhaNFErb2JMWXJDMENS?=
 =?utf-8?B?S3dzcE9RYkZZTE5pcHpjUkVKbnJwaTNGNExsL3FEcUhseDZnZnlJdG5hSC9a?=
 =?utf-8?B?TXdQdjhpRDNYVm5mbUpXS3ZMWmFKV2U4b21BNVBsYU9VVmIzN0JpUFp1UHVG?=
 =?utf-8?B?bjVYU1UxVlYrUy9OVi83ZUpPSXNWVy9oWnZSUmk2NmZ3RDFoRGlRRGRnZjN3?=
 =?utf-8?B?VlpXSUVxM0RSN1lWcEZOeUQwWkxGaEN0WXd0cDlHN1RmcDFMcGRleDNjTzI3?=
 =?utf-8?B?TFowRlNZeGFnamIwUDVneG5LTmxHYTVvY2l5M0xhK1huMDhCYnFsL0w0dGg0?=
 =?utf-8?B?NUJFRmJsbUkwck9xLzMyR2RoV0Z4NmVJWVVGUEpXc29UeDlNejJFcklzQXVo?=
 =?utf-8?B?RVhkZHArdHpQM2w2dnRQV1dCUWhFWUFETExxaHZKemNjeEV4T21DZ0VzNGlC?=
 =?utf-8?B?bkRnTWRBK2xXb3ljL0pmSEJkMjd4Q2w4eDNyL2lCV2NRQmdrQk1ld1ZrRGJX?=
 =?utf-8?B?SVNNbjVwSStxM3NzUVdNQlRoNktiZ244K3dVY1RmVW9RU3N0b1RGZVdQRFNy?=
 =?utf-8?B?akNucFRoR09MU1hmdmF5ZHF4c2xrRWNCSG1QWWFpUmNmZ3JmZnB3Y1JoR1li?=
 =?utf-8?B?OFlEYzZDMWlPRHNNSytIK0ZTRytWeEpCb20zbmZidENDWVRBQTBoTUUwOGVq?=
 =?utf-8?B?Zjk2ODVyV3YyUGhqejJXL0RuSi9CRkFaRndjMmt3RzZLWWJaN0pvV04xSFB2?=
 =?utf-8?B?YXVYeTNwUFVzMWlqajNHRlNvNDhZb2lSYWlwSHNGSDVybVhJUGZhUlNJSURM?=
 =?utf-8?B?OEg0Zzc5V29iejdiSHRsdFlma2JlUVh2V0pnSWw3aGJRdWtON0RMZ1M5c3Ey?=
 =?utf-8?B?MGxrUUpnMktqMXVGa1dqK0oxL3h5K0c4OWVlNjBUZHJPMUQ2UHpXT2x3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6460.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWgwOEhDWHNyNTA3N3ppd3ZjN0dqT2poTytBTVc0VTQ0NXJYK0JXMFJFOU5E?=
 =?utf-8?B?YUkwL0xOSXlaTVpRZGJtaHNTRWhKZ0crWHlqYjdjaVFmK2pzNzMxa296bkp4?=
 =?utf-8?B?MmlxbnFYdHNMYkpoeStDcDBQTDBWcUcvOHRWbHVTYmEyaEtnSVdJbGJ4SitE?=
 =?utf-8?B?djhOUklpUEM0eHA1SnYxTnRLNXFFYWhCdmJPQlY4aWhNSThxZ3JJcFhnY0VG?=
 =?utf-8?B?amRDY083Tlk1enlCcUVHRkdYbHE3Z1d0VXFTcVhoaC9SdUxpclRPKzgzUkRQ?=
 =?utf-8?B?b01qRXpBZUpnbDNPcGpXQU9jbzJNdkR0Rmtza0hEc3V3ejBTWmdZZHhTZmdX?=
 =?utf-8?B?WVdPN2tmZjhJM2xuMmdQZ1ZJRWJzdmdWeUFDOCs0NGloWWlrSmV5cGdocEsv?=
 =?utf-8?B?SXJqbEJsWXFROVVXMkxSbzhacWl2UVZ1U01YbXlwZW9KRXhKZE1JcERwMFlL?=
 =?utf-8?B?M2M5WkRua3lyNFVvNDhFT1NBUFVJLzhSWnBwcFhSTnZRZ1Viajd2RFJTcklO?=
 =?utf-8?B?QWQ2eTN2S3BRMGxVN21aUG5MVzczUDUydjEzVjg2OHdOVjkxYkxxR2ZrK2pC?=
 =?utf-8?B?SlluLy85eG1pN2tUZTBpTS80VlhJK0dvamluNVllOURXYStMRk9BcFJuR1lo?=
 =?utf-8?B?dVU2b3pFNnZpbGQ5RzFtVjBiOVppNGlndW5qeUZDS3pEOG9qNXo3TGQ5U1F6?=
 =?utf-8?B?VVdKKzFnQ0Fibk84ekJKbzJzdGpaT0t0ZlREbGVUYm5uNW90SUt3UHNZY3JJ?=
 =?utf-8?B?enFuakwrTlVhbU4vc1FlblMwdWYrUSt1MGRzRk44K2NqMktGVWloMU1NRzdp?=
 =?utf-8?B?SHpOR3dwTDBLZ29Xekt3US9ubWFiMHhKQnE1SzBUSFM5eDNTTkkwb2FUNUxp?=
 =?utf-8?B?TWdDV0V6ZXB0NHNZN1NyeTFxUWpSTEZndFk3ZGRwUTFOeWhXUndSODBvcGY1?=
 =?utf-8?B?OGpYRHB5QVBLbDlqYW55M0xrdnY2SWt5dU9ITU8xcXFMQ21OQTd5d1l6eVVh?=
 =?utf-8?B?eU5mSTJLSmF2NDRaMnFHbXdLcTBEaXVaT2NyQis1bU9SZWNDejFiUDRjZzds?=
 =?utf-8?B?NVE2U01wQkNvaVNTMTNyWDc4MEJFYURmZW9RMU9hUENvRHNkTmtCY3ltbzJt?=
 =?utf-8?B?bFIrSkRtRWRkbzV6UCtkT1pRNkF4UklQSjYyclptamxOOTVod3lqY3RiOG1p?=
 =?utf-8?B?YVZaMTFDYlloV1NYb29rUEJjWnBHZ3NTZjBrWDE0QWNWNjc1aXFIQmYrSWpO?=
 =?utf-8?B?aFZuK2U2WU9LSlJuTjNJT0VIY1VYbk01bWZMTTJLYTd6RmsvMG9TQi92MTlV?=
 =?utf-8?B?ZlYwSjVJeWMreEx5N0NCRVBzQ1FQSVRFTTkyRHMvaWxXKzY0VUo4RVVPWDZY?=
 =?utf-8?B?bEtqN0EweXF4OGFGZ0srWC9Ra2lTU1V0ZFJMaHNLSU5nUW4zR3J1VnhYWXJQ?=
 =?utf-8?B?WERCa0gxOWJNZGJld2U3QmZwYVNtdnpPK05YL3Q3VjRUcTVTWGs5aTJ4aisx?=
 =?utf-8?B?aXBPMENVR2xyZTUvKzQ3dWIybUxMOVEzeXBBNW9aMW01UmU1ZTVCQTdOSFNQ?=
 =?utf-8?B?Y2NGYWFLa24vbXF5a3A2bWJYdEZFUjg3aTJIQjlMZ0YrdTBPM1dlZGszZWcz?=
 =?utf-8?B?YU5PcVNpZURsNEdUQkV2d0ZJOXV1SFMzQTNHcXFGVlVzV08ybXFRZGNYWk9L?=
 =?utf-8?B?TnpDbjhRTnAvNHN2UUdZb0hvTHRpVkpqVnJ5TkYvRVowQXhLYmw2djJESEky?=
 =?utf-8?B?RjNWOUllQjFKZUI2c0x4WWF6UjNaYkpkNjJrc1QxYXY5M1ZJMG9aRDJIRjVt?=
 =?utf-8?B?cENRaVNidEpzT2R5UUxSeU1RN0k2WUl6WXlLRDdsZG9QUkkvNE80YllNNXM0?=
 =?utf-8?B?M2YzSmZaQmY3Q3c4bTdHMjhHaVlCeEVXVmRyQlZFUGFxT3hPMjZkV3AvNWVW?=
 =?utf-8?B?Z2tqL3RmeGs2WWtrZGFtWmZneldlcElMdldDcWIzTEUwNHE2UlBuSWZza2Ju?=
 =?utf-8?B?TDJRYmNBNDQzRnFDR0wwM3puVWl0eGJSMnM4b05IWVZvMGgzQmUrQ2d6TTRG?=
 =?utf-8?B?ZlVWaElCeDQyK0pxTTlFZzU3VGhzRlozR29GYVlsWUNxaE9HNVBCdlBabW4r?=
 =?utf-8?Q?M0XPS446+K7mSQWc+TGol2RG9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9caf9a4-6d0a-4b65-06ac-08dc85560f7b
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6460.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 11:53:05.6245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qydye2ADMlk9kQEZT/TKdsYbp+JGe2WQ6ou2DWRR7C9UOnsAKDPXYfXW3EXDgnk16dtHp5B2hyKtv+HakrBPsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7795


On 6/5/2024 5:18 PM, Ravi Bangoria wrote:
> SEV-ES and thus SNP guest mandates LBR Virtualization to be _always_ ON.
> Although commit b7e4be0a224f ("KVM: SEV-ES: Delegate LBR virtualization
> to the processor") did the correct change for SEV-ES guests, it missed
> the SNP. Fix it.
>
> Reported-by: Srikanth Aithal <sraithal@amd.com>
> Fixes: b7e4be0a224f ("KVM: SEV-ES: Delegate LBR virtualization to the processor")
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> ---
> - SNP support was not present while I prepared the original patches and
>    that lead to this confusion. Sorry about that.
>
>   arch/x86/kvm/svm/sev.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7d401f8a3001..57291525e084 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2395,6 +2395,14 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   		}
>   
>   		svm->vcpu.arch.guest_state_protected = true;
> +		/*
> +		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
> +		 * be _always_ ON. Enable it only after setting
> +		 * guest_state_protected because KVM_SET_MSRS allows dynamic
> +		 * toggling of LBRV (for performance reason) on write access to
> +		 * MSR_IA32_DEBUGCTLMSR when guest_state_protected is not set.
> +		 */
> +		svm_enable_lbrv(vcpu);
>   	}
>   
>   	return 0;
Tested-by: Srikanth Aithal <sraithal@amd.com>

