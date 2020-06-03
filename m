Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9271ECD39
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 12:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgFCKK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 06:10:26 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34841 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgFCKK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 06:10:26 -0400
Received: by mail-lf1-f65.google.com with SMTP id 82so956256lfh.2;
        Wed, 03 Jun 2020 03:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VJQBChCpqVmScxIVsRE/tzoYaBw5y+ElxuBAFpFZSx4=;
        b=gOeRpZGYaA4iy2YeApF4AKUMhmEYQCHIUdxJVaBNm4vI04v8b9l/r4wQOFJNRLI+eT
         meEivp30PWxYMup3xoELC3FEZX2MLQu7htyNtQnLowM5Z05rz1Sso0YYXrU6Z2nDAq5i
         PdtE/JljFojeMxX+G+JzHdsi2zH8HSciRE9vFwydVjEg3VRovPwLr6uarsMhAxSptFfB
         vOIycKfYcwA9R1h/LHKnYp8IPsJ5qLA8kG7mqv2LqToiWIXknVac45JMXmci8hSdKNg/
         K9v/sJ1ULASmJRuXqt6prqk60ZhcIGKDaLNnnpFFAk/NyyCLGTlOyT2OqXkblaaw0S23
         LDxA==
X-Gm-Message-State: AOAM530vPHsFiGnkz3CZrbmni8KQfOraN8DoY7s599bWgvPKcyKyDkyj
        k8wXk7Z/wspq4inF9/6hzs8=
X-Google-Smtp-Source: ABdhPJzbHpX6SdFHdCuPksS1gYu3+YX8RbNf4MpiT/293QxC9qClinHQc5NeGx+pAE+5VR6t9NaeGQ==
X-Received: by 2002:ac2:5604:: with SMTP id v4mr2125245lfd.124.1591179022502;
        Wed, 03 Jun 2020 03:10:22 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id c4sm346896lja.56.2020.06.03.03.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 03:10:21 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     pbonzini@redhat.com
Cc:     Denis Efremov <efremov@linux.com>, joe@perches.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Use vmemdup_user()
Date:   Wed,  3 Jun 2020 13:11:31 +0300
Message-Id: <20200603101131.2107303-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <0c00d96c46d34d69f5f459baebf3c89a507730fc.camel@perches.com>
References: <0c00d96c46d34d69f5f459baebf3c89a507730fc.camel@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace opencoded alloc and copy with vmemdup_user().

Signed-off-by: Denis Efremov <efremov@linux.com>
---
Looks like these are the only places in KVM that are suitable for
vmemdup_user().

 arch/x86/kvm/cpuid.c | 17 +++++++----------
 virt/kvm/kvm_main.c  | 19 ++++++++-----------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1fdecd9..27438a2bdb62 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -182,17 +182,14 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	r = -E2BIG;
 	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
 		goto out;
-	r = -ENOMEM;
 	if (cpuid->nent) {
-		cpuid_entries =
-			vmalloc(array_size(sizeof(struct kvm_cpuid_entry),
-					   cpuid->nent));
-		if (!cpuid_entries)
-			goto out;
-		r = -EFAULT;
-		if (copy_from_user(cpuid_entries, entries,
-				   cpuid->nent * sizeof(struct kvm_cpuid_entry)))
+		cpuid_entries = vmemdup_user(entries,
+					     array_size(sizeof(struct kvm_cpuid_entry),
+							cpuid->nent));
+		if (IS_ERR(cpuid_entries)) {
+			r = PTR_ERR(cpuid_entries);
 			goto out;
+		}
 	}
 	for (i = 0; i < cpuid->nent; i++) {
 		vcpu->arch.cpuid_entries[i].function = cpuid_entries[i].function;
@@ -212,8 +209,8 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	kvm_x86_ops.cpuid_update(vcpu);
 	r = kvm_update_cpuid(vcpu);
 
+	kvfree(cpuid_entries);
 out:
-	vfree(cpuid_entries);
 	return r;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 731c1e517716..46a3743e95ff 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3722,21 +3722,18 @@ static long kvm_vm_ioctl(struct file *filp,
 		if (routing.flags)
 			goto out;
 		if (routing.nr) {
-			r = -ENOMEM;
-			entries = vmalloc(array_size(sizeof(*entries),
-						     routing.nr));
-			if (!entries)
-				goto out;
-			r = -EFAULT;
 			urouting = argp;
-			if (copy_from_user(entries, urouting->entries,
-					   routing.nr * sizeof(*entries)))
-				goto out_free_irq_routing;
+			entries = vmemdup_user(urouting->entries,
+					       array_size(sizeof(*entries),
+							  routing.nr));
+			if (IS_ERR(entries)) {
+				r = PTR_ERR(entries);
+				goto out;
+			}
 		}
 		r = kvm_set_irq_routing(kvm, entries, routing.nr,
 					routing.flags);
-out_free_irq_routing:
-		vfree(entries);
+		kvfree(entries);
 		break;
 	}
 #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
-- 
2.26.2

