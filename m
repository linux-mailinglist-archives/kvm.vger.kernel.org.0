Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7EB1A8C06
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 22:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632773AbgDNUNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 16:13:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52376 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2632742AbgDNULR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 16:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586895076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TBfymaLjeSq2rO2oeC+ZflWOK6IYAgATphCSjLeriTw=;
        b=DoOl7nvWDREeBOkGnOSKiNyTKS4Xh6L3F1ltNJgAkqBWPx+ly1k5PElSM4W3PJo6KGPVss
        id4c9kQJdqdDYUFC71i4pxk1q0sICrnY+iFHzA9UQ1cXlpNN0EDWpCopA/FNXWMxgwBKdv
        Gcd0y5s8HOa0Yahq+t/wAv2H8f5/TLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-__B1P1llPCeFq6HN7ExM9g-1; Tue, 14 Apr 2020 16:11:14 -0400
X-MC-Unique: __B1P1llPCeFq6HN7ExM9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3959280269D;
        Tue, 14 Apr 2020 20:11:13 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-69.rdu2.redhat.com [10.10.113.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 728C55D9CD;
        Tue, 14 Apr 2020 20:11:12 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
Subject: [PATCH 2/2] KVM: x86: check_nested_events if there is an injectable NMI
Date:   Tue, 14 Apr 2020 16:11:07 -0400
Message-Id: <20200414201107.22952-3-cavery@redhat.com>
In-Reply-To: <20200414201107.22952-1-cavery@redhat.com>
References: <20200414201107.22952-1-cavery@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With NMI intercept moved to check_nested_events there is a race
condition where vcpu->arch.nmi_pending is set late causing
the execution of check_nested_events to not setup correctly
for nested.exit_required. A second call to check_nested_events
allows the injectable nmi to be detected in time in order to
require immediate exit from L2 to L1.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 arch/x86/kvm/x86.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 027dfd278a97..ecfafcd93536 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7734,10 +7734,17 @@ static int inject_pending_event(struct kvm_vcpu *=
vcpu)
 		vcpu->arch.smi_pending =3D false;
 		++vcpu->arch.smi_count;
 		enter_smm(vcpu);
-	} else if (vcpu->arch.nmi_pending && kvm_x86_ops.nmi_allowed(vcpu)) {
-		--vcpu->arch.nmi_pending;
-		vcpu->arch.nmi_injected =3D true;
-		kvm_x86_ops.set_nmi(vcpu);
+	} else if (vcpu->arch.nmi_pending) {
+		if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
+			r =3D kvm_x86_ops.check_nested_events(vcpu);
+			if (r !=3D 0)
+				return r;
+		}
+		if (kvm_x86_ops.nmi_allowed(vcpu)) {
+			--vcpu->arch.nmi_pending;
+			vcpu->arch.nmi_injected =3D true;
+			kvm_x86_ops.set_nmi(vcpu);
+		}
 	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
 		/*
 		 * Because interrupts can be injected asynchronously, we are
--=20
2.20.1

