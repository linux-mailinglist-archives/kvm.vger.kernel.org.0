Return-Path: <kvm+bounces-57249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D985B52187
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 22:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42E453B65C2
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D832EDD58;
	Wed, 10 Sep 2025 20:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MBm8ZZIX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216172D6E74;
	Wed, 10 Sep 2025 20:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757534436; cv=none; b=tAGJL4yY3Z6Ci2SmdULZxqFVQRt9Le+rv3J2WP7+EiztmnyZ8D/uk3UPC22QI4wcJMV4XdutpHVSSx//K0JVQRiDqi39jrVqpvyJapLNreEUe8CMa9ZLtfKQnr+PbngcUKtP5kdbvLNtePgMUEHxlkTCRnpKbvCJhDJpOGZNRT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757534436; c=relaxed/simple;
	bh=EKTQ7/KKk06PC4P0hrBSaQFg209GpQVgW+Z8KM2n3tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLSTcmtUL/XsBMlFHE7Y76UGUk94Gk47dq6EnEs1cAX1g2XRKA16UcUpWIOeWXco67EgxEqqyeekAh2+u6KWJypNnvVTiRNPt/njFk8NyDe+ox1cGcgk3Ajb+9TsGtrsRi5UZuiTF6cjdOZQ0z1vFDoCqYj2j8l0SeCtaF3je/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=MBm8ZZIX reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3FA8140E00DD;
	Wed, 10 Sep 2025 20:00:31 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 7Rba-gI6y12Q; Wed, 10 Sep 2025 20:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757534427; bh=tTP7WJCPA0F+L78sq3fAHJi/fZvPP2QjtFGkh16jzvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MBm8ZZIXpeiwEFsNoNXjttLv44Pi8fbzsOCoein670ovE7xQz638krZknHGzwyTno
	 gusHc8We5VrAJOHSmhvEh4eEeDLj9MBak9t50vlVjx6kn9J92Hoo69qiaBjkBukDd+
	 GNg0Do18zD265RFs2k7bihM64E3vCPCUWy+3PMQtuO2ZNe6ixg/G0zd6MfHuitg42i
	 inMdkR1ElxD3+F8bQAAIXx9ENo2LolVsml3B2e4tZ6kjhzEBPo0+wPwx0KAaQaqK2X
	 9WVREVn+z/7tFn928gIK9tVaKkxgE02wemggrGfr4oxytA2lcp6Pvo03IzQ0mFM5op
	 fy9ryiBeHpyvwTgB0pBZUay3HTuVoZmKeZbAaasRLQbnJd3c2y6k8L4VgBkOFR8xS7
	 ejtye3nd8ETo1kCi4EtKdFShRwaVbJUCr3sHpGZI5RwLTnO0yfh39Ah6NAt7Q672u/
	 lOWq2pmGynH/6dptXRmCSO86xq5H+DzLqz0jsqsCn10Cft+i20/FM+IDgpc7sSEC8R
	 OHhVI2jEqgFxQK277O3KSBuHJyVboSCun1VgwYf2UMoCQTEOJLEDpMZWOYzY3SHueJ
	 2N6Wi0L2XXkLiXlNSJlawA7CzidgQDN8pVOUuK8WZ9J3H9JH2Q3N4QNCwPXtyxge46
	 JgAMknovkq4d+JBgd8QJEor4=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 100A440E01D2;
	Wed, 10 Sep 2025 19:59:45 +0000 (UTC)
Date: Wed, 10 Sep 2025 21:59:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Moger, Babu" <babu.moger@amd.com>
Cc: corbet@lwn.net, tony.luck@intel.com, reinette.chatre@intel.com,
	Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	akpm@linux-foundation.org, paulmck@kernel.org, frederic@kernel.org,
	pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org,
	arnd@arndb.de, fvdl@google.com, seanjc@google.com,
	thomas.lendacky@amd.com, pawan.kumar.gupta@linux.intel.com,
	perry.yuan@amd.com, manali.shukla@amd.com, sohil.mehta@intel.com,
	xin@zytor.com, Neeraj.Upadhyay@amd.com, peterz@infradead.org,
	tiala@microsoft.com, mario.limonciello@amd.com,
	dapeng1.mi@linux.intel.com, michael.roth@amd.com,
	chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
	gautham.shenoy@amd.com
Subject: Re: [PATCH v18 14/33] x86/resctrl: Add data structures and
 definitions for ABMC assignment
Message-ID: <20250910195938.GAaMHYqjfOdFQmllbQ@fat_crate.local>
References: <cover.1757108044.git.babu.moger@amd.com>
 <1eb6f7ba74f37757ebf3a45cfe84081b8e6cd89a.1757108044.git.babu.moger@amd.com>
 <20250910172627.GCaMG0w6UP4ksqZZ50@fat_crate.local>
 <1096bc24-2bac-4bc2-bc4f-9d653839e81d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1096bc24-2bac-4bc2-bc4f-9d653839e81d@amd.com>
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 02:49:23PM -0500, Moger, Babu wrote:
> No particular reason =E2=80=94 it was just carried over from older MSRs=
 by copy-paste.
>=20
> In fact, all five of them are AMD-specific in this case. Let me know th=
e
> best way to handle this.

You could s/IA32/AMD/ them later, when the dust settles.

"AMD64" would mean they're architectural which doesn't look like it ... y=
et.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

