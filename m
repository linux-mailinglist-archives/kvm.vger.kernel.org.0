Return-Path: <kvm+bounces-43261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E1FB8A889A1
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 19:21:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29F501897646
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 17:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D909A289371;
	Mon, 14 Apr 2025 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UD5Pqj2W"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64529284698;
	Mon, 14 Apr 2025 17:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744651257; cv=fail; b=RQ/QTvwiOmE5yPztMDTqgmW1FbWVcAhdKP93b/X6jbBHHOFJqFtkoALi4wN8vylm6B5jjwKGlbuXWAlrj3OBzAaeV4pWsxzIk166dU4OwC90zKU0Er6ZhYN4hEOk6klOu+HFpzGFbbx+6pM4KvSFmw8qt58vQTYGRqxJY88bfOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744651257; c=relaxed/simple;
	bh=1HdLS6pIa+NGJHwojlju0fL6zUg4sljlWKA4aJQ8UOU=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mvKELxF5Y917wYJhxYmhBTVSJBnjJNrMLwd9Y+sNM+H849CO4EegmctE/3dzktTnGWrLLYSzmTK81lPGt1AWC1Ydn2WDzt6PHm2sekViVYLNKq1xXZ73naSnibLf/xbR7vpfE3OwAOdTOTAhIc9D9NN0+BYes5AvJtG0zrrsSXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UD5Pqj2W; arc=fail smtp.client-ip=40.107.223.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ni99RbRU+ifBhVXEvtb3HIhLJRCiooq6A9B0I9pgR2flwtJU5HtXi6ktbj+l4ov3RpcAlv2OzP2olr8MKnlBeOqUbFViXqmVAqcOPTVY8sxZfBWrH3NWAxq86rCcnEPgEDUoztSR/Es2rJkIQq/I73GfqY26nca14pj5SAyxuIqHttybRw0ewME37GLFxJ0QKHkNQmZyyoqRNta4trpjly4CXBoLh8F0lVyr66349CDQ4TZA7HlTX2z9NW35IbNc3+ql1fqafQEJ6WI/X5EDPQSZijXUPjWINJIkffnYIAdd82ITjA4kJ7wSmP3h4s10p49Cnr4Z8fupaq4k6meQFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nGYRD0XLxGqH/HXH/kpSSMsbJU5cO/1UsO2eCOIJMlI=;
 b=mKVKauE7/x93S8gif2xf3nTM0y/3aS1dk7++ZAh3Lol1/x977ZY5wPW9rLgCMXM/EETqKQGPp77vEFW9rPXGZnwq+dpzEJK59FJaONXCSIBjTe4Uwd7dlv4uMcgpjqs3GkimtAe8n7wu1o6gj+/pv3izB5N2/Gm8IE/XJL094tl396mxMsBZMJHdIvP4ZAI2tJlVkoygzZ5etTeA78j+Qrz4TDh8kguFiUKRepstKJZEmiasKne+Z+KPnWggm1T4lH8qrxdl5QSS/FRMQfmjJggl4YFNomyyHsgvnS2NDoupqAsmSmlI4rVwerh+Zq3Xr0ahNVRF71wXkUknDjU0rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGYRD0XLxGqH/HXH/kpSSMsbJU5cO/1UsO2eCOIJMlI=;
 b=UD5Pqj2WyRLO6NIEAjT10FrmuzePAijjYJesnh3qAUfnKGszVQB7ImErDEyoGPV7TOkmPH0w9TYnL3yxU8iGEcf8cPmYnuX6ut9Xeoy0ZRQ9DlZbgPbDESz2XoIHPGIoyoSmDdQAtOl8luWT2eDxbLUIvlWSO4YINgMYVxJAGkg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB8548.namprd12.prod.outlook.com (2603:10b6:610:165::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Mon, 14 Apr
 2025 17:20:50 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 17:20:50 +0000
Message-ID: <bcd4aa69-6b94-14ba-fc3d-d15e77b0c020@amd.com>
Date: Mon, 14 Apr 2025 12:20:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/5] KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if
 debugging is enabled
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <cover.1742477213.git.thomas.lendacky@amd.com>
 <ea3b852c295b6f4b200925ed6b6e2c90d9475e71.1742477213.git.thomas.lendacky@amd.com>
 <a06ed3bf-b8ac-15b7-4d46-306c48b897ca@amd.com> <Z_hQxXtLaB_OTJFh@google.com>
 <fb5acbc5-3a16-b29e-0496-3977177ed8de@amd.com>
