Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6578C494E3C
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 13:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243415AbiATMwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 07:52:06 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:41274 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243355AbiATMwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 07:52:06 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0DC231F76A;
        Thu, 20 Jan 2022 12:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642683125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D1rvjO8zoQTpWyFXJxK/RRno3+iqBzwkOLz68cPHvQo=;
        b=QPbhfvtyh7cF8Iqq9eDNeqXPeGOhh09KMQ/c9tsfcw9i+tTPLdU1O15vXSwynbww41de24
        xGEqUt80PpaMlOGnUzfuWP9YpLUaBVtazEszawarKUa3e/VgzYxc6+0yRpIaRKQOg3V6nB
        Ul+4Qt8AeNOh9Dl7aqnN42o+GqjLGyo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7960013EA5;
        Thu, 20 Jan 2022 12:52:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YOpYG/Ra6WGIagAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Thu, 20 Jan 2022 12:52:04 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests 01/13] x86/efi: Allow specifying AMD SEV/SEV-ES guest launch policy
Date:   Thu, 20 Jan 2022 13:51:10 +0100
Message-Id: <20220120125122.4633-2-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220120125122.4633-1-varad.gautam@suse.com>
References: <20220120125122.4633-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make x86/efi/run check for AMDSEV envvar and set SEV/SEV-ES parameters
on the qemu cmdline.

AMDSEV can be set to `sev` or `sev-es`.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/efi/README.md |  5 +++++
 x86/efi/run       | 16 ++++++++++++++++
 2 files changed, 21 insertions(+)

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
index ac368a5..b48f626 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -43,6 +43,21 @@ fi
 mkdir -p "$EFI_CASE_DIR"
 cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
 
+amdsev_opts=
+if [ -n "$AMDSEV" ]; then
+	policy=
+	if [ "$AMDSEV" = "sev" ]; then
+		policy="0x1"
+	elif [ "$AMDSEV" = "sev-es" ]; then
+		policy="0x5"
+	else
+		echo "Cannot set AMDSEV policy. AMDSEV must be one of 'sev', 'sev-es'."
+		exit 2
+	fi
+
+	amdsev_opts="-object sev-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,policy=$policy -machine memory-encryption=sev0"
+fi
+
 # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
 # After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive
 # memory region is ~42MiB. Although this is sufficient for many test cases to
@@ -61,4 +76,5 @@ cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
 	-nographic \
 	-m 256 \
 	"$@" \
+	$amdsev_opts \
 	-smp "$EFI_SMP"
-- 
2.32.0

