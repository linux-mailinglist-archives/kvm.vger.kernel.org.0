Return-Path: <kvm+bounces-9574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2950861D7C
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:22:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48C311F22DD0
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 20:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8250314AD04;
	Fri, 23 Feb 2024 20:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s9ot/QOo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9EE1474A3
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 20:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708719671; cv=none; b=K9rPdmdqvp9C1u8qnHbQtHu3jsWVUcZuppBVRuvXPyoeP8whwt41+9VT/ffZ3vJzbh7qjF9m5GMZM9TK+vGmVcFKQQUW4Q0ijF4CUaldbSwnZhCiEZZbR7eYmseprsDW2GQ+kagePg7DiaaIP9NMiwda/HT3Uqw8RABAEEIT6fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708719671; c=relaxed/simple;
	bh=IrRclgLzERlFlNP3VGcOQL+Anfa9GPiQX9sm7E4iwZk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HvM2ezIPLN9eAeWbSKxiaWlJS/MiVwetMEp+6OE4Nol06ClEAU5s23J/n51De0c6LHGnWzjcslr3VFgEZ8F6uHXMbvX5d9RhWdNybiLxH2SWVTn+LminzFUCyxcF3jaYR4yIGb5l/i1o3ho+eWxXCMmGN3waDbbGnBmpWP9h798=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s9ot/QOo; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6085e433063so13100397b3.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 12:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708719668; x=1709324468; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tyPTLCifBbTehT1oMnj3LiwEaJbfgbwYwJXO5JYENtY=;
        b=s9ot/QOoa3Gfu8c/XqMU2eC8Y8M/mOM1VmZOxKhVJ7MX7yahmorYt8RghSP+suf3pq
         nIaILba5/ltROBxUv/YuZTHn74xfHGScNNp18IC0sqB5XkemZ7l6oOOqlOIGiThvSmWQ
         w/jZvmWnQ94y6AqDtToVqLQ9hLvPtBjUoy8+iZR7WkF9QpR3fMvsJIDsXwPlhCA0Toz3
         FO/XbB8cBJIHHrzNRL3PIuE8oS1SrSwGyzrdVchZPaKwJzxoyYdCTEeZUuBR5qVYsrJE
         MXy9/3koG4Yec2yU14jBs0U6uRUh4sFjXKLIwihqmTlboOdNNlXl4maQmbSOSZ2V6Iph
         PpOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708719668; x=1709324468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tyPTLCifBbTehT1oMnj3LiwEaJbfgbwYwJXO5JYENtY=;
        b=LDWYaplejRfCu27Kn15urwqe6rl/r6vnIDfEunCvz3zcN86PbObmaZp/E5vbXULvmM
         Ug1vBlt3ffTCZ/ouBOeDV8/0er8lFXCufLPe5KFCP9FhJKQDqvJSbbfywX+Tz+ida1b0
         4rTQrIr4atASzeg5Ff4hFHVaIct506/krG/0M00k/RWqKU2RVnSfjRoCyUSJjPdihS6M
         T6Vx9vkLmUY1s7Lf+TXneZo7I5RFWZ7vD+njbbRc4w7J14lOQeGr5jCwo4GDtKKgs1aV
         Dv6UBn8JLYkuFLbjr5CbAFZF1vXpYnBbdkSKlCvLurTCG90JsSDBDZB87rY5dktKwWaB
         WCRA==
X-Gm-Message-State: AOJu0YwPDiwjRWgaqQRqckdTAU38Eddvc3a5YUP+Q+ujTVPLt95WevvK
	MzycK0bpzBUls/s5ibVbsIVL64vlp3/FLeR0KeLHlLkK6KnehqKoEAEGmbZFREY3hHaxNxKtBiT
	zKw==
X-Google-Smtp-Source: AGHT+IF9y2LX/GowBwnsObnVF5LY5lnupji+R0Pc3uuOz/2sQmJyZWA6tQRtsv5AbW/QaJBt3M4LGGReTmA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5189:0:b0:dc6:d3c0:ebe0 with SMTP id
 f131-20020a255189000000b00dc6d3c0ebe0mr239480ybb.0.1708719668602; Fri, 23 Feb
 2024 12:21:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 12:21:02 -0800
In-Reply-To: <20240223202104.3330974-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223202104.3330974-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223202104.3330974-2-seanjc@google.com>
Subject: [PATCH v2 1/3] KVM: VMX: fix comment to add LBR to passthrough MSRs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>
Content-Type: text/plain; charset="UTF-8"

From: Dongli Zhang <dongli.zhang@oracle.com>

According to the is_valid_passthrough_msr(), the LBR MSRs are also
passthrough MSRs, since the commit 1b5ac3226a1a ("KVM: vmx/pmu:
Pass-through LBR msrs when the guest LBR event is ACTIVE").

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9239a89dea22..7470a7fb1014 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -159,7 +159,7 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 
 /*
  * List of MSRs that can be directly passed to the guest.
- * In addition to these x2apic and PT MSRs are handled specially.
+ * In addition to these x2apic, PT and LBR MSRs are handled specially.
  */
 static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_IA32_SPEC_CTRL,
-- 
2.44.0.rc0.258.g7320e95886-goog


