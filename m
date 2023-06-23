Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B1D73AF38
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 05:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjFWD7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 23:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjFWD7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 23:59:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4050C2107
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 20:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687492707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1Jw0fxPjyDd3EMRjg7zdWLE38Oq7lDTXR6UHZeyuiLE=;
        b=Y9UCealu5ecSfCkOxvJwRoniE9uoYEmNYavDLbxgDF2cAnkOea3bAhP2so/rNNL6NNyokL
        +mUm+iGGatFREv5263ega07Q0Gr8lwxvIiTvvKPt8n31360YkKIZDiTTOzbKa3J54EnUyW
        J383hJeWETrOJgguyRtUFe2FZf4xhkk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-YqK7BijpPQWfF7Nh8rFzZw-1; Thu, 22 Jun 2023 23:58:23 -0400
X-MC-Unique: YqK7BijpPQWfF7Nh8rFzZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B68203C025D2;
        Fri, 23 Jun 2023 03:58:22 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-33.bne.redhat.com [10.64.54.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E2F44440CB;
        Fri, 23 Jun 2023 03:58:17 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org, andrew.jones@linux.dev,
        lvivier@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, pbonzini@redhat.com,
        nrb@linux.ibm.com, shan.gavin@gmail.com
Subject: [kvm-unit-tests PATCH v4] runtime: Allow to specify properties for accelerator
Date:   Fri, 23 Jun 2023 13:57:50 +1000
Message-Id: <20230623035750.312679-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are extra properties for accelerators to enable the specific
features. For example, the dirty ring for KVM accelerator can be
enabled by "-accel kvm,dirty-ring-size=65536". Unfortuntely, the
extra properties for the accelerators aren't supported. It makes
it's impossible to test the combination of KVM and dirty ring
as the following error message indicates.

  # cd /home/gavin/sandbox/kvm-unit-tests/tests
  # QEMU=/home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
    ACCEL=kvm,dirty-ring-size=65536 ./its-migration
     :
  BUILD_HEAD=2fffb37e
  timeout -k 1s --foreground 90s                                 \
  /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64        \
  -nodefaults -machine virt -accel kvm,dirty-ring-size=65536     \
  -cpu cortex-a57 -device virtio-serial-device                   \
  -device virtconsole,chardev=ctd -chardev testdev,id=ctd        \
  -device pci-testdev -display none -serial stdio                \
  -kernel _NO_FILE_4Uhere_ -smp 160 -machine gic-version=3       \
  -append its-pending-migration # -initrd /tmp/tmp.gfDLa1EtWk
     :
  qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0):
  Invalid argument

Allow to specify extra properties for accelerators. With this, the
"its-migration" can be tested for the combination of KVM and dirty
ring. Rename get_qemu_accelerator() to set_qemu_accelerator() since
no values are returned by printing at return.

Signed-off-by: Gavin Shan <gshan@redhat.com>
Tested-by: Nico Boehr <nrb@linux.ibm.com>
Acked-by: Nico Boehr <nrb@linux.ibm.com>
---
v4: Rename get_qemu_accelerator() to set_qemu_accelerator() and
    don't break the fix included in commit c7d6c7f00e7c by setting
    $ACCEL to "tcg" before set_qemu_accelerator() is called, suggested
    by Drew.
---
 arm/run               | 20 ++++++++------------
 powerpc/run           |  5 ++---
 s390x/run             |  5 ++---
 scripts/arch-run.bash | 23 ++++++++++++++---------
 x86/run               |  5 ++---
 5 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/arm/run b/arm/run
index c6f25b8..956940f 100755
--- a/arm/run
+++ b/arm/run
@@ -10,24 +10,20 @@ if [ -z "$KUT_STANDALONE" ]; then
 fi
 processor="$PROCESSOR"
 
-accel=$(get_qemu_accelerator) ||
-	exit $?
+if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
+   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
+   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
+	ACCEL="tcg"
+fi
 
-if [ "$accel" = "kvm" ]; then
+set_qemu_accelerator || exit $?
+if [ "$ACCEL" = "kvm" ]; then
 	QEMU_ARCH=$HOST
 fi
 
 qemu=$(search_qemu_binary) ||
 	exit $?
 
