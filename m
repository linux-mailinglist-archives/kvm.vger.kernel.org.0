Return-Path: <kvm+bounces-42584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29388A7A49D
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 16:07:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A0E23B9412
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 14:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8CB124EA8B;
	Thu,  3 Apr 2025 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQ+BnGUn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068A0134CF;
	Thu,  3 Apr 2025 14:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743689103; cv=none; b=qJY+2W0lMM04XHbzX1TAy8u5MT/s48KQYywiG9zr6qpNhkPAiv5g5mmsw04Vdsh4SroR9vOJoUILfdvuaPVIbCgv9On49bhPNzmg6cIHT5Se+vV3RF1JsI4pXOTCyEgU3aNAo2JGBJ7pURws+kkssD+NxeLENbdPbssD0U0m7bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743689103; c=relaxed/simple;
	bh=j+fJmYhBie4I4/+o0xro/RwT5JzJqH/bxviv14smygA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AMxaeqgyFs/z2yJOVEU8J80eQ+xPtDD/KuckhjRwsB74aAUSI2YdbZK9ihvPWMZ86F8sDRDzPfGdOKS8oukv6h6KbT3LnsuHPSoTasAAYn1RXzoH/B0aIyES4YVtCI/ZHMTsZcMsA1V3s+U3Yfdoh/Ro9+BDtwJOt2uEN37hyc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQ+BnGUn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45560C4CEE7;
	Thu,  3 Apr 2025 14:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743689102;
	bh=j+fJmYhBie4I4/+o0xro/RwT5JzJqH/bxviv14smygA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hQ+BnGUnk3UKPtsKi1h30h5CyTHS4fe8g63mtvZ/oMIb2nJqr4jSDu5aakk4zTEz1
	 6uJaqank49+9rfp5RqzmUyYjqFodSbUCKWE9O6VUDrbbxUNZYBV59JIyGGnkvY1aaU
	 0vuZ1LcwnfmOoNrEgV9+r2IlJ9tMiQ4Hpai9udzAFRn5S2FG9YtnXwv+BjsZVDCpkr
	 0RFIFCFTw2CG3P92jE4nNXnnAvqRrsynJkqPQBUNh5Jni/jP5IM3vWwPauRYvR0Xw1
	 w62fQGCPKyKFJ2eHH3Pg1AqRS9u9k39NmupJm/3C1G+IkPp/JLVxfNWehwzctWvn+K
	 TfIPVVRoqyBjA==
Date: Thu, 3 Apr 2025 16:04:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Chang S. Bae" <chang.seok.bae@intel.com>,
	Chao Gao <chao.gao@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
	peterz@infradead.org, rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com, john.allen@amd.com, bp@alien8.de,
	xin3.li@intel.com, Maxim Levitsky <mlevitsk@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>
Subject: Re: [PATCH v4 3/8] x86/fpu/xstate: Add CET supervisor xfeature
 support
Message-ID: <Z-6VhlOOfNTK_2tL@gmail.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-4-chao.gao@intel.com>
 <d472f88d-96b3-4a57-a34f-2af6da0e2cc6@intel.com>
 <a287cfc1-da35-4cd4-9278-4920bb579b5c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a287cfc1-da35-4cd4-9278-4920bb579b5c@intel.com>


* Dave Hansen <dave.hansen@intel.com> wrote:

> On 4/1/25 10:15, Chang S. Bae wrote:
> > In V3, you moved this patch further back to position 8 out of 10. Now,
> > in this version, you've placed it at position 3 out of 8.
> > 
> > This raises the question of whether you've fully internalized his advice.
> 
> Uh huh.
> 
> 1. Refactor/fix existing code
> 2. Add new infrastructure
> 3. Add new feature

The more detailed version is:

 - fix bugs
 - clean up code
 - refactor code
 - add new infrastructure
 - add new features

Or in general, the patches are basically hierarchy-sorted by the 
'utility/risk' factor to users, while removing net technological debt.

This is why *sometimes* we'll even do cleanups/refactoring before 
fixes: a fix can become lower-risk if it's on top of a cleaner code 
base.

Thanks,

	Ingo

