Return-Path: <kvm+bounces-72868-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GBlzLvm7qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72868-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:23:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F9702161AC
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8D56631C1B4A
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78A73E51F5;
	Thu,  5 Mar 2026 17:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ojK0VK/q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACDB3D9057
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730779; cv=none; b=JpcP+lpvbiYem/Y6vRR/oPf3BsVtvi2h8THm6xc9imp39ZyXBfeUbDZ0sEady5KsBqkHgskdv62T4HTK4AACH2T29eLjxiNnotK0ieCoic7neKURxoCWs1pCEXyUQ3lL/AaZ1Pir7lcbkXLFzvafOSg6YuxxlMhDGfRBKqIF5PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730779; c=relaxed/simple;
	bh=tXshdTamdQq8bCwMbZwK5zrOSjTMdyTERyv2zA9Rl6s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Euf2/YsUyRNza5MDJPOwp6BeXopeN1Equ1H+W1SSf4cFZ0zHap0Ig1v2AY2PApGw7VL7GfZhocBgBa0BFxJonNlis2nSMukwotnn4J3BKaAeTEDBC6zsklmJxln8GU2WDMOAbbDHJzXgPnTAfrHqFQ2OndgzRZJYAkGkNwVlCz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ojK0VK/q; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3598007eb74so26335693a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730777; x=1773335577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dn3NZilXhEkDTBFVcyT+W3PJ5Z+jM6pVvw1VzNRzvMU=;
        b=ojK0VK/qR50KMBRW1FffLT6xK5WpKnsYimptHCNf3l+RnAXxGfy6KnpjMxVxLxRGTm
         mhtZnbdLvBne1tqgku3Klrhe2GRulmP8GVkk0fpz6VckPfwE3318euE7nHF/skoCbO60
         zDnxK4173VCc5RYGjY33/0DUFbWJbmJsJhmklaHutMe/ysf7y7o3pZPFR6QzOBVJk56M
         /MPq0r5Z/8dkPc1QJHu5Bj5FA66czji33/pNE8ZN93E0a5LSR6Vg0nS9HChqe64QyBGV
         vjEy6iQiYvogH3XUFzt3UTEzYm5qyIkCKqH9N32g6zTqCUWZhJhAxlOTBnyO/suPEsH+
         Gd6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730777; x=1773335577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dn3NZilXhEkDTBFVcyT+W3PJ5Z+jM6pVvw1VzNRzvMU=;
        b=HgaAYjMkpKIOIR8IFFuI0Dt5uRCaulgWfQLeak1fkNisvRQCQZTrD+iyBjl7pAq2Hp
         Vxt51Fa01by1HX9J5IhDt65Ds0aXNeH3EZFPOMIm3ZY7z4Bve8CetJ9FRet4949O/kHR
         tn5LEiapaaxhqXFHy7nubGZ5wvvuGxqRvpsriQFhjHTfQAzu6r7YNI8HlxQ4ItKjQZST
         m1k9s00bAjDTmlkijmmQXpSMPMmJ8EQe5uqutlld2DRV//HD10ATRhzUXJs2qw9aL0Ph
         2O6ms8B/zKxJeJrZ/8YgCBJ/JxA2+pArN4ZQNJ1qWz+TyEqZheQQOVqmRw/aDBD/lak1
         C6ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9+9Z1cNVOvSEWF23syTwntz3FXrelVzDvEAnNhpiufJGC/0fSM02Mruf90W+7P+qqx4k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTUYVnwtE1ivyfvnLgjA7WpnDthEpVxkCWNI8TwtgZ9i0xCWsL
	0fylosw1Y+LrA/94zo67f9k+JDyNKQcoTmFoyE99rJE8f//AjeCbAtKiu5f4mHo0qg1ZyyOhlb8
	gplhbjw==
