Return-Path: <kvm+bounces-70513-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDgbBatlhmlLMwQAu9opvQ
	(envelope-from <kvm+bounces-70513-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:05:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CA0CB103A55
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:05:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6448030431E7
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 22:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E42E82D5C91;
	Fri,  6 Feb 2026 22:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="ndLBkBOm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WTtenmkC"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C0C2264D9;
	Fri,  6 Feb 2026 22:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770415522; cv=none; b=X/VS5exOEPRG0QSF1GkjpNGphpB9KMYXiSSRXD/a+4noCyJT78nL5kKpPsKl8ZCtt+MRjNtsbarYCIPGr2zuyVSWElj94ZAdPOObupaC+BOHVp394QdTbTY1+B/rEeBq64nt54BNOgdWa9zKqvSMWWNBrIp4LsDqaYAA3ke7Mrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770415522; c=relaxed/simple;
	bh=mDHGzI7C1PnFq7j1rNz8G+LCW0rfw71fJltKl2Fu5VY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AlrqfM1XOrTmZp1JEDo0tinzRnnU+ZrDkpBA5w40Vz6z/I7i4B9f+XVKruA8rK0q6cSw8/Ygp3IcT4XiXjsfevc2j25RPhYrbGPDKTaTNpCm35vtKD4o8LrWvCkG1cBuwaNp5h1I4jBtJV0vb+wwrfNgNcD83YW8/J9KVs+Ui/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=ndLBkBOm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WTtenmkC; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 7F5421D000EB;
	Fri,  6 Feb 2026 17:05:20 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 06 Feb 2026 17:05:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770415520;
	 x=1770501920; bh=af0GCyiGSvGeOiThvz/dtqIqyfCOJUrFAhMkfwKMKz0=; b=
	ndLBkBOmXnNxRVdteesaj5W6Fb70ViAg8LYgAlz6RkE2KOVXKnMV+7Miqp2TNBuW
	3iJey0sMiS+Car9MHE4zg9aVEBrZnz9vJVFKedFqGwSyWHWS37Al6ESlFx6JIkaV
	XPbcuSzo+1DP/anYh7srNKvScfBEWHn5mom6by6VMsOGw0FqqGDqIPuW1iGIulKB
	9xm2o+WxeAWDNtD8c/Zf+PDjCwkdMIVkSzTCXcop6lZ1dPtTX92/AEGvw4GBSEQg
	/hwFRnrR/9msNGVLCuIXX5jmihuz6XwVqmTIZzJto4NzkYpIVc4poiI9PsH7O0uP
	vrP3djBUZPqEW/bU7L4DRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770415520; x=
	1770501920; bh=af0GCyiGSvGeOiThvz/dtqIqyfCOJUrFAhMkfwKMKz0=; b=W
	TtenmkC0+m/6QNwAFkDg6HsXXb8LdmzG6360rRlyQDt1UNbRjEMhASB8GLYevPz8
	oJ5iSbl7Ez41uL6hRgsAk2h75pzaagtOgErcjIAWqRmYM9/yMNyiSe9X+asaC3nQ
	G1NwCWUGBvZCml7E4mp3y7r6R5TkuycaxPxclbFbREubOT3zwLG4fo1f+kua6cn5
	88RA+0En49/hiZIWdB3uLh1d6IaZNNbQWLVawGkEHXpZiWV2lUpjpXb8ky9W8aWI
	6KWlLqKb5ZL2ykvCDVSKuiYZPUdL31vLgRg4dDjBqP3Lrnv9VtP6ofEt0OWUMebM
	rK9azhicf8uI3FyI0iT4Q==
X-ME-Sender: <xms:n2WGaaq8DTUUT3AgvFKIPlv8k1obKz9XN6kvLrGnIL9Z5rwIctsGqA>
    <xme:n2WGaStwX5m4jpSypTkSy_kLEMAzVY7OJdFzWS75DAZQJfFacbHNx3Zes-bH54owL
    xdJRI0Xa21j_k3dnF1h0WIdQ4kIetUa4gQhCllquAIqXjhpk2hIuQ>
X-ME-Received: <xmr:n2WGafG_5zEkasXW7B3ydHYF9ns2wfnqCZKKosB2YmAsx2ra8wd7kjdFcIk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeelfedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekheejieetffefueeiteejtdejffdvleelvdeuvdffvdefteeghfevkeeu
    vdefvdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhg
    pdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehtvg
    gulhhoghgrnhesfhgsrdgtohhmpdhrtghpthhtohepughmrghtlhgrtghksehgohhoghhl
    vgdrtghomhdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidq
    khhsvghlfhhtvghsthesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    khhpsehinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:n2WGabY6tPRWv6_T2nIK137yZjY-0-gpdmv78YlhwM-0NaJv9b3cJA>
    <xmx:n2WGaXVB0aQzcTcegujFeHMIW4IO6D3lB-h9fibstsxtpM5e079_Hw>
    <xmx:n2WGaZkarXDbwa0GJEYdHS6C-IecmutH-AdGnL-doHpo9YN-3dAJ0w>
    <xmx:n2WGaaBX5Npf5UsMMOzuOOYpFCnfSAqC7dStj4Yq6HfoLV1trf5mew>
    <xmx:oGWGaVZQz0F7KOGEVt-5HxDc5dGmzLQPm3tll4zAQhiyTvQeLonceEs4>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Feb 2026 17:05:19 -0500 (EST)
Date: Fri, 6 Feb 2026 15:05:17 -0700
From: Alex Williamson <alex@shazbot.org>
To: Ted Logan <tedlogan@fb.com>
Cc: David Matlack <dmatlack@google.com>, Shuah Khan <shuah@kernel.org>,
 <kvm@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] vfio: selftests: only build tests on arm64 and
 x86_64
