Return-Path: <kvm+bounces-9436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C1CD860241
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 20:08:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5533628D495
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 19:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C676AF88;
	Thu, 22 Feb 2024 19:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XSBf7+zj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5CF14B824
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 19:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708628806; cv=none; b=i35GhdEvtOuiKFi4XTUHXSvEU1p5L8hGq3OjWwcX49MgK4cwBU+NjdBMUQCouJo/oChICfMSqYl0r4jT+nivHUURtR/LP9Y2+/kv7ME2wtfYRkgMOSLXHyTN2lhTZo6Ldwb5mlsZqkHiwJYBo69iyTlahWPwwQd/4/obEaKFeCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708628806; c=relaxed/simple;
	bh=Lpr6OXMdJrHRiK6NwVBpGyZp/lhKwMDMfWMCx4WLc3E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rmg2x5+PlGAXUxsd7JD3mAUVnliZnwHbuIi47/rWaGX7vTFSPdO/YPP2GhiG1LmYehwkHf/yn2IYjNRXSfK+0pB/Yl0rms941QRLUc1Eq3fvjbYZoI5H25VwHXz8298Xvp9Tu/QWDR1m+NVWNBlc/41YmX97Sfd7FvO0Myt9e6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XSBf7+zj; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-603c0e020a6so1176107b3.0
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 11:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708628780; x=1709233580; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TYSivnN6sKEY4CZofc9WbYnjIg5hjEEjj41nwAaSQHo=;
        b=XSBf7+zjqQSIdpqoyLdYZLXRBC8iVe9qqogTHUaBn57Ovayhzn94jJFmygn3Zcr4Ac
         V81jFQbw9uesISW4op0RXFqQ5VdLV/HFSoQMgT2F9cyXbcgC41UpHUEuMTsrIOESuQ8y
         tXXqOls0CCgznvtf0okfVtRp4miaFDLaNVNepblvY6Scs59lYYEy29yNVrwJF5fxGDpy
         wU+9Wev99fJvjYZ1taG7kkLvXLU9vnb7mGQyFIJ/qr3VUX+KCGweZjS/Wz1vrtiYi95r
         v0A5hzhGtLDUgKFWTwP6/5NKLqZrhp4TMNIpGvo+nihezpIBbEPgpDCLO+OELV9SDIlb
         qPqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708628780; x=1709233580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TYSivnN6sKEY4CZofc9WbYnjIg5hjEEjj41nwAaSQHo=;
        b=t/nuonwdwmg6rEPTdbkTO6WxAbUBIHD22sN3oki1zhAI9bz41qH1ELRM77bnlT92in
         UPVdJg3UUe4c3igpNI+WSMYZppZCwOwFFYhQ8R6n9kWHqEeT2nfxHrNG2UJNCm/Eoo+A
         GA8CKSvniGOHOZSFtOnQuAhZo0E0nCJoz5uEhVGMwETzIsaCkp2JpLYP1Rtr5icXdTfr
         fFh5NzjrilRzpQ50dUKOhK5VjAFZB/9TEZeB+TFpfaakgTuBvY4bPGfo2046EOq2e50b
         n8IZZQwuzbzbEnSRMci8Oz4cHsgCqaJqvshpPHUGb8tCfVlyx479P0zEYcbXK+pfrdwi
         TDNA==
X-Gm-Message-State: AOJu0YxFCKR/JlCUdIsejx/uT8DrNuvbdDFt6qij27nCwqoFwAFIKqYe
	TPePBYu+oP434v+xsC8i36sKvwemJ1uiLd6zLZc8ok1RcA0fJk4Q35wlZUIXK8CGrRmXZc5nr2G
	1uA==
X-Google-Smtp-Source: AGHT+IF9Ke/e46sWIPIrRAm77GXHG7bR55ds8AD8pgXpkvpOO/ZmmJioMfPOuwxYZiWeh9v80/lCewALitw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18cc:b0:dc7:6f13:61d9 with SMTP id
 ck12-20020a05690218cc00b00dc76f1361d9mr1123ybb.4.1708628780537; Thu, 22 Feb
 2024 11:06:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 11:06:10 -0800
In-Reply-To: <20240222190612.2942589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222190612.2942589-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240222190612.2942589-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: x86/mmu: Restrict KVM_SW_PROTECTED_VM to the TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Fuad Tabba <tabba@google.com>, Michael Roth <michael.roth@amd.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Advertise and support software-protected VMs if and only if the TDP MMU is
enabled, i.e. disallow KVM_SW_PROTECTED_VM if TDP is enabled for KVM's
legacy/shadow MMU.  TDP support for the shadow MMU is maintenance-only,
e.g. support for TDX and SNP will also be restricted to the TDP MMU.

Fixes: 89ea60c2c7b5 ("KVM: x86: Add support for "protected VMs" that can utilize private memory")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86d88bc7a6d0..1e0cc1906232 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4580,7 +4580,7 @@ static bool kvm_is_vm_type_supported(unsigned long type)
 {
 	return type == KVM_X86_DEFAULT_VM ||
 	       (type == KVM_X86_SW_PROTECTED_VM &&
-		IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_enabled);
+		IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_mmu_enabled);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
-- 
2.44.0.rc0.258.g7320e95886-goog


