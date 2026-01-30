Return-Path: <kvm+bounces-69706-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cHjrJk+xfGmbOQIAu9opvQ
	(envelope-from <kvm+bounces-69706-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:25:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC0DBAF9C
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:25:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A3834301E99F
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24A021257F;
	Fri, 30 Jan 2026 13:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SnKLRsr7"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5A22ECD2A;
	Fri, 30 Jan 2026 13:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769779517; cv=none; b=NG6mREBi7WYl0PnUXKtMC1WoyyDzcqanAC7H6SBYu0iQqjpJMSqfrWggh6onrCEqB01Imn8iG8FDa1ifYOdkLrnJfFuS/h2ImFqWbsK05Wj1JvQPlSgNF9wx0sA4PbNyVhINbRBYEoi2/qDsrS6r+pp9HyBWtkBfB/CD01GVNoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769779517; c=relaxed/simple;
	bh=t/GHaoAbRVqc6Qlj0IcYCoGbXhgSXmgrX5n6f0/rIOg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bLdqXkcjD4Fu+wBNFWSLp6Zz0Mm/oZDRk2vIvuyjhzuzToR8OgzKLp5JQ8cfO6Pe/TkneMUWN6sOORegwsfZ4rl/0thgpScHUYcjIe2L6y77ah4fkWxy7pIRMkt6pH7QSoARCLc4br9qBin9KEqI1tn0F1KlyriOl6mYr2hqkSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SnKLRsr7; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769779505; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=RozGlFaTYGMc2+qnEcfwrS17KdH/KSz4VErfc5KgN2Q=;
	b=SnKLRsr7JAigJDeh1CZVRQRKkwURo4rhukZRhGFOe8Xv5tF55AFTy2IztHWLBwn6aEp+dY2SPjXxiaPNGeW6oxQWwW9PV+CyXYSyKfjZ+vfii6lJPaF0+1lzyUIw9y+36eXnC91DXd0s8xsJkKOXCx2lqCEKNko1ddthzJEHu0A=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WyAvvCj_1769779501 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Jan 2026 21:25:03 +0800
From: fangyu.yu@linux.alibaba.com
To: radim.krcmar@oss.qualcomm.com
Cc: ajones@ventanamicro.com,
	alex@ghiti.fr,
	andrew.jones@oss.qualcomm.com,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	corbet@lwn.net,
	fangyu.yu@linux.alibaba.com,
	guoren@kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	pbonzini@redhat.com,
	pjw@kernel.org
Subject: Re: Re: [PATCH v3 1/2] RISC-V: KVM: Support runtime configuration for per-VM's HGATP mode 
Date: Fri, 30 Jan 2026 21:24:58 +0800
Message-Id: <20260130132458.16367-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <DG16GDMKZOBM.2QH3ZYM2WH7RO@oss.qualcomm.com>
References: <DG16GDMKZOBM.2QH3ZYM2WH7RO@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	SUBJECT_ENDS_SPACES(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69706-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fangyu.yu@linux.alibaba.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	RCPT_COUNT_TWELVE(0.00)[18];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,linux.alibaba.com:mid,linux.alibaba.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5BC0DBAF9C
X-Rspamd-Action: no action

>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>
>> Introduces one per-VM architecture-specific fields to support runtime
>> configuration of the G-stage page table format:
>>
>> - kvm->arch.kvm_riscv_gstage_pgd_levels: the corresponding number of page
>>   table levels for the selected mode.
>>
>> These fields replace the previous global variables
>> kvm_riscv_gstage_mode and kvm_riscv_gstage_pgd_levels, enabling different
>> virtual machines to independently select their G-stage page table format
>> instead of being forced to share the maximum mode detected by the kernel
>> at boot time.
>>
>> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> ---
>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
>> @@ -87,6 +87,22 @@ struct kvm_vcpu_stat {
>>  struct kvm_arch_memory_slot {
>>  };
>>  
>> +static inline unsigned long kvm_riscv_gstage_mode(unsigned long pgd_levels)
>> +{
>> +	switch (pgd_levels) {
>> +	case 2:
>> +		return HGATP_MODE_SV32X4;
>> +	case 3:
>> +		return HGATP_MODE_SV39X4;
>> +	case 4:
>> +		return HGATP_MODE_SV48X4;
>> +	case 5:
>> +		return HGATP_MODE_SV57X4;
>> +	default:
>> +		return HGATP_MODE_OFF;
>
>I think default should be an internal error.
>We can do "case 0: return HGATP_MODE_OFF;", or just error it too since
>KVM shouldn't ever ask for mode without protection anyway.

Good point. Returning HGATP_MODE_OFF in the default case would hide an
internal bug (unexpected pgd_levels). I’ll treat it as an internal error
instead, Something like:
    default:
        WARN_ON_ONCE(1);
        return HGATP_MODE_OFF;
    }

>> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
>> @@ -319,41 +321,48 @@ void __init kvm_riscv_gstage_mode_detect(void)
>> +unsigned long kvm_riscv_gstage_gpa_bits(struct kvm_arch *ka)
>> +{
>> +	return (HGATP_PAGE_SHIFT +
>> +		ka->kvm_riscv_gstage_pgd_levels * kvm_riscv_gstage_index_bits +
>> +		kvm_riscv_gstage_pgd_xbits);
>> +}
>> +
>> +gpa_t kvm_riscv_gstage_gpa_size(struct kvm_arch *ka)
>> +{
>> +	return BIT_ULL(kvm_riscv_gstage_gpa_bits(ka));
>> +}
>
>Please define these two functions as static inline in the header files.
>They used to be just macros there, so it'd be safer not put LTO into the
>equation.

Agreed.

>> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
>> @@ -105,17 +105,17 @@ static int __init riscv_kvm_init(void)
>>  		return rc;
>>  
>>  	kvm_riscv_gstage_mode_detect();
>> -	switch (kvm_riscv_gstage_mode) {
>> -	case HGATP_MODE_SV32X4:
>> +	switch (kvm_riscv_gstage_max_pgd_levels) {
>> +	case 2:
>>  		str = "Sv32x4";
>>  		break;
>> -	case HGATP_MODE_SV39X4:
>> +	case 3:
>>  		str = "Sv39x4";
>>  		break;
>> -	case HGATP_MODE_SV48X4:
>> +	case 4:
>>  		str = "Sv48x4";
>>  		break;
>> -	case HGATP_MODE_SV57X4:
>> +	case 5:
>>  		str = "Sv57x4";
>>  		break;
>>  	default:
>> @@ -164,7 +164,7 @@ static int __init riscv_kvm_init(void)
>>  			 (rc) ? slist : "no features");
>>  	}
>>  
>> -	kvm_info("using %s G-stage page table format\n", str);
>> +	kvm_info("Max G-stage page table format %s\n", str);
>
>Fun fact: the ISA doesn't define the same hierarchy for hgatp modes as
>it does for satp modes, so we could have just Sv57x4 and nothing below.
>
>We could do just with a code comment that we're assuming vendors will do
>better, but I'd rather not introduce more assumptions...
>I think the easiest would be to kvm_riscv_gstage_mode_detect() levels in
>reverse and stop on the first one that is not supported.
>(I'll reply with a patch later.)

Please refer to the discussion here:
https://github.com/riscv/riscv-isa-manual/issues/2208
If Sv57x4 is implemented, then Sv48x4 and Sv39x4 must also be implemented.

>Thanks.

Thanks,
Fangyu

