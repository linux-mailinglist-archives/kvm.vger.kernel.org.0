Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1A172C32B
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 13:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbjFLLjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 07:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjFLLiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 07:38:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8855461BD
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 04:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686569110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SDTcsG0aKECYSCw6frb1v3Y9aLT/hdvMgzOOCya5nPI=;
        b=HDlDMzG6eREtOURwnY7UQdQh5xBovSEQ1GL/SuosIoKyKT20DCSGwhWZtAtbAH2uvi1kmE
        uCeOU+DckLY87Cgxg9/LdyEZCuq4xwyPSwjNjAXIV3nDVf7BfTgvze5V/dVVK0tyl67NWj
        7mSAfMsZja/42emiFKKJePp0j7tRSWw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-BPKGNHukOVi10Sbgz4PQnQ-1; Mon, 12 Jun 2023 07:25:07 -0400
X-MC-Unique: BPKGNHukOVi10Sbgz4PQnQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B3953849525;
        Mon, 12 Jun 2023 11:25:07 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-97.bne.redhat.com [10.64.54.97])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 770D92907;
        Mon, 12 Jun 2023 11:25:04 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, andrew.jones@linux.dev, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com,
        shan.gavin@gmail.com
Subject: [PATCH v2] runtime: Allow to specify properties for accelerator
Date:   Mon, 12 Jun 2023 21:24:59 +1000
Message-Id: <20230612112459.597882-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
v2: Only tested on aarch64. Split accelerator and its properties in
    function get_qemu_accelerator() suggested by Drew
---
 arm/run               | 12 ++++++------
 powerpc/run           |  6 ++++--
 s390x/run             |  6 ++++--
 scripts/arch-run.bash | 27 +++++++++++++++++----------
 x86/run               |  6 ++++--
 5 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/arm/run b/arm/run
index c6f25b8..80ffd39 100755
--- a/arm/run
+++ b/arm/run
@@ -10,10 +10,12 @@ if [ -z "$KUT_STANDALONE" ]; then
 fi
 processor="$PROCESSOR"
 
-accel=$(get_qemu_accelerator) ||
+accel_list=($(get_qemu_accelerator)) ||
 	exit $?
+ACCEL=${accel_list[0]}
+ACCEL_PROPS=${accel_list[1]}
 
-if [ "$accel" = "kvm" ]; then
+if [ "$ACCEL" = "kvm" ]; then
 	QEMU_ARCH=$HOST
 fi
 
@@ -23,11 +25,9 @@ qemu=$(search_qemu_binary) ||
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
@@ -72,7 +72,7 @@ if $qemu $M -device '?' | grep -q pci-testdev; then
 	pci_testdev="-device pci-testdev"
 fi
 
-A="-accel $ACCEL"
+A="-accel $ACCEL$ACCEL_PROPS"
 command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
 command+=" -display none -serial stdio -kernel"
 command="$(migration_cmd) $(timeout_cmd) $command"
diff --git a/powerpc/run b/powerpc/run
index ee38e07..8aa000b 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -9,8 +9,10 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source scripts/arch-run.bash
 fi
 
-ACCEL=$(get_qemu_accelerator) ||
+accel_list=($(get_qemu_accelerator)) ||
 	exit $?
+ACCEL=${accel_list[0]}
+ACCEL_PROPS=${accel_list[1]}
 
 qemu=$(search_qemu_binary) ||
 	exit $?
@@ -21,7 +23,7 @@ if ! $qemu -machine '?' 2>&1 | grep 'pseries' > /dev/null; then
 fi
 
 M='-machine pseries'
-M+=",accel=$ACCEL"
+M+=",accel=$ACCEL$ACCEL_PROPS"
 command="$qemu -nodefaults $M -bios $FIRMWARE"
 command+=" -display none -serial stdio -kernel"
 command="$(migration_cmd) $(timeout_cmd) $command"
diff --git a/s390x/run b/s390x/run
index f1111db..e5d23db 100755
--- a/s390x/run
+++ b/s390x/run
@@ -9,8 +9,10 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source scripts/arch-run.bash
 fi
 
-ACCEL=$(get_qemu_accelerator) ||
+accel_list=($(get_qemu_accelerator)) ||
 	exit $?
+ACCEL=${accel_list[0]}
+ACCEL_PROPS=${accel_list[1]}
 
 qemu=$(search_qemu_binary) ||
 	exit $?
@@ -26,7 +28,7 @@ if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ] && [ "$MIGRATION"
 fi
 
 M='-machine s390-ccw-virtio'
-M+=",accel=$ACCEL"
+M+=",accel=$ACCEL$ACCEL_PROPS"
 command="$qemu -nodefaults -nographic $M"
 command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
 command+=" -kernel"
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 51e4b97..12dabf9 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -412,22 +412,29 @@ hvf_available ()
 
 get_qemu_accelerator ()
 {
-	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
+	local accel_list
+
+	accel_list[0]=${ACCEL%%,*}
+	accel_list[1]=${ACCEL#"${accel_list[0]}"}
+
+	if [ "${accel_list[0]}" = "kvm" ] && ! kvm_available; then
 		echo "KVM is needed, but not available on this host" >&2
 		return 2
 	fi
-	if [ "$ACCEL" = "hvf" ] && ! hvf_available; then
+	if [ "${accel_list[0]}" = "hvf" ] && ! hvf_available; then
 		echo "HVF is needed, but not available on this host" >&2
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
+	if [ ! -n "${accel_list[0]}" ]; then
+		if kvm_available; then
+			accel_list[0]="kvm"
+		elif hvf_available; then
+			accel_list[0]="hvf"
+		else
+			accel_list[0]="tcg"
+		fi
 	fi
+
+	echo ${accel_list[*]}
 }
diff --git a/x86/run b/x86/run
index 4d53b72..f0b0b4a 100755
--- a/x86/run
+++ b/x86/run
@@ -9,8 +9,10 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source scripts/arch-run.bash
 fi
 
-ACCEL=$(get_qemu_accelerator) ||
+accel_list=($(get_qemu_accelerator)) ||
 	exit $?
+ACCEL=${accel_list[0]}
+ACCEL_PROPS=${accel_list[1]}
 
 qemu=$(search_qemu_binary) ||
 	exit $?
@@ -38,7 +40,7 @@ else
 fi
 
 command="${qemu} --no-reboot -nodefaults $pc_testdev -vnc none -serial stdio $pci_testdev"
-command+=" -machine accel=$ACCEL"
+command+=" -machine accel=$ACCEL$ACCEL_PROPS"
 if [ "${CONFIG_EFI}" != y ]; then
 	command+=" -kernel"
 fi
-- 
2.23.0

