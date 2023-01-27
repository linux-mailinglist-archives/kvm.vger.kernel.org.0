Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC6467DC5B
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 03:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbjA0Cwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 21:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjA0Cwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 21:52:53 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E931E1207F
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 18:52:48 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id tz11so10374165ejc.0
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 18:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvDB910gEnDe36r/d/OlU/tDXP9cfG+XamOvClg0hhM=;
        b=BzSw5d6UEYdPaSMNL7TRDHRg+ZiCgJhM58Jauidl5iIaudeSgClPDXxx846FiEkusi
         k/9e4Ovl0cC2wEel4w44fQzwZaTO1P+Cm9ceYmOPGj03Zru3OuNZ9RoYAbqURRXt3xuB
         yzvpdv6WE6a1KiwnKep0F2tB7jwUwAg/RE/EK707Mxc0TqfXsE251OjEGdpMdoni1sPR
         J7HzYf81LXJhDwM/5QypcRYkpA5JlXwP3PZ2Gyf2cyRUNw2x5q5pmlQXjy/oTIks+qh+
         AWCTCnJhGP6LLtDorft9W+u7/V0EmZRUZckUUKBbiSu7MCr0eoUu/BC8JaT+eEuppzNO
         jL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IvDB910gEnDe36r/d/OlU/tDXP9cfG+XamOvClg0hhM=;
        b=0zjbyA0NApx9C/cMGVVF32WOEDoDVhOUc2TT5zULbSiIpMCZfyhsRaNiD3Eb72yvWP
         W0WJ1hTd+i3UoqqVUg+ShAFSMEfNfXOflEwDNKCtY5mIpJVy/4pp/qghrWAZRlSFT422
         KDLSZpAAfxsg+ysda/ptYWyNbZoyyHFo7x8Pxb05UhXCKD5O5zsgQRbC4FDpRw3cBQt6
         uZGCj6HZeqqxbVQwumiNw5MZ1dxw0Q4uoIFjC9bQyx5hMlj/NPsNr05Vq/oQJSJz+vs5
         aqKfAyfjLnP0EslMckYZAWtSV7m3nge2Vegw9+Ym5i+c7R+UipZXwRf/lAtFum+dxiwb
         Rhcw==
X-Gm-Message-State: AFqh2kr+hr9ViIQsx8iw0V4sO0QBABKPwMtnsq5ZJUJMFdnLUMH+o4M1
        gN+G/zxiqV7nKEmAlqleM/San0VLwZRRfNGEHg2BiA==
X-Google-Smtp-Source: AMrXdXsspIeDg5UBSefPlJ9BA3aTdIjSp6b+qGoQ7eX8kyEz4T9uIsYKYt+oGstAiBvvqnlrjFh5og==
X-Received: by 2002:a17:907:7248:b0:872:b1d7:8028 with SMTP id ds8-20020a170907724800b00872b1d78028mr53553920ejc.3.1674787967402;
        Thu, 26 Jan 2023 18:52:47 -0800 (PST)
Received: from localhost (88-113-101-73.elisa-laajakaista.fi. [88.113.101.73])
        by smtp.gmail.com with ESMTPSA id fp35-20020a1709069e2300b00878683acac3sm1448899ejc.112.2023.01.26.18.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 18:52:47 -0800 (PST)
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Harald Hoyer <harald@profian.com>, Tom Dohrmann <erbse.13@gmx.de>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH RFC 1/8] KVM: SVM: fix: calculate end instead of passing size
Date:   Fri, 27 Jan 2023 02:52:30 +0000
Message-Id: <20230127025237.269680-2-jarkko@profian.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127025237.269680-1-jarkko@profian.com>
References: <20230127025237.269680-1-jarkko@profian.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Dohrmann <erbse.13@gmx.de>

The third parameter of `kvm_vm_do_hva_range_op` doesn't take the size
of the range, but the end of the range.

Signed-off-by: Tom Dohrmann <erbse.13@gmx.de>
Link: https://lore.kernel.org/lkml/Y6Sgwp%2FBofzCUrQe@notebook/
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 855f5e702240..d3468d1533bd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -500,7 +500,7 @@ static int sev_get_memfile_pfn(struct kvm *kvm, unsigned long addr,
 			       unsigned long size, unsigned long npages,
 			       struct page **pages)
 {
-	return kvm_vm_do_hva_range_op(kvm, addr, size,
+	return kvm_vm_do_hva_range_op(kvm, addr, addr + size,
 				      sev_get_memfile_pfn_handler, pages);
 }
 
-- 
2.38.1

