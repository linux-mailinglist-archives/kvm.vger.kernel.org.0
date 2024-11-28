Return-Path: <kvm+bounces-32748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A5D9DB910
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 14:51:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD470162F87
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 13:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E42B1A9B52;
	Thu, 28 Nov 2024 13:51:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE6111E4B2
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 13:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732801863; cv=none; b=E2t2wEpNi5GkAZwFIac1HKa3iXO5/mnWz9nDA30r2JeY3yNGb7Vo8ZhOhe42ETPhpi6GP/n/qvJLVh1BbdV6KWQMAVuE2dEGOQTag38EuUECFEc3fyG4NL6Cmt6XaFkXVp67Q4Js+UTa0x5LJBmISJOXbPfMGCfxSfmP8+yhr1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732801863; c=relaxed/simple;
	bh=R695f/kh+SUC+5daQK2POXI8nRl5Qccr31pllz8V9eU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kVl3JfUS/26UVs+ZZb3mLmW4uvNQmGfyGtlvclp8JV/9DTJjQJEJxG4BJ8OA38UOCGBNg5hZDX42n2kugj+zZ+lQANeDiCky4g6lcwbDTZuk7MQ1OwZ0CwTwDpHDXbMW84ohDmKh6HnMl8luQ5IMIgNOPA0LrxRB/1HXMxcBqvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99D6A1474;
	Thu, 28 Nov 2024 05:51:23 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E6283F58B;
	Thu, 28 Nov 2024 05:50:52 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	apatel@ventanamicro.com
Subject: [PATCH kvmtool] builtin-run: Allow octal and hex numbers for -m/--mem
Date: Thu, 28 Nov 2024 13:50:41 +0000
Message-ID: <20241128135041.8737-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no reason why -m/--mem should not allow the user to express the
desired memory size in octal or hexadecimal, especially when it's as easy
as changing the strtoull() 'base' parameter to 0, as per man 3 strtoull.

Before:

  $ ./lkvm run -m 0x200 -k Image

would fail with the error message:

  Fatal: Invalid RAM size: 0x200

And now that works as expected.

Before:

  $ ./lkvm run -m 01000 -k Image

would create a VM with 1000MB of memory, when it's known that numbers
that start with a 0 are in base 8. With this patch, that's interpreted
correctly as 512 in base 8.

Note that this is a change in behaviour, but writing decimal numbers with
leading zeros is very uncommon, and it is this author's humble opinion that
there are no kvmtool users that do this.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/builtin-run.c b/builtin-run.c
index c26184ea7fc0..ebff9d5da49d 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -108,7 +108,7 @@ static u64 parse_mem_option(const char *nptr, char **next)
 	u64 val;
 
 	errno = 0;
-	val = strtoull(nptr, next, 10);
+	val = strtoull(nptr, next, 0);
 	if (errno == ERANGE)
 		die("Memory too large: %s", nptr);
 	if (*next == nptr)
-- 
2.45.1


