Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96ACE110311
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 17:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfLCQ7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 11:59:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32177 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727256AbfLCQ7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 11:59:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575392355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=14g8RaA5piWvH+2ustd/wNI5q+TQc8KxgzZhf+/2kiM=;
        b=aOsifXDBmooHhNfMJWj98QlYRrBcyXzpDfrXEXNMTSMyVK3JwBO+3wHKGlofXbZkrsYL10
        Z8EBhHWQ5DJZDmf5toCOvlaOIQfRdZ3Ip6F5WrghSCGY/ubgoo2JTj90K7Mgw5z2te30yg
        8FYxj2dQa9MotxzvJGlGbMSpsShqjpw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-FnzV2tSKOb6wZKLshthW6Q-1; Tue, 03 Dec 2019 11:59:12 -0500
Received: by mail-qt1-f198.google.com with SMTP id q17so2870052qtc.8
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 08:59:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dMSAhkBc+XDUp7X0JKW/OfiFquvplAZgCqXULfdRF2I=;
        b=XyDSctoB1/cKjo8Nb2eCkHcSaP1jYGiVycA2mcwVWO3sTnh2FrwgFJU9lalbDKs9TH
         slece5wM7lJMcnT1jlASSxDE1xMg/fNWY3iQul32mn/q1X9sMai0r1kKK7Ffbd/jzU4D
         6AKVlBI3UkhRTvctL2O75AhdybUHteMGK1dddIKZStoMk+zMLvKPZPn4Hcms52f4yHei
         ZruV/sWviVZ/y+vj5eB7LXGKBqkC5/qEpxx+RgNIDVSamQH5PYwfOqPE3nhVtR8KhK4e
         B5ER93oJyPiQNGbCMuKAImQjcSoOzCYt3fryjNQQpMiHx+IeeFKokxqnMrgKl60oV2SL
         mHtA==
X-Gm-Message-State: APjAAAUnJ2DmQ4SwWfn/AzFo8YJwXNQxUwXbn5LwNfM6faYiYcKzO5TC
        /eurcDqtOTqMyPaWsN0vx9yQWCerljQ703kWspP1KtaEp0Om1B1FnF49xywd0ggbAtIc3MV77p1
        djhXw+ULOHqde
X-Received: by 2002:ac8:4813:: with SMTP id g19mr6086864qtq.165.1575392351669;
        Tue, 03 Dec 2019 08:59:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqwhOExZF/82Calck5ed4HtF0UB8ns8wW9p0mAS3lY9jroDNugbV1+DN2S5djA6t1ZB7YgfJ5A==
X-Received: by 2002:ac8:4813:: with SMTP id g19mr6086847qtq.165.1575392351452;
        Tue, 03 Dec 2019 08:59:11 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a16sm482585qkn.48.2019.12.03.08.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:59:10 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v4 4/6] KVM: X86: Drop KVM_APIC_SHORT_MASK and KVM_APIC_DEST_MASK
Date:   Tue,  3 Dec 2019 11:59:01 -0500
Message-Id: <20191203165903.22917-5-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191203165903.22917-1-peterx@redhat.com>
References: <20191203165903.22917-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: FnzV2tSKOb6wZKLshthW6Q-1
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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

