Return-Path: <kvm+bounces-33184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B20C9E6288
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 01:53:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 804DD16412F
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 00:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520D047F4A;
	Fri,  6 Dec 2024 00:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uNT6Tlzr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B54D374F1;
	Fri,  6 Dec 2024 00:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733446383; cv=none; b=kLFZPbHp0LCO9EjhCFI4Gl5NCkxm6CQe0Mq874LpBkg+RzrASeZ2f9KAKi/tpCYRm3X8AXaU2wxq459B9GlK4NvBrT8C0/0pfbBC81IBFWOgkCduE2VOLiB0vQ1x1BWlXSIODjEq2wIuHLdAxM7LKfnoi6/ZNn52jc0hJx5gTME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733446383; c=relaxed/simple;
	bh=mXdF7eIA7DLmlnIHAoAVMUCUpmczPGA6A4u4ubZl6+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpULTGhdckygyHQOGy7eXN16AnsGdzdr+C4oBb9GxYwv0sgk5dV3Gq3zU113RP9I7fB07JtHK/TYo+oci/N2oVgyoEAPJe8Mo1Ukbgu0QNQv3uZS4OUTCiQcc296JVTCPDRixUL7Sl0VPx21Fqf47y9FkYWXh09jlXDcqq/mWls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uNT6Tlzr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1778AC4CED1;
	Fri,  6 Dec 2024 00:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733446382;
	bh=mXdF7eIA7DLmlnIHAoAVMUCUpmczPGA6A4u4ubZl6+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uNT6TlzrzRGwPDLTO3EF7gq7GPkn69pg1E4R4CYYmcA6kwKosdoyF7dTRijqlQGAw
	 WJe6yK7AKIVDZp/8sAmcKwWcUdDeF88Q/kiFGHnY8MQIQnuKIxi+5dWha9NMQ1jMOC
	 sOTp2FQrn7/L6PxqXKZUWh8x6EsdHlFnhywfZjpamn/VkkfP+8sFF2jreF4F+H1Fwq
	 CAzYH8bavumpVhudH/h9ugQJWkPGIsvWXKeZpYflbB9VdR3hKKlH/ADRyyUsh8kQzS
	 v8g0xCWT+lhkVut4u9bXS1jCmwI973RODg2DuucKqpJgdaVT6OOtmn2yMwW6Wjek7y
	 sTMpTJs1IohFQ==
Date: Thu, 5 Dec 2024 16:53:00 -0800
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
Message-ID: <20241206005300.b4uzyhtaabrrhrlx@jpoimboe>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <d6b0c08000aa96221239ace37dd53e3f1919926c.1732219175.git.jpoimboe@kernel.org>
 <20241205233245.4xaicvusl5tfp2oi@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241205233245.4xaicvusl5tfp2oi@jpoimboe>

On Thu, Dec 05, 2024 at 03:32:47PM -0800, Josh Poimboeuf wrote:
> On Thu, Nov 21, 2024 at 12:07:19PM -0800, Josh Poimboeuf wrote:
> > User->user Spectre v2 attacks (including RSB) across context switches
> > are already mitigated by IBPB in cond_mitigation(), if enabled globally
> > or if either the prev or the next task has opted in to protection.  RSB
> > filling without IBPB serves no purpose for protecting user space, as
> > indirect branches are still vulnerable.
> 
> Question for Intel/AMD folks: where is it documented that IBPB clears
> the RSB?  I thought I'd seen this somewhere but I can't seem to find it.

For Intel, I found this:

  https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html

  "Software that executed before the IBPB command cannot control the
  predicted targets of indirect branches executed after the command on
  the same logical processor. The term indirect branch in this context
  includes near return instructions, so these predicted targets may come
  from the RSB.

  This article uses the term RSB-barrier to refer to either an IBPB
  command event, or (on processors which support enhanced IBRS) either a
  VM exit with IBRS set to 1 or setting IBRS to 1 after a VM exit."

I haven't seen anything that explicit for AMD.

-- 
Josh

