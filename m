Return-Path: <kvm+bounces-18519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 509058D5E2A
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:24:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBC07B24D8A
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D128173C;
	Fri, 31 May 2024 09:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BYrETmUn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2071.outbound.protection.outlook.com [40.107.100.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BFA78C62;
	Fri, 31 May 2024 09:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717147420; cv=fail; b=KutjTJ/KWT5Lb1bkPM764TQBLuIVvZZ8UqZQIEyBaQR/suEKSzmGntrg9rXJx+AS7YuLwx2n1SlLMFwnq/wI0+3rQhERl1rhb+Qm2KJ0qh1Bq5+FGuBaxnQtV/PEAofDdGAO7aNtPwbavvJBlKiwc3lD2p7PcZm6Amv/4fnc1bY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717147420; c=relaxed/simple;
	bh=TzkeiIrcvq8XhwN2uqPZdkbQLpn7p/bYD5ljKYOnQAU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hg9mPO+z8halWWkoWUxmYxREebq7N3WB4Lsre2wcc/vsa3a+bfMGYwSzTbqB3yXEbCYdhWP+EvdbQdvPxLM3rLv4Ztz6KYilxTdeFRqqjO3dauDPq1gtarnqdgJtNDIE+H/tQWYfgK/HcCW9qiDMdtoTb5ilXkY7nZL22+p0ruI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BYrETmUn; arc=fail smtp.client-ip=40.107.100.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGmazq/wfgeZyJ2KgshSaX0opU/WBbrI9RFfk2ruBeMMYkTNESHW+G2GkgxWTQjpE8WHSCB+XddDkS8/YB7/q1taxXt7lesANhae3WyJHssUj4IhJ8Q4N4jENJI9KiFN7Z6lvuyAYfpKHgWikZybmLtDg0eqXn7FJNqiIQSKg5LD85N4+Fi7KHc2B9jxoM1qqUy24cFDBNSq23skb25HWhKohRZBxiJAwr4YefGqtyka97W63crRCSmFtz39lA5Prf7+F4aGW5rugwJrbqsI9DGF3Uqs3KuXF3vjhp5Ok+nEhftwcIwGXYdWegrR9jlruUhqKDoPK1fGxcmh6047fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhtouzQz1Cp/3oRyLrPRYR8C304csVkKtOFjSYVeREo=;
 b=hdnlmdnprmqpXCzPb+NocQyV6e7iH7NkCEi2T+WYMclLWEYtFVugFcbTqRM13W6s5x9OakIS5LVEiFVQm+WWTf0Zp3qqjyhGqxsBl2p+oIkt1IW2tG0Twc67f14VtDApFchV1HTjpn8EOL7xvDL/8l47th2iJmb4nlG6SvadBEdaMRMu+dLlSiEvbPUWRtmpe8BIsMi7/ZMbIe6FIypP1Wk0H4xohpogH8YYOWqeJEOFYJ1Xdu3FzNN2Oa9etfTPA5i4esrQ6nCaz4fatkk0TiQMstKkGLi1D/2EB3/5G8pb4TpDtj7fennY2207hgprtVEWLkgdc8bq1iT8gqNbgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhtouzQz1Cp/3oRyLrPRYR8C304csVkKtOFjSYVeREo=;
 b=BYrETmUnRDsklMJwACUXwiDtZCLIYAwqS7wUXYKOlSkJ887NZw11JMoBIR9YJntg5clOyWKMWpeBk6dpOJL4qqSOqJ3GEH9SmYj58+MJ5J/76GE74KRqVsZCU2aS7ymUr4e9zOeBcscrbew+bjjU7IaS6MCm+MPhDAmu/BR/8jw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DM4PR12MB6303.namprd12.prod.outlook.com (2603:10b6:8:a3::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.30; Fri, 31 May 2024 09:23:36 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.7633.018; Fri, 31 May 2024
 09:23:36 +0000
Message-ID: <ddd2f4a3-9d44-4f98-aee2-0a4b5553004f@amd.com>
Date: Fri, 31 May 2024 14:53:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] KVM: x86: Add a VM stat exposing when KVM PIT is set
 to reinject mode
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com,
 joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, mark.kanda@oracle.com
References: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com>
 <20240429155738.990025-4-alejandro.j.jimenez@oracle.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20240429155738.990025-4-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2P287CA0011.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:21b::18) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DM4PR12MB6303:EE_
