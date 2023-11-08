Return-Path: <kvm+bounces-1153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7945B7E54D7
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:18:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9ECE1C20D84
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F0515EA6;
	Wed,  8 Nov 2023 11:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="KFXFH01+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6570415487;
	Wed,  8 Nov 2023 11:18:31 +0000 (UTC)
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C83101;
	Wed,  8 Nov 2023 03:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442311; x=1730978311;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YhNiCY6Yx16hIA8ic6bDnU8CklxIVvoOxjYhmVU762I=;
  b=KFXFH01+WyKZVuGXSf+Ano1t5HqH4ywbQheqAJa6homt8uBTBLEo7NpO
   mG65UaJQHbEmtZp6YhIXHpCCp/+Exe8ozrAhXA+i4sQ+O66EPO1Hsr+DZ
   ftf8HaracbQVHh+VARBIggQLgn81310Sh/zYUHrSX+7HOACPx8iVcyWjr
   o=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="683505176"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:18:25 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com (Postfix) with ESMTPS id 74C1080D5F;
	Wed,  8 Nov 2023 11:18:21 +0000 (UTC)
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:31015]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.43.105:2525] with esmtp (Farcaster)
 id b8d2a861-c97a-4ec8-b470-7641a9da532f; Wed, 8 Nov 2023 11:18:20 +0000 (UTC)
X-Farcaster-Flow-ID: b8d2a861-c97a-4ec8-b470-7641a9da532f
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:18:20 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:18:15 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>
Subject: [RFC 0/33] KVM: x86: hyperv: Introduce VSM support
Date: Wed, 8 Nov 2023 11:17:33 +0000
Message-ID: <20231108111806.92604-1-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D037UWC004.ant.amazon.com (10.13.139.254) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Hyper-V's Virtual Secure Mode (VSM) is a virtualisation security feature
that leverages the hypervisor to create secure execution environments
within a guest. VSM is documented as part of Microsoft's Hypervisor Top
Level Functional Specification [1]. Security features that build upon
VSM, like Windows Credential Guard, are enabled by default on Windows 11,
and are becoming a prerequisite in some industries.

This RFC series introduces the necessary infrastructure to emulate VSM
enabled guests. It is a snapshot of the progress we made so far, and its
main goal is to gather design feedback. Specifically on the KVM APIs we
introduce. For a high level design overview, see the documentation in
patch 33.

Additionally, this topic will be discussed as part of the KVM
Micro-conference, in this year's Linux Plumbers Conference [2].

The series is accompanied by two repositories:
 - A PoC QEMU implementation of VSM [3].
 - VSM kvm-unit-tests [4].

Note that this isn't a full VSM implementation. For now it only supports
2 VTLs, and only runs on uniprocessor guests. It is capable of booting
Windows Sever 2016/2019, but is unstable during runtime.

The series is based on the v6.6 kernel release, and depends on the
introduction of KVM memory attributes, which is being worked on
independently in "KVM: guest_memfd() and per-page attributes" [5]. A full
Linux tree is also made available [6].

Series rundown:
 - Patch 2 introduces the concept of APIC ID groups.
 - Patches 3-12 introduce the VSM capability and basic VTL awareness into
   Hyper-V emulation.
 - Patch 13 introduces vCPU polling support.
 - Patches 14-31 use KVM's memory attributes to implement VTL memory
   protections. Introduces the VTL KMV device and secure memory
   intercepts.
 - Patch 32 is a temporary implementation of
   HVCALL_TRANSLATE_VIRTUAL_ADDRESS necessary to boot Windows 2019.
 - Patch 33 introduces documentation.

Our intention is to integrate feedback gathered in the RFC and LPC while
we finish the VSM implementation. In the future, we will split the series
into distinct feature patch sets and upstream these independently.

Thanks,
Nicolas

[1] https://raw.githubusercontent.com/Microsoft/Virtualization-Documentation/master/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v6.0b.pdf
[2] https://lpc.events/event/17/sessions/166/#20231114
[3] https://github.com/vianpl/qemu/tree/vsm-rfc-v1
[4] https://github.com/vianpl/kvm-unit-tests/tree/vsm-rfc-v1
[5] https://lore.kernel.org/lkml/20231105163040.14904-1-pbonzini@redhat.com/.
[6] Full tree: https://github.com/vianpl/linux/tree/vsm-rfc-v1. 
    There are also two small dependencies with
    https://marc.info/?l=kvm&m=167887543028109&w=2 and
    https://lkml.org/lkml/2023/10/17/972



