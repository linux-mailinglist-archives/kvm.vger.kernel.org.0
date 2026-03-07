Return-Path: <kvm+bounces-73217-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kLYjLE2Kq2kBeAEAu9opvQ
	(envelope-from <kvm+bounces-73217-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:15:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69D0722999D
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:15:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 614693039F4E
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 02:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FA45145B27;
	Sat,  7 Mar 2026 02:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r80h1+Z9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6081E4BE
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 02:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772849733; cv=none; b=uBXBwhR5TYED9iU21Css/FI0CcaSCej2wbZ9l0YRptaEGEbZL27PwXsdii2IjBtQcUdZNzdq8qNihTcnI0RL8gK5Cmfh9+efa5yCgSlTxyEmKTG3npCmrKEni0wafZaK/Us9JNDmTX+7csAOU8xH8bGGihebXna8UGdXICdjvJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772849733; c=relaxed/simple;
	bh=uXG19vgyqc0vRsqQoQGiphZhjsSOgse8qk3/8sYdk4Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e5kAxjoYnbXQXsaeEhzU6CUbdimxWvQuyXZ/4Awg7fyKIzFBQnD47JLPG2B6HLplL/6aMP0BiOE7fdJIET0WAk7eubPeyGbXF7Kse8fYEjk3EQ2cSiQMqLHebgRi0YKntuvXRy7Wvye9PU9wZsLzrUPrq3ooplSLX5n/lj0Hd6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r80h1+Z9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae4f27033cso63354015ad.3
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 18:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772849731; x=1773454531; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hpHs4vUYCe8FUMxp12xFtu/nT5nIlsGpqATm6Mj9k5U=;
        b=r80h1+Z9+s2t65aoHNhpqg75Ql64gn5SNeuHov736rWVkSUIGBS8X8Gts1mbcxknsn
         tSrMJ7Hy+opny4bwleSM4a555ir1HR/CMFl47eZGFOsCFieTHlp2jAXQibikhpvfcyv6
         1a2uzpqOA8rwuSv3CDyoKkdmkqMrN5CXv4GoDU5fIw6GFdgq+7I4QrUV8A7npF293Vbh
         TtZn44HDdDh8sku/s29GZSHVxgpkjRpIaVYMQ7myAAe/OF4gJNCGbE8xCKYL0ljNbLjz
         WQNKjMLrjX0CwGgnSyeNkAEyZFeQV1Rq2E1IGtyLzfe7erq/4Id+utrnHbd1iyeYk+0I
         895A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772849731; x=1773454531;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hpHs4vUYCe8FUMxp12xFtu/nT5nIlsGpqATm6Mj9k5U=;
        b=Wphbgfr/UBrWzieGtug6loYZcweu8jmHkrmlh7Xr1wCFUt4C9xOlfY32D/Qm0oETaD
         GWef8+4gdWqmIe3AAI7CGbWFIG9EbhD/WtcjrEmETmNoVLbq16LypV2dNORUd9UzByTf
         9GohC9IpEDHwsACFqSMU+w3tILjw1idfiE3hN9rbxSEKj/EgVrsSd41gpT5kdKq/vGMO
         Q2s3dLUfgFJ4YCYecReHkKj9iGXqCqdn0/lcb2MX7InQPCxE3dCKeBEMkmnwczaKV+uP
         gXT6d8XPxQelkPSkVho3TNTc4rOLKzqLXTqPuJI+twghCriUceSt1UHA4xSp2vQYVePx
         VMKw==
X-Forwarded-Encrypted: i=1; AJvYcCXJjqFTCskLtz1duyDaEzdOpzrtBwEPj0qb5stORn+uSXQGcuuk1fz3rhQ/e8jb71Tzu9w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL7sDdbtzeWgofEEZjwuAbrcCjOwl3DSFkkUSiUGrE+g5X+huu
	LOnf1RXKlchMF2AZNrNXMqs3moOS4kALz27hA7klOklFy5VDQ4DlsqoFkCyosucr1WU9g+GboAK
	S/0uKIA==
X-Received: from plbmj3.prod.google.com ([2002:a17:903:2b83:b0:2ae:3e55:f044])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef10:b0:2aa:d671:e613
 with SMTP id d9443c01a7336-2ae8245165cmr48752275ad.38.1772849730693; Fri, 06
 Mar 2026 18:15:30 -0800 (PST)
Date: Fri, 6 Mar 2026 18:15:29 -0800
In-Reply-To: <20250829153149.2871901-17-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829153149.2871901-1-xin@zytor.com> <20250829153149.2871901-17-xin@zytor.com>
Message-ID: <aauKQSACQXFYvCCH@google.com>
Subject: Re: [PATCH v7 16/21] KVM: x86: Advertise support for FRED
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com, 
	hch@infradead.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 69D0722999D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73217-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.931];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:email]
X-Rspamd-Action: no action

On Fri, Aug 29, 2025, Xin Li (Intel) wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Advertise support for FRED to userspace after changes required to enable
> FRED in a KVM guest are in place.

Mostly a note to myself, if VMX and SVM land separately, we need to do the same
thing we did for CET and explicitly clear FRED in svm_set_cpu_caps().  But ideally
this would just be the last patch after both VMX and SVM support are in place.

> Signed-off-by: Xin Li <xin3.li@intel.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> ---
> 
> Change in v5:
> * Don't advertise FRED/LKGS together, LKGS can be advertised as an
>   independent feature (Sean).
> * Add TB from Xuelian Guo.
> ---
>  arch/x86/kvm/cpuid.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index ee05b876c656..1f15aad02c68 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -994,6 +994,7 @@ void kvm_set_cpu_caps(void)
>  		F(FSRS),
>  		F(FSRC),
>  		F(WRMSRNS),
> +		X86_64_F(FRED),
>  		X86_64_F(LKGS),
>  		F(AMX_FP16),
>  		F(AVX_IFMA),
> -- 
> 2.51.0
> 

