Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A09B154250
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 11:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgBFKra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 05:47:30 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37272 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728254AbgBFKra (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 05:47:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580986048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DjACAqq/wYOhXLsaJL3aNxs4eglM1cTnecpkHCb5DHE=;
        b=X6ahpDdRjvCJxfcS9Vt+EqkPpWlq9QmGRb6/6dl5l558sMFD/o4nDayvxQyiXKWDe56+Tx
        ydclHYYDUVeCQ0GWFSK/AV8FAbuUoLvMgkNAZSC+7uwtbq0kvpR0aFxh/l5bmrEsm3RRvb
        xc4RegZyoyzV6XclCcqR1yJW4T/IgIM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-fX7PJ7G2Oy-0MdddfipMpA-1; Thu, 06 Feb 2020 05:47:27 -0500
X-MC-Unique: fX7PJ7G2Oy-0MdddfipMpA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BE81800D54;
        Thu,  6 Feb 2020 10:47:26 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDF058ECE3;
        Thu,  6 Feb 2020 10:47:21 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com
Subject: [PATCH v4 1/3] selftests: KVM: Replace get_gdt/idt_base() by get_gdt/idt()
Date:   Thu,  6 Feb 2020 11:47:08 +0100
Message-Id: <20200206104710.16077-2-eric.auger@redhat.com>
In-Reply-To: <20200206104710.16077-1-eric.auger@redhat.com>
References: <20200206104710.16077-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

get_gdt_base() and get_idt_base() only return the base address
of the descriptor tables. Soon we will need to get the size as well.
Change the prototype of those functions so that they return
the whole desc_ptr struct instead of the address field.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

---

v3 -> v4:
- Collected R-b's
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 8 ++++----
 tools/testing/selftests/kvm/lib/x86_64/vmx.c           | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/too=
ls/testing/selftests/kvm/include/x86_64/processor.h
index aa6451b3f740..6f7fffaea2e8 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -220,20 +220,20 @@ static inline void set_cr4(uint64_t val)
 	__asm__ __volatile__("mov %0, %%cr4" : : "r" (val) : "memory");
 }
=20
-static inline uint64_t get_gdt_base(void)
+static inline struct desc_ptr get_gdt(void)
 {
 	struct desc_ptr gdt;
 	__asm__ __volatile__("sgdt %[gdt]"
 			     : /* output */ [gdt]"=3Dm"(gdt));
-	return gdt.address;
+	return gdt;
 }
=20
-static inline uint64_t get_idt_base(void)
+static inline struct desc_ptr get_idt(void)
 {
 	struct desc_ptr idt;
 	__asm__ __volatile__("sidt %[idt]"
 			     : /* output */ [idt]"=3Dm"(idt));
-	return idt.address;
+	return idt;
 }
=20
 #define SET_XMM(__var, __xmm) \
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing=
/selftests/kvm/lib/x86_64/vmx.c
index 85064baf5e97..7aaa99ca4dbc 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -288,9 +288,9 @@ static inline void init_vmcs_host_state(void)
 	vmwrite(HOST_FS_BASE, rdmsr(MSR_FS_BASE));
 	vmwrite(HOST_GS_BASE, rdmsr(MSR_GS_BASE));
 	vmwrite(HOST_TR_BASE,
-		get_desc64_base((struct desc64 *)(get_gdt_base() + get_tr())));
-	vmwrite(HOST_GDTR_BASE, get_gdt_base());
-	vmwrite(HOST_IDTR_BASE, get_idt_base());
+		get_desc64_base((struct desc64 *)(get_gdt().address + get_tr())));
+	vmwrite(HOST_GDTR_BASE, get_gdt().address);
+	vmwrite(HOST_IDTR_BASE, get_idt().address);
 	vmwrite(HOST_IA32_SYSENTER_ESP, rdmsr(MSR_IA32_SYSENTER_ESP));
 	vmwrite(HOST_IA32_SYSENTER_EIP, rdmsr(MSR_IA32_SYSENTER_EIP));
 }
--=20
2.20.1

