Return-Path: <kvm+bounces-72954-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MEVyGErqqWmLHwEAu9opvQ
	(envelope-from <kvm+bounces-72954-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 21:40:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 95013218410
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 21:40:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4C57C30508DF
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 20:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE0E7345CA2;
	Thu,  5 Mar 2026 20:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0UxFGhNh"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011044.outbound.protection.outlook.com [52.101.62.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680B8344D88;
	Thu,  5 Mar 2026 20:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772743077; cv=fail; b=DZglfyqatjG3fI6ASHrppT0Gk+/tf+g7zkwhb0699w/ZYYtK2eWKevIFsQ57YxXQBUBCcB3h0ftNA5mRBBo3ECrCgPNhwO78mvm/CrXctLQV8JJfzEWRh4bE1pG2MixGTrJ3Dc2MwebGQLkw7c09KLYmVq37h3BDP7rQnfmyAjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772743077; c=relaxed/simple;
	bh=AjSmawU17eyphsbpRzCiLPok01ESFU5peDSkiLCdHoc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=n5v9Jk8K5XXaigpMbN0hMDT6blxl/Du27+AAo7F06HLIK9jO55NfgwpjxdZEcP2qTofBTvs0Teaz6qloDiQHrR33N3OZ0QmO20NN/Q3JmQM8O29GZt0GUbQr246ZkxhxKkWFkaIY2vU1v/fHlAIBqA5moWD+I9BKxNUDXme7joE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0UxFGhNh; arc=fail smtp.client-ip=52.101.62.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N9ryjaAENDSsg4/+mde/KvaholKaJYqy2Q7B9VzUHstlFTIdubNCEyIJnxYqa4dVXSaHACOc3+YKPsmU09AV3sGLb7j3v92ndjgZ2FJe+aB/oYwDphRarTNCXGLkbQCOM2g5pz3rqiyuzt4iNcAL6HGNXWjS4aEH7TtmZYk24G6x617vczc7yqaec+Mep7w+pf/Su+f+kscpysef4kAjK45eDzHLPw1xTAVkuij7CG97yywqr85qfzREzhZd4cW83oEcBHWWRfNc1TuONw0hBvXufaNSI7r5s/STAwq8ItzzuPamJpbxvkqEUveUUnmVDhdBLswd3JunPqGjmOTjHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiKzLPswhOzPzGVK1fAkLi3/ZXAFgnZS3n7EzIVL7Fw=;
 b=o1AxulfOFHNH0Tezlf7fhSOMFiAEEi687LPVVgnbi2jsh/3PpiM23IiUWiy/EjPgOV0FPXG2gR3umB8wHvER7jSK/GokgoBnpg+nmfPO67yK6wgoATwH3cbiMbxZcMd+IHFrjLr5Q7fNvmGsroHNTnWyDpmDiW5HKKgom9Q7rGr19EMPbf1NZBpWrEgM/RZC8qhvEYtDcA+Y3/V6Sha4rXCmZm1jH0f1pE/l7F+h9Qr3SgH+NxmFTiR7QYvj1FtghRCZUIdkZuq+UnGH+SeiXQfS3AVl+w3hR3QO8GE50LSrI7jouEz9I4td3UlU/+cuVkB330F9wQwjz3Y9Peit9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiKzLPswhOzPzGVK1fAkLi3/ZXAFgnZS3n7EzIVL7Fw=;
 b=0UxFGhNh8n3IbU0gNQpEfYjagbe2tjWTeVUukTdQhq0D+BpHFHKSfUuqr7pYtzDSNU3qW0zwyE89AsoxeuUF84DaO4BRojAS/U7FaFNf/Yj1pQxEXfqEK2f8FEcERERE26PNNaRA6r8rBjPZRhRg9VD9R0ctOTkGajb9Q4fAAZY=
Received: from BN0PR03CA0029.namprd03.prod.outlook.com (2603:10b6:408:e6::34)
 by CH3PR12MB7595.namprd12.prod.outlook.com (2603:10b6:610:14c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 20:37:50 +0000
Received: from BL6PEPF0001AB4A.namprd04.prod.outlook.com
 (2603:10b6:408:e6:cafe::74) by BN0PR03CA0029.outlook.office365.com
 (2603:10b6:408:e6::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.22 via Frontend Transport; Thu,
 5 Mar 2026 20:37:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB4A.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Thu, 5 Mar 2026 20:37:49 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 5 Mar
 2026 14:37:49 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 5 Mar
 2026 14:37:49 -0600
Received: from [10.143.199.149] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 5 Mar 2026 14:37:44 -0600
Message-ID: <8c25adff-1230-479b-b56d-784cdedd8758@amd.com>
Date: Fri, 6 Mar 2026 02:07:42 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
Subject: Re: [PATCH 3/7] KVM: SVM: Save restore FRED_RSP0 for FRED supported
 guests
To: <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <nikunj.dadhania@amd.com>
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
 <20260129063653.3553076-4-shivansh.dhiman@amd.com>
Content-Language: en-US
In-Reply-To: <20260129063653.3553076-4-shivansh.dhiman@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4A:EE_|CH3PR12MB7595:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c4d7178-9712-460c-c631-08de7af7114b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	hAytkLMpO1JyVc0dOVoXPL3W0/vHh9BHU2FIArEpPoigTBrw16AeV3Hny7wEpLXpLrUT+7WuxlRMCIchBF5866aimmeryKrMEpeTW6S7PfUEMD2vS9Y6GZnymH/A4ZdrYScJ1Ld02vveOs/yImLgTN/EjJXKsndczwfrlSOUCI4VbI+/SD2h/pPHEiQeHAYQXkZv1aRwxsW2tGuC1JjyCoXS8QgQe7VpXArxFJmHut4clfzGmcSPRj6+Qxd2X0dq7tbAYVGUMumE6Q6KDQEE8fOakAqlq1pw3ho+pYqFQiAm+WMLTyzNTS/4k8CyShIMZ7D1jbrXmcfuDbyMXzH6OqX4ZFexdUIo3rgKqo8N82SEV0CBVgYFtsnAwrw8jNAvL9SyblFcublgy/+Kyp052p465C8pYo1iudMKeRNlC16uoxSJTcfRJc8OU3Z5agcmyGOX+R2ydz1q7gx4eQOjGmooLp65DTacQ2WC07dV2xeKADpi+Wej091bLv50sZ5t2w7nf2X7aOdWLUCSztZbEZbfHiYniCbV0L7Ewdv06ERWKVtTPLYDtpIaUUrs1wLmMAPxOsENgNQsSAg6fVtHNcrutdcNdJVoXrWxJc1QK7K54mghr9R32gdeGSf/8ILFv+EJxo8wY5CeBlU/W4NjmvVS4buTnUJDcUsamA8/uRkqjWEo3THxTtIUe8ShMMqLfG5c0tD6hKBWbySKv/POmrg7/j8zkG02S9IHbZyDc+UIDbbVx8C9XDdo7JiAAxTnGWbLG+xiubzGeZe4hiPs9A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TPNGHTv1i5Aq6ThpbEMgEnAens3HC1vBUvADOKNMrXD6HhQxXPO4WHdMv19h5GYJFQSBMTWD5IY8HJUbCgwd6m84MjxORLlzFpgb2J+qeiKWA2dSJClsreIyNU21nllHa7p+oqoLKdGIVdo1zzBkeWYv8ytG2AiIWPS1vzCHn8lUBkTihMprKHiokb1Oc2vT9dY4oQL/DzxG37E0N1F7/pVI1PQh8jeyo2oLIB/yy0tLM6Ctc0wqFeZhLyx2Pme2KINMjnk0frP76mxEZIsRpWiOLlIayb1fA7AXI2VAGTHBK9kTTyJI52xG0Jy1Cx2u6Ru4MSJRa1RZCJHgbiFLllfm4UF/V1LA8QSA0yvp0SSxE1xIUZ30h53YgTZyaDPjEBtqDr10mVNUasmvuZp5AfZhxger48ZP0fnYFJ8guVZFoCn5P93bp4znoULwMZ8K
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 20:37:49.8428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4d7178-9712-460c-c631-08de7af7114b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7595
X-Rspamd-Queue-Id: 95013218410
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72954-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:email,amd.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Action: no action

Hi,

On 29-01-2026 12:06, Shivansh Dhiman wrote:
> From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> 
> Hardware does not save/restore FRED_RSP0 for Non-SEV-ES guests.
> Save/restore it early in svm_vcpu_enter_exit() so that the
> correct physical CPU state is updated.


I'm planning to improve this path in v2 of this series, by moving the
restoring/saving of FRED RSP0 to svm_prepare_[switch_to_guest/host_switch]
respectively, thus saving some MSR accesses. Any comments are welcome.

> 
> Synchronize the current value of MSR_IA32_FRED_RSP0 in hardware to the kernel's
> local cache. Note that the desired host's RSP0 will be set when the CPU exits to
> userspace for servicing vCPU tasks.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> Co-developed-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 05e44e804aba..ddd8941af6f0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4192,6 +4192,15 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
>  {
>  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	bool update_fred_rsp0;
> +
> +	/*
> +	 * Hardware does not save/restore FRED_RSP0 for Non-SEV-ES guests.
> +	 */
> +	update_fred_rsp0 = !sev_es_guest(vcpu->kvm) && guest_cpu_cap_has(vcpu, X86_FEATURE_FRED);
> +
> +	if (update_fred_rsp0)
> +		wrmsrq(MSR_IA32_FRED_RSP0, svm->vmcb->save.fred_rsp0);
>  
>  	guest_state_enter_irqoff();
>  

@@ -1391,12 +1433,34 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu
*vcpu)
                sd->bp_spec_reduce_set = true;
                msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
        }
+
+       /*
+        * Hardware does not save/restore FRED_RSP0 for Non-SEV-ES guests.
+        */
+       if (!sev_es_guest(vcpu->kvm) && guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+               wrmsrq(MSR_IA32_FRED_RSP0, svm->vmcb->save.fred_rsp0);
+
        svm->guest_state_loaded = true;
 }

> @@ -4218,6 +4227,15 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
>  	raw_local_irq_disable();
>  
>  	guest_state_exit_irqoff();
> +
> +	if (update_fred_rsp0) {
> +		rdmsrq(MSR_IA32_FRED_RSP0, svm->vmcb->save.fred_rsp0);
> +		/*
> +		 * Sync hardware MSR value to per-CPU cache. This helps in restoring
> +		 * Host RSP0 when exiting to userspace in fred_update_rsp0().
> +		 */
> +		fred_sync_rsp0(svm->vmcb->save.fred_rsp0);
> +	}
>  }
>  
>  static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)

 static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
 {
-       to_svm(vcpu)->guest_state_loaded = false;
+       struct vcpu_svm *svm = to_svm(vcpu);
+
+       if (!svm->guest_state_loaded)
+               return;
+
+       /*
+        * Hardware does not save/restore FRED_RSP0 for Non-SEV-ES guests.
+        * Also, sync hardware MSR value to per-CPU cache. This helps in
+        * restoring Host RSP0 when exiting to userspace in fred_update_rsp0().
+        */
+       if (!sev_es_guest(vcpu->kvm) && guest_cpu_cap_has(vcpu, X86_FEATURE_FRED)) {
+               rdmsrq(MSR_IA32_FRED_RSP0, svm->vmcb->save.fred_rsp0);
+               fred_sync_rsp0(svm->vmcb->save.fred_rsp0);
+       }
+
+       svm->guest_state_loaded = false;
 }

Thanks,
Shivansh


