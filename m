Return-Path: <kvm+bounces-13625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C78CD89923E
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 01:40:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06570B2705A
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 23:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 115E113C8E0;
	Thu,  4 Apr 2024 23:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OHR03Hm4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327A013C69E
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 23:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712274016; cv=none; b=Im/i6+OXvF6PYiezUlC+ziLem6K7dd6rNIKnJD2nrrlqRgOJxbnJ5zEO0bFe+qoJMacZXN10QIg4zVPEQI/1g7qOqbjzLlH9dMmOO3QCCe7j7oul99nEp6OqGGaC1PG8FF1HNE/jrikYqOFefkqyVhzBpDKTYzgRgr60q8d49bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712274016; c=relaxed/simple;
	bh=ShNXKTKxsoV1gidL/jCEGh1UXFa8beTlPBREvu3TALk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WsasFzHdeDE+uQ6SBxwXOOA0172+T3PpItIAqpPfK9gg5lAaCBYFvQBQCVpcWxragM9AB5VdtiYYiz+feF8YXZAnSIn1Fse6SpdnfwTvt1c0JkxsnIsd7XlcQ44GagxzClSpoTD/fWS5T4U3MnLdXRINfYTkX5GshXIY43G5y8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OHR03Hm4; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e09eebd62bso13777905ad.1
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 16:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712274013; x=1712878813; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=++a/hvLgm2LFaPeq7sJT2WCGQZL19kelVmxT81YyZ+I=;
        b=OHR03Hm4Yz6teVrcBEDj7uZYxtI/wK8o3p/VJxPH9QSOOUt441UucrN3CFoJG9ytlh
         8Wp2XnVg0rlKEsBzmbVjJx9XVoNcjdo5ZqA/FFlK8QagQeW9y+GucU1zKp/Z+1opadLG
         oS2vQ8Seofa5U36TUJzSoDqjbKbHld7YeqMGv3XgNF+p/l6eBpq04VfD7pfumuKv/fmp
         Rv89YUjYDuuR0ORxarFdlWX6/2SNNpTjfb1K/J4PkxeZaYNrqr9alRLOkgunNWw3gCRl
         m0u14fFC/k3WmbI3ykFb6CV44CyVeSKXM/usj/1iatqCLZkdNB5QZL56a8D3ezMoRi8E
         p7Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712274013; x=1712878813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=++a/hvLgm2LFaPeq7sJT2WCGQZL19kelVmxT81YyZ+I=;
        b=GIzyrPVs0hIGPaXwi8JQTD3UYrOBxoSSp09VvESw/E1hBuzJUVMkdCJoBWoxt1n5rm
         OJQMjjyS+u20eDdj2QbQuoPND1tyD+U04SIJ5Z0+8SOKdOsiX5WTM5Wn7qsBoEEF9Bf+
         UOPDDqr2ijJ8DiMCjKlaFVcI7JRvs1AYhVuLY7SFtiPiT+IlcuMLzBmMRxOzkY7/rlqS
         qdi7uotZ9VXLNzA003eAepSu51t7MGT5zgccrVj0VF1C8wYcUj8yU8C9JrENuN0c7kYK
         K+q/ry63ZnFpVnbw2VAIHHgUJ3zwOywNK+9C9LHHgkRvL3tnsUjncgKN78kMdpWw0Sc7
         y4qw==
X-Gm-Message-State: AOJu0YwiIKBggmYrV/iThtVLG6Zh757m699OZ3limNiz9Y1iGeXXgvL3
	dcigOJVqS/0//HfimPSO2nVPkNZYQUgi6HJ2oECi+GHFqt+piXcBFqRiuyMkAvctg+4muBTZ6wu
	tVA==
X-Google-Smtp-Source: AGHT+IFXyQGRwEJ/4fWcQaCNTSSexyUuvyDvbAc15+ionqqlW/lDl07k9yVGUcTvt59QeDxRQ5kPXvAaaLQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c9:b0:1e0:bae4:490e with SMTP id
 u9-20020a17090341c900b001e0bae4490emr38806ple.13.1712274013568; Thu, 04 Apr
 2024 16:40:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  4 Apr 2024 16:40:03 -0700
In-Reply-To: <20240404234004.911293-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404234004.911293-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240404234004.911293-2-seanjc@google.com>
Subject: [PATCH 5.15 1/2] KVM: x86: Bail to userspace if emulation of atomic
 user access faults
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Michael Krebs <mkrebs@google.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Upstream commit 5d6c7de6446e9ab3fb41d6f7d82770e50998f3de.

Exit to userspace when emulating an atomic guest access if the CMPXCHG on
the userspace address faults.  Emulating the access as a write and thus
likely treating it as emulated MMIO is wrong, as KVM has already
confirmed there is a valid, writable memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220202004945.2540433-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aa6f700f8c5f..a9c26397dcfd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7105,7 +7105,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	}
 
 	if (r < 0)
-		goto emul_write;
+		return X86EMUL_UNHANDLEABLE;
 	if (r)
 		return X86EMUL_CMPXCHG_FAILED;
 
-- 
2.44.0.478.gd926399ef9-goog


