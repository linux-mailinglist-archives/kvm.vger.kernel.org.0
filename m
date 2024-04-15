Return-Path: <kvm+bounces-14644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9321B8A50EB
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:20:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C46881C21C84
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B0C7581A;
	Mon, 15 Apr 2024 13:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MfDQpNBY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F7774C04
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 13:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713186212; cv=none; b=q8bO5hbun1clOsV7d3m5qg4iyXDnbvAyNQdGRamNW5rVKMBpHyZT+2e4//fAVF3kSY16aUvgybi5DA8s2qYVDtAzKugnTY/OHtNHQzq/M54WG47yHXhM//XbpIoFxEHfQZa4rgS4VjMjyB4OUa6eziTdeKOWLuvmO/SK2ll6tCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713186212; c=relaxed/simple;
	bh=bDWggnzhtXTHHLkA7gzx9ymhI8l0323hjLqLp4A2O/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OMMP8sDRoMCik5NhdbYKUXC7AnHV7N2hanS5OHLGOy4PdxoV7xeslDZRStZ3D8FdKR+K92chZ1WrJyfy/4EcaqJcwJsfMvdSGgArpBXUhwseKFK1aZQf17/bjoWTTVlVneS78gClwLRiM9g73tSL2Ud5CRFlz7G+bGNXEOKLLxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MfDQpNBY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713186209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=x2eu7kx/ma/BYi36u9yRpezV/GA2fDRjZu1b82NJs9c=;
	b=MfDQpNBYSWaehIGVHI8xwwaChtMBv5X5rVZcdX2l/f7ZBy+bo1K9MMU4n0gDpjpRNZIWAL
	0yeXjvK+HgyC0wa1Ed/kldLaoDPu4zip5OJmF/ZebjR80HogzS6KCq6lNngD4boCWnpvPe
	XOEVP/HBYwUmNiZMlK3OfCtQXVq0JSY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-2_YAaEHqOmG_LeBCWLtIZQ-1; Mon,
 15 Apr 2024 09:03:28 -0400
X-MC-Unique: 2_YAaEHqOmG_LeBCWLtIZQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB10229ABA22;
	Mon, 15 Apr 2024 13:03:27 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.192.87])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 909DB1C06889;
	Mon, 15 Apr 2024 13:03:26 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [kvm-unit-tests PATCH] gitlab-ci: Fix the cirrus pipelines
Date: Mon, 15 Apr 2024 15:03:21 +0200
Message-ID: <20240415130321.149890-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Pulling the "master" libvirt-ci containers does not work anymore,
so we have to switch to the "latest" instead. See also:
https://gitlab.com/libvirt/libvirt/-/commit/5d591421220c850aa64a640

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index ff34b1f5..98177cdb 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -308,7 +308,7 @@ build-centos7:
 #   https://gitlab.com/libvirt/libvirt/-/blob/v7.0.0/ci/README.rst
 #
 .cirrus_build_job_template: &cirrus_build_job_definition
- image: registry.gitlab.com/libvirt/libvirt-ci/cirrus-run:master
+ image: registry.gitlab.com/libvirt/libvirt-ci/cirrus-run:latest
  before_script:
   - sed -e "s|[@]CI_REPOSITORY_URL@|$CI_REPOSITORY_URL|g"
         -e "s|[@]CI_COMMIT_REF_NAME@|$CI_COMMIT_REF_NAME|g"
-- 
2.44.0


