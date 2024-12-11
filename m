Return-Path: <kvm+bounces-33491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 257C69ED3A9
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 18:32:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A359C281F19
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 17:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F4BF1FF61D;
	Wed, 11 Dec 2024 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VUfGzhSO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B861FF1B9
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 17:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733938198; cv=none; b=WdjlFgvjC99KrbFEeeXS2LDVPGAUhSq9p1YwnIoW1qcbIVgiEeRM7JqBkzGpwqlbYfoJw1TXgbr1ri7kD/pXi35WPa94c9pl3BYDnDki0sc4TGJjxCmyXI6dSMTUs7/6iB5cerELpurA1QEdxlsv+i2jnG4B35vJ4QZw4zQ13cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733938198; c=relaxed/simple;
	bh=Lk+Ha5wxFQ+Mh3b1LwsGP/EOGKHkzmqvcnz+ZP8JKUg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SIdTspNSQHLOSlICf3tRfyeXf+XbS5aCWppkVVH074A+OohfbLsvSfp7Y+99KdyQkzQGGm877qWwcGYtuCMeG/tXqOZPEv9aiv5t8tV/FcQ9pxCZMY6pqw9YCGFXyVNhcwehpQk7fQZzWD2jQ0QPKSVPqDVok92wr9lXxjEN+p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VUfGzhSO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef728e36d5so5261354a91.3
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 09:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733938196; x=1734542996; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cs2OyeuqVZvLJyvF9hJVcimYDZMHCiD1C4FXtPFGvoo=;
        b=VUfGzhSOBiXl7PhmBtQS7TouC3yLN/c85kiqD38kGl2WfYvYei+T9HUKKLQ508STpg
         bQJqP35zjjctlsoS8X0pd9/cotzJio9esuPESdprzdU0P3puDBl59Vo2BeRfXH699tuh
         aoVpGRQmxYl51XT2Ai+XDktTYA/71e9FnKKeuurcc1b+yK2U/Sd1qERVV5KykOZ4iNwA
         Kz3oBcmyFLqKtblhXB3chw0vd5zqvj5RWiQ2D1AeJwtdhRTLfMcnrSaDT/t9lar6muRU
         PswXS/0p/vWWA2ggadgmZ48bXjvhAbaD+fnCEqW/Dm5fEK+65mJsfBO2sCgkkrtOXVWA
         CG8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733938196; x=1734542996;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cs2OyeuqVZvLJyvF9hJVcimYDZMHCiD1C4FXtPFGvoo=;
        b=foKBGjYslyOMJtin3YgTYpDfpOqS2ilU7opiW5MK5/c/IkxEXvmep5raqAsIfTpsXo
         wUGT8LaSPVl9A6430gBKnr9ZcXk4EicQARK0uL7T23RsfGP4IfUq2gT01eoylahU9pty
         jk1p/DfAFOhxTVTCQ94cgZqsMz0gkiw8GnJSBhqxI/beUuVtaw3WnD/CWqLNJnenfaKm
         IyFf4yvWQ3HgwKE703hutYQU1a//puVMSBq4kjxZj67szqwqXoRlNE2CYXjayrEGWuiU
         XC5hAvvrkgn5CEwqMBAjnYxgRUoVfIHFb+KUaaP4rzqd490HCywIrBPehqyxSQ1mAZj1
         vAWQ==
X-Gm-Message-State: AOJu0YyeqzK+ypZMS/CT0orr5MIw0WiwZNFMfAqXQN9nwJAJ4Mlvo46G
	0Q5niOzTlCOhGXdWMFi+D06GC/N3nu70mmQC6AqlUShQh5RvgvSEoP4wjkIe/jmamv04bsDVUR1
	UWw==
X-Google-Smtp-Source: AGHT+IFufc8TXj11zrpajD1CnjIdyF+fE49Tlzc87TuIZTOcSb7mTLdHCVV9hJ4SvHQ7hecMnEHAOzzXzPI=
X-Received: from pjg3.prod.google.com ([2002:a17:90b:3f43:b0:2ef:78ff:bc3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a8c:b0:2ee:45fe:63b5
 with SMTP id 98e67ed59e1d1-2f1392577ebmr1129021a91.3.1733938196340; Wed, 11
 Dec 2024 09:29:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Dec 2024 09:29:52 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241211172952.1477605-1-seanjc@google.com>
Subject: [PATCH] KVM: SVM: Allow guest writes to set MSR_AMD64_DE_CFG bits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Simon Pilkington <simonp.git@mailbox.org>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

Drop KVM's arbitrary behavior of making DE_CFG.LFENCE_SERIALIZE read-only
for the guest, as rejecting writes can lead to guest crashes, e.g. Windows
in particular doesn't gracefully handle unexpected #GPs on the WRMSR, and
nothing in the AMD manuals suggests that LFENCE_SERIALIZE is read-only _if
it exists_.

KVM only allows LFENCE_SERIALIZE to be set, by the guest or host, if the
underlying CPU has X86_FEATURE_LFENCE_RDTSC, i.e. if LFENCE is guaranteed
to be serializing.  So if the guest sets LFENCE_SERIALIZE, KVM will provide
the desired/correct behavior without any additional action (the guest's
value is never stuffed into hardware).  And having LFENCE be serializing
even when it's not _required_ to be is a-ok from a functional perspective.

Fixes: 74a0e79df68a ("KVM: SVM: Disallow guest from changing userspace's MSR_AMD64_DE_CFG value")
Fixes: d1d93fa90f1a ("KVM: SVM: Add MSR-based feature support for serializing LFENCE")
Reported-by: Simon Pilkington <simonp.git@mailbox.org>
Closes: https://lore.kernel.org/all/52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd15cc635655..21dacd312779 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3201,15 +3201,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (data & ~supported_de_cfg)
 			return 1;
 
-		/*
-		 * Don't let the guest change the host-programmed value.  The
-		 * MSR is very model specific, i.e. contains multiple bits that
-		 * are completely unknown to KVM, and the one bit known to KVM
-		 * is simply a reflection of hardware capabilities.
-		 */
-		if (!msr->host_initiated && data != svm->msr_decfg)
-			return 1;
-
 		svm->msr_decfg = data;
 		break;
 	}

base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
-- 
2.47.0.338.g60cca15819-goog


