Return-Path: <kvm+bounces-34268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 352479F9DA5
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 02:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 421E11896DA8
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 01:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 316D01F95A;
	Sat, 21 Dec 2024 01:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hIC+L3H2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063DF3C39
	for <kvm@vger.kernel.org>; Sat, 21 Dec 2024 01:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734743811; cv=none; b=pYcuBJpUXQmNHTUmxHkoZFTKD/GE4loGNqXrXg1xSuOIukwvtxRbFdBqUNHvnYE7J0Gb3B+Fprt+BwyCfzTw9Per7rzI7i1APFzvmnH8btrUz3o7k4LkgxQEVE5RuADCIrWuGw/RfH5vYnMK8hD8oadKjoWLk4bTfbAMFyR31k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734743811; c=relaxed/simple;
	bh=2bJtEy9hohxLi3PqZ3yFRHo894cUkhEtBPA/D3mpois=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nrusftB3MbluZCn2ztmtx0w+gv0f2aNVDMe5I/W7AqgCLNj6nH7HyQUzNWuq4KySEnF3yJ6PjX0seisPQxU1xaoh46RO4SUzpucjLvCSYS9EUmw5skF6Tx7i/6AYWhhUYe5HpQryyV8KZdk3MRpYGp8xsQMSN7RJ4854OGVym/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hIC+L3H2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef114d8346so2229011a91.0
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 17:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734743809; x=1735348609; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lk7/OTWzihL1uFGb1WDeYLCs6NEHxHWnZ5NsQOmorGM=;
        b=hIC+L3H2OZDm3KBJPgXFtLDbwaN09OzUFDdLajdu/YyEkTQ5Gyz7ByUxrAjZZ521qy
         AWFHC84OSIyCGCOLJ75KbKZ243kuPXyQ7fV7F8aR3vK2Zlaq6XjP4E8yZDJLfUJWUVOp
         GkRuxkY3R0X9P0IIiK1z9u6obEYlP31TegmjYXXndWqNZn17j7lMJ/6s9tIiTdAR7ixK
         hJXvhMbCimns2HIeBYDTt8R1vu365puYQr70lO5KB8xx0wApvvvwR9Grouxeauw/i2i8
         yeYvadbphXsk9lDWdxrldRb3uKIX+oURn8mUeTqNtBW0buFZMuTcls+rxPoN1Z5rDWD1
         yfgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734743809; x=1735348609;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lk7/OTWzihL1uFGb1WDeYLCs6NEHxHWnZ5NsQOmorGM=;
        b=q5DYmddrKhtHC0LUyJuHjoaPim9tfub2Ne/L+kzkDBpukhHRegTVISiTjfYgs1gMU8
         Lht3Sa4XNNoAY2omBxitmxDlkRsOJlTIzqZyNrhAUF9Qkdwz6d36tSy1Djvp6WFAV/Rs
         U/5xvfg35MxktjrKU/UPxCFL++iEman85DThGZFnvNM0xmrBR0yaDm+KWJl1sDd8oFIm
         p6ftNQY68asqb31xdb7fKKu2Yb7M8u7UKraai1LBvUbjdJB7KpqZ41fykwMKfTr2q2hx
         pn7ngNhod04ch+c9d5tVvgvBz7tkgi/QHctmjZGLso2CnqAGl1LTz5c25/FBSrY4uwVa
         hiPA==
X-Gm-Message-State: AOJu0YyAIWNgIYVkg2XBlvrpJnitAu/8uxDSKGTzEWYq8MPRSPzgayRo
	i4HaQMWW8qx55WGOIyl9T1U1jmTuEpF2SmT+ZWPmX6oyWRhjSCuSNx5NF0KmhS5syJkA/UpulcF
	TbQ==
X-Google-Smtp-Source: AGHT+IGXsM9D8HV0wWWAKtxadm++2dpAi9K783VlKHo8N3Es2Tl+vRTOoZxOgw8Vs5BtN9ZT7YnqzZSARgE=
X-Received: from pjbse14.prod.google.com ([2002:a17:90b:518e:b0:2e5:8726:a956])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e0f:b0:2ee:db8a:29d0
 with SMTP id 98e67ed59e1d1-2f452ec378bmr6563353a91.26.1734743809080; Fri, 20
 Dec 2024 17:16:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 20 Dec 2024 17:16:47 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241221011647.3747448-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Avoid double RDPKRU when loading host/guest PKRU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"

Use the raw wrpkru() helper when loading the guest/host's PKRU on switch
to/from guest context, as the write_pkru() wrapper incurs an unnecessary
rdpkru().  In both paths, KVM is guaranteed to have performed RDPKRU since
the last possible write, i.e. KVM has a fresh cache of the current value
in hardware.

This effectively restores KVM's behavior to that of KVM prior to commit
c806e88734b9 ("x86/pkeys: Provide *pkru() helpers"), which renamed the raw
helper from __write_pkru() => wrpkru(), and turned __write_pkru() into a
wrapper.  Commit 577ff465f5a6 ("x86/fpu: Only write PKRU if it is different
from current") then added the extra RDPKRU to avoid an unnecessary WRPKRU,
but completely missed that KVM already optimized away pointless writes.

Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 577ff465f5a6 ("x86/fpu: Only write PKRU if it is different from current")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4320647bd78a..9d5cece9260b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1186,7 +1186,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 	    vcpu->arch.pkru != vcpu->arch.host_pkru &&
 	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
 	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE)))
-		write_pkru(vcpu->arch.pkru);
+		wrpkru(vcpu->arch.pkru);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
 
@@ -1200,7 +1200,7 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
 		vcpu->arch.pkru = rdpkru();
 		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
-			write_pkru(vcpu->arch.host_pkru);
+			wrpkru(vcpu->arch.host_pkru);
 	}
 
 	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {

base-commit: 13e98294d7cec978e31138d16824f50556a62d17
-- 
2.47.1.613.gc27f4b7a9f-goog


