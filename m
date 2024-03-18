Return-Path: <kvm+bounces-11975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DBB0A87E3DF
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 08:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F2161F21763
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 07:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D3322069;
	Mon, 18 Mar 2024 07:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="v3m9tVgQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2130.outbound.protection.outlook.com [40.107.92.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4018922EE5;
	Mon, 18 Mar 2024 07:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.130
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710745435; cv=fail; b=sKJU765+ApNj+anas+ilSBI2SAUOnJf5ZryTNZBBc5Yqn4w+lS14dtWCk4hftwP8szzV7HEBTnQW6NxqGxH6rZcFrjiPJWqUOXEcGvi2hzZSIfHADWkaMs/+vn0bJFf/kxN38KV3apaKY92Y6FpVEEhQVBmx2sQyefygtRP1A6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710745435; c=relaxed/simple;
	bh=2Nfhux9MmYuj73BDBWvXhlhfMM/VmWLXd9ALj4gG88w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RffHwT7G2GLm5eBk/GwOALeC9Uhipi6klwvXk6bxVATv5BoDp5q56QIuY5r3Om3JVYCNlyYDS+P0ANQJVhO1O6hXKqE0WZOy7Sy55CoqYkH4vsrw5/CY1VewZzI/3+ja9F+6ciNqA7lB8LVdRwftTM0rEEthGVDdUHM1o38zh0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=v3m9tVgQ; arc=fail smtp.client-ip=40.107.92.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQE4XzblOMJR5b8arnv4p45wLLxEjJ/0WrzX72YHohJROQECXTnVy66gs44sAFgw4FuzDJKEydPbuFUmJauFYYm/k9wPV3YNPYuK9ZMdpw3umUsWesmpwe8W0pk6JTJvytXkrR0msGS3SY9MisRfTE3JCUwszEo5s+Pabl8lDYUGTKlfd5e3jRKDe5kfI6lr7tWl3pWAjwSqao5zNG9CvwfphALsS7gxsvl/dowJe/ORHXldneOtKqjaoOVXCPUjAbirxq5yoHcUeDGNgbON8s+LzcXG1qtDRUQiqa8XUQTaO2GJIgwMX487dFkYHtXi7JfQkIcW8OW5MR93MTfluA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=anAnmk5BmAO/1JV6SIU9HcG4NDo+kycBOv8dI1swjUU=;
 b=fmjrmJgrdF65mh8+GlMKruo37dAioe5zTNBmxexzIBPGJcJvHteGEOjKglUUtoYSxhRlkXKDFZMR3zmm1ppo9S1BmOcUf8dMTEIWgWeFaEITClNbZCyxdO59z7TJDEskSLC/Du0/+KzJzdPGciLaRgBzrmgc/UTwa8j7AAU2Jg4IspfSWvtXj1zhhJXoz1X4wLargV86ap9e2rvLClSSaKOci7pyrrERtDhjQGRx2WK5eejjRyubmpVMlotmg5EE7B4ZYUC3s/F/m7JIkdkPssMrAUwnMfJE6h7azSSK9tEYpJBiSeYtq5dwC+D39jj0tw52fYgTKBxZdzYoMaMxPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anAnmk5BmAO/1JV6SIU9HcG4NDo+kycBOv8dI1swjUU=;
 b=v3m9tVgQbkfaAkrOlYSIWDqWMl1leV/WbmTRE3iphXgJphx4/rIR8IDnhs12rynLwkwrn6jntaeAHnyi7qJvbWyv51WWiVAO3IBEmkERIAcgU7UtBWdRiQcuJQ8HsJZUA3OIYbNFQY6+f97yRYrdnK5bpGZbv0Jb/brUPMs27Ow=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 CH0PR01MB7019.prod.exchangelabs.com (2603:10b6:610:108::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.27; Mon, 18 Mar 2024 07:03:48 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9%3]) with mapi id 15.20.7386.025; Mon, 18 Mar 2024
 07:03:47 +0000
Message-ID: <aaf10e76-657f-4667-a920-e71b93419efd@os.amperecomputing.com>
Date: Mon, 18 Mar 2024 12:33:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 03/28] arm64: RME: Add wrappers for RMI calls
Content-Language: en-US
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-4-steven.price@arm.com>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20230127112932.38045-4-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0059.namprd13.prod.outlook.com
 (2603:10b6:610:b2::34) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|CH0PR01MB7019:EE_
