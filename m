Return-Path: <kvm+bounces-39504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF593A47265
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:25:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D05103B55E1
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A4E20E007;
	Thu, 27 Feb 2025 02:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WLccEHwF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18031F583A
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622774; cv=none; b=hzX2+DmXmbGdMt6sPHDkPstUloKt52HVCSopGqtdy1OSNi70n0o3UI0U3zzMMwJ/1tFLIkfc+BbMRXhah8sHr9y6rFCcKrdf8Yh3IaTLjhwNaWAEvPtsyDzYEyAydej0INKrqs+elhBtPvcXOSG9ORPBX//59Ap4Rc6RZReksfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622774; c=relaxed/simple;
	bh=Ct4a9oRRcb4uCHXZ3lSQwfqmCTAwLfdRFXjQ6iMkxFY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NvO5DnERc1wvYnD/xo3hQ64gVime/CIuM+eYTitCfVc8YrxDVbw3xlJJAxUTugpF81DV0X6UuWGa9Dwqe00hx6G2rmtKt/7QGnFVclEfYxStK3OtZb7Oo3yVEKQqiMXgrB4VgnEFdf6jR5s/krwx7g1PuQdEmGtjE5F6AnccbrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WLccEHwF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc404aaed5so1539731a91.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622771; x=1741227571; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Cdk6AVEMbYJ/6Avsp+2Egdk5E71fbrI/hFT7BN4L+X8=;
        b=WLccEHwFFmO1MV/Sx2o9uqoN4m/rnZV4iLX37pdEs5bXz0rgQ4vXgUq2/rLOUh1+oI
         cgbeDiBarE5LltOCTUEdyqVovJfe88UflAY3dbiRJ1MkUtlTiW9pKU84Y+WjDhA0HrkX
         nlUkRBI1tI1jKoC7zFN5rKNmoPL38BzvEfE8izv48MQuwfoOHObXX51lSh0v3pG5vK40
         rhRbvu3uCCTBiv6nDMlZ3z4XRP7YeLVabhCqNNkQu4MW8kDpZnjkk+/tP02ML9+85/yq
         LuaY/eX4+szxEMqugecY4mopoDqZTXH41KtN7f4Ih/JMnoG8bsXtNfa8TrPVX/nnwnND
         qNrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622771; x=1741227571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cdk6AVEMbYJ/6Avsp+2Egdk5E71fbrI/hFT7BN4L+X8=;
        b=VsXQMcyRYqxVc4I34XKgCkz4S2aST218OCUInSW1YGrHFbivO0CXGMrnKaQMCmnk+5
         N3OERAMtG0AWZNLSI9pzSpAYqY0MvykAZ/vUJlsmG6Xgi8bslm50wwKgBIBQOwI3sEvn
         uk7xO7m6o2nkjbY2Pt+pQw1Fjy97/thpl62fodkfm51Vy8NwxzxdwJc5sa1ybmeVFzIk
         BndRAYqJaRYGNeDEUl0mRGh0ej0jBKUUCZpNs6UVTIEvflS+MjszauSNtohlbveuBDDe
         uh0yrxDYU0FOh5RHN8aWPidX76QnxVnpPlprHnB27enw33arq6MlWa4enQT2GYAN6LQv
         Htww==
X-Forwarded-Encrypted: i=1; AJvYcCVEf2TM10JeHiDWIjFqAX8bTtTlNB7mykXmhghwaZQhvjvHpF7xXSOuTeqBI4bju1+OQ+E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN/znNgwhKiWXjUn5uWj7vkEYtPAiTWb44RIPP8QVkqSv8ojZE
	/nvjUwU8nncWYTsZgADypEsJwpiGWeQWk1+cnlwLowoBvessv9ZfwwKcJEyCDgS7L/0U5l4ICyl
	UQg==
X-Google-Smtp-Source: AGHT+IGFILkiLdlR4RAAXuJxcaVfe/0bxh03RUlKL7+1zFXEwiB1qD3NnSdVhpPB8u60HxzWl62A5c233Wg=
X-Received: from pjbdb4.prod.google.com ([2002:a17:90a:d644:b0:2fc:2ee0:d385])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5688:b0:2ee:a4f2:b307
 with SMTP id 98e67ed59e1d1-2fe7e2eaca6mr8295061a91.4.1740622771119; Wed, 26
 Feb 2025 18:19:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:32 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-17-seanjc@google.com>
Subject: [PATCH v2 16/38] x86/vmware: Nullify save/restore hooks when using
 VMware's sched_clock
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, 
	John Stultz <jstultz@google.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"

Nullify the sched_clock save/restore hooks when using VMware's version of
sched_clock.  This will allow extending paravirt_set_sched_clock() to set
the save/restore hooks, without having to simultaneously change the
behavior of VMware guests.

Note, it's not at all obvious that it's safe/correct for VMware guests to
do nothing on suspend/resume, but that's a pre-existing problem.  Leave it
for a VMware expert to sort out.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/cpu/vmware.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index d6f079a75f05..d6eadb5b37fd 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -344,8 +344,11 @@ static void __init vmware_paravirt_ops_setup(void)
 
 	vmware_cyc2ns_setup();
 
-	if (vmw_sched_clock)
+	if (vmw_sched_clock) {
 		paravirt_set_sched_clock(vmware_sched_clock);
+		x86_platform.save_sched_clock_state = NULL;
+		x86_platform.restore_sched_clock_state = NULL;
+	}
 
 	if (vmware_is_stealclock_available()) {
 		has_steal_clock = true;
-- 
2.48.1.711.g2feabab25a-goog


