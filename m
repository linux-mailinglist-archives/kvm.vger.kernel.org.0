Return-Path: <kvm+bounces-39030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 874A6A42A2B
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:43:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8862A16424B
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 235E9264A81;
	Mon, 24 Feb 2025 17:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j+ULiqkz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092E41A704B
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740418921; cv=none; b=TS9PPHEOxIQYVB9+DWwlXOZlXr6kOl5Z04AHojC2Aix7+M6a73QvrAi127l1SkwbM08xDe+IIKnSR78knR8iqSqaC6k/FCDp4PJw8kWJlgl2OWLo7xmzNAMbEBOcCN67oC1t/5GEbGA5toG4slPK4mbgtB5CXiTPpg+yZiOw55c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740418921; c=relaxed/simple;
	bh=3IFadXaUYj7sdZ/YoFBbGyfHNpr1yxv29eaIHoixx3w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=R2G2gxpH8dY69tUAvhafKd1UbMjqJoeyglc8y0iieKbsz3YrlQpCyZLwaratckCoWamP+0hkCuU62OWjn7lSMcqoxAneJ3A13yGM16zfA406d4KDvlGzaNaObo9E7G+zIdFzlMcNxpcAIeTXm86o8W15AM4AlauCzTkiUa2zl9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j+ULiqkz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc45101191so9020062a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740418919; x=1741023719; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e1EZBmSe2im3juqrZK3CYkAhncBM5TtZhAUdFg3KflY=;
        b=j+ULiqkzVJUHePkxzUuurPaTkSW8k50eUp1nwfd6iH50R/+0UbpZBByCxvYGL3+ESb
         lL6r0QWIzUvgOl55jUUxk+/2DhKzCcY2EfOLspVHlxTaomWZT5IP44Roqndyp/9Sloiz
         5bA0Zj4WeMjKR5+H/GsEvqKjhueQ/hpoW9HP0WjSgEPWPPqS8KsdBMs6GaZ3FAvzPkQd
         23J4CIz4aeNCbPRvnjffGm5zeGOt06AnW5y5lqMLm/yARDFRGwxYwAAdwc3mXEDzRYj7
         /7UWlbQwAzK8au19wc9yxOrHO/VDjT9adz7KHNxAvfCsTPiU2tNflbnu4Z0PX3uyCweG
         J9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740418919; x=1741023719;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e1EZBmSe2im3juqrZK3CYkAhncBM5TtZhAUdFg3KflY=;
        b=k1NOrmUcqbKEBsDgTJ7ntXbhfdKaVpwJJaJKmaAwu2dqUWmumadO+Dl5Byfssyucr6
         g1pgwrTGyACMITHVF2RJ2iScX+O6xi3IYU+Pb15H5rxXvM1MkOQuanZEPwumeyoDw6+w
         chOFnn5wQCW/G78dnsreZTXJmS5kcCUomQFY7AeABUbMAE8iGj9aIaulLxmYK3SDlZYg
         srPMuBx1WUhwnf7umvHnUYgByvSoGFL87tg1PXrKWZMmarv7IaXphRsobsKNgJi38/5Y
         aS0XWjEJ6iqIoG6kPB+qvgTFXNWyOC/O/KIhoykE0aJrLVmwtMX3Adn47eYek7D6WLNA
         wqog==
X-Gm-Message-State: AOJu0YzvlTEZ9DdAFWm+DPNnh2G/0YYxqSHQAwrLn+W8BALhVGNc6WVs
	eCCCCD/ej+NmbqfHrV35s7grVJ2175n1Y2UcNVA9i54a0EONOPnOnVwGdgjTOSkRNWkUuWbwGtC
	IJQ==
X-Google-Smtp-Source: AGHT+IHFioBGXOxzm41NcBknr4shVziaEDjiaSXZYk4bXNvmJxj5hrZDjUahvq4dTClGOKbh+vDVlxvAwxw=
X-Received: from pjbpt3.prod.google.com ([2002:a17:90b:3d03:b0:2fc:13d6:b4cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a41:b0:2f4:47fc:7f18
 with SMTP id 98e67ed59e1d1-2fce78a2965mr24749658a91.10.1740418919237; Mon, 24
 Feb 2025 09:41:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 09:41:56 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224174156.2362059-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Always set mp_state to RUNNABLE on wakeup from HLT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When emulating HLT and a wake event is already pending, explicitly mark
the vCPU RUNNABLE (via kvm_set_mp_state()) instead of assuming the vCPU is
already in the appropriate state.  Barring a KVM bug, it should be
impossible for the vCPU to be in a non-RUNNABLE state, but there is no
advantage to relying on that to hold true, and ensuring the vCPU is made
RUNNABLE avoids non-deterministic behavior with respect to pv_unhalted.

E.g. if the vCPU is not already RUNNABLE, then depending on when
pv_unhalted is set, KVM could either leave the vCPU in the non-RUNNABLE
state (set before __kvm_emulate_halt()), or transition the vCPU to HALTED
and then RUNNABLE (pv_unhalted set after the kvm_vcpu_has_events() check).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58b82d6fd77c..7f5abdaab935 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11310,9 +11310,8 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
 		if (kvm_vcpu_has_events(vcpu))
-			vcpu->arch.pv.pv_unhalted = false;
-		else
-			kvm_set_mp_state(vcpu, state);
+			state = KVM_MP_STATE_RUNNABLE;
+		kvm_set_mp_state(vcpu, state);
 		return 1;
 	} else {
 		vcpu->run->exit_reason = reason;

base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.658.g4767266eb4-goog


