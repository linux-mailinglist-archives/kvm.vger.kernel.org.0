Return-Path: <kvm+bounces-34753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D56EEA05531
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 09:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A02B37A2530
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 08:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18E61E0B96;
	Wed,  8 Jan 2025 08:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cz32t/Mv"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9590513B288;
	Wed,  8 Jan 2025 08:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736324571; cv=none; b=hCBirCsazJaxLsGJrSzh+SDWZuk33k4NFKvECixDFCcr1tU4OPsuOAZRmRObV2BLOMQdBKKDg0TQcDD6wuHKJpNdeyIGOjFNMitp9Y9Afa75ZLlcj3WGuOxfVB/gxeq3ogdkkx8FobQbN5i3muZqP35folS95b7yWF+Vt0ZZkjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736324571; c=relaxed/simple;
	bh=RSNZwaEEfmOnQgVr07DlVfG3QNVlLshsQgNWKqbA9f0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MrvimwnB0t3L/FZj89Bpw0LRpbVCN8iygr5QjkAkdudWvt8Csnlak19jECvw8meBqzZWA9f0rdArKcLaV1SE7/Y4VHlaDlK+VzUG3KvIdBb2bz9694lHwGaxw/G784NGdvnYzAPcL+SMuQOs7IMYmHZoCIlOVp1YTPjEbrpX0mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cz32t/Mv; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1A81640E0269;
	Wed,  8 Jan 2025 08:22:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id FlDDmeWFgDWE; Wed,  8 Jan 2025 08:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736324563; bh=cB9+0Ue/NA2ab0Bs46sOO2KuTiD3MfhQ5A0yyPKrpHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cz32t/Mvja9vA1RptNZ47qpxYHRobsQCfynqN7HJbMTIV0/B/XqX7LCMMDgRbfvf6
	 UkbSFKP2mIan2q+dWmk0le1ZzC//FFEh00LeBStjJSfDptIQddyfCHvf/sD0EUdQiE
	 sRDbh6ZKybKgRaIW97R2H5J4A3eTyHF/H6I9CpSWOaLyj7TPSq5ILTBb3B6ae6Eh+t
	 tCMpiSzeS+wPFhE9mZYUDT+ssGnly/eAGnavyg4u4G26ETHlhX2QfxFYG0coP/gB4F
	 OUVKrGLHgEeAGKcn8cGjT6ZFo1zYatZPKC/LNVKrwyH8sKUninUJM2QjSdSwdvmVO4
	 QQKd9EO21fusX0scKB4VKmiWShlR3w/Upj54WD6TYgb9penBKrF804GdmSxLq0ix81
	 LtTg+HpBdenMDV/o1y4B/Woj76fypKqOnT4+Qzdgy3ICmvyIYp5ehfdiAIuBO6BrFr
	 0JhxdJceT6rS8hH6AsaTToXSgv+3716Iv6bG9A1P2SoExejtqiLQIeN2N5Hh3RlFH1
	 KaZ17tgh/Zr6gmwWNpKd2j+wHAlbk0o6PJsxuI1V2/icwFo8ESMLj3mrH2PIGwrZF/
	 f2qyi++4sq5ofVICbcc4sRPA405n9Nsd+zlF9JnfFuamMR2hx55XzX4Ojv+ZYItds0
	 DV0QDPHBDgbNSNbQKwQUJNtE=
Received: from zn.tnic (p200300eA971F9314329C23fFfeA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9314:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D79BE40E016C;
	Wed,  8 Jan 2025 08:22:27 +0000 (UTC)
Date: Wed, 8 Jan 2025 09:22:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com, francescolavra.fl@gmail.com,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
Message-ID: <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-13-nikunj@amd.com>
 <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
 <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>

On Wed, Jan 08, 2025 at 10:50:13AM +0530, Nikunj A. Dadhania wrote:
> All guests(including STSC) running on KVM or other hypervisors like Xen/VMWare
> uses the regular TSC when the guest is booted with TscInvariant bit set. But it
> doesn't switch the sched clock to use TSC which it should have, pointed here[1]
> by Sean:

Well, that paravirt_set_sched_clock() thing is there for a reason and all the
different guest types which call it perhaps have their reasons.

Now, if you think it would make sense to use the TSC in every guest type if
the TSC is this and that, then I'd need to see a patch or even a patchset
which explains why it is ok to do so on every guest type and then tested on
every guest type and then each patch would convert a single guest type and
properly explain why.

And your patch doesn't have that at all. I know Sean thinks it is a good idea
and perhaps it is but without proper justification and acks from the other
guest type maintainers, I simply won't take such a patch(-set).

And even if it is good, you need to solve it another way - not with this
delayed-work hackery.

IOW, this switching the paravirt clock crap to use TSC when the TSC is this
and that and the HV tells you so, should be a wholly separate patchset with
reviews and acks and the usual shebang.

If you want to take care only of STSC now, I'd take a patch which is known
good and tested properly. And that should happen very soon because the merge
window is closing in. Otherwise, there's always another merge window and
rushing things doesn't do any good anyway, as I keep preaching...

Your call.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

