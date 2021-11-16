Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FAD453B1F
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhKPUoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhKPUoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:44:05 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B72EC061767
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:41:08 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so3300687pja.1
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cLHNLQQhiR0+HDVMn8nTLasPvOuAmrrT3cWHezBkp04=;
        b=nH5FQ0odZRZ+CJYhCL8GzOogZssH+vnCc2HC/8oI8qb7/nGa1pWp/7YZqDLb5dKpgC
         hSzg4n2un5i1ZbZIW6z0/2takLDkIn6prIhRUeFGO36PFHu/Df/eEkKlfm1IiIgtQXFJ
         85bsU5ECmrnvHDjLG2MkPXG4CT76XVcAszOdBkJwULv7bl1mw5A5CpPg/nDjNFPPwm4i
         67ZeY4PCWxABCO/X24R66VApCFE+SqNncAkrKA1hq74420xS2LgVLXYJsrjLwDKoEuUl
         XIBkrScKKOJLdeFwgIr13JDogsIdEeokgBZ5jU5UUYBGEfYsAos8kHFYG4ZZtFaRsBxn
         r6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cLHNLQQhiR0+HDVMn8nTLasPvOuAmrrT3cWHezBkp04=;
        b=RZlLZJ4gBTl0psKgSif5PYGvIJkJ/ymRQm+Kb3bJJc8HV14ThP1a8HZMVx6a0GNADk
         YjbF+kXAc99H4teMvZQ+QEJJtOIHl+1rkBZIKi3ap81mWc7Xhx4cFG1o87HOF8VBM7uo
         7TwOmOAW8D8yWzPER5LxXQABvjdlJG0Gid3HMQP9ExVpwyxCTug5BnD/fdb6W6SkjuEf
         3ixcpSYGNvY1oywuaB7Wk2gf9b/cJAp8NltdPLufNy15SqGmNkCrailI7C69J8eoMd54
         VH+bNy8ep5glqKs2CxJAAzO4NnTQyqwyvigTPTADrYf2QnFAdMoKFlUpasbNdgGb3u6t
         /L8A==
X-Gm-Message-State: AOAM530qSNNMkIAcWyIiTjU6DRis2llmJk/pn1OmKN+c4Hu0EsmCq1ty
        3vN2lANHuVAq6zEDnauCU6AshOQup2zRXg==
X-Google-Smtp-Source: ABdhPJxGGwApjCXYg0BikzKNPf/3WrivKzO0fMInBKGNCUoHEA9Q6MJLpQ2TMBrS48xSSeFBYy9TZQ==
X-Received: by 2002:a17:903:410b:b0:142:497b:7209 with SMTP id r11-20020a170903410b00b00142497b7209mr49191732pld.9.1637095267548;
        Tue, 16 Nov 2021 12:41:07 -0800 (PST)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id lp12sm3652359pjb.24.2021.11.16.12.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 12:41:07 -0800 (PST)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v2 10/10] x86 UEFI: Make _NO_FILE_4Uhere_ work w/ BOOTX64.EFI
Date:   Tue, 16 Nov 2021 12:40:53 -0800
Message-Id: <20211116204053.220523-11-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116204053.220523-1-zxwang42@gmail.com>
References: <20211116204053.220523-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Orr <marcorr@google.com>

The `_NO_FILE_4Uhere_` test case is used by the runner scripts to verify
QEMU's configuration. Make it work with EFI/BOOT/BOOTX64.EFI by compling
a minimal EFI binary, called dummy.c that returns immediately.

Signed-off-by: Marc Orr <marcorr@google.com>
---
 scripts/runtime.bash |  2 +-
 x86/efi/run          | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 228a207..bb89a53 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -132,7 +132,7 @@ function run()
 
     last_line=$(premature_failure > >(tail -1)) && {
         skip=true
-        if [ "${TARGET_EFI}" == "y" ] && [[ "${last_line}" =~ "Reset" ]]; then
+        if [ "${TARGET_EFI}" == "y" ] && [[ "${last_line}" =~ "enabling apic" ]]; then
             skip=false
         fi
         if [ ${skip} == true ]; then
diff --git a/x86/efi/run b/x86/efi/run
index a888979..834cd90 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -39,6 +39,18 @@ shift 1
 mkdir -p "$EFI_CASE_DIR"
 if [ "$EFI_CASE" != "_NO_FILE_4Uhere_" ]; then
 	cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
+else
+	if ! [ -f "$EFI_CASE_BINARY" ]; then
+		cat <<EOF >$EFI_SRC/efi/dummy.c
+int main(int argc, char **argv)
+{
+	return 0;
+}
+EOF
+		make "$EFI_SRC/efi/dummy.efi"
+		cp "$EFI_SRC/efi/dummy.efi" "$EFI_CASE_BINARY"
+		rm -f $EFI_SRC/efi/dummy*
+	fi
 fi
 
 # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
-- 
2.33.0

