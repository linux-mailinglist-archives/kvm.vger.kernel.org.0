Return-Path: <kvm+bounces-32579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0188F9DAC6B
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 18:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 787F61672F0
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 17:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83862010FA;
	Wed, 27 Nov 2024 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="j+tKH0gN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387D620102E;
	Wed, 27 Nov 2024 17:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732728457; cv=none; b=ohHFhKlAJe8Ja9xZgrzKhTs1oilQO1ZfSxjYlNuUf9pa0LpKZauPW9v2WPm/6vID8r8WlkmU8fPW5ZLVJtHKA2NqZfVafYvkrMwtWYChdaGrr/olE+uv39hqluuViSMo66zxc3HEE6B9ce9f3cFDoF5heMDpgw5iO5B2l51UTns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732728457; c=relaxed/simple;
	bh=hpGMpZFbtZ71ct3nhU4Xj4uf3o+AADoog6oLOcrRNao=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=reljkdAQoUhGV3ty1WFFQX1a2CdBWXk/UZCtBeVIdsos9wTcDHeYqbND1dL6PXBIxG1rlCgAFKDHSyv60acThet+pqfOorPyT5Vq2ETMr3TvzjKlFkW9N2RocQZwrTjYmvyQKN4SYmHa3dV2fI8gP5Xv6pHF1Ph70+CN7GKTCeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=j+tKH0gN; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732728455; x=1764264455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JQ0H5XNdJiVRjtzDcrMcUYqg20cYD9pREmap3E/g000=;
  b=j+tKH0gNfauzoSvQXD8nnlhAHBR21ADG+7NO3BJEwBf0nBuKw4SWgqut
   qaQgXYlz/lfnNErY4E9ndwP/uV23tkcts/JGPaOYHvT5ox73mGHiXWC7P
   k0sLJEn2TNaXZxrhx4w689/V4xrBM9xIWwL9NODJrGWMGk2hbFx2b45yZ
   U=;
X-IronPort-AV: E=Sophos;i="6.12,189,1728950400"; 
   d="scan'208";a="44975132"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 17:27:31 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:9102]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.13:2525] with esmtp (Farcaster)
 id 919d0f07-8187-4c71-9a0c-3fee9f6d1d00; Wed, 27 Nov 2024 17:27:29 +0000 (UTC)
X-Farcaster-Flow-ID: 919d0f07-8187-4c71-9a0c-3fee9f6d1d00
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 27 Nov 2024 17:27:26 +0000
Received: from EX19MTAUEA002.ant.amazon.com (10.252.134.9) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 27 Nov 2024 17:27:25 +0000
Received: from email-imr-corp-prod-pdx-all-2c-475d797d.us-west-2.amazon.com
 (10.124.125.2) by mail-relay.amazon.com (10.252.134.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 27 Nov 2024 17:27:25 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-pdx-all-2c-475d797d.us-west-2.amazon.com (Postfix) with ESMTPS id BD6B6A056C;
	Wed, 27 Nov 2024 17:27:22 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <corbet@lwn.net>, <seanjc@google.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<vkuznets@redhat.com>, <xiaoyao.li@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <roypat@amazon.co.uk>, <xmarcalx@amazon.com>, <kalyazin@amazon.com>
Subject: [PATCH 2/2] KVM: x86: async_pf: determine x86 user as cpl == 3
Date: Wed, 27 Nov 2024 17:26:54 +0000
Message-ID: <20241127172654.1024-3-kalyazin@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241127172654.1024-1-kalyazin@amazon.com>
References: <20241127172654.1024-1-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8f784f07d423..168dcf1d4625 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13360,7 +13360,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 	if (!kvm_pv_async_pf_enabled(vcpu))
 		return false;
 
-	if (kvm_x86_call(get_cpl)(vcpu) == 0)
+	if (kvm_x86_call(get_cpl)(vcpu) != 3)
 		return false;
 
 	if (is_guest_mode(vcpu)) {
-- 
2.40.1


