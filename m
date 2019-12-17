Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B7A1221CF
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 03:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfLQCGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 21:06:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57729 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726133AbfLQCGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 21:06:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576548372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bYXs4y+7UYR5FEMuno/b/WUb7xe9pnd08JpgREnT/sQ=;
        b=BwVWjQPsEldxm3eGma/ELLnOILGhve8E2V53njqWa/mE23kV1xeX8LXm1F6pHo5VhRHCyO
        /53STlMFQx1N9IiiOM92T2j7JBkmNvMauaOfRNJ4sItDnA0TV8pWncMTxJnFytiGnSXTBo
        h1xPyvhGERsQLlJEdTZb+TsbdrPnOjs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-24oA3peAO2-8M3YhsPXvkw-1; Mon, 16 Dec 2019 21:06:10 -0500
X-MC-Unique: 24oA3peAO2-8M3YhsPXvkw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CEA01809A2F;
        Tue, 17 Dec 2019 02:06:09 +0000 (UTC)
Received: from localhost.localdomain.com (vpn2-54-16.bne.redhat.com [10.64.54.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 900497C834;
        Tue, 17 Dec 2019 02:06:04 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        vkuznets@redhat.com, maz@kernel.org
Subject: [PATCH v2] tools/kvm_stat: Fix kvm_exit filter name
Date:   Tue, 17 Dec 2019 13:06:00 +1100
Message-Id: <20191217020600.10268-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The filter name is fixed to "exit_reason" for some kvm_exit events, no
matter what architect we have. Actually, the filter name ("exit_reason")
is only applicable to x86, meaning it's broken on other architects
including aarch64.

This fixes the issue by providing various kvm_exit filter names, dependin=
g
on architect we're on. Afterwards, the variable filter name is picked and
applied by ioctl(fd, SET_FILTER).

Reported-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
v2: Rename exit_field to exit_reason_field
    Fix the name to esr_ec for aarch64
---
 tools/kvm/kvm_stat/kvm_stat | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index ad1b9e646c49..4cf93110c259 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -270,6 +270,7 @@ class ArchX86(Arch):
     def __init__(self, exit_reasons):
         self.sc_perf_evt_open =3D 298
         self.ioctl_numbers =3D IOCTL_NUMBERS
+        self.exit_reason_field =3D 'exit_reason'
         self.exit_reasons =3D exit_reasons
=20
     def debugfs_is_child(self, field):
@@ -289,6 +290,7 @@ class ArchPPC(Arch):
         # numbers depend on the wordsize.
         char_ptr_size =3D ctypes.sizeof(ctypes.c_char_p)
         self.ioctl_numbers['SET_FILTER'] =3D 0x80002406 | char_ptr_size =
<< 16
+        self.exit_reason_field =3D 'exit_nr'
         self.exit_reasons =3D {}
=20
     def debugfs_is_child(self, field):
@@ -300,6 +302,7 @@ class ArchA64(Arch):
     def __init__(self):
         self.sc_perf_evt_open =3D 241
         self.ioctl_numbers =3D IOCTL_NUMBERS
+        self.exit_reason_field =3D 'esr_ec'
         self.exit_reasons =3D AARCH64_EXIT_REASONS
=20
     def debugfs_is_child(self, field):
@@ -311,6 +314,7 @@ class ArchS390(Arch):
     def __init__(self):
         self.sc_perf_evt_open =3D 331
         self.ioctl_numbers =3D IOCTL_NUMBERS
+        self.exit_reason_field =3D None
         self.exit_reasons =3D None
=20
     def debugfs_is_child(self, field):
@@ -541,8 +545,8 @@ class TracepointProvider(Provider):
         """
         filters =3D {}
         filters['kvm_userspace_exit'] =3D ('reason', USERSPACE_EXIT_REAS=
ONS)
-        if ARCH.exit_reasons:
-            filters['kvm_exit'] =3D ('exit_reason', ARCH.exit_reasons)
+        if ARCH.exit_reason_field and ARCH.exit_reasons:
+            filters['kvm_exit'] =3D (ARCH.exit_reason_field, ARCH.exit_r=
easons)
         return filters
=20
     def _get_available_fields(self):
--=20
2.23.0

