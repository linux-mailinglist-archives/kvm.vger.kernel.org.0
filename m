Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6321AABFF
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414772AbgDOPhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 11:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1414765AbgDOPhX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 11:37:23 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8C2C061A0C
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 08:37:23 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id o19so10347275qkk.5
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 08:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EeFIVTegln/F+8Ij5JttngNbXaEaGERsEIMec13qZzg=;
        b=WRxp2lhfPadNKlqzoLQV8hxug+VjD1ar3yARtG3bgGXwaV60vtGjZu8bYj/o37CTnb
         zB9cQxs1a26yeWJxcq0kShTttFpZdGdVWGFu2b2NWqZtAUSvKXrdWq1e61oPN65WnmPv
         0wOyIFtOQ+sdg9DpVuH+Y9bIzb1WyusCnIKviWgXUBuPrlUD4FkuIJ8ilAH4pOlXDPs5
         RDFFcI86GJlJlgy1CIJS+sVrjplPRCBwz5CS0669dIORCcYAqaa0aS8nLJF1HkEVDFn8
         jLh4wehfQ/a5bDFy1BtqaBNoIWddIDLPYeSBKvL4Dl5RZV/c/WlhfsftBxtC7yrquuNs
         FE3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EeFIVTegln/F+8Ij5JttngNbXaEaGERsEIMec13qZzg=;
        b=JmStAM3U/G9OW2giHOmtmXWch8loVztNYW/+yCa+lVKMwuVh4cvU9bbp1O1RaCRbAe
         +orANupcdJnfqAyon1Tf/wjzvTDxZezkwESZ4OGxMq5TLgWlM8a+sB6GL7sN7YN2X4lC
         3DBaumL1ie2OPvuRSUmrPZ0DGOPGmJhQbL5zJeoAFjCbg5fgxrZUo+Eqmq+Mb46Md6A5
         EuBjaAm6yvPk0p1B+UmDhHIUqlKV7LZNcPSectteuNaXs+YVTEuS69y6IqQD0pn13PiO
         Qy3HKbcwlh3qGpdKvuL3/M1ghdGLvBBiPTX1FIHqiRpResRyFp+k4EnLFqsRf/lo7HA3
         ELgA==
X-Gm-Message-State: AGi0PuZ9KOqiGoOlZZpFV7W9JZNtR8m2hY12+5iwUXEBaQi1nJlY92gC
        d/zRPSIVkTSsqcybCqtbu4dclA==
X-Google-Smtp-Source: APiQypJ7MP0hT7vNZTsu3/X7j7aM4EOHAvvziUhebjXuHKDZ0gVy14WJy7E9ieTiHCGKFcrHes4q2w==
X-Received: by 2002:a37:9dd6:: with SMTP id g205mr8286950qke.9.1586965042621;
        Wed, 15 Apr 2020 08:37:22 -0700 (PDT)
Received: from ovpn-113-148.phx2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id i20sm12549999qkl.135.2020.04.15.08.37.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 08:37:21 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     paulmck@kernel.org, pbonzini@redhat.com
Cc:     elver@google.com, sean.j.christopherson@intel.com,
        kasan-dev@googlegroups.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH -next] kvm/svm: disable KCSAN for svm_vcpu_run()
Date:   Wed, 15 Apr 2020 11:37:09 -0400
Message-Id: <20200415153709.1559-1-cai@lca.pw>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For some reasons, running a simple qemu-kvm command with KCSAN will
reset AMD hosts. It turns out svm_vcpu_run() could not be instrumented.
Disable it for now.

 # /usr/libexec/qemu-kvm -name ubuntu-18.04-server-cloudimg -cpu host
	-smp 2 -m 2G -hda ubuntu-18.04-server-cloudimg.qcow2

=== console output ===
Kernel 5.6.0-next-20200408+ on an x86_64

hp-dl385g10-05 login:

<...host reset...>

HPE ProLiant System BIOS A40 v1.20 (03/09/2018)
(C) Copyright 1982-2018 Hewlett Packard Enterprise Development LP
Early system initialization, please wait...

Signed-off-by: Qian Cai <cai@lca.pw>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2be5bbae3a40..1fdb300e9337 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3278,7 +3278,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 
 bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
 
-static void svm_vcpu_run(struct kvm_vcpu *vcpu)
+static __no_kcsan void svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-- 
2.21.0 (Apple Git-122.2)

