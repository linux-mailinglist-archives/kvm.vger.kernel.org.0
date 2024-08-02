Return-Path: <kvm+bounces-23136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2995C946467
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D363B2824F0
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3640F13213F;
	Fri,  2 Aug 2024 20:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c/3sxpIp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5376C52F6F
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722630590; cv=none; b=dR7xmo9J//3k4vFi6RL9elUaKe80dJinwghFlozo/da6zp33Uz6SSK7yotLLyCY24zXgr5LjFJMXsWxUwuKHmJDWPIKYzVLgjOUR0M/HBoCrPeQ/89rCn8rmuBb+65ILt0ulVtKdU48UEkCD5BrDfPBQO6GdwPXKc631LX7KHqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722630590; c=relaxed/simple;
	bh=40gwNMpJVGKV5q7dYqyY/bOpVlLRQuxsneTOTjEjCrM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FLryi14GZ1nmu0OyNlVtUU7Gw+2EHWMfSZ7gmrb4HeUVysPm9RhNoi/Y0pnwyzABW8EfzxXikHMq70048Z6TJnY4ErFxf71/uZe5+MaBQL12xL8kEONEXybE6LffiT/hwRok42nfllkZfTMC/rY7E091sLur7zb3lfVmheT5B/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c/3sxpIp; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc6ac9a4aaso84243105ad.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722630587; x=1723235387; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ITybHSn2lgwdo9OgBova5WgDb3bxvpvix4dcDu0Ihw0=;
        b=c/3sxpIpXfRKHLe/ZVGoCqG3+vIZwM7cQiF9dKlnKvDjsH6+0lVVKhCghyiYFcBb8P
         nUnTI0n4HS8pKXBY5fWso0PWnCLWjJz9N7Qj6j1C5tmr7FpsFrAxXVZHH+0E2xry7EfC
         oPiw18Ik/cZnpASMk1wRMiCGUDrKQbtNmWJHcvCNBUHeJqW5JI3QbqF/mAciGtElR3Dx
         FAk3EeVpvvG90YKfN6b/Zo/mqNQCfwMQCxbTHSq9d2rGyjyVZQspdOIelxOuKR/eJMsm
         4DSrl5JgZgKFmAfg2S6p8RUkC3gJOz1Zt3i+uIxxvTqixdFK7dZABHqDiJd1g6Qqa5bw
         vG3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722630587; x=1723235387;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ITybHSn2lgwdo9OgBova5WgDb3bxvpvix4dcDu0Ihw0=;
        b=kTmv7b9D+6crdEi25s29ieqR8xUAUOj0HalszvNFA3/14C62XY6A6u6FwfoG8e5EGd
         iGTlK6vtlfZxWQYskwuQQseKQqeUx2UfdcdhEvyPk1+tGfZkO8juvC4KcAiAmLdb64YV
         8Hd/G9LUoUA3L2kftPdSanXBcCz7o3CYEa2/8m5bqMg02sENkNTdtjhQVKtnGU/UT6Ma
         h3fG7V/i7W5F4O4SQ9dlo5EYf0sTZf54a0LlEwrH7JhePlV4YgiRXUmxHvB0dVz19NW3
         LtiuQ/x4ycnA2A+A4p4s5ANO//c9/LbN9DPhQunLrNaew2OtN518knpH4C1dVt8wCjb9
         U9Eg==
X-Gm-Message-State: AOJu0YzVsbU65PJPbowd17kWvUrDsXymmAvGcj9QAeAYyg/Mdpi0VAMz
	yaY74Jr9K7UR7evqH4sfhJEdUzbR2mV6dRtVhN+alynpD8HAwmp1fkSxXphAq41icqVT+lWFAbF
	a8Q==
X-Google-Smtp-Source: AGHT+IGRq+dVNGtNV9XqcGvZVjcLmkzM3kpMD7Cek6RunfBtNP9VV5PoU3KDoqHiJRj+R7bIJmacvOz29AY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b686:b0:1fb:7978:6cc with SMTP id
 d9443c01a7336-1ff57290c0cmr1353185ad.5.1722630587428; Fri, 02 Aug 2024
 13:29:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:29:41 -0700
In-Reply-To: <20240802202941.344889-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802202941.344889-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802202941.344889-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: selftests: Add a testcase to verify x2APIC is fully readonly
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Luczaj <mhal@rbox.co>, Haoyu Wu <haoyuwu254@gmail.com>, 
	syzbot+545f1326f405db4e1c3e@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

From: Michal Luczaj <mhal@rbox.co>

Add a test to verify that userspace can't change a vCPU's x2APIC ID by
abusing KVM_SET_LAPIC.  KVM models the x2APIC ID (and x2APIC LDR) as
readonly, and silently ignores userspace attempts to change the x2APIC ID
for backwards compatibility.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
[sean: write changelog, add to existing test]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xapic_state_test.c   | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
index 69849acd95b0..618cd2442390 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
@@ -184,6 +184,33 @@ static void test_apic_id(void)
 	kvm_vm_free(vm);
 }
 
+static void test_x2apic_id(void)
+{
+	struct kvm_lapic_state lapic = {};
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int i;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+	vcpu_set_msr(vcpu, MSR_IA32_APICBASE, MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
+
+	/*
+	 * Try stuffing a modified x2APIC ID, KVM should ignore the value and
+	 * always return the vCPU's default/readonly x2APIC ID.
+	 */
+	for (i = 0; i <= 0xff; i++) {
+		*(u32 *)(lapic.regs + APIC_ID) = i << 24;
+		*(u32 *)(lapic.regs + APIC_SPIV) = APIC_SPIV_APIC_ENABLED;
+		vcpu_ioctl(vcpu, KVM_SET_LAPIC, &lapic);
+
+		vcpu_ioctl(vcpu, KVM_GET_LAPIC, &lapic);
+		TEST_ASSERT(*((u32 *)&lapic.regs[APIC_ID]) == vcpu->id << 24,
+			    "x2APIC ID should be fully readonly");
+	}
+
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	struct xapic_vcpu x = {
@@ -211,4 +238,5 @@ int main(int argc, char *argv[])
 	kvm_vm_free(vm);
 
 	test_apic_id();
+	test_x2apic_id();
 }
-- 
2.46.0.rc2.264.g509ed76dc8-goog


