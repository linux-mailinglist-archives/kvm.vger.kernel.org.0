Return-Path: <kvm+bounces-58199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 33415B8B5D1
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C48C7AEA8F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F1F2D3EC0;
	Fri, 19 Sep 2025 21:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UowpauNc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9212C0F90
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758317890; cv=none; b=t7Hx+s8cOyHL87MFpxkQiw17R0LF7Q0hq0NRIcRBoWFRZaCrMOcf22T1TbJ2xEuJSrIXQeccoPYhgCA6+YQvjF+/k73kZj0DxVO6OHQL+nH0EWqbKmh+4Rws0D4wXMhzgL9pD1z58N9838yWMWiRKFCmHwL0kgd6GbR1uQnEJCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758317890; c=relaxed/simple;
	bh=ybuee/CP+3Nt4h2RFjOT+11CdhkSUVkIl5rA6kLLIds=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qQtxkMvOKeV+Uu/4wOKX2BW1zT3+0J6j3M/7BWVLKFPHQh4eV1jQ8aCM7Qum25wKdXo/NovbsNIDLTTfxUO9Ve0316u8e42SSzzgcsuTLn1lE7yiedtHZ8WtMEYxyqG3toDbJ3lmgA2nsCNIFtRZeUPpqtZ7Wqr2pFT+SEuUCmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UowpauNc; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4c72281674so1731993a12.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758317888; x=1758922688; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RKdm3Xfs0ylrgXhnYW7dHs94H/PnNzvnxwBxGG6khr8=;
        b=UowpauNcyPTWPlNDVFF/gi4qEH85CksgIJsl4i4wvzLorlqcrj3ClHw78z1wcyJMjS
         U3ieUOE4kasNThXIc8NHn7v9xz8FVIjUSFZZcbfDsAFqu7Y7Gf6aZV6ijppOIOKmBJ9m
         2h9QnVn2M7oHoq33wQ9A3Eg7CKKX5UaEW5sy6PabXP3Av8KOoDBi7kikMM+NnFlZXpVQ
         qVNiY6KA00MJ3K70rf+dA8EcP95mzbmQW0jjpWHqe1KZ3RotK4Nys+/9vkTjUGQKQ9si
         /RJIWrG0SXFFJIZuy3z3xhBFMcw3Z517xV02hqhQyh/7Yjmt7c4KFpBhohh4nKxRodjS
         3/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758317888; x=1758922688;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RKdm3Xfs0ylrgXhnYW7dHs94H/PnNzvnxwBxGG6khr8=;
        b=Vt9URPxdhsWHQnF56AZF/IzGpWn8S/9TPbEycoeffC+Fl5bkPEja5Wsj3tM5NKA2WQ
         HxhFY4noh9hhcqQNQB6noH5/gioahvwV9cJ+pPQa+/uuDhBf0hlVS6EbA2Ssf4YDlBcq
         R9b35SlROMKGjyDNmVChnORCb6G4wecge4OOTMy/TUU71K2wgmWAmtRNEsrcAo4JAyDq
         vBDxBER9LziEFLAI4H8bjDBC0/0PZ0eX7D8v5CzpZYVVUnhRqL7bik/lgKH8CmXxutvU
         NBtdeQhTJGZtrGARuDTR2mAzq1lSQQ84kgWC2JB+h/5xxsqEOyk6i7nScnbUNhm59aED
         b4Tw==
X-Gm-Message-State: AOJu0Yx+cVVD0Nep5O+B9X1zEzx6lbGwOEq+1K1NWGEUxgxJzKeNZtxQ
	ljHlQtBo/nzNEnfebOsL5dLq2RCsVhaynxQszcXujoqfgTo0MeyYoiaps9KwKaVTT8Y33DpmAvm
	VxuwWvA==
X-Google-Smtp-Source: AGHT+IHdw5gzWTwCMexEJ/dleQ8GOPJny2l/qK7IrByLrSy2Hz4TbX3exiExZKAkCKRcDH5LA0g2eAFCMQc=
X-Received: from pjtd17.prod.google.com ([2002:a17:90b:51:b0:330:6d77:9a83])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5109:b0:32e:96b1:fb80
 with SMTP id 98e67ed59e1d1-33097fe9687mr5567412a91.11.1758317888145; Fri, 19
 Sep 2025 14:38:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:38:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919213806.1582673-1-seanjc@google.com>
Subject: [PATCH v2 0/2] KVM: SVM: Fix a bug where TSC_AUX can get clobbered
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

v2 of Hou's series to fix a bug where an SEV-ES vCPU running on the same
pCPU as a non-SEV-ES vCPU could clobber TSC_AUX due to loading the host's
TSC_AUX on #VMEXIT, as opposed to restoring whatever was in hardware at the
time of VMRUN.

I tried to test this by hacking sev_smoke_test, but unfortunately I don't
have a machine that has SEV-ES *and* TSC_AUX virtualization.  *sigh*

diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 77256c89bb8d..73530a01a3b5 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -16,6 +16,12 @@
 
 #define XFEATURE_MASK_X87_AVX (XFEATURE_MASK_FP | XFEATURE_MASK_SSE | XFEATURE_MASK_YMM)
 
+static uint64_t guest_sev_es_get_info(void)
+{
+       wrmsr(MSR_AMD64_SEV_ES_GHCB, GHCB_MSR_TERM_REQ);
+       return rdmsr(MSR_AMD64_SEV_ES_GHCB);
+}
+
 static void guest_snp_code(void)
 {
        uint64_t sev_msr = rdmsr(MSR_AMD64_SEV);
@@ -34,6 +40,10 @@ static void guest_sev_es_code(void)
        GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ENABLED);
        GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ES_ENABLED);
 
+       wrmsr(MSR_TSC_AUX, 0x12345678);
+       guest_sev_es_get_info();
+       GUEST_ASSERT(rdmsr(MSR_TSC_AUX) == 0x12345678);
+
        /*
         * TODO: Add GHCB and ucall support for SEV-ES guests.  For now, simply
         * force "termination" to signal "done" via the GHCB MSR protocol.

v2:
 - Drop "cache" from the user_return API.
 - Handle the SEV-ES case in SEV-ES code.
 - Tag everything for stable@.
 - Massage changelog to avoid talking about the host's value and instead
   focus on failing to restore what KVM thinks is in hardware.

v1: https://lore.kernel.org/all/05a018a6997407080b3b7921ba692aa69a720f07.1758166596.git.houwenlong.hwl@antgroup.com

Hou Wenlong (2):
  KVM: x86: Add helper to retrieve current value of user return MSR
  KVM: SVM: Re-load current, not host, TSC_AUX on #VMEXIT from SEV-ES
    guest

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          | 14 +++++++++++++-
 arch/x86/kvm/svm/svm.c          | 26 +++++++-------------------
 arch/x86/kvm/svm/svm.h          |  4 +++-
 arch/x86/kvm/x86.c              |  6 ++++++
 5 files changed, 30 insertions(+), 21 deletions(-)


base-commit: c8fbf7ceb2ae3f64b0c377c8c21f6df577a13eb4
-- 
2.51.0.470.ga7dc726c21-goog


