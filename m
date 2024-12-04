Return-Path: <kvm+bounces-32995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1D19E3785
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:33:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54291280F3E
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D39E11B3956;
	Wed,  4 Dec 2024 10:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C5ZWS+h/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009571A724C;
	Wed,  4 Dec 2024 10:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308267; cv=none; b=k/3sQ+jV+AV9KjiNnGyU3XPftuvWqsmHhC7AD8YPWuqUgThKyfoU/OS9CltlQDh1N2RUR9pd+o1HmKsRO9DwV5VT6iRHuqPeFm1eqIziIUNjF4+o4Ew34jqww5qaIuGQBAGw/vo6877qRbDQpvcDlDu4BRkVw8+vKGp2HiPPwug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308267; c=relaxed/simple;
	bh=RlkJX0MrhsJeOtYwbzKz9uU11pc4QQCMS9xkZOpuwfo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s5JJtW0VD48xgMu14TrjxvnpgT/zjILxdQmnjAw0qNb4MLEwro2FYuEAjKMFhkgXVqSB+jSLQc5IL2HgrrwXSrx3+aKV6LJmOZtkFueJQSGqNIqC1vuWZngcEsCaUyi31rn3ZhoUKBOWshalEGIJBpSbi6Tw1JiVPFxge05t5hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C5ZWS+h/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3466AC4CEDD;
	Wed,  4 Dec 2024 10:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733308266;
	bh=RlkJX0MrhsJeOtYwbzKz9uU11pc4QQCMS9xkZOpuwfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5ZWS+h/mbWTTmvQEszVA3a14XrbmFIlUZT3Xh3uiVXjA7t11SGw44HUlMrfplPYA
	 eDkn54F/9g20AZGsvSm+WIdkcsKbvTzebPOHjhtserCsUvjzdIn0a9PeWD0PGhWJ4Q
	 XFFy5nVD5vLk/AwUEDmp4Nl4JIvO7HXhHiEv7fRZZ+HF7/QkP3ndMlQNBBnf9O/7zB
	 ntvwajTTgSPav6hSNYuizgyH23apH2H9ejefXRwGAyqUX7obgZIVcwqgDnHSNzoGul
	 bKxuAMEKr7wBrBf4V0xDYc7FU5Y68hip5sJKCx9SMgobcEXVg/MiZGFwaDbld5F+7L
	 oT82zbZsfvrMQ==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 01/11] x86/Kconfig: Geode CPU has cmpxchg8b
Date: Wed,  4 Dec 2024 11:30:32 +0100
Message-Id: <20241204103042.1904639-2-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241204103042.1904639-1-arnd@kernel.org>
References: <20241204103042.1904639-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

An older cleanup of mine inadvertently removed geode-gx1 and geode-lx
from the list of CPUs that are known to support a working cmpxchg8b.

Fixes: 88a2b4edda3d ("x86/Kconfig: Rework CONFIG_X86_PAE dependency")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/Kconfig.cpu | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 2a7279d80460..42e6a40876ea 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -368,7 +368,7 @@ config X86_HAVE_PAE
 
 config X86_CMPXCHG64
 	def_bool y
-	depends on X86_HAVE_PAE || M586TSC || M586MMX || MK6 || MK7
+	depends on X86_HAVE_PAE || M586TSC || M586MMX || MK6 || MK7 || MGEODEGX1 || MGEODE_LX
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
-- 
2.39.5


