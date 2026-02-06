Return-Path: <kvm+bounces-70395-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4LViIDZGhWm5/AMAu9opvQ
	(envelope-from <kvm+bounces-70395-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:39:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2579FF8FD8
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F3463022609
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 01:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FF6242D76;
	Fri,  6 Feb 2026 01:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rub3yRVN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FD32236E0
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 01:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770341926; cv=none; b=mPCCQVRacf1R6KGfoHJhDtj349iADjzEDOJjNTP/UOXpghCc64U4m8oaVCuwI8LEBHEqfvhmWsWZxFs1uaynSuvJzBqxQZko4j23ptISK9DB3HSIiHHltkgcmusk5OnNVXalIWDL29Ac0W2CKloZKVAIS7VVUzBrZUrukoJ0Yd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770341926; c=relaxed/simple;
	bh=IbopyEVAw0lcGmp+LREMylxfP9DIqwwNS3V/is5hqb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g482Z6xX0sCBU/E1a8rBzU0tOfexTOHKX8Bl+7lbFLgstPsQJgnOH6+lfUgxmyP2UjFByvpoWbZNmEkDJutEY9ub5aUIiMZyXAE7ci1u+IdmjzVrLKojUvGzo5sNBp4MINjDZuOuQhar3WIsINMbnsWafZ5NaLhVi9SZzkdh4iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rub3yRVN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a945ba5553so1972515ad.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 17:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770341926; x=1770946726; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xnh7MWyoEPXlnntK36ZUb93K9kbxOaxGRlGHFywiAKY=;
        b=rub3yRVN2gn8W644+N6b7COsd7xOxabt763fRa9FQPB/QFvYbI4ynDYmcl8KHna3l1
         XASNwxsHlgFkzmI2n+ivBXCwiBNBtTpwItFzZWUZ2Eea7i20JCVjj8DV+YTmKZJg8gM9
         YAu8BMDBrsddCZHrOhdxk/B3R7aaB3MCGwqSE1M8kE3VDrxbvHhiW22DLXazAnL2i+qn
         ociPFp2r+5FrDsd/Qjk5jNyT2c+QbQ2U48CC6h190Cq8pxie/uaDNSObX3GBJZt9RL0l
         vb10MvCQAyfCDmDaaRSbqEd+N071TVkCTMoP5DlH4JMmiiX9EyO0clNtEUQfXPXGrrnZ
         va9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770341926; x=1770946726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xnh7MWyoEPXlnntK36ZUb93K9kbxOaxGRlGHFywiAKY=;
        b=S4pxIrWhD5MqmfVRWezvFrPUWTgOlopbz5xPGmHA7gOnm+772331GcSUs/Ay5CyfcT
         FU/Ju0MhY3kAvjPX9Lvj37798yf4wD0ynVnWPW7XZq9GRB52c5wDHPLY247sn8NNq3iJ
         d7kpoluJob6HGMPTtF5FGmGl2/MvBlOGG9sgcMFcZSb3RScwohC7jd6jQSFJyDEaYeeN
         lAGY7xHWsJQrefeqZAie+fMlTb0X/U9dsCfO0q+k7LkDgHY//ju9/kqLVZyM19A3gJRc
         tokUwkuXwKxRYMXKfHlyOZIglIW2LkWu0fEke1mpuYQ4rvreQE9JDvwuyQLBUuwYqWks
         x/lg==
X-Forwarded-Encrypted: i=1; AJvYcCU/pgg4Ra8RZhk9HGkHgOmzdkNCTjq/moed0XmmSYSxJsd311wuwyVw3pSvdjJNh1e6JBo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVmn7I7B6e2yOsPg/O3L5lTaVM9s/SFTbKt7qTZGKfZDPnP9cg
	SyNlEonfT+yFrD/pJ1yGEEYxazeTxVdMpZD20KDUB2JgtHBh8iMw9Zlq6MXmcAfopiGY6yVMSuM
	AbqSlzA==
X-Received: from plhz4.prod.google.com ([2002:a17:902:d9c4:b0:29f:25cf:e576])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf0a:b0:2a8:ff32:5f96
 with SMTP id d9443c01a7336-2a95165a927mr11461595ad.13.1770341925840; Thu, 05
 Feb 2026 17:38:45 -0800 (PST)
Date: Thu, 5 Feb 2026 17:38:44 -0800
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
Message-ID: <aYVGJJuRdYTzO20p@google.com>
Subject: Re: [PATCH v4 00/26] Nested SVM fixes, cleanups, and hardening
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70395-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2579FF8FD8
X-Rspamd-Action: no action

On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> Yosry Ahmed (26):
>   KVM: SVM: Switch svm_copy_lbrs() to a macro
>   KVM: SVM: Add missing save/restore handling of LBR MSRs
>   KVM: selftests: Add a test for LBR save/restore (ft. nested)
>   KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN
>   KVM: nSVM: Triple fault if mapping VMCB12 fails on nested #VMEXIT
>   KVM: nSVM: Triple fault if restore host CR3 fails on nested #VMEXIT
>   KVM: nSVM: Drop nested_vmcb_check_{save/control}() wrappers
>   KVM: nSVM: Call enter_guest_mode() before switching to VMCB02
>   KVM: nSVM: Make nested_svm_merge_msrpm() return an errno
>   KVM: nSVM: Call nested_svm_merge_msrpm() from enter_svm_guest_mode()
>   KVM: nSVM: Call nested_svm_init_mmu_context() before switching to
>     VMCB02
>   KVM: nSVM: Refactor minimal #VMEXIT handling out of
>     nested_svm_vmexit()
>   KVM: nSVM: Unify handling of VMRUN failures with proper cleanup
>   KVM: nSVM: Clear EVENTINJ field in VMCB12 on nested #VMEXIT
>   KVM: nSVM: Drop the non-architectural consistency check for NP_ENABLE
>   KVM: nSVM: Add missing consistency check for nCR3 validity
>   KVM: nSVM: Add missing consistency check for hCR0.PG and NP_ENABLE
>   KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS
>   KVM: nSVM: Add missing consistency check for event_inj
>   KVM: SVM: Rename vmcb->nested_ctl to vmcb->misc_ctl
>   KVM: SVM: Rename vmcb->virt_ext to vmcb->misc_ctl2
>   KVM: SVM: Use BIT() and GENMASK() for definitions in svm.h
>   KVM: nSVM: Cache all used fields from VMCB12
>   KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
>   KVM: nSVM: Sanitize control fields copied from VMCB12
>   KVM: nSVM: Only copy NP_ENABLE from VMCB01's misc_ctl

All in all, looks good.  A few comments, but I don't anticipate a big jump in
the patch count :-)

Note, make sure to rebase on the latest kvm-x86 next, there are a handful of
minor conflicts.

