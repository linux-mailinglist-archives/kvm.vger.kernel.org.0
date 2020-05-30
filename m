Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F48B1E921F
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 16:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgE3OgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 10:36:16 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34041 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbgE3OgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 May 2020 10:36:16 -0400
Received: by mail-lj1-f193.google.com with SMTP id b6so2807469ljj.1;
        Sat, 30 May 2020 07:36:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zcNfd/l9BFnlHabQoqPPfv442F/SopiWQUZyPNucIqI=;
        b=tsKQApuqDOi18dN9MvPNC2VpTUX4+2k/gzk0DOuC+FY+NoeTD1UXy06FfkoVfiiJdl
         gUl+RNqANhKyqA/ZFLQex9D1czvirt/FmBFaGudiiSCKAGNZmf6z3uNbiNqaZulsQpM4
         FDgUBb6CYNorm9WUtnAZdycaTe8xz/QAegJXyZAx4Z7wdKUbTf1rNwJscXid2Df42+OB
         9KBrLY6JZ3WSKKAad+Bmnr11ke/2b0j6EIUDYG0vKgASuOL5QM17214hsOk7dprdI+e8
         Lhlb9qw9SRo2s2itKel8PakumQPgqYH0z2ofQ9XU+e72vXVxgTN/j81b5kbKM/6q4Nn7
         KhJg==
X-Gm-Message-State: AOAM533VYE63TJFi2PsRSp+HSlUnzl2rfYsshgyI01F46mEhAnLfXI7k
        z5NyxjV6U7exMGNNLEcHPqQ=
X-Google-Smtp-Source: ABdhPJxJJVDsE3UA3/u/pMgcLiK5Uceo5WYq0qc9mpMLE7pcXRdVy9+idpuUa8Ne4vCS6k4H/zYytw==
X-Received: by 2002:a2e:9787:: with SMTP id y7mr6173028lji.107.1590849373877;
        Sat, 30 May 2020 07:36:13 -0700 (PDT)
Received: from localhost.localdomain ([213.87.139.175])
        by smtp.googlemail.com with ESMTPSA id w10sm2859199lfq.14.2020.05.30.07.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 07:36:13 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Denis Efremov <efremov@linux.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Use previously computed array_size()
Date:   Sat, 30 May 2020 17:35:58 +0300
Message-Id: <20200530143558.321449-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

array_size() is used in alloc calls to compute the allocation
size. Next, "raw" multiplication is used to compute the size
for copy_from_user(). The patch removes duplicated computation
by saving the size in a var. No security concerns, just a small
optimization.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 arch/x86/kvm/cpuid.c | 9 ++++-----
 virt/kvm/kvm_main.c  | 8 ++++----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1fdecd9..3363b7531af1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -184,14 +184,13 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 		goto out;
 	r = -ENOMEM;
 	if (cpuid->nent) {
-		cpuid_entries =
-			vmalloc(array_size(sizeof(struct kvm_cpuid_entry),
-					   cpuid->nent));
+		const size_t size = array_size(sizeof(struct kvm_cpuid_entry),
+					       cpuid->nent);
+		cpuid_entries = vmalloc(size);
 		if (!cpuid_entries)
 			goto out;
 		r = -EFAULT;
-		if (copy_from_user(cpuid_entries, entries,
-				   cpuid->nent * sizeof(struct kvm_cpuid_entry)))
+		if (copy_from_user(cpuid_entries, entries, size))
 			goto out;
 	}
 	for (i = 0; i < cpuid->nent; i++) {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 731c1e517716..001e1929e01c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3722,15 +3722,15 @@ static long kvm_vm_ioctl(struct file *filp,
 		if (routing.flags)
 			goto out;
 		if (routing.nr) {
+			const size_t size = array_size(sizeof(*entries),
+						       routing.nr);
 			r = -ENOMEM;
-			entries = vmalloc(array_size(sizeof(*entries),
-						     routing.nr));
+			entries = vmalloc(size);
 			if (!entries)
 				goto out;
 			r = -EFAULT;
 			urouting = argp;
-			if (copy_from_user(entries, urouting->entries,
-					   routing.nr * sizeof(*entries)))
+			if (copy_from_user(entries, urouting->entries, size))
 				goto out_free_irq_routing;
 		}
 		r = kvm_set_irq_routing(kvm, entries, routing.nr,
-- 
2.26.2

