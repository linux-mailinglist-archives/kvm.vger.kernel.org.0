Return-Path: <kvm+bounces-39432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB37A470B9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:13:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E5173AFC73
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82415137742;
	Thu, 27 Feb 2025 01:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wRd89/ii"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7CB54764
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740618810; cv=none; b=V892ULX6Of6YhVhvEL0omPuW3tT/wNv8k+AqfG64gsrn9OQS9Bdw9cljeKQ6YdgKCVI7K147wF4XUNbtOX5zhy30h40arick1fFcEReKJZdWQLkSrXkBXp34mDNrHoknFLv13NJw5akkWWCTaCR/MfEFvvOzc+fmsylB7yaSaDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740618810; c=relaxed/simple;
	bh=zm2QaR360KIl6iSEbDz2zLo3X3lN7lh4lpL7RxCk81I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l3dg2rM7PJJUmQTPlVLagxsW0m8SmDzxEmoUNm7s3jNgdnw8JAK8xoHWSnPmy6Pxk54z0Q0DpmJVEb2KxzWYVsACNGy0qsXfU0qgu72mvjkmDHth2ia6pAAA5MtbyTQJ3OUOhRGLE6wOmlb0qb/yWKyMXLIMFXIaDTn7YILVrsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wRd89/ii; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc518f0564so972993a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740618808; x=1741223608; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0b+q4LTl32D7RG/ClIETiGyEI98jipo9UuVZ1dxYatM=;
        b=wRd89/iii27OqFapIVMolJmD9T0c5Dy3zTnftS1MoFzmPRE4KydgURruYpBG5PNHJN
         t+uYDGWKxesHEg81ljVNJwFdWnPleG43Sj70vFtKr5mON2aLmTuQvWhi0b7kq4buOoL4
         qkI9tdHUdfp12IJj+1dZnK8zT9nXb5KE3RM9FYpYi97LeencG+HLQdzq+yK+BdbHYtEy
         V6fZNMyZE1J/MspMkON4upRIpBONxjQQ3JUQaLqJmgWGGO6R1oU3u3nkDOZALQoUszS9
         tqY9VzFrolqSnH6jVxWbqynJy+OjsHA4DqNpvrQZ0QgZzfVthdpIQgrKGi2l24zOA2ci
         i11g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740618808; x=1741223608;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0b+q4LTl32D7RG/ClIETiGyEI98jipo9UuVZ1dxYatM=;
        b=H/j00qMoMh7h0Q4ADC0OQlzgxCxC6UQYHAryrAL3f9gu91/RQRcL0mTcO5xtSgwvDN
         ITC2/BZS8KGDb7uroxOXvRCuOGOGnOLnEMSnD1Jfof8cq2BI8ctKAqXcGd508CUJxkjD
         OFY7SF6pV5KpR75K0l8MlYYIO584ULnMNot9mXpHcHQT2fwHEwV9VVcH83breZ/e5/MH
         OjrjnyjFTS8w/vdcbFuhnsxrzTewC8GZp1Hv1F0Gka84al3+2DVsfodXj54Y1qbKg2DX
         FaNpy2cG4HOvbWVRPqv6Pv9eVbXloHl3h6AMYNkkFcMd8V/Yu3PxJfAPpXgtnlXFcdX2
         dQAA==
X-Gm-Message-State: AOJu0YyLdgMZQoQhCrVkIjAfZ7Dq4A8mHnk6vM212ApmAeNOwDosawzJ
	F6HgW+IsjTX5rk59KfGh03rQjugMB8G96j+BcJuSgRX37wpVkC3WdVD2jVr4TES0Ru5nIr3PwFe
	SKA==
X-Google-Smtp-Source: AGHT+IH4j2hz+QG3bfdUby9AHcMKdde1f0mz0Lh4hjfInlOzv66k2GVgHs1NibxtzgfdBTAmj0DWWrBKdCc=
X-Received: from pgzz124.prod.google.com ([2002:a63:3382:0:b0:801:d5e9:804f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3287:b0:1ee:d06c:cddc
 with SMTP id adf61e73a8af0-1f0fc78fb84mr17684149637.30.1740618808506; Wed, 26
 Feb 2025 17:13:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:13:17 -0800
In-Reply-To: <20250227011321.3229622-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227011321.3229622-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227011321.3229622-2-seanjc@google.com>
Subject: [PATCH v2 1/5] KVM: SVM: Drop DEBUGCTL[5:2] from guest's effective value
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ravi Bangoria <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, 
	whanos@sergal.fun
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Drop bits 5:2 from the guest's effective DEBUGCTL value, as AMD changed
the architectural behavior of the bits and broke backwards compatibility.
On CPUs without BusLockTrap (or at least, in APMs from before ~2023),
bits 5:2 controlled the behavior of external pins:

  Performance-Monitoring/Breakpoint Pin-Control (PBi)=E2=80=94Bits 5:2, rea=
d/write.
  Software uses thesebits to control the type of information reported by
  the four external performance-monitoring/breakpoint pins on the
  processor. When a PBi bit is cleared to 0, the corresponding external pin
  (BPi) reports performance-monitor information. When a PBi bit is set to
  1, the corresponding external pin (BPi) reports breakpoint information.

With the introduction of BusLockTrap, presumably to be compatible with
Intel CPUs, AMD redefined bit 2 to be BLCKDB:

  Bus Lock #DB Trap (BLCKDB)=E2=80=94Bit 2, read/write. Software sets this =
bit to
  enable generation of a #DB trap following successful execution of a bus
  lock when CPL is > 0.

and redefined bits 5:3 (and bit 6) as "6:3 Reserved MBZ".

Ideally, KVM would treat bits 5:2 as reserved.  Defer that change to a
feature cleanup to avoid breaking existing guest in LTS kernels.  For now,
drop the bits to retain backwards compatibility (of a sort).

Note, dropping bits 5:2 is still a guest-visible change, e.g. if the guest
is enabling LBRs *and* the legacy PBi bits, then the state of the PBi bits
is visible to the guest, whereas now the guest will always see '0'.

Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 12 ++++++++++++
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b8aa0f36850f..2280bd1d0863 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3165,6 +3165,18 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct=
 msr_data *msr)
 			kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
 			break;
 		}
+
+		/*
+		 * AMD changed the architectural behavior of bits 5:2.  On CPUs
+		 * without BusLockTrap, bits 5:2 control "external pins", but
+		 * on CPUs that support BusLockDetect, bit 2 enables BusLockTrap
+		 * and bits 5:3 are reserved-to-zero.  Sadly, old KVM allowed
+		 * the guest to set bits 5:2 despite not actually virtualizing
+		 * Performance-Monitoring/Breakpoint external pins.  Drop bits
+		 * 5:2 for backwards compatibility.
+		 */
+		data &=3D ~GENMASK(5, 2);
+
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
=20
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5b159f017055..f573548b7b41 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -582,7 +582,7 @@ static inline bool is_vnmi_enabled(struct vcpu_svm *svm=
)
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
=20
-#define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
+#define DEBUGCTL_RESERVED_BITS (~(DEBUGCTLMSR_BTF | DEBUGCTLMSR_LBR))
=20
 extern bool dump_invalid_vmcb;
=20
--=20
2.48.1.711.g2feabab25a-goog