In-Reply-To: <fb5acbc5-3a16-b29e-0496-3977177ed8de@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0011.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB8548:EE_
X-MS-Office365-Filtering-Correlation-Id: 79387d25-45dc-4daa-18f9-08dd7b78b435
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U3dZaDVBdFRiNFdIczNwVFIvS29maUNkTVI2SjI1SGdFbDVMR0JGLzY1L2JM?=
 =?utf-8?B?TkVFNFNNYnEvRDFYK1gwbmJPOGl1QTBWR1NpdDVZT2tzTXJmRU1zejZjY1dl?=
 =?utf-8?B?a1Vicm51bGNrdVM4a1JVS0dPYkFxQWVWN0RzcEw4bk9aNzhPZmF6Q1lIdnFG?=
 =?utf-8?B?UkdLMmxmZDRHenpqM2JXTjRBOW15RElmdC9KeS9oQ3hoUGlWN0NUYVhFK2Iv?=
 =?utf-8?B?ZVdRVGMvWEtoelR1UWNrL0QyZmlYVFVCc3RtclE0T3RHdXBQTDh4akxkcnd1?=
 =?utf-8?B?WVV3dmZjdDVxSnBlNTN1bjFTMWFBL1ZnWTVvL29NeGNpaUwrYWxwbm5TdFJS?=
 =?utf-8?B?blUyampRTHhkcjRkeXUyTFIxbzV5RExBVitPOVVNQTNER2FSNitrZEk2TmR5?=
 =?utf-8?B?bkxxenptcXFjQUdUTW5GaWR2cVIyOGNGL3FFVUpOdmJ4cVFacDlOeEQzMmxX?=
 =?utf-8?B?dWFhM2dLK2Evc0lmY0UxcDFIcWwrZ3NScWhhVVhrK1hSRlo5am5oVk9EZXRK?=
 =?utf-8?B?T1p6dEYxUmNWZVBqbHVMaTF3Q1VzekxtV3dUa05mQkhMWnprU1NpU2duaFNt?=
 =?utf-8?B?UTc5Z3VmOFo0R29EcGJCVmp6eEtnWVhhZjNFSGRwMmpLajlwNlNtdFFOM3l1?=
 =?utf-8?B?MDRFdlE2TjRTTlpXc2M3S0tGcUVlVndxMlY0eGcwT0grWkVZNkVLZFY1Witi?=
 =?utf-8?B?a2loeCtMbm9kMjUrRkpiOUd5NVBaU1VKaWVmU1Z0RFoyTjRRbVk3QkdzbGR5?=
 =?utf-8?B?WUZrYmdpY0EvdnhUdFplWFdiR3BzZGF1cXNETHVNTHBlT1E4Z2wxYjRIWXBN?=
 =?utf-8?B?SkRmSURQRW1WWWRjdGVjNUhnb1o4UkQvSzZQVnJpRUZXZWFNNFZaQURyUTlj?=
 =?utf-8?B?a3JDd2xyUmN0Z2VVNDhJS3RlNThHKy80azJXbHdBK3BSM0JLWnpFU1Z5WDdV?=
 =?utf-8?B?bFBBLzZ4QzZTdzNnaWhoeU1aa3phamIxajdLNngwL1FMQ0ZkYU04NmFPMkpx?=
 =?utf-8?B?cnZNdG1mbVpNWnlBSWowVGp2OXRoWlh4TTNYcXp2czhlZnRRRTlZb2V4QjNK?=
 =?utf-8?B?VUwzMC93eXZlN0Z0MTR0R3FVeDk0MExVZkpScm1RVjMrNUV0ZzlkbHZLYlNo?=
 =?utf-8?B?azlWOFh6cks0VnppNVR4RDBJNVF5bUR3eitEOWFGSXFOdWFTZGljMDY5UDN4?=
 =?utf-8?B?NFQvSWR1MFZ5UG1PVlFrY25lTEdtb1hlMEdLMVR5aEVTTHI2eUVCZDZjWVNm?=
 =?utf-8?B?emo1c0h0SmgxQWxOL2pOVHA2cFY3UWE1T20rWTB1OEpwcGRSVzhKSVkwT2dC?=
 =?utf-8?B?TlVpamNvNHdjR0dyek95MXl6VGY3MFd1RjFxbTNPQkszNUVkME9qcFNZUUtI?=
 =?utf-8?B?dHZCSDJFNDR3OFN6VjkyRnJFeXcvdkxySU1DZmJMQldleUZJNktZQXZPOE1D?=
 =?utf-8?B?T3E2cmJZQXlqdXFGb3NNRTlBSG44VzQzSVYrY0dGeXFXUXVPWGFxMHFtMGZK?=
 =?utf-8?B?MnRzZXcyb2JPcUExaWp1VFZNZTZhZlZSakJoc2hwaGFuZ25NVXE3TjJ0OUxR?=
 =?utf-8?B?dmFvNVkyUmxLcVlTOW5TMUxyNEdwYU5ER3owMWFPSmJrSGt1MDJxTy9CQ1N0?=
 =?utf-8?B?MS96RjM1V3hldUN4OE5EWTQ3M0VYRElLWEJEcVZ4aEJPRmpnWnc3Z2hUQWhm?=
 =?utf-8?B?YUNUa3lkd2hTZ3ZpM1dkWXlRUW5HbVBZODRUclAwS1M2S1pySHFlU1VVUmEz?=
 =?utf-8?B?MmlKK0w4QzF1am92cEYxbzFPMHVSTFhMZUlBQVJTVXJoTklrWERPMzZpeGE0?=
 =?utf-8?B?dVRaak96d2FGMkZNQll2ZThsSHcrMkZOUmY5ZlhKcmNRM25tTzJSSUZEUjhB?=
 =?utf-8?B?T0RJTW1PT3VwSWZVdGNYQTBac2FKOXNBRVFTZDcvdlV6dnc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0JNYVE2WEVDNVB6bUhoNllHSzlEcHdEQ0lIU2c1Ly96cnFsSWQ5N1ZuTlBw?=
 =?utf-8?B?WjkrVXdPWjRmZE5veTZPbmMwS3RZRFZPN0JraXR1WWFsTm9wWUdZN2xKSHhV?=
 =?utf-8?B?enpwR3VpUWRiQ0poVGNpZjJ2QW9QcEkzV2tGRm8rTHlrTVREa2RyMDhmbk9I?=
 =?utf-8?B?djQ5UzJmSXNNbFg4d3MyWGFjM09hek9ZVEw1Q01DRTcycURwSFBGUjVBOXY0?=
 =?utf-8?B?OCtvcUlQZmd4dTNUVnYzRHpRajJsVWM3U1l3ZXpMb3UzZnV2OEZXVlBmcnlV?=
 =?utf-8?B?c01FZmx1dG5URXVnb0N5dy9EaHk1aTA5Nys5R3hQSStxZHpBa3NXZ1VzU1Ar?=
 =?utf-8?B?WVFsN1pZRXRZUkVObCtvd2VKQStNbGRucXJzMHA3Qlk0N0luVTdMZnZnWG55?=
 =?utf-8?B?d2h0T3BWTEV4NEJnNXdxQWtTcDk0TDU0eU9nMFVucGxXejlJeVhyR3crZlQ1?=
 =?utf-8?B?WmNzbUppRGtsMEgreEtoY1Jjei9QdjYvVnRKcDBkYUY2aVFmN3RjZHRYcjY5?=
 =?utf-8?B?MGZtMXhBYVhNb2VmeWpENVZQOVNOeEkyUk9VV3FLTERxbmN5L01oMW83Und0?=
 =?utf-8?B?VzRzZG9Ed0xJcXQzUHFvM243Mjd0UmwyUWFpdGdTdTRMaUVJcVd3Q3k4V3RY?=
 =?utf-8?B?Rkd3TksvTDZTT29HcWNLTWtVeDdIVjlvU3poK1J0MnpBZ3BVSTBOaitxWUNQ?=
 =?utf-8?B?cnRNQXd0NzlJREFWY0wyYVJjNlcvRE5nam9kVnhBeUd2NWZYd2VEYXJsQ1cz?=
 =?utf-8?B?WkxLaWVidElsOXBLN1NvWEFJQmc5eCt1TFBkS3k1NW5RWmlaQ3N6dlRJSUxt?=
 =?utf-8?B?OFNXVWVueWVKWnc1YnV3UnpFY08zUDJ6MTN5alkxblh1ZDFyVWwwUncyb1J1?=
 =?utf-8?B?ckRpSHFCL3ZvcDgvbFh1R0cwSmdISExNYllhSnM1VWpYUWxFOEVmdVQzcTZ0?=
 =?utf-8?B?STVacWNuNVFyRW94MjdMZjJiS28vaVBzaG5qa1pZUUs1QXl0cjFzUURQK3Fk?=
 =?utf-8?B?SlVvUVAvSVdQUml5aGthelJXeW9Yc0N3TlhiN3F4aW9mTDg5VjhKMm9pdk43?=
 =?utf-8?B?enBpT05DVElUc3VTekg4VFFJQ1JXU2Z4WWhnejNIekhLYkFsMVBZS1RsK2hF?=
 =?utf-8?B?VXY3OFNFMWplTUFmZDE0aFkvU0RRQ2EvUXdkN2VBTm1EUlV6bzAzZlpLeStD?=
 =?utf-8?B?QVNYdzhxVFVaekVpdStSbDlhWVQvVTRQOHBENStQVlowVEtsNUo3aVFuNG9w?=
 =?utf-8?B?eUJaSEhrMzdPZGlITEt0ZENBZ0dvaG5LbTVQNEtLL1pVa3dGQXdiTlpPaU1y?=
 =?utf-8?B?c045MG9tVWx4aVFoQUcxS2FZalpnNG84VHM5ME1VMlJudWU3UXQ4RDg0NG51?=
 =?utf-8?B?TDlpSDVqSVZyMkdQVDNqUkxUY2UvK2E3cnpNV1JWbzNWVWVBb3BDWkFoYTdj?=
 =?utf-8?B?VGpZNVpiZVpQQWVncFI0djhIUFBwbDJOOVZ5VEhXSlk0QytnbnFNYStSeHk1?=
 =?utf-8?B?a0krRHZaVlk0WjJ6TVhmVmk0OHVXbENURURIVTl5ZGI2bkJiZlpOWFl0cDJo?=
 =?utf-8?B?cW03VWU3ak5IdnJHK1FwOGsrdmJ0SEFZdzVvY3AyeFdBVjhWd1J1RnlXNTFO?=
 =?utf-8?B?VSsrazJlYmsrNFo3SU1CVitiNjB0NzFOK2FQbGdhSUcvS3dGNTcxVmZUbGJZ?=
 =?utf-8?B?QjM1d2ZlaFRXcjhYczVhNUdCRGdmQndXL2wyS0dUSGdBOGdOVHpCNlQ4ZTZz?=
 =?utf-8?B?d3BVdXc0V1RtSlFZWTJMV2xZRHlrWlJtcWdpQ1NvRWdXQjJsdmV4b1ROdzJX?=
 =?utf-8?B?Z2VXcjFRWXZvcW5qTzMvc1orenVJRjE5MTM2cnROWGNQL2VCYTgyRnlSRUNh?=
 =?utf-8?B?aWprZVdMcXZUR0cydXU5T01OaG05UENmd3BtaWdReTZ1OGF1eHR1RXI0SU1Q?=
 =?utf-8?B?K3Vqc3BMOC9sSXhaQVArRDhNUGt4cFArVC9MQzhJVkxEenc4Njk2WURWdnJB?=
 =?utf-8?B?M2VGS3dRMmVjTkFOdFpzYjdmM0tCYm1XOWdGVmZrL2haS2h5enovdDRXV213?=
 =?utf-8?B?UlVNS2FFeC9LdkxKVlYvaENCMFUvbHVYbWxiNjc5bFJkL2h2SFhxOUdVSXFU?=
 =?utf-8?Q?Y2mJzm9/2YSQWzNy86uAC1wcp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79387d25-45dc-4daa-18f9-08dd7b78b435
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 17:20:50.7723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i2oZhqd6Kp0iLpg/8gbrwNkJNpoVB3bbSGgDkJKyhx6+MsXK+hL51vc5pjv4bSXtPou6p/orS7SkMdP+sZfVLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8548

