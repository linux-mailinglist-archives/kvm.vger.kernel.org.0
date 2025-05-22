Return-Path: <kvm+bounces-47349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 292F8AC061F
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 09:51:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4931A3A5816
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 07:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 302D524E4C1;
	Thu, 22 May 2025 07:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ikkB023H"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8CD241693;
	Thu, 22 May 2025 07:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747900287; cv=none; b=ATQsY/c2WzF7fv3kov/dlPIPykoGzjzOId1IWEVQ/Wwmf8QxPeikP8Prt/hETTr6M01dZgLIbQOTMMQH4o1n09N09Vo25Eynic53SimUKd3Fr4fdqBWwADo8YyaoblLoAS/MvhZw6cGLODOUsGEe97Ze+67FQFvFj3ux6z4MQHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747900287; c=relaxed/simple;
	bh=/aYhT8vM2cDXmeV1vWj3lHW7/qM3cYogO7PhzIceLb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lNBDeqYKCCcXh6yRrwIrCGyNjHjU2DhtRy3LELuAsqsRU+HCIaghMW6n1UhOcpT7hKIpsMkK4+RxMMjU36c9wOhPIRWVDnmWGMmunttrFFXc257lu6/v0+r8WbYrCn+Semsd/WMGl3P/OmgIE5prVJm3aBeEQ42QwFry0/JyFe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ikkB023H; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JNtiODZQ5XMXnuwJKYtkx+44LK5XAKVKSFPKx4Ql4GM=; b=ikkB023HEBCMo4GcGGzELvxPza
	AQRWbHZzoFQU6IVmFzVLnRytXGjtKXMy7QjSEMtI31OtlyxHvZNnoerklamCBbO5vsCwrAfB5HAZH
	fyB2avBm5YOl4QSZgvdGee7qXJG95CXdHswEKs1Q6TR238al9kdf/KxCqpZTOiZyfhgEAsE1PQCOG
	ZjnC9+vfNMYgrz/037KDvrgFZAi8n1MgO4sumlF00r+HcXvUEtCejtwQ1pD1UX+akbJmqktlKOUEu
	aNXZ7PPwHra4So2z87WImFQm/0fs+lBIT6IUgrZ81XwkKjhtBNyXOAynN9Pk+tTFd2AZTGEN+fHXi
	VV5wFUSg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uI0hm-00000005nXa-2sLP;
	Thu, 22 May 2025 07:51:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 00DBE300677; Thu, 22 May 2025 09:51:05 +0200 (CEST)
Date: Thu, 22 May 2025 09:51:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Chao Gao <chao.gao@intel.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
	rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
	john.allen@amd.com, bp@alien8.de, chang.seok.bae@intel.com,
	xin3.li@intel.com, Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Eric Biggers <ebiggers@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Kees Cook <kees@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Uros Bizjak <ubizjak@gmail.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v7 0/6] Introduce CET supervisor state support
Message-ID: <20250522075105.GF24938@noisy.programming.kicks-ass.net>
References: <20250512085735.564475-1-chao.gao@intel.com>
 <aCYLMY00dKbiIfsB@gmail.com>
 <ed3adddc-50a9-4538-9928-22dea0583e24@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed3adddc-50a9-4538-9928-22dea0583e24@intel.com>

On Fri, May 16, 2025 at 08:20:54AM -0700, Dave Hansen wrote:

> It's getting into shape, but it has a slight shortage of reviews. For
> now, it's an all-Intel patch even though I _thought_ AMD had this
> feature too. 

Yeah, AMD should have this. While AMD does not implement IBT, they did
do implement SS, and as such, they should be having this stuff as well.


