Return-Path: <kvm+bounces-29972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C20479B51F6
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 19:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85DB3284751
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 18:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA98020720F;
	Tue, 29 Oct 2024 18:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="naLAa5bg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D0020513C
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 18:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730227176; cv=none; b=af9tWVY08ndCnN0ACd8PYrMIfe+V6A42JIBbiDb6YtgrvZGOP9SCJNXsamh7ccrWhaBOu9r6Iqii0jst8o3GLPbBztEKrJukhpIVzO3Q+x/zc46kZMaud4rvXCGnkb5i3NrnR0Pz2RF7MqjqBqU5wUxI1LJEMBQjjBXK+FgGd8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730227176; c=relaxed/simple;
	bh=vT6UGaJCAHZQdweFlVmqsA0PbWlxvJ3lJa2y/UVhQX8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LWGvV1fgJS81fL2k/WlH8V0lJQhSqq88OGxnElk8p8iJzOZvy6LMcIjgX3PNpXhNHrjvvyJTvoWEl2e3RA79gWPU660RfaDw7McDA05G+dykB0xKzQu7rfj0gTtxCbm8zwwbLG95SiUTgiFuxghUZPTRhFBlQ7EITM2r2tc6dhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=naLAa5bg; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e30cf48435fso379239276.0
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 11:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730227173; x=1730831973; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nIzbr7zBh90Qk+4L+ha95UM8CI0cs/ioObBQO0IhCVc=;
        b=naLAa5bgLcbKMaCyxJL+Nk58kSjrpEZB55UkCPYiUF0D3oTEukNrBNOk9kbbDSik5W
         oMrNqoP3Kgv/PbihZNb9efcHZ1dhM4CBiSzFvNlaAXwBMbzucCU7jD4h2esMX//n1Shp
         jPZwXQe1Tnh5muCk4nFBzG2XGiANcXsv76LPoGqc0hJOPm66AFvEP+fUJ8vK0TW6HVkT
         OFad+j7/lcjqQ5oB6owpaJX2G9L763ptvvtBzla4TGTrW8kS+zrXiJw7xDu0mf1v/5YT
         0Rwz2xQre9yXStaPPM9w/frQyqx0z67xrVXyxz4Lf5qMcAWI1Yenqwdd8nK1423BbsIo
         wLbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730227173; x=1730831973;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nIzbr7zBh90Qk+4L+ha95UM8CI0cs/ioObBQO0IhCVc=;
        b=LMeF7Iyw3K2tPYmTGv/YESQUjQZt9fCOOaYhWelmhGjeIT8WNaIvSQ9Nag5Dd+G7aU
         91Oe59mRnid496ZPeIaoMFKACG5miHpkF/Xvfb9O13KoYH1iZP6uPnC1OiurWW62nCbX
         h+ogfIvY2crlZvU9spcKVHM7LQcqCCNDXLBTXe8SYmdazxUOJAzaaXVe2VzQUD122l0l
         STxIbD+tuJxJR4QI9YgImg36/uDUqi7ZwjIbOS6B54CTAqfflwtdS5apCgTWr4zDhboi
         Kob2h5su0SXZN1Gdd8ntsvIl5q5TJKh48ZvKFZIhiPna6VviiZFv7OzraZwCLuY4mt1p
         ekfQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0Qx+ED1TMuaojVphBGY2yuInFa0+AMfg9JL9ql4Qmi9SeejALM2rwKSNGdtaFWdYDkn0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzljERLeD4qhn80TKGw2ipxkPhvapAAUeDJ6lOQG97hOrKqiB8d
	/FaA5PLtVHnGDGpsMzInEIxMk/R13JtD4s/9hX/w+/CbCTtqADFTgmcdIwHGYWLi7WMyEKSF7io
	cxyYWgAlkTaZSN9jF7df9yg==
X-Google-Smtp-Source: AGHT+IHSZ9z1gKFuoLjow1B8gxL4DLpvVpticofCNjquLeMSvisfqXyLo4Rn8guu4cbEwZ/Xr0RyrrNg9xIAoplbLg==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a25:18b:0:b0:e20:2502:be14 with SMTP
 id 3f1490d57ef6-e30cf49aefcmr320276.7.1730227173530; Tue, 29 Oct 2024
 11:39:33 -0700 (PDT)
Date: Tue, 29 Oct 2024 18:39:04 +0000
In-Reply-To: <20241029183907.3536683-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241029183907.3536683-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241029183907.3536683-5-dionnaglaze@google.com>
Subject: [PATCH 4/4] KVM: SVM: Delay legacy platform initialization on SNP
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Dionna Glaze <dionnaglaze@google.com>, Ashish Kalra <ashish.kalra@amd.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When no SEV or SEV-ES guests are active, then the firmware can be
updated while (SEV-SNP) VM guests are active.

CC: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>

Co-authored-by: Ashish Kalra <ashish.kalra@amd.com>
Change-Id: I3efb5fbbd0da05ab29f85504a86693f5cdf49050
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f6e96ec0a5caa..8d365e2e3c1b1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -445,6 +445,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 		goto e_no_asid;
 
 	init_args.probe = false;
+	init_args.supports_download_firmware_ex =
+		vm_type != KVM_X86_SEV_VM && vm_type != KVM_X86_SEV_ES_VM;
 	ret = sev_platform_init(&init_args);
 	if (ret)
 		goto e_free;
-- 
2.47.0.163.g1226f6d8fa-goog


