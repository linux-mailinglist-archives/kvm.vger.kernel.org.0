Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A53411C37A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 03:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfLLCpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 21:45:39 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38816 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727892AbfLLCpj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 21:45:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576118739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uncFyvnHFSKVFSYnpKTKrWHTgCtzsOrAlALXlYSzS3Q=;
        b=H1vUJz6zbzdTtXYfq4vq7Bmx57LIKVKMjE+XxNi5n7CuHLyKW2vDTHpk3UK0sC38rsRcXl
        3ZL1hssks3KCOcAZ3i/t+iwBEFKgdywQozZDgt0nDmfsF3Cue0iX5zir5F4rIYAIr/37EC
        R/GDVR7pHrdDdpTOBaDJyEKd0dtqgYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-22lQ5p1LPcueCQXL0rT7Ew-1; Wed, 11 Dec 2019 21:45:38 -0500
X-MC-Unique: 22lQ5p1LPcueCQXL0rT7Ew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE2BC1800D45;
        Thu, 12 Dec 2019 02:45:36 +0000 (UTC)
Received: from localhost.localdomain.com (vpn2-54-40.bne.redhat.com [10.64.54.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CED16FEF8;
        Thu, 12 Dec 2019 02:45:33 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, paulus@ozlabs.org,
        maz@kernel.org, jhogan@kernel.org, drjones@redhat.com,
        vkuznets@redhat.com, gshan@redhat.com
Subject: [PATCH 3/3] kvm/arm: Standardize kvm exit reason field
Date:   Thu, 12 Dec 2019 13:45:12 +1100
Message-Id: <20191212024512.39930-4-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This standardizes kvm exit reason field name by replacing "esr_ec"
with "exit_reason".

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 virt/kvm/arm/trace.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
index 204d210d01c2..0ac774fd324d 100644
--- a/virt/kvm/arm/trace.h
+++ b/virt/kvm/arm/trace.h
@@ -27,25 +27,27 @@ TRACE_EVENT(kvm_entry,
 );
=20
 TRACE_EVENT(kvm_exit,
-	TP_PROTO(int ret, unsigned int esr_ec, unsigned long vcpu_pc),
-	TP_ARGS(ret, esr_ec, vcpu_pc),
+	TP_PROTO(int ret, unsigned int exit_reason, unsigned long vcpu_pc),
+	TP_ARGS(ret, exit_reason, vcpu_pc),
=20
 	TP_STRUCT__entry(
 		__field(	int,		ret		)
-		__field(	unsigned int,	esr_ec		)
+		__field(	unsigned int,	exit_reason	)
 		__field(	unsigned long,	vcpu_pc		)
 	),
=20
 	TP_fast_assign(
 		__entry->ret			=3D ARM_EXCEPTION_CODE(ret);
-		__entry->esr_ec =3D ARM_EXCEPTION_IS_TRAP(ret) ? esr_ec : 0;
+		__entry->exit_reason =3D
+			ARM_EXCEPTION_IS_TRAP(ret) ? exit_reason: 0;
 		__entry->vcpu_pc		=3D vcpu_pc;
 	),
=20
 	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
 		  __print_symbolic(__entry->ret, kvm_arm_exception_type),
-		  __entry->esr_ec,
-		  __print_symbolic(__entry->esr_ec, kvm_arm_exception_class),
+		  __entry->exit_reason,
+		  __print_symbolic(__entry->exit_reason,
+				   kvm_arm_exception_class),
 		  __entry->vcpu_pc)
 );
=20
--=20
2.23.0

