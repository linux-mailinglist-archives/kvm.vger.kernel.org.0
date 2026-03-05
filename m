Return-Path: <kvm+bounces-72859-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AEviNqS6qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72859-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:17:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E7D9321604E
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:17:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 071973052395
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F323E3D9E;
	Thu,  5 Mar 2026 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eEWVthy5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAB4330B28
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730714; cv=none; b=rKl23/b0ykMg8L28JvfXORJJHc00jCjnwomgE50s98cJ3yOUyZXRy2DRDqo3X4YyvPKiaiF2OToQTgTaMz/8L/1XoB4xNdd4dBgQUpEiOHV61fBHXzlMhQduw1H68j8Asmm94bisa1BUGDokPTaI+RQ+3m9Nnqr0sEN1dy23baQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730714; c=relaxed/simple;
	bh=fktHFHZPZsrs/3zB2J7jK9eELPeCBLLiXMYeFFWRWfk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rUZ3XkhssjOYfL5glxO0OS5GbCn1RXaO0QMEjFT2yOyRWF3kP5NhkVvg9Z5ktud5fhiRW5V+jQGFSC1BGrnXHblsUXu4p69Ano/OGrPWdEqDVErRQGtX3vUQbpKHumG2pOXwSHI4xkGg8Qg+iBLihhlJTxnZHiKXCFDc3ioGlro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eEWVthy5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-358df8fbd1cso7660203a91.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730712; x=1773335512; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ixKevYdEBHh1355kxemVQcztN2Rxf7dmFLaInuEGac=;
        b=eEWVthy5+aiD951V1jG2T46hze9aux/Pu7E7fWRRddxEE02MyNW9Sez1EyHlD1vEkG
         p/XLXc7h7DZFEnRcLNWpxyQ++WU3S+oxZHaHccmaFut93VSiTh1pk8G602yyjQtWAkjl
         rDH8s2QCeGG/CoYY5wkpKJrYr50F9BQLwokaERojvYE8VAXInfH9fEhhqDVqsxV1ubsc
         c5Sf9JMnk6cUL5UQLBm3d/5UzsnRllKq+NhYZZErsacSQ6CJn+uwufNRbU2GZS6YWZeO
         MZ0OlKXMGAG+H1da7XUqR/KmA9xrOojKBvXNOem9aB4nyebDXz2ucfTzYUqmLQ5d3diT
         aYSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730712; x=1773335512;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ixKevYdEBHh1355kxemVQcztN2Rxf7dmFLaInuEGac=;
        b=fCXis/7WbYk7h2R5NdHJ6AfcSlJp7XAZZzL6JXoXuyQbi3Y8VbIYSQCNFHtZXCdQRK
         jAi7TXqH7I6o5BWBHmujgvJITgp9T02W9kXAbqEc/0jS8ZNs3P01cH0NTdXoSqeuPAUR
         6MD34OlBOo2wNSqoSMSyqLN4a3UiZj3HWoQEyG0HklrcxLDuYYCS/hEeiwOdw6nz5py7
         xT16fGFqX8N3yz8ky/nC3gqwOOo6AkHy+xHTMxtbtu1K04iuUSZ2I+uucUYHLdvhw9qF
         zjBkV28whNCHeNMgaJrLR0paYzQdl6XUQmoFxDlwi6dPHA75/LBIdrteihueQCsRlixx
         CChQ==
X-Gm-Message-State: AOJu0YwqKRkrh00Xw1Hw6i/gJ4Yl2E1pvphk0XxIwi5f61bdIPRB/Bnz
	lTLyBs1DaBP9edApekt5TC1I3HnarByGXJ+PmtUR1rYkZNylhx4SJrGsLiDpRuTQyCs3aR+IHCE
	2tOWshQ==
X-Received: from pjbgv7.prod.google.com ([2002:a17:90b:11c7:b0:359:8b65:8af7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f90:b0:343:684c:f8ad
 with SMTP id 98e67ed59e1d1-359bb3395afmr253627a91.4.1772730712371; Thu, 05
 Mar 2026 09:11:52 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:07 -0800
In-Reply-To: <20260218230958.2877682-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260218230958.2877682-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272543301.1534965.445035613008893739.b4-ty@google.com>
Subject: Re: [PATCH v2 0/8] KVM: SVM: A fix and cleanups for VMCB intercepts
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: E7D9321604E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72859-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, 18 Feb 2026 15:09:50 -0800, Sean Christopherson wrote:
> Fix a likely-benign bug where KVM fails to mark vmcb01 intercepts as dirty
> after recalculating intercepts while L2 is active, then do a bunch of related
> cleanup, e.g. to split recalc_intercepts() into nested vs. non-nested
> functionality.
> 
> v2:
>  - Fix the aforementioned bug.
>  - Split recalc_intercepts() instead of simply renaming it.
>  - Move the new WARN in nested_vmcb02_recalc_intercepts() to its own patch.
>  - Use less weird local variables even if they aren't consistent with the
>    existing code...
>  - ... and then change some names in the existing code to provide consistency.
> 
> [...]

Applied to kvm-x86 nested, thanks!

[1/8] KVM: SVM: Explicitly mark vmcb01 dirty after modifying VMCB intercepts
      https://github.com/kvm-x86/linux/commit/d5bde6113aed
[2/8] KVM: SVM: Separate recalc_intercepts() into nested vs. non-nested parts
      https://github.com/kvm-x86/linux/commit/0b97f929831a
[3/8] KVM: nSVM: WARN and abort vmcb02 intercepts recalc if vmcb02 isn't active
      https://github.com/kvm-x86/linux/commit/a367b6e10372
[4/8] KVM: nSVM: Directly (re)calc vmcb02 intercepts from nested_vmcb02_prepare_control()
      https://github.com/kvm-x86/linux/commit/4a80c4bc1f10
[5/8] KVM: nSVM: Use intuitive local variables in nested_vmcb02_recalc_intercepts()
      https://github.com/kvm-x86/linux/commit/586160b75091
[6/8] KVM: nSVM: Use vmcb12_is_intercept() in nested_sync_control_from_vmcb02()
      https://github.com/kvm-x86/linux/commit/ef09eebc5736
[7/8] KVM: nSVM: Move vmcb_ctrl_area_cached.bus_lock_rip to svm_nested_state
      https://github.com/kvm-x86/linux/commit/af75470944f4
[8/8] KVM: nSVM: Capture svm->nested.ctl as vmcb12_ctrl when preparing vmcb02
      https://github.com/kvm-x86/linux/commit/56bfbe68f78e

--
https://github.com/kvm-x86/linux/tree/next

