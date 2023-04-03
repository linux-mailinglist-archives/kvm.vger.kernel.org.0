Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DAB6D4E44
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbjDCQpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbjDCQo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:44:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83038171E
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680540256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cQH7NZdBwc5o3W8R0BF9R9P2wjienvG35Z70XDeKbk0=;
        b=OUk94t6nreQJWlrKP7SAvTKiyoNyFkVMSHNsVByKHIzatpYmUUVU/xb9HKmFtsfpq2e3on
        uzw74imF4CATs4POpW86Ji9DE+DFqOL6D+LAmEIpskc+6V7cAWNo1aQRFs15WC/IX5ycLu
        kySq6DGwa7A/OSgKq27ds6F5eFqNoKw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-2Kwf7yJtMCOnGcCeoIT-WQ-1; Mon, 03 Apr 2023 12:44:15 -0400
X-MC-Unique: 2Kwf7yJtMCOnGcCeoIT-WQ-1
Received: by mail-ed1-f69.google.com with SMTP id ev6-20020a056402540600b004bc2358ac04so42576897edb.21
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 09:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680540253; x=1683132253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cQH7NZdBwc5o3W8R0BF9R9P2wjienvG35Z70XDeKbk0=;
        b=ODUOyD8mQEdF6mIiC4kAfSi65EJDYFcDSqVc84X0Ckun+XPQOghIG16UTrSWce+h/F
         oWeKYRm2AQPPhraXl/F2ifuH+z4bmMM6xITLR1oT/IzjfZy9irqWBH4fLmGfcgeYXkEz
         cgAntijhifWNYK/zJRjHtLe3Eb0OEkWMaOnH0h0LqXB4NyQAK6MKQrODr0hgL170qYtt
         XpziJHWbLp/e9jwATzT1i2W/WxmJ1ACmXeJ/N3CINmng5AbjuZ8ysPsFjcAOJjMW54aT
         WwRKwdsRx6yifylYCLIXqEXY0XPJ0ZI2FUh6h6mtz1wfGgpOaLL5JEE4ryDju+w0mDaa
         LAvA==
X-Gm-Message-State: AAQBX9dXFpajULllWnVgDwolEQVy0BQMl2o5mTAvaY8LY70vHu5c40vc
        vKTiNtplpSDj+WlBSD8SKI42I2d0WNhWBO9GCVGrk2OfBV0KeTzkcijnT52l6Bcp6ACOTyPX8tK
        oewTKglIHbooQIqdOZazHfumuVPJ4XwRM7RdmGfOumgnFxnLaFUQizRgzlxcHILqRMoHhgywZss
        0=
X-Received: by 2002:a05:6402:205c:b0:500:2a15:f86b with SMTP id bc28-20020a056402205c00b005002a15f86bmr32496041edb.42.1680540253405;
        Mon, 03 Apr 2023 09:44:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350bQ8O1V6kMo5z9y+ZaeRP/lKF/88pLHk4LuteJCLM10Wn9xYOOFpKYN9Yq+m3Oibgp3s+HtDw==
X-Received: by 2002:a05:6402:205c:b0:500:2a15:f86b with SMTP id bc28-20020a056402205c00b005002a15f86bmr32496027edb.42.1680540253061;
        Mon, 03 Apr 2023 09:44:13 -0700 (PDT)
Received: from [192.168.10.118] ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.gmail.com with ESMTPSA id dn25-20020a05640222f900b004be11e97ca2sm4729395edb.90.2023.04.03.09.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 09:44:12 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, Thomas Huth <thuth@redhat.com>
Subject: [PATCH kvm-unit-tests v2] memory: Skip tests for instructions that are absent
Date:   Mon,  3 Apr 2023 18:44:11 +0200
Message-Id: <20230403164411.388475-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Checking that instructions are absent is broken when running with CPU
models other than the bare metal processor's, because neither VMX nor SVM have
intercept controls for the instructions.

This can even happen with "-cpu max" when running under nested
virtualization, which is the current situation in the Fedora KVM job
on Cirrus-CI:

FAIL: clflushopt (ABSENT)
FAIL: clwb (ABSENT)

In other words it looks like the features have been marked as disabled
in the L0 host, while the hardware supports them.

Reported-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/memory.c | 83 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 34 deletions(-)

