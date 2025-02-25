Return-Path: <kvm+bounces-39112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A164CA44159
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 14:52:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62865189609F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 13:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38651257420;
	Tue, 25 Feb 2025 13:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YDQ1aGQm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D0426A0AD
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 13:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740491549; cv=none; b=YI8xazPcbV9SnSg7cjG2B/endp6CVyS1I8KZTOpFIagqeL1yt+RUOfHyN2oGECkO/9GBCflcaDJCnYvneIeKfLjJZIgEWB0IMhoK0XciG5UC+R6SvPVlFgQfk9N/9kdHbUhZp8jydlqw9ZO4JUcdXtPKjvV38+lPPGMGpRze9OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740491549; c=relaxed/simple;
	bh=x10T7/eCTeM0M4xy3rCmMnWyO7UukP7ZVK9yhTioOlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHHzeAMi4aWMWgZSxrhTHUxfJwbw6Sxzx0+ftbgiMoNx7wM3YJWfFd/Oy7GJeUvovL27jcTCrLJ+e9eKVAFeveVgEa2AUNxZhmaNPsw/DyrgICcJu0wOaJIbvalUU6xECHXjpI7nO3EP9oZBVG0CjgFCX0Xu8BfJhMXdfj3vIMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YDQ1aGQm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE05C4CEE9;
	Tue, 25 Feb 2025 13:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740491548;
	bh=x10T7/eCTeM0M4xy3rCmMnWyO7UukP7ZVK9yhTioOlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDQ1aGQmDiNCd89QjnmHsvF5gbMZMVl371l6VaAoqH9weAnTD079E7AXppihTTtT7
	 9jc2k5qUD6kBinPLy7Jd2EcW6CibDos384aFCwYdRe6TXiO6x9IyPVVz1zOgM7uG7B
	 XvDtNE4JD964RbwvJ2Y/AcATt5VSm69oqk66Bcp1YlBQyQre9j2V0Y8lBmKGBIkuQK
	 kiGq6RzJmnL6PUpZLEy829C59c7bj8fhWwSSaoXNSkBpjZQdG8dT8ICeg72Hi4vhH2
	 sSEkln8SHiFVFO6Y0op/7gXkF8pEA8h/t8ky/8fwSbogNLZnNoIKxMCxis6o+gLMJC
	 Pcw7ZM7+gPsgQ==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFC kvm-unit-tests PATCH 2/4] x86/apic: Disable PIT for x2apic test to allow SVM AVIC to be tested
Date: Tue, 25 Feb 2025 16:10:50 +0530
Message-ID: <6aba109b9ac7e883d00b74d084e58f37acd805e3.1740479886.git.naveen@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740479886.git.naveen@kernel.org>
References: <cover.1740479886.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SVM AVIC is inhibited if kvm-pit is enabled in the default "reinject"
mode. Commit f5cfdd33cb21 ("x86/apic: Add test config to allow running
apic tests against SVM's AVIC") disabled PIT in xapic test to allow AVIC
to be tested. However, since then, AVIC has been enabled to work in
x2apic mode, but still requires PIT to either be disabled or set to
"discard".

Update x2apic test to disable PIT so that AVIC can be exercized with
x2apic.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 x86/unittests.cfg | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 8d046e6d7356..35fb88c3cb79 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -14,10 +14,11 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -machine kernel_irqchip=split
 arch = x86_64
 groups = apic
 
+# Don't create a Programmable Interval Timer (PIT, a.k.a 8254) to allow testing SVM's AVIC
 [x2apic]
 file = apic.flat
 smp = 2
-extra_params = -cpu qemu64,+x2apic,+tsc-deadline
+extra_params = -cpu qemu64,+x2apic,+tsc-deadline -machine pit=off
 arch = x86_64
 timeout = 30
 groups = apic
-- 
2.48.1


