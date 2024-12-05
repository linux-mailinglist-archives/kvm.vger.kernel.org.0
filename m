Return-Path: <kvm+bounces-33178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D239E6126
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 00:12:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 343521885806
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 23:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 098321D516B;
	Thu,  5 Dec 2024 23:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnkesRnA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294C71CCEED;
	Thu,  5 Dec 2024 23:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733440330; cv=none; b=LIjiPaBlPxhLzYiPe5ezMTdVERx5AZyOA0CAZ7U8VZa4gZdU/NgjOUSsNVMJbkNls+cs+Pk54PTd8DozW8nHbBnkalsGmGBLoNzWw6n4ZOnnU9XMbSPEJ177x4qVdBhHpzvM65woyhmczm1gHTl6NBRVULrYe5wNdAdhqP2ij98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733440330; c=relaxed/simple;
	bh=1Iiia0qtbEtE06hZP1THeRahBbWaPfXeh2KJQsl0KCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HWaxgnkszg6SMgML46mxXYpX90U8cY0Jp/D3WpNJg2wdXe8dIxl5L5QAESxMKuh1so45tgrmioeFusIdl5xKqk735+ec+5uhGA4SLxo1xLGL6IR7079ByMTw7ufv9cz+j6hDycTm6DBLdtL+oVXCXz+TVlQeomHylNup0Fzn1Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnkesRnA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2650BC4CED1;
	Thu,  5 Dec 2024 23:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733440330;
	bh=1Iiia0qtbEtE06hZP1THeRahBbWaPfXeh2KJQsl0KCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CnkesRnAB4nmV6TfbGF/fOtmeXI10iPH1yTKp5oJBm4MtUsMCdwC2IQnAMqXRb9JP
	 NKGwhXvnyXXJ/pj2qsbZ5aiKqQQLvCEsJ7TguDiO3AmaZd0wB+TaFtkt1TaS3bWlgD
	 JJtBc2+GP1KhIgdRrqLZsUmjB8snKCh6TSYzYlCX14jfapr6ouNUCUa4wakjbTwdrK
	 z1fIrjzEnt/ikLa24E/0t0/X6cWaoB5FnN2X4mXkbpMS/8x4fPTDzwiJ7TKh4LiYAR
	 zOgmM1Nu81Ol+TiJjNjeuJ7//rk8dYyoWHJ2WHnteY9hsrvXwGxz60qthUObmUC0dn
	 Kiv4NKzwvMpXQ==
Date: Thu, 5 Dec 2024 15:12:07 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, amit@kernel.org, kvm@vger.kernel.org,
	amit.shah@amd.com, thomas.lendacky@amd.com, tglx@linutronix.de,
	peterz@infradead.org, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Message-ID: <20241205231207.ywcruocjqtyjsvxx@jpoimboe>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>
 <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>
 <20241202233521.u2bygrjg5toyziba@desk>
 <20241203112015.GBZ07pb74AGR-TDWt7@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241203112015.GBZ07pb74AGR-TDWt7@fat_crate.local>

On Tue, Dec 03, 2024 at 12:20:15PM +0100, Borislav Petkov wrote:
> On Mon, Dec 02, 2024 at 03:35:21PM -0800, Pawan Gupta wrote:
> > It is in this doc:
> > 
> >   https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/indirect-branch-restricted-speculation.html
> > 
> 
> I hope those URLs remain more stable than past experience shows.
> 
> >   "Processors with enhanced IBRS still support the usage model where IBRS is
> >   set only in the OS/VMM for OSes that enable SMEP. To do this, such
> >   processors will ensure that guest behavior cannot control the RSB after a
> >   VM exit once IBRS is set, even if IBRS was not set at the time of the VM
> >   exit."
> 
> ACK, thanks.
> 
> Now, can we pls add those excerpts to Documentation/ and point to them from
> the code so that it is crystal clear why it is ok?

Ok, I'll try to write up a document.  I'm thinking it should go in its
own return-based-attacks.rst file rather than spectre.rst, which is more
of an outdated historical document at this point.  And we want this
document to actually be read (and kept up to date) by developers instead
of mostly ignored like the others.

-- 
Josh