diff --git a/x86/memory.c b/x86/memory.c
index 351e7c0..58ef835 100644
--- a/x86/memory.c
+++ b/x86/memory.c
@@ -25,53 +25,68 @@ static void handle_ud(struct ex_regs *regs)
 
 int main(int ac, char **av)
 {
-	int expected;
-
 	handle_exception(UD_VECTOR, handle_ud);
 
 	/* 3-byte instructions: */
 	isize = 3;
 
-	expected = !this_cpu_has(X86_FEATURE_CLFLUSH); /* CLFLUSH */
-	ud = 0;
-	asm volatile("clflush (%0)" : : "b" (&target));
-	report(ud == expected, "clflush (%s)", expected ? "ABSENT" : "present");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH)) { /* CLFLUSH */
+		ud = 0;
+		asm volatile("clflush (%0)" : : "b" (&target));
+		report(!ud, "clflush");
+	} else {
+		report_skip("clflush");
+	}
 
-	expected = !this_cpu_has(X86_FEATURE_XMM); /* SSE */
-	ud = 0;
-	asm volatile("sfence");
-	report(ud == expected, "sfence (%s)", expected ? "ABSENT" : "present");
+	if (this_cpu_has(X86_FEATURE_XMM)) { /* SSE */
+		ud = 0;
+		asm volatile("sfence");
+		report(!ud, "sfence");
+	} else {
+		report_skip("sfence");
+	}
 
-	expected = !this_cpu_has(X86_FEATURE_XMM2); /* SSE2 */
-	ud = 0;
-	asm volatile("lfence");
-	report(ud == expected, "lfence (%s)", expected ? "ABSENT" : "present");
-
-	ud = 0;
-	asm volatile("mfence");
-	report(ud == expected, "mfence (%s)", expected ? "ABSENT" : "present");
+	if (this_cpu_has(X86_FEATURE_XMM2)) { /* SSE2 */
+		ud = 0;
+		asm volatile("lfence");
+		report(!ud, "lfence");
+		ud = 0;
+		asm volatile("mfence");
+		report(!ud, "mfence");
+	} else {
+		report_skip("lfence");
+		report_skip("mfence");
+	}
 
 	/* 4-byte instructions: */
 	isize = 4;
 
-	expected = !this_cpu_has(X86_FEATURE_CLFLUSHOPT); /* CLFLUSHOPT */
-	ud = 0;
-	/* clflushopt (%rbx): */
-	asm volatile(".byte 0x66, 0x0f, 0xae, 0x3b" : : "b" (&target));
-	report(ud == expected, "clflushopt (%s)",
-	       expected ? "ABSENT" : "present");
+	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT)) { /* CLFLUSHOPT */
+		ud = 0;
+		/* clflushopt (%rbx): */
+		asm volatile(".byte 0x66, 0x0f, 0xae, 0x3b" : : "b" (&target));
+		report(!ud, "clflushopt");
+	} else {
+		report_skip("clflushopt");
+	}
 
-	expected = !this_cpu_has(X86_FEATURE_CLWB); /* CLWB */
-	ud = 0;
-	/* clwb (%rbx): */
-	asm volatile(".byte 0x66, 0x0f, 0xae, 0x33" : : "b" (&target));
-	report(ud == expected, "clwb (%s)", expected ? "ABSENT" : "present");
+	if (this_cpu_has(X86_FEATURE_CLWB)) { /* CLWB */
+		ud = 0;
+		/* clwb (%rbx): */
+		asm volatile(".byte 0x66, 0x0f, 0xae, 0x33" : : "b" (&target));
+		report(!ud, "clwb");
+	} else {
+		report_skip("clwb");
+	}
 
-	expected = !this_cpu_has(X86_FEATURE_PCOMMIT); /* PCOMMIT */
-	ud = 0;
-	/* pcommit: */
-	asm volatile(".byte 0x66, 0x0f, 0xae, 0xf8");
-	report(ud == expected, "pcommit (%s)", expected ? "ABSENT" : "present");
+	if (this_cpu_has(X86_FEATURE_PCOMMIT)) { /* PCOMMIT */
+		ud = 0;
+		/* pcommit: */
+		asm volatile(".byte 0x66, 0x0f, 0xae, 0xf8");
+		report(!ud, "pcommit");
+	} else {
+		report_skip("pcommit");
+	}
 
 	return report_summary();
 }
-- 
2.39.2

