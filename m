Return-Path: <kvm+bounces-34964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E4B9A081BF
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 21:53:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7430188CB3B
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1273207A07;
	Thu,  9 Jan 2025 20:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lnGb2amd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BC71FC114
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 20:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455808; cv=none; b=MYDc7eV2adf8hhkqzfnqM3lp1SgZTJnaZy6dvd+jg3hIpNAdkXxqSDrNcuy/BVeOGmvTTeIwFs1nBEr3r4XZJzjxmV4BCiZYKsAiRw7oiu8h1kJatV/dg0aChJcfRkFeNn4gT08vEJe735sTDeag9ioO83dgl7LXQyFHkjOro3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455808; c=relaxed/simple;
	bh=0eyMEtCsJeYENXDg27iZXcBn86i7IQLtffZKe3KbKs0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f3529iyHgGG2nKa57MPnr8hh9cRGwDTJCsshFzPxZZ2eSMTGPIrf13ZHIVTMJ5TqU1so65Xq/mCJIxSPBAyoC+4D7c2yF8IFgYRbn2OvmtCAM42hfNKVoyZsyBR6uSY1+eKiRVH/JZQeBAmqoge/+eozaToFKiaHcAd6Y4Jdh6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lnGb2amd; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-85ba35d100fso163266241.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 12:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455804; x=1737060604; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A4uSddURoLEbUkGuIhSA7RvXzffvl1Ath1WbpEvQHEc=;
        b=lnGb2amdeluEUvZZa4tCCapSYrU6KfvKXqKec37vD1kloezlACy77FPdOyOSvkOxdL
         veSdrNAq/+EM+UTg8KzEzaf5in0+l+yHrfmPU0gwcX0UpwS3oJ/C334ZF3pGaKitBKTp
         J6n/+gCSEcWaDAKbEsKF/EJMKOYfZ1DMT6RW2WY2njJHZiJZ6rBdZk35tcc47FV1j86B
         yDC+7jVhyjF9/yHpzR4zr3X/1fS9s9y+BPqef+i8zf5UP4WkIvrpNDu6jADWrYLOXB+g
         N0KyitO+Utw/RVEbGGnA+4oeDymKX1hwi/JJ/8KwB5nMzMoQqb/N1CMdS4F4LSecJLkk
         1SSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455804; x=1737060604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A4uSddURoLEbUkGuIhSA7RvXzffvl1Ath1WbpEvQHEc=;
        b=gl3BmvRQRjzL/IqQsiqzhstAorNpc5i8npvSquaHlOAEheAcc6olmoCzKOZJws/rJw
         wlK14+t/rEVufjeuGs+jw1byXn1O/8zrQn+QJjYr4UViEdnRmgAHptq+TdzH7DiSEoAb
         jG2peDeM3gf0hDR2ZIOqxYS6SL1GnIp9S87OvfSZsiSZa22N6LSMvjbty1RVkK14EmQT
         q901uBFhlD1/azqGL8EAHpQVwuirupAwLxdlIl/V/v/COKyUfPZbUG9DvBWr1cb3+5zr
         TFj/r8ugN2UWvXIK1nYhdNWQj8X2aE2vOcBHsEZshNee2NJWRUKJqIFIH5lEPlR2FSp0
         CyCA==
X-Forwarded-Encrypted: i=1; AJvYcCX08i6Kl7I3D53RfM1vECQPcKmuXhGXXhh7MAdUxPttpSld6Q9QMzz1RGGChAmYgRJYooI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwomULbBG7aYtVsdHHnKRl+hM6vau1+/LRnGYneOjod2m1y/3Pi
	33iVJaTTVchPvdYo8eRJwCLcn+ZnxfNzfLhrRoKNOCublmurtvN6Y6wbcv5sSjKZzE0DnpCGRxL
	6uwyxvVoVPXIv6PpcDg==
X-Google-Smtp-Source: AGHT+IHUcz3SJhDUBT3AFAphG25I/PCLrMSFE5oskoAYquhM4FPeQ8hRbnzHYl6jdbwhQgIl3dB0klJ9OTTcUSfO
X-Received: from vsbic11.prod.google.com ([2002:a05:6102:4b8b:b0:4af:dad1:fc51])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:3e20:b0:4af:e5fd:77fc with SMTP id ada2fe7eead31-4b3d0d75fcfmr8791219137.3.1736455804705;
 Thu, 09 Jan 2025 12:50:04 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:27 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-12-jthoughton@google.com>
Subject: [PATCH v2 11/13] KVM: selftests: Inform set_memory_region_test of KVM_MEM_USERFAULT
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

The KVM_MEM_USERFAULT flag is supported iff KVM_CAP_USERFAULT is
available.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 86ee3385e860..adce75720cc1 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -364,6 +364,9 @@ static void test_invalid_memory_region_flags(void)
 	if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES) & KVM_MEMORY_ATTRIBUTE_PRIVATE)
 		supported_flags |= KVM_MEM_GUEST_MEMFD;
 
+	if (kvm_check_cap(KVM_CAP_USERFAULT))
+		supported_flags |= KVM_MEM_USERFAULT;
+
 	for (i = 0; i < 32; i++) {
 		if ((supported_flags & BIT(i)) && !(v2_only_flags & BIT(i)))
 			continue;
-- 
2.47.1.613.gc27f4b7a9f-goog


