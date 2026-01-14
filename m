Return-Path: <kvm+bounces-68089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E28CD21532
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 22:26:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 982F4302C9E6
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 21:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0CC7361DA9;
	Wed, 14 Jan 2026 21:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J4wPT2eU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D08285041
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 21:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768425966; cv=none; b=IKiayOFPdQpMpCCHI+AROC8DLrjTkIJL6FW89PpWTaznzbKc+Ql/+J8I5H4oD2k5aRHWzSTyUI6UIEtvbAELNnVMHFwSNAItr8whLhDhhSylZ2/gOVRaLKMusVq1p0IRmOhdDe1KYYtujHkhGvBWFG5r24HkWtqjPjXPIpvR1sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768425966; c=relaxed/simple;
	bh=tS2p1VVtTwfSm29+9nvecEVJH3haKiQXRr8i3I2E2Q8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XxDvwGjTG7VYti7SYHAElLGkHSi7VJ77KVrlehn63ByPlSBZgPeN2IZvUmkbeHFaOvI8WnqTrdHrz0cH5JgOWPKsrJpZPMC1IkBVeCH7SmZGWi8TlYr1mlHVFrD0FMb1n8HbGuGVy+T1br3HJQM7RToJNpwbCI8AUy3fld/viNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J4wPT2eU; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-bce224720d8so205631a12.1
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 13:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768425964; x=1769030764; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CYLcqn8bUj4LB8zfvp84Gv8TOn5CHv63OjVbPqApIWI=;
        b=J4wPT2eUzTVkwe/tz9phKjg1By6FxEczC9CLVFbdUXsBueo5SqbkQ1zpL05PM2XZp0
         69eZpuQoGGEU/ZpLnvjpwQLGLrLnqHpEf4LFwgDtM727gMkc0HbSaGprGHtKz9se4ZYE
         oe6WlBmPD+RwsgP4M05vMAYaxGGyAuFnAQSfJj3gcseiOF5VpAv5vGQ9mrJ661vZ1LKK
         5iwubYNYzwr/7sizX+uaH88EryUmgcs95X7oJqgOUbukQr20o7fnEXOl26ASKs8Pz3mq
         35pjloGw8jIgmksKbr+mlygNes6iLEjRmkSDxEtKY8KuRQlQUE71C/r9u9KvmpoI/AQB
         MErg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768425964; x=1769030764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CYLcqn8bUj4LB8zfvp84Gv8TOn5CHv63OjVbPqApIWI=;
        b=WyKNesc1kA2HAsj9/YcGCls1y8AMKMPNwYSK9BdSE1TcxOUr24t+HofsG8nnOasmK6
         ORDmUHRpQFxINZFe+Xz+53iM2cWb/U3S6O7A156Pw6rBAeYPaLLLBujc1W1WxMKRO7be
         Uj8BNVGItoIxzd+n5s3Sy4ijN0uv+6bClMqX/sHtRJIKTl+yWIfg80vv++YUFhgZGmaL
         7tVDbsPIXhGWthCgMzmXy7mFCsvFuPKWFjJiJfGRNRrzx4jRh9PZTc2mnt/n/MZUcnRb
         eANd4HsTofa6g18xHtzGzKAkvGVteZxZj1gx52FxFw7sMy7FzMav15vpzbJ6HlyF+OQV
         eLZA==
X-Forwarded-Encrypted: i=1; AJvYcCUtjxhTmKBxIgW7jCIra3lrI296cDHPuDS3AYwpRCe2QPMNsu1nQRqx7xmSO5VjyGHx4eE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqHXk58cKwf+v0VYkWBqRm8G2O0yy+FZGb5HiPzBR6HLBgGMDB
	YQjuCrmmKjBEreUdDMx2cpaLGOG64EhHeFfe2YosXPyCLKeqB1kzlJPG4RmmxGbP3fp9lRrmgXm
	cyDe3hQ==
X-Received: from pgdj16.prod.google.com ([2002:a05:6a02:5210:b0:b55:70c6:bece])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9145:b0:376:2a3e:e758
 with SMTP id adf61e73a8af0-38befaad7d0mr3819410637.28.1768425963761; Wed, 14
 Jan 2026 13:26:03 -0800 (PST)
Date: Wed, 14 Jan 2026 13:26:02 -0800
In-Reply-To: <20260113003016.3511895-5-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003016.3511895-1-jmattson@google.com> <20260113003016.3511895-5-jmattson@google.com>
Message-ID: <aWgJ6qDGJA9L71g8@google.com>
Subject: Re: [PATCH 04/10] KVM: x86: nSVM: Restore L1's PAT on emulated
 #VMEXIT from L2 to L1
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>, 
	"Radim =?utf-8?B?S3LEjW3DocWZ?=" <rkrcmar@redhat.com>, David Hildenbrand <david@kernel.org>, Cathy Avery <cavery@redhat.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 12, 2026, Jim Mattson wrote:
> KVM doesn't implement a separate G_PAT register to hold the guest's
> PAT in guest mode with nested NPT enabled. Consequently, L1's IA32_PAT
> MSR must be restored on emulated #VMEXIT from L2 to L1.
> 
> Note: if L2 uses shadow paging, L1 and L2 share the same IA32_PAT MSR.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c751be470364..9aec836ac04c 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1292,6 +1292,16 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	kvm_rsp_write(vcpu, vmcb01->save.rsp);
>  	kvm_rip_write(vcpu, vmcb01->save.rip);
>  
> +	/*
> +	 * KVM doesn't implement a separate guest PAT
> +	 * register. Instead, the guest PAT lives in vcpu->arch.pat
> +	 * while in guest mode with nested NPT enabled. Hence, the
> +	 * IA32_PAT MSR has to be restored from the vmcb01 g_pat at
> +	 * #VMEXIT.

Wrap closer to 80 chars.

> +	 */
> +	if (nested_npt_enabled(svm))
> +		vcpu->arch.pat = vmcb01->save.g_pat;
> +
>  	svm->vcpu.arch.dr7 = DR7_FIXED_1;
>  	kvm_update_dr7(&svm->vcpu);
>  
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

