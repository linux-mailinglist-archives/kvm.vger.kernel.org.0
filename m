Return-Path: <kvm+bounces-17744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 095738C98B2
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 07:05:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 838FC1F21591
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 05:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA1814005;
	Mon, 20 May 2024 05:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IAn7L74p"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A5CDDA3;
	Mon, 20 May 2024 05:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716181494; cv=fail; b=DkrEhGVgKuAMfV6fa1480BsV6PLnH489L6wLt5ZQ2/mx0CuwmsiqUWSNFTQO8J4q4qMqHpp0+CkpKdHDeMdxoD6nkXjUG8FCtVzQuFt5IWN/lzanC/l9WK+TZnN0ISmkguG+gnjcKjZ2oUlalnO3RTegSviJ9xM0nKeOelBWKAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716181494; c=relaxed/simple;
	bh=BA1GKi/roMAnzFtcCE5qPmBb4nbXzQHdl2RUkB123II=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uDUPLoP/qzZ6u8HIzkdJtNhSfEwCI7RZXmiCB5hndL8tMOxFp/u7ELKDMaERQ723gAj4rR+5IWWg4p6BXcSEmRtx3Myiy9rrjPCRiUTyOMPtjnZwoCuFLrQSqJF3AqHFJLUBSZzT8ktMgShIxlzYgym8fl+j5njv1TcwAtmDL9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IAn7L74p; arc=fail smtp.client-ip=40.107.92.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dW9lPa2cEfRXzSzeuRdCMulm8T4/bZbk8cztdD3rPzc2jHgjKLPFKtXTPMCf8ymgqrL3SYqTkkje4IGsosPR8ffzQv428Wi0tw22R+kEOHYsVPWGvSsoRse2BsfNP+ZJvBEFJziK4PGBiDZBayZEu4SUZGzGnvHG/EEsejH7qJhRDkZ9sYObmLEpE393Famuh8c7K9KoeU/TezSg/niJm5alHOLOQU+HPFH2qHSk3P1zqtFawUSWZYG90qyqTJh88OVMFmnmtrjLe5AVSWBZNg6TLCeL+1R+cmAQnHEKZr4U0tK4WN5O30pdHHmsFQDpDI8xg5ndG13JhHbM1jBB+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LPj5F/SpSY6kXg5u8J0/p8dL6qZNT/hrOYfccgnU98M=;
 b=TGKWFRN1B7IoZu7mMjnZcjctAhDI+5tSKPdsKHykUtXAM5GzSzExQhovkgIno+fIhR7hnGstKiKnh4DkJknziFam1nDSQ6NEfxnKJp+BFBAR0CF9dzs5Gb0bILnM8G2gF5HD3j2xcDAe5pYIZZ+pmgp1Ft72WEWLO52z53J7sPI4uXok6cEMzhh67UDrflbITRZvLKZkGQiblC0PIDYNc4Not0sLvIPfkAwURNVBmBoKk46h/9h60hDZEKeua46ktpi0wpqabM52hrXQTj1yIZQ+/Z72mUWVZIwsUIkoRtNq7SIEwEFVM75OM8PE/0yhG3u8/hcluQILKHoND0rKag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPj5F/SpSY6kXg5u8J0/p8dL6qZNT/hrOYfccgnU98M=;
 b=IAn7L74p3J/rUw328EN/E//5Y/EOQYw3HjLi7uk5cijPbi54OJ95qxGRmcSWdOSTSGsA7KKJj501ZwipsQH3emnLKD6GVO8UHPVAcLAr4z/AhKBuN7Zo6nwd0ENb5lO6VSXQDtj+jpag5ZEMCBgBCV5FmFsaZ9M1n5YDnI9d9y4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by IA1PR12MB8287.namprd12.prod.outlook.com (2603:10b6:208:3f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 05:04:49 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 05:04:48 +0000
Message-ID: <b66ea07a-f57e-014c-68b4-729f893c2fbd@amd.com>
Date: Mon, 20 May 2024 10:34:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From: Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, michael.roth@amd.com, nikunj.dadhania@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, santosh.shukla@amd.com,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240416050338.517-1-ravi.bangoria@amd.com>
 <ZjQnFO9Pf4OLZdLU@google.com> <9252b68e-2b6a-6173-2e13-20154903097d@amd.com>
 <Zjp8AIorXJ-TEZP0@google.com> <305b84aa-3897-40f4-873b-dc512a2da61f@amd.com>
 <ZkdqW8JGCrUUO3RA@google.com>