Message-ID: <20260206150517.3976db13@shazbot.org>
In-Reply-To: <20260202-vfio-selftest-only-64bit-v2-1-9c3ebb37f0f4@fb.com>
References: <20260202-vfio-selftest-only-64bit-v2-1-9c3ebb37f0f4@fb.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm2,messagingengine.com:s=fm3];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70513-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,messagingengine.com:dkim,shazbot.org:mid,shazbot.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,fb.com:email]
X-Rspamd-Queue-Id: CA0CB103A55
X-Rspamd-Action: no action

On Mon, 2 Feb 2026 17:23:53 -0800
Ted Logan <tedlogan@fb.com> wrote:

> Only build vfio self-tests on arm64 and x86_64; these are the only
> architectures where the vfio self-tests are run. Addresses compiler
> warnings for format and conversions on i386.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202601211830.aBEjmEFD-lkp@intel.com/
> Signed-off-by: Ted Logan <tedlogan@fb.com>
> ---
> Do not build vfio self-tests for 32-bit architectures, where they're
> untested and unmaintained. Only build these tests for arm64 and x86_64,
> where they're regularly tested.
> 
> Compiler warning fixed by patch:
> 
>    In file included from tools/testing/selftests/vfio/lib/include/libvfio.h:6:
>    tools/testing/selftests/vfio/lib/include/libvfio/iommu.h:49:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
>       49 |         VFIO_ASSERT_EQ(__iommu_unmap(iommu, region, NULL), 0);
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    tools/testing/selftests/vfio/lib/include/libvfio/assert.h:32:37: note: expanded from macro 'VFIO_ASSERT_EQ'
>       32 | #define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, ==, ##__VA_ARGS__)
>          |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:22: note: expanded from macro 'VFIO_ASSERT_OP'
>       26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
>          |                                              ~~~~
>       27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
>          |                                           ^~~~~~~~~~
> ---
> Changes in v2:
> - Add white space around arch checks
> - Clean up uname command
> - Link to v1: https://lore.kernel.org/r/20260130-vfio-selftest-only-64bit-v1-1-d89ac0944c01@fb.com
> ---
>  tools/testing/selftests/vfio/Makefile | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
> index ead27892ab65..8e90e409e91d 100644
> --- a/tools/testing/selftests/vfio/Makefile
> +++ b/tools/testing/selftests/vfio/Makefile
> @@ -1,3 +1,10 @@
> +ARCH ?= $(shell uname -m)
> +
> +ifeq (,$(filter $(ARCH),arm64 x86_64))
> +# Do nothing on unsupported architectures
> +include ../lib.mk
> +else
> +
>  CFLAGS = $(KHDR_INCLUDES)
>  TEST_GEN_PROGS += vfio_dma_mapping_test
>  TEST_GEN_PROGS += vfio_dma_mapping_mmio_test
> @@ -28,3 +35,5 @@ TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
>  -include $(TEST_DEP_FILES)
>  
>  EXTRA_CLEAN += $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
> +
> +endif
> 
> ---
> base-commit: c3cbc276c2a33b04fc78a86cdb2ddce094cb3614
> change-id: 20260130-vfio-selftest-only-64bit-422518bdeba7
> 
> Best regards,

Applied to vfio next branch for v7.0/6.20.  Thanks,

Alex

