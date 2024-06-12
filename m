Return-Path: <kvm+bounces-19446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 128E29052A2
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:38:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91B7FB2274D
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 12:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A51170844;
	Wed, 12 Jun 2024 12:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQzuenDC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C133416F29C;
	Wed, 12 Jun 2024 12:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718195888; cv=none; b=FHONbCjR7lVEnLB1/UWPvdKasqxCnzo9Dc9SLfCwLDtKPXLrLC3gYoJb4HRWfIX6tQVffXM1e5NvKX+fu4oPH67s1RVBg4ZuuQ6W/j/u7n94f0uvXE8oGBRKS09MNgCeT3kT+Bs5lmGpjCvG9XpHJXGnnraHshEyH7XtXtoWrN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718195888; c=relaxed/simple;
	bh=RMhTmUYidEH/Wcb7QQv/55jUD5NSSnQO9os8yqUo8Wk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O8AbqvJUVm/sp4DWGJN3WazdWagwle5bRmCCGkzhlLdRW+YlOBjVzXad3EUMEfCXBDRO6H0giFr94qDc5LRDYwijgJa3pq4iYmK9EuMYiaLMzQJUfkG/pLPP2hm8GHJGmH0t5mVF3ZsMrXjl1ZejPy6AcZyZdwLRrQCcJPE3RTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQzuenDC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1857C3277B;
	Wed, 12 Jun 2024 12:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718195888;
	bh=RMhTmUYidEH/Wcb7QQv/55jUD5NSSnQO9os8yqUo8Wk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XQzuenDC7J1p/Wn/LXlAu1FCsX7iDKTSry7WfkaCEAPejGVTLULQAD2lsDdXqn568
	 qXEX52V4/MeIE3gOvzvF9bw6r1gkM9WIf+3E1ntTpwmL3RpBFD2EJvrg+8TK4wluJN
	 4YhHY16AjZ6JJsvmgoccY++7diOphNQ7x87icx+M=
Date: Wed, 12 Jun 2024 14:38:05 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: Sasha Levin <sashal@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Haimin Zhang <tcs_kernel@tencent.com>,
	TCS Robot <tcs_robot@tencent.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH MANUALSEL 4.19 1/2] KVM: x86: Handle SRCU initialization
 failure during page track init
Message-ID: <2024061239-tinfoil-cryptic-e638@gregkh>
References: <20211006111259.264427-1-sashal@kernel.org>
 <0fd9f7e5-697f-6ad0-b1e3-40bd48a8efae@redhat.com>
 <9acccdfe-b7d8-b59d-7b00-d5a266b84d36@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9acccdfe-b7d8-b59d-7b00-d5a266b84d36@huawei.com>

On Wed, May 29, 2024 at 04:29:32PM +0800, Zenghui Yu wrote:
> On 2021/10/6 19:23, Paolo Bonzini wrote:
> > On 06/10/21 13:12, Sasha Levin wrote:
> > > From: Haimin Zhang <tcs_kernel@tencent.com>
> > >
> > > [ Upstream commit eb7511bf9182292ef1df1082d23039e856d1ddfb ]
> > >
> > > Check the return of init_srcu_struct(), which can fail due to OOM, when
> > > initializing the page track mechanism.  Lack of checking leads to a NULL
> > > pointer deref found by a modified syzkaller.
> > >
> > > Reported-by: TCS Robot <tcs_robot@tencent.com>
> > > Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
> > > Message-Id: <1630636626-12262-1-git-send-email-tcs_kernel@tencent.com>
> > > [Move the call towards the beginning of kvm_arch_init_vm. - Paolo]
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Sasha, will this patch be applied for 4.19?
> 
> The same question for the 5.4 backport [*]. It looks like both of them
> are missed for unknown reasons.
> 
> [*] https://lore.kernel.org/stable/20211006111250.264294-1-sashal@kernel.org

This was from 2021, quite a while ago.

Can you please send them in backported form if you feel they should be
applied?

thanks,

greg k-h

