Return-Path: <kvm+bounces-23330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C63948BC2
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 10:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5DBE282514
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 08:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE581BDA93;
	Tue,  6 Aug 2024 08:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TvyE56tY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4666D16BE17;
	Tue,  6 Aug 2024 08:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722934526; cv=none; b=dPA5AGg8WHWyznPe+vnoyoR1BhmXme/jiQtngSH8NGaZQQoLLED8TKgirnAZ6MyJ71wyhf4ZZlLbwHQc5cgAu0VV9IF3BPioOxdLPcsTLHQdHH9XJ1R21X5MUgXT33dlUlrr3ZpD3wX6QZhHiWq4SlbNDunYxTOgygjprIBoeiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722934526; c=relaxed/simple;
	bh=fNf9KpbqDQ65Rk4oRZ3GXyFRT5bkqehalm3Q1gthkSc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fQEwLiTlXhMCATNzSrcJTvnniGwE1O+Dp2VUEtymAkuetbIKNIkn4n7PafWgr+Uq+eh1n1zeOb9QBOfHh/XvWLn5H9kJaV38kOK5pGu1cqZxRojvZqDf0RN2B3/IJaPJYgSfrjmjvsYXIHcz6SoSEeLTaV9bvhrlXcIliSMc/u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TvyE56tY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADD4C32786;
	Tue,  6 Aug 2024 08:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722934525;
	bh=fNf9KpbqDQ65Rk4oRZ3GXyFRT5bkqehalm3Q1gthkSc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TvyE56tYK3MKji+0edYs5FwYHls/3UPSKwVbaoXysQtem6W2x+AET4eygFoJ270tI
	 6is1jeOuW5z+PbS7fnA27BMCC3phJInVGslO8AhaKB9ivP5S2ZBEhteFvegf0sNC07
	 YuYNAYg3Ep0MduJiROIWjoOmIH55ccwgUfSuNAPNx6hoXS8jgGo2ML5Y+EbSKa//H6
	 qXIOM/QqJNB7uUWkG7Of8+R8HbDap7Dq1ryl/W6Vm+HeJRqfR1e4JB09R8xYefspTt
	 olHjIDWbI3frln7WrTDqsLUJrFNhb1Dd1/4PSD3AIjdlmZxoljfb5rTBMMtrJ7t0uu
	 cPa7Eq2CqB8qw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sbFyV-001J7s-7B;
	Tue, 06 Aug 2024 09:55:23 +0100
Date: Tue, 06 Aug 2024 09:55:22 +0100
Message-ID: <86ikwe2fph.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	David Matlack <dmatlack@google.com>,
	David Stevens <stevensd@chromium.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v12 54/84] KVM: arm64: Mark "struct page" pfns accessed/dirty before dropping mmu_lock
In-Reply-To: <ZrFfvjy_-Tyx4xUV@linux.dev>
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-55-seanjc@google.com>
	<ZrFfgzRbiqT-Zi2O@linux.dev>
	<ZrFfvjy_-Tyx4xUV@linux.dev>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.3
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, seanjc@google.com, pbonzini@redhat.com, zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, dmatlack@google.com, stevensd@chromium.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 06 Aug 2024 00:26:54 +0100,
Oliver Upton <oliver.upton@linux.dev> wrote:
> 
> On Mon, Aug 05, 2024 at 11:26:03PM +0000, Oliver Upton wrote:
> > [+cc Fuad]
> 
> Take 2!
> 
> > Fuad, you mentioned in commit 9c30fc615daa ("KVM: arm64: Move setting
> > the page as dirty out of the critical section") that restructuring
> > around the MMU lock was helpful for reuse (presumably for pKVM), but I
> > lack the context there.
> > 
> > On Fri, Jul 26, 2024 at 04:52:03PM -0700, Sean Christopherson wrote:
> > > Mark pages/folios accessed+dirty prior to dropping mmu_lock, as marking a
> > > page/folio dirty after it has been written back can make some filesystems
> > > unhappy (backing KVM guests will such filesystem files is uncommon, and
> > 
> > typo: s/will/with/
> > 
> > > the race is minuscule, hence the lack of complaints).  See the link below
> > > for details.

Should we consider reverting 9c30fc615daa then?

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.

