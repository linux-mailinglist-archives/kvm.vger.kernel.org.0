Return-Path: <kvm+bounces-2840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA5157FE7A6
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 04:30:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 272EE1C20CAB
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 03:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D12A13AF1;
	Thu, 30 Nov 2023 03:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ha8rW2UW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECBB10C6
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 19:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701315009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4cE4T+EEL+03WZ5UUP3AHZPRhs258nrnZLkXaC4jGAY=;
	b=ha8rW2UWbgo6l1qvMJYgqo5jTMAQajNS7cA4MCQsLpQ4vcelf02/skDcaLcehrtvWCcd/w
	s0N6sN4GH8AaB7BdS7rHQuCmQ7Q08ZnIPQFbvnaNl1+a2cy7zyRSvN4mHlJRG6XqJPU/+r
	CAeyH2WcwgB+h4VNUadhG8he8VV9V8A=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-207-FwT6T1RnPsSfc7cHZW2ruQ-1; Wed,
 29 Nov 2023 22:30:06 -0500
X-MC-Unique: FwT6T1RnPsSfc7cHZW2ruQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 720AC29AA3B8;
	Thu, 30 Nov 2023 03:30:05 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 39FFD112130C;
	Thu, 30 Nov 2023 03:30:05 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Colton Lewis <coltonlewis@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Nico Boehr <nrb@linux.ibm.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Ricardo Koller <ricarkol@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v2 0/3] arm64: runtime scripts improvements on efi
Date: Wed, 29 Nov 2023 22:29:37 -0500
Message-Id: <20231130032940.2729006-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

When I run the arm64 tests on efi, I found several runtime scripts issues. This
patch series try to fix all the issues.

The first patch add a missing error reporting.

The second patch skip the migration tests when run on efi since it will always
fail.

The thrid patch fix the issue when parallel running tests on efi.

Changelog:
----------
v1->v2:
  - Add the fixes tag in patch-1.
  - Change the $last_line to embedeed format in patch-1.
  - Move the check EFI into the check for migration, which decrease one check in
  patch-2.
  - Add more detailed comments about how tests fail in patch-3.

v1: https://lore.kernel.org/all/20231129032123.2658343-1-shahuang@redhat.com/

Shaoqin Huang (3):
  runtime: Fix the missing last_line
  runtime: arm64: Skip the migration tests when run on EFI
  arm64: efi: Make running tests on EFI can be parallel

 arm/efi/run          | 16 +++++++++-------
 scripts/runtime.bash |  6 +++++-
 2 files changed, 14 insertions(+), 8 deletions(-)

-- 
2.40.1


