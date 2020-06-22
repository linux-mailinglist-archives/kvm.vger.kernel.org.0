Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C8F203C38
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgFVQIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:08:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53770 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726328AbgFVQIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 12:08:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592842120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oLt4zilRnLpSNkiF0C8oekFwW4sIceZdS9Lxg4NGfQA=;
        b=PK+e1cLpHraM4um6ix+qtFJ1R5QX9DKFempRhpHpyYXR3KGLUAnsLQuQNdMA7Ne2LPWSyN
        gyE2b4xdkfipTppjgTIOrHSbVLhGXuO4NYs0pMQT6uu/PV7/JBOk4+D+0qwF9HUq2aPt/r
        utnGwO+YqUWBGUECrSHv9KM4VNBPwYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-IPnes8dvMvar_MJTs1dysA-1; Mon, 22 Jun 2020 12:08:35 -0400
X-MC-Unique: IPnes8dvMvar_MJTs1dysA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 545F5A0BD9;
        Mon, 22 Jun 2020 16:08:33 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq.redhat.com (dell-r430-03.lab.eng.brq.redhat.com [10.37.153.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECEC45BACD;
        Mon, 22 Jun 2020 16:08:31 +0000 (UTC)
From:   Igor Mammedov <imammedo@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, kvm@vger.kernel.org, wanpengli@tencent.com
Subject: [PATCH] kvm: lapic: fix broken vcpu hotplug
Date:   Mon, 22 Jun 2020 12:08:30 -0400
Message-Id: <20200622160830.426022-1-imammedo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guest fails to online hotplugged CPU with error
  smpboot: do_boot_cpu failed(-1) to wakeup CPU#4

It's caused by the fact that kvm_apic_set_state(), which used to call
recalculate_apic_map() unconditionally and pulled hotplugged CPU into
apic map, is updating map conditionally [1] on state change which doesn't
happen in this case and apic map update is skipped.

Note:
new CPU during kvm_arch_vcpu_create() is not visible to
kvm_recalculate_apic_map(), so all related update calls endup
as NOP and only follow up kvm_apic_set_state() used to trigger map
update that counted in hotplugged CPU.
Fix issue by forcing unconditional update from kvm_apic_set_state(),
like it used to be.

1)
Fixes: (4abaffce4d25a KVM: LAPIC: Recalculate apic map in batch)
Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
PS:
it's alternative to full revert of [1], I've posted earlier
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2205600.html
so fii free to pick up whatever is better by now
---
 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 34a7e0533dad..5696831d4005 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2556,6 +2556,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	int r;
 
+	apic->vcpu->kvm->arch.apic_map_dirty = true;
 	kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
 	/* set SPIV separately to get count of SW disabled APICs right */
 	apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV)));
-- 
2.26.2

