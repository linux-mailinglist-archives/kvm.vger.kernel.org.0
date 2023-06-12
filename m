Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11CB72B72D
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbjFLFIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 01:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjFLFIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 01:08:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89762FB
        for <kvm@vger.kernel.org>; Sun, 11 Jun 2023 22:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686546442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2KwLEKyk3OHL6JZRSL3mC7Y+rJWSx7IrBJpbK44Gq+g=;
        b=ExKa6jwTBvnSyO5DcJ5tFf+05DeuGcsMecufte/Y2mTdxq+FfWR47PBGy42istyx4bC4NM
        2SGwfcMCMhLFFGiMlWzQCLjKZTNmL8aQ5p39f6vw2ImRoeIRDbreOnr4875W5J0QTVxehT
        Ntq1xgirrfcFDBNE8CLMA1N4UlKWY4Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-Prprt-4aOf-o61__KKOBLg-1; Mon, 12 Jun 2023 01:07:18 -0400
X-MC-Unique: Prprt-4aOf-o61__KKOBLg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3285E3C01C15;
        Mon, 12 Jun 2023 05:07:18 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-97.bne.redhat.com [10.64.54.97])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DF13167EE;
        Mon, 12 Jun 2023 05:07:14 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        andrew.jones@linux.dev, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com,
        shan.gavin@gmail.com
Subject: [kvm-unit-tests PATCH] runtime: Allow to specify properties for accelerator
Date:   Mon, 12 Jun 2023 15:07:08 +1000
Message-Id: <20230612050708.584111-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arm/run               | 4 ++--
 scripts/arch-run.bash | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arm/run b/arm/run
index c6f25b8..bbf80e0 100755
--- a/arm/run
+++ b/arm/run
@@ -35,13 +35,13 @@ fi
 
 M='-machine virt'
 
-if [ "$ACCEL" = "kvm" ]; then
+if [[ "$ACCEL" =~ ^kvm.* ]]; then
 	if $qemu $M,\? | grep -q gic-version; then
 		M+=',gic-version=host'
 	fi
 fi
 
-if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
+if [[ "$ACCEL" =~ ^kvm.* ]] || [[ "$ACCEL" =~ ^hvf.* ]]; then
 	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
 		processor="host"
 		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 51e4b97..e20b965 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -412,11 +412,11 @@ hvf_available ()
 
 get_qemu_accelerator ()
 {
-	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
+	if [[ "$ACCEL" =~ ^kvm.* ]] && [[ ! kvm_available ]]; then
 		echo "KVM is needed, but not available on this host" >&2
 		return 2
 	fi
-	if [ "$ACCEL" = "hvf" ] && ! hvf_available; then
+	if [[ "$ACCEL" =~ ^hvf.* ]] && [[ ! hvf_available ]]; then
 		echo "HVF is needed, but not available on this host" >&2
 		return 2
 	fi
-- 
2.23.0

