Return-Path: <kvm+bounces-43341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7EB3A89B6C
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 13:06:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAAF9189DBE8
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 11:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2BF528BABD;
	Tue, 15 Apr 2025 11:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YE//WqTU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56082D529;
	Tue, 15 Apr 2025 11:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744715201; cv=fail; b=qfb+GLXZkn/IGoDI5y9lHK+7xS9jyzgpjpFjqtqPuN7a1iAZvPu8jGHcpdbRY0AWLUrj/MRL3XeDAdUQHAlthOinC8u7TUa1qG7IyHrdp1iiUJhyP0CcKQce1J1iHCnJwjtLuoWBEzD4UQAwNW0O0e0sYYK5FwQqLL2ZRy0W3C8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744715201; c=relaxed/simple;
	bh=Y9seB1OymfzDwqJVZ8IG7fKGj9B1dvvCQo0cALg8VyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CkfvV/Q6ySzMmQ1Jb8cFgJaYzSKLiVo4GSP/6EnOfrvK3wkPU5CbOtqh/6e2A+wQN9LpTRkoQ8J/KIqsGrTsWc6N1QTNii733EaOrcIsxfupW/dP+MjBrHJFgtCtjK6vlFRI3tYOba0jBfL46xNN+yBn8Q4BFHUM1Z4wGnKaoQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YE//WqTU; arc=fail smtp.client-ip=40.107.244.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=syCzjxfGivgF19OXiHuiBGOY7MXx2LaNFZWH7BeDeIO0s8qv5YLEDVXoUsBy+87XcSWhfHaerOl2fEpwKvEfFPNNy17sWhxFdjlbBbu1X9d1ThfIkURhKnnjDJxQawYGzGBN1cXKc3FurmoHKyhoV0SAxbkabxyt7KlWfvYX9gVt1HHMrt5Jo9VHP1z3LYelGdysOQsc7ITeguHv+0NHR8nNd3rLdes6jYQVxsBm/6BKF2riMzWFW1fcMkx4bccDmcXwO9RuTQVadPPY9UVNrKfHcXqIhNAv8un7X7SVESsIapnSephlwBJwlQs2FIIOuZFxUu6RxUysLAa2SqoIWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1w5T8vXx9NM9HNwUfIMSniPLpzcI3d1PYM/NcXsELuc=;
 b=LrpYFBsJVtZ0Fanb3HDPzSWNfhPSWw0Y4XtAhMJTdF7pbNZZXGjkd+Dcx5Z5pglj1neJQITCF57BnlwTEKYODas0AYY0ctkdcpSo6UVue/hP0zUKCbrhd3D2eyyNu7+aBfmJALiydaiHCg+GAHQvD0oA9PG+2raMryECp1It581FxYkzxEmG/GvywEXRXNrLWaG8WhORqEmmcdihY6Jh8Otq7cT4e7a/oICuBxeZvEWuZXDlueesJmmNfoigRQlM+7uAYoEB/tn6nQ8NdAUDngiTpM3W3QhhqAfaR79LDB6j1D5sB6i2S6rExq4Dgd8en8b7Ec77QHj44t3dXKmg7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1w5T8vXx9NM9HNwUfIMSniPLpzcI3d1PYM/NcXsELuc=;
 b=YE//WqTULEYAMKEJ1nmkpZfaeiYwm5h6jHfmxar/EFYNZkOdwZD9PWjD5OjCPJQzSoHXG1GQFZLWejGtl6VRBd3HrEzvesDyeimkF3ku4E7/MyS1zM3f/oaU+A1VbxVPnvzGS8mTvOLttQZnCVWsQsdH1L4WSZz54adGeo6OZpo=