-if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
-   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
-   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
-	accel=tcg
-fi
-
-ACCEL=$accel
-
 if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
 	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
 	exit 2
@@ -72,7 +68,7 @@ if $qemu $M -device '?' | grep -q pci-testdev; then
 	pci_testdev="-device pci-testdev"
 fi
 
-A="-accel $ACCEL"
+A="-accel $ACCEL$ACCEL_PROPS"
 command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
 command+=" -display none -serial stdio -kernel"
 command="$(migration_cmd) $(timeout_cmd) $command"
diff --git a/powerpc/run b/powerpc/run
index ee38e07..b353169 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -9,8 +9,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source scripts/arch-run.bash
 fi
 
-ACCEL=$(get_qemu_accelerator) ||
-	exit $?
+set_qemu_accelerator || exit $?
 
 qemu=$(search_qemu_binary) ||
 	exit $?
@@ -21,7 +20,7 @@ if ! $qemu -machine '?' 2>&1 | grep 'pseries' > /dev/null; then
 fi
 
 M='-machine pseries'
-M+=",accel=$ACCEL"
+M+=",accel=$ACCEL$ACCEL_PROPS"
 command="$qemu -nodefaults $M -bios $FIRMWARE"
 command+=" -display none -serial stdio -kernel"
 command="$(migration_cmd) $(timeout_cmd) $command"
diff --git a/s390x/run b/s390x/run
index f1111db..dcbf3f0 100755
--- a/s390x/run
+++ b/s390x/run
@@ -9,8 +9,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source scripts/arch-run.bash
 fi
 
-ACCEL=$(get_qemu_accelerator) ||
-	exit $?
+set_qemu_accelerator || exit $?
 
 qemu=$(search_qemu_binary) ||
 	exit $?
@@ -26,7 +25,7 @@ if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ] && [ "$MIGRATION"
 fi
 
 M='-machine s390-ccw-virtio'
-M+=",accel=$ACCEL"
+M+=",accel=$ACCEL$ACCEL_PROPS"
 command="$qemu -nodefaults -nographic $M"
 command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
 command+=" -kernel"
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 51e4b97..2d28e0b 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -410,8 +410,11 @@ hvf_available ()
 		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
 }
 
-get_qemu_accelerator ()
+set_qemu_accelerator ()
 {
+	ACCEL_PROPS=${ACCEL#"${ACCEL%%,*}"}
+	ACCEL=${ACCEL%%,*}
+
 	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
 		echo "KVM is needed, but not available on this host" >&2
 		return 2
@@ -421,13 +424,15 @@ get_qemu_accelerator ()
 		return 2
 	fi
 
-	if [ "$ACCEL" ]; then
-		echo $ACCEL
-	elif kvm_available; then
-		echo kvm
-	elif hvf_available; then
-		echo hvf
-	else
-		echo tcg
+	if [ -z "$ACCEL" ]; then
+		if kvm_available; then
+			ACCEL="kvm"
+		elif hvf_available; then
+			ACCEL="hvf"
+		else
+			ACCEL="tcg"
+		fi
 	fi
+
+	return 0
 }
diff --git a/x86/run b/x86/run
index 4d53b72..a3d3e7d 100755
--- a/x86/run
+++ b/x86/run
@@ -9,8 +9,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source scripts/arch-run.bash
 fi
 
-ACCEL=$(get_qemu_accelerator) ||
-	exit $?
+set_qemu_accelerator || exit $?
 
 qemu=$(search_qemu_binary) ||
 	exit $?
@@ -38,7 +37,7 @@ else
 fi
 
 command="${qemu} --no-reboot -nodefaults $pc_testdev -vnc none -serial stdio $pci_testdev"
-command+=" -machine accel=$ACCEL"
+command+=" -machine accel=$ACCEL$ACCEL_PROPS"
 if [ "${CONFIG_EFI}" != y ]; then
 	command+=" -kernel"
 fi
-- 
2.40.1

