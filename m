Return-Path: <kvm+bounces-12032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2135F87F2F7
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6B8FB22002
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9230759B77;
	Mon, 18 Mar 2024 22:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DLYiSF5I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134535A0FA
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 22:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799810; cv=none; b=Fl2yostq7fL4cEMvnduXdT9G9mpQdZ2Mkr17fgsNx2Dtw6Q+Fvh5v+z0N3jJy0kfm8N38nvPu0/+x2FuepazBNotrm4q15BvLb9vy7FIpLmtLUfv8Ot3LtqeuHdgVDnQ/M3YrT7U/y75LDDKPuGACmdMBA4GeNQKAJnZe0JBHZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799810; c=relaxed/simple;
	bh=SS06J2Qq7Itn7uGpSS75eUlr+DDWdLd2LrLa8ZpCTXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=q5jCpRe5yEHeNCHhRoC5K2JqgEMEBNbGJ1VC2Z7Yl8wY5XkTUqnRlMvn00iHNLZxqJ+5z2+PCYTF5SZldL4XbvWeFZ5EyHxDyzjQiHIYsK+IA4FY+yJWDCZEXShk9ox4/Cms+6pbq2tpQFQG4okk/j8dm5nxiR/rfU3ejF6r9QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DLYiSF5I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710799808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lU3bYlVFweW6d5myNi1cvNJ/wMZHrCTdSlP/1ol+Mt8=;
	b=DLYiSF5I1HqwJL6rnGQw4ed5C1sz9LsiXp8C/szY4BNvwZqeZg7qCUO5OcgUXaoKvLEwld
	YeVNDnmkL/wdrv7z0iyY+0lSuw7hmBfwRPZlJf9AyL69+nr3hpiRmRqPdBzzKCoyW7+xIs
	e4o2HQNak8M0C261k49G3qciHKiaXj8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-iDRZ-uWrNBe7E91cIiLiGw-1; Mon,
 18 Mar 2024 18:10:04 -0400
X-MC-Unique: iDRZ-uWrNBe7E91cIiLiGw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AE861C04338;
	Mon, 18 Mar 2024 22:10:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C5AF492BD3;
	Mon, 18 Mar 2024 22:10:03 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com
Subject: [PATCH 0/7] KVM: SEV fixes for 6.9
Date: Mon, 18 Mar 2024 18:09:55 -0400
Message-ID: <20240318221002.2712738-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

A small bugfix and documentation extract of my SEV_INIT2 series, plus
4 patches from Ashish and Sean that I thought would be in the 6.9 pull
requests.

No need to rush this in during the merge window, but please ack
nevertheless.

Paolo

Ashish Kalra (1):
  KVM: SVM: Add support for allowing zero SEV ASIDs

Paolo Bonzini (3):
  KVM: SEV: fix compat ABI for KVM_MEMORY_ENCRYPT_OP
  Documentation: kvm/sev: separate description of firmware
  Documentation: kvm/sev: clarify usage of KVM_MEMORY_ENCRYPT_OP

Sean Christopherson (3):
  KVM: SVM: Set sev->asid in sev_asid_new() instead of overloading the
    return
  KVM: SVM: Use unsigned integers when dealing with ASIDs
  KVM: SVM: Return -EINVAL instead of -EBUSY on attempt to re-init
    SEV/SEV-ES

 .../virt/kvm/x86/amd-memory-encryption.rst    | 42 ++++++++------
 arch/x86/include/uapi/asm/kvm.h               | 23 ++++++++
 arch/x86/kvm/svm/sev.c                        | 58 +++++++++++--------
 arch/x86/kvm/trace.h                          | 10 ++--
 4 files changed, 86 insertions(+), 47 deletions(-)

-- 
2.43.0


