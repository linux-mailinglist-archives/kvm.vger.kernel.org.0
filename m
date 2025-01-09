Return-Path: <kvm+bounces-34916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31014A077E2
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 14:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1D2E169325
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 13:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA9D92206B1;
	Thu,  9 Jan 2025 13:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YqGkmfWy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D73220686
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 13:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736429911; cv=none; b=qprPigaPZEh7h2ZuYDePh0EDJK8kaoSiVnmoeBHFUOu0mH2mXrae97RSRMTbvlb1Of2akxSAWhnsAaGtT3aw8+XAm/kUxbsqP8aPYTh/vMMs6OeCK6ixF02DEnDirBOIUwxtLmd3In95DMqzONt78cFCspWhuSbhen9u5Zat+K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736429911; c=relaxed/simple;
	bh=gHVqbeeLDW26xdNiUZY5UzwMkP98DCAKakRVGGlY3Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GD3/AJ97BU6oqDXWj7fakRDTtsH7mwno2YBUbl99cvbIq2nhUI7dAC4aNiaL89PTmzyFzQKxRl8MESkUwUT81urh6yLyEXZTKCtcTlx2Q67YklTmqE7Q0Q01snceMrvYuKQ9r7WJqwjRZMQ3NFtnzj9jV7DcpXJM89YajH6wxSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YqGkmfWy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736429905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+qIG/0LvnjXMgyU8eqBX8hgYV7UmJPw6Xa2UEwpxHJA=;
	b=YqGkmfWyEjjY77HA0vyTth1nUFN7C+3p0TP6pni2mbjmzQzWkCOEOtuS6ch3rFRJUnmvJZ
	TP2s+6j68+qVWWDwZQQnViMHPtRUIvXqNfINzq8KF0LIsblGIUT5jmNeRNajkGc97+16bw
	pF+kcTICC5E/UQHUWdPcxFr51mKz8KY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-6K0RCVH7Nd-N0zYGN-2gHw-1; Thu, 09 Jan 2025 08:38:24 -0500
X-MC-Unique: 6K0RCVH7Nd-N0zYGN-2gHw-1
X-Mimecast-MFC-AGG-ID: 6K0RCVH7Nd-N0zYGN-2gHw
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5d3eea3b9aaso677685a12.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 05:38:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736429903; x=1737034703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+qIG/0LvnjXMgyU8eqBX8hgYV7UmJPw6Xa2UEwpxHJA=;
        b=OVxiy6yOXtzkyNv4xPx1TAcwpPD5jB7O+OF9ad8VqhoQjVqLjBq/Ta96e4w6J1WOgy
         UVHKPrKf3VkJR8+wNlMx9aIDSGr2BhhBx2yb0x10t/FHnNdKMOvqp5rvkU+XjVm+jgGj
         jRP8POYp4fDcYRCv0v+FkjleEsM+gVcVN8Lu4E8/p/xp/RfYjol/VV83XzJAnJitzV+H
         p/vceTOjVRV5VfP+GmCurBKM0m2B79eKshXBfTB+AAHVH302LlmtSgBiHfSKsvWkjaV9
         tVPgVCsJeJ3EoCUiRwP5UN+NGuPMQLtm2VLPU7dUu56aTJyRgRT/JOjoP3sCWqlC7kEM
         zB5A==
X-Forwarded-Encrypted: i=1; AJvYcCW+bgnflyT+Ut7AcLCUDnO6dWESkvfQv8oq74qrmZgfzN6hIxAjBW2lPMO0H6Pb0YSQIHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKD6/f7V6GKZGNKgopbmr8RTOlHcbuKVg/XtG+dehSzd3n9CwQ
	mf/i5iNZ6Pn7oDJ+faGnljU1zbU6QsUKStAJxrXJRzprSexySQgSON8QO7q6MKGMpUWiaBCWm13
	zMqoYFQy2djwUPYsDcThobZhygZWazNXKTIDpRAg5Datc2sg/zA==
X-Gm-Gg: ASbGnctvS3CRW7m8XTWFY530dMnG1i7IhcamCEegUGXb9Ym50uPqpdh53qxtOF0xE+e
	DwSmS39r3t9eEyJWYqfPRT0vaDzQvx9D5a0vQtxEfHZuc/hTE++54z1ZKZ1Pf6ojlTMugsTuxKh
	QeKF7hN0gygV659K8nY3xm7La9tkx3JLGmWkbAk9NGgyPtpACATGMeAVyCrAbGeofsusrcfHIux
	6afPqCiFy6tu1tiPN/8axY7oicYtTQ3u106GJwZaWSqOkjq/j91E8simi0C
X-Received: by 2002:a05:6402:3549:b0:5d0:e73c:b7f0 with SMTP id 4fb4d7f45d1cf-5d972e70945mr15040460a12.28.1736429902493;
        Thu, 09 Jan 2025 05:38:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHsGUykWSOpesU6tHxPGZnO3JxPfRRnO6klBd/fYEFfPEHAwQWWT0oVTu7t2r5Sxoacsy+c3Q==
X-Received: by 2002:a05:6402:3549:b0:5d0:e73c:b7f0 with SMTP id 4fb4d7f45d1cf-5d972e70945mr15040371a12.28.1736429901823;
        Thu, 09 Jan 2025 05:38:21 -0800 (PST)
Received: from [192.168.10.47] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d99008c366sm624477a12.17.2025.01.09.05.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 05:38:21 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: oliver.upton@linux.dev,
	Will Deacon <will@kernel.org>,
	Anup Patel <apatel@ventanamicro.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	seanjc@google.com,
	linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH 1/5] KVM: e500: retry if no memslot is found
Date: Thu,  9 Jan 2025 14:38:13 +0100
Message-ID: <20250109133817.314401-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250109133817.314401-1-pbonzini@redhat.com>
References: <20250109133817.314401-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid a NULL pointer dereference if the memslot table changes between the
exit and the call to kvmppc_e500_shadow_map().

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index e5a145b578a4..732335444d68 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -349,6 +349,11 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	 * pointer through from the first lookup.
 	 */
 	slot = gfn_to_memslot(vcpu_e500->vcpu.kvm, gfn);
+	if (!slot) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	hva = gfn_to_hva_memslot(slot, gfn);
 
 	if (tlbsel == 1) {
-- 
2.47.1


