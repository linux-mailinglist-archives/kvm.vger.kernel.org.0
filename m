Return-Path: <kvm+bounces-54942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BC5B2B7CF
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 05:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 425035E242C
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 03:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDFBB2D8DB9;
	Tue, 19 Aug 2025 03:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="P2NG14oY"
X-Original-To: kvm@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013087.outbound.protection.outlook.com [52.103.43.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D9F2D24B9;
	Tue, 19 Aug 2025 03:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755574721; cv=fail; b=N7V1Kb7RONE57/nvcOvGm0GhoSaRNbStmsDN+5cKBZnVucx43vahIVbG/1YGVG3UbkfYzc3XorTrNz+fWcYwMn9uPQQScFw+YhTPXtjU3L26khMxHzl4aTF7xsJinObibh9WJdK8ZhERGYikshcHq4BK4Qxfb/dXueFZ7PpChLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755574721; c=relaxed/simple;
	bh=Yx8arCtpA0Va7M4N/EAGi/qxbyvqBBc/C8ElYM6CTN8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pXF6gL09vg60kdWyYhc2xWZx/O84eJD97LrOumgATx9O6RnaRNledPXPxBDG/GGzLh6kfLzaUsCZVkZVkO0KRjJzH+2zN/zdNbXN3cdgT1J9hSaqoXCvtfzJtgIBJTs+YfNUK7+EdJFroFuHs48ceP2k0H4xAONrDHje3CZ5D7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=P2NG14oY; arc=fail smtp.client-ip=52.103.43.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U8DBD6URuxSBf30C4WkEWTqA5Fg3Zl6u71gxm5M+bWtMa1ZT9C18hHIETUekegpDZYOTXx/CtSqmxsFLW/DsTdGOgQHsIqEjO5B6eKxvuLaaTiW9sPJ1L+ZjRwZhTsuwF6jet/CvO2rIgXskFV/Hj9wUpx7Bo4kzbYxArnZR1bhncP/6vrpvsc0Jf4bAWj/D4MbTyUqFAGPwwDGospms0zTfx3GSszTVeqxQmn9gV9L7XrlWQqkHUHa67nCeSoee+lV8Ju3eMwRqylyaQmit8xQVk4zVM0LrZviuP6Lxp22T4Wf+JFDxFgLqQjRgKv4KemIw3hZQrwAot0LTCSzkow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9CpfC7avC0VuOlOB5eG1FDtQIX9MZggvNiH6X7jgWk=;
 b=K5sYR3XRZa2PUT90ZTksTD+lx+7riQJOokISEUHH2CWfeAFZYBgdhzvu9YxyVsi2jVhPwWqr2xpiG1eQ1xe14W5LCqKUHw6EdM0eJOyfuomHUD+1sRhlX40YnCsQvP3p0JGTv31+lyCoWIISja+2pOSY6rpGZthLOdZXQAry8g6nbC+TZuacNJNk7+gy7L9nTHdSoWAC7VhMYf+/bX6XLkv7RmNMIRK9GuCmL291easXo+WDiohDUnjlk4p+FZ1skHn8IXY/JR25PR65p5N/xXHyqWnnf/JcSKLzPrA3XYvpi43t3e70OMRvgsxZu81qdguVyspVxTUDYNV9gmhg3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9CpfC7avC0VuOlOB5eG1FDtQIX9MZggvNiH6X7jgWk=;
 b=P2NG14oYnBPO/Hkoxz1UDkRJcl29OZZKM1xuSmY6aTdcJIhAwczVt3jBWGyN2Fiu1JrFA+SPww1cLy51OZLuZFbtle3rcTUQsBwfVdhwF11c2hd8brG5xWEfqo7zV8hrFE3RGx7xvYCB47czvGEZ2g0O1RQ3KvSxbPGEXyD35zh/ax0riXKQpphhquGgIa2ZvdpVAFd9rwS9IyopsDLKdJiFELCRM5/h/OksagOERB0RGZRGhOh3tKeXCV2+Kp2FNXXkhWL19a9ZY8ttRGpYtf80Kr7PNjKW+rZXmLU9/I+JCkJqiWCMBX0tw0QejXNONBbA10z1n0bt3ri9T00qPA==
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com (2603:1096:408::966)
 by TYSPR02MB7782.apcprd02.prod.outlook.com (2603:1096:405:57::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 03:38:34 +0000
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da]) by TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da%6]) with mapi id 15.20.9031.018; Tue, 19 Aug 2025
 03:38:34 +0000
