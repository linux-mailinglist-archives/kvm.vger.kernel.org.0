Return-Path: <kvm+bounces-26766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85776977316
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 22:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E30C28448D
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 20:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C193E1C230B;
	Thu, 12 Sep 2024 20:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="7NEOmWpl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="d61ouSIs"
X-Original-To: kvm@vger.kernel.org
Received: from fout8-smtp.messagingengine.com (fout8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40091BB691;
	Thu, 12 Sep 2024 20:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726174584; cv=none; b=oWiSgyslQgnwey6mteboIZCqq4+90VFkn1ZlknpFo7aOGp9AAMRT8xFktU+92s/FjJ6456gGT8ligrsuxKWo7Lq8pis/ebQ9m44YLuIvcFkOmJJCFEaVvtZwDaNXo+awGMF09UR5FDEFvy566/aLuHVHC/U+OhZoor2x9b51DcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726174584; c=relaxed/simple;
	bh=v6osASlTNEvnvIOnDNv0OrwDnAd9yo5Nrdl5GzUh2o4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=OlVhZWY4YPQ2cMGrqB8dMvsiDJ0q/rgnOmHaqWLRDwujAZRgrVxclQ7Nk4dhCc1qriY6eQXoRGua1e9s81rEwbSzRUwwoRkgEiewtTcZkZsGyIEcPdAdFjiEWy3wORcmL5dltop8UaLSu2TmGEW7DiaWQpdanaIgncGXW3nvMzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=7NEOmWpl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=d61ouSIs; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 049F813804BE;
	Thu, 12 Sep 2024 16:56:22 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 12 Sep 2024 16:56:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1726174581; x=1726260981; bh=cr
	YbuhU/mIWyDxAStZdKyg/xZ/Sd/V3p+NJqMpC0uDI=; b=7NEOmWplmx9JpJFX8P
	8TX0uLA7sI8/amnsvnGCLEIFMgm08NmEp2WWctcpbx14iXm77G+NP1W6l1lBQQq2
	TxtMJHk/A7vDK5ALHAK/STd+T29jUEyrN3MnRi/8KUg96hBt0qlOFrSAlKT2Viyn
	YmO+H2Xb/++GQ6vsBLoyBRC1c665333t8mcIoaMq5JiJjnHVA9Uek0uPiji25V8x
	Cybz/O6ctSCC5gJiDzuwMYKfKcIqJTnzXEv9NMgF65yf5w7Nm5CxIb/tKlIlsmz0
	67pzorQxeJIuYzfPaCvzd8BDlt9LVUGNtHzCmxp+Ae08YTGaN9ZlAIPLpP+xjwjK
	uO9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1726174581; x=1726260981; bh=crYbuhU/mIWyD
	xAStZdKyg/xZ/Sd/V3p+NJqMpC0uDI=; b=d61ouSIsTiENK2l6auDDUiCBJoQ3k
	Fbxqam3HIvLop1X51Kiph0+pKNgqBQ+g5helD6Nv+NiIersCOW8GIQCVQ1/4pJk8
	Cxr/l2jfQQxdKy8+WgZIZSAWCjbe8KGvFV3oIg4e56BtwynLuLzFg4CLDgiw/Tel
	CFy9i6ecwYlz2Ln6ZSVu+0mY04EkL9ZnjMo0zlAKw7XNZp4yMYyW1+8DbVL77ERI
	wsn7JYjrL3pz3OmvjF3tFHCU/v0UfTyeJQc/Ac8R1kiV94z9QuoNc6imXD66v+8v
	68pkwuUWYc/5W7B1YATPOEg6dQD4O8qMnKKXzqnWXX2hKzNgmMNj8ZQOQ==
X-ME-Sender: <xms:dVXjZjJDlTozBsZ4zUBv7ctjJAPYF5uHKBd5mT4cJ7sTWcUskuyBrA>
    <xme:dVXjZnKk-qE_pKub1LC4CPARNvDE4zsPexEsPNjJ7_JLfqzwNRws0CSK9VkKl8Yfb
    BEawiwwtNM1320g3HQ>
X-ME-Received: <xmr:dVXjZrvI7pM0sEmDyQBuRx6yDSsVXsG2bRlZImx65ZvzF6zDc3qFu6k6Rbucu9otGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudejfedgudehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefhufffkfggtgfgvfevofesthejredtredtjeen
    ucfhrhhomheplfhirgiguhhnucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihgh
    horghtrdgtohhmqeenucggtffrrghtthgvrhhnpefgveffjeetgeejfeelgfekteelkefh
    uefggedvueeujeekjeetkeekvdffffefudenucffohhmrghinhepkhgvrhhnvghlrdhorh
    hgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhi
    rgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomhdpnhgspghrtghpthhtohepuddvpd
    hmohguvgepshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhg
    vghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnih
    igrdguvgdprhgtphhtthhopehlohhonhhgrghrtghhsehlihhsthhsrdhlihhnuhigrdgu
    vghvpdhrtghpthhtoheplhhinhhugidqphhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeht
    shgsohhgvghnugesrghlphhhrgdrfhhrrghnkhgvnhdruggvpdhrtghpthhtohepjhhirg
    iguhhnrdihrghnghesfhhlhihgohgrthdrtghomhdprhgtphhtthhopehrrghfrggvlhes
    khgvrhhnvghlrdhorhhgpdhrtghpthhtoheptghhvghnhhhurggtrghisehkvghrnhgvlh
    drohhrgh
X-ME-Proxy: <xmx:dVXjZsblSgBVQPbDm4MAiDJdFqqQeIz0UzKnKuWMJcee4fS5x_U5qw>
    <xmx:dVXjZqZ9Hy2j1aUHeuB0buqNduraFtdLU7jE3gH_kBTIhOolUPvt2g>
    <xmx:dVXjZgBAOssEWbpqaGfZNyisZ_m789FNN9EDX1eSBhFObBC7UTXLSg>
    <xmx:dVXjZobR6k9wJS9S7gPk_0b-UAYCvkJxBq83_gfMqOpoz98Yy1pCPQ>
    <xmx:dVXjZmQ_pvc8ADBx6Esnup9ToMOthIJH64zrZz2yVvI4XdXSwwimPEKg>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Sep 2024 16:56:19 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v2 0/4] LoongArch, MIPS: Unify Loongson IOCSR handling
