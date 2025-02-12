Return-Path: <kvm+bounces-37941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4754FA31BA9
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 02:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB5B73A6D38
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 01:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7931ADC98;
	Wed, 12 Feb 2025 01:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vlExsrIx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A26386347
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 01:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739325558; cv=none; b=uiLGXQaycTRYrjvlPPRmpbg+agcvGtvzqyIl7cSYJW+O+/zr4WE3NV+COZxu6t9IEMEHPQJ+hUzDLH05gER1PMizw3V+xEJ2mXxUeD8MQa0vOKYojriFQrsbG9y2n44P/BOd0scEjpmyl43TFaefO91DyJmfIoK5D86M6q0RA0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739325558; c=relaxed/simple;
	bh=8plav0HWTt+1h9QiCkNdNPq1o+Y+AMAFq2hfN8tZSs8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dssPeo8nC9uUoPSLL4KwL5dFfOnc/KPZW5l3B5PELYSwQAZx7R8YYBkLO46OMXQ4ejRFMe5HQs6c2pIjOpOwBuf0V7sUHalxYwXj5vXKkG5JJ0w24kJcA+LOF1tOKBrxEUeZZOHYc/ZYiD+qCWlq0JBP8whQg568GmVXmy4lqN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vlExsrIx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fa166cf656so11798187a91.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 17:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739325555; x=1739930355; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5TmAA7lrYyzPK7RPMr80QZDXqtaYCD1a8crOBimpM0Y=;
        b=vlExsrIxEZEHfUvcBMDMBuSIUS84rCdt5tgck0XWeP5fT1rJXN6W4aIFWgxaUc0HVV
         3U1c01nUZLMbTp6vhOuN1JirigMQxO/8MO68xZFck6rB3k4GGiMJBSWjZrfB65l3Cn/J
         BkhT0QLKFHLN3/BLjvWvEF3yjs+zVlcMLAPLDD6D4o+6ZroiXI+uofTjewvFZuniZGdd
         wN5W9mNzjvatxLtLDIwYONoDiViIqq/PC7m6YYkc5BD2ND/R8ewTABLzvK1x3V52RGTt
         yiyRpaM8Hv3EFtizbHz0ol0SssVJzdHASqBarhGcfnuqbyJZIFdh3aQb5VfiRuIiUYa1
         ydqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739325555; x=1739930355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5TmAA7lrYyzPK7RPMr80QZDXqtaYCD1a8crOBimpM0Y=;
        b=AU/sXoT1GiGhchFCkwP+psw8uEHEY7t7sA8DNlF18HnCHUkmj5jmLECulQ23b0V3CW
         CuJlak9UR+n1c+Zs8stmw8ebY6zm3nKP79V7NTua0HkaAOHrOjsNpOyBlj8TYxqc01Bv
         CJniLyaGCWb0mOSkQa9tYQ5PDnZmknPkecgfJKSSaQFJlRasIqMss0swn5DSS3k+6Tup
         pfgUGPrhE7fyoXDrJhk1ZU2Q6K56dShBsepiaOadT9BB+Q0kn/x44byPCsaJp69Nvu9s
         z/UbaM5A2FYFRmujts1ZICrgfRyqWuCxQnzJLu3uTYMycFhXOrFSlG9lbMw5R9mP3ROw
         tp1g==
X-Forwarded-Encrypted: i=1; AJvYcCWakgolFCO5RspDNxoUuepgxG4KQma6b8shGfKPhGpq/cdi7Q5Rq32560yKGHqQBb7hx4A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiJWTt4z7tJ7Yet5WbUxCuNq/l2Tp0RYKyBmnkLCma7zcDqnWE
	xXYHQK+eGG0Ky+X8OcXR+lbakSIFTi1R68eZCRG6aCg8p/k+qyqPDO5e5mf53ksp6HVb1Fx0pDJ
	ENg==
X-Google-Smtp-Source: AGHT+IGNXFHUFBAGO7+23DHP+xbhUNfnPfHgeiFc0IIY5LE7qIIGAVhpnh4dGAbimBx/4hI7qfnSlyKuElk=
X-Received: from pjbpq16.prod.google.com ([2002:a17:90b:3d90:b0:2e9:38ea:ca0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53cf:b0:2ee:ab29:1a57
 with SMTP id 98e67ed59e1d1-2fbf5bb8fb4mr2372898a91.2.1739325555495; Tue, 11
 Feb 2025 17:59:15 -0800 (PST)
Date: Tue, 11 Feb 2025 17:59:14 -0800
In-Reply-To: <20250203223205.36121-5-prsampat@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250203223205.36121-1-prsampat@amd.com> <20250203223205.36121-5-prsampat@amd.com>
Message-ID: <Z6wAclXklofHtY__@google.com>
Subject: Re: [PATCH v6 4/9] KVM: selftests: Add VMGEXIT helper
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, shuah@kernel.org, 
	pgonda@google.com, ashish.kalra@amd.com, nikunj@amd.com, pankaj.gupta@amd.com, 
	michael.roth@amd.com, sraithal@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 03, 2025, Pratik R. Sampat wrote:
> Abstract rep vmmcall coded into the VMGEXIT helper for the sev
> library.
> 
> No functional change intended.
> 
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Tested-by: Srikanth Aithal <sraithal@amd.com>
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
> v5..v6:
> 
> * Collected tags from Pankaj and Srikanth.
> ---
>  tools/testing/selftests/kvm/include/x86/sev.h    | 2 ++
>  tools/testing/selftests/kvm/x86/sev_smoke_test.c | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
> index 82c11c81a956..e7df5d0987f6 100644
> --- a/tools/testing/selftests/kvm/include/x86/sev.h
> +++ b/tools/testing/selftests/kvm/include/x86/sev.h
> @@ -27,6 +27,8 @@ enum sev_guest_state {
>  
>  #define GHCB_MSR_TERM_REQ	0x100
>  
> +#define VMGEXIT()		{ __asm__ __volatile__("rep; vmmcall"); }

Please make this a proper inline function, there's no reason to use a macro.