X-MS-Office365-Filtering-Correlation-Id: bdc93212-92db-4b1a-f417-08dc47198ef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	P+1LQS5uj3jdMe4KbK/szEd7O6ZL34TnkIGzhrha8hVmAH7uQe1st834CSLEjPHpFhzEQKeZ7Zz0ZejdTeWCk4+H+OkEbz8/7nSMNMpUs+SqH1s0LliRAvLXUcHiCT+6fq+258bm6eZdDZsPwQ0Vcd/9TSYhEOZsGRwDgIrTjnzy7MZpuQlttL7NCLDVwSrRWqHit//QyE9w2se/gTHpcz6Aoz8Lq6n8bBBX/Zq9Vg961ZcDkjhw84FgiEznhUUl2sNJvLrtsIf5wxeIJRX9vVyi6NWxZ0FNIDiiuKFU6V5YOh1Sd5GSbRVX7eM50nAfuXbUTNFnsWneHQ7n/GVrSdqjNJsZIrkuhK15Q8PhQvu9qAkgy/MqmFoqYLITJuHViVXAYi84HE0xRf73J1Zr0Krt8Ar3J+2DJHu15gCjLY8PsJPtV+uItjzquhp+Mn0LoOzHZg57HZwKDZmlmAiKpCz0zr4wWn8timp5d3EykFG3spn7niiMbTZfm/h+PmYS1H2Nrdtk+pFrvG70UjVTbZ5bgxXUsrGQ29MZCdvXJjwfOJKXSAY3lxvGxoA+hC+I58hoUx/gUIeqUMnsq38b+BdbPk/wPi687iOGLAjtiu9OWeQYlXbiRNwnnokgW2Pk4S99kp0qTYADYHZ67BU5dsnp8UzKqDUx12+UI3zmFDo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGdHcXdnMnN5OVEzeTF3RC9XYVM4SGtIK0pQREozTER6YWJqTFVuTUtKZWJu?=
 =?utf-8?B?YUsxVXdkM2RqczJmTmNBRmpSckdsOVFuOXFZUTNLSTcvOFliNkJuNVlpQWtt?=
 =?utf-8?B?aWFFOVNsTnRxQzY2QThNVmJBRlQ4U3o2N2ZBd3lDS1Y3RW1vYUY1RktkMVF2?=
 =?utf-8?B?dTZRME5keGVvU3FIa2hwM2dtdGFiWWtld1pMQTlkL0tia3lhbzVtRkh6V0h4?=
 =?utf-8?B?UG9lWk01aGxWWWYySFpFalF4VEtWSGF0ZXFvUm41V1hWeXFaVnlYR2RNb1NJ?=
 =?utf-8?B?TGYzQW90S1RqRzNLenUrOHhmcUMrZnY0WC9lNDAzbEVSa2JZVWovSVRwVXow?=
 =?utf-8?B?ekVNcWhwQkNCcFY0UEVOK29Jdmp5ckUzZkdoTEZ2cEFOdmcwWDg1T01HUERL?=
 =?utf-8?B?UGp2Q2FTWlhyRExIdzVMN3QxWERLV0JrRFpwWFNScmlBVUhGeFhKMm84N1A3?=
 =?utf-8?B?NXBNa3cwQ3BxSXhnTGFvRERXb3RRK0t5RDJNUkN2NVpUY0ZCN1Y1ZHpyZ1JE?=
 =?utf-8?B?V2N4L281OGl1NUs4dTVxOFE3NVhyb0I0VFZWc0JiRll1d0VoVkROazRUYm1h?=
 =?utf-8?B?Z2pxcFJkV29XZ3pNWFJFNUE4d1VhT3d1UTdxTWJGbkwwNFJKdlBad25XT2x3?=
 =?utf-8?B?ZzRxeS9xTXdMSTBWWEVVT3hKY3Y0a29FQXFWOTJDSzBIRnhZblF4emxiWno5?=
 =?utf-8?B?WXUxQTRVdjFHbktLSmR1MjN0aCtXeFV1Nk9JV0tsZ21QM2hYeTFDY1Z2NGJq?=
 =?utf-8?B?SWErQklJOGQ5RHVRMW95RFI2aEs1cjhUZEM5eG5Va2lDSXdnTTNNYXZDbFlh?=
 =?utf-8?B?aXFmbDFhU2s3dW9ROXhaelg1ampBeFNyN0lZTDc1QS9RYUg5cXIrVVh4MnhN?=
 =?utf-8?B?YkxsNWFjcXZxR1BadnAxdEYyaWJRc0ROaUpHYXlvM0tpOG53OWV2SWxEZlZ3?=
 =?utf-8?B?NC9RMVFWc095ZVdQWnVoTXlDdmdvNThHNVVqZHFza2k5NGJhMjBLOU9VZDhv?=
 =?utf-8?B?QkRGditxa0JwS2JIVmlLcUJsWHY1ZnVpb1Z6cnByWGN2MzlQWloreVZ5VVZU?=
 =?utf-8?B?N05QY1BIbVg2WjZVN1BNWXhyMHNYU3JBVkoza1ZpMERtTlpRS3FXZjVKNXVW?=
 =?utf-8?B?YmFNMGxRNkI1VHViRzNidWdwQitzdlpsc2EzdC9VOHpEMEZEUHVGNU84NnVr?=
 =?utf-8?B?alpQVnZnNndRWWJHdzQzU0NLZ1kzWG4vQlhuQ1ZqOWZLMjBadXhDajY3clZj?=
 =?utf-8?B?eW41NlI1c2ZJUE1kYXVjdlF1NlE3RmhNMzFQSE1RQXRKV1RCSzFHVTNXaXFS?=
 =?utf-8?B?bUdLYjV3T3I2RzJmVy8rWU5lSFlTQzBzK0FtTVNzTEpsMllCTkVRYy9XQ2Jo?=
 =?utf-8?B?aktJRkxTcnYrQXJpRUNyZER2UXQrY3QrVUVwMVYzWXV4Rm1selhLd2NnTDlh?=
 =?utf-8?B?STNGcWtUUlVxV1cwZDJvTEpJT2F0dFlvOG12MnVpYXdkNmpzSHpmMmdaMHBX?=
 =?utf-8?B?NHBzb3Nza1B0SzJ4NjJaWUxOZlhIUVdwQUZHa3JaajR1SFhDVDluUUxUdHNH?=
 =?utf-8?B?NVpicDQraTNGQ001d2hnWVl2aTFCQmdmOGJOU2wvWkxLZCt1SCthOGJXeDVY?=
 =?utf-8?B?MDZvTWJLSEpjWlQ3SUlJQlIzVkRhWEQ0R0VqY1VYajJKZXRjV0hoZTNOSktL?=
 =?utf-8?B?dEhZWTBDYTZCSFlXMnh4VlNtR0M0WU1Vc3BMcEcyVzhIMS9DNkxSQkFOUVN1?=
 =?utf-8?B?djlPSjNLSlJFbHVTeWQ4TjBjUlNtQzNsOWdRZ3gxT01GU2tzaTBVL21JZ2Ir?=
 =?utf-8?B?YUNIc2NrL2RDSW1sTEVCOWZUVW1jNnYxUExJUnlTTXdIZTd2WWJkT0FVbDc5?=
 =?utf-8?B?eGNmQXo5WlpwNE45cnIwMkNNV0xFR2ZndmlsTFlhazhPQU0ralowa21OcmNl?=
 =?utf-8?B?UFpIY0d4M0VGL0tnUWd1enY1LzdJRnhRVGtDK0tkN2FEOFlMRS8wUlJ5Y0Vx?=
 =?utf-8?B?Qm5DWllsdUlqK0JadlowZ1ZkSTV0cU1Od3lyQmhrTUVZcWxJRHNpcTRsZTJL?=
 =?utf-8?B?OVRVY01zY01HTkdrdFlJUEt4amE2bXpwY3BQb0pCejVNNU1saVZxQXhJUmVh?=
 =?utf-8?B?YjluZ0Q5MnZZOXg2VTVVckZuUGlKS2JWZmYzT1dMNDRIUVVoNWNYVGh3eklz?=
 =?utf-8?Q?nZUVyoGN1Pj1lGcJBtfgUQmOapSNAkV2lNpyGjZXHGsA?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc93212-92db-4b1a-f417-08dc47198ef2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 07:03:47.8906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ZFqcD3bv/BuCrj/J4v2+ZNjtw78UaLyd9QGABlLxKwpHJ7CprdngnAbWkKpIAsYWY7NCHV4JV15oDvi2wDb7iGrQeLHuDdf0120BjDsGhmwpc6oLZLfC3p5k9gZvbEh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB7019