Date: Thu, 12 Sep 2024 21:55:53 +0100
Message-Id: <20240912-iocsr-v2-0-e88f75b37da4@flygoat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFlV42YC/zXMTQ6CMBCG4auQWVsz/RPqynsYFlgLTKLUtKSBk
 N6dSnR27+TLs0F0gVyEa7VBcIki+amEOFVgx24aHKNnaRAoFBq8MPI2BtYIg7VWutGcQ9l+gut
 pOZx7W3qkOPuwHmzi3+9fqH9C4gwZWmMeUkpV7ta/1sF389n6N7Q55x1nA5a+nAAAAA==
To: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
 Jiaxun Yang <jiaxun.yang@flygoat.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2254;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=v6osASlTNEvnvIOnDNv0OrwDnAd9yo5Nrdl5GzUh2o4=;
 b=owGbwMvMwCXmXMhTe71c8zDjabUkhrTHocWNdXxqBguEZ63ZtuyfcaRy3aMs/unafV8r88R/f
 5rD0CXbUcrCIMbFICumyBIioNS3ofHigusPsv7AzGFlAhnCwMUpABPx/s/IcLH7o97cilOy0hVH
 u24Yi7/9Xd65KMiWrWZLCn/UOaMSZob/hZ4aB5j6TfI9BFesMVprmfv2XKvTZ0XFj5dY6quXXP/
 IDQA=
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

Hi folks,

This series unfied LoongArch and MIPS's IOCSR functions and
macros so they will expose same interface to arch-indenpendent
drivers.

This can reduce code deuplication, and also help my unifed IPI driver
and MIPS extio driver effort.

This is touching many sub-systems in once so might be hard to merge.

Huacai, can you apply first three patch via loongarch-next tree.
For last two patch maybe better merge them via a second PR after
all subsystem PRs merged.

No functional change so hope it's not too late for 6.12 :-)

Please review.
Thanks

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
Changes in v2:
- Drop patch 1
- Move IOCSR probing to cpu_probe_loongson
- Fix build error for CPUFREQ driver
- Link to v1: https://lore.kernel.org/r/20240907-iocsr-v1-0-0c99b3334444@flygoat.com

---
Jiaxun Yang (4):
      LoongArch: Probe more CPU features from CPUCFG
      LoongArch: cpu-probe: Move IOCSR probing out of cpu_probe_common
      LoongArch: Extract IOCSR definitions to standalone header
      MIPS: Loongson64: Use shared IOCSR header

 MAINTAINERS                                        |   1 +
 arch/loongarch/include/asm/cpu.h                   |   4 +
 arch/loongarch/include/asm/loongarch.h             |  93 +----------------
 arch/loongarch/kernel/cpu-probe.c                  | 103 ++++++++++++-------
 arch/loongarch/kernel/relocate_kernel.S            |   5 +-
 arch/loongarch/kernel/smp.c                        |  23 +++--
 .../include/asm/mach-loongson64/loongson_regs.h    |  58 +++--------
 arch/mips/kvm/vz.c                                 |   2 +-
 arch/mips/loongson64/smp.c                         |  44 ++++----
 drivers/cpufreq/loongson3_cpufreq.c                |  11 +-
 drivers/irqchip/irq-loongarch-avec.c               |   5 +-
 drivers/irqchip/irq-loongson-eiointc.c             |   5 +-
 drivers/platform/mips/cpu_hwmon.c                  |   7 +-
 include/linux/loongson/iocsr.h                     | 113 +++++++++++++++++++++
 14 files changed, 254 insertions(+), 220 deletions(-)
---
base-commit: 9aaeb87ce1e966169a57f53a02ba05b30880ffb8
change-id: 20240906-iocsr-829075458511

Best regards,
-- 
Jiaxun Yang <jiaxun.yang@flygoat.com>


