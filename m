Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C047730F37
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 08:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243585AbjFOGWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 02:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243493AbjFOGWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 02:22:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071131FDA
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 23:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686810122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1Jdp2Dt66ASZ0j6UJlOPexywjJsI21/1kai5Bt5vA3Q=;
        b=HNv2lkNUouw6TkSxUjzFFYrssUthZ6usZU3seZbqcnTHHW4VA2UBvRdMGcg41NkoS09wkg
        J+m4MfNM6EoU0rLk8ncjglTKWloQmnNShbmo9XJObISZfXO/2E23M9xKrxlbKteCGkNX9V
        MZ+7MIlamFhyMplFr6zgWj4wSjQibMA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-0OugQtqSP-aWHUMc0XuZHg-1; Thu, 15 Jun 2023 02:21:58 -0400
X-MC-Unique: 0OugQtqSP-aWHUMc0XuZHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38B3E101A528;
        Thu, 15 Jun 2023 06:21:58 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-145.bne.redhat.com [10.64.54.145])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 73E5F2026D49;
        Thu, 15 Jun 2023 06:21:53 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org, andrew.jones@linux.dev,
        lvivier@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, pbonzini@redhat.com,
        nrb@linux.ibm.com, shan.gavin@gmail.com
Subject: [kvm-unit-tests PATCH v3] runtime: Allow to specify properties for accelerator
Date:   Thu, 15 Jun 2023 16:21:48 +1000
Message-Id: <20230615062148.19883-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
  timeout -k 1s --foreground 90s /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
  -nodefaults -machine virt -accel kvm,dirty-ring-size=65536 -cpu cortex-a57             \
  -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd   \
  -device pci-testdev -display none -serial stdio -kernel _NO_FILE_4Uhere_ -smp 160      \
  -machine gic-version=3 -append its-pending-migration # -initrd /tmp/tmp.gfDLa1EtWk
  qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument

Allow to specify extra properties for accelerators. With this, the
"its-migration" can be tested for the combination of KVM and dirty
ring.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
v3: Split $ACCEL to $ACCEL and $ACCEL_PROPS in get_qemu_accelerator()
    and don't print them as output, suggested by Drew.
---
 arm/run               | 12 ++++--------
 powerpc/run           |  5 ++---
 s390x/run             |  5 ++---
 scripts/arch-run.bash | 21 +++++++++++++--------
 x86/run               |  5 ++---
 5 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/arm/run b/arm/run
index c6f25b8..d9ebe59 100755
--- a/arm/run
+++ b/arm/run
@@ -10,10 +10,8 @@ if [ -z "$KUT_STANDALONE" ]; then
 fi
 processor="$PROCESSOR"
 
-accel=$(get_qemu_accelerator) ||
-	exit $?
-
-if [ "$accel" = "kvm" ]; then
+get_qemu_accelerator || exit $?
+if [ "$ACCEL" = "kvm" ]; then
 	QEMU_ARCH=$HOST
 fi
 
@@ -23,11 +21,9 @@ qemu=$(search_qemu_binary) ||
 if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
    [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
    [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
-	accel=tcg
+	ACCEL="tcg"
 fi
 
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
index ee38e07..3988e72 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -9,8 +9,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source scripts/arch-run.bash
 fi
 
-ACCEL=$(get_qemu_accelerator) ||
-	exit $?
+get_qemu_accelerator || exit $?
 
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
index f1111db..c57862f 100755
--- a/s390x/run
+++ b/s390x/run
@@ -9,8 +9,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source scripts/arch-run.bash
 fi
 
-ACCEL=$(get_qemu_accelerator) ||
-	exit $?
+get_qemu_accelerator || exit $?
 
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
index 51e4b97..19c16c1 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -412,6 +412,9 @@ hvf_available ()
 
 get_qemu_accelerator ()
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
index 4d53b72..9a10703 100755
--- a/x86/run
+++ b/x86/run
@@ -9,8 +9,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source scripts/arch-run.bash
 fi
 
-ACCEL=$(get_qemu_accelerator) ||
-	exit $?
+get_qemu_accelerator || exit $?
 
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

