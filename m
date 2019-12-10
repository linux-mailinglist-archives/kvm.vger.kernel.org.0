Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB395117F31
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 05:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfLJEsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 23:48:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21090 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726619AbfLJEsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 23:48:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575953319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QympgZOxqEEUQUgiK/ImVQ4UaqIOxBVleuToewMy0Ek=;
        b=Vi+WHZjdh5n9KKRjqnnCklKQSioTCbB3vR33f4DxpSxq2XcSDn7/hKLaW5z4mBkrd2eDYJ
        uEYuDk2i6RopUqj8uBXy/YVX+njopOLCC+nXAIg3WZFaymh8rkT4GM3uqJAjrOd52OOgAu
        sqIy8qbkp3d/eU/o0gEE6pM/MykOJKU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-bktEsB10NHCGdS9KSGL7wA-1; Mon, 09 Dec 2019 23:48:38 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91050800D54
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 04:48:37 +0000 (UTC)
Received: from localhost.localdomain.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E6181001925;
        Tue, 10 Dec 2019 04:48:32 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        gshan@redhat.com
Subject: [PATCH] tools/kvm_stat: Fix kvm_exit filter name
Date:   Tue, 10 Dec 2019 15:48:29 +1100
Message-Id: <20191210044829.180122-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: bktEsB10NHCGdS9KSGL7wA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The filter name is fixed to "exit_reason" for some kvm_exit events, no
matter what architect we have. Actually, the filter name ("exit_reason")
is only applicable to x86, meaning it's broken on other architects
including aarch64.

This fixes the issue by providing various kvm_exit filter names, depending
on architect we're on. Afterwards, the variable filter name is picked and
applied through ioctl(fd, SET_FILTER).

Reported-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/kvm/kvm_stat/kvm_stat | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index ad1b9e646c49..f9273614b7e3 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -270,6 +270,7 @@ class ArchX86(Arch):
     def __init__(self, exit_reasons):
         self.sc_perf_evt_open =3D 298
         self.ioctl_numbers =3D IOCTL_NUMBERS
+        self.exit_field =3D 'exit_reason'
         self.exit_reasons =3D exit_reasons
=20
     def debugfs_is_child(self, field):
@@ -289,6 +290,7 @@ class ArchPPC(Arch):
         # numbers depend on the wordsize.
         char_ptr_size =3D ctypes.sizeof(ctypes.c_char_p)
         self.ioctl_numbers['SET_FILTER'] =3D 0x80002406 | char_ptr_size <<=
 16
+        self.exit_field =3D 'exit_nr'
         self.exit_reasons =3D {}
=20
     def debugfs_is_child(self, field):
@@ -300,6 +302,7 @@ class ArchA64(Arch):
     def __init__(self):
         self.sc_perf_evt_open =3D 241
         self.ioctl_numbers =3D IOCTL_NUMBERS
+        self.exit_field =3D 'ret'
         self.exit_reasons =3D AARCH64_EXIT_REASONS
=20
     def debugfs_is_child(self, field):
@@ -311,6 +314,7 @@ class ArchS390(Arch):
     def __init__(self):
         self.sc_perf_evt_open =3D 331
         self.ioctl_numbers =3D IOCTL_NUMBERS
+        self.exit_field =3D None
         self.exit_reasons =3D None
=20
     def debugfs_is_child(self, field):
@@ -541,8 +545,8 @@ class TracepointProvider(Provider):
         """
         filters =3D {}
         filters['kvm_userspace_exit'] =3D ('reason', USERSPACE_EXIT_REASON=
S)
-        if ARCH.exit_reasons:
-            filters['kvm_exit'] =3D ('exit_reason', ARCH.exit_reasons)
+        if ARCH.exit_field and ARCH.exit_reasons:
+            filters['kvm_exit'] =3D (ARCH.exit_field, ARCH.exit_reasons)
         return filters
=20
     def _get_available_fields(self):
--=20
2.23.0

