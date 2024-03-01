Return-Path: <kvm+bounces-10613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B7886DF0F
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:14:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABBFC1F25794
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 10:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A956A8D4;
	Fri,  1 Mar 2024 10:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fllSf0MU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288211E886
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 10:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709288057; cv=none; b=rnaDAqzrP0yy3PO28Ezjkdt11MpsYjbt1amy9v4UNGJkB/DpZEvEb/i/7MI34njib00r7JDTDc9nLdDS3YyhYXCm2+AS8qZp6cmzcMhqZ6OawMDPYj9SgyHqtU/UyICZk0GgMS6mISMbwjpZWMOduofH6hUSLZ2z5Ua1Wu1ajYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709288057; c=relaxed/simple;
	bh=pd96EErgclFz4mHcitZg2HvWTsowfNBTKRTjFSrCm+k=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hOpJVThHjV82fQQjWo9ZCcbfLscfpqR536hYr63xa75g2YTlnOC7w1ifmPehBXEPFKy+BpnOnvHiizKRXoFSYI3Ew8ib6TIv9VezY0dQrqfYLXjXqzu+PYo3mtTqMD+JhVpqA2XLGMeATsWAuJ6FIhNxFioDQYQ5kAZ6UzE7AvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fllSf0MU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709288055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JUOQYhiKCOxnE9lb3KXp86kxc2UtFWyyA38jGPwnyAo=;
	b=fllSf0MUI7flCFGeqefWHim2RL29WcIZ2Ad7ZyPoKoX+e88wawg3gnlHoqlYOf/sgnwPXp
	jiQg8zN2Un4FIuHDr5pTrzhR6zjxn3rXHVl7Ua23QICwF2ml76A+b1Pkf6ovGiyrIfnz7B
	0fX5l2dOr0kfrfoNw1NXQD89S+WxjRY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639--rB_XquMMlGU9413nzaUHQ-1; Fri,
 01 Mar 2024 05:14:13 -0500
X-MC-Unique: -rB_XquMMlGU9413nzaUHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44AA41C0F2E0
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 10:14:13 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.121])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D1FB40243CF;
	Fri,  1 Mar 2024 10:14:11 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 7561D1800DFF; Fri,  1 Mar 2024 11:14:10 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: kvm@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 0/3] kvm: add support for KVM_CAP_VM_GPA_BITS
Date: Fri,  1 Mar 2024 11:14:06 +0100
Message-ID: <20240301101410.356007-1-kraxel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

This allows userspace (qemu) query the address space size available to
the guest.  Typically this is identical to the host physical address
space.  There are a few exceptions though, and this allows to handle
them properly.

Gerd Hoffmann (3):
  kvm: wire up KVM_CAP_VM_GPA_BITS for x86
  kvm/vmx: limit guest_phys_bits to 48 without 5-level ept
  kvm/svm: limit guest_phys_bits to 48 in 4-level paging mode

 arch/x86/kvm/x86.h     | 2 ++
 arch/x86/kvm/svm/svm.c | 5 +++++
 arch/x86/kvm/vmx/vmx.c | 5 +++++
 arch/x86/kvm/x86.c     | 5 +++++
 4 files changed, 17 insertions(+)

-- 
2.44.0


