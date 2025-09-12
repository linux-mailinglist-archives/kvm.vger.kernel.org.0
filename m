Return-Path: <kvm+bounces-57467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E32EB55A2E
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:31:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FE0DAE2A2D
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 979C42DE6F9;
	Fri, 12 Sep 2025 23:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fEkd+vF1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7832DCBF1
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719449; cv=none; b=ALJpA815Ot5yqF74A0oyDNDwCRcg4EmaN4At0Xbi1ZLs/SpRKnEae+rHJFRQQvnY+me/ukTDpX+evFAP/96N+eQySQo6ggZDsDRUnP1N7ccdgdEFSaMGC1dm/HS86vNQkvk7iAwuddibIfQqgux9jFclvZTPuIh3PIJriNxKEOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719449; c=relaxed/simple;
	bh=u6obytA8jhs+D5XP44Ibf3Fk/tIoJ+TGc9bGl3L5dOA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eYiHA+hL0hI6h9+EzXOUaYzgxJrXY4qBuWlZjwgk+uPI4FIYO3cKerCidlVKwnl6xzkTnNHo5GP24DsVkcFcAvxUB0WKjKHe4U/2UtgqioxyNTZJKg7wW93a7q2xTcw8Q74pCWh7WlJS+lPe/h8E6YdfSYgvaF+0DGnmXDNfUVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fEkd+vF1; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b54ad69f143so1604021a12.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719448; x=1758324248; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=I6bEobPpCMUaQNNOaa/Shf0wUDSFQDd5DVDJT0PcEeY=;
        b=fEkd+vF1uXlXWQlL5n5rB7p6V/wmiFHeScwumb42Pi6ONvBrTX7K82Zz1i/dkG5dK9
         +BVtbHPtIW32PIv+JwN0t3n9aEeohMghhEE67eH5//5/nTQ0gcHBpxu+qLl1HmRjaqdL
         M6lKONCQO1vJYcjJd9bKMrxzD75LsJc8chluSjcqqYLT2hLdg7CIsYA4yFDi4zZxhZXO
         MTY/7MYHS63Nqcvypk6dwqODwOiIdHJMUoLvNA7cVVjwHJrZ9PLio46w1g7TWiiDrg4u
         DU2+eldi6IE6IQcOzeaMoO3jkEW0j/uyM1jSJ910xRnDC0rk4oRgb+aUsvCiLQd2pX9b
         KDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719448; x=1758324248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I6bEobPpCMUaQNNOaa/Shf0wUDSFQDd5DVDJT0PcEeY=;
        b=PqmvYv4aKluai7jNzplVIMz88zh6IXgYMyb+RwsnTeSSY/YMASo2LeKoBhMHN3k2fn
         1/ZghNDHla84A+nVe/DCcX0kWtU6yatBLdW4WxXgPWWESfp2mFi3CbQpOnix7Z2VmCJy
         ChrUDIAShFtVBR+Q+cOPNmWktPIeGpAYAONPWdajEJog5JfIulQtSw6IPomFVd3Q1Mad
         5xe7LyplyNPm7witwB4C0GlnAgvMF+hdJQ2h3jpK59ib+zAdjlmL3LmpoPcZokplzcsp
         P+VLTTV+wTHGg9v+nCYTdroc7BsU7su+ta+vllqKw7jAwezK4O1SdNcFtTUDiGpjqOJJ
         q7Lw==
X-Gm-Message-State: AOJu0YwGZvfUNTlCCvfJKJu3KdqoCEMTVD9WEYR7bzhNGAP5qGIweB5G
	4POg5IRPq+U8DeKBWbCgkA4vi2PgKrFV33aXIXaxv2AMtYXr9n0G0WQTRXur30GCrvIeDcT6fb9
	K+9XYaA==
X-Google-Smtp-Source: AGHT+IHtj+tfTTkNWx+nJoIYfR+Z5Mexj4eaI1LLzMLxspdIKr6yZiJ5WzcH128cOWOdI+CaPgk3IhWMyJs=
X-Received: from pjwx7.prod.google.com ([2002:a17:90a:c2c7:b0:327:d54a:8c93])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:72a7:b0:24e:e270:2f4d
 with SMTP id adf61e73a8af0-2602cc1c69dmr6233860637.52.1757719447756; Fri, 12
 Sep 2025 16:24:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:02 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-25-seanjc@google.com>
Subject: [PATCH v15 24/41] KVM: nVMX: Advertise new VM-Entry/Exit control bits
 for CET state
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

Advertise new VM-Entry/Exit control bits as all nested support for
CET virtualization, including consistency checks, is in place.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index edb3b877a0f6..d7e2fb30fc1a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7176,7 +7176,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -7198,7 +7198,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
 #endif
-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
+		VM_ENTRY_LOAD_CET_STATE;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
-- 
2.51.0.384.g4c02a37b29-goog


