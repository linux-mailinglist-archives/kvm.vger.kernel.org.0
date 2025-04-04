Return-Path: <kvm+bounces-42655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80C80A7BFCA
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:45:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66B743B568C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 14:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CEB01F4193;
	Fri,  4 Apr 2025 14:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KVfD5W2J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8851F3D30
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 14:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743777943; cv=none; b=dVI0NhWYwljl/xkzufIG8FIA8lQlQEuuFWYUg/lEWKxPc30LFYnrbhqdcU7VAdbr52BuTG5mau+L2X1p+uMo3NrK0gLNkrJBmYHIAjzIQtSBqNS/xofZOUuNCvAqmVzkUT782CFVaNJqy2KLfVv+Gr8Y1d8rEm4fJ0ZElI4dT20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743777943; c=relaxed/simple;
	bh=r3/VI4a4OjNrbliYn97P/QEzpIwEclWNIqQmn53U5g0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z/XFhPiFqY0lYAn6TtRBwqnj/PGRsErUBEOBew2M1Ry3cakhpXIn5TalfyPTje0DmGhC+DtZWCIwR9saNUCip1/sRKUU57LMWeLZGzaSEbiZca0YYNBnQCYGyM6aalXpiqnhAkiWAl2+4bEl7keo44DB7iP5+8NY7H4HDFuWnBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KVfD5W2J; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac29af3382dso335189966b.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 07:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743777940; x=1744382740; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JS/vd5e2tpXFd2QmetRNo1GU+HSThqX2mJTs6MpCaTg=;
        b=KVfD5W2JKQZ5b6cCApmXeIAANCSXGEbCKJntu4sRZkBNPMnN5//4VHWW4PqkNybZKe
         8HqsQlj0ZV149BGsT9Y2suoN0qtWzqxdzH56c2l37kncgVh39w7ZJ4vna/Xrw7VVvnnT
         5hhETFSR9NyysPz4gzx50a6YfZAHQgjrroGvj5ABKlJeNH5FRncEj08hVCMSQcv9AhLb
         dt54Cc8NwJfiPpW8YDu/ZNV0X5QXIEm5pHHG1dJ1DQjlNjQIKNI1UIDdhp4So/1pr11h
         w7PtVE650FMsjxFHbBmYiSOZb6lyWuy/lRj5ejFYJn67E+GzI6Q99rNw10Q/QSwkSFe5
         7+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743777940; x=1744382740;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JS/vd5e2tpXFd2QmetRNo1GU+HSThqX2mJTs6MpCaTg=;
        b=MfxBPmLmgRADROCi/sotmYt7lc7nioNGibcSI7VWal0m4X9Y7XJvTG66nBQUW5ioCB
         81wuyZGEQcCSo98iKrNruaz7aajWkqYnN7RKdRk0JJ0cJ5OrYDJIchFRdbvZXEQVFhx6
         W1WQU9/5AgFYQjA/kQHvMW+smcVW1P61n1qgHuzgGVbQU8ShON/ptcKySiOp3AzrMfJn
         QtAvGKb96XbQs/3sjKEbjlYLe5Atd6XDJ+lippw9+zsIlg/g+V9ItjLUBDpsy3f7n7qa
         Jfg4EwsxXke5DG4Ln+uwOXWDZ33P/yu15ikar+bny/AaxFSELvrqbM/825r25lAq6K0V
         aJ3g==
X-Forwarded-Encrypted: i=1; AJvYcCUGrDQiRhoMN6fgB0V4zxen8sJ1mkQBN+r5JaswDQsgju3UOfRlY1bbItKz4K+1mOVWmAA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN8POUrCg9m0MWh7VDKbp7YA3bY9lUCXb7iluLgLqVuIpvLiyi
	cNU+Xz53CjFP9SyWOBTwDo1XoI1fSGNTUBWrpSZJ6LJL1R1MJ/20dXmNevWQIek=
