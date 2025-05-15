Return-Path: <kvm+bounces-46734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2CFAB921F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 00:04:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDB233AE38C
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 22:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8329628D82E;
	Thu, 15 May 2025 22:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w2ea5Ja3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484E928D8D2
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 22:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747346660; cv=none; b=C7gR56QwVYQMyK3NE46LBsuzOiZdNfsbVnTVL3p2v+CtJed38le8Pq5xOh5sVy2Iga5yZQ1mwTid/o1zvd2/1iUSy7eAfQH6r3HUOGAz+p8+aBnpwMHcKCCP2QER9r2giC+TG/yG5wvS8CCCY0HRggGIESDNVLlXai0iWtu6cgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747346660; c=relaxed/simple;
	bh=mmLKrWU9BMWCBbc2PskOjz9u++A6Zg7rZw9yObFxywE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ddK8RX3sxi4zF9k6MEP+NjJOw7bI6fx6sqavp91Y6ki3huuAFxDfUWq/HMnZwLzMJIKRtNBIVAUQO/DHdVcYkG6BkOofjnJZ2C4wpmrOhj8KiHtYCHLEue5IhiNX09IuWwxggxRwI1I7LCu9pNSF/Paj/XW8jPfh0V3KjSY1EMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w2ea5Ja3; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22fc829046fso13064795ad.2
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 15:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747346659; x=1747951459; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=da2OQuvEUljiX7sOqbLfJ1kNKJczIhzC2yFs3FB784s=;
        b=w2ea5Ja3gbYdhXXhb5Z1w5D5pw77H/eyQ2mxrNJEHZTKAemRtrrPkWikJU+Gcw2zpe
         kzKkKJQilRDflF/vEGYhEroPjY1RY2JflIIKGFtYu7G8e9rV1SzO8fqTJhjybnkN+2AV
         J7UxOxW5Lc0gzUF17tCbquLs6707YMdhxUL19oxBBZjVqXM0pvxi66YNp1Gbof//lGfy
         O0PBp7rckFIfO6rtl1kTFaphfHKfJjTVqakfAj0Bw8Yxq7nScyjI+TvjZBuPMX8Zbjv8
         XFzuyPQLVtoxVPkYnzMLiVDl6xu4peNqY+ihDwRA3xsSbJyeJNkBT1LE+ojMuCO1KrmC
         00Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747346659; x=1747951459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=da2OQuvEUljiX7sOqbLfJ1kNKJczIhzC2yFs3FB784s=;
        b=AWtU4MyV9uGyELHa0Jt3iTEgEe8az96MDkL1lPEslB6mRZH+0KMiYgNfMQs9/ZzZ65
         bsm1vybxAmA0NOIa3NgPkeDKXRETF72xi0QnE4jUZG9S1IkBz6gv76dPSw9VY2X3Wyy5
         6bjYRzrdNdGKPEIiitkktTPyhil9YlGiWae98NyV4gjtH8XGRJx/gvRMV7YMaL+GwEK8
         FjhNkE0VU0RGkOOFNIdn98w8Fg2QCIZ3YrywqZZqvfdYkC3pXHixi55o3nm/PlRh36RX
         ShY/TdcpGsRFmHIar1X6F5PrWfpa5hkgV2Q9vFyGBv6tD9nzbjRkSY+DfnRS7lS608HS
         8i0g==
X-Gm-Message-State: AOJu0YykW0mHhq8Qc1RQUHBRQqR7JBWUp4rPH45SDCZuC3f8L9Qq8Rdh
	JtD8pDKKAtVLsMHKGsnlYPY+m7Tl0GTNykBVAIPtmyy0eqxJOKx2BPrBUh2l/u0XYdBv/ZKd0mL
	Fdn8moGQT9DGPwGyzneitzwLzmKqJKn/MIOsWyZHSkGDwd3kcmwAOOGiJnFx2nkNBjs0IyHCRtX
	snLjOa6QFS9fYWax4IESHZa39t2kvhEG47UPZ27BAvBUytd0N3TPdx1yrgKRw=
X-Google-Smtp-Source: AGHT+IGlf26I+aKQ0s1+qKRvgDiVtukbmuiTudxffeFLhCnrwEABrd4/+TM3/By71fTsSsPwRSUcRT9wY+f7sv5Vlw==
X-Received: from plge2.prod.google.com ([2002:a17:902:cf42:b0:231:c831:9520])
 (user=dionnaglaze job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e787:b0:224:26fd:82e5 with SMTP id d9443c01a7336-231d455d9ddmr12636465ad.48.1747346658529;
 Thu, 15 May 2025 15:04:18 -0700 (PDT)
Date: Thu, 15 May 2025 22:04:00 +0000
In-Reply-To: <20250515220400.1096945-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250515220400.1096945-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250515220400.1096945-3-dionnaglaze@google.com>
Subject: [PATCH v5 2/2] kvm: sev: If ccp is busy, report busy to guest
From: Dionna Glaze <dionnaglaze@google.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Dionna Glaze <dionnaglaze@google.com>, Thomas Lendacky <Thomas.Lendacky@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <jroedel@suse.de>, Peter Gonda <pgonda@google.com>, 
	Borislav Petkov <bp@alien8.de>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The ccp driver can be overloaded even with guest request rate limits.
The return value of -EBUSY means that there is no firmware error to
report back to user space, so the guest VM would see this as
exitinfo2 = 0. The false success can trick the guest to update its
message sequence number when it shouldn't have.

Instead, when ccp returns -EBUSY, that is reported to userspace as the
throttling return value.

Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Peter Gonda <pgonda@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/kvm/svm/sev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 35b04a10ed73..884ab3f54fca 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4063,6 +4063,11 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	 * the PSP is dead and commands are timing out.
 	 */
 	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
+	if (ret == -EBUSY) {
+		svm_vmgexit_no_action(svm, SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_BUSY, fw_err));
+		ret = 1;
+		goto out_unlock;
+	}
 	if (ret && !fw_err)
 		goto out_unlock;
 
-- 
2.49.0.1101.gccaa498523-goog


