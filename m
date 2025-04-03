Return-Path: <kvm+bounces-42533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C56BCA79975
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 02:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAA553B0FAA
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 00:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC5C1804A;
	Thu,  3 Apr 2025 00:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NvaxnSPz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16497FD;
	Thu,  3 Apr 2025 00:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743640703; cv=none; b=Vyvsjv/jItS/ruQbsxLpBtQlBGQrKEuFGqDVFKq4krRaNvnIH9i+z1N8/oVDV7loWUea1lpZfjbe0AfejkFnMHLD8cyvU/CW7Kqg8tEeopw2NxjfOO5V7PeHpUhR+uDeM4g+4wsdnwU3bUxs2uxirzbScRzCOfcZxtjuWAJfk1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743640703; c=relaxed/simple;
	bh=vWs8tqrKwyvurhpVZnuHY4P/5tovdte/s4ejHVXlkFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4FBRCUtDUXvoJfRZnA8r3+1Ih73h50HM9+O3PSXrt7sJgQrlbIm3DALvKerV+kCRgoQc6dusH/A0UuCs7tsWeHYmpaANPa06q+WLRnVcJJokao0tV8ru3OgehhZB+YochZAw5vtVx9e6bzatH6ILn34rehrnXA9fQtXR+mKa+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NvaxnSPz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46964C4CEDD;
	Thu,  3 Apr 2025 00:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743640703;
	bh=vWs8tqrKwyvurhpVZnuHY4P/5tovdte/s4ejHVXlkFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NvaxnSPz/Jo/d+UCtcDhljsQPceYz5kO0Ln7aejdTsFEJVUr+eeISvN8vAIbPDAq6
	 eASHuNWXMJcaEesm/ZhfxLHIvW2dzwbHocghh8Fts52p8IdGjZakrN07mm5XcGYChu
	 vQe0Td4d7qb2Sg3BWCxFxybPWfz5AaT3zNKyPEG++ZIGB10CC4hjAtCOw/W/4CdHQl
	 lzltbiW33gtLSp1gw+/zLvCamlUtfi0Xp7NAKr7CNQqjSVNf1u8zFBDxqnl/pBysUW
	 iafS/ZHvSoQks4firwIULMMSyKh7aTAkuuBd9R4esodoAkgcsiQPL2feugd9hzj/6J
	 jJ21WJYQSl7+A==
Date: Wed, 2 Apr 2025 17:38:20 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org, 
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de, 
	tglx@linutronix.de, peterz@infradead.org, pawan.kumar.gupta@linux.intel.com, 
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, daniel.sneddon@linux.intel.com, 
	kai.huang@intel.com, sandipan.das@amd.com, boris.ostrovsky@oracle.com, 
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk, 
	andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 6/6] x86/bugs: Add RSB mitigation document
Message-ID: <7oz656x65pmwcnrm7msk5os53o7ipizimelq6n6tjot6zpj2r2@dkfjcgizhv66>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <d6c07c8ae337525cbb5d926d692e8969c2cf698d.1743617897.git.jpoimboe@kernel.org>
 <Z-2XAx9u8l-73aXM@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z-2XAx9u8l-73aXM@gmail.com>

On Wed, Apr 02, 2025 at 09:58:59PM +0200, Ingo Molnar wrote:
> 
> * Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> 
> > Create a document to summarize hard-earned knowledge about RSB-related
> > mitigations, with references, and replace the overly verbose yet
> > incomplete comments with a reference to the document.
> 
> Just a few nits:

Ack, thanks!

-- 
Josh

