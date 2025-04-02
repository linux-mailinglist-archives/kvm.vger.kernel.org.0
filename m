Return-Path: <kvm+bounces-42474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B27A790FF
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 16:20:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 701781892D2E
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 14:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86593239072;
	Wed,  2 Apr 2025 14:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XPbzLk2W"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A6523643E;
	Wed,  2 Apr 2025 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743603419; cv=none; b=HPp9IjDDjJHtVcNtyW7qjZEnD1Wbuuotd2dmMcf6VHpYBLpcEbtjB4wF1VtuNeaFuQPOZ0OYgUAdFFQRpzTJbCOg+q5joA/kaoD/Y37Ku3GW02S6RerHAyB2Gg7vincWCBlWPNYaWlUzdnqSblhFTbo5+vx/M1ZK3RD4ez/qJLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743603419; c=relaxed/simple;
	bh=orHRFiP7tPTIweKu8AyOtAuC/svXlElWERYo0NHQ05U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YBcFzPwstvvi/WoKhwPEJpKkNZG3Wln+tBl8ckb2Ab6n+TiGtDrTOprFfvHfI6gOb6gqc4X0U5F73phHe0bW0sccHzIA87MSgy7eHtLw5Ecfz/btRoH51HpKj0eSwvqn+AuU9A1AgTijKPWkHM5EKMkfs3AqzIdyiuIWXupRobc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XPbzLk2W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38FDC4CEDD;
	Wed,  2 Apr 2025 14:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743603419;
	bh=orHRFiP7tPTIweKu8AyOtAuC/svXlElWERYo0NHQ05U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XPbzLk2W95Fs76RlRux729HFKI25VSLcTyyg5hCIpvl1Bjq+zf453YhNAkhTzb1s9
	 5twhBgIQpokA8lWUp9y4mgMrWItD2PjjD1W+x/OuedKjNKWtUc673mMciGloQ/SMKp
	 gzeCkh/hibxVJr5NYh4Dk/ZpcXViLSK3zF7RfY/ld/zG3FTGKNYKG1nbOt5jxFk+qY
	 aZyZrVYLb96vaf0GbzJGX3ukKtZ329RHRqEtULIoEls81Wawz/IdiMvRqx0bt9kbR8
	 /Ynfq0UwkJCMfGM/8cS9xitNhtoVK5K10ct3t0O4nqd1FLehgtkSTr5o5EMN1LLEys
	 qsAvIlxgAVHmw==
Date: Wed, 2 Apr 2025 07:16:55 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: "Shah, Amit" <Amit.Shah@amd.com>
Cc: "bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>, 
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com" <kai.huang@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, 
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"Moger, Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>, 
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "hpa@zytor.com" <hpa@zytor.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, "Kaplan, David" <David.Kaplan@amd.com>, 
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Message-ID: <g5xe26esmtoqevdgxueapvtvojgi63z3lsdzr3jyyo3cmcb2tj@gpeofgbzjzch>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>
 <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>
 <20241202233521.u2bygrjg5toyziba@desk>
 <20241203112015.GBZ07pb74AGR-TDWt7@fat_crate.local>
 <20241205231207.ywcruocjqtyjsvxx@jpoimboe>
 <6bfb74e5f05ab8d4cecda1c09a235ccc59c84be6.camel@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6bfb74e5f05ab8d4cecda1c09a235ccc59c84be6.camel@amd.com>

On Wed, Apr 02, 2025 at 09:19:19AM +0000, Shah, Amit wrote:
> On Thu, 2024-12-05 at 15:12 -0800, Josh Poimboeuf wrote:
> > On Tue, Dec 03, 2024 at 12:20:15PM +0100, Borislav Petkov wrote:
> > > On Mon, Dec 02, 2024 at 03:35:21PM -0800, Pawan Gupta wrote:
> > > > It is in this doc:
> > > > 
> > > >  
> > > > https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/indirect-branch-restricted-speculation.html
> > > > 
> > > 
> > > I hope those URLs remain more stable than past experience shows.
> > > 
> > > >   "Processors with enhanced IBRS still support the usage model
> > > > where IBRS is
> > > >   set only in the OS/VMM for OSes that enable SMEP. To do this,
> > > > such
> > > >   processors will ensure that guest behavior cannot control the
> > > > RSB after a
> > > >   VM exit once IBRS is set, even if IBRS was not set at the time
> > > > of the VM
> > > >   exit."
> > > 
> > > ACK, thanks.
> > > 
> > > Now, can we pls add those excerpts to Documentation/ and point to
> > > them from
> > > the code so that it is crystal clear why it is ok?
> > 
> > Ok, I'll try to write up a document.  I'm thinking it should go in
> > its
> > own return-based-attacks.rst file rather than spectre.rst, which is
> > more
> > of an outdated historical document at this point.  And we want this
> > document to actually be read (and kept up to date) by developers
> > instead
> > of mostly ignored like the others.
> > 
> 
> Hey Josh,
> 
> Do you plan to submit a v3 with the changes?

Thanks for the reminder, I actually had the patches ready to go a few
months ago (with a fancy new doc) and then forgot to post.  Let me dust
off the cobwebs.

-- 
Josh

