Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E40338769
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 09:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhCLIcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 03:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbhCLIcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 03:32:02 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9250C061574
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 00:32:01 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so10730362pjb.2
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 00:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CXpW0jwlizj8GYTWHzwU8bAHHZKAdwaecc1NswSz/OE=;
        b=Ccj25YDTPKU/57oEL/GyBbzdoG3Cad1MC5quVjSh1ZoLeLYp/oRlBjJJWGKN2QAFlP
         8299qZp3bQJMvvbvg1UTV+zydy/b2Hzgexu50JBiylyqKEq46bc3pxUCPDFH3O36/LFX
         kJ+br9H0Eb+q7AWaSuzrLYEOlgZTmA5nHPPYPoRt2LjDcOCsvEhsiwDSpQOONFpBj6Go
         lJyzEU4SzgXRLk2vkkV6B0KiscdvSAgwj+n3cN2FQBeBE4YQHa/XEJpZ1m7pXyy5owU2
         fc+DgjWfaINp1NjLkCk0FcGg5htcxCPhikvIYN9Plw+biynveEp+496yv3vFkoYHUetv
         h+kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CXpW0jwlizj8GYTWHzwU8bAHHZKAdwaecc1NswSz/OE=;
        b=nQQMPoO+mKl8QDA2Rp+sTebfGaDdU/aUsZ2n7IqL6PYITbDRlaff+fNwiROoZ9wJYs
         Njza0wHrzo39bIZ0VV4eNKc5dbQf6NZkZ34xH45+JSBhRIoEC3KNpOvbg/aLQshBRx5m
         24jp6zyMgjQd1kaiQSKll4wRl5Ef5aXFqWcR+GF/G7QocgKNrNHS0q+nXeDd6Gk257Qd
         eQ6rQHq1FKzc41G+D0D5mhcC3e4pDi3yJ9QNQGn0QBeAluUSRPYpUmRKhTUwA0442PQV
         jd2ISV5gBHzs6eNGt28MHPY15iF41l5dsskgNkyFhRtuv7W7PtRfGt/lHkfiClFpZ/W+
         Txdg==
X-Gm-Message-State: AOAM531mTeWJpx3S7ciDe3xPEKbWrVwvpLK/YFTOzbyTXIzRi5q0/iMZ
        PpE5opFOSSLekm75biyMxuI=
X-Google-Smtp-Source: ABdhPJwP36IB34Owww3eDhkOSn0CtURJiGKPlguqyhIT5PdyQT3VFZJB4jFJR0/0jvVLyHI542wg2A==
X-Received: by 2002:a17:90a:c389:: with SMTP id h9mr13158014pjt.226.1615537921339;
        Fri, 12 Mar 2021 00:32:01 -0800 (PST)
Received: from localhost (176.222.229.35.bc.googleusercontent.com. [35.229.222.176])
        by smtp.gmail.com with ESMTPSA id c25sm4340198pfo.101.2021.03.12.00.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 00:32:00 -0800 (PST)
From:   Yuan Yao <yaoyuan0329os@gmail.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yuan Yao <yaoyuan0329os@gmail.com>
Subject: [PATCH 1/1] Fix potential bitmap corruption in ksm_msr_allowed()
Date:   Fri, 12 Mar 2021 16:31:57 +0800
Message-Id: <20210312083157.25403-1-yaoyuan0329os@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In ksm_msr_allowed() we read "count" out of the SRCU read section,
this may cause access to corrupted bitmap in ksm_msr_allowed()
due to kfree() by kvm_clear_msr_filter() in very small ratio.

We can fix this by reading "count" value in the SRCU read
section. The big comment block below shows detail of this
issue:

===== Details =====
bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
{
	struct kvm *kvm = vcpu->kvm;
	struct msr_bitmap_range *ranges = kvm->arch.msr_filter.ranges;
	u32 count = kvm->arch.msr_filter.count;

    /*
       Schedule out happenes at this point, but before the
       kvm_clear_msr_filter() run "kvm->arch.msr_filter.count = 0;"
       on another CPU, so we get the "old" count value which should
       be > 0 if QEMU already set the MSR filter before.
    */

	u32 i;
	bool r = kvm->arch.msr_filter.default_allow;
	int idx;

	/* MSR filtering not set up or x2APIC enabled, allow everything */
	if (!count || (index >= 0x800 && index <= 0x8ff))
		return true;

    /*
       Schedule in at this point later, now it has very small
       ratio that the kvm_clear_msr_filter() run on another CPU is
       doing "kfree(ranges[i].bitmap)" due to no exist srcu read
       sections of kvm->srcu, then the below code will access
       to a currupted(kfreed) bitmap, we already got count > 0
       before.
    */

	/* Prevent collision with set_msr_filter */
	idx = srcu_read_lock(&kvm->srcu);

	for (i = 0; i < count; i++) {
		u32 start = ranges[i].base;
		u32 end = start + ranges[i].nmsrs;
		u32 flags = ranges[i].flags;
		unsigned long *bitmap = ranges[i].bitmap;

		if ((index >= start) && (index < end) && (flags & type)) {
			r = !!test_bit(index - start, bitmap);
			break;
		}
	}

	srcu_read_unlock(&kvm->srcu, idx);

	return r;
}
---
 arch/x86/kvm/x86.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 46b0e52671bb..d6bc1b858167 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1528,18 +1528,22 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct msr_bitmap_range *ranges = kvm->arch.msr_filter.ranges;
-	u32 count = kvm->arch.msr_filter.count;
+	u32 count;
 	u32 i;
 	bool r = kvm->arch.msr_filter.default_allow;
 	int idx;
 
 	/* MSR filtering not set up or x2APIC enabled, allow everything */
-	if (!count || (index >= 0x800 && index <= 0x8ff))
+	if (index >= 0x800 && index <= 0x8ff)
 		return true;
 
 	/* Prevent collision with set_msr_filter */
 	idx = srcu_read_lock(&kvm->srcu);
 
+	count = kvm->arch.msr_filter.count;
+	if (!count)
+		r = true;
+
 	for (i = 0; i < count; i++) {
 		u32 start = ranges[i].base;
 		u32 end = start + ranges[i].nmsrs;
-- 
2.30.1

