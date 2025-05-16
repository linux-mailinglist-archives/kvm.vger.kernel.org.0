Return-Path: <kvm+bounces-46887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A7C7ABA535
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:32:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F33D2189B817
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E0F728153A;
	Fri, 16 May 2025 21:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0d0RHOkz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDD1281504
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431017; cv=none; b=p0kMWge4X92Xn2eq/7K5fuZ6SHIYZaycJIeWpXvHsPjsNQN2d7ZTnJJC+ctXYo9a241Fsl76z54PRRBh/TEjMlE1hbDQc9osoKmzKzSbGaJzQHCzDHEyda6qcuxxL0H4yM2he+3lnytkb/DL+emNtZ4eyC1WQBIls2uiT2YWm4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431017; c=relaxed/simple;
	bh=NZvCSJRzuz1KajlGW5YiPv7YN+M07Tdox9/J35tpIEQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K1zI7fhqH4IP5y/saFmG5ZCBb5qSNDeXQbBIe3cp/eZ2p3Ej5DAEF5shhdu53B/kDtAU0jEXVZZ6oQH9pXFZzE54Dvfsdv+apLeL67lSy8DSRPFsgrcC+04KhSEIa5Uw5oB5ue4b7GiWdKm7FZnRrlsIWMtUbYaVjmAnbFfbvz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0d0RHOkz; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26e73d375aso2079280a12.2
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431015; x=1748035815; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7Dga/slcZZ6fKTxbenqYjayajDYVeAnUirYr9Z43Kqg=;
        b=0d0RHOkzaqcA9atnHe/JJClOr0TmFScvdbmO9kJtssIykG1Hg5H5wldUnFjcgH3cKj
         kPWzJ+5s9bfbp2/OPBZYwoh9GHTzuEdj7OaaOEyZ5y2T+tX52CKCCNt/h9wgZ48VZEy/
         d5pdP0vL9h3kIg+seXAx9s4en8TqGf6jB9pHUMeYdGk8+ftd0+V1V67cx+1/I+33CL3a
         hVURrEJnyllWoJaiCNbey7xvxoROBdeJcvgz+5FdnjkAfNwIRt3UT4YkYqp9M/saUTIQ
         Df0D/XpZjil2qDN/5A0vH03R10W9fK9CJMtOurvhrALHLXNe1Ll9Czk+LSgeUjHui6w3
         cYqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431015; x=1748035815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Dga/slcZZ6fKTxbenqYjayajDYVeAnUirYr9Z43Kqg=;
        b=VdWdVmOUXJzl2JIsbHo16uQ94JPV6g9XCcv7MrnphWiCvVw8IGQA5slnMyjqOlOEUq
         BkFphC2h3EJmNLUPgaM1y14UANzIoP7LMOIlIiPFwUeElDyd5CHIyAMXrMnWlxnGbaC5
         pWu0qRFUhFJ/GXnklL8rEaocKgdZcwsQEIcMIOJPPIL7Fi/soJX26vAfp0M+tHa6n5TT
         rxCr9xl8/XmLAMbb/cbzE7E8U/tcfdtN9jeNjB35NjQNoQlJY4DUIIXMeFpobIR5vrqF
         DiIzMZ7al70vsJW4mSpVLyg07n46NOIHl1RPx6J2rtHc8mXl+Yy0eX+wI1pZF7+eL3Vg
         8ofg==
X-Forwarded-Encrypted: i=1; AJvYcCWWfNyR3z4Cb8k+N33fgYELoFcY8h3jvDUbjZZjFuYVvJTcKigC/BKVb5RT+FS4lIWed04=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUW1f8W0AXSXR8rqny+TnQd8aCtEeCR8qel5YuR341efh3H8S9
	AwZhFVKqjbok8BhyfeECw9dXwn5t9rgaVz9+LCeJGwQX5MHB8NqUQLzW6miJpJMIVpLNRB6+Jy5
	lYsUMFw==
X-Google-Smtp-Source: AGHT+IEmIT1oJ5BehpO/x/61kMltmH/PXqlkOkfjC0VyUyY4O6dvRDZ3QTMaLlJYbCRtNBQEKJ+Vu2+xC7I=
X-Received: from pjbpv17.prod.google.com ([2002:a17:90b:3c91:b0:30c:4b1f:78ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3409:b0:214:f8b1:e385
 with SMTP id adf61e73a8af0-216fb192726mr7093001637.2.1747431015121; Fri, 16
 May 2025 14:30:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:28:31 -0700
In-Reply-To: <20250516212833.2544737-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516212833.2544737-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516212833.2544737-7-seanjc@google.com>
Subject: [PATCH v2 6/8] KVM: x86: Use wbinvd_on_cpu() instead of an open-coded equivalent
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kevin Loughlin <kevinloughlin@google.com>, 
	Kai Huang <kai.huang@intel.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Use wbinvd_on_cpu() to target a single CPU instead of open-coding an
equivalent.  In addition to deduplicating code, this will allow removing
KVM's wbinvd_ipi() once the other usage is gone.

No functional change intended.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f9f798f286ce..b8b72e8dac6e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5009,8 +5009,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		if (kvm_x86_call(has_wbinvd_exit)())
 			cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
 		else if (vcpu->cpu != -1 && vcpu->cpu != cpu)
-			smp_call_function_single(vcpu->cpu,
-					wbinvd_ipi, NULL, 1);
+			wbinvd_on_cpu(vcpu->cpu);
 	}
 
 	kvm_x86_call(vcpu_load)(vcpu, cpu);
-- 
2.49.0.1112.g889b7c5bd8-goog


