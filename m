Return-Path: <kvm+bounces-72399-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMqmLzW4pWkiFQAAu9opvQ
	(envelope-from <kvm+bounces-72399-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:17:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7856F1DC970
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:17:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 98E74305466D
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 16:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4BB41C0C8;
	Mon,  2 Mar 2026 16:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PD5EYLbp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DC03FFABB
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 16:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467912; cv=none; b=NJagBQm6kK67WVOaEY40bCXwhX2hvZI6BG0gurYFWRJaxxeWJh4nAkzwKnN5zP+A4B/POOq31V+rix+q50jxTgJhQRQQmjA8v0W38efvjIan8wKU1uH/RS3XdiAp4PCDpS8n3XxUSGVeCi+25q4GM8DOaYdEXgqjAnmDpZFsNIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467912; c=relaxed/simple;
	bh=FdNYlROhuINV1ZK5m4jv48YEZrLmzMvdmZd2mlMdZ8s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NHV9i9NrfM3hGiGRluRpN5DunXZS9sy04MNbnnCJ72s+BjajsLfi62csQ/osLKZAsKTi5nEBY4QvvUygt954YxKzlNMzFrB2QCiNsU51v7oeu9iuE4GE1ZL8efdx7+FG5Bf4A+vMp1maWhVnVEk7LX4mbiv+1+fdF409J3OYpwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PD5EYLbp; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae3e462daeso9996455ad.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 08:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772467910; x=1773072710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DXjiZiaUu0ZaFdaT6kkKBQZZcQF/ZcN9DW8r7pZ6DfI=;
        b=PD5EYLbp77xsWYMKmVMivgOa4rBabOdWds7eZdc+aQg/UMDjS/GQKq4COeKKiXqupr
         rOzpJSuAhRlc6FKIIpdZuEOwcU/NAWeN8uuVIpjLbov0oIahdjIqyT0fL9BfFf9emwDb
         KXOq6satPMlcte95vEjoA45NDqHvtZZyPkFI/76LzObms5uwyDFwE0bEYh7AByNv4xJS
         Uuyc2/y6vYIAINa17XZtsnmeRb+3WNlLDNPOi0LcwiZpqOscDa/GUrcmBrunJgU/o8E9
         vMmNjCUjydcAwsrvyoJ1vAdlM7PxV7Sq68NucOpL14hudIXtBncXEH2pgdY5xHI0gHpk
         rsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772467910; x=1773072710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DXjiZiaUu0ZaFdaT6kkKBQZZcQF/ZcN9DW8r7pZ6DfI=;
        b=O9gMCMJ/R4/z5PjC0FNEKJY7cVoHKXGmCohhurObaNVONOgAylnbmj6/7RGLqzeijX
         8sDliz7toiq6h229Mcv+IsDV6+xwpmIE9pr/JolukKxEKFK3Mu/xI548lgi21+bqxdmn
         lhc4fes30jp1x9OvTb/T2BKdH4lT71LzE0GX/hcKF9uBeN2P1vCD3tqNWVzwSk733jUL
         JfH6P0NVyrvgRzZxX+Z1fm1HtOrWiMtFbtsPOIckyl5btCeANc0tb17nX2SeVxELwtKb
         vZ9bMMv/sN0Pps9esSwLLnJdvEXl/t33XNJjhtrqDgzf21rECS+KAaFx3puVHuitO+uD
         Mztg==
X-Forwarded-Encrypted: i=1; AJvYcCVCkEgWSy0e5dEeggpJ68Usx9XH76DOvEGa/Tx9ED1thdS9vJ9cNIFKpf3Y9OXZOoylTac=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmFEGGayS3e3I4MPrsHJwX17wq2fL9nHDRUB2PxJQ2Gd77GzkG
	LiFUinnVqsQOZ4MTOdMVZlwBeZSR2NY+bOs8XaCHvq31wjveuSqk1HHTG1DW9a+98APbEuEtE73
	y+tZK4g==
X-Received: from pllx22.prod.google.com ([2002:a17:902:7c16:b0:2ab:194e:4d54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ccc8:b0:2ae:5628:a170
 with SMTP id d9443c01a7336-2ae5628afe4mr34644475ad.46.1772467910234; Mon, 02
 Mar 2026 08:11:50 -0800 (PST)
Date: Mon, 2 Mar 2026 08:11:48 -0800
In-Reply-To: <CAO9r8zP-chd6VcS5zGgU=g_AWAu9ytqnxzemQ9BKdV61rRHimQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224223405.3270433-1-yosry@kernel.org> <20260224223405.3270433-17-yosry@kernel.org>
 <aaIxtBYRNCHdEvsV@google.com> <CAO9r8zMRkFfxm_zs88uc_ijARrU4XxHQQZAQFmC_t0H9qdbM-A@mail.gmail.com>
 <aaI_XogE98GvJjAU@google.com> <CAO9r8zP-chd6VcS5zGgU=g_AWAu9ytqnxzemQ9BKdV61rRHimQ@mail.gmail.com>
Message-ID: <aaW2xBf0uxHS4wyN@google.com>
Subject: Re: [PATCH v6 16/31] KVM: nSVM: Unify handling of VMRUN failures with
 proper cleanup
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 7856F1DC970
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72399-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,hcr0.pg:url]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> > > As for refactoring the code, I didn't really do it for SMM, but I
> > > think the code is generally cleaner with the single VMRUN failure
> > > path.
> >
> > Except for the minor detail of being wrong :-)
> 
> I guess we're nitpicking now :P
> 
> > My preference is to completely drop these:
> >
> >   KVM: nSVM: Unify handling of VMRUN failures with proper cleanup
> >   KVM: nSVM: Refactor minimal #VMEXIT handling out of nested_svm_vmexit()
> >   KVM: nSVM: Call nested_svm_init_mmu_context() before switching to VMCB02
> >   KVM: nSVM: Call nested_svm_merge_msrpm() from enter_svm_guest_mode()
> >   KVM: nSVM: Call enter_guest_mode() before switching to VMCB02
> >
> > > I am fine with dropping the stable@ tag from everything from this
> > > point onward, or re-ordering the patches to keep it for the missing
> > > consistency checks.
> >
> > And then moving these to the end of the series (or at least, beyond the stable@
> > patches):
> >
> >   KVM: nSVM: Make nested_svm_merge_msrpm() return an errno
> 
> I don't think there's much value in keeping this now, it was mainly needed for:
> 
> >   KVM: nSVM: Call nested_svm_merge_msrpm() from enter_svm_guest_mode()
> 
> But I can keep it if you like it on its own.

Hmm.  I don't have a strong preference.  Let's skip it for now.  As much as I
dislike boolean returns, 0/-errno isn't obviously better in this case, and we
can always change it later.

> >   KVM: nSVM: Drop nested_vmcb_check_{save/control}() wrappers
> 
> This one will still be needed ahead of the consistency checks, specifically:
>
> > KVM: nSVM: Add missing consistency check for hCR0.PG and NP_ENABLE
> 
> As we pass in L1's CR0, and with the wrappers in place it isn't
> obviously correct that the current CR0 is L1's.

Oh, gotcha.  I'm a-ok keeping that one in the stable@ path, it's not at all
scary.

