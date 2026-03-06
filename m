Return-Path: <kvm+bounces-73006-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAYxGFKiqmlLUgEAu9opvQ
	(envelope-from <kvm+bounces-73006-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:45:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E78CF21E2AB
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EAC6930CB8A5
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 09:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A24C9346A08;
	Fri,  6 Mar 2026 09:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AzW3JJn5"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013069.outbound.protection.outlook.com [40.93.196.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674D9345754;
	Fri,  6 Mar 2026 09:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772790066; cv=fail; b=JIQ24CPxSi7fbUfYvHh2ftLAW0nj9mTefgi9nHOexU9II2UGssPC6HCySBXp2KlgTbIBZShE3cSXsxjG0k2lugIhWvliRnIqx8luvXBLY4cKAzINM55VH+NrXn2Ne4/SXvrfvKtH13MWynMOBw/qVgBNjKatTOHTUZSI5/UZjQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772790066; c=relaxed/simple;
	bh=9kO3jXWrPg7Lkba3fWghx0TTnO0yCbVWZTo37R/3zCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tuTL7po2JJ1B7wTmDAfjibd0bq6psgY2ksH+x6bSxP56WaqoaEOP1+fDS3BElTHlEzqDJ4s8xmlA+FqmS1xDYML2LSzoUOlcDjQDlclLKloLK7+Ey0VUIlbEEV8zC5gUW2BBKJKho7uZmUF2wsGu5TPbakS/5OvT4DiOBLjzm6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AzW3JJn5; arc=fail smtp.client-ip=40.93.196.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JSIjzLXr0HVjVIY7nJkIE35lXwZIq2V7rMytmgqL3MRd0yufrIQsPCjtrO5e5Y5mDn6eIm7KQvVGnyoFqhXdc/6F7HFVRdDOfmP3HyF2+ps74bYMWrgcBnYt90PpP+eqwwezvyEXrHpLDklLZD26oWC2OQMEgyNjLc1xwsH/i2Mx0+k1QS6pFR/sH0NyhcZqCBG+uizul4HQc12+JeQBNMI1yNA0MEe1pJXcN1rv3QXL5nMyrSn64MVpS++d0r9zWyWzGLjsYRMPSvECbN4wqFXPJtQmnJQBnvhAs4qzCe4x9rNxlK6xl11ZVWWRKkIgEUuvogybskkIHYW5WwPyNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFuRhIy62JlIS0eRHjURDsyG4KVbo3+63ys19uPTq4U=;
 b=uKSL00/XcvQjGuvZo7Sb25qCDO9drV0CUVpxFAwuw/C6NYHKbjJklRsg9dfg4f1nj2b+v4+w2EsYKKJ3pmWHfs9UwIXyZYvPLbTlCLcKZIkxCAao44ro3DhEkhRKw+slljOhbcbM87lBOQg93wmuFKwe1klvez7bR4IT4wtUFVS/hx5J8VJhDJKFiahtEuOMjqD0hUr5xwjvyGhfUQcDhlAKskkUuBfylfKMBEGrFh2JAHqI664AoZOT3xuUtyIHS6ZoYIbn6sczABWSRdGeHnL16VFNJJR4wWnCwHaSTU3XGA0OZnafUUmPBXrD2l3+gDJiNawhysHiVAaxxjooGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=citrix.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFuRhIy62JlIS0eRHjURDsyG4KVbo3+63ys19uPTq4U=;
 b=AzW3JJn5wPGAEXZBUOg7f6lFcyJpiKokCPoubMARhjD4iz7X4bcLHaE/MuFi6oUSJxuziKaa/Q90GpvLQUr5bB3SB+5X4fAjfkebO31HlnNMPILE7cQLRSv8RtbdHI9szdeZbyg7cZehtXZ7wnugrqKa0z8h0B3FHyjWrRnMHk0=
Received: from SA0PR11CA0147.namprd11.prod.outlook.com (2603:10b6:806:131::32)
 by DS0PR12MB7827.namprd12.prod.outlook.com (2603:10b6:8:146::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Fri, 6 Mar
 2026 09:41:01 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:806:131:cafe::52) by SA0PR11CA0147.outlook.office365.com
 (2603:10b6:806:131::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18 via Frontend Transport; Fri,
 6 Mar 2026 09:41:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Fri, 6 Mar 2026 09:41:00 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Mar
 2026 03:40:59 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Mar
 2026 03:33:38 -0600
Received: from [10.143.199.149] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 6 Mar 2026 03:33:33 -0600
Message-ID: <f092feb8-c0e4-45da-ae28-06e5dd4b7aa6@amd.com>
Date: Fri, 6 Mar 2026 15:03:32 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] KVM: SVM: Enable FRED support
To: Andrew Cooper <andrew.cooper3@citrix.com>
CC: <bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
	<nikunj.dadhania@amd.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<tglx@linutronix.de>, <x86@kernel.org>, <xin@zytor.com>
References: <85958aa8-98ee-40bc-8fcf-750bbf62ccce@amd.com>
 <f3959d60-9622-4817-8b85-2b704c46c583@citrix.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <f3959d60-9622-4817-8b85-2b704c46c583@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|DS0PR12MB7827:EE_
X-MS-Office365-Filtering-Correlation-Id: d0f241b9-f6d3-4361-dfae-08de7b647a2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	JZa6xG0mb8sWZDOVOIu1CdNthwG1SbFHnuvdwp7zAuk3exFHxyFqLgbffDs/NWdKibO8sMHlGIhufXxQgdfF6c+7CVIL8Cu1JCTCw/9T18+nW6QgF15/h2mJHb703nJWNQQMyk143c9eZpbOYp9L9V+5oNd8cX//GFMihBnP0FFQ4+nNLaFCIPzOzuPSqSkJA4GsB3JWIXQZC5TbZ1lG6IUw/zMsKdQzclCYGFwqTNYsnk/RVqaGD+MSRSy3XOsKABxuM3K3cx60b1UDZ30w2e+wfKy0Rq7DBRc48Qe+f5+83WZ1lfPja/ngHiyqG4EfIcfoaoiR+Zniupo47fYKUM0tgauDQi0ndDYYLP6vNaDsauhzTBI07YpOCwA4sBCOnud6Lyi5+58Ujn83K7gFYXa2cfFqbcHlsRkGHDEKYcI4qf5zdwBF77ha8bE2Z7aC3PjNJGzlE9PqvR/YHkyw2VCoDfE64c0CeFU2AynZepCoYLGDKG/5YYn28rdfwI1kk+8ctytfYw71mVwb+HpvtOsflA5okMUAA20SZEDmN0WjteeVt+k81KjU9FhPu0W/xA9URfWcUfIL7JfZifDbm0Xfe0tdwmbvO+xMtbe7KlGmd49AN+dPryLd8Vqne32Jxxc0b8DDHwQ+5kwZQKVmbjisp0bWyWoe4hc/M3mSTstRCEi2sxDIsufUw7QG4sx2j1e+TENa77cKDXYL8Far6nVnDKNYSy7T3a1LUcANXCTRF/BkbJgZH6+iP6dZw3yDcDCLHrJ127doQl2STPgqjg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZhWvIK3aWQR7XFMxHkEOtUGL452YQ1KcXtd0gaaC2G/Ky2A4618Agux0WAorQ9aaHWdQCslpw0DaHnS+GuNPgFaA/GJLPCrBExEDLY+2hiOpOlcWlFt+3mjRczcdleGp6Qd40w5VFVtFbjYqh1E5Tkpy+KoCGeB3KKJaFpjcMQCLtqVI+/xyh5ZKwMsbUUR6hmL+K44p/KkCDyU99x49N0uyevzQbN4KXkxkTJUxYsmP802BtLgRrTsXWvYv4sN7L9DAXJ8bk6lFTTEqpRy/w5mZ1Aly4KwGDfChZGcbF3yN7pWsdZ4NhIQWLGHbJCVUw0vfA6PG9GfPZvYSud2tf03YNqO22e5elV7YupQ59F2nQ0x7Pb20Y/QyTQnSbB+vQ5p1EDql4wTnoLMq5tDiDvLcpbnXC8q6FPvvbF56z15pFCcjVn+aAoAk1PQPtHd4
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 09:41:00.9450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f241b9-f6d3-4361-dfae-08de7b647a2f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7827
X-Rspamd-Queue-Id: E78CF21E2AB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73006-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Action: no action

Hi Andrew,

On 11-02-2026 06:23, Andrew Cooper wrote:
>> Here is the newly published FRED virtualization spec by AMD for reference:
>>
>> 	https://docs.amd.com/v/u/en-US/69191-PUB
>>
>> Please feel free to share any feedback or questions.
> 
> 
> FYI, there is a fun behaviour captured in the sentence:
> 
> "If FRED virtualization is enabled, NMI virtualization must be enabled
> in order to properly handle guest NMIs"
> 
> i.e. hypervisors need to make sure not run the guest with FRED &&
> !vNMI.  AIUI, there's no ERETUx intercept similar to the IRET intercept
> with with to emulate NMI window tracking in !vNMI mode.

Thanks for letting me know about this. Seems like a legitimate consistency
check. I'll try to integrate it.

> 
> I requested that this become a VMRUN consistency check, but was
> declined.  I've asked that at least the wording change to "undefined
> behaviour" so something sane can be done for the nested case where L1
> tries to do something daft.
> 
> 
> There are two other issues which are going to be adjusted.  One is the
> consistency check concerning SS.DPL==3 && INTR_SHADOW==0 (not a valid
> restriction in later drafts of the spec), and one is "On an intercepted
> #DB, EXITINFO2 has DR6 register value."  Both do/will (not sure which)
> behave like Intel, rather than as currently documented.

Can you tell under which conditions does the #DB issue may arise?

> 
> ~Andrew

- Shivansh