X-MS-Office365-Filtering-Correlation-Id: 34bd5f59-88a3-4020-c2d7-08dc81535968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MDhaVitZcFVibXU5K0xEK2s2MDd4TmJBWVVXM25GVjhSOFhWZjdUVlRWOE5v?=
 =?utf-8?B?eWg1dmJQV2FXdnlNQUk1cTgyeEYvaWw5c1VsZlB4eFNZZ3RIek53dFhGOUtT?=
 =?utf-8?B?SlFEVlcvQnpjZGZqRUQ0ZFpLVUFMNUJkTGI2Mkk0NjRuMUxHQUZCUkdzRCtn?=
 =?utf-8?B?TGJqN3ovalNYb05Ocy9ZcWZnVHgrRm9oVzRycitDMnl5OTFlb1NhTlRwb3A3?=
 =?utf-8?B?Q1E3c1JmSjhzREJCUnRqdTFob1R5cnZUYzlTZi9sRmovdW9GT2ZpSHI2SFNv?=
 =?utf-8?B?ZmhlQ2pQeWR3blQ5NkY0c2pvSC9zUC9DVmxHQzhJN1g5NVBwTnRsNk8ySlJR?=
 =?utf-8?B?ZFNvWmxMNVYreHhuczZiUmVkOUJhbEY4TEQvTjFJNUF3SmxpZGxwWkY3c0J2?=
 =?utf-8?B?V0dXTmx6MTMrbW1wb3BNVEc4ZXgrM3BZdW5Vck9MSXJwdGV2RFBkWGkyRG1D?=
 =?utf-8?B?VWNacGk4d0NocHNHeUlSMjRNdDZxaXFBb3BJcjE3YWdwV1Z0cHZvUXN4YnBB?=
 =?utf-8?B?MjdzNkFMc3dDMFhhSjdlNFROT1BPa0dpK1lYZDAxeDZtN0dFMmdJZjI2NEMy?=
 =?utf-8?B?NEY0d2ErVDZ4dmFQZ29FTmFnQmlub3kzVUtoVkNZd0FzWVRFWjVjU3R4eG16?=
 =?utf-8?B?ME1RaFlpVkQ0OVJTaDN0TUhsajFrMUpVMFgveWZ2ZDNuc0lDVVRlRFowWDNS?=
 =?utf-8?B?djBFZ2xPNUtsRUxBMEllVkhqOThDelUvcmdJdzd4aXpSTDlJMENPdG11TFd6?=
 =?utf-8?B?SExEcVhFMTlUcUJNN0x3bzNCbVc0U3FGbnA4SHJDWVJQZUhtRGFBbnNyMzhs?=
 =?utf-8?B?cXM0RXVKSDFFRGlJNGh5RFFHcDB3R2NHVVpOWVZ5K1VmVFpxdkpzS3hZSjdk?=
 =?utf-8?B?M3cyZWR4T1NOSUhvTGtTbUVpaEhjVUM3TklBNE9nUEIxRzRzOU5OVHc0YS9p?=
 =?utf-8?B?WXU3b2c2ckROcDlMVWh0Y3RPekkzNGRvSmxicWVRcURmbkZLQ1hzS2d3dTBy?=
 =?utf-8?B?aG5wSlZSV3BNZTBFZzhXazNkektqOGVIL1gwTXEvRDBoYXhnQ1IvV3llVEEz?=
 =?utf-8?B?TjlhOEhteG4xTytFZStyN3FQYnh5NlBodXB4VUpxVU1MVmphK1QwTWUraWda?=
 =?utf-8?B?dGJmVzRvaFdEdXIrWXdWbmZraElRVzBQcUg1U3hpbjA4aERzUlJpZ1J2RHRy?=
 =?utf-8?B?d1liazRLYnBhQmREUE5tRU9MSW9RNVVJTm9SNGpBNTVWeWhGNzdhZTBrVWp1?=
 =?utf-8?B?R2JIVzNibENpeUxNZmtTalJQb3llYzgzQXFpek0zN3FpNHFva3ZGbEtRR3NB?=
 =?utf-8?B?L1hFa3JjczBMaElBL0NCRFNLMXpNbE1zZWdUMmxlSGFYemhJSUFoNTdmMWJm?=
 =?utf-8?B?MUxhRVhMTmo2QklQVXdFZXAyWkU2ODVRd3RsRlN1SGtpaENZSnd4NVV3OFBO?=
 =?utf-8?B?NW5pUFpnM0tmWmh5eVdET21LNXJwblMyTitvWGk5K1dXSytaS0c3aEtkbG1G?=
 =?utf-8?B?amZJdmsvTzV3MDZWK0hiT2IzNFloZWI5aC9kUmxDN21odE9henQydTNLMXdv?=
 =?utf-8?B?ZmJDdXM3Y1VYbmtleGpwakpIbFJ2a29JQnlmTEJVUDVsY3U0Q21VTkJadkNq?=
 =?utf-8?B?QmtmamFVQW5CUUhGOWVvazNtbi9UR2hVNEZKaWxoM3ZVdENkdVd5ZHhnKy9R?=
 =?utf-8?B?SW5HR1hkaURpM2dyUXU0QzFjcDc5TFpuSHZTMUtmYWJQK0hjUlFnRnN3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckdlQ3UzR0VpendEcVhVVHl2UmNmTStmMVl1NmZmNjkraisyYXRaRlM1Tzgy?=
 =?utf-8?B?M1JLaHp6QjlnWGVibzR4SU9ZUnMwWnFwV0R0MHh1Mm9zUk9SM3VhVERGaHBk?=
 =?utf-8?B?U3MyR3lLWmtLZU1mQ3c1TDVTUzFyN0RMbFpwdk1RdUwwVkdyYkpDdzVYNXhR?=
 =?utf-8?B?Z1FUUE1YQlNpSHQ4NUhLanVaUFdUSGV0QUx0NDRkNEdMMndhd2t1T0kyRUt2?=
 =?utf-8?B?ZUV0YlEvdWkrNmlYZ2xmMGtwNkpMaUZBaGhZQmQ2a0ROREdWaDhlSnRDaUJL?=
 =?utf-8?B?dDQwQlJ2R3ZOYlNtM3pmZ3F2angrelZBYjBRbkh4ZVI0d2RJdFE3TXR4MG5m?=
 =?utf-8?B?ei8zYXFzVUxvbzVuYTkvc0prQnZlemJIVk1icU9KRTJLTzZjdHFPSzBibmY1?=
 =?utf-8?B?VkMvYmx4YllNYjIzYkJ6dTRwUjROVjdlRXJHbmhOTWxSbm9SQmNNQWkyc2tN?=
 =?utf-8?B?NXpxYjMzZjc3dFpneTlvc0RkYWZCcS9wM3NFc25QQWd5Yy92NmVoQ0djUmtO?=
 =?utf-8?B?a3Q3K05qQ2pISnlzK3dyUFNXMXR4SHFhOTAvR2x0NmdmRktCRGMrc2ZYY0lu?=
 =?utf-8?B?TUlxQU03ZTVEblhIV1pNc3oyTHNMK3hZMWNMTHdZcmJTVnNyOEhZZEFoYys2?=
 =?utf-8?B?MW5OVFVJRVM4by9aZ0xZUEtYRVZFYUpmM215QWkyL2dLRlp4MUlxaXAzV2s5?=
 =?utf-8?B?dmMwRFRjV3BqQXZxRkhkdTJHcDlsSzAvZWRPQndlMkJpdzhmc2hpT2F2UkFZ?=
 =?utf-8?B?MWxiZFQ3Qi9zQXN6R0x0NmpUUkdnazdJTElNZ1c4ZFlMTVVvVGJHeExDTnRt?=
 =?utf-8?B?M1NXZTJ1YzgrZkJRSXFEeVNqeExTRER1bEMwdC9kNWV6eDNRcDBISGIzQkVw?=
 =?utf-8?B?Yngya0NEdERrTW10U0tXODdib0xqOXlXeS92YXVnNlpMUy9wL3p4cWdISlFL?=
 =?utf-8?B?aXUzdHgyUTFoRXp4djRPWnZKSkRqK1VLUTdtdUUrM1YwR3BHZUozWEZqNXRY?=
 =?utf-8?B?WThJeTE0UCtVd2NXVEV1RWZCVW1QNGgvS25icVp1Z2d0Sng3N2dTRFVZYmQy?=
 =?utf-8?B?ZWlEUkUvOVIwWHk1L0dsWUJFVy9LOVZJZ29HNFZ5NC9QVG42KzJuM0tnYnhV?=
 =?utf-8?B?WWtaMVVrenNhM0FpeVkyQ2ZZcDh6NkVxN0NjMjZRYnp6SFo0dnRyQkF4dWdC?=
 =?utf-8?B?Q0Yxaytta05waGJacStNa1FvRlFzZlBMR0lGU3lHZzJwdENGUkowUEE3ZkJv?=
 =?utf-8?B?enZPK09GNVV0RnZyZnhkUEdFM2o3R21pRWFSWXIrTUZNZWs2UXpuTmRjbjlK?=
 =?utf-8?B?WU5WWnFSUnBLbmdpRnNvVXYzTHhjeGdUS3RqV3ZmQVhyWkhkSkh2Z3ZCS2Ex?=
 =?utf-8?B?TlVxVkhxMWpMU1FTZk1pSSs4TkFYSThwUDRrQjBNRkZ0M2lCTU50dWhTUXc0?=
 =?utf-8?B?TEFJUm9FU1U0UmxIaEZVVjZNL2dvaWhmVTdER3hzVXE2aDVma2VGNk8vLzVW?=
 =?utf-8?B?L0xpWWhDbjNFTDdJQy9HS1gvQjhKK2ZFM2dYZ05XUFRiWDRNa0c2amRJK01C?=
 =?utf-8?B?SUhsSTVYNEliRm8xd0k0Z0RIV1JId2N0K3VOVXk0ZVFCZWVRL3UzVUE4LzAy?=
 =?utf-8?B?L2lRT1UxMld4ME9kbG5qOGp2RldFdllFRjNrS2lnZ3FIRnhYRHV3YUVaRVND?=
 =?utf-8?B?THVMc1R5anlWRU1oc3l4K0k3WktEcHBHZTJHanZIUCt5OTVtc3R2ZlFVcGhN?=
 =?utf-8?B?RDRBSnJkc05wdE91NFF4OWZhUnFtWkFRWGdWRkR2NjZBK0FsY2lRMU01THJ2?=
 =?utf-8?B?NUJZb3dvb0pFK3dFQ3A4eFBqcTk3VXZSWDRHVWNNYkJyMHVXOUxYMmo0Q1Vh?=
 =?utf-8?B?TDFCc09aempyQllvdHdiL28yRE1UQm5iclpMc3lBVTV6SjhDeEN3U3ErNGZr?=
 =?utf-8?B?TUdhaHQ2UHl5Q0pwYytpWTN4V0ErclpzaEpkTFF6dnoxWUV5T3hJMlB1Nk1V?=
 =?utf-8?B?SVdlc3RsQlNUUEpJVDJsbzhvRHMxaXJ1Z0UwUUkrbzJ2NkxaZGFuZEtKNHI5?=
 =?utf-8?B?OVF3WWNJZ0VzR0JrdDIveUVVR3Nqd1RoMnNySmxtVVM5ZTI5c1VHREtkMjRY?=
 =?utf-8?Q?CwskKxUHU//oW+Q9uyxDlYQXC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34bd5f59-88a3-4020-c2d7-08dc81535968
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 09:23:36.5228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kl2fkFhMf3+zAGyAmTtoLvz8WrxdH5QCaGu4WKHzo7vQSmE7HcDZOZ88nPh6FTMSXmclvB5sLnm+f/Rxe8KEYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6303



