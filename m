Return-Path: <kvm+bounces-59174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5859ABAE001
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10857174C34
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75453090DE;
	Tue, 30 Sep 2025 16:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S5lemQb1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A181306B0C
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759248281; cv=none; b=OzNrwIfC68SpzHe2c47ssq2FYSD+4r4yXagZHnLp56dF5XASK1RX+SlLxMkMqQqBZHIBW4aJDih3L0m60sZJ3X+u7BRDVYDpchniXKSJ8z/X2/4dyPb7NvMUs/3LCyTs6IAM5RkwYF2CTqiJEQp6U0bwgYDjv4wtda7mwia20A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759248281; c=relaxed/simple;
	bh=CIQrBHGVbgwkU3rx+4yY6apUD9S280j7xf+HvKJtaIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e4PvKrCTI7HrgqD6HqohEIxEK8j6Ppd+0a6H3WndHwJiaIIKsqsMl9YtpIde9pXz7GbCEKttfbTl7zuJQ5WCNKanO2NAha6HPBR5SRwvok4037+Sulh7bAYrmUgXd/sxJg1+Mo5A6e+b7B7BYrvAfHRAvPqY/WXDVxvRJmNP9Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S5lemQb1; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77f64c5cf62so4734314b3a.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759248279; x=1759853079; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IdFZbyWQ0dNsaCiYR6b8u1XMwRe0ata5vLTplPw04rA=;
        b=S5lemQb1P7WHuRsFIa230Z790AId1mBLZpdMAljSHMirokZ2LK5afKk+q2znl86Rtw
         MqbjPIzDtlvMfEbMNy4f+BnIrYvjt4vq8HxpDKi+RJvvX0UNFS/ljOIZx+v3+h8qCzMi
         vAv/UHuCWc12AQr+b/XoQC/M8wEhpM58lA45BoA2mlK5W827ZX5BGyJOXn4PcaZJOFcX
         40jI2IxqnXgO0BwAsGHPFXpXXLT8sUBVwEO4eH+Yw+UQ8k3zRSpv5AYKY7BrQ2kdwg/q
         Cbk9WLMwYSYUfWNjcp/dxzPAmykoLH3lnXQTPkjETocTF0//rPDpWLHVPDUz9QJRfgIn
         Wqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759248279; x=1759853079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IdFZbyWQ0dNsaCiYR6b8u1XMwRe0ata5vLTplPw04rA=;
        b=qpj15AiWz+EjYj20ogxecFLgYRNc4ulvk+IVCZyLSWFsiSsGimFGAKDqgWcbIk0nd+
         hMvfcTtKG6UFZYLiG0AtlVZfjMA/wRik79hALlhKOG3HZbL/6WtyNIiQDgyhJA5jMllr
         KnuzsqSZq3AdhG8zW1wxeY4r0L16kcLO9M0li0AoCBbxGDTMPb1EASYy+6WucMCOvGg+
         MHEKpKx+cCwTGvMIF13kC9s3srqggkgOlDAnbujEy0I3pVVF566DIQ8GOEXarc2A1Pz9
         N0blAM2xyQg4moK30WJ/2vRl51YS6RaLqMjPtJHb76F/KgawxyMc7iE09gOroYaKm9y1
         13/g==
X-Forwarded-Encrypted: i=1; AJvYcCVgX0nbdHqREGSkNJMJYsTsQAJqxeLEq0uID6ecGGlCzKNaIvYKjmx3l6ipQdBy4C4Jg5c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv2uf1OePYlKOLTrTwNNdRZqUjEEpbMq8ubVsJ8ldd5uNQvKfP
	gVcly7H+UHXsFuJZzjDTuZvFxABAkskVAOD5BPbgc+QeaHqQHh79mRNA3wKljVRxmyuv7jPL2XV
	AOm6ctg==
X-Google-Smtp-Source: AGHT+IGuq04fNw+y2dOWCTT7ZIZp3DZpfa7EiiOI5fXbI8dSP67m6sn/ivLptYNMCGAVNO//jjn0ZeAZDaQ=
X-Received: from pgre23.prod.google.com ([2002:a65:6797:0:b0:b54:f33c:b8ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d0ab:b0:2fc:660a:23f4
 with SMTP id adf61e73a8af0-321da7ed5d9mr358399637.23.1759248278740; Tue, 30
 Sep 2025 09:04:38 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:04:37 -0700
In-Reply-To: <20250930070356.30695-4-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930070356.30695-1-jgross@suse.com> <20250930070356.30695-4-jgross@suse.com>
Message-ID: <aNv_lWzVqycCUZIi@google.com>
Subject: Re: [PATCH v2 03/12] x86/kvm: Remove the KVM private read_msr() function
From: Sean Christopherson <seanjc@google.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	xin@zytor.com, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

For the scope:

  KVM: x86:

because x86/kvm is specifically used for guest-side code.

On Tue, Sep 30, 2025, Juergen Gross wrote:
> Instead of having a KVM private read_msr() function, just use rdmsrq().
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
> V2:
> - remove the helper and use rdmsrq() directly (Sean Christopherson)
> ---
>  arch/x86/include/asm/kvm_host.h | 10 ----------
>  arch/x86/kvm/vmx/vmx.c          |  4 ++--
>  2 files changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f19a76d3ca0e..aed754dda1a3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2296,16 +2296,6 @@ static inline void kvm_load_ldt(u16 sel)
>  	asm("lldt %0" : : "rm"(sel));
>  }
>  
> -#ifdef CONFIG_X86_64
> -static inline unsigned long read_msr(unsigned long msr)
> -{
> -	u64 value;
> -
> -	rdmsrq(msr, value);
> -	return value;
> -}
> -#endif

Gah, the same commit[*] that added a wrmsrns() use also added a read_msr().  Sorry :-(

[*] 65391feb042b ("KVM: VMX: Add host MSR read/write helpers to consolidate preemption handling")

