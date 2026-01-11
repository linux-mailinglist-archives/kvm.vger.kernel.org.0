Return-Path: <kvm+bounces-67671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C4FBAD0F10A
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 15:11:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 05396300A50A
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 14:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43EFE34164B;
	Sun, 11 Jan 2026 14:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="BKDMHQNS"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7159A33FE2E
	for <kvm@vger.kernel.org>; Sun, 11 Jan 2026 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768140711; cv=none; b=e9EWD58SxgnaoE03CCR+UpCqmi08PJwgmZxNO9clhm4BM0g/Cvn6aj4AuSFoGnwlF1n5qsgguhhHKB102OfpmS2t5H+L0d0zm+p5qfg0Q5bOr55liThxAR6xR+iAPQwEWsnwm0qcDETHRSlj4dc+YjdwwAEmqGykj/0nn6GbuVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768140711; c=relaxed/simple;
	bh=m/39cP4ChtcaZqn5v4tJy5D0O2mK9SzKVD8lnUZ0aTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuY391ba53dkqzo9Pq5w2P59pI0ZXCsrubCew2dgitjjv7Qq8f9yTjZV2brciLJy7hdHlPhP5N8MeZlWm6qjOQ2UtBVDqBgy7jVJr9t/T8zm87CJ2V2/oZgrPq9UHs+/x70qMjIHcO1r45JbO5Uox3InpnVKZx5tX43bB3AkAls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=BKDMHQNS; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=ioG69/GtrWYK1SDvXNBCpr0/tF+/m/pe5JE6q8DF188=; b=BKDMHQNS+rpd0hAB
	kMOUSQBdfEndwxEz39ARIAWZiSRD4PmIGxiUmmK0YFRfgi5zky2pmZMILlPtgYbK1CiYQt1Cd7KX+
	hYo8AVwqeGlVLU2iEPwAMHUdUzZKhLtVTDb+SfnPnYVEh72ASuMCKw87whvXu25P929IpmLCTGo/S
	Dwmqo8IMt2ZBpqz6paWzp2dSb4dMrnatgwjmLuHlcI/Xo8kpj8F1aRi1cRlntEo6ox/Ve30bRBFiH
	IKv2BrooisymFgsCgAD0UQSxIRCoOWNcMyb3UB6P9e2hIjuEayMamNcyp3AV1iVg2u3trB770enAM
	5n1NDvLo09Ugo4CqrQ==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vewAF-0000000DtGN-1OrJ;
	Sun, 11 Jan 2026 14:11:31 +0000
Date: Sun, 11 Jan 2026 14:11:31 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Markus Armbruster <armbru@redhat.com>
Cc: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	qemu-devel@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, qemu-riscv@nongnu.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Max Filippov <jcmvbkbc@gmail.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] monitor/hmp: Reduce target-specific definitions
Message-ID: <aWOvk527PkZzLtSp@gallifrey>
References: <20260107182019.51769-1-philmd@linaro.org>
 <20260107182019.51769-3-philmd@linaro.org>
 <87jyxsczyk.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87jyxsczyk.fsf@pond.sub.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 14:06:23 up 76 days, 13:42,  2 users,  load average: 0.16, 0.04,
 0.01
User-Agent: Mutt/2.2.13 (2024-03-09)

* Markus Armbruster (armbru@redhat.com) wrote:
> Philippe Mathieu-Daudé <philmd@linaro.org> writes:
> 
> > From "monitor/hmp-target.h", only the MonitorDef structure
> > is target specific (by using the 'target_long' type). All
> > the rest (even target_monitor_defs and target_get_monitor_def)
> > can be exposed to target-agnostic units, allowing to build
> > some of them in meson common source set.
> >
> > Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> 
> The only use of the ->get_value() callback I can see is in
> get_monitor_def(), to implement HMP's $register feature.  I can't see
> the callback being set.  Is it dead?

I think I see that being used in ppc;
target/ppc/ppc-qmp-cmds.c

const MonitorDef monitor_defs[] = {
    { "fpscr", offsetof(CPUPPCState, fpscr) },
    /* Next instruction pointer */
    { "nip|pc", offsetof(CPUPPCState, nip) },
    { "lr", offsetof(CPUPPCState, lr) },
    { "ctr", offsetof(CPUPPCState, ctr) },
    { "decr", 0, &monitor_get_decr, },
    { "ccr|cr", 0, &monitor_get_ccr, },
    /* Machine state register */
    { "xer", 0, &monitor_get_xer },
    { "msr", offsetof(CPUPPCState, msr) },
    { "tbu", 0, &monitor_get_tbu, },
#if defined(TARGET_PPC64)
    { "tb", 0, &monitor_get_tbl, },
#else
    { "tbl", 0, &monitor_get_tbl, },
#endif
    { NULL },
};

those monitor_get_* functions are that get_value() aren't they?

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

