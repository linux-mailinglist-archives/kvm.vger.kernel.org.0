Return-Path: <kvm+bounces-37041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF09A24666
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:57:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E295188830D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83B83154BFF;
	Sat,  1 Feb 2025 01:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ixcVm+kT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8F314AD29
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738374933; cv=none; b=sxN1jZ0mbGNDzK0JN+dtM4S5DtzHEJhVxVf1Su0m+hI1Ho9BbG8JzIAIBbx+YpalDI2OVkJprEfyu+htuY1YcbVL9Qwaupcs3QYs2Dz/Rivyi5J4mxQ/5IImPGKoce0swHAcPvSWiihM+vDeo47GAT8CfZFAL9Por43Nvb0tpr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738374933; c=relaxed/simple;
	bh=vmEbPbxbMS9aUOXfyT+ZSZRy/eMxMmE8Iua31butyQA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lbsg7mGl/03glSmQFKqkHvwjwryYypZc0ouJtl6ZIQk8Sql3eNVVCr+HYjhQEfUyJrmFQmgCoMKkLgqDqx37TMy5zOmSaMs6OhQmuXx6wVwFcebRUPVliDoPmbsv5kGXxc0/ojDV2KWBrqHtSb8OPogYLFtM7DpbLk1KeC1JDRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ixcVm+kT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef728e36d5so5029845a91.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738374931; x=1738979731; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SSq5rYLAYG2vKFAF70mfCTOkmocHERBtCqn9i2vcAtY=;
        b=ixcVm+kT6Brw2ZztMSq1Qyqza4qGWq2GYtbj9GQ15xl8XlxP79inYPtXDjRukspZ8f
         BQBwUFx+MGdJQA4lWbdCCEgjY25fvewS4POj/zc9S0w4T8THjpMDNkNa088ALea2BZ12
         1sfHiQTshHN6rcm7Vqikk79brVhKjGDzZpDAraJc8CmfOT3bSiHFdpwpK9BG7KYX2xVU
         npj5+6oIbaviw8k/1FZp6j9z16axRIdh5tEvZLLgEMjfvOahLknWXdYSSL2Xk1tThzDX
         5p6rJ0+vej5A6ruM0M7xZg9nvbUEk77sVdZng49Q+g2C7Ld9vbHEXrIEg5h85OQmoRR9
         8Ogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738374931; x=1738979731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SSq5rYLAYG2vKFAF70mfCTOkmocHERBtCqn9i2vcAtY=;
        b=Ix49MZvAuOmBi056Dvn6hpuB/0Of+gbrYG89NSXLgn79wyNGZRIgQhuZ2finoeri3J
         SBCSlL4j2YpI9oEqSoLrN8tr0Qe+uTIAdn/tgGs9WKr2AmrSicbuLUBtisX+Sk1VGkXb
         kthixvfVdWmEBnh6K8ydDgaeLQaG2cQ9Aqaevbqi4VUbsCBiPr/xZxiheOpyej85KNfD
         btt8kawMgmkgFvOXZbh6JdKPKXA/WFDq7SZgVvGS/d4shH//TVg2NSlQaEVWNx+q5h7f
         odvOMg5WX15EhlouQ9/sXmA68T+vSbInmb778FJ1qNQJZjgD4bfHG9YLxsMoPw9WzJFY
         1HpQ==
X-Gm-Message-State: AOJu0YxlIyqTBTz0jZ6QCExhvfsgLGfmxB1DaLcl6JHiI5/6ZB1Cd2CM
	ZYxKJEi7ldwRJ69q409XRidKBSvrsIKrsDSJVk/+kaxMgy2muCpBkD2M/PnqDzQm8t2IJvVZ6U/
	19A==
X-Google-Smtp-Source: AGHT+IEFpzfH3dkO4+Y860/dfQ4O1AiD1t9jfO7r11k85kQFFgtWqnFjO6ht6BavxIM9aAIGs8WsY8WQD2s=
X-Received: from pjbeu6.prod.google.com ([2002:a17:90a:f946:b0:2f4:47fc:7f17])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:390c:b0:2f8:4a3f:dd37
 with SMTP id 98e67ed59e1d1-2f84a3fed3dmr12867960a91.16.1738374931514; Fri, 31
 Jan 2025 17:55:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:55:14 -0800
In-Reply-To: <20250201015518.689704-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201015518.689704-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201015518.689704-8-seanjc@google.com>
Subject: [PATCH v2 07/11] KVM: x86: Plumb the emulator's starting RIP into
 nested intercept checks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When checking for intercept when emulating an instruction on behalf of L2,
pass the emulator's view of the RIP of the instruction being emulated to
vendor code.  Unlike SVM, which communicates the next RIP on VM-Exit,
VMX communicates the length of the instruction that generated the VM-Exit,
i.e. requires the current and next RIPs.

Note, unless userspace modifies RIP during a userspace exit that requires
completion, kvm_rip_read() will contain the same information.  Pass the
emulator's view largely out of a paranoia, and because there is no
meaningful cost in doing so.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     | 1 +
 arch/x86/kvm/kvm_emulate.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index ca613796b5af..1349e278cd2a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -480,6 +480,7 @@ static int emulator_check_intercept(struct x86_emulate_ctxt *ctxt,
 		.src_type   = ctxt->src.type,
 		.dst_type   = ctxt->dst.type,
 		.ad_bytes   = ctxt->ad_bytes,
+		.rip	    = ctxt->eip,
 		.next_rip   = ctxt->_eip,
 	};
 
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 49ab8b060137..35029b12667f 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -47,6 +47,7 @@ struct x86_instruction_info {
 	u8  src_type;		/* type of source operand		*/
 	u8  dst_type;		/* type of destination operand		*/
 	u8  ad_bytes;           /* size of src/dst address              */
+	u64 rip;		/* rip of the instruction		*/
 	u64 next_rip;           /* rip following the instruction        */
 };
 
-- 
2.48.1.362.g079036d154-goog


