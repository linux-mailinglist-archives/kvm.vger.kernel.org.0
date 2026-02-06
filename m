Return-Path: <kvm+bounces-70469-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iIFiOfcwhmmcKQQAu9opvQ
	(envelope-from <kvm+bounces-70469-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:20:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB3C101B4B
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F0E730427E4
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 18:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D8E33121D;
	Fri,  6 Feb 2026 18:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DiCPi45i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E4F3101DC
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 18:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770401988; cv=none; b=jEQotMrIlc2rsQMBY5rJ8Nr0WF+i70lkEuEX7qxdXx8FmJ87Hvc5hEmBfdAPCymfsyPU6/BD3ucjvRAq1dp5itgy17laVJxSoZEFHf+OwmkpAGdW2D0o/w+cueugk0lHuqOUEjo33nBKJ3U/jCP7aYtWm6JKpHQmM7ndQ6tgrPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770401988; c=relaxed/simple;
	bh=duHfASxkiLCK0yIeVX+u0DBwaVXH4lup2H7rNt0YfWo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DKl6SlaEvCcs5oeO8ZkPOpyCEr04RQsdXZKT7iP5ZZEgnCANmwmbulOzCrjidahaqk18FBb0xfTnh0pIbgbAd6epHZyIB/11bvP00YzAWDsQ/t3RURuSpibRPJ3DfHAulOozU8lvEBiXMSHCi4NJcCqMWotGTdrRMkzghPHNNXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DiCPi45i; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354601967f6so850450a91.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 10:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770401987; x=1771006787; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTIXOxloDpdjhXpaBbigu7Y3M7v9e+xWUhcs+CNLKKA=;
        b=DiCPi45ivuR/VCDsYMqyL7OjeMrjZqH8hGfCWLohPNopfQiJeTqNol6/ix5e09mFfz
         23+qT6Y7fjwjxtRwmdrF42z/D+/dUQVcyi9VxJVwqlwGoMB/IHu11ga4Kx+kG99mKxKh
         foaXdnqfTpo0XNaN6qilAErLU3RezjFWrYSKhq+neulZBsiXUaA5s0uGm96ZzjN3VFhg
         4wLSl8lSbZ8Ep8EBWWxgRdmZqdUbGjWngPHJaM3RtDLdGU1iwREx6huMKQTND5GLNmii
         nvX2butopBkIRW0kbhQTX3xD8Jzi3HOipkw80wOYVs4CIyfARA6hcfwwvTbex/5xebLQ
         7ctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770401987; x=1771006787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTIXOxloDpdjhXpaBbigu7Y3M7v9e+xWUhcs+CNLKKA=;
        b=ZjD8M/HViiY/ibgbtGL4zuya5C08vElHK6A5iptmmh8Fm47taFpROA0+pvmNZkoG6G
         +Nbh82mPnKKlcLZOsUBZg3K74H+ue3xf8QxcmrYDcDOMgqQDVWSpnzgTQVTMALnMkZ2t
         IOxv7YuQVyBJ2ufJ0YXvMlrcuhjZRt13ITKv2M+mXySU69Wim+18CsU7do1F2AHKFz02
         Y8Rt3QQntuG/DqpB1G4LbkYe5w4MI7POWr/gGz4MtjcKHGjX5/Wk5eSK+SF45VIPYopO
         MiO6nxeEJlgHtdaZBo3u+oARXykf7i+0O2+iQYxo6tyRu7UHHTuTomNGlfkdo+jeX9kX
         bVoQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1t/zuz5ocwH1w/+7eJnqoIdd5tHLU8GfGdWMgw62iI/RagUWxEsEAj8rHMspCJL9Om9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVxVnYGKdXD1vVl+HY5OWyUyYmYazXAsoPRPvva24E3rAY3VNd
	HuQsEpf3M1PxzezlHpwQguaz0xlvIGphIdljieFVOY5jibG7GEecwvL5huTUAKnINhKaVExGZPn
	be9yG6w==
X-Received: from pjzl3.prod.google.com ([2002:a17:90b:783:b0:34a:bebf:c162])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:534b:b0:354:a065:ec3e
 with SMTP id 98e67ed59e1d1-354b3e4b3f8mr3044668a91.26.1770401987544; Fri, 06
 Feb 2026 10:19:47 -0800 (PST)
Date: Fri, 6 Feb 2026 10:19:45 -0800
In-Reply-To: <20260205214326.1029278-3-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com> <20260205214326.1029278-3-jmattson@google.com>
Message-ID: <aYYwwWjMDJQh6uDd@google.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70469-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8AB3C101B4B
X-Rspamd-Action: no action

On Thu, Feb 05, 2026, Jim Mattson wrote:
> Cache g_pat from vmcb12 in svm->nested.gpat to avoid TOCTTOU issues, and
> add a validity check so that when nested paging is enabled for vmcb12, an
> invalid g_pat causes an immediate VMEXIT with exit code VMEXIT_INVALID, as
> specified in the APM, volume 2: "Nested Paging and VMRUN/VMEXIT."
> 
> Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 4 +++-
>  arch/x86/kvm/svm/svm.h    | 3 +++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index f72dbd10dcad..1d4ff6408b34 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1027,9 +1027,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  
>  	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
>  	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> +	svm->nested.gpat = vmcb12->save.g_pat;
>  
>  	if (!nested_vmcb_check_save(vcpu) ||
> -	    !nested_vmcb_check_controls(vcpu)) {
> +	    !nested_vmcb_check_controls(vcpu) ||
> +	    (nested_npt_enabled(svm) && !kvm_pat_valid(svm->nested.gpat))) {
>  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
>  		vmcb12->control.exit_info_1  = 0;
>  		vmcb12->control.exit_info_2  = 0;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 986d90f2d4ca..42a4bf83b3aa 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -208,6 +208,9 @@ struct svm_nested_state {
>  	 */
>  	struct vmcb_save_area_cached save;
>  
> +	/* Cached guest PAT from vmcb12.save.g_pat */
> +	u64 gpat;

Shouldn't this go in vmcb_save_area_cached?

> +
>  	bool initialized;
>  
>  	/*
> -- 
> 2.53.0.rc2.204.g2597b5adb4-goog
> 

