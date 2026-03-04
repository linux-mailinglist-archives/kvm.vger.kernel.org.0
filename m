Return-Path: <kvm+bounces-72698-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EFeiN2BcqGmZtgAAu9opvQ
	(envelope-from <kvm+bounces-72698-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:22:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ED9B20422F
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:22:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6291630074BC
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 16:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C26D3644D1;
	Wed,  4 Mar 2026 16:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Laluglbu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49ED3644BD
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 16:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772641350; cv=none; b=qwEe0+QP6pBY/CAKy2aFlIIQGI3YIihmxaXy73Xuxo5f1DyvKp7n1vT4Cq2qgnZdtGAgYPKPcAZ+irPj+JkddnkymBv81RCn2Gi9lxjo3zHS0jQFbSVGn0QnKvaY2Uvn20adDWOlChB1UMOBPNcK98UVVPAOsTEURpCXk4YN5Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772641350; c=relaxed/simple;
	bh=LYtSjN2RhqcKr3aNj5Cb08Kuh0Rl1UyF8cnoKSiyKPE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tYQQY5ES1pnb3Cbi8ZNCRoP217QOCZR9uvwLmCn0bnndexjVH0FQbf+tOpNuRrOepV7nixeTslbRHf6etD0Lv8ltxgKRCMSTprEkml+7J5cTBBI9x2tTFp/mrnjxTZgtroZWZ/Dzkz9Yr9iFVm7yQWU8XK1d7uHsPqUR0wY+XY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Laluglbu; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837907ec88so78652125e9.0
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 08:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772641346; x=1773246146; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hIPQsaRMySh/GQ9beSIags017EfvQfEs6fVmzxgycwo=;
        b=Laluglbuf74bNOR57a3AcoTXhIhYi9htlitgKs8bm9owB2qtsptR6nPPzBJvc9LMRR
         kscUeeE9InVHNK6lln4d+tspyA290k+03Ac2l/0WJ9rlR8Mlf1ZS2boFkv4tuPBic88U
         fo/oaMkBHDCAbayGOsV97sPwo/pSj5+uvVg5lo6Ey8laMOHv+uUUtAlUl26f/zSvOUDw
         CEhcxYQ/th0l1awQ/FTGHCQOP+Qy/gIsI3M4Oni+keW+lwp8UCE2Y6IhVy4Zga7kEj8U
         zQphCG3BQil8u732Rqe8pvLGrY50BHmC4tmre24aD8rQ2eeQiP6sAm7nAwEes4RZ6boe
         LYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772641346; x=1773246146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hIPQsaRMySh/GQ9beSIags017EfvQfEs6fVmzxgycwo=;
        b=fnNwJhpqFGcjg5FUsi1YtwV3WKA20zYXVLcResVvBcWvjHm3krXVz24580WQ8JAHlk
         BUJGbCv7CdaBt4J1NKPS/8BmoXaTgNHm4ouRPVlkboziAzbFOr4c+76Tlw5iEq4KQpvd
         l+YCMAKEcETnmWqBK5VKSO+iEz12r+zw9cp9UvUcPGjovYLfFOJysqdeqCXMdGCSRzym
         nVfeK1nU3fFAvfXN4+2TbpZjnBFWnlyl42+r9oBCvfr91//l+xQC6ZmVkS3dWe5pJiMf
         zqm73/DW+PP3Ei+BQoUrOXXZqNREwtgygMPzkOzA7TkKSPSz0ye9CMkd3KFN8oAUGY3a
         jvDQ==
X-Gm-Message-State: AOJu0Yx5bNYDt7x+dmS+Ao33k8C4wHaapk97kuY+WuhCDfhcO2+fCrEz
	3q5MFr/WsUPHNF1PcRH12JarDYYra8f0Kf6d6UNB0ORhnRww0xTwU1njtnG5Rs7w07MH22UFrHH
	Lu4fC5Bo9bUyWJoNJjcEg6H5SPvDPqhtKSUVF+JD8pxFUXB9D3VQAXtJXamDSV+uT0e+qY+Imed
	ZujUOZ4NGu5ZeupzXRcz06z0TvNAo=
X-Received: from wrov11.prod.google.com ([2002:adf:edcb:0:b0:439:b0ed:2aee])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b8b:b0:46f:c55a:5a8d
 with SMTP id 5b1f17b1804b1-485198312a0mr43881475e9.4.1772641345799; Wed, 04
 Mar 2026 08:22:25 -0800 (PST)
Date: Wed,  4 Mar 2026 16:22:22 +0000
In-Reply-To: <20260304162222.836152-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260304162222.836152-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260304162222.836152-3-tabba@google.com>
Subject: [PATCH v1 2/2] KVM: arm64: Fix vma_shift staleness on nested hwpoison path
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, yangyicong@hisilicon.com, wangzhou1@hisilicon.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8ED9B20422F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72698-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

When user_mem_abort() handles a nested stage-2 fault, it truncates
vma_pagesize to respect the guest's mapping size. However, the local
variable vma_shift is never updated to match this new size.

If the underlying host page turns out to be hardware poisoned,
kvm_send_hwpoison_signal() is called with the original, larger
vma_shift instead of the actual mapping size. This signals incorrect
poison boundaries to userspace and breaks hugepage memory poison
containment for nested VMs.

Update vma_shift to match the truncated vma_pagesize when operating
on behalf of a nested hypervisor.

Fixes: fd276e71d1e7 ("KVM: arm64: nv: Handle shadow stage 2 page faults")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e1d6a4f591a9..b08240e0cab1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1751,6 +1751,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 		force_pte = (max_map_size == PAGE_SIZE);
 		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
+		vma_shift = force_pte ? PAGE_SHIFT : __ffs(vma_pagesize);
 	}
 
 	/*
-- 
2.53.0.473.g4a7958ca14-goog


