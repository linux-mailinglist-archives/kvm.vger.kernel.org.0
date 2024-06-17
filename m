Return-Path: <kvm+bounces-19759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ACD890A7B6
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 09:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37DDA283D0A
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 07:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031C8190052;
	Mon, 17 Jun 2024 07:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gvcpbp1L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B16518F2C3
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 07:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718610710; cv=none; b=j2xGoUjoTjt87oAG2GkCKHdyaPg1ohxouI3ogMQAnTrqf5fTVthL2p8jugYJ/UbJnY/b0oX3ubAotdd0K/4fnnev0AdLEwr4W1nFZfgMLcNGrU9zAePe+Y40BadZW+1oUZjxn7bpRBX/IkD8ZqapWf5WD7dvVctDjrDQt5vh69s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718610710; c=relaxed/simple;
	bh=mproEs7n+ddFpkKXDlP2Smw07PE40yTNGmUf0E6+5Zs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k9B8tzx9rO0PQnMe+eMA6cBxH+3PmdyJtlAlMoHg23VR51EsUGsskSb5fpyaHgKgQSQU6rDq+3QpGnV+KEg+efx34PYywxA1O4VOD/IUnrbVrEWEY3jdwxqJS5J2xW5fLl/kD4F3IOKwJfYqIlkmGQlvQ8dAksej8VHOvnIjUV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gvcpbp1L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718610706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BW4VAsHAD5rQXt1LXI/66mtVgyz0sOVi0R128fdor2M=;
	b=gvcpbp1LUJaNLQCzE81irxggspYWBZGQ01p7IR70ovc5Pl2MEwS6y28wLlLSH2agxASml3
	8yItOs94+rX8zIKrYCg7PMbmKbH/7stg8AjCLtr5vfcuqH4931GMga3ZstJ3HI+bNqX5WN
	DM4hPhKBCMOd3liqSiEv2Bqti613dHA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-eYIEDCG1OhSnxDpFyTq0Ag-1; Mon,
 17 Jun 2024 03:51:43 -0400
X-MC-Unique: eYIEDCG1OhSnxDpFyTq0Ag-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E941019560AF;
	Mon, 17 Jun 2024 07:51:40 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A91481956087;
	Mon, 17 Jun 2024 07:51:36 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
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
Subject: [PATCH v1 0/2] KVM: arm64: Making BT Field in ID_AA64PFR1_EL1 writable
Date: Mon, 17 Jun 2024 03:51:29 -0400
Message-Id: <20240617075131.1006173-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

In this patch series, we try to make more register fields writable like
ID_AA64PFR1_EL1.BT since this can benifit the migration between some of the
machines which have different BT values.

Changelog:
----------
RFCv1 -> v1:
  * Fix the compilation error.
  * Delete the machine specific information and make the description more
    generable.

RFCv1: https://lore.kernel.org/all/20240612023553.127813-1-shahuang@redhat.com/

Shaoqin Huang (2):
  KVM: arm64: Allow BT field in ID_AA64PFR1_EL1 writable
  KVM: selftests: aarch64: Add writable test for ID_AA64PFR1_EL1

 arch/arm64/kvm/sys_regs.c                         | 2 +-
 tools/testing/selftests/kvm/aarch64/set_id_regs.c | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

-- 
2.40.1


