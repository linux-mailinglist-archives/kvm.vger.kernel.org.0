Return-Path: <kvm+bounces-34955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20143A081A4
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 21:51:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27247169579
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DFBF205AAB;
	Thu,  9 Jan 2025 20:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p2Ypn3us"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2285F2010E8
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 20:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455799; cv=none; b=euNas9QLtmvZ52i9vkt/H9MLFbpuzS8z4q1MSOmI6a3BDS3QRlLVi+o9RiAFDpgBMbh5lUTNhW3AKwel1rVI6An9lbbsjtkTtW5XZ47uKQTG/rNwhCcWdiaL/gJYbfPWry+sbIDjZOHN7mt017orsubXEOCk/n1BLlj250mbghg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455799; c=relaxed/simple;
	bh=CmgtQ2eKueuvA0O3zOIgnVmBoSBMqtMP0Wab4N434t0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p7rYPZ9zFKiuXNLe2ByA5UVYDpMUNgpV1PIyfPk2zAirTgg4Dse3M7lhUsGtpRYEcV+ltoH+Wh8dKmY2ENKAIay30ocAUJ/iPDeOFd3JHna0XnGkF1/EeB8DoWH4vH/WPCVUP0cE7x76OQlt5nTeckpIXVXA4R20l8zmWSlSlOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p2Ypn3us; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-4afb0276095so232729137.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 12:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455797; x=1737060597; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=inJmWA70Ac+hZHw9fDPSAlORU93rduBYUNSCVpvyraE=;
        b=p2Ypn3us1MoEIQVIpqufx0haf3J6pgjd9V2/GtF2sO68+YNnC23rxFKfkjWfS0oKgc
         MMnUCB+BpokOcbPoLsDZxp3Jgldm3aqzvTVMjljvRh/xyEwK/H2ro7tQ3iAAKpJCp25C
         oXKh/CvoLYzoTnaGXubOoMbAiak9H3D/N2wNB/wA1gel+JVmkhEcPBztebSMDB0e4Q8w
         Da4YpwDuTktoVv5NW/ofp+vz41YgyQ98BFsrwUqnyxxz6IMHo7052eQaNzHM+TtecsI0
         5L4ZaOCeqh4Srsbqmu9gAX9ucOED+i4EdfCMyxeX0eagK5OoCXVo2MGG3zze8gjNdA76
         eYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455797; x=1737060597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=inJmWA70Ac+hZHw9fDPSAlORU93rduBYUNSCVpvyraE=;
        b=ZohJveNQPp7urpyHdMm+/b8awFYGtmmIzRCpk/Vi6qV3XE5pZ66SniknjoTTqM8rCD
         o+YkJsrD3nY9CfrPA/i0FygcKpefzVIjNFoSN8hG1te4gnX2t3CPmmScmkMsQJc35vRg
         xVyX+Jm0lDxuw4BkmqIj7IJSDyzG9b8u0dnH/wgf0gjZgfSIINTk/VlIss6ILazUYfDF
         7UdTYN0N5eTpVmWfeACzGMjHRPK1VmWMvOvuH8Ll/Qv4XUZ5PTLhzmiPldcD6Zid5+FB
         ibiFkMCk+4EqdVZspdPgO1g50/cADp3gxBGP9K95ay2nxawkE6or5jZho+k+Bi0mYitO
         nDVg==
X-Forwarded-Encrypted: i=1; AJvYcCVNP3SudScOxGaB7t5Ur6bZLmxZ89h45YQfXXbGn0a4SRc+Yns11JRuZL2fXBcycFJeFwA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4Z/nLNy8SoVjbxsaooP2UqNGDDFKrSmfeZobNhscx3CU4bAOq
	W2CbAKgAWUmTY9mSzY8Jm1gNTODLr9g7Y0qBEqvDtDrQZav6WVzs/z2ygF5BCqFtOeEzOlWZ0Oi
	9tT6LcqZujoNMQBLaug==
X-Google-Smtp-Source: AGHT+IGmWC0I9uhGcwdr2Gd8ZWKOxj9FqNl2pt1I3pHNzlZaCTTUBXu0xZZz+qkK1VqDCdKw56Aw4mYDSrKY0XUr
X-Received: from vsbka9.prod.google.com ([2002:a05:6102:8009:b0:4b4:eb7c:c900])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:38cd:b0:4b2:adca:c13a with SMTP id ada2fe7eead31-4b3d0f05fbamr8311073137.12.1736455797065;
 Thu, 09 Jan 2025 12:49:57 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:18 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-3-jthoughton@google.com>
Subject: [PATCH v2 02/13] KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This flag is used for vCPU memory faults caused by KVM Userfault; i.e.,
the bit in `userfault_bitmap` corresponding to the faulting gfn was set.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7ade5169d373..c302edf1c984 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -444,6 +444,7 @@ struct kvm_run {
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+#define KVM_MEMORY_EXIT_FLAG_USERFAULT	(1ULL << 4)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
-- 
2.47.1.613.gc27f4b7a9f-goog


