Return-Path: <kvm+bounces-21992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1FFA937E36
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:54:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58DED1F2383A
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38491494B5;
	Fri, 19 Jul 2024 23:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UEdMJcA3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3A514B967
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433089; cv=none; b=hml688OGkCs6iuPGWyjiwW05yP08NX/+33CHgzkGPVER4q0v/OdvOfaDMsGKW5QB4ayNBwdC/YL5KC+241Ot1vquDsVok+BZTS2+4dysfFKau/sckxKO52GXgnJAXuPTa3ixq91jeg14CwlP26sCDndypHOFxVq07AGANPhZWxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433089; c=relaxed/simple;
	bh=koF0ilUHAjbeODWkxNP1nhd3CUNaryDa0xwHrMXzgqs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hpmv41cLDutR+zYE/X9ctT3Xwlk1Bd6JrO7ArzXoqwt8e86Kpaf0+hYjd8N7PMEDMdHhIAXlkQXW+qgG2AvOIFz+CYhSVHruwo6/t9+FaWYe9kpQHHy0mspjHOGlEU1Hraraz7KZ2NuzxQhBgZwMVQ+HgTe7dtLHSnfkEQIqszg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UEdMJcA3; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7163489149fso2187956a12.3
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433087; x=1722037887; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8Sk1Boj3nBGrPa6ow6mxcb0YRG2ZhhxIoTDChRs8X2U=;
        b=UEdMJcA3b4AFw8eYBudHXNKiUiUaVAYX4Fol+5+jc4okUfbiTZUO7vrs5itHHIucEp
         pcqd97LvKFOlPhls0z72K2oPac9x0XtJRtnlP1/Klmae3nM5VpyaHQRFdVrMCBnVgb3k
         /vgA+MOTq08XTIXnRkd2WSy7JWMCFOiqTeoFhYdYCKCMq3TQhs5F15CXhtaNl1kwVgwc
         BEp3Y86QwTWmUqp9pZrjhIYWnqkAfaJ7eT1RUhkoAhgB05cRsX3amnxWDLGKr9nBayqL
         4ZKb4+0hdt111qBC+riDjKcjpoScSvM5hnueozuhQ600Ckk3J3tTm/d+MeSKBQNJ7nrY
         tY2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433087; x=1722037887;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Sk1Boj3nBGrPa6ow6mxcb0YRG2ZhhxIoTDChRs8X2U=;
        b=mS5j3nT7A6qdlHXEX2VMk8hocFWQBhDaYrHP5+WTIE3VCLJECBCTJJkhrYuL4E8HoG
         5+3D317DWRKLwlTGdcOuyJX3llFgoszm6BgM5U15M6ug+o/ikzy7uaYDqa5WZXaQdWU1
         uMFTj3bUuQofg+AUEY+5PWmIJzNIeX18Qg2+FM40bpAinSHl/pLI28IRoRkHmLrpJlTy
         f+wRfA0FXi8wQRjxAK9Ce6nt1K4ptAWeM2ZkkozZfm0sY3h/d18y55ytubF7Q3WaQoPF
         5/MP3bP9WVR9jB4iF7okIRPZBqHKof6wZJl4LnPQRSSs2zNHRJ39HBFhTu8/XuyhfRzK
         /OXQ==
X-Gm-Message-State: AOJu0YxznPtEe88RZUoi1lUFlT1SJn4CQ4PnLXr6b8RL722Rg4q6YaJZ
	z6Eds4W2XJJftp3LWKvp//TQURD/rnLiQEgzrNIgQ4efkKG3SFV3vhjp0lXv85oliDTahSJIjY8
	ueQ==
X-Google-Smtp-Source: AGHT+IHS2YxJ7KX/UH9tkB2CnA3jvZqUjqWzd4OIqvGM0Un8cvSzhcEo9bYt2q8f59pE8zSx6ZQrF8NDDIc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:191a:0:b0:6e5:62bf:f905 with SMTP id
 41be03b00d2f7-79fa29df2a0mr2918a12.10.1721433087010; Fri, 19 Jul 2024
 16:51:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:51:06 -0700
In-Reply-To: <20240719235107.3023592-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719235107.3023592-10-seanjc@google.com>
Subject: [PATCH v2 09/10] KVM: selftests: Verify the guest can read back the
 x2APIC ICR it wrote
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

Now that the BUSY bit mess is gone (for x2APIC), verify that the *guest*
can read back the ICR value that it wrote.  Due to the divergent
behavior between AMD and Intel with respect to the backing storage of the
ICR in the vAPIC page, emulating a seemingly simple MSR write is quite
complex.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/xapic_state_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
index d701fe9dd686..a940adf429ef 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
@@ -45,10 +45,12 @@ static void x2apic_guest_code(void)
 		uint64_t val = x2apic_read_reg(APIC_IRR) |
 			       x2apic_read_reg(APIC_IRR + 0x10) << 32;
 
-		if (val & X2APIC_RSVD_BITS_MASK)
+		if (val & X2APIC_RSVD_BITS_MASK) {
 			x2apic_write_reg_fault(APIC_ICR, val);
-		else
+		} else {
 			x2apic_write_reg(APIC_ICR, val);
+			GUEST_ASSERT_EQ(x2apic_read_reg(APIC_ICR), val);
+		}
 		GUEST_SYNC(val);
 	} while (1);
 }
-- 
2.45.2.1089.g2a221341d9-goog


