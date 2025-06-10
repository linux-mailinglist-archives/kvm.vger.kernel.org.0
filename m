Return-Path: <kvm+bounces-48890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CECDDAD4635
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:59:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5CF016B68E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 22:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 616D92BCF4F;
	Tue, 10 Jun 2025 22:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZyxoXWYx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A6928BAA5
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596273; cv=none; b=ZycN+uIN59RiW5wqRNzXdorVtk9JA5C5uZNQlshCqHZUZD0/J2PwQJ9rblQzlC+2ojePqFTnixIBdjqt+w/qyeMi361laEnHmGdrAqrnM4Pdwk3iPkaTUabKOJz/WDKk/b5Ux84Qbr4JDfFCTnRZDnZDIE1e0cTcIarXfcZ1Nhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596273; c=relaxed/simple;
	bh=c+t0aGloWvvPZWudE6chQFa0LcMP7HyKXfD+z7olri4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NcbwgHgutVrgiYlZ8kWJ9zvlzGaC4UP42qE/+aMQ0q/94wFblDnOjMB/NeNvKYUhcUJP9uPIUhFXHGN1SC6c02rL+qm781/z78mxjEVrBHJEDUK80sQ4XZe66+T9iOYA04ecqi1tbO+JgHGObRa6lGz7rYErx8lv/aGpwCebHPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZyxoXWYx; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2358430be61so53688435ad.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596271; x=1750201071; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XhAPhvLo2nl6sdVqTFuYJr40FL1ci1fLAEXeXTkKruM=;
        b=ZyxoXWYxfSvnbYcHS3/uhTfnGnP3GiR+R+TarIHG598aIBtwfhmr3nuSj7miorzO/D
         g451vcKWIna2jaFYHwYLsMLcyr7uYnz3TK5G+LMfQmgDzCcgJrT3leTatfLHag/Daa2I
         nQwrs98UDlvewePOEdtWMPj+AYrDh/Xv9S6sB5OHOQu75WjUSBW55kEj8oNd+a6JnvXL
         v/JSPHXm93sY2sKuZZaF9/3maK5NXrgknmGahxZJT6JB7QrjsGB67Fzrm2yQOuDJBqkb
         5z6L2plj24CLk77yIqT0fVzOSJLPZ9KpqAluVmSxuCKXQsp4m/5wsbnn6d7v7z+hEC9r
         97hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596271; x=1750201071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XhAPhvLo2nl6sdVqTFuYJr40FL1ci1fLAEXeXTkKruM=;
        b=NzxQQaFPTHjnFRvrtQZrYFXzC/5GyIn8pnVxPH8YkXCwo/WjqpBleOuJEdprTMQ23R
         WVkL1ALp/JGZPJxkrsm/aUdePDrNLLZQmP+Zhau1nR1qKeK+6ZG5EpE6kk+Zma4PBI37
         0JjKJqIOeiLGNoJ52cWwHjhjgBh1rC1WWyHs3bUQ++2Kwo5bEGfXiqVx4A0G3rJSnO0C
         9VMJuqz3ne5cBMfIWjtMzVJ7OX6+BZSqc1PsJ3NXYsaMhUQtRhL68CH+SV1jezcaSijB
         HieYycu0f8uE3sFfa+BusRImWIQ3IrGZo/I426e3YwJ2svoRquqt1OLtPWu7ZczFUeZx
         yqWg==
X-Gm-Message-State: AOJu0Yx2DZxPW4rBEZ+YxGz81dZJxC4/9Kx0HB4IX1xO+RHcmQFRduqz
	p44kkUzn2s0BA9kMZZoqJnrBBA0y1b4yqNoJCwJOQPRFk78FCyHTP+ZnLiDDA0NRzAD3GLf0+wK
	kEhSXSA==
X-Google-Smtp-Source: AGHT+IFp0iTQA2qb/rrkM2L4XBGSSDPzYUa46lgRiaFpLtNRWiXfONhK/T8YLERYwpCsdcZuiyvCj/aOGFQ=
X-Received: from pjf16.prod.google.com ([2002:a17:90b:3f10:b0:313:221f:6571])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d48c:b0:234:a992:96d9
 with SMTP id d9443c01a7336-236426208b0mr6442435ad.17.1749596271429; Tue, 10
 Jun 2025 15:57:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:11 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-7-seanjc@google.com>
Subject: [PATCH v2 06/32] KVM: SVM: Kill the VM instead of the host if MSR
 interception is buggy
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

WARN and kill the VM instead of panicking the host if KVM attempts to set
or query MSR interception for an unsupported MSR.  Accessing the MSR
interception bitmaps only meaningfully affects post-VMRUN behavior, and
KVM_BUG_ON() is guaranteed to prevent the current vCPU from doing VMRUN,
i.e. there is no need to panic the entire host.

Opportunistically move the sanity checks about their use to index into the
MSRPM, e.g. so that bugs only WARN and terminate the VM, as opposed to
doing that _and_ generating an out-of-bounds load.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c75977ca600b..7e39b9df61f1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -824,11 +824,12 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 				      to_svm(vcpu)->msrpm;
 
 	offset    = svm_msrpm_offset(msr);
+	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
+		return false;
+
 	bit_write = 2 * (msr & 0x0f) + 1;
 	tmp       = msrpm[offset];
 
-	BUG_ON(offset == MSR_INVALID);
-
 	return test_bit(bit_write, &tmp);
 }
 
@@ -854,12 +855,13 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 		write = 0;
 
 	offset    = svm_msrpm_offset(msr);
+	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
+		return;
+
 	bit_read  = 2 * (msr & 0x0f);
 	bit_write = 2 * (msr & 0x0f) + 1;
 	tmp       = msrpm[offset];
 
-	BUG_ON(offset == MSR_INVALID);
-
 	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
 	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


