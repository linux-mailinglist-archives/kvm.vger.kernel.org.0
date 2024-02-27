Return-Path: <kvm+bounces-10148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D36D186A253
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 23:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0377E1C25ACD
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 22:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FEC1153506;
	Tue, 27 Feb 2024 22:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="miKLOaTg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5591C4CE17;
	Tue, 27 Feb 2024 22:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709072448; cv=fail; b=PrRtjtHGGLotoVwVT/TUQF1/pYmSgdRE2xBfFC8gCHZgLw8uS9YGIR5LDdQINHJPlziUne4zLpiEYASxuK0JJ79vZGjcdT0BhZH4di6zaZm7dAeDdK4FzFEa/OOADfkcuuX+JpqXc2MTEZdsH/103JQ/I3CVQU6xmRRyxDiT0yU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709072448; c=relaxed/simple;
	bh=ztG35l95TCV0FT2RL0MykHSkgOD+fBGs9eHV9tDXKi8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Zjr+qN3cAk+B2aJn1jCSJ2kjdLuV8bLR8i3qXYQc117CYAiNnE5WR3LmP4PHZznjVDq2hKCLlBIQh6wEOnXRMKJ9yd3+eo2kDpZtSpP4Q8IG56ZMg0NrgrsdDPf0nUyXD7g49ST2oNWONuGEOz70PnpKCccKH3v7a7mJ81siXjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=miKLOaTg; arc=fail smtp.client-ip=40.107.237.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmHkCcItlN3K4ZI0UsZIo3R/eU2+3ORj+V/Yz/UGpG0Jh47pq3cTmPe1kXepErVwC3zydaZJS1glSAaG/g/WVLE+qrHyO8ACURX9ZDDmu8OTMtGmL0FoFQamiWaHbJndGMzQ01T0H6nuJCMq+8EMkNOuJ0LHHZmL9F8/ZIWhG8+vHi0455vSElbAQEbhuAq8zKSXjLLGmAjbzgEap9Z59qSflhFZqKrSkTrVo8ClrBLn39NKDzGfGh4eq5x9K4qY0k+D79y18hTmuCshgNfm+o/W72xFiGx0USiZHTQnmQWdQQenk0BziyNkDZjCsUVoIblsAezBUx6Z9gmGr39W+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4KCXbxR8CU77N99u9D0BrgHszm/NV+tmaOM1Ka8pxnE=;
 b=AAZbWFnsu8AxLiDoj3aIHSQi5aRrQ+Bm6DkF393ozbEDTBJBBDxe5Vj1Erwuwb5QgihSgg3XwRd31AGUK1FG1qrJ9g0G6BHP9XJFTCrYgBdAqqP6o30WJFzdtdHi2VfkKt5jo6uM+hTxhzIPXymcWNa4lAfkw07jongYnEw96VKOZWfHOIg1BBqJgd6vfRlVJYP0WF0XqMjkSzd4I2MrpnD2PBcLFpCR+FDQ1a1ARUAyamCcEtkEYPqSY78gJxrNuqawoHYIRIRCzjxXQiGiSY2pWCpMUtcswdrS2OFf6wZQlS40mww8ALOP9qMTAJ2t1UP56KdUtj5kBAOdGMamzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KCXbxR8CU77N99u9D0BrgHszm/NV+tmaOM1Ka8pxnE=;
 b=miKLOaTgiIDVgo/GjbdhH7MoTvBlURqjB43hpRi1raOuULEP3HP7GkCCKJCe9HZZRTUIGNRCeCCvA5By96Xx9i+wG2czQdWfBdjyhBvEy2Idw/U3QmAeEWgKjfy4ZgPr4niOGHlMddlAs/PQk89z7ROj/dOy0iJiOECh1i1aSHQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by BY5PR12MB4872.namprd12.prod.outlook.com (2603:10b6:a03:1c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Tue, 27 Feb
 2024 22:20:43 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e%7]) with mapi id 15.20.7316.035; Tue, 27 Feb 2024
 22:20:43 +0000
