Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF69A135C8C
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732318AbgAIPWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:22:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35072 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732315AbgAIPWE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 10:22:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578583323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GkPqCUD4XkIHW5a1LsjZ+v2acwoaiMCCGZAUZ9gBdJI=;
        b=ZqIs0MvKBp3Jw6mqFNsuF4jFd0gLAmShCZq6B89inz9D1linMFjfSCGVJ/rRPx7c1tVJkn
        aJhhjfNArdgXWVvGSZJ/pJ5G5AXrRBUJkwkurgDsVLxxhQxgDQizzlcpRjSWD9uHLIxM2d
        ZTWtWLi9FBSOf23BMa3QbuIfH07EQv8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-Gscak5j0MSqJfyybuFHsGw-1; Thu, 09 Jan 2020 10:21:59 -0500
X-MC-Unique: Gscak5j0MSqJfyybuFHsGw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAC11804910;
        Thu,  9 Jan 2020 15:21:57 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44F1180608;
        Thu,  9 Jan 2020 15:21:45 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        qemu-ppc@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 01/15] target/arm/kvm: Use CPUState::kvm_state in kvm_arm_pmu_supported()
Date:   Thu,  9 Jan 2020 16:21:19 +0100
Message-Id: <20200109152133.23649-2-philmd@redhat.com>
In-Reply-To: <20200109152133.23649-1-philmd@redhat.com>
References: <20200109152133.23649-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVMState is already accessible via CPUState::kvm_state, use it.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 target/arm/kvm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index b87b59a02a..8d82889150 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -181,9 +181,7 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
=20
 bool kvm_arm_pmu_supported(CPUState *cpu)
 {
-    KVMState *s =3D KVM_STATE(current_machine->accelerator);
-
-    return kvm_check_extension(s, KVM_CAP_ARM_PMU_V3);
+    return kvm_check_extension(cpu->kvm_state, KVM_CAP_ARM_PMU_V3);
 }
=20
 int kvm_arm_get_max_vm_ipa_size(MachineState *ms)
--=20
2.21.1

