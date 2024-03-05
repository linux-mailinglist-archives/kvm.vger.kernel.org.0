Return-Path: <kvm+bounces-10946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9901E871C65
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:58:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 558AF2851DD
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE1255C5FC;
	Tue,  5 Mar 2024 10:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMIIzzi3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE60A5C05F
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 10:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709635959; cv=none; b=tfM3nnGx/mEnbwxQ5RV5rGgc4jfV5WZm8xQ9+0uj89OpWZQJosPK9+wlJk86h3aiKE8/Jvkog8mKFM9dZAHsl/5ZE2kpbsP3VWOBNxAd+jysLG4r6cnmUVdqgLV7tyoTvd71bv+yd7k1j13ID7dLaktd6/m7HgEcxuxqxbS6U2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709635959; c=relaxed/simple;
	bh=ExvFBemFw7riN3B5nuy7+ao10E/jIIz9+L0sqwsgSAs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ZhSFRHjHmaio+Nk29lcB8cokPVz3vpEM52mtajx82xITcsn0CvIX4v16D+cMy4IBFOuFSZ9JVg/i0dScDWQpXO4T3mHya4C1FI++652QGYpNuimS84/HqxubWEVZIv1zbm6xOPeQil1BW1rWe4RGdb+FNI4gcpbc7Z54m32iykc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMIIzzi3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709635956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QXXrnxGBxMGgQNNZbpH3bctjMDiLFNhErcRPQVRsX3g=;
	b=VMIIzzi3AycAobg9gnsrl6ev0cjO3DyRC2LIcbKhUQgXUqLASgR/fGPl2IApurVP4TYjKN
	0Mt6cNhDnw+jiEFRnD0obwwqyS9MGWF0PtEn3YnbRQcIVdvtWNbxhNhSxJSP2qUIke6032
	O3O74Pt+FOlEyRIfIoYmgPsiZ51ecwQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-Inp4hYS2M_i9dAj28f14tw-1; Tue, 05 Mar 2024 05:52:35 -0500
X-MC-Unique: Inp4hYS2M_i9dAj28f14tw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3FC787251E;
	Tue,  5 Mar 2024 10:52:34 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.193.36])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5982A17A8E;
	Tue,  5 Mar 2024 10:52:34 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 34CFE18000B2; Tue,  5 Mar 2024 11:52:33 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v2 0/2] kvm: add support for guest physical bits
Date: Tue,  5 Mar 2024 11:52:31 +0100
Message-ID: <20240305105233.617131-1-kraxel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

The matching kernel bits are here:
https://lore.kernel.org/kvm/20240305103506.613950-1-kraxel@redhat.com/T/

Gerd Hoffmann (2):
  [debug] log kvm supported cpuid
  kvm: add support for guest physical bits

 target/i386/cpu.h     |  1 +
 target/i386/cpu.c     |  1 +
 target/i386/kvm/kvm.c | 31 +++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+)

-- 
2.44.0


