Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316616D4DE1
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjDCQcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjDCQcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:32:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F252D70
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680539452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MPS0a9q2wBgWzoVXK25wx68oYQt4CXIzgrAFBuym3Gg=;
        b=Brx+GsAJ3u2TxV4M/VUIJLVBpu7F3FzkhMvEIBTHhEwbEfe3fPMP/jQ/BOy1C1m9UZFvxz
        i6OUbd4DBArdh91WnFIph4OC9lZBiFGsBWYsiK1qNZm0T4WO4L4LdD7zRjpt68kD7c+gEF
        E+SLteGj+vW/tb/4TQtHCTiDpSi3N40=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-M-rsmh8aMwKoaC_f74ABvw-1; Mon, 03 Apr 2023 12:30:51 -0400
X-MC-Unique: M-rsmh8aMwKoaC_f74ABvw-1
Received: by mail-ed1-f70.google.com with SMTP id ev6-20020a056402540600b004bc2358ac04so42528809edb.21
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 09:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680539449; x=1683131449;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MPS0a9q2wBgWzoVXK25wx68oYQt4CXIzgrAFBuym3Gg=;
        b=a39TLqoNW9oA9JYFw8gxE4Vh5IkEg1BcczTnXSarRd7BiG4vKqJ1NVgBkxZA7XVdME
         96riFZ4xw46A/twtYhoNGPFJkWaxbGYvctLzptHbqFILUpiDH0VhvutOc2/iccJ3CQ4I
         P7tgY29Gd1ew4bSuVZeV+lUxwaqCnzoONd8Dg0iLb081GX1vOchF3D/Z/Fech1dctDMS
         D+MC/xN87xmMZrv4ToL4i63TW1AmKNbmsZ5p1gxvPvuRdAsQNhU3FOBRifLJCQNbiV4B
         2HIqEkvQ+Z5Xy4n68h0U02gxwXV7LOzAGDxItaHAQNumpjgB3mvq4EHRm/fEcDbRFDHH
         lReQ==
X-Gm-Message-State: AAQBX9dWbkvJ810OmY3FnXkaxioT0cYH7RIOZdBi3w66hIpNxqtTVnqs
        ggdXmPcBL8JUb0MravqmsD/hCe0/p4Brz76ftxoSdGFLoF4h2cpx+yYyxMmMPSXdp/5StDf6XL7
        9hXzo78V/LVBj/oapgDl4bFvAX+dt6l/SgATgp4CbxjgTPG0vqPI81nw7ol2RbIc6z/UjMgj0Z+
        4=
X-Received: by 2002:a17:906:2990:b0:92f:a6d3:b941 with SMTP id x16-20020a170906299000b0092fa6d3b941mr37699870eje.30.1680539449235;
        Mon, 03 Apr 2023 09:30:49 -0700 (PDT)
X-Google-Smtp-Source: AKy350YZO6yy3slohD2vwdLzy0n/CLUL0WYrHOjF1iIAKERVsFL+cXW6KUd1h4792Rkymp+TFDlvpA==
X-Received: by 2002:a17:906:2990:b0:92f:a6d3:b941 with SMTP id x16-20020a170906299000b0092fa6d3b941mr37699848eje.30.1680539448823;
        Mon, 03 Apr 2023 09:30:48 -0700 (PDT)
Received: from [192.168.10.118] ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.gmail.com with ESMTPSA id gl18-20020a170906e0d200b00924d38bbdc0sm4742475ejb.105.2023.04.03.09.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 09:30:47 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     senajc@google.com, Thomas Huth <thuth@redhat.com>
Subject: [PATCH kvm-unit-tests] memory: Skip tests for instructions that are absent
Date:   Mon,  3 Apr 2023 18:30:46 +0200
Message-Id: <20230403163046.387460-1-pbonzini@redhat.com>
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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/memory.c | 69 +++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/x86/memory.c b/x86/memory.c
index 351e7c0..ffd4eeb 100644
--- a/x86/memory.c
+++ b/x86/memory.c
@@ -25,53 +25,56 @@ static void handle_ud(struct ex_regs *regs)
 
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
+	}
 
-	expected = !this_cpu_has(X86_FEATURE_XMM); /* SSE */
-	ud = 0;
-	asm volatile("sfence");
-	report(ud == expected, "sfence (%s)", expected ? "ABSENT" : "present");
+	if (this_cpu_has(X86_FEATURE_XMM)) { /* SSE */
+		ud = 0;
+		asm volatile("sfence");
+		report(!ud, "sfence");
+	}
 
-	expected = !this_cpu_has(X86_FEATURE_XMM2); /* SSE2 */
-	ud = 0;
-	asm volatile("lfence");
-	report(ud == expected, "lfence (%s)", expected ? "ABSENT" : "present");
+	if (this_cpu_has(X86_FEATURE_XMM2)) { /* SSE2 */
+		ud = 0;
+		asm volatile("lfence");
+		report(!ud, "lfence");
 
-	ud = 0;
-	asm volatile("mfence");
-	report(ud == expected, "mfence (%s)", expected ? "ABSENT" : "present");
+		ud = 0;
+		asm volatile("mfence");
+		report(!ud, "mfence");
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
+	}
 
 	return report_summary();
 }
-- 
2.39.2