X-Gm-Gg: ASbGncuf9naQIG2B9zksaEVlU38CCUMVV+YuBhe65r3g86aBaOlwJpxNYyWPzcdOs0J
	CUgMjuSHjUL6jsfD2p/5FcbOE11urq8Kr5WSqMPYsqBPD2WlExQCiAfzFqwTuftN/fnUE2r8nrU
	l7C0JSigpx8MQlgyOzVo9jNjuPz3Zz5NmpsEbEIXNiGN/igIdvYjSCraOt2aGhVk07Pyj26w+h3
	mOYNE8mcNkUWIPAmNu4uoo4sHaOwWyTpzvZaH4AtVpq7j7ewcoH2iO0WRwvRsjR8INFUVD/DI1M
	ZvPFQeC6rbBlZDqJgf6V33lzVvZ4U+/s/PMJVC7/wr7P2/LNsA==
X-Google-Smtp-Source: AGHT+IGgE6fK51XzaItK5mqNYSNa3ub7nl36pgZn2lhhYKSKvPfmNH1p49Y/7GJRjtPyYKpXrLjxpQ==
X-Received: by 2002:a17:907:971d:b0:ac3:ad7b:5618 with SMTP id a640c23a62f3a-ac7d6cbdb44mr290443366b.3.1743777939632;
        Fri, 04 Apr 2025 07:45:39 -0700 (PDT)
Received: from [192.168.0.20] ([212.21.159.224])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f08771a1c6sm2503812a12.11.2025.04.04.07.45.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 07:45:39 -0700 (PDT)
Message-ID: <d5ad36d8-40da-4c13-a6a7-ed8494496577@suse.com>
Date: Fri, 4 Apr 2025 17:45:37 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] x86/bugs: Fix RSB clearing in
 indirect_branch_prediction_barrier()
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, amit@kernel.org, kvm@vger.kernel.org,
 amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de,
 tglx@linutronix.de, peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
 corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 daniel.sneddon@linux.intel.com, kai.huang@intel.com, sandipan.das@amd.com,
 boris.ostrovsky@oracle.com, Babu.Moger@amd.com, david.kaplan@amd.com,
 dwmw@amazon.co.uk, andrew.cooper3@citrix.com
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <27fe2029a2ef8bc0909e53e7e4c3f5b437242627.1743617897.git.jpoimboe@kernel.org>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <27fe2029a2ef8bc0909e53e7e4c3f5b437242627.1743617897.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2.04.25 г. 21:19 ч., Josh Poimboeuf wrote:
> IBPB is expected to clear the RSB.  However, if X86_BUG_IBPB_NO_RET is
> set, that doesn't happen.  Make indirect_branch_prediction_barrier()
> take that into account by calling __write_ibpb() which already does the
> right thing.

I find this changelog somewhat dubious. So zen < 4 basically have 
IBPB_NO_RET, your patch 2 in this series makes using SBPB for cores 
which have SRSO_NO or if the mitigation is disabled. So if you have a 
core which is zen <4 and doesn't use SBPB then what happens?

> 
> Fixes: 50e4b3b94090 ("x86/entry: Have entry_ibpb() invalidate return predictions")
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>   arch/x86/include/asm/nospec-branch.h | 6 +++---
>   arch/x86/kernel/cpu/bugs.c           | 1 -
>   2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index bbac79cad04c..f99b32f014ec 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -514,11 +514,11 @@ void alternative_msr_write(unsigned int msr, u64 val, unsigned int feature)
>   		: "memory");
>   }
>   
> -extern u64 x86_pred_cmd;
> -
>   static inline void indirect_branch_prediction_barrier(void)
>   {
> -	alternative_msr_write(MSR_IA32_PRED_CMD, x86_pred_cmd, X86_FEATURE_IBPB);
> +	asm_inline volatile(ALTERNATIVE("", "call __write_ibpb", X86_FEATURE_IBPB)
> +			    : ASM_CALL_CONSTRAINT
> +			    :: "rax", "rcx", "rdx", "memory");
>   }
>   
>   /* The Intel SPEC CTRL MSR base value cache */
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index c8b8dc829046..9f9637cff7a3 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -59,7 +59,6 @@ DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
>   EXPORT_PER_CPU_SYMBOL_GPL(x86_spec_ctrl_current);
>   
>   u32 x86_pred_cmd __ro_after_init = PRED_CMD_IBPB;
> -EXPORT_SYMBOL_GPL(x86_pred_cmd);
>   
>   static u64 __ro_after_init x86_arch_cap_msr;
>   


