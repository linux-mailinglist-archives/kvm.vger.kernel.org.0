Return-Path: <kvm+bounces-41831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C504A6E120
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 18:40:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E11701897DBA
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 17:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785742641D1;
	Mon, 24 Mar 2025 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IA7hcS2r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097E226773D
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 17:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742837600; cv=none; b=UGjlO7wwmZi6tyYw30rKHXoBQd+ugoO2ew/x4fVLom+Z3dNjA6DoeZF8XkURu1ht2MfonA5tpro5UBFHcqauaj5D0G+o12FtDl95VO5PuLVuRmK1yBg/5an9cnq0yvEwvg1B3uCg19neWrM9rP+uiee7kj8+htAAPVl0PdvUseY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742837600; c=relaxed/simple;
	bh=b8kfH1giQMSXfOU3H4wI9RK8POw0T6oW++CyqKtBnX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iwYzSCMNVsET5+fw18iYPXGuemwYn2OL3Dci/5aH3j+mtg6/86Rku1CJaK/AnJH9+HN4WesjCTGVYcWvzfqgRUj3vOMV/PNS3rNrX5PZDxnQ6BC9dI2S/xT7yHmcv07SQNLp+tPQlyIOgoKVri8whXHoPe8NgJqM35mG/Tt6obk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IA7hcS2r; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff82dd6de0so6225653a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 10:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742837598; x=1743442398; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bMvztk4Ls/rO+e5Y79A5cu9f2ky21aF113lmuU+q7KE=;
        b=IA7hcS2rbox46IneULeeUT7ooW/SC3Kl4OLoLiTfiHgx9EoZScPA8Z2hfrVoTXbE1Z
         qZ71qmHX7FzbU4vMr03IqxXwwOgP1dAxD4ygoEIgIee6xE8bepwc+oeP61W8O/PK6XgC
         Wt2iCjdcxQFru3prWrGCMnLbHJwWJrBsnHB8ilCMD/sc7rfC8QkgbUKiRyW6NoKD6056
         K8sYqQneeUMSa7EpNYby36tTO+5ineU9F6PMqvLqsMhhxChin7PYPRUMHXr7YkJlkfw5
         Xgv8lFfn0qUAgdsZVa/a/G+uIntikYqD4GVdGQhbx8g8jqsSNu98+cx2alvYmMzx99xs
         T1pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742837598; x=1743442398;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bMvztk4Ls/rO+e5Y79A5cu9f2ky21aF113lmuU+q7KE=;
        b=TmA5gf3OvBN8uPM91zCwVsGoTs72IJB9V1/LbJ+7TsrlXKZP2KRWkdP0iY0Rh1kpc+
         MrBeSts+kQnexXkwxRUeMTBWiLx6cLSG3TA8HSCG9BsV1h4dHe4TqmMOyM7+SUJAcelh
         ErM1ihqUtpgVIGQLiLUZeLrEWquKKDnpQN0hSwl1KnJ4mef5wzo1UIcg8RDdYUh47vA8
         5DusHT34G8GU/Gh2ZZg81bfgj4jCW9jL9VOJFl/7u+ieKDDePXqo6z/UGGGmkBzEqbNa
         N4yldb1ZEFpu7xtONtjHhbgJw7jz5NmIo312ZNMG3CtkrsgB3kUnW+IPKMKLfzK4Rgj7
         QqTg==
X-Forwarded-Encrypted: i=1; AJvYcCV12SQkl8Wh20akBvLNYDK6+JUe3kQhcksGNOaj+OVtQv02UVK5OiJ9Ntup/IIATsDNJfg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh0cO5Q6IrphnXdv3y13M6HT4zE+NASyo9LWFiMsqcZaupGjSe
	AMlrbGKlVlx2kfbUT+G0jZd+a9gBsZvZG/E9BkaKrkF92yJL+wSw2O5oXt+Q4HJrT612nYaWfnV
	2RM2+Pg==
X-Google-Smtp-Source: AGHT+IFuXYKM2/ft8zmuifG//R7KBXVtO7yRI38c7kXk4CZuqSwM8AkIrVF15vqaI/zOHCFLN1phpoVdAyVd
X-Received: from pjd6.prod.google.com ([2002:a17:90b:54c6:b0:2e5:5ffc:1c36])
 (user=mizhang job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b4e:b0:2ef:19d0:2261
 with SMTP id 98e67ed59e1d1-3030fe956damr23161099a91.16.1742837598383; Mon, 24
 Mar 2025 10:33:18 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon, 24 Mar 2025 17:30:56 +0000
In-Reply-To: <20250324173121.1275209-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250324173121.1275209-17-mizhang@google.com>
Subject: [PATCH v4 16/38] KVM: x86: Rename vmx_vmentry/vmexit_ctrl() helpers
From: Mingwei Zhang <mizhang@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Zide Chen <zide.chen@intel.com>, Eranian Stephane <eranian@google.com>, 
	Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Rename the two helpers vmx_vmentry/vmexit_ctrl() to
vmx_get_initial_vmentry/vmexit_ctrl() to represent their real meaning.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a4b5b6455c7b..acd3582874b9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4424,7 +4424,7 @@ static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
 	return pin_based_exec_ctrl;
 }
 
-static u32 vmx_vmentry_ctrl(void)
+static u32 vmx_get_initial_vmentry_ctrl(void)
 {
 	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
 
@@ -4441,7 +4441,7 @@ static u32 vmx_vmentry_ctrl(void)
 	return vmentry_ctrl;
 }
 
-static u32 vmx_vmexit_ctrl(void)
+static u32 vmx_get_initial_vmexit_ctrl(void)
 {
 	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
 
@@ -4806,10 +4806,10 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT)
 		vmcs_write64(GUEST_IA32_PAT, vmx->vcpu.arch.pat);
 
-	vm_exit_controls_set(vmx, vmx_vmexit_ctrl());
+	vm_exit_controls_set(vmx, vmx_get_initial_vmexit_ctrl());
 
 	/* 22.2.1, 20.8.1 */
-	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
+	vm_entry_controls_set(vmx, vmx_get_initial_vmentry_ctrl());
 
 	vmx->vcpu.arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
-- 
2.49.0.395.g12beb8f557-goog


