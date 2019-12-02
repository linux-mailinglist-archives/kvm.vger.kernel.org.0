Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA7010F161
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 21:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbfLBUNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 15:13:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55392 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728172AbfLBUNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 15:13:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575317609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T7L1QC4sZLzLTqoiJLJWCwYXhhugr76FDNW4JXS4WHg=;
        b=Y7xrUui9TM0Ye+yDvI228IGQ9Wo+lQexUUBBfDqFf/ymtw5xCcKuR/qilXf0jTNGtz3y9v
        DOsaZvj3OfY2pjb7pGdtPWWZ8HJ+P/b7vg4F0Nv4wd7Z3P7d9+Gc4cOfGFnQeNS7ZI0Dn0
        P5aDnotoD0xk4ZSFh4hk6tcQPlknvNY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-MdpHRlVDMgOznfUQD9XKtA-1; Mon, 02 Dec 2019 15:13:26 -0500
Received: by mail-qk1-f200.google.com with SMTP id 143so484979qkg.12
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 12:13:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IdAobF5KxkWmSZeeTAl/kA2XqKFNltZufrBJllpURpA=;
        b=CQ4T7YfjA2tgLkjkdL2vU1+g7IuzoGnA8olxP25WytV6F8McW+57jO/Gd/OJSyju+u
         0mTLHC+h6mXbKtpVythMYZEsqKnQWE4zJsJl4owfL36dGAZp0VTVVpSsw1UTAPqwL7vT
         G8B7kmdhFVcwRB7/3/gU9i2H4yFefdGwW98YDzB8GYIFnrOr9VZSvg8LDaLHMmy37YyJ
         IwzsTTPo0GIEu+tqC6+X/TN5hXyrG4Z11wp4M/feuwy3NoRKvlgQAtS1ek2oTnK3eiSy
         /99MhpH5gXg5UBl5EXCdxQw5zPXFl3ulgKQGQSDgytSqV5wp7Xe/dRfkY4rJFxrjD/Wh
         o5AQ==
X-Gm-Message-State: APjAAAV5/cGJgoh7Ke7Cfifdlvqkk4hv5kR+oWe/x+3htYn+Wk4ibdqk
        rYwBluoMfTs3WFbmJQ6q6b/ovBTRH8LOcMt+ka7fKwSPFW91ekuYJ5E/0Ze6jft+31r/0ABMXtD
        op0o5TvCepbRe
X-Received: by 2002:a05:620a:102e:: with SMTP id a14mr786093qkk.159.1575317605928;
        Mon, 02 Dec 2019 12:13:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqxEmfH5EcGeAkoaUvzsaIZoBstltQzghSFbzjr38dtpCINdSAr6Gawz4Ylo/zCpRToT4lqTKw==
X-Received: by 2002:a05:620a:102e:: with SMTP id a14mr786063qkk.159.1575317605660;
        Mon, 02 Dec 2019 12:13:25 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id b6sm342410qtp.5.2019.12.02.12.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 12:13:24 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v3 4/5] KVM: X86: Drop KVM_APIC_SHORT_MASK and KVM_APIC_DEST_MASK
Date:   Mon,  2 Dec 2019 15:13:13 -0500
Message-Id: <20191202201314.543-5-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191202201314.543-1-peterx@redhat.com>
References: <20191202201314.543-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: MdpHRlVDMgOznfUQD9XKtA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have both APIC_SHORT_MASK and KVM_APIC_SHORT_MASK defined for the
shorthand mask.  Similarly, we have both APIC_DEST_MASK and
KVM_APIC_DEST_MASK defined for the destination mode mask.

Drop the KVM_APIC_* macros and replace the only user of them to use
the APIC_DEST_* macros instead.  At the meantime, move APIC_SHORT_MASK
and APIC_DEST_MASK from lapic.c to lapic.h.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/lapic.c | 3 ---
 arch/x86/kvm/lapic.h | 5 +++--
 arch/x86/kvm/svm.c   | 4 ++--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1eabe58bb6d5..805c18178bbf 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -56,9 +56,6 @@
 #define APIC_VERSION=09=09=09(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
 #define LAPIC_MMIO_LENGTH=09=09(1 << 12)
 /* followed define is not in apicdef.h */
-#define APIC_SHORT_MASK=09=09=090xc0000
-#define APIC_DEST_NOSHORT=09=090x0
-#define APIC_DEST_MASK=09=09=090x800
 #define MAX_APIC_VECTOR=09=09=09256
 #define APIC_VECTORS_PER_REG=09=0932
=20
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0b9bbadd1f3c..5a9f29ed9a4b 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -10,8 +10,9 @@
 #define KVM_APIC_SIPI=09=091
 #define KVM_APIC_LVT_NUM=096
=20
-#define KVM_APIC_SHORT_MASK=090xc0000
-#define KVM_APIC_DEST_MASK=090x800
+#define APIC_SHORT_MASK=09=09=090xc0000
+#define APIC_DEST_NOSHORT=09=090x0
+#define APIC_DEST_MASK=09=09=090x800
=20
 #define APIC_BUS_CYCLE_NS       1
 #define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 362e874297e4..65a27a7e9cb1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4519,9 +4519,9 @@ static int avic_incomplete_ipi_interception(struct vc=
pu_svm *svm)
 =09=09 */
 =09=09kvm_for_each_vcpu(i, vcpu, kvm) {
 =09=09=09bool m =3D kvm_apic_match_dest(vcpu, apic,
-=09=09=09=09=09=09     icrl & KVM_APIC_SHORT_MASK,
+=09=09=09=09=09=09     icrl & APIC_SHORT_MASK,
 =09=09=09=09=09=09     GET_APIC_DEST_FIELD(icrh),
-=09=09=09=09=09=09     icrl & KVM_APIC_DEST_MASK);
+=09=09=09=09=09=09     icrl & APIC_DEST_MASK);
=20
 =09=09=09if (m && !avic_vcpu_is_running(vcpu))
 =09=09=09=09kvm_vcpu_wake_up(vcpu);
--=20
2.21.0

