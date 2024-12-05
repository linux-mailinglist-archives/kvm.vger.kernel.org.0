Return-Path: <kvm+bounces-33181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D70A39E6166
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 00:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85C4518855BE
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 23:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA911D0E27;
	Thu,  5 Dec 2024 23:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKFoPW4i"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431D684A22;
	Thu,  5 Dec 2024 23:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733441568; cv=none; b=nU2nnGHAeM9q5JyJy32c0f/SpcitrpbSALVsRKDr+AoyDg3auLPWyUelygKN8DNYEOSoIBUHqWW1PHlpA1tksgTyv8xtucEzpQWq5qmm693V2ztCM+ZrM4Iix3h45msaUv2jUqwb2YR1+G6c174ipad7U/nG3Mdov8Ube+S4+KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733441568; c=relaxed/simple;
	bh=eSgBZqO2vnfiAWR9pD+J75croiH27ygn2G58DkHVM5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJAmjhEQ++K8iTvBNh3zecqlRez1GNxlBG01HeRBNCKHe8dBcaKll/LG7cpDtInGaIbZQDMbipWgpFaSsFcwF0sESI2WxZuXhrPPoEzJvKG2ygEnCvyqXRPNYl6idmssPNbhwSLQxg06styGRngeAYey0AeM8YxyEM3CD3JTalU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKFoPW4i; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FA6C4CED1;
	Thu,  5 Dec 2024 23:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733441567;
	bh=eSgBZqO2vnfiAWR9pD+J75croiH27ygn2G58DkHVM5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PKFoPW4iRrox+j5NaW7rl/VfVU2ChOMjhwrYMe0KKabRRKhavT2L2A5LVOoifMya7
	 l5Q7ZUMraUBgTr3PW7rMpo0N3/CMncRT4Va9D1twlp5qepb/6J0lCQqC0d/uuMwLkv
	 AqFJyXEwELsAatAijGKDr0588SsvDtVIIy2ZlO/zAxZzZQNBeb5b0gMIfc5aQOrz0y
	 iY/5EIkpqgMGG2Z5hAFzUSIvCcjmlceZMr5gFK5T+rC+WJQqXa0f4rkhDqx6T3oK5/
	 wTpQmiOape6kY/hAwVM1LMF+VP7g8ngPCGheqXeJe4OMdp+LSV2mv8nl6SPx36st6T
	 hK+GIWJVvc4Lg==
Date: Thu, 5 Dec 2024 15:32:45 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, amit@kernel.org, kvm@vger.kernel.org,
	amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de,
	tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v2 2/2] x86/bugs: Don't fill RSB on context switch with
 eIBRS
Message-ID: <20241205233245.4xaicvusl5tfp2oi@jpoimboe>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <d6b0c08000aa96221239ace37dd53e3f1919926c.1732219175.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d6b0c08000aa96221239ace37dd53e3f1919926c.1732219175.git.jpoimboe@kernel.org>

On Thu, Nov 21, 2024 at 12:07:19PM -0800, Josh Poimboeuf wrote:
> User->user Spectre v2 attacks (including RSB) across context switches
> are already mitigated by IBPB in cond_mitigation(), if enabled globally
> or if either the prev or the next task has opted in to protection.  RSB
> filling without IBPB serves no purpose for protecting user space, as
> indirect branches are still vulnerable.

Question for Intel/AMD folks: where is it documented that IBPB clears
the RSB?  I thought I'd seen this somewhere but I can't seem to find it.

-- 
Josh