Message-ID: <c03f15aa-6606-4aff-bcec-2e29e0b36d9f@amd.com>
Date: Tue, 27 Feb 2024 16:20:40 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/16] virt: sev-guest: Add SNP guest request structure
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-4-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20240215113128.275608-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:5:40::32) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|BY5PR12MB4872:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fddd7f5-1a8e-4074-060c-08dc37e2568c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YjC0+fT2ifU+yGxiM2dnT+xBx+iNhK+xjg8mZC18yb+55+5AUY8IoCb+LKbvE7zeaqVfCCCJ73yf9z9L8yn1akdOL0dx5iVvEhfYwQHd2E1YGXm8XD8tEwKiRVDS7qa66jtqIhMBqJKfvvVgX20iMasEViGQdxO/rgx1QOJDycIliRf4GXiojZb6uOAV/pdVRY1Ly8SKx6S7ZTN/v/3cHW+wKAAphNIoQqBuB3QE6vsRDHaH0O1EC4Vfepm2BeGGcGjnpHnY1K/wqXQKTjI1mGJt4rhorbtKXpKvKh3HWRkRz8UHmoLqDwJQlAX9V1Nee1e3NoAeAyCOfs8E2xLWGOWlpHjT3Kw2n271ZGSG10VpPkCsa7KrCRQ4fhi+FPMDe4ZuKSW+Wt74Z0uBxdKSzS4v8cfLoVHYWYvBQ58sroR4wI5r7HHLvQs2i1nG+4XeKG1pplGPE1opq8rmd1jXr02IJzJpO2khyxViRFLgU9iB4vwBzybQxG7qEga1lpNEiR7FLqY7ojY0bkVDqtVDUmhJX2SpEzm/7EOCZmTmtpv2fCv0UVSsBXSpVtUwLWrZsY0fTuyqv5fKRg7Aj+qPE6YWL5DAwhecKJiOmvL0rC06U6AojPs+i1DfkXNpH9xr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czc0SnRBNXBBNmhaL3U0bnVNcU1yby9LZFhvbGNZL1lmc0RaNTEra0xySzVo?=
 =?utf-8?B?ZTByNUx5ZWFzY2lpdDVPblVidFY5OWs2YjB6ZUdjT2FEcERoVm1GRDc2UFZD?=
 =?utf-8?B?OEV4Q093c3F6MWxwWUtxc21EZGMwemJnZUJiazA5OGhBV1VOMGIwSWRoV2ZS?=
 =?utf-8?B?MjQ3MXpmN2M4QXM0a1M1UDdvb3FBeWdQZktSUW9IcEpZYnlIL0s0T2dpWUtE?=
 =?utf-8?B?bEJnTU9mRS9TK2dUK1pvMWtvdHY0dE81bXloc1FvWW1QSmlWWFpISThOS2Ns?=
 =?utf-8?B?QUZRZ1FZTi9IUUJsUjNWUnJyRHo2OFNLNVB1Rk41ampVYVdXZXNQVFJzdTdT?=
 =?utf-8?B?M01rWnovRjN2QjZkcm1pTHdJYlVMK0k4SU5ZWi9kZ1k2dXZUUWgwdytVV3lF?=
 =?utf-8?B?M2diSTJiYTUwQ0g3dDEzRXl2cEJ4RDRrdXpIRTBuaTBtbzQ5WUFHZ2ptL3Bx?=
 =?utf-8?B?Y3huVkhTSWlVWUk1c0xqRzJvK3JqdUNXTWJRVzM1SlNUbWVxSGg3K1BnTkNE?=
 =?utf-8?B?cXBLYmcrTS9QT2xzQm0vUmNmWjZodnpRZjNDVVFQQ25JY0lvanZTYWMraHMx?=
 =?utf-8?B?SjljVTJib2x5d0w2RGlzNU5FUDR2ekR0dUl6aGlNL1o3ditnWFZSQ1I3WTZa?=
 =?utf-8?B?ME45QWZWTCtYTGpqUzVXckY3OTFsZTRwejRiK3FxMXlLV1ZDdnROSTNKR2F5?=
 =?utf-8?B?dXRuTE1JVU5Qd1FsZWhNUWs1bnZWZGxBUVliWVU3a1lvRlFsdGs5Q2VEWG9v?=
 =?utf-8?B?Sk9Icm0wbnhTbitPUExUNUFIOHRzOTFuQTFoa09icFhUSkMwOUFFdFJ4N01j?=
 =?utf-8?B?c2dVUUJ1MWZMRitWRWlKa3pyVGJVRW8yU1JObDZDWWZWQkluY21Bb3ZOcFV2?=
 =?utf-8?B?a3J2K3pNYzFoWGFBY1hmMU1qcEpjT2o2L2prYytWNzRFY2FGWmgrQVREQXYr?=
 =?utf-8?B?YVhFa1lzdkl5Mkx3dWQxaU5Hek9mWDdtYVlUbXJ6dHBMelBOdnBjdkc2SnJ5?=
 =?utf-8?B?aHc3NEVacnRnVVFtZUpRQXZFN250VC9BQ3ErbUpTaVlSRnM4c1dxTG94amEz?=
 =?utf-8?B?MDFZbGI1Ni9WWHg1cFBwQ1Zib21mODlLMEsvWFo1WnRCaFlIaGEvMUNjeTVG?=
 =?utf-8?B?M0QvVmpac2EyMnhmbHBPb3Jyd2ZybmhBNStRck5meXVsZEc2cUlSOUJ1MklF?=
 =?utf-8?B?SVZGVmRVSlM2dFFwelBrc2tpV1cySzNiY2xBYm1YVy9ZSExEaTVEaVBtNXk0?=
 =?utf-8?B?dnA1TDQxR21KNHZQNTNYNk1GTWdGek9QMXgrMGFGeGhZY2MyN1Q3RVFIQ1Ax?=
 =?utf-8?B?NVBLV2xJL2RBWE9WWmdSTGc0OFdWSFJFb3YrSzZmR2oxZUh2aE1jV2QvMFds?=
 =?utf-8?B?eVZ1TWh4aTZkcHNNU1YxM2ZVS2VuajZXMHB6QU1XQ244Q2Qxd0lOQmtCcnFv?=
 =?utf-8?B?UmI4aENNcmczOVdOK0U1MGJmTzdZbTNZcUQzYXQ5ZzZ3MHJKcWVOOEZEZ3B0?=
 =?utf-8?B?WXEwbFdzaThvRjYvOGNrRitPaUdaaGdLY3AzWS94d29VVmRkWGkzdXFZWE5K?=
 =?utf-8?B?b1AxdU1SVHFPUW96bng0L2ErRFM4WkNWWGoxbjhvZ3N0UnYzTXllTGxHaGVW?=
 =?utf-8?B?M0JBdGJyd3UzUkwvejAvdmZxOWdkeXNvNDRUaTdoTWwvVXVzWjJRYUpWRmsy?=
 =?utf-8?B?aUhlV1M1aVdQVmlsTG1QelNScGhqNXhYMW5WZ3hBSis0ZHdUY1ZWTm9IVTBV?=
 =?utf-8?B?anVNeklma3g4bEIxTi9zbVVCWnFMdDRvRzhRZ1ExY2Rmc1UxSnpFSms5N0FM?=
 =?utf-8?B?ak0wRjdHbHRGV243UUFVQVpOanFUVWRMUVVCRUdjNlowMVVrWjVaQWE2T282?=
 =?utf-8?B?b2sySW9WUmdUNjE3aHZPNlZEQlUwOHdIY2VpbjhEOGJxbGhjcjZaUHZhVzlE?=
 =?utf-8?B?V2RpaDhzbFFJa1ZSUjEyaUhZWHlWbjBhTkRDaDFKVDBMMDUvcmV1elRSbEQy?=
 =?utf-8?B?NldpUHBzQXN6UitWVFZWbEkwb2VjNUhRM0svbm50WWJJWklvS1Q3cG5pSFVV?=
 =?utf-8?B?aTd5ejFVN3VQWVprcEE3VnVYNW00TnhlWVljNURlYXhneXQ3Rk1NcDVENjBE?=
 =?utf-8?Q?cb/DM7Afxb1naxqf4xER4Ens6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fddd7f5-1a8e-4074-060c-08dc37e2568c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2024 22:20:43.5049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xtfl7cAD8wxj39yt246ItgybljJKRfM2ZVc4NFgnl5vL8tUKnNGGO5K9iSq9h2a2eXAgASfxArjQIshMFonDKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4872

