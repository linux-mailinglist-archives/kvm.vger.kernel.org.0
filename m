Return-Path: <kvm+bounces-26298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8342C973D1B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:22:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0E14B2199E
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37FAB1A08A6;
	Tue, 10 Sep 2024 16:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h25i9jpy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5A56A022;
	Tue, 10 Sep 2024 16:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985361; cv=none; b=RRAWG+VgII6PiBGvQWPrdS85jE1OJwmauzn58icLUtyeMpZcNZ8XM0hQ8UnxWiA0+BMyF6CQXaS/LSRNzyeqsSxa6N40/8weevohZxCw5Mf9XpkJYEg7PzbhNNYDAn8OQr4GWaajnpz8JSBuf4koHPP5asquo8Bk83RL76vMuEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985361; c=relaxed/simple;
	bh=QtTIziDJn2hWVIqsYe1L4T1YiTgroLjyBXJGDuCTVy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gp6+ed3lPTq+aWoXaD+jbteaYphYNWW4zs9t9V+Gm/nCAs+2xqvfQUnnT7fJfU6ri6lPO1NvievQXimyNRsf2LQLIDJh/EhZqwq/5GGY4B6kMaAu540Bu25McqpyD1eOkqerRZ9TWg7cSfcKEgtQYpyjwY4GLCZ1Xg6uYJTiulE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h25i9jpy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8A6C4CEC3;
	Tue, 10 Sep 2024 16:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725985361;
	bh=QtTIziDJn2hWVIqsYe1L4T1YiTgroLjyBXJGDuCTVy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h25i9jpyqSUpXnnUTSAQPo1qC04Pnp7MFSQPRspk/erZ/lrxXMBTS3k4Poe5HsxL3
	 pLMKoYLvXltB9iAh5KxakzF263VA9/9quFMiwT1eTJSLM6uJMUWZJKDxno/HGpEu5k
	 b+FLqe/ctp0hHuQ0f1skXpOVXhIe4lvXEAg6uHKyoaEHBsu/Taqdhc8upf5HLGGTZD
	 VMIdRDSHl2duImeleXAqDb0Zqkqf9m9836jep9wC4fa5cB8gNtWNh+Uwm8AjtHONcw
	 gu4FTvzhC5skWFeHqG08H1vXYrMHqqrTU3uj7rki6f6LF2WD8D+h96oAWRKEw4zYwT
	 eQ9a3TnnKBwNg==
Date: Tue, 10 Sep 2024 09:22:38 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	Zeng Guang <guang.zeng@intel.com>
Subject: Re: [PATCH v2 0/7] KVM: nVMX: Fix IPIv vs. nested posted interrupts
Message-ID: <20240910162238.GB117481@thelio-3990X>
References: <20240906043413.1049633-1-seanjc@google.com>
 <172594254948.1553040.1513231357668918094.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172594254948.1553040.1513231357668918094.b4-ty@google.com>

On Mon, Sep 09, 2024 at 09:56:42PM -0700, Sean Christopherson wrote:
> On Thu, 05 Sep 2024 21:34:06 -0700, Sean Christopherson wrote:
> > Fix a bug where KVM injects L2's nested posted interrupt into L1 as a
> > nested VM-Exit instead of triggering PI processing.  The actual bug is
> > technically a generic nested posted interrupts problem, but due to the
> > way that KVM handles interrupt delivery, the issue is mostly limited to
> > to IPI virtualization being enabled.
> > 
> > Found by the nested posted interrupt KUT test on SPR.
> > 
> > [...]
> 
> Trying this again, hopefully with less awful testing this time...

I meant to reply yesterday but I guess I lost track of time. This passed
my testing on all my machines, so it is not as bad as last time :)

Cheers,
Nathan

