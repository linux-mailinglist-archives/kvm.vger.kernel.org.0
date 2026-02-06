Return-Path: <kvm+bounces-70394-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KFnxAOlFhWm5/AMAu9opvQ
	(envelope-from <kvm+bounces-70394-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:37:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B29EF8FBF
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D8C973022685
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 01:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4013E241103;
	Fri,  6 Feb 2026 01:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3aYBVZKR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D0323D7F0
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 01:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770341843; cv=none; b=uJTfLiKeKmeBZ+J2gx6fK7+XjygiNkfbbX9LhK1UvLv9rPe29feeJE+zoByd7ylCmvvP1gloVIwbEAC7Rki3GKj0ddJaOIPiWOPBB/gb7gzcN/SamHfMgxLLtX0PMxgDXdamWcOhouDFbNzLoigqaogWCJqYeT5YC7ROF9uHG7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770341843; c=relaxed/simple;
	bh=3nXGFTXJKxFQ/Q/T0eJFrTLoYWSbFkYglkxnarVYjcY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JN/AMNLKrMIoi0cz54qG6sEaq6DaJ3MAuy0fRYIQ3h4ortKgTpxKKVoldF0Zb53b17EBDHLmcBrvkdxvPhGKbW9n8uqVbYUnopjCpTlp3ZeQK2giF/YNTPVpIBArid/fjGfHeCIX1MlkIXtOtxk5ViHN10npuKUghgV39YsFN7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3aYBVZKR; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a944e6336eso39686305ad.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 17:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770341843; x=1770946643; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6HcbFAQ5ji2NXv3x3xA5R27OOd827rmNEXbIuMb23b8=;
        b=3aYBVZKR7VzJqljF4yZ2ixQL4c8uVCxsnCZJkm4OAg7A6jLVmLO0a5A99LF9CH/zmc
         sfbhDcOOB2ODTkHPiWIPuBjL02epbfixuG4MOtR/TAaXeZ5iseQokz4S0OWnechA7ry9
         XfUuebWyrmQamftEzyoyCFhab57xpeF1cSVADD6zB/PeXzOl4t4ciZigfeysQvIig3RB
         kZVQnXSTofBHryl2TNXc3X6x87Gr2nVgCpdF5EFvJ3lLyffUkqPtYq9MXsAFfAgpnD9b
         GYubKDDsHeF8kQiL9HDPKi8EvEjtzpSy5cUA+TPq6sYMEYqZ4C02w4V7Cj81Xqq9Y9Wv
         kdEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770341843; x=1770946643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6HcbFAQ5ji2NXv3x3xA5R27OOd827rmNEXbIuMb23b8=;
        b=p9pq62uFv2nBLBUX3nerZS23PzvgJrdXYuzZNk2WYTqtw6olJCcE+spjVEQmX5NdcG
         QEvLpCpy80k9DQaNMyvOw8+DzEdEpWO/HqIX1LVjRhv6urEWV7HlutQGKtcQtRKLpKYg
         jOLxCaDZpMZxlZprqEFtezlYqJp8H1SImKVSPELYNgIWeRUjRH0hR54BlxqCEw+Nk2O8
         EFzl7NRov3fJjKscwk8LiTFw0uC71TR10Q3NAvUNo7IpsXnch+FrReaufS1zqsuh7z5P
         DeV/Z/b6mzeQxydR0e5TRrrKBvtPPLdHfyKqEyalZc50vIJ24BAGC1G55PC6dD/LFk6C
         mm/w==
X-Forwarded-Encrypted: i=1; AJvYcCUcmrmsnjkouK+L9SKg3GpruuC87jdBfQx3fISRXgNnhrZrmP+jUal/JvWGMKcHUU3fb3A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNs7vz+zZKCnkN6kQFPICyLUHcTXWWQ1NnjaFcqByd4cAjWpLG
	jKMa3Ym6xyVRdHWMOZTCB36EJgx056dNFG7wKVtkQunhCNkiFehk7oT/8rGniBU9utTkl0ZuwCM
	X8mjC0w==
X-Received: from plim1.prod.google.com ([2002:a17:903:3b41:b0:2a8:71ec:6799])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f788:b0:2a0:b02b:2114
 with SMTP id d9443c01a7336-2a9516754e5mr12308075ad.11.1770341842775; Thu, 05
 Feb 2026 17:37:22 -0800 (PST)
Date: Thu, 5 Feb 2026 17:37:21 -0800
In-Reply-To: <20260115011312.3675857-23-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev> <20260115011312.3675857-23-yosry.ahmed@linux.dev>
Message-ID: <aYVF0YfqlRktzM7S@google.com>
Subject: Re: [PATCH v4 22/26] KVM: SVM: Use BIT() and GENMASK() for
 definitions in svm.h
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70394-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5B29EF8FBF
X-Rspamd-Action: no action

On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> Use BIT() and GENMASK() (and *_ULL() variants) to define the bitmasks in
> svm.h.

Oh, hey, just what I was talking about.  But why is this buried as patch 22/26?
AFAICT, it's got nothing to do with the rest of the series.

> Opportunistically switch the definitions of AVIC_ENABLE_{SHIFT/MASK}
> and X2APIC_MODE_{SHIFT/MASK}, as well as SVM_EVTINJ_VALID and
> SVM_EVTINJ_VALID_ERR, such that the bitmasks are defined in the correct
> order.
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/include/asm/svm.h | 78 +++++++++++++++++++-------------------
>  1 file changed, 39 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 770c7aed5fa5..0bc26b2b3fd7 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -189,39 +189,39 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define V_TPR_MASK 0x0f
>  
>  #define V_IRQ_SHIFT 8
> -#define V_IRQ_MASK (1 << V_IRQ_SHIFT)
> +#define V_IRQ_MASK BIT(V_IRQ_SHIFT)

I vote (and if anyone disagrees, their vote doesn't count) to purge the _SHIFT
and _MASK crud.  There is zero reason to define the shifts.

And then when we rename, I would like to try and find better names, e.g. maybe
things like V_GIF and V_ENABLE_GIF_VIRTUALIZATION?

Anyways, that's partly why I asked why this patch is here.  If we're changing
things, then I'd like to do some cleanup.  But this series is already a chonker,
so I'd much prefer to do any cleanup in a separate series.