Message-ID:
 <TY1PPFCDFFFA68AAE9F8D45142C373728EDF330A@TY1PPFCDFFFA68A.apcprd02.prod.outlook.com>
Date: Tue, 19 Aug 2025 11:38:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] RISC-V: KVM: Change zicbom/zicboz block size to
 depend on the host isa
To: zhouquan@iscas.ac.cn, anup@brainfault.org, ajones@ventanamicro.com,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <cover.1754646071.git.zhouquan@iscas.ac.cn>
 <fef5907425455ecd41b224e0093f1b6bc4067138.1754646071.git.zhouquan@iscas.ac.cn>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <fef5907425455ecd41b224e0093f1b6bc4067138.1754646071.git.zhouquan@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0239.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::17) To TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 (2603:1096:408::966)
X-Microsoft-Original-Message-ID:
 <34b16c0b-74b9-4c53-a79f-f7eb260ec5df@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY1PPFCDFFFA68A:EE_|TYSPR02MB7782:EE_
X-MS-Office365-Filtering-Correlation-Id: 767bf47e-6616-4943-e872-08ddded1df9a
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|36102599003|19110799012|5072599009|461199028|6090799003|15080799012|23021999003|440099028|3412199025|40105399003|51005399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0dNdGhQYVU1Qm1sRDE1U0VnR0FEMFJvWm9DVVdYMGRIczJ1YU9oRDFINGxm?=
 =?utf-8?B?U01uTEMzd3ZtZVd5c3hXanlqK0drOFhkSWNoVHE2RlJtU3R4RHpzQ0ZvOC9q?=
 =?utf-8?B?TXJZOWpmK1VjUmtkZWsvK3Q1YnNmRFdYc2hwS0VsdWVJcTQ3S2FqQUpSVGZF?=
 =?utf-8?B?NXJXc0swZ1ZiUnFheVR1NHMvREh1dzlXeklEMWIzL1RtanphZUV6dzhyeE05?=
 =?utf-8?B?cW5LblBmT0NKWlR2NmExd0lSUENaN05IWXRuRWtZRkNHRDZOM0FUUkduVHRH?=
 =?utf-8?B?dS84T2x4UEhRQnFveDMxUFJwU0VVVmxvSEFBbzllczR2QUV1TlNkbmZyRG9v?=
 =?utf-8?B?RjFQQVh1bitmWFJJaUJXdHc0ZHZUeFlmcXc2eU5hTFZ6SzBISW9IUVBYdTdM?=
 =?utf-8?B?ZFd6WjQrdjhOTGdxaWg1SW1rc3k2OUdlWG9ZOTRXN1BFcm9VQWdQTitiWEEx?=
 =?utf-8?B?M2dCTm8vYUFWbUtyNkZudDdLU0xERXZuZUF2ZmxITEgydFhGckt4emplSkJM?=
 =?utf-8?B?TDdYQXlncmZlcWx0WnJORFArZ25QbEpoVXdlVXFQQlJtQncxeW5hODlEQ0Z6?=
 =?utf-8?B?OTVnRW82T3ppQzBhb3llazhOSkJsbHNLM2ZoQWFsYnhXMnNDMkpXbzU1OGl3?=
 =?utf-8?B?cDdid1hmelo3aVlBdWVwOWJMU25WS0IvaUdWSmxqWDgxT1JBTDVZcGFDaEls?=
 =?utf-8?B?YWpGcUREdERwdlBXTW5VeCthL2N2NEE0RzdNcDdQUENBaGxLUy80RUw1My84?=
 =?utf-8?B?SlkrSmQ4bWNzemRtb1lkKzRTeGJYUENJWFlvOTcxSDI2NW5mNTNQQ2dHWFpy?=
 =?utf-8?B?K2xsV1EvL3p5U0k2bUNiZEZ1cCtrQTViQU5HUEFDZTU0eDFxeitSQnFIU0NK?=
 =?utf-8?B?VXk0WXNIU2tkVWIzc2JHZGRuR1RrUmxQL1NUS0RIcjRCNG5jMXZXN1YrYlN5?=
 =?utf-8?B?VGlNSTZXdEFNeHkxQnpKOXBMcWV0WitWdFpLQ1Y0eUJBZUwzNlBkK2FDa1JE?=
 =?utf-8?B?c00rU3pxOXBhVHdTK0VJNmhWNER5bHE0UFpnRSs4UHN2TFlaSkF5Z21yb3JG?=
 =?utf-8?B?b0YrWExHMnlGYzh6UVlPdjNGeTRCS2VUK0NpUjhOSk9JcEdzNWZPYW9QejZk?=
 =?utf-8?B?aTRWRXlmRmE2b3p4c0xkSVNOdnowYmx4MG5xMEJnZ2NNaGs0a1RzZVFSQXA0?=
 =?utf-8?B?N1BYZ3h6YkpIUHg2NXFuTjM4Q1pPd2NRelNCeWtuLzhKblpiYW45ei9wMTlY?=
 =?utf-8?B?QmlpdVZMTjlTamFmazNCWFh3NkdtaEFVNVlqSkx6NHdGU1BuVWRxSHJHajY2?=
 =?utf-8?B?OGNXdlA2bWZnenV6N0JRRC9ycEZSRkhQdDByUHNGcGFIY0NIYllERFpmeVpr?=
 =?utf-8?B?YjU5bkU0bzZhV3d2VS85SXVXNGt1Y0lLZjAvejVLT1dqN1NnREE2Mm9CNm9s?=
 =?utf-8?B?T3AyaExCSGJyT3lRSWdSWGZteFpkN0VTVFdNRzFtdFV3ZU00TGRJZ0RkSktL?=
 =?utf-8?B?U3d6OWlOY2RRdGxhWG9VbWMvOHhqQ0NpVmtjK3dOUXdrL2l1YTJxRVB6SzFS?=
 =?utf-8?B?ejRrVC9VY24rUFVFd1BMZ2g0cWExMGRKWk05TmpiSUkybU9CQTc2d09kTjFF?=
 =?utf-8?Q?Y1UYdtPGV8/LIWMKmXJn6QqWEVH607uTXjnzxKQApluA=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzJ6bGhGSmRWTmNUdHRsVGR5cERjanRPSVlMRXIyT2RYTjlPa1pVbDBIRVlC?=
 =?utf-8?B?b2VsNzNmQTdqeFZJUWxLS0RaeUdUOTBHcnQvbWdwV0p4NEFINVlNRy94M3VD?=
 =?utf-8?B?ajdKbTZkbXFIU0l0TXRpd25QaTRaR1hWQkVsNkp3UEtZZ2E0d2o3Uk9YMWxl?=
 =?utf-8?B?K0RaWHNRVTErOVF3eWVleiswNjlseSt1aVpVRTZRY1pOYzYveGhTbTZRZW0z?=
 =?utf-8?B?SkovbS9LOXFXT1M4akN0V1R1VDBjR0c0emdNaUc5VHA1ZUc4d3hJSUQ0NzQ0?=
 =?utf-8?B?V2ZnZWlrWjQ4VVRxUnVnYURvRVpGbkZsaWx2R1pKN1JCK1VydXY3amVkMFVa?=
 =?utf-8?B?WisrUXRwWXNWazFjUzhtS3FtMXloUWFpemRIdmFIbUFmeVN4a0VzeXhyc0JC?=
 =?utf-8?B?Q2EwcVA5aE1lR3JwM2w0VnNxQmVnRG5CQWxJTDFORjJQaDM5ZWpCZGxkSW5a?=
 =?utf-8?B?cnZETk5RRVlRLzliQm12OXM4U0NWNEJsOHVoeDE3cTg0Wk9VNGx0bUxmZWdv?=
 =?utf-8?B?bjNTZmRtWnJib3oyYXFBd3NlZGduYkdYckVjNytiemlRdmp0M01EZGx3Q3My?=
 =?utf-8?B?dXYwQ2VkNUltc0hjaUFNK3Z0V2R4REFaRGczU2lpaTRud0ZKeXE0a1Y5NFov?=
 =?utf-8?B?WGtoaG5GcEQvemR2c25RdG9kK3JNZUM5UWhBWG9qRm84K01xM0dOZGc0WWJQ?=
 =?utf-8?B?NWFkOUcxTGdJSDFqa1d6RGsyRlF6N05vamM3TWkxSGZEWUJudzU4QThJbGhE?=
 =?utf-8?B?VklSc0hWVGlJZmpvb3dNYURkalA1NG5ubnU5S0tmYWZjWjZPK3h6c0U0SGFh?=
 =?utf-8?B?ZHJuanpjYWlVTXRBNWdpWWs2VXp6cDkxcmVUc2xyU295WS9ieWZTS2NwOCtw?=
 =?utf-8?B?Ykpqb25XRWk4dlgyb0tVUHVaTWpzY0FiUkVFQlJnQmFFakVJRExDUHU3RTNF?=
 =?utf-8?B?Q05OOC9ybmVua3pYaUZkOVU5LzQvMzJGNCtOcUMxVHV4N1gyWWJCMlFIMk9L?=
 =?utf-8?B?eVpOQ3Y5UnhIUkE2MTJGMVNIUm81V1Z3V2Jpck9mWTFmVHphRmNCVStSMVcy?=
 =?utf-8?B?RkpZdEhCcWNpTjNxSjRpOENUMVJqb3BkN1BkWVRrd3NqaUpSNUF3SndmYjdn?=
 =?utf-8?B?b05ZaHk0R1RWNXlSTlR6N3Rodm1TeEI3NFAvZWViSGJSaDIwQWpwL28xbUh2?=
 =?utf-8?B?a2E1dGhXRHdXRUg1ZWxUNEtyTXI3ZlJDVXBYblpKRU1VM3dzazB5dXI2OWFK?=
 =?utf-8?B?dWxnN0tudzdSc2YyZjNkQk9JbFhLM3hqcWlHV2dPV3FEbnFMc1NHODhXcEk0?=
 =?utf-8?B?aWlHSG1BYmlqZW1aSXNwK0t0MWs5ZTZWd0dkMlozNTd4dVVidXZRa1JvUHRZ?=
 =?utf-8?B?RGVsV1NmZ2xIWFcwTk12V0x4RVJUL0JSN2R1S3pqVDFndnhzYWt1bnlRc3l1?=
 =?utf-8?B?UHhNNXF5VHJGRGRFSE9MdnpxY1dmejNBdnZmQjJ6aThSMWdCdU9qVlByYmNM?=
 =?utf-8?B?MGpHbXBGL3E4Zm9FNTlBN0dTSktXQ2tFckkwcG55UkYyZWZuS0FRY1dhS09O?=
 =?utf-8?B?alNURFNjdU55YSsycnpoUzVpQmRQbmt6VnM2WFM4cWJMTGhjUTNVSVc5ZCtW?=
 =?utf-8?B?bmZZQm5GQVZoV0NRN0FqVnZNeGdJWlNpcEg1cHZZVVdJR2lsY2lvbEdtN0M4?=
 =?utf-8?Q?DCXwJCCuX2Bn44ALnUw/?=
X-OriginatorOrg: sct-15-20-8534-15-msonline-outlook-c9a3c.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 767bf47e-6616-4943-e872-08ddded1df9a
X-MS-Exchange-CrossTenant-AuthSource: TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 03:38:34.3513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR02MB7782


On 8/8/2025 6:18 PM, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> The zicbom/zicboz block size registers should depend on the host's isa,
> the reason is that we otherwise create an ioctl order dependency on the VMM.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>   arch/riscv/kvm/vcpu_onereg.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