Content-Language: en-US
In-Reply-To: <ZkdqW8JGCrUUO3RA@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0090.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::19) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|IA1PR12MB8287:EE_
X-MS-Office365-Filtering-Correlation-Id: 80e61ab2-a77b-46b6-5723-08dc788a5f7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TmtCa0pmRXdUd3U1UCs1dEs0clYxajhoVW5yUzcwZ3VkNXpWbTVneWliUjVS?=
 =?utf-8?B?dlFFWWUyVU42K1pKaTBENjVhS0lEbDd6d2xSVGN1RllaRXhFd2RBQXZZTVUz?=
 =?utf-8?B?Z0d3U3kvV1g4cjFLOXgwYllMak0rRE5OS2tUdnRMbUFMYmtlY1p2TUUyWlBI?=
 =?utf-8?B?NWlCZXZyQUJ0bXBpejVnWGlOVjZySTZ1L2cyMkt3K0dyYUpGN3U4YjhIVXZ1?=
 =?utf-8?B?K3FkN29VTTArL3R4dTFlSW95UTkyU3NYR3lueEkyY2d2U2JoNGMrVi85THQ4?=
 =?utf-8?B?aUx3OGlJdVl0YkJkQzJZdUVsNFlyZEcwMnlPRGJ4UktMeFNPekFjZXRqNkRV?=
 =?utf-8?B?RlNvK2VUNFBwWXdGNEphbHM4eW1kWDhKWWdMVEFkbEJlVHJTY2paS1I3Vkcy?=
 =?utf-8?B?RXZTOTVXRHEzbWVmeklZOE0zc09xM2hqSlpoQ3JtaDFIanNFOXYwam0xN1l3?=
 =?utf-8?B?UU1LNHJhRm9yb1BHTzZVL0psRnNFOGZGbFJHSjVBQ2Y5ZC81VENOSHRENDUr?=
 =?utf-8?B?VmdyMnQrTXphVTArSkFxVUpiR0dQK3B0YmN4ZyttMmxBcmJpU0lxMEhrZzIz?=
 =?utf-8?B?bWJ0MUk3STk2UzVIL3M4VmtsT0llSEhuV0FoMFRBUXB6c0VkRkI2OHpZeWNw?=
 =?utf-8?B?SU1iYjBkRHE0cStaNXpRcXVZT2NGRGN0bllCQ29PTUtESmF2ODJtbkpkR2VF?=
 =?utf-8?B?enorazVVbWJGeDdydEZVQ0RpeUI3c3p5bThscCtwV3VBUGtlUVhQL1pmVkxm?=
 =?utf-8?B?dTk3dU9xbnBYRTBXenJEQm9mR0lValR3YVVIZXp0OVlVb3hab256VG5YZm1s?=
 =?utf-8?B?a2FQK1d4Zk5TMThZVEZKV3RCLy9jVzNiVEI0aUQ3cTlVKzBMd01xTWo3djR4?=
 =?utf-8?B?SHRVc21ta0Q2czdxNE1MaVhKUWlqYlBJR09NYmRLbHk1Q2JOQUZyNEJ1QWV6?=
 =?utf-8?B?UXlWWXdNUjYzaHFIUGRiUUd6SUZTNzNMQURJdVdIckovbVRaWXhNSjFiYjIw?=
 =?utf-8?B?b0taejBJeGlzdlJxMVVPbHhOUTJ0WkhTeW5BOFJpa0oyNTNBUmMzNy9ZOWNR?=
 =?utf-8?B?VlAraWc0ZTQ5cStOdXRiRE1UaUVqekZzcW1BR2lkQ1MzOHV0M05jOTlCbkRM?=
 =?utf-8?B?SVZQVHVqaGhtQTZ3eXdRUGRraEU0Wk5ka3dRNDJENWFCNzA4bVZla3o4Tm5u?=
 =?utf-8?B?SHA2WkNoTnRtMlJuN2VBcU42ZWhKU21CTHdnSE1YTjlSemE1VXVZRXMrRVRC?=
 =?utf-8?B?YXFWbzZPS2F1RHFaT1QrQnRBc090eWZpaHlkVWZxQU1pdGo5RWRxRUJBejY5?=
 =?utf-8?B?cUNUanhDcmUwK0g3ZVpJUlpwcU9xQnpPQzNhUXBuM20zM1RGNlViSVdaVEx0?=
 =?utf-8?B?b1QyWWJ2bXd4dVlrRG53ZVFwbTBrd1FpWnc4U3JqMmIyazMrZjFOYTI1d2s5?=
 =?utf-8?B?N3RZeVRYbHlYN3oyRzRCS3YrM0VqWFNleW5CdHFZdTdsdHBsemg1S2xuRmdQ?=
 =?utf-8?B?dmpBVkJjR3ZtV2FrQW1sUTVDb0J2c2NTSGtxb09PTERWZFBJVFdXR1V2VlNr?=
 =?utf-8?B?OFc3YkoyUTFtVlJMdDFYU0w1cXFwcm9lN2U1RnhuQndDaWpYSjBpUWRkU2Nw?=
 =?utf-8?B?ZlNpRjlmbXNBWlQ0azBGRllpZ0pxZ2wzbDVpZlpLOFhSMmtITHlTNTREalNE?=
 =?utf-8?B?eXpvOHdWNU5CenhCdFZDS3M1TUxiQ1BOenJrNlBnVGt2M29mclB6V3F3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkpYczdXRlVtQVYvSVpqN05BUUQ1d2xVcjZXVUZXNitXMFVIRFQ0dzNHOENT?=
 =?utf-8?B?L2pacm51WFNqNEN3UWpyVHlZQ1R3dlhhNENLbHhUd1V3c3QzeVhIcGJjSVlE?=
 =?utf-8?B?d0JSaXphc2FtZ1c0TUJ0ZWZHbThnbkxtNmJkaDZDOFl2WXl0Z2lEUDdxMmF1?=
 =?utf-8?B?V1VxcHBHc0NhRzc5YUVLbXBUOUtoUlA0QUpJRXN6YWVKd1hOdExvR2cwdWxU?=
 =?utf-8?B?dWJrTWEzTDIyY3Q1TmxJTDRrYlFFTC9COEF5SDZLZW1oNUQxUDBjV2w0SmdP?=
 =?utf-8?B?UDhoUzNsM3F3V0xneDBTQW5RbmcrQVBXaitVbUh5dFhZUWZiSGtCR2pJZnZi?=
 =?utf-8?B?aWNMQ2JwZEpsRGtibjNyMDROd01FYTdOODlUbDVDQm1XUU5jRGtURENZblZD?=
 =?utf-8?B?OWh2S2U1eSs0czV4alFZaXNaRnZXazFmZk1NOHNuZm0yRE1lYkJHOFIxZTh2?=
 =?utf-8?B?ODluMzMyZ1NaUGM4TFo1REhicnJiSTZ5eldMUFk3a1hMTU5xZ3ZKemZSLy9W?=
 =?utf-8?B?T2FvSytXYVg5V0xIelR5UzRGZ0czcEYzZStma2lYM1puR3JmR1Nyc21ocnl0?=
 =?utf-8?B?dElXUHZUcm14Q2xHT3RjNU9OeG9sdXdBa0lYVk5TREVFZUVoZWl4VWRRMkl0?=
 =?utf-8?B?M3pKNko1V0V1T1FpNUlLSVM5aW1tcXRkMm03UUs0alM2Y1FpNUJYVkZJQ01X?=
 =?utf-8?B?ZGtka1BtVzZlc2QzeHRRQVlEbTZ4aTloRGNTUEtZNnVmRmV3Tm5qdE9QcjFH?=
 =?utf-8?B?ZVQ5WFZMM3N2OFZIVG16d04vUTV0em90MFBzRGFmT1Jxa2pVWTRqdkFkcDND?=
 =?utf-8?B?d2VVWHh4dDc5K2UvQk4vOFg1UG0zU1pCWXZnSWhlZGJJaTI0OUY2VXdXRUYw?=
 =?utf-8?B?WGhYU241QUFvUkRTVkpEbFQxalhISEpVY2RrVGdHL1J1NE43RFBuTUw1TWpQ?=
 =?utf-8?B?ck15NksrUjY2T1ZwalJoTU1BaVNTMUJIb2szWlN5Y1RMNE9yUm1GdDlmOEli?=
 =?utf-8?B?bzF2Rk9BWTNieVVTU09RdFdrbkhMbWpjalJKQU9qMlAvRkVDNGk5eC9rOW9w?=
 =?utf-8?B?WEZmOHMxcldxZDI1M3pyRzdKR2dtWnVFM2dCWE5ZTGtONWZwL0F5cFdPc0ZO?=
 =?utf-8?B?OTdld3krbzJZa0d2eFYrbS80KzQxSzh6TlZlQnYva1lUNWxVUTJ1OVMwaEkv?=
 =?utf-8?B?czNPOEtvME1ETmx2MDlybjkrdGNhL2dRVEZkNWNJUXFZUTZUME9acEE1UFNk?=
 =?utf-8?B?VnFMNDRta0JRQkRmUTYzaklwM0ltcjIzaTZvVmZERmluaTRZdk0xNnFVc1dE?=
 =?utf-8?B?QUhhN2tzSVdaWkk0Z3NXVEFjOWhZTzVOeHZrUlU3cWNDNjJMaXNvL29KaCtP?=
 =?utf-8?B?S2haNkYzbHYyOEtJZTdRT203VlZmdzJsWnMrSGlNWHRvNEJMNFV6aC9mbmh2?=
 =?utf-8?B?QkxheVVMbmlueTE0S2c1amh0Smd2bndRMGI5WlhEbXF2MEQ4Q05Jdll2Wnp4?=
 =?utf-8?B?K2o0NmNtTEN4OHFTaWMvWG5Ya05UbDlKcERGSmxHaUl2RUFvWll6dDl0OWZy?=
 =?utf-8?B?eklYTzRVbHhZYitEK2ZTZkp2Y2pxakRla0tEYjdaMys2Y0Zab09kaEt2c1NC?=
 =?utf-8?B?bFl0d0h6YkQvRytWZ0xmcjJ4Q05mdG1WbzlxVkdIdWpidE9yamtTaXBLTTAy?=
 =?utf-8?B?a1lscUhXSTJlK2Rtb3VmYjF1SG1sazdjcE5wckFPbkZqVms4OFVLcHp1R2Ri?=
 =?utf-8?B?OEVySzNLYjdXWE5LNmpwVnRHMTl6Z0FwcGZSL25iVDZpcFVrR1NXQkdrU0Fh?=
 =?utf-8?B?Ukh3STE2SkQvdzZTZzZBaU9rSUhFYVNSUGF1WWQxKzdIc1NlTTU2OXcrOCtU?=
 =?utf-8?B?TGIwakxkNS9MQmVJM0R6SlRGdXMvNktITUN0K3F3QWxsNnQzVTVDMGxSbmJ5?=
 =?utf-8?B?K0VHdGVHVzNuTVlxeUZQZ2Rka3BBSlloU2JNT2c2M3lodFd2VjNQKzY4dXky?=
 =?utf-8?B?VVBZZ2FCN3VHY2FOZ0hiQ0trTjROZENlck9xRjdHWksrNVZTck53d0tMMEU1?=
 =?utf-8?B?RUdXNVlaVlJCM0FOSnRkSHJscTdPNGpUOG1OTmtVWjBENzU1RVduMFp4cy85?=
 =?utf-8?Q?bC9heAfvgryvTPvbo/vHMG9li?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e61ab2-a77b-46b6-5723-08dc788a5f7b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 05:04:48.6366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ePJSWs3XLZ9jWs6amRfrNsvCe24IS4BwB/bS8OXWzsmABmB1F9VS4Z4S8ELY67lbVH6g1iOV+D/1OKburmWOBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8287

