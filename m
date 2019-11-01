Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932EDEC9AC
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 21:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfKAUeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 16:34:06 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:49153 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfKAUeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 16:34:06 -0400
Received: by mail-vk1-f202.google.com with SMTP id v71so4342769vkd.16
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 13:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NdMpYXsn4p41hC1RJFMhKomdkFTZyn7osluAUD6/350=;
        b=p0pPMBKN0bVlXmIR2MVnncKCGPL8AngtJCAkTsQiLa8m0HNXprk7oZ43VRQunJMVuq
         xUDRYsRN1fbeS0Q6ir3OZziHWOC8d+nfrucXeZcjKmPKfH+BjKeu64ge2wBeZEmcjn2N
         K2/We3QaeIlw9z5urIzqiSM7VYv1DtQed+Jo+HswKYtS+OP2bAX4MxKViCiVHpdaFwyf
         MaQQF6rSQ+ETDLA+s3XknCSkKyys6d+MA/sIMRUY8gdaPd2UsPnTrE+ccpxQ70p53sVu
         ACKEdqfH6A1eMZO9tOVfApSvz058PlCWvusKJNO68uNwD4HNcKc1R0hHaZo94aBYxDUh
         JG0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NdMpYXsn4p41hC1RJFMhKomdkFTZyn7osluAUD6/350=;
        b=nnxSGFNhL4biYPqNSbVTtCieck+V0fmGsyyQDO+eBYJTFQUMZxbOS8R1OEHefpZ6/6
         MnuXaiDwzdGTmZV50lsUS6sCCateeRCQsM5glC0z4pthhUkaUSanWBrbNIDo6LbyEjr2
         ug4p9vRMOg//er7rSUzhgLJWzQ4SD1QTf3Jmx1VVhV7dB+hPqxfP+em0lyuf6ggmuog0
         b2IQXayeQ6yfKoXJga5m9dCMBdaEzTwl6RnScDazRpc550mmInVZhI0qHC4KYC/vSKuv
         mXf1mGHsLJ6LBXgYwlya9/mw+hUZ91QRvrDAy9TOtQzf9W8FRLTD8UM67BkuRYngvL3l
         A/Kw==
X-Gm-Message-State: APjAAAWt6QjzdbNRds7Aghqbl56XFbeTxW1oewXvjerUCBkjfJlfSvmV
        dqWGRrx1kpR8ROjFYeQc8YJemiLdJQ0eP69SJRVw8bmHbY6K0uTrarUsfNg2eaPAjQaKfNuc4W+
        3xD6eNk21jJVdzClZnBYmO0OOwfkItTt7/66dbQg9f3Wc6L27KKKo1g==
X-Google-Smtp-Source: APXvYqzI3br4HrCZ3rQ3okOYczJAAUcQJgRU4sCtjx7djnW+Mycbufyxm/RIeyEmQykmLylzMHIBpgIduQ==
X-Received: by 2002:a1f:d3c1:: with SMTP id k184mr2277469vkg.46.1572640445149;
 Fri, 01 Nov 2019 13:34:05 -0700 (PDT)
Date:   Fri,  1 Nov 2019 13:33:52 -0700
In-Reply-To: <20191101203353.150049-1-morbo@google.com>
Message-Id: <20191101203353.150049-2-morbo@google.com>
Mime-Version: 1.0
References: <20191101203353.150049-1-morbo@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH v3 1/2] x86: realmode: save and restore %es
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Cc:     thuth@redhat.com, alexandru.elisei@arm.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some of the code test sequences (e.g. push_es) clobber ES. That causes
trouble for future rep string instructions. So save and restore ES
around the test code sequence in exec_in_big_real_mode.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/realmode.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index 5dbc2aa..629a221 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -164,7 +164,10 @@ static void exec_in_big_real_mode(struct insn_desc *insn)
 		"and $-2, %[tmp] \n\t"
 		"mov %[tmp], %%cr0 \n\t"
 
-                "pushw %[save]+36; popfw \n\t"
+		/* Save ES, because it is clobbered by some tests. */
+		"pushw %%es \n\t"
+
+		"pushw %[save]+36; popfw \n\t"
 		"xchg %%eax, %[save]+0 \n\t"
 		"xchg %%ebx, %[save]+4 \n\t"
 		"xchg %%ecx, %[save]+8 \n\t"
@@ -190,6 +193,9 @@ static void exec_in_big_real_mode(struct insn_desc *insn)
 		"pushfl \n\t"
 		"popl %[save]+36 \n\t"
 
+		/* Restore ES for future rep string operations. */
+		"popw %%es \n\t"
+
 		/* Restore DF for the harness code */
 		"cld\n\t"
 		"xor %[tmp], %[tmp] \n\t"
@@ -1312,10 +1318,8 @@ static void test_lds_lss(void)
 		outregs.eax == (unsigned long)desc.address &&
 		outregs.ebx == desc.sel);
 
-	MK_INSN(les, "push %es\n\t"
-		     "les (%ebx), %eax\n\t"
-		     "mov %es, %ebx\n\t"
-		     "pop %es\n\t");
+	MK_INSN(les, "les (%ebx), %eax\n\t"
+		     "mov %es, %ebx\n\t");
 	exec_in_big_real_mode(&insn_les);
 	report("les", R_AX | R_BX,
 		outregs.eax == (unsigned long)desc.address &&
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

