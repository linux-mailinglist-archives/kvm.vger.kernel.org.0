Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C25C2F2E8E
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 13:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388701AbfKGMyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 07:54:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57183 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727619AbfKGMyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 07:54:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573131239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3y0I7IlS4H5f58+QId2pdet5TjErOAhCzPeVmmoAFuQ=;
        b=jCe1SNinnIz56+ejZ0Pq0o7CzojN4Do7BmpsOHhdavUzbHq7Wiilhc1auvnasNNu4c8hh7
        LmS0UtL/qGdPCCg3/9jQY7lBMYZrrWRi9ZX3olG4+8kPDjseEt2Bpp18kS1VPqYErarRcx
        BOlu4zALQDnfhb1knYXX4yTY2IppYdI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-aTBMbFduMU-rfHfqz0ay2A-1; Thu, 07 Nov 2019 07:53:55 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A48F48017DD;
        Thu,  7 Nov 2019 12:53:54 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B4041001E75;
        Thu,  7 Nov 2019 12:53:53 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mtosatti@redhat.com, rkrcmar@redhat.com,
        vkuznets@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [Patch v2 1/2] KVM: remember position in kvm->vcpus array
Date:   Thu,  7 Nov 2019 07:53:42 -0500
Message-Id: <1573131223-5685-2-git-send-email-nitesh@redhat.com>
In-Reply-To: <1573131223-5685-1-git-send-email-nitesh@redhat.com>
References: <1573131223-5685-1-git-send-email-nitesh@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: aTBMbFduMU-rfHfqz0ay2A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>

Fetching an index for any vcpu in kvm->vcpus array by traversing
the entire array everytime is costly.
This patch remembers the position of each vcpu in kvm->vcpus array
by storing it in vcpus_idx under kvm_vcpu structure.

Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 include/linux/kvm_host.h | 11 +++--------
 virt/kvm/kvm_main.c      |  5 +++--
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 719fc3e..22068fe 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -266,7 +266,8 @@ struct kvm_vcpu {
 =09struct preempt_notifier preempt_notifier;
 #endif
 =09int cpu;
-=09int vcpu_id;
+=09int vcpu_id; /* id given by userspace at creation */
+=09int vcpu_idx; /* index in kvm->vcpus array */
 =09int srcu_idx;
 =09int mode;
 =09u64 requests;
@@ -571,13 +572,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(stru=
ct kvm *kvm, int id)
=20
 static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
 {
-=09struct kvm_vcpu *tmp;
-=09int idx;
-
-=09kvm_for_each_vcpu(idx, tmp, vcpu->kvm)
-=09=09if (tmp =3D=3D vcpu)
-=09=09=09return idx;
-=09BUG();
+=09return vcpu->vcpu_idx;
 }
=20
 #define kvm_for_each_memslot(memslot, slots)=09\
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67ef3f2..72132fc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2673,7 +2673,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, =
u32 id)
 =09=09goto unlock_vcpu_destroy;
 =09}
=20
-=09BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
+=09vcpu->vcpu_idx =3D atomic_read(&kvm->online_vcpus);
+=09BUG_ON(kvm->vcpus[vcpu->vcpu_idx]);
=20
 =09/* Now it's all set up, let userspace reach it */
 =09kvm_get_kvm(kvm);
@@ -2683,7 +2684,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, =
u32 id)
 =09=09goto unlock_vcpu_destroy;
 =09}
=20
-=09kvm->vcpus[atomic_read(&kvm->online_vcpus)] =3D vcpu;
+=09kvm->vcpus[vcpu->vcpu_idx] =3D vcpu;
=20
 =09/*
 =09 * Pairs with smp_rmb() in kvm_get_vcpu.  Write kvm->vcpus
--=20
1.8.3.1

