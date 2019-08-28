Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E249FC67
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 09:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfH1H7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 03:59:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbfH1H7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 03:59:12 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 71EE183F3D
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 07:59:11 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id d64so666694wmc.7
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 00:59:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HqAYNYe6Ug0GzLuBdmUlgIsXKA4zYv5rxY3t4CUPVFQ=;
        b=Z2fPBO6HB1cFzSu0VLAr0gm9zOHeLZku6DgAa1TQLDSGcrE0MA6p0J4dQf5d2aqHWV
         kcxC7daOX3yO4IiLY2ggFX9/DX7PKpUCgcM+itbcvGZA/3wjdmunjl7r+9gIsnTl+Mt4
         +mn/rncUmQxcSGxKaOajpZRw9WYZLPNyp0rVEVU9dnIxaG3OHRpOzOw1C982ZDYhTwbD
         Ibgx1sa6r+ekpvK+djJuWk2jC0Yppph5wR3vid6G4dyOjZYHlnz7wLQNjIY7U1RSC9A2
         SbIktNK+IJaR8GCFeghV8pWv6an8/4NpF5YhQEijcvBPtyhpq4aNIJu4AyA5TMdZJI/E
         8TkA==
X-Gm-Message-State: APjAAAUA9+4d/oIwIzKguOmhylEv9iwHImWSFcsH+hXWydG3nLQAEBDt
        gEch2KjvIMBMGkRBNK4GdgPI8NCKQ2wrZcIVx9gQrjhxhZ/jzVP+dgTSSElwsU+Oj9nzueUWrrD
        RQ6GUeAyqR67P
X-Received: by 2002:adf:82d4:: with SMTP id 78mr2668211wrc.85.1566979149801;
        Wed, 28 Aug 2019 00:59:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyAgGjUe2XPR9J6yRmKjEXklPepwazpcGdHUVGFoBlK2l13Y0XcluoZTglZdM8C09USuZ9JBQ==
X-Received: by 2002:adf:82d4:: with SMTP id 78mr2668192wrc.85.1566979149600;
        Wed, 28 Aug 2019 00:59:09 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a190sm2448469wme.8.2019.08.28.00.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:59:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH v2 2/2] KVM: x86: announce KVM_CAP_HYPERV_ENLIGHTENED_VMCS support only when it is available
Date:   Wed, 28 Aug 2019 09:59:05 +0200
Message-Id: <20190828075905.24744-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828075905.24744-1-vkuznets@redhat.com>
References: <20190828075905.24744-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It was discovered that after commit 65efa61dc0d5 ("selftests: kvm: provide
common function to enable eVMCS") hyperv_cpuid selftest is failing on AMD.
The reason is that the commit changed _vcpu_ioctl() to vcpu_ioctl() in the
test and this one can't fail.

Instead of fixing the test is seems to make more sense to not announce
KVM_CAP_HYPERV_ENLIGHTENED_VMCS support if it is definitely missing
(on svm and in case kvm_intel.nested=0).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d1cd0fcff9e7..149511f47377 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3106,7 +3106,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_EVENTFD:
 	case KVM_CAP_HYPERV_TLBFLUSH:
 	case KVM_CAP_HYPERV_SEND_IPI:
-	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 	case KVM_CAP_HYPERV_CPUID:
 	case KVM_CAP_PCI_SEGMENT:
 	case KVM_CAP_DEBUGREGS:
@@ -3183,6 +3182,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = kvm_x86_ops->get_nested_state ?
 			kvm_x86_ops->get_nested_state(NULL, NULL, 0) : 0;
 		break;
+	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
+		r = kvm_x86_ops->nested_enable_evmcs != NULL;
+		break;
 	default:
 		break;
 	}
-- 
2.20.1

