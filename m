Return-Path: <kvm+bounces-10189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 444A786A6B8
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0033A287A94
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9145210ED;
	Wed, 28 Feb 2024 02:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VzOej303"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CDB20322
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088119; cv=none; b=dYtjTgTCIwYV1in6TKrhw8i+rDguKbC4YTVRfwSWUcICsR5ZKZeEhbyocWNMgHTkuvwRHupRkB1ksJmXvowR0lgRYIFES3MxNXfn8IE/Z0ejwKCCEKimzmT25Jq0zKRl6NFLwCfnmTBSaw16YrgKaZEqL+nNReJXhf656LLkKsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088119; c=relaxed/simple;
	bh=1Uryw7EIyGaADMbLf4vJNKsPqM+n7z9iSFQFR6i45EA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WBwUONqnKN1ztNnviheLTyISll/ZTk6YUXWCr9KPuSZCH6iGuTmOpJCwNW+CLR/Vphg5OyY+Hwmz3tnwVWFnmYjYtE1foW1FziGQiKyJIiw8uZ2etCFVc6mNDxLPAXNBEoY+RnGt0yRs9/NikGk+lbtHfxdOFU7reBjKaPCQdtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VzOej303; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dced704f17cso8087217276.1
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088116; x=1709692916; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/L3RUGH7+uAkBQWkVD/RBnetvTxq10PRbhVuv1Z2Es=;
        b=VzOej3036cWOSrvGRqAPgWv+JRFfg3UqbQbz7+hR+4Xemu0wsHujaiVIcyXVY5LpQ2
         wG3YWgkutM/LxE5TSOTdY9TH2uI8+2q1sjiH413EJVakMlLz7CKbb1nT8Aw5xxdzvtXH
         HF5SckaMUWXFu4RteSnflqvKLchokpKsoAzVqKsqbrh52AX0ZuE6A3jwjbFgQ5Fh78wp
         xaUO5yO4JBPBUG3+RT+tuZpv49+Zv4U5UU18fyx2HFXJGDRfUQaUcjGX5baSFYAT6Ufv
         xNo9SrKH2LJgLH/5MQPJaB0t2Z7bdnvJz/OzolCk7oDEfwOuviut0uKLmf2jyXodz9+o
         IJuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088116; x=1709692916;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5/L3RUGH7+uAkBQWkVD/RBnetvTxq10PRbhVuv1Z2Es=;
        b=hvegdAOz1yE3hYdoMgiVUrqoS/w5osw3T+IbgIQToXHuhbI1CxVxRrftNsfNggltd+
         l0vkkDQHlUinXrAoCitsu1oCLFCexitrZd5/E+LB5LQlbUnFXet51xS5+9uLwxRhcMnK
         VyO4R/qw+T1YLyaWU3z5HTuYlR2n1a4YWAdkBoqPdEO/P5nKsv8lY5KxdqEN4vNmOrMn
         o8/lM6r9rl6PfYlAuQd5FW0PWdXK46lJ02r/ffg8aErwgqE2mByonIboI2+xLjpv1Siy
         nFuaLTJkusqnH+bb1tP6iZ/HGVtgSy2a+cWCiX4Fx+hd4o3SNyOQhR4l0/SuSv/4NK0Z
         CUOg==
X-Gm-Message-State: AOJu0YyYf+Kd0EdHM0Y/Zg50Un7d99JJf6wYtZZG7WDN8zXC02yirhAe
	baRy2p30XOFUnyA9WaoNHguX4QoL6dMNjFvk9fz8+cjUCfJYJHZK2agFDDX0TAYQf1ktu712QxP
	RYg==
X-Google-Smtp-Source: AGHT+IHHsJM5lRH1Wgjj5L2FJEo06HzdA8kv6SKdx8rA1dzoB6Dy3aQiZHQWtax/vHxL1ZgCk9HefZp45BM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1001:b0:dcd:b593:6503 with SMTP id
 w1-20020a056902100100b00dcdb5936503mr102444ybt.2.1709088116351; Tue, 27 Feb
 2024 18:41:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:34 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-4-seanjc@google.com>
Subject: [PATCH 03/16] KVM: x86: Define more SEV+ page fault error bits/flags
 for #NPF
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Define more #NPF error code flags that are relevant to SEV+ (mostly SNP)
guests, as specified by the APM:

 * Bit 34 (ENC):   Set to 1 if the guest=E2=80=99s effective C-bit was 1, 0=
 otherwise.
 * Bit 35 (SIZEM): Set to 1 if the fault was caused by a size mismatch betw=
een
                   PVALIDATE or RMPADJUST and the RMP, 0 otherwise.
 * Bit 36 (VMPL):  Set to 1 if the fault was caused by a VMPL permission
                   check failure, 0 otherwise.
 * Bit 37 (SSS):   Set to VMPL permission mask SSS (bit 4) value if VmplSSS=
 is
                   enabled.

Note, the APM is *extremely* misleading, and strongly implies that the
above flags can _only_ be set for #NPF exits from SNP guests.  That is a
lie, as bit 34 (C-bit=3D1, i.e. was encrypted) can be set when running _any=
_
flavor of SEV guest on SNP capable hardware.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 88cc523bafa8..1e69743ef0fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -261,8 +261,12 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_MASK	BIT(4)
 #define PFERR_PK_MASK		BIT(5)
 #define PFERR_SGX_MASK		BIT(15)
+#define PFERR_GUEST_RMP_MASK	BIT_ULL(31)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(32)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(33)
+#define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
+#define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
+#define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
=20
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
--=20
2.44.0.278.ge034bb2e1d-goog


