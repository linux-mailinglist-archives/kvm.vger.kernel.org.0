Return-Path: <kvm+bounces-3087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C95B8008CA
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:46:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 376892814B9
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64DBF1DA53;
	Fri,  1 Dec 2023 10:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="1XnU2BSg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A0110E2;
	Fri,  1 Dec 2023 02:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:To:From; bh=djbPckzM3W8M21CN4MQGvDbZA8H4KJVF34YSsULAd7Y=; b=1XnU2BSgd
	jkHVu0upJ6DzjhKYsC6CnrOJce8U/LN2D+wjcL2uypovLY7JGoD2W5bYxb72A0a3KCb7KsDk7zA0e
	EUSj3olGjhszJvcv+bLNT8IY+PH/bpRO7Zx0wgoqagNZ0ekFy29FS95gYw3mUxIjR1g1ZIk6FLV9m
	weqId714=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r911r-0005P2-1y; Fri, 01 Dec 2023 10:45:51 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r911q-0003dT-Nx; Fri, 01 Dec 2023 10:45:50 +0000
From: Paul Durrant <paul@xen.org>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: xen: update shared_info when long_mode is set
Date: Fri,  1 Dec 2023 10:45:34 +0000
Message-Id: <20231201104536.947-1-paul@xen.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paul Durrant <pdurrant@amazon.com>

This series is based on my v9 of my "update shared_info and vcpu_info
handling" series [1] and fixes an issue that was latent before the
"allow shared_info to be mapped by fixed HVA" patch of that series allowed
a VMM to set up shared_info before the VM booted and then leave it alone.

The problem was noticed when the guest wallclock apparently reverted to
the Unix epoch. This was because, when the shared_info was set up the
guest's long_mode flag was unset and hence the wallclock was intialized
in the place where a 32-bit guest would expect to find it. The 64-bit
guest being tested instead found zero-ed out memory.

Fix the the issue by first separating the initialization of the
shared_info content from setting its location (by HVA or GPA) and then
(re-)initializing the content any time the long_mode flag is changed.

[1] https://lore.kernel.org/kvm/20231122121822.1042-1-paul@xen.org/

Paul Durrant (2):
  KVM: xen: separate initialization of shared_info cache and content
  KVM: xen: (re-)initialize shared_info if guest (32/64-bit) mode is set

 arch/x86/kvm/xen.c | 84 ++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 32 deletions(-)


base-commit: 369e9826edfd346f259471e521c03e12bb0ab476
-- 
2.39.2


