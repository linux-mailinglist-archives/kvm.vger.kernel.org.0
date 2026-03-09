Return-Path: <kvm+bounces-73362-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4BypDr0nr2mzOgIAu9opvQ
	(envelope-from <kvm+bounces-73362-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 21:04:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AE0F024096F
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 21:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 630ED3169EEB
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 19:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EAED41B34A;
	Mon,  9 Mar 2026 19:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gNZxb2aE"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011047.outbound.protection.outlook.com [40.93.194.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACE141161D;
	Mon,  9 Mar 2026 19:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773086288; cv=fail; b=UsiZ0P7oKkJBl3E3FawNo64m/VOXcP/QeCWNd/0OIYoIwGEgt88t1akC2eAYmblpT2bUCabbFOE5PAYh1Q/ZER1I2X7MqWykn0Lq2fe9EZu3ple+1KBPm19exZb0UZ5YgVlXGuSV98cJmwcXwrX4GGX3FFKvmBKwDmGmCvLWKJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773086288; c=relaxed/simple;
	bh=1Lx5sS85+6fQb1lZJnDWxpuYDecQ4yqm6GQgzfDxvXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Jp8C7ZDqKxa4zcgJo3yCefU3B+LcEAJL/C2z6DaC+7N2EJQD+ps5LpA7IbHEuYbEEIzWRRt4cis8kUv83MKpHBy7Bvb5Exn6wkKvDG+WteFOXFoo+kLBkoC4C5L8oDouBnUlwZtaFZV0IHaL7llLlzufk0kWYWso1nHQYCh7saI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gNZxb2aE; arc=fail smtp.client-ip=40.93.194.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ENGmQ7KrlOMD7UtyCjArLzTRhiGQm1pPip0bsHAC959HWrZ0qxoMKslVHd5PlFym71OGFBbeGJxuuTNwL+wrchscNM1UHZgeAdzQZ8MlaH30L4fw/t3xn1modQi0cf+aOVk4pxd/iN9N1IzZ2xvtypnhhihJG2f1Mb8yr5MHwuulePmfe3ZMGLUqtNkh6tzhiRsHMry1NgczfVBWvG5WnzS8vqSdC9svo6UHWCULnzANiP2afFopSGLiNEh9WeuhyVFN8tE5MQ5Zms/bb0KJyTEYgktPpahMUH8Me66uiRpQmzGtfzql+JoXpX3OEyhUyFXdD7BgSew8cLXVx1tgjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EqFnGq03xYqS+QQU1pXtuAjZVPsOmwD+eJE+IEXn4w4=;
 b=vBSDblc9LhpDIzRgi042j+TkIWuizcPJx6eHzyj9OJN/LkRKuBbDsY4nS53URag8APdUEzT/4itKpDEGgvr1nq7TAUpgv2IHbX9U/AajMhsrDg6gFj2ik7N9UvMniYIktNBO1WjVRji2XDovFjUtVO+6dyhD8Lnq+22oKnn01lQf58IIHiq15ihFlc8pDiSGCVEdx3reiiBkq9LdKAhBqXslCyArha8o6qoEaIVL9aQfRppI6ErQIbuJ5hvfrY3FmCcxlET9cjMGvyuKtkI6RCUJUCHAeXTctYJsoOjo2dQV+3ozheWS7IRJJYQtvDvbOiysclLhUqo8HbQmcxW7lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqFnGq03xYqS+QQU1pXtuAjZVPsOmwD+eJE+IEXn4w4=;
 b=gNZxb2aEnXOPPVoPv83TiZ+fdx01cSi7vsIUmhkC1DEFvKA9tnY6zuWi1t5KJ6PtExKuojDZuWZVtiUpLxI0u0JkqJ1vI5Wg4XyD0fWtQqxc16ZjH0wWotu81PA1ADbFxkuib57Nq2ssOH71r7LW0oaJi2Kysb5imzYLRtlW4gQ=
Received: from IA4P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:558::16)
 by SJ0PR12MB6712.namprd12.prod.outlook.com (2603:10b6:a03:44e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 9 Mar
 2026 19:57:58 +0000
Received: from BL6PEPF0001AB77.namprd02.prod.outlook.com
 (2603:10b6:208:558:cafe::96) by IA4P220CA0007.outlook.office365.com
 (2603:10b6:208:558::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Mon,
 9 Mar 2026 19:58:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB77.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Mon, 9 Mar 2026 19:57:57 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 14:57:55 -0500
Received: from [10.143.203.87] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 9 Mar 2026 14:57:51 -0500
Message-ID: <c93ccd61-9ce5-43b0-99d0-fad0b08b545b@amd.com>
Date: Tue, 10 Mar 2026 01:27:50 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] KVM: SVM: Dump FRED context in dump_vmcb()
To: Sean Christopherson <seanjc@google.com>, Shivansh Dhiman
	<shivansh.dhiman@amd.com>
CC: <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <xin@zytor.com>, <nikunj.dadhania@amd.com>,
	<santosh.shukla@amd.com>
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
 <20260129063653.3553076-7-shivansh.dhiman@amd.com>
 <aauHhQsIzJo68bW_@google.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <aauHhQsIzJo68bW_@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB77:EE_|SJ0PR12MB6712:EE_
X-MS-Office365-Filtering-Correlation-Id: e2f15910-c6f1-4046-9505-08de7e1628e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	FTufI4OhSDr0j3f/9ZcNzi5/TSfDutTkXz7ugPcsQvZz2eLarHp20nofCgSygqaLS9JUrTbET0sqY2F3W/nYx7b3Lf9tCqkufmbwryT/XP2z1PcDwaEBxKiJQrmu4z6HNnhFGkREGQS8munC8vgwN/Ikhbs3VZiBUm3oDxVVJjLGV+YnvK0Nd8tdTt0zWzA65Py0WyHsn2ZsAklaZHhyLhBQCbiQ8inaAfVKNsZeVv5b7eOHBwV5+RF3K0yX7czuu+/10LDijSIT/TBhDpAXV8cJ+cBdeCKGUbX8v1j9VA504f7yKSNTu5svfGiL/Rdh3MlXPFchjLp8/eSrwqC04a/ecSdQQI+l7UqHlk6N9siJKbkxSEBsF9lef9RKlw1Ya7JyHPXf76e4DxvkMtYQ4NzACJ0QR0oEjazbQ4VVsnJWnU2MHnXaKXEZvDw1JIXjzB3ChkBsw02//MAmbur4Nay1l6ji4+3gT4gb255q4/6zgIeJUIPgrs3HrPAo3H1BbxSExYD/883zWl2zsyCUX+9s83jCBVrz9YA6hZu1+8GTYMbD0QH94pzjCf9sZ7idUtAO5+grWXy6PEnuLQAxGNAjx6m0ScuU51QacTMvSfH1Hp9XBJC1vxSHP8SsVoDzIyA/bH/f3EwWacrjxwS0Vexsq1BOTH1lyLBl0JTVa8Cy3w/QX3UCkL1LSskbpB+cNt5haW0bBGXS59N2O4GyoMqwFg2DbRgECoRTp8JaIXlR+cdn2Eyqmzs0Jw/zi76dQnDDjxrQB0aJ5yLT+7vcsA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	T3kWQot8m90yQGYJAn82EsbVfvaJC8vscuqtbhA1yIMa3lqLdFEow5pcxs5sY8PYyCyW73JpYf4Dnw3DG0QYHzDz3UVwTuT3Dybwyg9lp2fLcqBindNfo32PvKXKkue3bsKXrI7fMKLrU29A8htfkMDQkEqc2JlQgZjmMAkT9BotmnVoAbPFa834HiaYNhj76+9pUuwjo6fs1geiB94It6tVil3bKqRVu8qrvn28qEjKyAddWzrQ4g/ExWaCc3GapgdG/HDJMafbbXAvMdnYR+s7PNRMVx0Nt0c3ScsQGl2jIhS+L7w/ciz/G2Klv9U5xY9VuYe6X/0Iqclls/zNyHC2WirBUlvGITVpkbPMX+m2uE2Empu/Y3zNSHFXq5WVoyQrdT3EuC5SdL4VyPyLTwhApQ+M2V1uDY2cloQUBvbIA8G9oImS0EwDlbPeuK6M
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 19:57:57.3394
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f15910-c6f1-4046-9505-08de7e1628e7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB77.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6712
X-Rspamd-Queue-Id: AE0F024096F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73362-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Action: no action



On 07-03-2026 07:33, Sean Christopherson wrote:
>> @@ -3461,6 +3482,24 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>>  		       "r14:", vcpu->arch.regs[VCPU_REGS_R14],
>>  		       "r15:", vcpu->arch.regs[VCPU_REGS_R15]);
>>  #endif
>> +		pr_err("%-26s %d %-18s %016llx\n",
>> +		       "is_fred_enabled:", is_fred_enabled(vcpu),
>> +		       "guest_evntinjdata:", save->guest_event_inj_data);
>> +		pr_err("%-12s%016llx %-18s%016llx\n",
>> +		       "fred_config:", save->fred_config,
>> +		       "guest_exitintdata:", save->guest_exit_int_data);
>> +		pr_err("%-15s %016llx %-13s %016llx\n",
>> +		       "fred_rsp0:", save->fred_rsp0,
>> +		       "fred_rsp1:", save->fred_rsp1);
>> +		pr_err("%-15s %016llx %-13s %016llx\n",
>> +		       "fred_rsp2:", save->fred_rsp2,
>> +		       "fred_rsp3:", save->fred_rsp3);
>> +		pr_err("%-15s %016llx %-13s %016llx\n",
>> +		       "fred_stklvls:", save->fred_stklvls,
>> +		       "fred_ssp1:", save->fred_ssp1);
>> +		pr_err("%-15s %016llx %-13s %016llx\n",
>> +		       "fred_ssp2:", save->fred_ssp2,
>> +		       "fred_ssp3:", save->fred_ssp3);
> 
> These should all be gated on guest_cpu_cap_has(X86_FEATURE_FRED).  Just because
> KVM can read and print garbage doesn't mean it should.

Will include that in v2. Thanks.

- Shivansh

