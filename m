Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139F311C379
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 03:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfLLCpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 21:45:35 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36044 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727756AbfLLCpf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 21:45:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576118734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sr810Oqrdalkpz1AS7AmLIEu53E2Nn5hxhJYZnRzfmA=;
        b=HU4uXUbFKYFYGdV0Y02Qy2TPPRThdhYMrQGsKFfDiM4fgrkeKdx98TS+7MrJs7p9K1NZaz
        7+6COUj8Okzhkk44w7zKzSo25ueXKGnVsMZMKCWwakpOnRaOOxjiaC+z6ry3VMu+UHD4NP
        Cap8QpCtx1KLWVe1eLZgJirq1soV9C8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-FeCsVO4jN9Oa1C8NMATUAw-1; Wed, 11 Dec 2019 21:45:33 -0500
X-MC-Unique: FeCsVO4jN9Oa1C8NMATUAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CCFE107ACCD;
        Thu, 12 Dec 2019 02:45:32 +0000 (UTC)
Received: from localhost.localdomain.com (vpn2-54-40.bne.redhat.com [10.64.54.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7144276FFF;
        Thu, 12 Dec 2019 02:45:29 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, paulus@ozlabs.org,
        maz@kernel.org, jhogan@kernel.org, drjones@redhat.com,
        vkuznets@redhat.com, gshan@redhat.com
Subject: [PATCH 2/3] kvm/powerpc: Standardize kvm exit reason field
Date:   Thu, 12 Dec 2019 13:45:11 +1100
Message-Id: <20191212024512.39930-3-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This standardizes kvm exit reason field name by replacing "exit_nr"
with "exit_reason".

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/powerpc/kvm/trace_booke.h | 10 +++++-----
 arch/powerpc/kvm/trace_pr.h    | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kvm/trace_booke.h b/arch/powerpc/kvm/trace_book=
e.h
index 3837842986aa..f757ce1dccb9 100644
--- a/arch/powerpc/kvm/trace_booke.h
+++ b/arch/powerpc/kvm/trace_booke.h
@@ -36,11 +36,11 @@
 	{41, "HV_PRIV"}
=20
 TRACE_EVENT(kvm_exit,
-	TP_PROTO(unsigned int exit_nr, struct kvm_vcpu *vcpu),
-	TP_ARGS(exit_nr, vcpu),
+	TP_PROTO(unsigned int exit_reason, struct kvm_vcpu *vcpu),
+	TP_ARGS(exit_reason, vcpu),
=20
 	TP_STRUCT__entry(
-		__field(	unsigned int,	exit_nr		)
+		__field(	unsigned int,	exit_reason	)
 		__field(	unsigned long,	pc		)
 		__field(	unsigned long,	msr		)
 		__field(	unsigned long,	dar		)
@@ -48,7 +48,7 @@ TRACE_EVENT(kvm_exit,
 	),
=20
 	TP_fast_assign(
-		__entry->exit_nr	=3D exit_nr;
+		__entry->exit_reason	=3D exit_reason;
 		__entry->pc		=3D kvmppc_get_pc(vcpu);
 		__entry->dar		=3D kvmppc_get_fault_dar(vcpu);
 		__entry->msr		=3D vcpu->arch.shared->msr;
@@ -61,7 +61,7 @@ TRACE_EVENT(kvm_exit,
 		" | dar=3D0x%lx"
 		" | last_inst=3D0x%lx"
 		,
-		__print_symbolic(__entry->exit_nr, kvm_trace_symbol_exit),
+		__print_symbolic(__entry->exit_reason, kvm_trace_symbol_exit),
 		__entry->pc,
 		__entry->msr,
 		__entry->dar,
diff --git a/arch/powerpc/kvm/trace_pr.h b/arch/powerpc/kvm/trace_pr.h
index 46a46d328fbf..b6039777e2b4 100644
--- a/arch/powerpc/kvm/trace_pr.h
+++ b/arch/powerpc/kvm/trace_pr.h
@@ -215,11 +215,11 @@ TRACE_EVENT(kvm_book3s_slbmte,
 );
=20
 TRACE_EVENT(kvm_exit,
-	TP_PROTO(unsigned int exit_nr, struct kvm_vcpu *vcpu),
-	TP_ARGS(exit_nr, vcpu),
+	TP_PROTO(unsigned int exit_reason, struct kvm_vcpu *vcpu),
+	TP_ARGS(exit_reason, vcpu),
=20
 	TP_STRUCT__entry(
-		__field(	unsigned int,	exit_nr		)
+		__field(	unsigned int,	exit_reason	)
 		__field(	unsigned long,	pc		)
 		__field(	unsigned long,	msr		)
 		__field(	unsigned long,	dar		)
@@ -228,7 +228,7 @@ TRACE_EVENT(kvm_exit,
 	),
=20
 	TP_fast_assign(
-		__entry->exit_nr	=3D exit_nr;
+		__entry->exit_reason	=3D exit_reason;
 		__entry->pc		=3D kvmppc_get_pc(vcpu);
 		__entry->dar		=3D kvmppc_get_fault_dar(vcpu);
 		__entry->msr		=3D kvmppc_get_msr(vcpu);
@@ -243,7 +243,7 @@ TRACE_EVENT(kvm_exit,
 		" | srr1=3D0x%lx"
 		" | last_inst=3D0x%lx"
 		,
-		__print_symbolic(__entry->exit_nr, kvm_trace_symbol_exit),
+		__print_symbolic(__entry->exit_reason, kvm_trace_symbol_exit),
 		__entry->pc,
 		__entry->msr,
 		__entry->dar,
--=20
2.23.0

