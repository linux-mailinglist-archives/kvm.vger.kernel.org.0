Return-Path: <kvm+bounces-62521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56532C479D1
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 16:44:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C874E1883C20
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 15:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E317931DD85;
	Mon, 10 Nov 2025 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zFqZdDec"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC41131619A
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 15:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789133; cv=none; b=GF1Saum4d7Z3pQnhqnfWGB0l+oZ/Bt9onIHM/1ShRUrEiITfqxtQMjp91aIvU7vsiZY70G30s79TM/zLbb+73vzE1xCtXdyxhmX+HmhhwqzRLTKjgretzTqk1QuWKc4P7U/NsAFg6KnBkbyT58YizAbPfee79tNut57DJ/B2pGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789133; c=relaxed/simple;
	bh=WYo31m3heuJFHd2AleHIkwCwmVtacFIEhcJ51fkn2mU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ilzvos5wtdbHJ0TSVqzybjFs8dUtJcWv0nhiNPaAl1bS7WlwUCyw2ZyPgpmimxobAvUh3wQYQGAAv998y6nDNG8+KcBEaNhhRB359pHoYuES3xoW0LzFuPx2BWSgkgRibJ7PGWFfFN2sHncy6qaDtHJfB9QR8Kaodmiuq08nRKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zFqZdDec; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340c07119bfso7742650a91.2
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 07:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762789131; x=1763393931; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UMGtDSMhLp7PwCftwD5VWBt9/H+12AqeZNXDWEVNOss=;
        b=zFqZdDecMTfURgE0Vc0HAdqEaPBE+hLLdocxPPkL4Tdd4jXBRtbgrSHe5Int4jVkF5
         9OwWASgiq97ASKGQQ33ovNmbcm1YjQ3EFTsV90h1xlix7+33Ez/LTVHjqyD2AWvnJOkw
         ox5K5Fw53ds0P95rkuQvMBs4u9p49N2MPJ5B0cLNT0vIu5CRj51jnuO1ZowDcSQxZVVz
         rQscTLkEffgZxv/vN3N5X4Te1cTQfnMpeF9LsezHIPbdqD3s4O/4zIiddo1oAD9b12qb
         K/tq0tE0n6XFWsLop2tOxi2dcH3YOfeoC1c+hlxtSgIMrEio/AJhb5aMNJDboaEWDdze
         W1mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762789131; x=1763393931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UMGtDSMhLp7PwCftwD5VWBt9/H+12AqeZNXDWEVNOss=;
        b=H47fISxuCZLlLxotr3L/j/ZaOIlc7tUeBq35qg5p6Q5Fd4LzhKPaagy7UqDIsyFmji
         tuY3LnJZFim912zGF2vkAjsTwHl6XAy5kKxpsCC7PWEWa/UuOQoFLPBgU8OgjtlmI3dL
         XkoXjFw14337neiSdC8vDEQ6K1/o4XWlNJbSd7mUH9Gdk3/fZSH0yOxORExgZnPAHAOi
         gLVy4zAeYJQwxwDNMULM6+k5g1SzkfQL+MaoOhMvMnSs46qg3iSxAsdETu4je1Xzg2Cy
         DCQ6GwjL9dItb91B08FQxr7BsmYHaOp0XCcdQuMvQON3FDMfKk0DaDHmmxj8u5QlVw5a
         f+Og==
X-Gm-Message-State: AOJu0YzQh2PgMaXbSESPLmS6Ehy/7fSxLEZPuzyjRdB2SLYr3mGKNLtd
	bdyw6yiE/tBxfD4K3S7358Wm/jtlIn3+jgSTnJpPmuPm6LygyxtuNmAMJ5MMO2L0gPIF9OH+ckm
	NqYKN9Q==
X-Google-Smtp-Source: AGHT+IEp9sm7tBdgsbr2NYRbGOtKx/P5/qWT3g321cSR22hpudavx53XGYsuVNRtFk/NTp4RaBYyBOym9jY=
X-Received: from pjon19.prod.google.com ([2002:a17:90a:9293:b0:341:8b2e:afe9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dd1:b0:340:f009:ca89
 with SMTP id 98e67ed59e1d1-3436ccf1f55mr11306347a91.22.1762789130950; Mon, 10
 Nov 2025 07:38:50 -0800 (PST)
Date: Mon, 10 Nov 2025 07:37:19 -0800
In-Reply-To: <20251030224246.3456492-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030224246.3456492-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <176254658743.821204.2042588290407024138.b4-ty@google.com>
Subject: Re: [PATCH 0/4] KVM: x86: Cleanup #MC and XCR0/XSS/PKRU handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jon Kohler <jon@nutanix.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 30 Oct 2025 15:42:42 -0700, Sean Christopherson wrote:
> This series is the result of the recent PUCK discussion[*] on optimizing the
> XCR0/XSS loads that are currently done on every VM-Enter and VM-Exit.  My
> initial thought that swapping XCR0/XSS outside of the fastpath was spot on;
> turns out the only reason they're swapped in the fastpath is because of a
> hack-a-fix that papered over an egregious #MC handling bug where the kernel #MC
> handler would call schedule() from an atomic context.  The resulting #GP due to
> trying to swap FPU state with a guest XCR0/XSS was "fixed" by loading the host
> values before handling #MCs from the guest.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/4] KVM: SVM: Handle #MCs in guest outside of fastpath
      https://github.com/kvm-x86/linux/commit/6e640bb5caab
[2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside of the fastpath
      https://github.com/kvm-x86/linux/commit/8934c592bcbf
[3/4] KVM: x86: Load guest/host XCR0 and XSS outside of the fastpath run loop
      https://github.com/kvm-x86/linux/commit/3377a9233d30
[4/4] KVM: x86: Load guest/host PKRU outside of the fastpath run loop
      https://github.com/kvm-x86/linux/commit/7df3021b622f

--
https://github.com/kvm-x86/linux/tree/next

