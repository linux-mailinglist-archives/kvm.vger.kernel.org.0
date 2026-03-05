Return-Path: <kvm+bounces-72855-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wEEIN/m6qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72855-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:18:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB792160CA
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:18:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A637931A640C
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C27A3E51F5;
	Thu,  5 Mar 2026 17:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QiQpPvUS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0093B8D7C
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730670; cv=none; b=rlp+aal/vMyUnkEwZ0pGg614XmHgSQuO8dVyQdzNQv1LDqoZVDlcAutjHjoz2u0hCv3bQ9XgXEjMsysdbcR2/eGck6JloagFh75H9F5dk7vJhn7cmtbQsI28d+U4Go9HoDvBifgcH6vY5M7oW8Z+vCmKolrovldPgJGWZ2phw+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730670; c=relaxed/simple;
	bh=EiZRIOma5yT1iQulOJ/Bmg5cPZxIJOZcu7SR6cw9joQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mYGfl66BEDmHpWp5/9JNkaNqPIk1qEldTfTz+j2sP+X7ndsQaWTs83I5SJf3B/szKtobFyA9kAc3MK1kbW7WE0fuNU8QXh2av+TqlxDeScCS2DJVU9XIY/A9+WgDvg8MTdl+fCnCRf57c5b5DURCeOdaWzuKKCIn/N06dELRvrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QiQpPvUS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35641c14663so8679979a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730669; x=1773335469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CtwAMovf8rzdeDDnrlXC+Uv7hAlbzLA4l8aaeE62Qmg=;
        b=QiQpPvUSmCiA5NIiNNrzCpdGwkVm9sXm8k3yYypNo0DVys4MS4px2WCusQhJUDnXHq
         cGXcrns2sNekXNBsEKcU9mAlZjIV62YSwe/81ecqIyjNdGIpH30SzWWRaTDjnFXhrlwh
         WXvpof8bE6/USrV84E0IP0TeBIp/eYWrMocLS7MsN3jy3079//RHQosf4WuERYUV3VhO
         Ch6Q3eHnWcZXR3WU/88HXoPjOpWvER8rhDd1sq5i5cZ1eksVuLGrCeeB1tqCKc6o1cI+
         LkrjBykEe73i05nrAHpszdxgavfvJpotRAu4K6ZXAJeWriZptNF2zYVE5U6FLUSlvoxB
         Kk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730669; x=1773335469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CtwAMovf8rzdeDDnrlXC+Uv7hAlbzLA4l8aaeE62Qmg=;
        b=O4y+ZlIa4fIbMp3IeO0zi6o5GRCnGICfgOIpD+9V+uhOkSuBQH2eCSrbkDon/tIweB
         ery6EQAAiVDlBCe8iWn7fuQRVxjlDKBivSDRWFzmt1Z3Tnk6meE9jneLA3JcJbMBJbet
         lbORrg7sglA1NGKa2mKaeB89dPd3GA9U+FIAfp9mL0068zF6pJYGIgRVRD5n4sofaa9X
         pFMV3DEwZh8ic+7996CUjdn0zqKM9eThw5d2t4dPuGtsnnPo4pX7NGc4Tij77+Nv7FDR
         jHy8RK1sMryeZ+t3nsoOdQFPZkco03FnC9PTD5i+q5foFiiYyjrGs0vXe656/AGnZu4B
         qh7w==
X-Gm-Message-State: AOJu0YyGgaqAl03JDVkM3ONmoJCszbBykEOzP5pk2XoVPXhIOEcucd9S
	PmjpdeclmBukz3X8jyfQfp9o7ZTrtXw4HvmguO7KU4kLTrT/t8iYI0jdSYj1471aBq+xUCwrKw5
	5c+81qw==
X-Received: from pjoa5.prod.google.com ([2002:a17:90a:8c05:b0:359:8c74:aec4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:184d:b0:359:7906:d998
 with SMTP id 98e67ed59e1d1-359a6a4f88bmr5722995a91.18.1772730668917; Thu, 05
 Mar 2026 09:11:08 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:59 -0800
In-Reply-To: <20260218210820.2828896-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260218210820.2828896-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272542345.1534825.4006634596500180669.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't zero-allocate page table used for
 splitting a hugepage
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 5CB792160CA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72855-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, 18 Feb 2026 13:08:20 -0800, Sean Christopherson wrote:
> When splitting hugepages in the TDP MMU, don't zero the new page table on
> allocation since tdp_mmu_split_huge_page() is guaranteed to write every
> entry and thus every byte.
> 
> Unless someone peeks at the memory between allocating the page table and
> writing the child SPTEs, no functional change intended.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: Don't zero-allocate page table used for splitting a hugepage
      https://github.com/kvm-x86/linux/commit/ecb806293213

--
https://github.com/kvm-x86/linux/tree/next

