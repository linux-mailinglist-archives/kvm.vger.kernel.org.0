Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A565C15C063
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 15:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgBMOdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 09:33:22 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20057 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727511AbgBMOdW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Feb 2020 09:33:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581604401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yGxqh+JUbDFpXw/tRFqtlST406bww3UGxKfo5WhxX34=;
        b=NhSbBrLrXKyGbr9j7DDK4tdxqbh8qF5gMHiG1L/K+pf0JqgX5v/BVLXZrH56REtcLKgqZ4
        C9uE622cKXnR6T0Sz30RStXHIUN6uqTq2WCX7qryIWDTi6K7UJbXfZ38k4+TO+aid6BXwo
        CF8BrTc8hKWQYKe2legwqHlaY+DyzcA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-jMODuqiSOT2R0GAr8fETJQ-1; Thu, 13 Feb 2020 09:33:18 -0500
X-MC-Unique: jMODuqiSOT2R0GAr8fETJQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7387C800D48;
        Thu, 13 Feb 2020 14:33:17 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71A5D5C1C3;
        Thu, 13 Feb 2020 14:33:15 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     peter.maydell@linaro.org, alex.bennee@linaro.org,
        pbonzini@redhat.com, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, frankja@linux.ibm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests 2/2] runtime: Introduce VMM_PARAMS
Date:   Thu, 13 Feb 2020 15:33:00 +0100
Message-Id: <20200213143300.32141-3-drjones@redhat.com>
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

Users may need to temporarily provide additional VMM parameters.
The VMM_PARAMS environment variable provides a way to do that.
We take care to make sure when executing ./run_tests.sh that
the VMM_PARAMS parameters come last, allowing unittests.cfg
parameters to be overridden. However, when running a command
line like `$ARCH/run $TEST $PARAMS` we want $PARAMS to override
$VMM_PARAMS, so we ensure that too.

Additional QEMU parameters can still be provided by appending
them to the $QEMU environment variable when it provides the
path to QEMU, but as those parameters will then be the first
in the command line they cannot override anything, and may
themselves be overridden.

Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 README.md            | 5 +++++
 arm/run              | 4 +++-
 powerpc/run          | 4 +++-
 s390x/run            | 1 +
 scripts/runtime.bash | 4 +++-
 x86/run              | 4 +++-
 6 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/README.md b/README.md
index 396fbf809a4e..834d6202ac97 100644
--- a/README.md
+++ b/README.md
@@ -47,6 +47,11 @@ environment variable:
=20
     QEMU=3D/tmp/qemu/x86_64-softmmu/qemu-system-x86_64 ./x86-run ./x86/m=
sr.flat
=20
+If QEMU additional parameters are needed for all tests, then they may be
+provided in the VMM_PARAMS environment variable:
+
+    VMM_PARAMS=3D"-additional parameters -go here" ./run_tests.sh
+
 To select an accelerator, for example "kvm" or "tcg", specify the
 ACCEL=3Dname environment variable:
=20
diff --git a/arm/run b/arm/run
index 277db9bb4a02..a8a93591b825 100755
--- a/arm/run
+++ b/arm/run
@@ -60,7 +60,9 @@ fi
=20
 M+=3D",accel=3D$ACCEL"
 command=3D"$qemu -nodefaults $M -cpu $processor $chr_testdev $pci_testde=
v"
-command+=3D" -display none -serial stdio -kernel"
+command+=3D" -display none -serial stdio"
+command+=3D" $VMM_PARAMS"
+command+=3D" -kernel"
 command=3D"$(timeout_cmd) $command"
=20
 run_qemu $command "$@"
diff --git a/powerpc/run b/powerpc/run
index 597ab96ed8a8..b07aa18f26bf 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -23,7 +23,9 @@ fi
 M=3D'-machine pseries'
 M+=3D",accel=3D$ACCEL"
 command=3D"$qemu -nodefaults $M -bios $FIRMWARE"
-command+=3D" -display none -serial stdio -kernel"
+command+=3D" -display none -serial stdio"
+command+=3D" $VMM_PARAMS"
+command+=3D" -kernel"
 command=3D"$(migration_cmd) $(timeout_cmd) $command"
=20
 # powerpc tests currently exit with rtas-poweroff, which exits with 0.
diff --git a/s390x/run b/s390x/run
index 0980504448ce..9bfb95397064 100755
--- a/s390x/run
+++ b/s390x/run
@@ -19,6 +19,7 @@ M=3D'-machine s390-ccw-virtio'
 M+=3D",accel=3D$ACCEL"
 command=3D"$qemu -nodefaults -nographic $M"
 command+=3D" -chardev stdio,id=3Dcon0 -device sclpconsole,chardev=3Dcon0=
"
+command+=3D" $VMM_PARAMS"
 command+=3D" -kernel"
 command=3D"$(timeout_cmd) $command"
=20
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index eb6089091e23..5ea3772d9b2b 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -30,7 +30,9 @@ premature_failure()
 get_cmdline()
 {
     local kernel=3D$1
-    echo "TESTNAME=3D$testname TIMEOUT=3D$timeout ACCEL=3D$accel $RUNTIM=
E_arch_run $kernel -smp $smp $opts"
+
+    # Move VMM_PARAMS to the end to override parameters provided in unit=
tests.cfg:extra_params
+    echo "VMM_PARAMS=3D TESTNAME=3D$testname TIMEOUT=3D$timeout ACCEL=3D=
$accel $RUNTIME_arch_run $kernel -smp $smp $opts $VMM_PARAMS"
 }
=20
 skip_nodefault()
diff --git a/x86/run b/x86/run
index 1ac91f1d880f..3770c16ad4e6 100755
--- a/x86/run
+++ b/x86/run
@@ -38,7 +38,9 @@ else
 fi
=20
 command=3D"${qemu} -nodefaults $pc_testdev -vnc none -serial stdio $pci_=
testdev"
-command+=3D" -machine accel=3D$ACCEL -kernel"
+command+=3D" -machine accel=3D$ACCEL"
+command+=3D" $VMM_PARAMS"
+command+=3D" -kernel"
 command=3D"$(timeout_cmd) $command"
=20
 run_qemu ${command} "$@"
--=20
2.21.1

