Return-Path: <kvm+bounces-17724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C37D8C8EC8
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 02:06:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5FCD282121
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 00:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C10D517;
	Sat, 18 May 2024 00:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N5udJawD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA64928DDF
	for <kvm@vger.kernel.org>; Sat, 18 May 2024 00:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715990692; cv=none; b=RzxBLlU2AWtPsxsuW7qa3zfufd7NpvNJsf19zmOrDOQD5KGoMczIyewZLAIIMCPgdzckN8e15KaxlTWf3l3TuNJkcZRQGSKQy2n7zlYXeplnaVlH2m9rbjuv6Ccd8Ukzq3+SJNmfjN94JIDgi0+zOPhZ6jDeR8S7CslgsnTUJW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715990692; c=relaxed/simple;
	bh=d+HGE5FKbalq1IyET5esmBeH4ox7PVAkkfHJLMxz3xo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HL3GXWTaa7pQH6ewvURBDGtTM1byioPqCxYIRDdn987ZK6FfcOb1v//Kd/xabNaATsreVC0/FC31ZxVK/PQM2LkVzvvgN8tVidTc93F6lJSJbFBm7ZFZZpJ1Jjp76Y5fgLnI62drMAYrRgRUOBUzgEUA55Hj0Cp4k/OkoVdntQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N5udJawD; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de8b6847956so14590450276.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715990690; x=1716595490; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gllonWtr/HXeH3HBzo9n0ORhoUvXSPNion6U8aTZ5rc=;
        b=N5udJawDMf7x+Wc0ZtJ4eh90N7pmyDLFo1b5pAMHBK8FgD6X5BUdM637bDySWH55s4
         RnPUCFCFfLkZpAz7JLDAKzb/YAxGpxoqH+PLWrjWmsZlSsB7s4xiXhsAGYA/qM/HQIlb
         qoCmvoABa3T7dtjlRiVbvXPaxs6762Q9D6RUH7WZd/UXfCJoLtWxgGBPPJYetTDA2L02
         /4JoQTO1j2EiHm7FjAfIrRgY7CF8HAIIkYiN72CAKLP5JoP9RxGJKvO488d9si7AJ2Po
         cfQ2ffg9OAJpeyL7rS4+52tjJrW10HwUfqfMOgsDJg2P8HuAFFXNFPO9Ztm01ytZuv3p
         frsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715990690; x=1716595490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gllonWtr/HXeH3HBzo9n0ORhoUvXSPNion6U8aTZ5rc=;
        b=pa/KX64gC10jGiNRsBBcWqWgs4OiMHKy2p7wO4ng6AZadopYMAJIBLe0ze3FH8B//G
         XuQT6d0y35yi65y0Ytemygn7OaIMu17k8NXSDlai8uS2lQDquH+g/OD/dujn85u+1lDd
         KppRmY76pJUGOK2UJWmUrFH+GU3O2A+PaCbx+xXEG4uYpsivJrzlbeKug9QKum9V1qNd
         TGkAelVY8URdDkI/VIGZW9v+eIFyBIIAh7xTZUlU2tXtB9V4TnSd7hMAz2iOpJ46RoMX
         xc3iLmAPR7nSp78/cMieHCHtIBO9Kd4aRMm9fQql6HlM2SDojbBfRcprT0UvO9frMQrv
         vKmw==
X-Gm-Message-State: AOJu0YzIKovENWwRdoewcnKwEL0c22PCtKxCbE16et5ECCt5lXne5Iip
	Vb6vPIeHkE0v8o1Cl/Dzln18oKk2s8YOoN8uZhedVSxgjYufjMTHU45Y7E5H1BZ8hxtl/vaX9/L
	F0g==
X-Google-Smtp-Source: AGHT+IFAyinQ0ziYwYxNYFhEDBpRzcHlzA15Uvh759ilYWGg6F9fzj5Lm4hz9NDOEEtMykWD/Id/cx5EJhg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2d8f:b0:de5:4b39:ffd0 with SMTP id
 3f1490d57ef6-df49021cfccmr116977276.0.1715990689912; Fri, 17 May 2024
 17:04:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 17:04:28 -0700
In-Reply-To: <20240518000430.1118488-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240518000430.1118488-8-seanjc@google.com>
Subject: [PATCH 7/9] KVM: VMX: Don't kill the VM on an unexpected #VE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Don't terminiate the VM on an unexpected #VE, as it's extremely unlikely
the #VE is fatal to the guest, and even less likely that it presents a
danger to the host.  Simply resume the guest on "failure", as the #VE info
page's BUSY field will prevent converting any more EPT Violations to #VEs
for the vCPU (at least, that's what the BUSY field is supposed to do).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2a3fce61c785..58832aae2248 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5217,14 +5217,14 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	if (is_invalid_opcode(intr_info))
 		return handle_ud(vcpu);
 
-	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm)) {
+	if (WARN_ON_ONCE(is_ve_fault(intr_info))) {
 		struct vmx_ve_information *ve_info = vmx->ve_info;
 
 		WARN_ONCE(ve_info->exit_reason != EXIT_REASON_EPT_VIOLATION,
 			  "Unexpected #VE on VM-Exit reason 0x%x", ve_info->exit_reason);
 		dump_vmcs(vcpu);
 		kvm_mmu_print_sptes(vcpu, ve_info->guest_physical_address, "#VE");
-		return -EIO;
+		return 1;
 	}
 
 	error_code = 0;
-- 
2.45.0.215.g3402c0e53f-goog