On 4/29/2024 9:27 PM, Alejandro Jimenez wrote:
> Add a stat to query when PIT is in reinject mode, which can have a large
> performance impact due to disabling SVM AVIC.
> When using in-kernel irqchip, QEMU and KVM default to creating a PIT in
> reinject mode, since this is necessary for old guest operating systems that
> use the PIT for timing. Unfortunately, reinject mode relies on EOI
> interception and so SVM AVIC must be inhibited when the PIT is set up using
> this mode.
> 
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/i8254.c            | 2 ++
>  arch/x86/kvm/x86.c              | 3 ++-
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f3b40cfebec4..e7e3213cefae 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1535,6 +1535,7 @@ struct kvm_vm_stat {
>  	u64 max_mmu_page_hash_collisions;
>  	u64 max_mmu_rmap_size;
>  	u64 synic_auto_eoi_used;
> +	u64 pit_reinject_mode;
>  };
>  
>  struct kvm_vcpu_stat {
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index cd57a517d04a..44e593e909a1 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -316,6 +316,8 @@ void kvm_pit_set_reinject(struct kvm_pit *pit, bool reinject)
>  		kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
>  	}
>  
> +	kvm->stat.pit_reinject_mode = reinject;
> +
>  	atomic_set(&ps->reinject, reinject);
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 27e339133068..03cb933920cb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -257,7 +257,8 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>  	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
>  	STATS_DESC_PCOUNTER(VM, max_mmu_rmap_size),
>  	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
> -	STATS_DESC_IBOOLEAN(VM, synic_auto_eoi_used)
> +	STATS_DESC_IBOOLEAN(VM, synic_auto_eoi_used),
> +	STATS_DESC_IBOOLEAN(VM, pit_reinject_mode)
>  };
>  
>  const struct kvm_stats_header kvm_vm_stats_header = {

