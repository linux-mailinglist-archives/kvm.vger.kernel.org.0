Return-Path: <kvm+bounces-6323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6106582E9BD
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 07:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3980B20C98
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 06:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9963111AD;
	Tue, 16 Jan 2024 06:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UW4I5w8Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D9A10A1E
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 06:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705388332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MQ5GcXOhiGFSyn5vD4nd7pcGv9wo7rlPf51HBEjNCys=;
	b=UW4I5w8YFTNeQZVgpKcToANPewy20DizCi+531lmD0vaB+6f/C6dYT4h4lj+T55+Sl9pVj
	DlFRwEaqp0BY8EKVTQCq2baFJ+JdLRXEmWcYAsZaWyUb24NY8z4X5vjfiaprUuJ6wAHnol
	ERkEhPESx0c12mgfvOFFIq7EA0OadvI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-Kqpsa5f8POSfN7O59EGkcA-1; Tue,
 16 Jan 2024 01:58:48 -0500
X-MC-Unique: Kqpsa5f8POSfN7O59EGkcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33D171C05AC2;
	Tue, 16 Jan 2024 06:58:48 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 065693C25;
	Tue, 16 Jan 2024 06:58:48 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 0/3] arm64: runtime scripts improvements on efi
Date: Tue, 16 Jan 2024 01:58:43 -0500
Message-Id: <20240116065847.71623-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

When I run the arm64 tests on efi, I found several runtime scripts issues. This
patch series try to fix all the issues.

The first patch add a missing error reporting.

The second patch skip the migration tests when run on efi since it will always
fail.

The thrid patch fix the issue when parallel running tests on efi.

Changelog:
----------
v2->v3:
  - Collect the Reviewed-By.
  - Drop the arm64 flag in patch summary of patch2.
  - Small tweak to minimize the call to basename in patch3.

v1->v2:
  - Add the fixes tag in patch-1.
  - Change the $last_line to embedeed format in patch-1.
  - Move the check EFI into the check for migration, which decrease one check in
  patch-2.
  - Add more detailed comments about how tests fail in patch-3.

v1: https://lore.kernel.org/all/20231129032123.2658343-1-shahuang@redhat.com/
v2: https://lore.kernel.org/all/20231130032940.2729006-1-shahuang@redhat.com/

Shaoqin Huang (3):
  runtime: Fix the missing last_line
  runtime: Skip the migration tests when run on EFI
  arm64: efi: Make running tests on EFI can be parallel

 arm/efi/run          | 16 +++++++++-------
 scripts/runtime.bash |  6 +++++-
 2 files changed, 14 insertions(+), 8 deletions(-)

-- 
2.40.1


