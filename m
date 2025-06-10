Return-Path: <kvm+bounces-48869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F06AEAD434E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:54:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F2203A4E4E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9307826562F;
	Tue, 10 Jun 2025 19:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yjJFxLUs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1D8265621
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585265; cv=none; b=cerAFU/oN7s3ZBDUt/F6TolKMaSBtolQZ2ks+/+R1ddK4hnf4ICVvkxLoeOzFV3tmDm9GF4DAe8Ild/cOYzX7BgGp3kYT4KHMX0zg6Z40L+KK25C0C/VN/QxsQ4S3+roD/g961c8Btn9/bLr4lKZBnK9oOUx5mIhNsTRh6r7iP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585265; c=relaxed/simple;
	bh=m8BU+5eTaV2HJgelefdnCKCjjQ/EtT+r/4UlbPQq38o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HjTV0GGqgOhCP/QLEoueewhvugvjuLZGUnu/aDPTn9LXG4El3wkn4LarL7Zclj20KJsnNHl69M7Y7Vu9CaibtFDeAK2hRk/5eHn+ocyY5F7uJe7229SGPM/jvD+ghfHOflaD2I6aNjvimmBaXaVBHMf1PPUUkgu3owPVj9Y57WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yjJFxLUs; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2eea1c2e97so4109761a12.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585263; x=1750190063; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=t0yTgzHml1ElSDAxvAkNwMhAyR7ZOEme8dCw5Xzqrw0=;
        b=yjJFxLUswFWb056RR7MvOak8wjLgmxOBsVaiISjaQgqzSlkTfEWQhyJythHwv0MSxk
         84JluUjBCx70YVb1gNHoyMQkdeupjCH54Y4BMMfD77SK/IiRU5R5TBRutFlsy0cSl8hD
         T9+mz/OP8OspJQoQSzAGR5EF2plUnJY41kLXxJs73WZrAEFhN2vFePgvO+2we2ak/EyW
         0CiZGwRqglwPQKrzRok+J9sBwa/YLxYn3NMMosZNJel2+G/yD0qDeirEEBioYSIU5gAO
         4r1JHdXvjITqPSTuhOYFgKPIP8ED7BohyLv69/wa7h8aZ5d0PrYuqvpsKWv8NNlcwcVe
         46xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585263; x=1750190063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t0yTgzHml1ElSDAxvAkNwMhAyR7ZOEme8dCw5Xzqrw0=;
        b=HHhJwTsO/E9Gixlxq3waKawosAPbcLriz6/468FR01NNW7YDvAgO5FvpvudL3P2FcQ
         jJGKQdvNCxKZraMMUnJe/lshShMZuzeAam3alzShnUVgfXZuRB/lmreLPuOOKNONGguX
         +6jN9Az3A53u8R5iWDHToZZKyMuhNKJFrljyvCAGsZfVa+lMqIvtVf8SlPxDKTGiB8Uk
         puIgYWGYqfwuqS3D+lN+DyI91c8x6om6gfOUu9bmrVFD7Ymhx46xhjrHW1ZruDDnKiCi
         WyiSC+CvGCq6PTNPkRvh0BMB8OMQC9AqGqgcyAspMGPVJ5332xRmgryIXI/8d1Dhbz+9
         U2cw==
X-Gm-Message-State: AOJu0YyvGoqa0Ch1ZXH4b71JQcY1ycNpA4Le5LQVjJajhmXZsZ0ZMMql
	3y6ypneVO7cz/oR5sDzPrLLK7WoH/q8J2cDMDjp3QthEW44vO5rHa5nxDDYhY7ycit84pyi8EgW
	fLE7DSg==
X-Google-Smtp-Source: AGHT+IGFKndYpgYT4M2fmt6lWaXcZpGL4CL3n4ONjhbyjigsAcYen+I3xWbktFHZ8L1HLIhfZ5z5eADFef4=
X-Received: from pfvb15.prod.google.com ([2002:a05:6a00:ccf:b0:746:2897:67e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:648b:b0:21f:556a:ca14
 with SMTP id adf61e73a8af0-21f8660dcbfmr1004412637.11.1749585263690; Tue, 10
 Jun 2025 12:54:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:04 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 03/14] x86: Use X86_PROPERTY_MAX_VIRT_ADDR
 in is_canonical()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Use X86_PROPERTY_MAX_VIRT_ADDR in is_canonical() instead of open coding a
*very* rough equivalent.  Default to a maximum virtual address width of
48 bits instead of 64 bits to better match real x86 CPUs (and Intel and
AMD architectures).

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index e6bd964f..10391cc0 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -1022,9 +1022,14 @@ static inline void write_pkru(u32 pkru)
 
 static inline bool is_canonical(u64 addr)
 {
-	int va_width = (raw_cpuid(0x80000008, 0).a & 0xff00) >> 8;
-	int shift_amt = 64 - va_width;
+	int va_width, shift_amt;
 
+	if (this_cpu_has_p(X86_PROPERTY_MAX_VIRT_ADDR))
+		va_width = this_cpu_property(X86_PROPERTY_MAX_VIRT_ADDR);
+	else
+		va_width = 48;
+
+	shift_amt = 64 - va_width;
 	return (s64)(addr << shift_amt) >> shift_amt == addr;
 }
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


