Return-Path: <kvm+bounces-32577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 297C09DAC63
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 18:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2CE6281FA1
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 17:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD1120102E;
	Wed, 27 Nov 2024 17:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="vZRMDW+u"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525AA225D6;
	Wed, 27 Nov 2024 17:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732728426; cv=none; b=um1BGA/o0M8Rny2pZfDlU6oni3UJcbZAiNQTALAYhvxDZgL7MLofqyWpmddJeUbgA8HexWT9CXyKN7vKhR8ubgl7LTuccHx/pQGq5IeqgHJNA0FHK+96MoYiZjKVMYwOl8B4Hz5XDTzD66MOYHDaHHocHa7BWGybpt1U42s9iL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732728426; c=relaxed/simple;
	bh=trR1odbMnYfKg+y643iIq1x+oSQsAUYwbdhImqxRW9A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PU5mOeXYC5sfRbYXq2jrMcBQv8otltawi+i42sGfHaHDOzV2KMAGS/vYNMgkyS0xVED128DWAzVXQqHja/0ZW9XMB3xleeWcQkm0Ju+MyyiQ9d0z9rRHfpFu+IDWApseaOFgRoNGYRnv+fuIQMhASGIScC11++fWdyryNAeJ12w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=vZRMDW+u; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732728424; x=1764264424;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+LVpJO+T6cIMOLRME/58BNmXO8qIXYUov9NRO5ERaek=;
  b=vZRMDW+u26cWl2KyAa8AdBawzBS+RtyJh0drzDaTRoqMYJAmTI4AwQ92
   YDMJct7C9RYAmHg0mWytfLZ07+q2fHRFYypE0qXImZi6fXrevnM7uvFTv
   zF+99Exr45xFuyPW4b95Wv0cVRN4GRkwPiwpmmcfDTrSXCpGgIfyu2YzT
   I=;
X-IronPort-AV: E=Sophos;i="6.12,189,1728950400"; 
   d="scan'208";a="677204372"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 17:27:01 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:44496]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.9.62:2525] with esmtp (Farcaster)
 id 88571b37-b1fc-4a42-8fb0-e1c403c74e85; Wed, 27 Nov 2024 17:26:59 +0000 (UTC)
X-Farcaster-Flow-ID: 88571b37-b1fc-4a42-8fb0-e1c403c74e85
Received: from EX19D022EUA001.ant.amazon.com (10.252.50.125) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 27 Nov 2024 17:26:59 +0000
Received: from EX19MTAUEC002.ant.amazon.com (10.252.135.146) by
 EX19D022EUA001.ant.amazon.com (10.252.50.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 27 Nov 2024 17:26:58 +0000
Received: from email-imr-corp-prod-pdx-all-2c-785684ef.us-west-2.amazon.com
 (10.124.125.6) by mail-relay.amazon.com (10.252.135.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 27 Nov 2024 17:26:58 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-pdx-all-2c-785684ef.us-west-2.amazon.com (Postfix) with ESMTPS id DB44BA037A;
	Wed, 27 Nov 2024 17:26:55 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <corbet@lwn.net>, <seanjc@google.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<vkuznets@redhat.com>, <xiaoyao.li@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <roypat@amazon.co.uk>, <xmarcalx@amazon.com>, <kalyazin@amazon.com>
Subject: [PATCH 0/2] KVM_ASYNC_PF_SEND_ALWAYS
Date: Wed, 27 Nov 2024 17:26:52 +0000
Message-ID: <20241127172654.1024-1-kalyazin@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

As was suggested in
https://lore.kernel.org/kvm/20241118130403.23184-1-kalyazin@amazon.com/T/#ma719a9cb3e036e24ea8512abf9a625ddeaccfc96
, remove support for KVM_ASYNC_PF_SEND_ALWAYS in KVM.

Nikita Kalyazin (2):
  KVM: x86: async_pf: remove support for KVM_ASYNC_PF_SEND_ALWAYS
  KVM: x86: async_pf: determine x86 user as cpl == 3

 Documentation/virt/kvm/x86/msr.rst   | 11 +++++------
 arch/x86/include/asm/kvm_host.h      |  1 -
 arch/x86/include/uapi/asm/kvm_para.h |  2 +-
 arch/x86/kvm/x86.c                   |  4 +---
 4 files changed, 7 insertions(+), 11 deletions(-)


base-commit: 1508bae37044ebffd7c7e09915f041936f338123
-- 
2.40.1


