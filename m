Return-Path: <kvm+bounces-38913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B77A40317
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 23:57:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6332719E106D
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 22:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967BC2512D7;
	Fri, 21 Feb 2025 22:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UG+fppPl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF2E1EE028
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 22:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740178670; cv=none; b=qK1STf1IPXUfTpFn8WeFbjuClOrUJOLZ+2X9cmil5cwVOCcgDWv43Epl9bXuilkCH765r/lYZeVxIalvZMGX+Q2LZDuMXQjL9Lg+ajbC+Cgn0kw+vL3CN0KcBfggmUfCVbiWqVvdeloHdN2Zu2n0Qix38VwkXF7odr6AsiSjD+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740178670; c=relaxed/simple;
	bh=lFo4JUPYMsFO7Lsbh8vNtNm2eGGY0s1hy/av1rJDtU4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=FOIhO4F1IjEifJnj4huEOKQPF3HWsTJoqElmWtqdV9NxcMRoKTxryhRZZfpkIcYQx1Wm7HOTFqcHjSYHpCbkOp064GE3UQR6G8rCToOdKhv38oK8pgI0kljLr15z+xU+rR1nVhjIErxCA8G995snp+Bve8fWmmemLxml7VDkx8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UG+fppPl; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220f0382404so50147875ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 14:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740178669; x=1740783469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=su5RCnPwYbw2U6fhjLj3rvvSBHFZckaAgbFdJ2/uW6w=;
        b=UG+fppPlSOByfhbITIwLIeJ6qRd+4HbI2t0Lt+Iu8VU9y+RcaCqvT1TFOIL2LD+2go
         /dgrmNMNcVgqkawbWgL+2VVf+rRY5vwefu3t77DA0itutWqG9tHLxX6v5nRAE8H3jvqZ
         gpde6GYrRbVLn5L+tq51s5anSdqlCHB5FGK+O4YODyymAc9AngCL4N5NK7ZezhlNv9Wv
         9hrS8PGUTGV8Fx9JXXtWi6PlnnQvD6zwHSVXKctuG0NRwm/3AWAiwGplykTkchzfaeIK
         mFAt/aRS6JIzsFdTqn6GvxGFN3uytKHFx4J6pWxz2FjK/3BmhkanYb1J5vD/428nM48k
         d2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740178669; x=1740783469;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=su5RCnPwYbw2U6fhjLj3rvvSBHFZckaAgbFdJ2/uW6w=;
        b=uMCA4hNWwzZdNWH/L/9XiVuOmBiyrdwm/XLhTS7Mqpknz2OmOEITJMjg6tTNBXy6ZC
         oXn0yJy6QW4AanyhirxUU+8rJuUlBjymtQleIV8d+WzYEfktAo0IRDu7do73UCbG52cU
         +KmhwaJKGy4yLyH1AoT/8zoB+gnv9Bvy8Ep+kjjMetZ3+fum7mS/hSD5Fs2zHr1eGtAR
         634ec8heL4aBXBTVTBiX3Ju3hjriWMoNkOE0jn72kyii+hFW57LytFAhyPrwZwPCYF2o
         ByIDc3HkIjxOwk1mtXGmsb3v5UKxh3KZsk6KxCk4T8iY7vC894nAQLysQsjSQHvWfOME
         T4ow==
X-Gm-Message-State: AOJu0YzVdzS4B1YXEbCMK8PO/tQrUOoGi5dtGMaga/W7RhRV+MWq8K36
	V30kWJmM6LhiSN+NdVOMiqaVL3QJSq9oVdR6E9g74W5NgZ2zEde4jlHam/r5I+cpW7HXd7xUBYM
	GUQ==
X-Google-Smtp-Source: AGHT+IEKjAky/MNUT16y7h7fZHZUHbWng2wYzvFDZ0uVPO+njMMAMC1cdDN77T85JWvz0yaFk8Gx7jQs0Pk=
X-Received: from pjbsn3.prod.google.com ([2002:a17:90b:2e83:b0:2ea:5be5:da6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f689:b0:20d:cb6:11e
 with SMTP id d9443c01a7336-2219ff61211mr69550575ad.26.1740178668693; Fri, 21
 Feb 2025 14:57:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Feb 2025 14:57:44 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250221225744.2231975-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86: Drop "enabled" field from "struct kvm_vcpu_pv_apf_data"
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove the now-defunct (and never used in KVM-Unit-Tests) "enabled" field
from kvm_vcpu_pv_apf_data.  The field was removed from KVM by commit
ccb2280ec2f9 ("x86/kvm: Use separate percpu variable to track the enabling
of asyncpf").

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/asyncpf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/x86/asyncpf.c b/x86/asyncpf.c
index 6474fede..0e6eb6ff 100644
--- a/x86/asyncpf.c
+++ b/x86/asyncpf.c
@@ -50,7 +50,6 @@ struct kvm_vcpu_pv_apf_data {
       uint32_t  token;
 
       uint8_t  pad[56];
-      uint32_t  enabled;
 } apf_reason __attribute__((aligned(64)));
 
 char *buf;

base-commit: f77fb696cfd0e4a5562cdca189be557946bf522f
-- 
2.48.1.601.g30ceb7b040-goog


