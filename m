Return-Path: <kvm+bounces-69912-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AM33IWobgWm0EAMAu9opvQ
	(envelope-from <kvm+bounces-69912-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 22:47:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E30F3D1C4E
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 22:47:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 503F3302E402
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 21:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D99313E15;
	Mon,  2 Feb 2026 21:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="rSDJUCP4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YIXihLx/"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEB41C84BD;
	Mon,  2 Feb 2026 21:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068785; cv=none; b=O02555OiTd/qJwlcI9MEeopBiIIxYEZw5XM31RUNZztZb5Pje0bCsiw2iP7C5MV6dG3P7634qmH2SowwfWIWYPTsgbCDxj+QztmoZ8i29Y2XOmQSrUoBJpKkrqZ2/leQYtsR5vkLNffiIJ6QmNmI3ERozZz7Fo+Qu3kyyqIm/R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068785; c=relaxed/simple;
	bh=P1hwRLkRbf/qAD7V9FbY64fM7zTTPUYZWgjOJmw3Wg0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTMsZfQZL3LznKFHj/rzpZvNZcOzSxazEtnIUCWEbrawi/kx8DKcjol+Hmfx/n5cuqwZGaBALX4NFu1tOU/ldbEm4HYz1KXifDzlo6nul3I5osfl8xToZKQcxJ490eUznwc4Sl6RXc3Q3YHERjxQE9xJ7sGfKzQWi9qIK1XoPyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=rSDJUCP4; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=YIXihLx/; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 45055EC005A;
	Mon,  2 Feb 2026 16:46:21 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 02 Feb 2026 16:46:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770068781;
	 x=1770155181; bh=5XTvfkLRD6t0Cirlql/f2DOs7bSt+Y3nGNA6o5hil2g=; b=
	rSDJUCP4ViZeHHychwU2v7uQMN7XaM6sBtJQp4pR3DRzN1/Qjk82xBxhUixkpu75
	JcAdnd/L7etCDJr3S75Iiod2P2HsK1Rnzw/3cn2gwCHg5oth9vwF9OqIEXjLA6Qz
	YYuoRUbUzhLumDUIvFrsVqE+rZLaU0ZQTAcD+inV79oFipR01Q5Bl3k9i5JTJnDC
	L2phBTXmwi9v3RjFGoia+NFtL7lW2ymRxp/iMT+Xe5KYZ9h96/THpvPN7hTwKj3i
	g1zC1Eavi286T2d81QmKuN6j4tWwIqZ2F4HwDyF3+sABC5BaocDIFyuFkmZ5LkoZ
	ZE2ccygJ892vkHG0nmLLjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770068781; x=
	1770155181; bh=5XTvfkLRD6t0Cirlql/f2DOs7bSt+Y3nGNA6o5hil2g=; b=Y
	IXihLx/dvxtqv2DT8z3kz7cyI9HALM9YW3vDS1QCBHCk8EVKX5EAtRGPzC4rdqsB
	HdpFvSHFzSVR6TvdUd5kTSWYpZyndnphRSPG8FH/87eZuKHrr7vVHE8JJCa2qhqq
	NtbCewLquNCcEekmVdvjBWevR1DhrXjtRFzlt3S6Mxf8Dcy9FZj9hieunR/STngN
	Andoh1U9kCmYW2Ke2rl81VGQdS6pNklTM22cj/BBH3MMZXOaJnQWg2bxi2IQMd2y
	2NPSqfPtzgKN9TxhkKRdtNqBQNh9SZdYE+LdXdHU8ihwb/9FhhMQUpGFy4KG+Pf9
	qLAFLRxZUcdM2URgk83GQ==
X-ME-Sender: <xms:LRuBaZ7QFdro7aBZQcGKB42EE0GQ-zKSUWGZWHDJcB1tUBkTw9fa_w>
    <xme:LRuBaQ8nrRw5Kf7rMwHZqmwGxCFuIr_JBT4mfqKyFRoU3tMVVO6lk117CbfAmWADl
    gwB2TUFZy2e7zMYmYgwS8td1rMI2GaNmldnVJvoReQTVg53J3kO_EI>
X-ME-Received: <xmr:LRuBaQV3fz6eV_71yF46FnBtyVQ0iwZ9-sU17pvA8DrMSyHmsUOmedQFy9k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeekjeehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:LRuBaTomOb6DTKvfAy5wFcu2sUtMiM7Wu-Lo5ldCrXUyW1Tl6CBhSA>
    <xmx:LRuBaakgsnOL6UZ95eArHfHE4BfU1tbR_4b2qE70OOzb_5tdEQUFZQ>
    <xmx:LRuBab3b5GpGVOIVuI3xJ9S8-Osto7p_QqEArByBSsh-zSEc-4K5Fg>
    <xmx:LRuBafTrV8FnsjWQXtJSYj_5FHU7a-VaMoSOGTDwGW65HW6kQ4iR-w>
    <xmx:LRuBaeoJGRdKdvQh2YFcdbLzDZuXpbug_FZxdwdh1-Y7rm6L5owYozk8>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 16:46:20 -0500 (EST)
Date: Mon, 2 Feb 2026 14:46:18 -0700
From: Alex Williamson <alex@shazbot.org>
To: Ted Logan <tedlogan@fb.com>
Cc: David Matlack <dmatlack@google.com>, Shuah Khan <shuah@kernel.org>,
 <kvm@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] vfio: selftests: only build tests on arm64 and x86_64
Message-ID: <20260202144618.32bde071@shazbot.org>
In-Reply-To: <20260130-vfio-selftest-only-64bit-v1-1-d89ac0944c01@fb.com>
References: <20260130-vfio-selftest-only-64bit-v1-1-d89ac0944c01@fb.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69912-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email]
X-Rspamd-Queue-Id: E30F3D1C4E
X-Rspamd-Action: no action

On Fri, 30 Jan 2026 16:02:16 -0800
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
>  tools/testing/selftests/vfio/Makefile | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
> index ead27892ab65..eeb63ea2b4da 100644
> --- a/tools/testing/selftests/vfio/Makefile
> +++ b/tools/testing/selftests/vfio/Makefile
> @@ -1,3 +1,10 @@
> +ARCH ?= $(shell uname -m 2>/dev/null || echo not)
> +
> +ifeq (,$(filter $(ARCH),arm64 x86_64))
> +nothing:
> +.PHONY: all clean run_tests install
> +.SILENT:
> +else
>  CFLAGS = $(KHDR_INCLUDES)
>  TEST_GEN_PROGS += vfio_dma_mapping_test
>  TEST_GEN_PROGS += vfio_dma_mapping_mmio_test
> @@ -28,3 +35,4 @@ TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
>  -include $(TEST_DEP_FILES)
>  
>  EXTRA_CLEAN += $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
> +endif

I see other Makefiles include tools/scripts/Makefile.arch which would
then just let us test for 'ifeq (${IS_64_BIT}, 1)'.  Would that more
directly address what we're trying to solve here?  Thanks,

Alex

