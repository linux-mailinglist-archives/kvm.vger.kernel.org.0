Return-Path: <kvm+bounces-49989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FCEFAE0CA6
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 20:19:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B046917A7F1
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 18:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE4F298CD5;
	Thu, 19 Jun 2025 18:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N2Foun68"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A731298247
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 18:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750356133; cv=none; b=XIJlwRb7Ee3YUpq1aC8oS5yvUoDk4XM5TtNxwaUxS/u3xwyBWagLkfDiEMW6uqq5r0jLjvOg69anwJ1y9KhSmA7wa7FR2goy2h4pfyrLrY6S7D6CgR6EClEzk9JgngMSOP4/pyf7nhH5os5YsGh/KwJ2zzSCs94aXfYh+LF7QoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750356133; c=relaxed/simple;
	bh=NUzIuRJOiY+vaxEiC/B98ILU8KhziclSjuFiudHGbw8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LVDgrpxS8U8/YMEIRRfVqctnzHGP0KhLIkjnFuP0qyWgPhajhTxAiXSavPtCSSn+UP827dQx/Vqso8HN6fydzv2d7+7S2Mcvpgwddh2KuPtezeAZvo5eG91r9qFl4OQsA9kzYj6kZTMw6hFBFX+61zYa/FOv3xI7CWwK+WDo7uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N2Foun68; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750356130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RHCQtoHGjMDrhRcO8E0Tsx4dl8R3fUsghttQ3tnfAJk=;
	b=N2Foun68seqVegkffkrtLAQEhtdDTdfg5lZSGntRIn7ow+JUc3hUg7vwspxY1N3q6i0ODm
	ufCinajIAEM7zefMJ4XXvJ/9aZX0Z1qON/i3c+I+Y2xgAVA84UMSeJG/tjz6opSFMHjpw0
	VAEmrl2j3YCJ4QjFgNxlZf8fRdFiyww=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-388-o63fMCJ-PEij3pYZnfvtiw-1; Thu,
 19 Jun 2025 14:02:06 -0400
X-MC-Unique: o63fMCJ-PEij3pYZnfvtiw-1
X-Mimecast-MFC-AGG-ID: o63fMCJ-PEij3pYZnfvtiw_1750356124
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D136180135B;
	Thu, 19 Jun 2025 18:02:04 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A8C461800288;
	Thu, 19 Jun 2025 18:02:00 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	mikko.ylinen@linux.intel.com,
	kirill.shutemov@intel.com,
	jiewen.yao@intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 0/3] TDX attestation support and GHCI fixup
Date: Thu, 19 Jun 2025 14:01:56 -0400
Message-ID: <20250619180159.187358-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

This is a refresh of Binbin's patches with a change to the userspace
API.  I am consolidating everything into a single KVM_EXIT_TDX and
adding to the contract that userspace is free to ignore it *except*
for having to reenter the guest with KVM_RUN.

If in the future this does not work, it should be possible to introduce
an opt-in interface.  Hopefully that will not be necessary.

Paolo

Binbin Wu (3):
  KVM: TDX: Add new TDVMCALL status code for unsupported subfuncs
  KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
  KVM: TDX: Exit to userspace for GetTdVmCallInfo

 Documentation/virt/kvm/api.rst    | 62 ++++++++++++++++++++++++-
 arch/x86/include/asm/shared/tdx.h |  1 +
 arch/x86/kvm/vmx/tdx.c            | 77 ++++++++++++++++++++++++++++---
 include/uapi/linux/kvm.h          | 22 +++++++++
 4 files changed, 154 insertions(+), 8 deletions(-)

-- 
2.43.5


