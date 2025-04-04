Return-Path: <kvm+bounces-42657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32A48A7C06A
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 17:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C780B3B7A58
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 15:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2A11F5413;
	Fri,  4 Apr 2025 15:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OwDgM89D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175CB86344;
	Fri,  4 Apr 2025 15:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743779827; cv=none; b=jswyfAasZl4uSy45ixwDZwIgjbKzFmnonnynlSEJiEQyGN4vZxuKnT1Eam9Y8GThK7koBJeQOT/ddvkAxZF0rcy7ePhbhu1AJCaJO8zoMg+Ub4ePP4ws1GstZbavdYNaTPDYdck/coxZARBkipYGs6qp8eMkGvh8l3GI5jIPRrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743779827; c=relaxed/simple;
	bh=qOs+fLd7zsPUFNymqQgXx9+kWVigfHUsAiGZPOVHthw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MyiLm7BvinJlrbnnm3KvVyaKsDFMku1grEbAM54yeENDKzsYDb5OC+DQS33GNfqvWZZNKNOVspC31CY4TOUEdtEkgkhN/fNp1dJkpWYZJ5Ph1Qp5utogHxyVGsGVT50NJ1SIHmH788HCXSGyW3WPVlAxB8+4aiNmWIOytGJgVlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OwDgM89D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E948CC4CEDD;
	Fri,  4 Apr 2025 15:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743779825;
	bh=qOs+fLd7zsPUFNymqQgXx9+kWVigfHUsAiGZPOVHthw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OwDgM89DZiXDZzbrrNvPmUczQgRsMvB+q16ARNTJu4aIoltsrxZQ+la+TyIWugZDl
	 vrElbgXvr1jesmIA7hvaeKMi8WDIjOcetp/0KLAyAx6mDCOXG3FFERVpCrRQm359R5
	 W68W2mpd3YJzESU9MIJ/r2S5L7eP9Pyxnt7q+Kw92Y4VivMK77G/4t4h4D1HbpYKH/
	 1jGDI//5MszKcvB+2WXj+Nrto2DPfjvsWYL4I91L2sK0A4mJ+9Cnhgy1xSxppiHGgk
	 jyoWB+lVebbC08eNG8ABLJ95y2Tli7H1+ELzJzgfhwl8N0VV2bIw3kXyFcp3agYM+i
	 YIvAxLChixJIA==
Date: Fri, 4 Apr 2025 08:17:02 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org, 
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de, 
	tglx@linutronix.de, peterz@infradead.org, pawan.kumar.gupta@linux.intel.com, 
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, daniel.sneddon@linux.intel.com, 
	kai.huang@intel.com, sandipan.das@amd.com, boris.ostrovsky@oracle.com, 
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk, 
	andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 3/6] x86/bugs: Fix RSB clearing in
 indirect_branch_prediction_barrier()
Message-ID: <ioxjh7izpnmbutljkbhdqorlpwtm5iwosorltmhkp3t7nyoqlo@tiecv24hnbar>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <27fe2029a2ef8bc0909e53e7e4c3f5b437242627.1743617897.git.jpoimboe@kernel.org>
 <d5ad36d8-40da-4c13-a6a7-ed8494496577@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d5ad36d8-40da-4c13-a6a7-ed8494496577@suse.com>

On Fri, Apr 04, 2025 at 05:45:37PM +0300, Nikolay Borisov wrote:
> 
> 
> On 2.04.25 г. 21:19 ч., Josh Poimboeuf wrote:
> > IBPB is expected to clear the RSB.  However, if X86_BUG_IBPB_NO_RET is
> > set, that doesn't happen.  Make indirect_branch_prediction_barrier()
> > take that into account by calling __write_ibpb() which already does the
> > right thing.
> 
> I find this changelog somewhat dubious. So zen < 4 basically have
> IBPB_NO_RET, your patch 2 in this series makes using SBPB for cores which
> have SRSO_NO or if the mitigation is disabled. So if you have a core which
> is zen <4 and doesn't use SBPB then what happens?

I'm afraid I don't understand the question.  In that case write_ibpb()
uses IBPB and manually clears the RSB.

-- 
Josh