On 17-May-24 8:01 PM, Sean Christopherson wrote:
> On Fri, May 17, 2024, Ravi Bangoria wrote:
>> On 08-May-24 12:37 AM, Sean Christopherson wrote:
>>> So unless I'm missing something, the only reason to ever disable LBRV would be
>>> for performance reasons.  Indeed the original commits more or less says as much:
>>>
>>>   commit 24e09cbf480a72f9c952af4ca77b159503dca44b
>>>   Author:     Joerg Roedel <joerg.roedel@amd.com>
>>>   AuthorDate: Wed Feb 13 18:58:47 2008 +0100
>>>
>>>     KVM: SVM: enable LBR virtualization
>>>     
>>>     This patch implements the Last Branch Record Virtualization (LBRV) feature of
>>>     the AMD Barcelona and Phenom processors into the kvm-amd module. It will only
>>>     be enabled if the guest enables last branch recording in the DEBUG_CTL MSR. So
>>>     there is no increased world switch overhead when the guest doesn't use these
>>>     MSRs.
>>>
>>> but what it _doesn't_ say is what the world switch overhead is when LBRV is
>>> enabled.  If the overhead is small, e.g. 20 cycles?, then I see no reason to
>>> keep the dynamically toggling.
>>>
>>> And if we ditch the dynamic toggling, then this patch is unnecessary to fix the
>>> LBRV issue.  It _is_ necessary to actually let the guest use the LBRs, but that's
>>> a wildly different changelog and justification.
>>
>> The overhead might be less for legacy LBR. But upcoming hw also supports
>> LBR Stack Virtualization[1]. LBR Stack has total 34 MSRs (two control and
>> 16*2 stack). Also, Legacy and Stack LBR virtualization both are controlled
>> through the same VMCB bit. So I think I still need to keep the dynamic
>> toggling for LBR Stack virtualization.
> 
> Please get performance number so that we can make an informed decision.  I don't
> want to carry complexity because we _think_ the overhead would be too high.

LBR Virtualization overhead for guest entry + exit roundtrip is ~450 cycles* on
a Genoa machine. Also, LBR MSRs (except MSR_AMD_DBG_EXTN_CFG) are of swap type
C so this overhead is only for guest MSR save/restore.

* The overhead was measured using instrumentation code, it's not an official
  number provided by hw folks.

Thanks,
Ravi

