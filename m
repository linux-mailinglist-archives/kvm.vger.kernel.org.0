Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A351510D873
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 17:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfK2Qcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 11:32:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49898 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727073AbfK2Qcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 11:32:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575045165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YdjqiuhcZ58rcqgBhxb9lvVnvVL8Yk36IVCo28ntw5s=;
        b=jOc8isZJQtlTkjAgo0VnrohVrs9mwWjowNCOj9dVO1CMdHU4r0o6IWHh+ucU5z51auH+cu
        3w5wIf3QyMxXtXq1ZH8QrCc93A+XrYV+thZq+mrYD3U0O6XwEeZ4gAb3uNs4Aj2s8QZWEW
        Q1infbgLt83eopcDuXv1WJRAL/9y+U0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-d-euL8O8OjmJU3SUxenDWg-1; Fri, 29 Nov 2019 11:32:42 -0500
Received: by mail-qv1-f72.google.com with SMTP id bt18so2307963qvb.19
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 08:32:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pF321W2AO34u1L6FQdPVoWqPwEEaGFwdyk4B7rVy65s=;
        b=ixXFMXfiors/Ee1Rvd2Q+MO6xdZVTx1ZGGxmsHaW0EnZB3baAKrjObpTHnFYyIT3LD
         iB60LS2g3MTx806ns4wweeHp9wdQccmRNXwYVAWr6LrQ8LFiNaOPj8YL6VMblNgs96ZA
         7iAPJNm6fhSCvB4al/tAP3Gd08hdxK0wzMyhNw4DH8c9i88cYb4nVOmAYzeIyMQdirme
         0hqIRifVZLSCNjAe9xtVl+scLwEBm7xfhZwbxhpCwcA3Vt9VPgDF9D3NZoZVc0wh5u0Y
         ++R56Hu9RTymrome7A98twOIqKfJdlSAyb/lXL8aKX+C1ni6AKap7sZ0loCZYDO4L6hJ
         k8zQ==
X-Gm-Message-State: APjAAAVk0jmsoM2Y4wwCU39ly4HpBJzKyVgZCLLCUQ/a0QGwqLoug8uH
        3+tZBgxAWp48RrUY0QOgyGIxhj7jnMnJ6mT22QkKAycc4tzTvY/lkBqlXlZZ3lLEa5DxXS+ak90
        COP+yZ0jGxtp7
X-Received: by 2002:a37:7dc2:: with SMTP id y185mr16812163qkc.380.1575045161648;
        Fri, 29 Nov 2019 08:32:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqxL2taDIIh634zxS4jLBOiDRC64GcK8w8AVHUAo6D3g58URlp/1EyloE/5HF/qs4zkbAkP1Jw==
X-Received: by 2002:a37:7dc2:: with SMTP id y185mr16812137qkc.380.1575045161402;
        Fri, 29 Nov 2019 08:32:41 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id d9sm4568329qtj.52.2019.11.29.08.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 08:32:39 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2 3/3] KVM: X86: Fixup kvm_apic_match_dest() dest_mode parameter
Date:   Fri, 29 Nov 2019 11:32:34 -0500
Message-Id: <20191129163234.18902-4-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129163234.18902-1-peterx@redhat.com>
References: <20191129163234.18902-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: d-euL8O8OjmJU3SUxenDWg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The problem is the same as the previous patch on that we've got too
many ways to define a dest_mode, but logically we should only pass in
APIC_DEST_* macros for this helper.

To make it easier, simply define dest_mode of kvm_apic_match_dest() to
be a boolean to make it right while we can avoid to touch the callers.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/lapic.c | 5 +++--
 arch/x86/kvm/lapic.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cf9177b4a07f..80732892c709 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -791,8 +791,9 @@ static u32 kvm_apic_mda(struct kvm_vcpu *vcpu, unsigned=
 int dest_id,
 =09return dest_id;
 }
=20
+/* Set dest_mode to true for logical mode, false for physical mode */
 bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
-=09=09=09   int short_hand, unsigned int dest, int dest_mode)
+=09=09=09   int short_hand, unsigned int dest, bool dest_mode)
 {
 =09struct kvm_lapic *target =3D vcpu->arch.apic;
 =09u32 mda =3D kvm_apic_mda(vcpu, dest, source, target);
@@ -800,7 +801,7 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct =
kvm_lapic *source,
 =09ASSERT(target);
 =09switch (short_hand) {
 =09case APIC_DEST_NOSHORT:
-=09=09if (dest_mode =3D=3D APIC_DEST_PHYSICAL)
+=09=09if (dest_mode =3D=3D false)
 =09=09=09return kvm_apic_match_physical_addr(target, mda);
 =09=09else
 =09=09=09return kvm_apic_match_logical_addr(target, mda);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 19b36196e2ff..c0b472ed87ad 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -82,7 +82,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, =
u32 val);
 int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 =09=09       void *data);
 bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
-=09=09=09   int short_hand, unsigned int dest, int dest_mode);
+=09=09=09   int short_hand, unsigned int dest, bool dest_mode);
 int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 =09=09=09     struct kvm_lapic_irq *irq,
--=20
2.21.0