Hi Steven,

On 27-01-2023 04:59 pm, Steven Price wrote:
> The wrappers make the call sites easier to read and deal with the
> boiler plate of handling the error codes from the RMM.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/rmi_cmds.h | 259 ++++++++++++++++++++++++++++++
>   1 file changed, 259 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_cmds.h
> 
> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
> new file mode 100644
> index 000000000000..d5468ee46f35
> --- /dev/null
> +++ b/arch/arm64/include/asm/rmi_cmds.h
> @@ -0,0 +1,259 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RMI_CMDS_H
> +#define __ASM_RMI_CMDS_H
> +
> +#include <linux/arm-smccc.h>
> +
> +#include <asm/rmi_smc.h>
> +
> +struct rtt_entry {
> +	unsigned long walk_level;
> +	unsigned long desc;
> +	int state;
> +	bool ripas;
> +};
> +
> +static inline int rmi_data_create(unsigned long data, unsigned long rd,
> +				  unsigned long map_addr, unsigned long src,
> +				  unsigned long flags)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_CREATE, data, rd, map_addr, src,
> +			     flags, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_data_create_unknown(unsigned long data,
> +					  unsigned long rd,
> +					  unsigned long map_addr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_CREATE_UNKNOWN, data, rd, map_addr,
> +			     &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_data_destroy(unsigned long rd, unsigned long map_addr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_DESTROY, rd, map_addr, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_features(unsigned long index, unsigned long *out)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_FEATURES, index, &res);
> +
> +	*out = res.a1;
> +	return res.a0;
> +}
> +
> +static inline int rmi_granule_delegate(unsigned long phys)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_DELEGATE, phys, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_granule_undelegate(unsigned long phys)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_UNDELEGATE, phys, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_psci_complete(unsigned long calling_rec,
> +				    unsigned long target_rec)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_PSCI_COMPLETE, calling_rec, target_rec,
> +			     &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_realm_activate(unsigned long rd)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_ACTIVATE, rd, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_realm_create(unsigned long rd, unsigned long params_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_CREATE, rd, params_ptr, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_realm_destroy(unsigned long rd)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_DESTROY, rd, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rec_aux_count(unsigned long rd, unsigned long *aux_count)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_AUX_COUNT, rd, &res);
> +
> +	*aux_count = res.a1;
> +	return res.a0;
> +}
> +
> +static inline int rmi_rec_create(unsigned long rec, unsigned long rd,
> +				 unsigned long params_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_CREATE, rec, rd, params_ptr, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rec_destroy(unsigned long rec)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_DESTROY, rec, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_ENTER, rec, run_ptr, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_create(unsigned long rtt, unsigned long rd,
> +				 unsigned long map_addr, unsigned long level)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_CREATE, rtt, rd, map_addr, level,
> +			     &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_destroy(unsigned long rtt, unsigned long rd,
> +				  unsigned long map_addr, unsigned long level)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_DESTROY, rtt, rd, map_addr, level,
> +			     &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_fold(unsigned long rtt, unsigned long rd,
> +			       unsigned long map_addr, unsigned long level)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_FOLD, rtt, rd, map_addr, level, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_init_ripas(unsigned long rd, unsigned long map_addr,
> +				     unsigned long level)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_INIT_RIPAS, rd, map_addr, level, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_map_unprotected(unsigned long rd,
> +					  unsigned long map_addr,
> +					  unsigned long level,
> +					  unsigned long desc)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_MAP_UNPROTECTED, rd, map_addr, level,
> +			     desc, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_read_entry(unsigned long rd, unsigned long map_addr,
> +				     unsigned long level, struct rtt_entry *rtt)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_RTT_READ_ENTRY,
> +		rd, map_addr, level
> +	};
> +
> +	arm_smccc_1_2_smc(&regs, &regs);
> +
> +	rtt->walk_level = regs.a1;
> +	rtt->state = regs.a2 & 0xFF;
> +	rtt->desc = regs.a3;
> +	rtt->ripas = regs.a4 & 1;
> +
> +	return regs.a0;
> +}
> +
> +static inline int rmi_rtt_set_ripas(unsigned long rd, unsigned long rec,
> +				    unsigned long map_addr, unsigned long level,
> +				    unsigned long ripas)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_SET_RIPAS, rd, rec, map_addr, level,
> +			     ripas, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline int rmi_rtt_unmap_unprotected(unsigned long rd,
> +					    unsigned long map_addr,
> +					    unsigned long level)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_UNMAP_UNPROTECTED, rd, map_addr,
> +			     level, &res);
> +
> +	return res.a0;
> +}
> +
> +static inline phys_addr_t rmi_rtt_get_phys(struct rtt_entry *rtt)
> +{
> +	return rtt->desc & GENMASK(47, 12);
> +}
> +
> +#endif

Can we please replace all occurrence of "unsigned long" with u64?
Also as per spec, RTT level is Int64, can we change accordingly?

Please CC me in future cca patch-sets.
gankulkarni@os.amperecomputing.com


Thanks,
Ganapat

