Return-Path: <kvm+bounces-42776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CE0A7C726
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 02:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F1AD3B6656
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 00:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C86B171C9;
	Sat,  5 Apr 2025 00:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tjiXTeL2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFDA6FC3;
	Sat,  5 Apr 2025 00:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743814601; cv=none; b=PwSMch/O+8k4x3jpnMhaB33yL+ON9SoU/RN7202NJO1DrUNgMDA8LIJwI60YDrsBHgzZsAuc7uwLlpIMXf1EtZZ4OxjyLHSdT/msCA5UtH67vi51GnMzn2zx6iewISjZuGFp5Zuoi+AJwjDgJU2HQ/CDW+KN0lVaPSSlmEgXT/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743814601; c=relaxed/simple;
	bh=zCzeNB5rhGscFFF4qQ7vn3/tfI4COIkAp0STkLQVQ5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cr75jihmL8GhghKOtAjfFHXBSnA3/ZUYpxrtxFDxEIEgh1R6vnkrlZq1TTk3/qOW0TITTzWjK8hp2LviO5nEkINFi9MpM6NHPYAGuqePWX69KAAFTdhhHRRpIGvzVqqpBYhCBxQRN1GTFsuzyWVTM2UM2AInwCRuDIM1c9nS9QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tjiXTeL2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B4AC4CEDD;
	Sat,  5 Apr 2025 00:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743814601;
	bh=zCzeNB5rhGscFFF4qQ7vn3/tfI4COIkAp0STkLQVQ5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tjiXTeL2Q0uOFnWs4QPKSoRFVbqBW2JfGhCpNzBO4NrN24uAG9ZU6ZTA1qXBULYQm
	 k7TNKoACS9fNGcjrk5I4LQtz4NvdiFvsMZ4AeIGNZ9RqoOpjP8gNkFh+7q03NaEfjK
	 a94T/Fq0i3Am9jeRggenEGUO9Qcf5EuweKj7Ei9FmCkXFTSeyemKNgrFPBvhRGltbn
	 FdWQsYqRMEVIMb/PlJ5aSRQBQiP0j+awi3Wf4ugw32h8HWDgQF6kB+ywqUemM64opQ
	 ugsU8Pv1L/HgCEkc6Z5xV9y2booH7Nb5j2wzFnXFHke+krVnmkKxQuP0h+stFStXQv
	 6l5MtnO8w5g5g==
Date: Fri, 4 Apr 2025 17:56:37 -0700
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
Message-ID: <j75r3jm5sujsn3hhf5prto3vcnl4nitsiqb5fp4rlwgqhlwylu@ofi3g6valzu2>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <27fe2029a2ef8bc0909e53e7e4c3f5b437242627.1743617897.git.jpoimboe@kernel.org>
 <d5ad36d8-40da-4c13-a6a7-ed8494496577@suse.com>
 <ioxjh7izpnmbutljkbhdqorlpwtm5iwosorltmhkp3t7nyoqlo@tiecv24hnbar>
 <86903805-569a-41d5-93d8-df8169e61cef@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86903805-569a-41d5-93d8-df8169e61cef@suse.com>

On Sat, Apr 05, 2025 at 01:56:59AM +0300, Nikolay Borisov wrote:
> On 4.04.25 г. 18:17 ч., Josh Poimboeuf wrote:
> > On Fri, Apr 04, 2025 at 05:45:37PM +0300, Nikolay Borisov wrote:
> > > 
> > > 
> > > On 2.04.25 г. 21:19 ч., Josh Poimboeuf wrote:
> > > > IBPB is expected to clear the RSB.  However, if X86_BUG_IBPB_NO_RET is
> > > > set, that doesn't happen.  Make indirect_branch_prediction_barrier()
> > > > take that into account by calling __write_ibpb() which already does the
> > > > right thing.
> > > 
> > > I find this changelog somewhat dubious. So zen < 4 basically have
> > > IBPB_NO_RET, your patch 2 in this series makes using SBPB for cores which
> > > have SRSO_NO or if the mitigation is disabled. So if you have a core which
> > > is zen <4 and doesn't use SBPB then what happens?
> > 
> > I'm afraid I don't understand the question.  In that case write_ibpb()
> > uses IBPB and manually clears the RSB.
> > 
> 
> Actually isn't this patch a noop. The old code simply wrote the value of
> x86_pred_cmd to the IA32-PRED_CMD register iff FEATURE_IBPB was set. So
> x86_pred_cmd might contain either PRED_CMD_IBPB or PRED_CMD_SBPB, meaning
> the correct value was written.
> 
> With your change you now call __write_ibpb() which does effectively the same
> thing.

Hm, are you getting SBPB and IBPB_NO_RET mixed up?  They're completely
separate and distinct:

  - SBPB is an AMD feature which is just like IBPB, except it doesn't
    flush branch type predictions.  It can be used when the SRSO
    mitigation isn't needed.  That was fixed by the previous patch.

  - AMD has a bug on older CPUs where IBPB doesn't flush the RSB.  Such
    CPUs have X86_BUG_IBPB_NO_RET set.  That's fixed with this patch due
    to the fact that write_ibpb() has this:

	/* Make sure IBPB clears return stack preductions too. */
	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_BUG_IBPB_NO_RET

So you're right in that this patch doesn't change SBPB behavior.  But
that's not what it intends to do :-)

-- 
Josh

