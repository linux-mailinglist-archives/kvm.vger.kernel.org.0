Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513BD4AF70D
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 17:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbiBIQnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 11:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiBIQnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 11:43:32 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845E0C0613C9
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 08:43:35 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 157A121107;
        Wed,  9 Feb 2022 16:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644425014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=WOJuf80urs5no18O+t0VxCeay6qVLC3ryVSG8Z8C/NA=;
        b=VUkeQR0kq+lnBkAurXvs/VG7eB5Vvl160SkPW4VGr5ZQmeVZdOgiMlmDtqBIGfVNNj+/6Y
        9WZq6TTQKYtqO5E2DYoLOSs/kd2jFYOSjY5Rk27yxv8lBLVocHepkqMdWbJMD9GIXaerC0
        tWGYUgbxyvSs09NsNgm17fIX/to/Mcc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7D47113D4F;
        Wed,  9 Feb 2022 16:43:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nCvNGzXvA2J0NgAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Wed, 09 Feb 2022 16:43:33 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v2] x86/efi: Allow specifying AMD SEV/SEV-ES guest launch policy to run
Date:   Wed,  9 Feb 2022 17:42:54 +0100
Message-Id: <20220209164254.8664-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make x86/efi/run check for AMDSEV envvar and set corresponding
SEV/SEV-ES parameters on the qemu cmdline, to make it convenient
to launch SEV/SEV-ES tests.

Since the C-bit position depends on the runtime host, fetch it
via cpuid before guest launch.

AMDSEV can be set to `sev` or `sev-es`.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/efi/README.md |  5 +++++
 x86/efi/run       | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/x86/efi/README.md b/x86/efi/README.md
index a39f509..1222b30 100644
--- a/x86/efi/README.md
+++ b/x86/efi/README.md
@@ -30,6 +30,11 @@ the env variable `EFI_UEFI`:
 
     EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/msr.efi
 
+To run the tests under AMD SEV/SEV-ES, set env variable `AMDSEV=sev` or
+`AMDSEV=sev-es`. This adds the desired guest policy to qemu command line.
+
+    AMDSEV=sev-es EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/amd_sev.efi
+
 ## Code structure
 
 ### Code from GNU-EFI
diff --git a/x86/efi/run b/x86/efi/run
index ac368a5..9bf0dc8 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -43,6 +43,43 @@ fi
 mkdir -p "$EFI_CASE_DIR"
 cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
 
+amdsev_opts=
+if [ -n "$AMDSEV" ]; then
+	# Guest policy bits, used to form QEMU command line.
+	readonly AMDSEV_POLICY_NODBG=$(( 1 << 0 ))
+	readonly AMDSEV_POLICY_ES=$(( 1 << 2 ))
+
+	gcc -x c -o getcbitpos - <<EOF
+	/* CPUID Fn8000_001F_EBX bits 5:0 */
+	int get_cbit_pos(void)
+	{
+		int ebx;
+		__asm__("mov \$0x8000001f , %eax\n\t");
+		__asm__("cpuid\n\t");
+		__asm__("mov %%ebx, %0\n\t":"=r" (ebx));
+		return (ebx & 0x3f);
+	}
+	int main(void)
+	{
+		return get_cbit_pos();
+	}
+EOF
+
+	cbitpos=$(./getcbitpos ; echo $?) || rm ./getcbitpos
+	policy=
+	if [ "$AMDSEV" = "sev" ]; then
+		policy="$(( $AMDSEV_POLICY_NODBG ))"
+	elif [ "$AMDSEV" = "sev-es" ]; then
+		policy="$(( $AMDSEV_POLICY_NODBG | $AMDSEV_POLICY_ES ))"
+	else
+		echo "Cannot set AMDSEV policy. AMDSEV must be one of 'sev', 'sev-es'."
+		exit 2
+	fi
+
+	amdsev_opts="-object sev-guest,id=sev0,cbitpos=${cbitpos},reduced-phys-bits=1,policy=${policy} \
+		     -machine memory-encryption=sev0"
+fi
+
 # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
 # After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive
 # memory region is ~42MiB. Although this is sufficient for many test cases to
@@ -61,4 +98,5 @@ cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
 	-nographic \
 	-m 256 \
 	"$@" \
+	$amdsev_opts \
 	-smp "$EFI_SMP"
-- 
2.34.1

