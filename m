Return-Path: <kvm+bounces-42507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E953A795FF
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 21:38:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACC13171DCA
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 19:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B293C1EE7C0;
	Wed,  2 Apr 2025 19:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oT8Espg3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D528E2AF19;
	Wed,  2 Apr 2025 19:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743622637; cv=none; b=bJl9p8KOvlM46JdHDATTLpuodJfXraSwqwaKhsytuSuQELNWDNriDGfYvjoG3mSRVcMAIIbuI8EKuOW77nLD6cagICgMk0rnk17EynMPAQ0YaH0Nwgw3ahvV6aPVx0/suExCWOZR1TptyOmJYtiKZThowUKVL17WbOQvzVvhEmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743622637; c=relaxed/simple;
	bh=blr2whLFQ9Cu4VkttoNrY24eGAMdcLt7WK8KNXrWNxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qNvBeA8pJgOMRd5LO5jb9F9nj34wZAOagx6NkxkhdOG2mTLqACn349gJTsdUr1/qczimCX092b0KhKddk1xnIwngMYXp9YUv8xdPDRkumdMCJNd71cucJ9x0pSUAIYTb5+lq2MJ3d0Nn92CQ/qbvGqW2fb/3M4Xt/V9qmO1NRo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oT8Espg3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38F3C4CEE8;
	Wed,  2 Apr 2025 19:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743622636;
	bh=blr2whLFQ9Cu4VkttoNrY24eGAMdcLt7WK8KNXrWNxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oT8Espg3cPd3YVx+dmLNY9ljiuorgRIr2YvWY8bh3a0nFZa7WhaSz4Gaxb9kpi4Up
	 R2PaceAhS0DZ0FO0fwrhgMmg17VGEqEdnAZQwEC14T66858naCiHRYuT0QGa0+9yVo
	 xbS+RdRvpRD6yzDbF4LhDKDW/uo2nBJTKJimh/2DTVnurL+GBBhgMlQC/vU3JHxh+i
	 A6+We0UCQltYPcqSyqcgtYz+JnamX9pVA/AI4pWAKKvk6nDht/J1IX7hpb4jWG1OhD
	 M0PQh0wvxuCPJaa9AE896xSC3DVZlo1T2sSQo5iNPbCYfCo6MRrLxnxRkLoubFhiFR
	 xFOartSKV+JDw==
Date: Wed, 2 Apr 2025 21:37:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org,
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com,
	bp@alien8.de, tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 1/6] x86/bugs: Rename entry_ibpb()
Message-ID: <Z-2R4_xF8H_DlEqm@gmail.com>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <a3ce1558b68a64f52ea56000f2bbdfd6e7799258.1743617897.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3ce1558b68a64f52ea56000f2bbdfd6e7799258.1743617897.git.jpoimboe@kernel.org>


* Josh Poimboeuf <jpoimboe@kernel.org> wrote:

> There's nothing entry-specific about entry_ibpb().  In preparation for
> calling it from elsewhere, rename it to __write_ibpb().

Minor Git-log hygienic request, could you please mention in such 
patches what the *new* name is?

This title is annoyingly passive-aggressive:

  x86/bugs: Rename entry_ibpb()

Let's make it:

  x86/bugs: Rename entry_ibpb() to write_ibpb()

... or so. Because the new name is infinitely more important going 
forward than the old name is ever going to be. :-)

Thanks,

	Ingo

