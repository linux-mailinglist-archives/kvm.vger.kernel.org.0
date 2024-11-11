Return-Path: <kvm+bounces-31461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0CA9C3EC9
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 938731F213DF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1249C19E836;
	Mon, 11 Nov 2024 12:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PA7kD+99"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0798F77;
	Mon, 11 Nov 2024 12:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731329678; cv=none; b=qIZ7j8Q3Zvo/tHdqI55NeKeC0wIFvEg7z7NaFsX+jIswNacY8dNNa8w7OoDNsMwVKVL6RNySgOoLaOiJXc1OuZuVQmGsTT/z9lpiSGOYvKbrRhk1l4+BBDGIC5j6ljRK05As1PTSBVwMCJZFPbSA2zUred1Dh4/eIDh4s4Q7HTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731329678; c=relaxed/simple;
	bh=8ytttvrXBO0uc4kq8pwVGBvkkLqj5TLtL84oxCETWyM=;
	h=Message-Id:Date:From:To:Cc:Subject; b=ZSi4Qe3acl/sLjre7R4fDojk8/6IU/lGoQODKhpzLRSV80qSaAuyoofbj9Ij4RfHW33JTWhN4gcfgTEWeYypASNXyzpISJOoh0UnIf0UpFnPnLjBsdIEQW7qLZOXWgczEXflvJeOgosQ7A7G91Xo6kIIWFXjRoq3av+AyVcNeqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PA7kD+99; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Subject:Cc:To:From:Date:Message-Id:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=8ytttvrXBO0uc4kq8pwVGBvkkLqj5TLtL84oxCETWyM=; b=PA7kD+99Z5+YEOnVHluF7eGqYC
	xnsFcKWN4mjniwvy7ZV06Z6R5MvfK9BmRQeuxxAc/et3ZUTcZh7R0n05DUHM4d+xfZ73hhpPhvr4G
	Yu1wtrjADXSg2wDmeJ37jMGTV8vHwBuJCSigIL/KViXXecgrknhn8E8roycmw9YOZrMnlvXiAvzFp
	SirUua05qUUpMCr2PA+VT5YaoKSljypnj7qHIXgiSsmqBmkUi3wFmtup3Pbm0WydDzdtMPP/RqM9E
	kswkfUWc+gC/C88L/9rqDoGdd4064Nmcb/1J/xIHSDclmbi4Ca2F0kvICHNOIPK5B7leiwj7Sesav
	m4OmG+BQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tATw9-0000000Cqjd-2bBN;
	Mon, 11 Nov 2024 12:54:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id C12A630042E; Mon, 11 Nov 2024 13:54:32 +0100 (CET)
Message-Id: <20241111115935.796797988@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 11 Nov 2024 12:59:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: seanjc@google.com,
 pbonzini@redhat.com,
 jpoimboe@redhat.com,
 tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org,
 x86@kernel.org,
 kvm@vger.kernel.org,
 jthoughton@google.com
Subject: [PATCH v2 00/12] x86/kvm/emulate: Avoid RET for FASTOPs
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Hi!

At long last, a respin of these patches.

The FASTOPs are special because they rely on RET to preserve CFLAGS, which is a
problem with all the mitigation stuff. Also see things like: ba5ca5e5e6a1
("x86/retpoline: Don't clobber RFLAGS during srso_safe_ret()").

Rework FASTOPs to no longer use RET and side-step the problem of trying to make
the various return thunks preserve CFLAGS for just this one case.

There are two separate instances, test_cc() and fastop(). The first is
basically a SETCC wrapper, which seems like a very complicated (and somewhat
expensive) way to read FLAGS. Instead use the code we already have to emulate
JCC to fully emulate the instruction.

That then leaves fastop(), which when marked noinline is guaranteed to exist
only once. As such, CALL+RET isn't needed, because we'll always be RETurning to
the same location, as such replace with JMP+JMP.

My plan is to take the objtool patches through tip/objtool/core, the nospec
patches through tip/x86/core and either stick the fastop patches in that latter
tree if the KVM folks agree, or they can merge the aforementioned two branches
and then stick the patches on top, whatever works for people.




