Return-Path: <kvm+bounces-59234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5D22BAEDD3
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 02:16:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A13F33B9A94
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 00:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458D94594A;
	Wed,  1 Oct 2025 00:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PTYcjf2y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1182917AE1D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 00:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759277742; cv=none; b=kM5cL0cp69Xjo+8r8H/fXlDqB+kbCCCOs0dDVmoUzX0WfN3h02YW+fT0UvalscDnXP9gqCam1gxdMlNIfqDCeKBWLPwxiKz0FaSsaQ7TtOFseBB7j3SY/cujsO8HNCJ2DJMqt7Yn0X8pEsJW0PqhGnxfmWMBGnAexNarOIVGJmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759277742; c=relaxed/simple;
	bh=Kducq2ZeSjXYvGI/ghOcZsk4NUusB8RxSwzsVgzEpgw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=V10YsgoY6j7bzYlwfDiMRqu6EX4xIWOd+72ga1AS29QK01Syg41guIlYHNV1TB7cPj6i2SjG5QxecIM4SLxia510/iuOdT491uqCHYwsVohla28j/SXQzcPT+TIFrAaOHup3nnQpOthIF0ea0WjGipj+x3w8HtN6Vv1cslM69Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PTYcjf2y; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-27ee214108cso127694025ad.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759277740; x=1759882540; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LcYitO65fM6U+2guQlIxnINa19j5zqeVtzHxSXLQKIA=;
        b=PTYcjf2yc8QM1y2Lp+iN4nMpe+n9kNDkkffxMdzj0fPBDS6XjVpE2a9Ss3io9NFAYz
         RBLGGuRj83SfFkkprgVZyY9QiTwVxQZgxMLz/AFTB3hzHjewJSEw9xsj/2djSBm7hFCo
         jciT3hYZquFauZBWnjen4a8D7hYgZoSjK7+Cj++4qOvC1maNaYO1qw1t6fuQeF5mpUeI
         +eBmKt/pSNFm43CTAvT4FYTwaJGj9JINzZ+bHHH93bEveT07ASJOcEHT0XDiR3NyEa7c
         gqYa2cV44pAVO6HPCf4MhcVncTZRQn9+VdeLlufUeHWDlV8eXLHAKMQdtYOpajAKwtNQ
         zBWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759277740; x=1759882540;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LcYitO65fM6U+2guQlIxnINa19j5zqeVtzHxSXLQKIA=;
        b=JlqCP/IMN/TkFqZQ/v2fcWLtwp6fbHakz4FolXiQprLCC+Uq9Y0Z6SgR36AievWBkk
         8AulImDUX7kUjgKZe8DTacHIAm6r9b7A0jHYam5V7fvWC99yk2kYlnffhIYSM47j5W/U
         HnqeYNTAg84ALP77InwoMQQIkcmPMgzd0HsYDBOt+1CdoGQCjoeAF2ZqXn9JkEqFVXRa
         +A6up7U9MzptaJOt9IPlzq2ueAFjHZT2fqMHFF76CcQ6rH2mVxmA8P1n/MEJaHtsMbvg
         SlnrjTa3rhs18Sil1OIV2J7FoyP7AvCoFHSUDjwXs+juLOFqVbY2k1b0AOmurJiwCDKd
         LoPw==
X-Forwarded-Encrypted: i=1; AJvYcCXC/eRDw5p1YDXegpkDdNBmj+mw1s6FZyEBTDyjjdxgPOE0GZbE8aGsUON2YEMkRKqhRVo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPxyrmW91ztFTk5mSBIBZjVbp5iNhvCSxDU7H+SVZZUu+yvvIu
	BiZK8bcMn9RsuSQhS0Ck2flPhj0KNZgujE3BQyKJLdlrTYiaR8+gDD4Rhgdc6+5oEAvUocrH24s
	cOBJ8fhxrlcfjcg==
X-Google-Smtp-Source: AGHT+IEIIEjWwhQ/2dq2CphjZTc2Klk/2tjbWkphIg3Eyh1AwnfRMWPBkeJy4YRaqzCXcKDyOONweBtc+rC66Q==
X-Received: from plsm6.prod.google.com ([2002:a17:902:bb86:b0:267:dbc3:f98d])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef02:b0:269:a4ed:13c9 with SMTP id d9443c01a7336-28e7f2eee4amr16409815ad.30.1759277740288;
 Tue, 30 Sep 2025 17:15:40 -0700 (PDT)
Date: Tue, 30 Sep 2025 17:14:08 -0700
In-Reply-To: <20251001001529.1119031-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001001529.1119031-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001001529.1119031-3-jmattson@google.com>
Subject: [PATCH v2 2/2] KVM: SVM: Disallow EFER.LMSLE when not supported by hardware
From: Jim Mattson <jmattson@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Jim Mattson <jmattson@google.com>, Perry Yuan <perry.yuan@amd.com>, 
	Sohil Mehta <sohil.mehta@intel.com>, "Xin Li (Intel)" <xin@zytor.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Modern AMD CPUs do not support segment limit checks in 64-bit mode
(i.e. EFER.LMSLE must be zero). Do not allow a guest to set EFER.LMSLE
on a CPU that requires the bit to be zero.

For backwards compatibility, allow EFER.LMSLE to be set on CPUs that
support segment limit checks in 64-bit mode, even though KVM's
implementation of the feature is incomplete (e.g. KVM's emulator does
not enforce segment limits in 64-bit mode).

Fixes: eec4b140c924 ("KVM: SVM: Allow EFER.LMSLE to be set with nested svm")

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1bfebe40854f..78d0fc85d0bd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5351,7 +5351,9 @@ static __init int svm_hardware_setup(void)
 
 	if (nested) {
 		pr_info("Nested Virtualization enabled\n");
-		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
+		kvm_enable_efer_bits(EFER_SVME);
+		if (!boot_cpu_has(X86_FEATURE_EFER_LMSLE_MBZ))
+			kvm_enable_efer_bits(EFER_LMSLE);
 
 		r = nested_svm_init_msrpm_merge_offsets();
 		if (r)
-- 
2.51.0.618.g983fd99d29-goog


