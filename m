Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A6D10DB1E
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbfK2Vgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:36:31 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40114 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfK2VfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 16:35:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nk+AMYp/B5018WGXHd+pNlZDxGbWGzQP/gZBrdpp4/w=;
        b=XIweWHQtTxvJ8Y+sbuTXSLBnuCIf7q7xs1FWTJLhd64YBWXJmC/t7esAeqGO5vECMWknuD
        Agk/w8wh2XGfNW+LAyjxaSGgSs1VURxap2sxagF1f6MSWGxQfpyp8sewxTsxn3Je/z1u0s
        gDiJZ6V2eArH3Pc8YQsrM4KOhN8Upfs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-pqzvYRSmOQKc3_HUFCfyQQ-1; Fri, 29 Nov 2019 16:35:11 -0500
Received: by mail-qk1-f198.google.com with SMTP id q13so15605878qke.11
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZBxIG8UMSN4DcK848hz6hNmhnmdyT63k+9vVPNH+Rtk=;
        b=gavvrP6WQflyVGTSMCdpafUs4LjMwAXC/APQWgumWXk+0q2a3DvjDbsD1vetO/wv6x
         iYWNp7PmHTibDJi4C+m6/Bt4Cv+ZAU6H8/M+XK6VgvFLAYqqNa1hen7zfm1zreDyd5t1
         +t3E3P/WDNwofqMH1aVQmeBOvUAI5BpADid0c9lGzQU0n+33fBCNA146d3KXIWYG3CsJ
         0vPlu7CRAA3sUfE4gytYtc2IYWAZlvP+VxJvE1ZWTwZERuw1+UGlSC+m16/k1T3WVEul
         WkRHl8Uu5kAvzwArHAdvbsT/RsKwRkltthWl46Pei7EUd1ybMp0v6+iG50Y+Ux1w/CR4
         mE/A==
X-Gm-Message-State: APjAAAVAZzI0BZkdw9l3/5pgUu6CU2E+l5nJGvmL4qrJKUuYp9sZJCLt
        2mb5i9GW/VyV4+8SNaQ5ncPwrhvU4lUqt/jzQQVHJkqDLEE0/Ij+94upeEWJKzzsu9h7Ry41LJS
        fCmqpx4awyG0J
X-Received: by 2002:ad4:4bc2:: with SMTP id l2mr9372701qvw.50.1575063311141;
        Fri, 29 Nov 2019 13:35:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqxotUIlHNSr/8iS+DZ+KTBCqLO8S5vzYAHxSYPZIcfOoaZ/NoLxHiCXQAhCdpl46tcNdIw+/g==
X-Received: by 2002:ad4:4bc2:: with SMTP id l2mr9372678qvw.50.1575063310867;
        Fri, 29 Nov 2019 13:35:10 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:09 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 02/15] KVM: Add kvm/vcpu argument to mark_dirty_page_in_slot
Date:   Fri, 29 Nov 2019 16:34:52 -0500
Message-Id: <20191129213505.18472-3-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: pqzvYRSmOQKc3_HUFCfyQQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Cao, Lei" <Lei.Cao@stratus.com>

Signed-off-by: Cao, Lei <Lei.Cao@stratus.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/kvm_main.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fac0760c870e..8f8940cc4b84 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -145,7 +145,10 @@ static void hardware_disable_all(void);
=20
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
=20
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t=
 gfn);
+static void mark_page_dirty_in_slot(struct kvm *kvm,
+=09=09=09=09    struct kvm_vcpu *vcpu,
+=09=09=09=09    struct kvm_memory_slot *memslot,
+=09=09=09=09    gfn_t gfn);
=20
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
@@ -2077,7 +2080,8 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu,=
 gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
=20
-static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t g=
fn,
+static int __kvm_write_guest_page(struct kvm *kvm, struct kvm_vcpu *vcpu,
+=09=09=09=09  struct kvm_memory_slot *memslot, gfn_t gfn,
 =09=09=09          const void *data, int offset, int len)
 {
 =09int r;
@@ -2089,7 +2093,7 @@ static int __kvm_write_guest_page(struct kvm_memory_s=
lot *memslot, gfn_t gfn,
 =09r =3D __copy_to_user((void __user *)addr + offset, data, len);
 =09if (r)
 =09=09return -EFAULT;
-=09mark_page_dirty_in_slot(memslot, gfn);
+=09mark_page_dirty_in_slot(kvm, vcpu, memslot, gfn);
 =09return 0;
 }
=20
@@ -2098,7 +2102,8 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
 {
 =09struct kvm_memory_slot *slot =3D gfn_to_memslot(kvm, gfn);
=20
-=09return __kvm_write_guest_page(slot, gfn, data, offset, len);
+=09return __kvm_write_guest_page(kvm, NULL, slot, gfn, data,
+=09=09=09=09      offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
=20
@@ -2107,7 +2112,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, =
gfn_t gfn,
 {
 =09struct kvm_memory_slot *slot =3D kvm_vcpu_gfn_to_memslot(vcpu, gfn);
=20
-=09return __kvm_write_guest_page(slot, gfn, data, offset, len);
+=09return __kvm_write_guest_page(vcpu->kvm, vcpu, slot, gfn, data,
+=09=09=09=09      offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
=20
@@ -2221,7 +2227,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, st=
ruct gfn_to_hva_cache *ghc,
 =09r =3D __copy_to_user((void __user *)ghc->hva + offset, data, len);
 =09if (r)
 =09=09return -EFAULT;
-=09mark_page_dirty_in_slot(ghc->memslot, gpa >> PAGE_SHIFT);
+=09mark_page_dirty_in_slot(kvm, NULL, ghc->memslot, gpa >> PAGE_SHIFT);
=20
 =09return 0;
 }
@@ -2286,7 +2292,9 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsig=
ned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
=20
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
+static void mark_page_dirty_in_slot(struct kvm *kvm,
+=09=09=09=09    struct kvm_vcpu *vcpu,
+=09=09=09=09    struct kvm_memory_slot *memslot,
 =09=09=09=09    gfn_t gfn)
 {
 =09if (memslot && memslot->dirty_bitmap) {
@@ -2301,7 +2309,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 =09struct kvm_memory_slot *memslot;
=20
 =09memslot =3D gfn_to_memslot(kvm, gfn);
-=09mark_page_dirty_in_slot(memslot, gfn);
+=09mark_page_dirty_in_slot(kvm, NULL, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty);
=20
@@ -2310,7 +2318,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, =
gfn_t gfn)
 =09struct kvm_memory_slot *memslot;
=20
 =09memslot =3D kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-=09mark_page_dirty_in_slot(memslot, gfn);
+=09mark_page_dirty_in_slot(vcpu->kvm, vcpu, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
=20
--=20
2.21.0

