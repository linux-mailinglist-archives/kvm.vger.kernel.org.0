Return-Path: <kvm+bounces-37038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D22A2465F
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:56:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7104C7A04D6
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D0B145A09;
	Sat,  1 Feb 2025 01:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="togLWU4P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E9D179A7
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738374929; cv=none; b=JiOx1dYHgPCoHM6bk6ofzCH4XzTEsgUO2ml/3TyXOcIkjzk1LCc2+fSHwVVuLhD4p0YSuYj7fEGHGQzv+dvlyWxJPh0JLgKSewszQbkOAv/6xjQ4R5mbkj7KpJaKx0AXvq/DFjBOtBk5A6Qc29mM77YQxeqqKtvXh6nMY6k9Z+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738374929; c=relaxed/simple;
	bh=2L/cnO9EtXQAJOsgX3k8m5pz/6fkrIp1s4+pPXI7COU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EVImZGvpKWrSfSGHP8fdHUk7ueo63Ab2pU5jXqDD8DdirJUEikm5achWgE4YFYrtZ8uLTbNLe6skUdvLipzhbimvflRI1jFEcLuylLloWgdNGBOQjOGhbgIB+70NJBKuK4nox99e2ftLxIkE3Kam+DvCQ/2RiOnhhtSIUscKduI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=togLWU4P; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2166464e236so77952115ad.1
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738374927; x=1738979727; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=POYPQ5yMJ4zL9xLSOyVPlGOIMkdLL5mZFIi+OVlxA4k=;
        b=togLWU4PwCPHAA9d27IUou1fAo1AgBKoNtYLoN/TjCSmNc6m22heoekzY5LXtskzne
         AXw4GyyRamuPrHc6RzvRUoMFPvuPyS2/6STU6OSATnCrHPB4E8NLwI2aW38HJJw92XpH
         HLiikN9eT0HpvsNxpqPzBGHFJtieNu2BCHxGtXcuvLI22vYb8Wa2GNvIt4Un6/PDkjDp
         lS5fwE4Rsgoz15nHmBpyFTsjNRGBpmlBTZDse1cUrrlC7t8HC1Q5UstHJdYIMaydLWAJ
         UdTH6CAcH15H2F28aCj0L03uGZ5m95iJe6FzHlY6MOG1qLGvMy1lzImRB3rod/HIdmna
         KDvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738374927; x=1738979727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=POYPQ5yMJ4zL9xLSOyVPlGOIMkdLL5mZFIi+OVlxA4k=;
        b=mlVPaQhXiI2WFZNVeOBYExvhbOoo3HonwRcJpk6EyhQbW/XNcoVfz2bFjA0TE81iMO
         ZLSLCyG7W1GGhrRbtJHIAgRo1Pe7LlYOEICEZl2WltwTBDic4lt7aRv1Q2Jpbx5ddofx
         v5VlewRKaSlm4lNpSTEYBe2vyPrxxeII+uP4l3uj1j4K58n6A9Xc8oH0jXzB0rKzjNvm
         8jN3s1IwiA1Ur6tj1FBRrSGH6lgjeDBQTGzVYhm6Ya3egfnP8m4+EkwGoxKV8LdHl2k/
         URDU5gD00+CrDt1311Yh7nT9rM4wRix/MW5WVxvhmpZMqlOL++k15oX7tUQ6DR5VxisX
         4I2g==
X-Gm-Message-State: AOJu0Yw9LcY0eYjSo50Px4paWx5jvmj3bQjfZcDOlYj8lpt22FYsAdMJ
	cQbOEQP4hD2xY8NEPlrN2twKvfsfxkthpS7DlpK9uAP7mZGBNnHJ4H+n516JCo6nlUlSIJbZXx5
	75g==
X-Google-Smtp-Source: AGHT+IFucuJj48dbyTnCbLgl25vShezhlevEBnCH9ynRc5KSrkn3lU4zojxv7hZQDWHfYCSBvzxzdIeNmFE=
X-Received: from pjtu8.prod.google.com ([2002:a17:90a:c888:b0:2f7:f660:cfe7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:7c8c:b0:216:7ee9:21ff
 with SMTP id d9443c01a7336-21dd7df06f5mr157673425ad.49.1738374926702; Fri, 31
 Jan 2025 17:55:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:55:11 -0800
In-Reply-To: <20250201015518.689704-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201015518.689704-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201015518.689704-5-seanjc@google.com>
Subject: [PATCH v2 04/11] KVM: nVMX: Emulate HLT in L2 if it's not intercepted
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Extend VMX's nested intercept logic for emulated instructions to handle
HLT interception, primarily for testing purposes.  Failure to allow
emulation of HLT isn't all that interesting, as emulating HLT while L2 is
active either requires forced emulation (and no #UD intercept in L1), TLB
games in the guest to coerce KVM into emulating the wrong instruction, or
a bug elsewhere in KVM.

E.g. without commit 47ef3ef843c0 ("KVM: VMX: Handle event vectoring
error in check_emulate_instruction()"), KVM can end up trying to emulate
HLT if RIP happens to point at a HLT when a vectored event arrives with
L2's IDT pointing at emulated MMIO.

Note, vmx_check_intercept() is still broken when L1 wants to intercept an
instruction, as KVM injects a #UD instead of synthesizing a nested VM-Exit.
That issue extends far beyond HLT, punt on it for now.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9773287acade..fb4e9290e6c4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8083,6 +8083,11 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 		/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
 		break;
 
+	case x86_intercept_hlt:
+		if (!nested_cpu_has(vmcs12, CPU_BASED_HLT_EXITING))
+			return X86EMUL_CONTINUE;
+		break;
+
 	case x86_intercept_pause:
 		/*
 		 * PAUSE is a single-byte NOP with a REPE prefix, i.e. collides
-- 
2.48.1.362.g079036d154-goog


