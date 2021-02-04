Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CB130C6FC
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbhBBRG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:06:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57131 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237005AbhBBRES (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:04:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612285373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=F9oAoXtAX+Cil+a1sW8Pz3+QVGLc8h16eVPUFtZSABM=;
        b=LgRsP0+gGX811rh8Wjopr3tCeT/PWO+G1Z2D6GYtTmsGPCqezyN9m0/80gTY+IbN8ZJSIY
        89ZDnXTku1UyLGOSXb1tOg3UmHGi27NSYMUDrGsR/zDk3rcrlawm9s855EsCOrM15wom+V
        yvbjtZSYcYveext1HMLp61jFty24xyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-l6UgDDbgPyelQPCboFbVhg-1; Tue, 02 Feb 2021 12:02:47 -0500
X-MC-Unique: l6UgDDbgPyelQPCboFbVhg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFC87801817;
        Tue,  2 Feb 2021 17:02:46 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F8A75D9C6;
        Tue,  2 Feb 2021 17:02:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH] KVM: cleanup DR6/DR7 reserved bits checks
Date:   Tue,  2 Feb 2021 12:02:46 -0500
Message-Id: <20210202170246.89436-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_dr6_valid and kvm_dr7_valid check that bits 63:32 are zero.  Using
them makes it easier to review the code for inconsistencies.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 97674204bf44..e52e38f8c74d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4414,9 +4414,9 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	if (dbgregs->flags)
 		return -EINVAL;
 
-	if (dbgregs->dr6 & ~0xffffffffull)
+	if (!kvm_dr6_valid(dbgregs->dr6))
 		return -EINVAL;
-	if (dbgregs->dr7 & ~0xffffffffull)
+	if (!kvm_dr7_valid(dbgregs->dr7))
 		return -EINVAL;
 
 	memcpy(vcpu->arch.db, dbgregs->db, sizeof(vcpu->arch.db));
-- 
2.26.2