On 2/15/24 05:31, Nikunj A Dadhania wrote:
> Add a snp_guest_req structure to simplify the function arguments. The
> structure will be used to call the SNP Guest message request API
> instead of passing a long list of parameters.
> 
> Update snp_issue_guest_request() prototype to include the new guest request
> structure and move the prototype to sev.h.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>   arch/x86/include/asm/sev.h              |  75 ++++++++-
>   arch/x86/kernel/sev.c                   |  15 +-
>   drivers/virt/coco/sev-guest/sev-guest.c | 195 +++++++++++++-----------
>   drivers/virt/coco/sev-guest/sev-guest.h |  66 --------
>   4 files changed, 187 insertions(+), 164 deletions(-)
>   delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index bed95e1f4d52..0c0b11af9f89 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -111,8 +111,6 @@ struct rmp_state {
>   struct snp_req_data {
>   	unsigned long req_gpa;
>   	unsigned long resp_gpa;
> -	unsigned long data_gpa;
> -	unsigned int data_npages;
>   };
>   
>   struct sev_guest_platform_data {
> @@ -154,6 +152,73 @@ struct snp_secrets_page_layout {
>   	u8 rsvd3[3840];
>   } __packed;
>   
> +#define MAX_AUTHTAG_LEN		32
> +#define AUTHTAG_LEN		16
> +#define AAD_LEN			48
> +#define MSG_HDR_VER		1
> +
> +/* See SNP spec SNP_GUEST_REQUEST section for the structure */
> +enum msg_type {
> +	SNP_MSG_TYPE_INVALID = 0,
> +	SNP_MSG_CPUID_REQ,
> +	SNP_MSG_CPUID_RSP,
> +	SNP_MSG_KEY_REQ,
> +	SNP_MSG_KEY_RSP,
> +	SNP_MSG_REPORT_REQ,
> +	SNP_MSG_REPORT_RSP,
> +	SNP_MSG_EXPORT_REQ,
> +	SNP_MSG_EXPORT_RSP,
> +	SNP_MSG_IMPORT_REQ,
> +	SNP_MSG_IMPORT_RSP,
> +	SNP_MSG_ABSORB_REQ,
> +	SNP_MSG_ABSORB_RSP,
> +	SNP_MSG_VMRK_REQ,
> +	SNP_MSG_VMRK_RSP,
> +
> +	SNP_MSG_TYPE_MAX
> +};
> +
> +enum aead_algo {
> +	SNP_AEAD_INVALID,
> +	SNP_AEAD_AES_256_GCM,
> +};
> +
> +struct snp_guest_msg_hdr {
> +	u8 authtag[MAX_AUTHTAG_LEN];
> +	u64 msg_seqno;
> +	u8 rsvd1[8];
> +	u8 algo;
> +	u8 hdr_version;
> +	u16 hdr_sz;
> +	u8 msg_type;
> +	u8 msg_version;
> +	u16 msg_sz;
> +	u32 rsvd2;
> +	u8 msg_vmpck;
> +	u8 rsvd3[35];
> +} __packed;
> +
> +struct snp_guest_msg {
> +	struct snp_guest_msg_hdr hdr;
> +	u8 payload[4000];

If the idea is to ensure that payload never goes beyond a page boundary 
(assuming page allocation/backing), it would be better to have:

	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];

instead of hard-coding 4000 (I realize this is existing code). Although, 
since you probably want to ensure that you don't exceed the page 
allocation by testing against the size or page offset, you can just make 
this a variable length array:

	u8 payload[];

and ensure that you don't overrun.

Thanks,
Tom

> +} __packed;
> +