Received: from BL6PEPF00013E0D.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:11) by IA1PR12MB8358.namprd12.prod.outlook.com
 (2603:10b6:208:3fa::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Tue, 15 Apr
 2025 11:06:35 +0000
Received: from BL6PEPF0001AB4D.namprd04.prod.outlook.com
 (2a01:111:f403:f903::4) by BL6PEPF00013E0D.outlook.office365.com
 (2603:1036:903:4::4) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.26 via Frontend Transport; Tue,
 15 Apr 2025 11:06:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4D.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Tue, 15 Apr 2025 11:06:35 +0000
Received: from [10.85.32.54] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 15 Apr
 2025 06:06:31 -0500
Message-ID: <d345b636-792f-4762-8c6c-2a7252294068@amd.com>
Date: Tue, 15 Apr 2025 16:36:29 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/67] KVM: SVM: Delete IRTE link from previous vCPU
 irrespective of new routing
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse
	<dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Joao
 Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-12-seanjc@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <20250404193923.1413163-12-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4D:EE_|IA1PR12MB8358:EE_
X-MS-Office365-Filtering-Correlation-Id: 84e99587-d2d7-49bb-3e60-08dd7c0d9624
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bndaYVBzbXpZWDJjcnd1T0g1UU1kRXJYbFEzK0NRb2lvRE54dmxkQi9KRlY3?=
 =?utf-8?B?eTNwWUJnTHRzTWdsWEwvMmRpclY5cHY4aFd3bEpLV09BTUZiYzVQaHRnV1l4?=
 =?utf-8?B?Y2Q1aFpjdHRTUENMalZ5SERJVUJPeFFaSEZKemk2cXRpWlJ5N3d5SXpyZ21z?=
 =?utf-8?B?Tmp1UkVaZCtpQi85TC9Fa3lSbThwY0NPUUZRVStWdENKNHVhRG9qczhlQmNm?=
 =?utf-8?B?bzZJV2FRblRXajBSVVl6ZHZBeE1kY1EwMzIzeWErNUpMVDNvcWRGK0haUGY3?=
 =?utf-8?B?WVowMzUydGpoaXBvRlN0eUMzN00rcWNtbk0zMHZyTi9FWHJHSkgyU2NHVS9m?=
 =?utf-8?B?b09mcmN5L29jTXRnK0MycUl3WlI1b3Y5K2IxTkdHRysyenZSV3RqdHhGZmJ5?=
 =?utf-8?B?VkV5ZlJCVGNZVEpnU2RiKzVTRkxaWjN1NmxOZXo3b3kvenlkTVJLVmNtbjlE?=
 =?utf-8?B?RW05TEdneEg0QlFuWFlaTm5rZUhFVExxaHhIYjBERUVGdjJhMWc2a3BnMDRO?=
 =?utf-8?B?dThxTE9UK0JabHQxNzM0QjM0by9adnNKUEJZdWh6dmdpNE1WWUk4ZDdGQnRh?=
 =?utf-8?B?Ni9TSWpIWTZjZ1JtYjZzcDhxQU41eFh2c1loNW43MFFqUmNPNTM2QXVZc1po?=
 =?utf-8?B?RGFNZkthRmVqaGg2NzFReUkwT1Fub0poVzh5K01OSVY5Wjhyem5oR25CdVBp?=
 =?utf-8?B?clhIRVN0bFoxOWR1VVZtbW1zSDh6dzJldDdiOHZHYTc0WHl5alA3a1ZFdUU0?=
 =?utf-8?B?RHptelZEQVdNOUhvckFOTmhsdm1wTWVqdUk0S0ZIQ2lUdjVpS0lzSCt3c0FW?=
 =?utf-8?B?VG5kelFrNWdGUk96Ny94OS85WWY3c0ZwUzd6RjR0R1dZZkpOVlBRQTd1TWpB?=
 =?utf-8?B?R2ErcU0wRmpMaFVQaEN5VVZjWkVaS1BWWVZPZEFjUFVac21qMjk4dXlVbjdR?=
 =?utf-8?B?RzJ1R1lucldCSjdnbFF6ZGNxVWhiRVlEbGpRNWRVOVJjU2ExdXFOb0dIMUcr?=
 =?utf-8?B?UFNhazgrSmt1alRzYzFqcitIUWJZakN5RXlzbWROR1BYQk0wcXlDUy83OEtG?=
 =?utf-8?B?dCtiMlJaVkdmMW9PQ0pTUDQ2Sno0Q2t2ZFFRa0dNQktjLzV0R0x5QWViYk9P?=
 =?utf-8?B?cGthakVnK0pMMis2Q09tRDVCc25rSWVNSXNienpMVUxnWWFhUlBnbjlZYW9w?=
 =?utf-8?B?ZlZwRW91UGtKQ0p6Y2Q1eXR4OTJ5N1FGOXZyRkJaKzdMVHdQYkczeXJEZXIx?=
 =?utf-8?B?Q2EybGYzaFBGOHhHZnJjM1RiQzRjVHdZUVNkVVBTMzNkN2hjQmVZVjk0L2k5?=
 =?utf-8?B?VEF2SXJac05Td25JU29HYkpheU9zUFU1T0doZVg2VmxyOEhlczFidk9YbVlz?=
 =?utf-8?B?cjZvYTFod2l5dnBPVDFkT0xtWkNLYTNMTUZ1MGY1VkpQMHZMUzlSM05sMWpq?=
 =?utf-8?B?YmRlWDkvME8vaXpySUFtMFZGbmpHeEZZcmxXckNZZXUxM1BGR1VHSERnYXB4?=
 =?utf-8?B?Ri9Vb3EvWVhqMDRIM3V4T05wK3VXN3ZVYTZYcUY1ZXJScFlVRFZubllybFVG?=
 =?utf-8?B?T1JUeFRhNHZoenlwbUdHSWw2V3lkbDJnWVdJejMwMVZtZkYxSkV5elF4TmxE?=
 =?utf-8?B?d0lkdmpQVXdtbEhlUXYxQ0pYWEEyMjZxelBRemhtbEd2KzdTWFdwYlNYVDBn?=
 =?utf-8?B?R09WOThMcjNwdlZqM25RaEJUaUVMWUFCaVFZakEwNVRiMkpvWW0yRzRkUThY?=
 =?utf-8?B?a1F0N3EvTHhnVk9FZ0ZQV25paEdpVVNDREc4Y2lLL0d4OFNrSEc1RldpemlK?=
 =?utf-8?B?dUlETzBTRWR5cmIzN2IvV0VUcGk4U20ycndoQitVYk9Id1EwZFkwYnFmY3NL?=
 =?utf-8?B?RGxray80TTdFL0ZHeERrQU1pdERDbU9rVkNGSWMyeThEZGYvajIyM0NvZEdT?=
 =?utf-8?B?QitoVUdEQnBrYWtTdlk4UGYzdUxnNTl4YmdUNkhpM3lqY2dycERlVDBMNVJk?=
 =?utf-8?B?QTRqMWJtWWUyUXZFaFljODNvZW94K2RZUXV6S1dBdHQ2b3l4b0tWWDhGblZI?=
 =?utf-8?Q?tLSCDj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 11:06:35.1542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e99587-d2d7-49bb-3e60-08dd7c0d9624
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8358

On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> Delete the IRTE link from the previous vCPU irrespective of the new
> routing state.  This is a glorified nop (only the ordering changes), as
> both the "posting" and "remapped" mode paths pre-delete the link.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/avic.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 02b6f0007436..e9ded2488a0b 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -870,6 +870,12 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
>   		return 0;
>   
> +	/*
> +	 * If the IRQ was affined to a different vCPU, remove the IRTE metadata
> +	 * from the *previous* vCPU's list.
> +	 */
> +	svm_ir_list_del(irqfd);
> +
>   	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
>   		 __func__, host_irq, guest_irq, set);
>   
> @@ -892,8 +898,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   
>   		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
>   
> -		svm_ir_list_del(irqfd);
> -
>   		/**
>   		 * Here, we setup with legacy mode in the following cases:
>   		 * 1. When cannot target interrupt to a specific vcpu.

Hi sean,
Why not combine patch 10 and patch 11 ? Is there a reason to separate
the changes ?

Regards
Sairaj Kodilkar

