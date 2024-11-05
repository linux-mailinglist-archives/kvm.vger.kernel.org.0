Return-Path: <kvm+bounces-30584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D19AA9BC251
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 02:07:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 902D2282F78
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 01:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5B774059;
	Tue,  5 Nov 2024 01:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O+dDM6zL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF99052F71
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 01:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730768788; cv=none; b=ACOWVs2cLlD/CNGnRlQxst2e6Ib/v/7fGkwI+Lxs1TQY4y8qwX/vXxfzFqQ8lMoPv97E0FiQwBm4EaMYuFqiea6b4rOH22dzpQ0yVedLn62ihtWAfwpk0FnNquD1hhq1Gyg887D0P+iDwMaHZwPaHLsyMjP6RKTGFfyoSa4Acm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730768788; c=relaxed/simple;
	bh=PrkZM6Xy8UF0mEloWiv1/ygTi//WCDu6vFaQAcQxgaY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VBDv2dwMN8ClT8VFuhR2dlndCT7UrA+ZksEZ8sSLARij6AbsfnU8pvMGND6+G0Q+6uJ5GDyIn8hyQzKzqCZSdhfkLTdz3Kdvebdcb/yvgupB8jZWzO9eh+tdUNj30THxH4hDmZvWrvCfh0Yp8DotCQHUOctFTBPFZQLKMNDbIsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O+dDM6zL; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea8a5e83a3so41125557b3.2
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 17:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730768786; x=1731373586; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JS3XxluJTES3Wiur3lmc4TEkrd8MuXF3kmtmu8pwE5Y=;
        b=O+dDM6zLw62e/tcs6Q7rF+NuDoPAnnY/2Vhfa9sUZQnZFrEx1tZTg7OjYSmGPvmwfw
         44Q+9fdXv4I+kzh4ipsZ/mxRWwUMD6fvwFZ0bb9zIPypP2C7gqmfpRoab5ooLcR3xXZP
         vIaCaTeg1EPLv0ssuMoiL/C0n0CtBL/tNbdNdvXEBLQ1SfDA9pwdBRSBhTS3+jE5iKue
         kmx3o3f6EBrjXOrdbQ3Z4D8nuxy0XCbvOg9L9Kt8k71+f+MYcRkb1IyhvClDfPaSxbRG
         gTVZFTCAO3JLi0dbGhbTvKTQv0v9o9zDTjFz43bTzsBj6dRAXmi88JmOJdeeU2mfedsy
         zDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730768786; x=1731373586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JS3XxluJTES3Wiur3lmc4TEkrd8MuXF3kmtmu8pwE5Y=;
        b=O1cKUSrRTJcC3vS3QSEKub0rsw7OJbyMfdWTa7kK2D5CI+iKD2Orv4oG7LUoHeOkwR
         5ffW6VB/0lleW88GbtU7s47M/+LLuwkhGPNSdr9G8+oIoqCKWu7mBzE7MYEKsrs6V2wN
         5WHwdYNiIUqxiOEtWN6OewYsPysZp4SYcZO5LCCqNmQtP09vHJYmlJt+kFovS6hu1dVS
         jaYgoKzKIs+LgHIKM5cPdSCNdouzBkdquOAgCcaN8VdmVl/FgJVHZetcMOS7/oPuFHBI
         x8PdXE+SfEFtDDw+jK1ZoDM4Ck6pE/YtquuFzoKmxpylZB9mzv5lOZY1xaOF9+zYXkhU
         aqQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAGL4Zng/sxEWIeYQrxMAKJCsGfpW2GMp4Pr/8fXAs6nuuOy9hfbhKAmT1boCP0M4eWWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0IWP+OBkdd4sRr3mhBB0q5+ZNg9Ak1DZxYp7PHSFrrpGAmavn
	ttmn1EIy+LwXrJlzKHFDN1sp5Q7HcmjNMT9KIXN55Gj7L+UgylsDUh9aFI5ZN3JPep2PbrMEV+8
	JQLxNkT9DpLB6LIPh3BxNBA==
X-Google-Smtp-Source: AGHT+IFO2JgTdSt2JVSAlE6aLJiAl18hccyke07Vi/GlLOEcPNFzRu1IUPbLnPUPUc1RIzAgyPoMizpEQTsA/tZYFg==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a81:a8c6:0:b0:6ea:7c90:41f2 with SMTP
 id 00721157ae682-6ea7c904377mr279887b3.6.1730768785769; Mon, 04 Nov 2024
 17:06:25 -0800 (PST)
Date: Tue,  5 Nov 2024 01:05:53 +0000
In-Reply-To: <20241105010558.1266699-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105010558.1266699-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105010558.1266699-7-dionnaglaze@google.com>
Subject: [PATCH v4 6/6] KVM: SVM: Delay legacy platform initialization on SNP
From: Dionna Glaze <dionnaglaze@google.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Dionna Glaze <dionnaglaze@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When no SEV or SEV-ES guests are active, then the firmware can be
updated while (SEV-SNP) VM guests are active.

CC: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: Ashish Kalra <ashish.kalra@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: John Allen <john.allen@amd.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Michael Roth <michael.roth@amd.com>
CC: Luis Chamberlain <mcgrof@kernel.org>
CC: Russ Weight <russ.weight@linux.dev>
CC: Danilo Krummrich <dakr@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Rafael J. Wysocki" <rafael@kernel.org>
CC: Tianfei zhang <tianfei.zhang@intel.com>
CC: Alexey Kardashevskiy <aik@amd.com>

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f6e96ec0a5caa..3c2079ba7c76f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -444,7 +444,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (ret)
 		goto e_no_asid;
 
-	init_args.probe = false;
+	init_args.probe = vm_type != KVM_X86_SEV_VM && vm_type != KVM_X86_SEV_ES_VM;
 	ret = sev_platform_init(&init_args);
 	if (ret)
 		goto e_free;
-- 
2.47.0.199.ga7371fff76-goog


