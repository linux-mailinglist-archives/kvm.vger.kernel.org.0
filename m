Return-Path: <kvm+bounces-19391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 81C6690490B
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 04:36:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C80A1F243D1
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 02:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86D5D29B;
	Wed, 12 Jun 2024 02:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JY4/gZ7u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E021B651
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 02:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718159773; cv=none; b=EbXgjeV6CUJrPmc+jF0jt0kM4JHemtFHYOf3FKZCyPZiXHf72HKGaKQKo9Gi18F6cUh96MzD+D0uUthk5f0bI5v4HBUtbWR1kM3dedtn9BxiqcXCyCsuqH0RjdZxrBoYM/mIn1HER7RnrBYUwUyMIJcp5MQWVZTrYaGgdk2WBwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718159773; c=relaxed/simple;
	bh=+zTXVVp9zEYSS8FpmkYG3jt7vMygW3q5VbDW7BOSSik=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IIeB8diJsf+B4fy7gg/srScPQodCcS9+XgcJSqzSGUw7H7aCNJgGvsh+3QWd02wGltOubHH0YF9UjEvd01TEFuXRAEvHbNuzdD3iGaYy9cEOVBbw0EpA+f0futhZHLAhnMUsWgO2D8q57TaXX6LH7rgsME21TUoccDzy0hWMHU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JY4/gZ7u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718159771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rm5KrzlMz16jgYDKm0W+81rd6UxTby42kLMaocYRJT4=;
	b=JY4/gZ7ud1se1mOvSiFVsqrmTI0ucmOkayGzy2C093HVTcVG9WXCwvtdS7/fv7nh3XAjwj
	MYGbw3qtJFBTcdYK7X0EbkpGU7zYzAHu1cb91qTrPkmQreHLTGTqLTDMkjtE6i2UgiMz/T
	kVFXMXTmyeMTLCWY7PN2vTMcTm4hOP4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-I3EBlmaWOheMu2EXI5MiEQ-1; Tue,
 11 Jun 2024 22:36:06 -0400
X-MC-Unique: I3EBlmaWOheMu2EXI5MiEQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E358019560BD;
	Wed, 12 Jun 2024 02:36:02 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1E53B19560AD;
	Wed, 12 Jun 2024 02:35:58 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Eric Auger <eauger@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [RFC PATCH v1 0/2] KVM: arm64: Making BT Field in ID_AA64PFR1_EL1 writable
Date: Tue, 11 Jun 2024 22:35:50 -0400
Message-Id: <20240612023553.127813-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hi guys,

I'm trying to enable migration from MtCollins(Ampere Altra, ARMv8.2+) to
AmpereOne(AmpereOne, ARMv8.6+), the migration always fails when migration from
MtCollins to AmpereOne due to some register fields differing between the
two machines.

In this patch series, we try to make more register fields writable like
ID_AA64PFR1_EL1.BT. This is first step towards making the migration possible.
Some other hurdles need to be overcome. This is not sufficient to make the
migration successful from MtCollins to AmpereOne.

Shaoqin Huang (2):
  KVM: arm64: Allow BT field in ID_AA64PFR1_EL1 writable
  KVM: selftests: aarch64: Add writable test for ID_AA64PFR1_EL1

 arch/arm64/kvm/sys_regs.c                         | 2 +-
 tools/testing/selftests/kvm/aarch64/set_id_regs.c | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

-- 
2.40.1


