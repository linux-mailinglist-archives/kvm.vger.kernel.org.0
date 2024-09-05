Return-Path: <kvm+bounces-25965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2DA996E2E0
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 21:11:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 722DE288424
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 19:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A11B18D642;
	Thu,  5 Sep 2024 19:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFDQ+Aev"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7718E18A6B0;
	Thu,  5 Sep 2024 19:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725563466; cv=none; b=SVEx/++lyxKXXOjwCaO4BInyGIX9v1iwIh775Sf01VDlUuPF4Tyd2kVDGnw9Ocpb97OhPXRnjN32WHGRzCwiYsD0ZfGnpBaLBeLuLbsyo9B8oBJG9kaVOqpWXsVRncDz51U2piYI+eEWauDjD7qmu87/Ze8Bpj9wLzkVmqL5bpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725563466; c=relaxed/simple;
	bh=a+2l3lUJXsVo9C6MHsAUuRf8wIiXOv+aWoA+7tw5gHs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=OHnmE1u4Ysh6XGuvtrTnlbUYHivUYg1WM+wxYD/6C9QPuhD2h8Ie40jHU1PiiMt/23vt7tiPtbsFDsqbmLipWy+gtmG1BU0gRtGdcFdt32TdK5hO0c/zfIOJ1I+mTMGoCLfy6d/uOjT3aA7arj7T7PYoYfW9smBiiGNevEww/x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFDQ+Aev; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9152DC4CEC3;
	Thu,  5 Sep 2024 19:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725563466;
	bh=a+2l3lUJXsVo9C6MHsAUuRf8wIiXOv+aWoA+7tw5gHs=;
	h=From:Date:Subject:To:Cc:From;
	b=BFDQ+Aevsz0K7BTHQ6JbJLC5GHetlcJxA7JEcZdPBzG7oqn29PrB7N1j5AXqPf0vr
	 sKYREc99tBsQMl+erfVtIWyN16G3UxeloA4GZx24d/4jndRwfw6uvearDUdIwfT4F/
	 DslnihxyUGBUnXXKY5UQp2EK19TMt9F/SfTUXtUWxmULT1RIfilWrlhiunefu0C+7L
	 0tOPHUo4/fFhCXUKcGEELrIitMua4SwI2s0+zbrh9IqiuRf4aPFN8/8ffS+PsojuJJ
	 dnsEYEAcILwHSl5so07LdgRf3gprI7aNqrJuTpAt/7OJbV7b0mQ9FRBqkatNP/AyuO
	 LDxa4fTtcudzQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 05 Sep 2024 12:10:56 -0700
Subject: [PATCH] KVM: x86: Avoid clang -Wimplicit-fallthrough in
 kvm_vm_ioctl_check_extension()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240905-kvm-x86-avoid-clang-implicit-fallthrough-v1-1-f2e785f1aa45@kernel.org>
X-B4-Tracking: v=1; b=H4sIAD8C2mYC/x2NzQqDMBAGX0X23IUYf7B9leIhxNV8NBpJbBDEd
 2/ocWCYuShJhCR6VRdFyUgIW4H6UZF1ZluEMRUmrXSrnqrjT175HHo2OWBi64vDWHcPi4Nn4/3
 hYvgujnvdDtIY2zW6ppLbo8w4/6v3eN8/SJLeknoAAAA=
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Dohrmann <erbse.13@gmx.de>, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1350; i=nathan@kernel.org;
 h=from:subject:message-id; bh=a+2l3lUJXsVo9C6MHsAUuRf8wIiXOv+aWoA+7tw5gHs=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGm3mDw72FxMTS58WrLP4attWd16I94jh++8/Zpvbf6Xx
 T3vbmNrRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjIrzyGf2rad9gux4Wo9W7s
 CVk+NfJ7zJRztxMNi3c63phwpGtXVwYjw9uyWT8Zcjn12U4Gf5plqMJ41tL4TFjshQK1qkuXS0X
 6WAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR):

  arch/x86/kvm/x86.c:4819:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
   4819 |         default:
        |         ^

Clang is a little more pedantic than GCC, which does not warn when
falling through to a case that is just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing break to silence
the warning.

Fixes: d30d9ee94cc0 ("KVM: x86: Only advertise KVM_CAP_READONLY_MEM when supported by VM")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0f801804150e..c983c8e434b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4816,6 +4816,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_READONLY_MEM:
 		r = kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
+		break;
 	default:
 		break;
 	}

---
base-commit: 59cbd4eea48fdbc68fc17a29ad71188fea74b28b
change-id: 20240905-kvm-x86-avoid-clang-implicit-fallthrough-6248e3ac5321

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>