X-Received: from pjoa5.prod.google.com ([2002:a17:90a:8c05:b0:359:8c74:aec4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2fc8:b0:359:8e1c:542
 with SMTP id 98e67ed59e1d1-359a6a3c1ddmr5815717a91.18.1772730777388; Thu, 05
 Mar 2026 09:12:57 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:25 -0800
In-Reply-To: <20260303003421.2185681-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272552677.1536346.5631416946196901652.b4-ty@google.com>
Subject: Re: [PATCH v7 00/26] Nested SVM fixes, cleanups, and hardening
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 1F9702161AC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72868-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Action: no action

On Tue, 03 Mar 2026 00:33:54 +0000, Yosry Ahmed wrote:
> A group of semi-related fixes, cleanups, and hardening patches for nSVM.
> The series is essentially a group of related mini-series stitched
> together for syntactic and semantic dependencies. The first 17 patches
> (except patch 3) are all optimistically CC'd to stable as they are fixes
> or refactoring leading up to bug fixes. Although I am not sure how much
> of that will actually apply to stable trees.
> 
> [...]

Applied to kvm-x86 nested, thanks!

[01/26] KVM: nSVM: Avoid clearing VMCB_LBR in vmcb12
        https://github.com/kvm-x86/linux/commit/b53ab5167a81
[02/26] KVM: SVM: Switch svm_copy_lbrs() to a macro
        https://github.com/kvm-x86/linux/commit/361dbe8173c4
[03/26] KVM: SVM: Add missing save/restore handling of LBR MSRs
        https://github.com/kvm-x86/linux/commit/3700f0788da6
[04/26] KVM: selftests: Add a test for LBR save/restore (ft. nested)
        https://github.com/kvm-x86/linux/commit/ac17892e5152
[05/26] KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN
        https://github.com/kvm-x86/linux/commit/01ddcdc55e09
[06/26] KVM: nSVM: Refactor checking LBRV enablement in vmcb12 into a helper
        https://github.com/kvm-x86/linux/commit/290c8d82023a
[07/26] KVM: nSVM: Refactor writing vmcb12 on nested #VMEXIT as a helper
        https://github.com/kvm-x86/linux/commit/dcf3648ab714
[08/26] KVM: nSVM: Triple fault if mapping VMCB12 fails on nested #VMEXIT
        https://github.com/kvm-x86/linux/commit/1b30e7551767
[09/26] KVM: nSVM: Triple fault if restore host CR3 fails on nested #VMEXIT
        https://github.com/kvm-x86/linux/commit/5d291ef0585e
[10/26] KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)
        https://github.com/kvm-x86/linux/commit/f85a6ce06e4a
[11/26] KVM: nSVM: Clear EVENTINJ fields in vmcb12 on nested #VMEXIT
        https://github.com/kvm-x86/linux/commit/69b721a86d0d
[12/26] KVM: nSVM: Clear tracking of L1->L2 NMI and soft IRQ on nested #VMEXIT
        https://github.com/kvm-x86/linux/commit/8998e1d012f3
[13/26] KVM: nSVM: Drop nested_vmcb_check_{save/control}() wrappers
        https://github.com/kvm-x86/linux/commit/b786e34cde42
[14/26] KVM: nSVM: Drop the non-architectural consistency check for NP_ENABLE
        https://github.com/kvm-x86/linux/commit/e0b6f031d64c
[15/26] KVM: nSVM: Add missing consistency check for nCR3 validity
        https://github.com/kvm-x86/linux/commit/b71138fcc362
[16/26] KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS
        https://github.com/kvm-x86/linux/commit/96bd3e76a171
[17/26] KVM: nSVM: Add missing consistency check for EVENTINJ
        https://github.com/kvm-x86/linux/commit/7e79f71bca5c
[18/26] KVM: SVM: Rename vmcb->nested_ctl to vmcb->misc_ctl
        https://github.com/kvm-x86/linux/commit/1aea80dd42cf
[19/26] KVM: SVM: Rename vmcb->virt_ext to vmcb->misc_ctl2
        https://github.com/kvm-x86/linux/commit/7e6eab9be220
[20/26] KVM: nSVM: Cache all used fields from VMCB12
        https://github.com/kvm-x86/linux/commit/84dc9fd0354d
[21/26] KVM: nSVM: Restrict mapping vmcb12 on nested VMRUN
        https://github.com/kvm-x86/linux/commit/b709087e9e54
[22/26] KVM: nSVM: Use PAGE_MASK to drop lower bits of bitmap GPAs from vmcb12
        https://github.com/kvm-x86/linux/commit/a2b858051cf0
[23/26] KVM: nSVM: Sanitize TLB_CONTROL field when copying from vmcb12
        https://github.com/kvm-x86/linux/commit/30a1d2fa8190
[24/26] KVM: nSVM: Sanitize INT/EVENTINJ fields when copying from vmcb12
        https://github.com/kvm-x86/linux/commit/c8123e827256
[25/26] KVM: nSVM: Only copy SVM_MISC_ENABLE_NP from VMCB01's misc_ctl
        https://github.com/kvm-x86/linux/commit/b6dc21d896a0
[26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT with unmappable vmcb12
        https://github.com/kvm-x86/linux/commit/5e4c6da0bb92

--
https://github.com/kvm-x86/linux/tree/next

