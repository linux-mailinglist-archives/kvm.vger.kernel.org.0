Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBDD15C062
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 15:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgBMOdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 09:33:21 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20140 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727414AbgBMOdV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Feb 2020 09:33:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581604400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BS1gc949f0GEp9oop4QVBA5jni4HDU5dKQyNOzlsGVM=;
        b=cuolvnAr5av0Qr+UrvGZJYqcYGw5KQow1SkqSXBJ2NMLTTwIuQSEanpvevyq4MUqzfWhZT
        b20aiRxvzdoC91JTbrC3xnJiDraqeD1bhhwYzQW+d01o3mvH96kqjdPxzudubKHk9quRHu
        UfeXHgj1Uau22P3iOWfR1RtxJN6sgXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-2N3f5fKnPl-xQ9XA07MICg-1; Thu, 13 Feb 2020 09:33:16 -0500
X-MC-Unique: 2N3f5fKnPl-xQ9XA07MICg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AEE3801E67;
        Thu, 13 Feb 2020 14:33:15 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 278CF5C1D6;
        Thu, 13 Feb 2020 14:33:08 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     peter.maydell@linaro.org, alex.bennee@linaro.org,
        pbonzini@redhat.com, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, frankja@linux.ibm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests 1/2] arch-run: Allow $QEMU to include parameters
Date:   Thu, 13 Feb 2020 15:32:59 +0100
Message-Id: <20200213143300.32141-2-drjones@redhat.com>
In-Reply-To: <20200213143300.32141-1-drjones@redhat.com>
References: <20200213143300.32141-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now it's possible to run all tests using run_tests.sh with a
QEMU specified by the $QEMU environment variable that also
includes additional parameters. E.g. QEMU=3D"/path/to/qemu -icount 8"

Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 scripts/arch-run.bash | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d3ca19d49952..ebe4d3cb2a09 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -172,8 +172,20 @@ search_qemu_binary ()
 	local save_path=3D$PATH
 	local qemucmd qemu
=20
+	if [ -n "$QEMU" ]; then
+		set -- $QEMU
+		if ! "$1" --help 2>/dev/null | grep -q 'QEMU'; then
+			echo "\$QEMU environment variable not set to a QEMU binary." >&2
+			return 2
+		fi
+		qemu=3D$(command -v "$1")
+		shift
+		echo "$qemu $@"
+		return
+	fi
+
 	export PATH=3D$PATH:/usr/libexec
-	for qemucmd in ${QEMU:-qemu-system-$ARCH_NAME qemu-kvm}; do
+	for qemucmd in qemu-system-$ARCH_NAME qemu-kvm; do
 		if $qemucmd --help 2>/dev/null | grep -q 'QEMU'; then
 			qemu=3D"$qemucmd"
 			break
--=20
2.21.1