On 4/14/25 11:11, Tom Lendacky wrote:
> On 4/10/25 18:14, Sean Christopherson wrote:
>> On Mon, Mar 24, 2025, Tom Lendacky wrote:
>>> On 3/20/25 08:26, Tom Lendacky wrote:
>>>> An SEV-ES/SEV-SNP VM save area (VMSA) can be decrypted if the guest
>>>> policy allows debugging. Update the dump_vmcb() routine to output
>>>> some of the SEV VMSA contents if possible. This can be useful for
>>>> debug purposes.
>>>>
>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>>> ---
>>>>  arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>>>>  arch/x86/kvm/svm/svm.c | 13 ++++++
>>>>  arch/x86/kvm/svm/svm.h | 11 +++++
>>>>  3 files changed, 122 insertions(+)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index 661108d65ee7..6e3f5042d9ce 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>
>>>> +
>>>> +	if (sev_snp_guest(vcpu->kvm)) {
>>>> +		struct sev_data_snp_dbg dbg = {0};
>>>> +
>>>> +		vmsa = snp_alloc_firmware_page(__GFP_ZERO);
>>>> +		if (!vmsa)
>>>> +			return NULL;
>>>> +
>>>> +		dbg.gctx_paddr = __psp_pa(sev->snp_context);
>>>> +		dbg.src_addr = svm->vmcb->control.vmsa_pa;
>>>> +		dbg.dst_addr = __psp_pa(vmsa);
>>>> +
>>>> +		ret = sev_issue_cmd(vcpu->kvm, SEV_CMD_SNP_DBG_DECRYPT, &dbg, &error);
>>>
>>> This can also be sev_do_cmd() where the file descriptor isn't checked.
>>> Since it isn't really a user initiated call, that might be desirable since
>>> this could also be useful for debugging during guest destruction (when the
>>> file descriptor has already been closed) for VMSAs that haven't exited
>>> with an INVALID exit code.
>>>
>>> Just an FYI, I can change this call and the one below to sev_do_cmd() if
>>> agreed upon.
>>
>> Works for me.  Want to provide a delta patch?  I can fixup when applying.
> 
> Will do.

Here's the diff on top:

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6e3f5042d9ce..4e9ab172e3f0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5020,7 +5020,7 @@ struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 		dbg.src_addr = svm->vmcb->control.vmsa_pa;
 		dbg.dst_addr = __psp_pa(vmsa);
 
-		ret = sev_issue_cmd(vcpu->kvm, SEV_CMD_SNP_DBG_DECRYPT, &dbg, &error);
+		ret = sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, &dbg, &error);
 
 		/*
 		 * Return the target page to a hypervisor page no matter what.
@@ -5052,7 +5052,7 @@ struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 		dbg.dst_addr = __psp_pa(vmsa);
 		dbg.len = PAGE_SIZE;
 
-		ret = sev_issue_cmd(vcpu->kvm, SEV_CMD_DBG_DECRYPT, &dbg, &error);
+		ret = sev_do_cmd(SEV_CMD_DBG_DECRYPT, &dbg, &error);
 		if (ret) {
 			pr_err("SEV: SEV_CMD_DBG_DECRYPT failed ret=%d, fw_error=%d (0x%x)\n",
 			       ret, error, error);

> 
> Thanks,
> Tom

