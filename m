Return-Path: <kvm+bounces-33337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6873B9EA091
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 21:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E48616518F
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 20:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49A4B19AD8C;
	Mon,  9 Dec 2024 20:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pjmsQ877"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCDF1E515;
	Mon,  9 Dec 2024 20:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733777178; cv=none; b=HFGOhFuK5OXz0Aagxc7cIn4rauYzdBkkhlsyr5vgFzoqRO1QAF2ocKrDCXzeDSz/jp7z9ZKi2R5y4N/vG8UB0FyrE7TglRa6U9qRplk+WumD6RHCtQ9xtOjNbCMRgQUkIk206QXvb7ChK1qP10c6/PBMjhVnaJRsh12beok1NfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733777178; c=relaxed/simple;
	bh=Sy0df8OMuc4UsW/w9DP2NkGuhHpfQjU4nY1+/BUPqwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LghYGylL5+NbnhLMVFzeew7HdfYV0WEkdis6afDDMPNbUaISHykLRXHNoMwmvdNVON7LFxvBz8J/tOmD75o4j1VvsNE0orCkPNo7DPcEGMqftENgI+06CCDJytPewGT+AU4iibx46IYptfOmbxHigA714u37hYLea1BQy/R8XlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pjmsQ877; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A4FC4CED1;
	Mon,  9 Dec 2024 20:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733777178;
	bh=Sy0df8OMuc4UsW/w9DP2NkGuhHpfQjU4nY1+/BUPqwQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pjmsQ877mVXX7WxC7t98yJX9nWWusdu+4wwmCq1oiM3hPLhepBzELnA2qAbmSSwkJ
	 cXWNI8GqyTfzi1sf7Gz3E2boPBs8MuoTLoFuxt4qIg6fJ2OmHh5EWbQQtBnBuYRlv8
	 1b1cD09B6a7wmkmtot/vp0UGhYK8hH23NtZmj/Yf13MkfMMlaS3c4+uoNRhx6hoChQ
	 E1IqKTFjrVfp/JEpMdZHHh5xJN9BH4/FqAqrotr6KDxZOWI/Pvme8jvqa3XrKE5XXv
	 8I86ton2hJFzeA87tV2ergcgD+HVpynyex1IMDazsUE9Vze5VmB7hPV/lBz9oFGx1C
	 SqOmuZYUM/5xw==
Date: Mon, 9 Dec 2024 12:46:14 -0800
From: "jpoimboe@kernel.org" <jpoimboe@kernel.org>
To: "Shah, Amit" <Amit.Shah@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"kai.huang@intel.com" <kai.huang@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Moger, Babu" <Babu.Moger@amd.com>,
	"Das1, Sandipan" <Sandipan.Das@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"bp@alien8.de" <bp@alien8.de>,
	"Kaplan, David" <David.Kaplan@amd.com>
Subject: Re: [PATCH v2 2/2] x86/bugs: Don't fill RSB on context switch with
 eIBRS
Message-ID: <20241209204614.vzmb4dr3sfelcixk@jpoimboe>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <d6b0c08000aa96221239ace37dd53e3f1919926c.1732219175.git.jpoimboe@kernel.org>
 <20241205233245.4xaicvusl5tfp2oi@jpoimboe>
 <f1d0197349388c1785eeba356a26553ced29800c.camel@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1d0197349388c1785eeba356a26553ced29800c.camel@amd.com>

On Fri, Dec 06, 2024 at 10:10:31AM +0000, Shah, Amit wrote:
> On Thu, 2024-12-05 at 15:32 -0800, Josh Poimboeuf wrote:
> > On Thu, Nov 21, 2024 at 12:07:19PM -0800, Josh Poimboeuf wrote:
> > > User->user Spectre v2 attacks (including RSB) across context
> > > switches
> > > are already mitigated by IBPB in cond_mitigation(), if enabled
> > > globally
> > > or if either the prev or the next task has opted in to protection. 
> > > RSB
> > > filling without IBPB serves no purpose for protecting user space,
> > > as
> > > indirect branches are still vulnerable.
> > 
> > Question for Intel/AMD folks: where is it documented that IBPB clears
> > the RSB?  I thought I'd seen this somewhere but I can't seem to find
> > it.
> 
> "AMD64 TECHNOLOGY INDIRECT BRANCH CONTROL EXTENSION"
> https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/white-papers/111006-architecture-guidelines-update-amd64-technology-indirect-branch-control-extension.pdf
> 
> has:
> 
> Indirect branch prediction barrier (IBPB) exists at MSR 0x49 (PRED_CMD)
> it 0. This is a write only MSR that both GP faults when software reads
> it or if software tries to write any of the bits in 63:1. When bit zero
> is written, the processor guarantees that older indirect branches
> cannot influence predictions of indirect branches in the future. This
> applies to jmp indirects, call indirects and returns. As this restricts
> the processor from using all previous indirect branch information, it
> is  intended to only be used by software when switching from one user
> context to another user context that requires protection, or from one
> guest to another guest.

Sounds like that needs to be updated to mention the IBPB_RET bit.

-- 
Josh

