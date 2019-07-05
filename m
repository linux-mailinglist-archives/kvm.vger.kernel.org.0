Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D6D605C8
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 14:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfGEMOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 08:14:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38338 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfGEMOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 08:14:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so4215863wro.5;
        Fri, 05 Jul 2019 05:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=YWCq9LHp/N7/bCAEwSiCjpeKgXe91A7xdO5EBeT5qNo=;
        b=DddSeVtcAHiOFI1GKWwgDQxmwKiNsHet8Xya9b69KEV1zIgD6L1wWTenwMtsGmyVrC
         NpxNcpQ91pWP8mtMNB8Wl/3zwbhfXxdgqyDucSlnYEvFzA/+IuHG1DJ5dMcClMRMwhus
         zelPU1PfnoVOsyGef8bTPU6L47noBQuRfNU9w88ZPg6VZvI0MZzY1fcZzqihLLii3UEH
         13G5Ap2iQBhDfL42DpmtnCM6+LYwQP8Dm+NP7+w79C3DzsiINfiH8WGbSZ3NovYAa6g+
         0ywce1UWx4sV2Lu8K2O4/jys/5rvNYFJ3inboI/vh4XA2+BxOb3YwQhRKTb76W2QQcmU
         LaQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=YWCq9LHp/N7/bCAEwSiCjpeKgXe91A7xdO5EBeT5qNo=;
        b=Sa/qKZykpo5t9n07BQ2DgoxfTpn5Q+cb3lyJgeo6bdWMefUlLgG572rJ0qkRRh3P7C
         tjnfk8XiBuORNreyNsq0yg465dEMXPvgiFtZMdVZNnVksPVWW7rJ9YhlukE5IEDZZ1B2
         DRqHv2amyspkL3JmceOEPoLFG1TNEwFuMF56fzwSPqoT5TJUWTCmgrdRs9pHikgs0xEr
         WKLLe0i5HsITaoQFHRvBT/KXh99O6Jmt84gv/WR8rJ55aKVcWn8a16aCxebFGfXjbbIx
         t0/z5VzjGQV7TY4gur28o8mniOQEF5Y5l0kgiZDi6vOxsuerc9tZi3flNftTdFvEn2VJ
         N3OQ==
X-Gm-Message-State: APjAAAVGpga3vlmdD3CWJOdH1nN/UQ5MvU0Ll4M1B+ifGOfNYd8KvZLE
        2wlB/k2u4jYq2IkqqNBSxG8cm2wppg4=
X-Google-Smtp-Source: APXvYqxAPpdp9JtNRaOCMhTUrGE5InJ9RWwI6TW5HjOmqXw6RHHEuuvz7aPNuERMGDv2ZQnvdwLkMQ==
X-Received: by 2002:a5d:6406:: with SMTP id z6mr3931535wru.280.1562328873969;
        Fri, 05 Jul 2019 05:14:33 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b71sm6058378wmb.7.2019.07.05.05.14.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 05:14:33 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: LAPIC: ARBPRI is a reserved register for x2APIC
Date:   Fri,  5 Jul 2019 14:14:32 +0200
Message-Id: <1562328872-27659-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm-unit-tests were adjusted to match bare metal behavior, but KVM
itself was not doing what bare metal does; fix that.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/lapic.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d6ca5c4f29f1..2e4470f2685a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1318,7 +1318,7 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	unsigned char alignment = offset & 0xf;
 	u32 result;
 	/* this bitmask has a bit cleared for each reserved register */
-	static const u64 rmask = 0x43ff01ffffffe70cULL;
+	u64 rmask = 0x43ff01ffffffe70cULL;
 
 	if ((alignment + len) > 4) {
 		apic_debug("KVM_APIC_READ: alignment error %x %d\n",
@@ -1326,6 +1326,10 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 		return 1;
 	}
 
+	/* ARBPRI is also reserved on x2APIC */
+	if (apic_x2apic_mode(apic))
+		rmask &= ~(1 << (APIC_ARBPRI >> 4));
+
 	if (offset > 0x3f0 || !(rmask & (1ULL << (offset >> 4)))) {
 		apic_debug("KVM_APIC_READ: read reserved register %x\n",
 			   offset);
-- 
1.8.3.1

