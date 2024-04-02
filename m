Return-Path: <kvm+bounces-13349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC130894CAF
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 09:33:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 925CE1F22414
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 07:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41CD13C471;
	Tue,  2 Apr 2024 07:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q45gGveN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2D539AD5;
	Tue,  2 Apr 2024 07:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712043221; cv=none; b=qi9UEs2ex1woO47XIbNat0xf8nQZ1jYN9R+rqCItDbPoPWuRPYXJl3L+NTLciK0UGe4G/1zRptF17FrmiTkYNlE2t8YyTCtyi4RGNNRS/xYGTdp61/PIbSr+gXK0nXHnsgYwGTl+UJ7OLZBlcLy8TuusSbyY3v8XRC/RZDZcjp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712043221; c=relaxed/simple;
	bh=m/HmUPqKtAU2Uzx9nZeyjvyqOP6z3AWH/L98dSBa2eE=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j+nVhyR47v7rwaZyHSUYstn6pA4io4uaBrkAzT/SOnAWWxam6nzHbs9Cb9BqsJkvff9lTafSYhhCskB7p6xsK9Vg67LD5ATSAa0poFfgtPDUd0x/qGYGjxJebVxIXAZ4Gv+3al41ZDJ0Kpa7Ma/DvgjMLbg8szeZaNF9lZnEeuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q45gGveN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DFEC433F1;
	Tue,  2 Apr 2024 07:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712043220;
	bh=m/HmUPqKtAU2Uzx9nZeyjvyqOP6z3AWH/L98dSBa2eE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q45gGveNzJJNmszpvI5WF3tatmQxt0nBrDNzXVfcUvtoKdEArlvelGXMiNea3muXS
	 AwsWrkMjm2FR4+yXI6W5figU2Hc9V21fJTdwGugb+Eb/5lnFimTnLQZ4r6hMgIJkaW
	 7NtTQTNsXB3hRf4d0NIa+qRqyyoxfl84SLzLpK33CGpGizwSVyKl03yHW8+Nyo4pdB
	 I3OZQdjtoeD9WRNWs0VoQGpgdbqMq/HxtyDPjR5D2HLH6QkrBBi+Dj3s/u49291KC8
	 yawsn9G89FH1p6za4/EEB17IMDpni4jtNxIbUIi+eFdq8Xh4zhEzzIbL3bOzXRcD7z
	 XMa9VuwynDwrw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rrYeI-000bjD-4I;
	Tue, 02 Apr 2024 08:33:38 +0100
Date: Tue, 02 Apr 2024 08:33:37 +0100
Message-ID: <86bk6sz0a6.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Yu Zhao <yuzhao@google.com>
Cc: James Houghton <jthoughton@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Gavin Shan <gshan@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Rientjes <rientjes@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] KVM: arm64: Participate in bitmap-based PTE aging
In-Reply-To: <CAOUHufaQ-g6L5roB-3K0GamuS3p9ACpPj9XM-NF67GgrjoTj_A@mail.gmail.com>
References: <20240401232946.1837665-1-jthoughton@google.com>
	<20240401232946.1837665-7-jthoughton@google.com>
	<CAOUHufaQ-g6L5roB-3K0GamuS3p9ACpPj9XM-NF67GgrjoTj_A@mail.gmail.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: yuzhao@google.com, jthoughton@google.com, akpm@linux-foundation.org, pbonzini@redhat.com, dmatlack@google.com, oliver.upton@linux.dev, seanjc@google.com, corbet@lwn.net, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, shahuang@redhat.com, gshan@redhat.com, ricarkol@google.com, rananta@google.com, ryan.roberts@arm.com, rientjes@google.com, axelrasmussen@google.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 02 Apr 2024 05:06:56 +0100,
Yu Zhao <yuzhao@google.com> wrote:
>=20
> On Mon, Apr 1, 2024 at 7:30=E2=80=AFPM James Houghton <jthoughton@google.=
com> wrote:
> >
> > Participate in bitmap-based aging while grabbing the KVM MMU lock for
> > reading. Ideally we wouldn't need to grab this lock at all, but that
> > would require a more intrustive and risky change.
>                        ^^^^^^^^^^ intrusive
> This sounds subjective -- I'd just present the challenges and let
> reviewers make their own judgements.

Quite the opposite.

This sort of comment actually indicates that the author has at least
understood some of the complexity behind the proposed changes. It is a
qualitative comment that conveys useful information to reviewers, and
even more to the maintainers of this code.

That's the difference between a human developer and a bot, and I'm not
overly fond of bots.

	M.

--=20
Without deviation from the norm, progress is not possible.

