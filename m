Return-Path: <kvm+bounces-12085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5162887F8A7
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C23451F21A8F
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A35753813;
	Tue, 19 Mar 2024 08:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bhflP3MS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F91537E5
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835210; cv=none; b=JP4zLX2zjTs8ugICj8v5t7un3xZTxvIazT+QNeZPMIXNcXJ6k/82uCraDBPeKrXk5StZ6FY+cIv/6eRcGkFt0fWR1UxjectdyRbjH0pfZilirQ/8fVrR2/OSu6IYYkw+P6pzG8NbccRxpTl4aBVGcpCnrIe5Bvf8oDkYm48wFO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835210; c=relaxed/simple;
	bh=1zNCoqHestvzjqmOKzTGuG6awWSNUYYGH1tNUv3KBPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+z2WryBxQunOJs721UD9mLnBuqhwaWgs4LThUFKUy3En8SZ4hpbIE+cgggSDW58zhzSd9Kzf6qyZNaNycW7iGbWMhViBcrsryIxPwaDfRtVtFeaP/iOUkZeS08Tbo+TrVl6qMWogD8gKiipjx9ZMOib0RAwAsWUrvdm8uoOnFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bhflP3MS; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e6ee9e3cffso3170351b3a.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835209; x=1711440009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fndo0MEe/uD2EZQF5VsTSnetuecWQ7lAuCXwwSf7lcs=;
        b=bhflP3MSC3qdNjk6ASKY/We5De7hbfwaF+ygKog78BctvhUVySyDKBNR2ozZD3Uf/s
         uK5LY9Uy/6FJoVx/qWx8Yf3KyRdfaMrI0/gSURDay3LeZB9LNORgp6jDACR86xOBd+HS
         cncuqBCjNOnFa6hX1+GoVEIjn0K4LpSL4FsD/qCckPg8/ap+AHm7NJpFYPvcPqfvTUtS
         iB/+04kXmWHFRztEIHWS1ArnC3+lU8S2SWol8o+BbEYAxW4EI+qvGt/gU7YLRy7mubKU
         r/qvAPx2fCx/9VTiXcoB3bwVx8oxE6Qy9UEhETBnx/i+QPY7u650prKIUDTUFHG3dmBZ
         So1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835209; x=1711440009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fndo0MEe/uD2EZQF5VsTSnetuecWQ7lAuCXwwSf7lcs=;
        b=iSz3jUtLiEZwMRInOCeUKRVZMeGuxcy5rBKzCXPa945JF36N1wK5slslMZ+XCQvGY5
         U/eUvkBX4s58KqD3W6A5TzGDJscIoZRCv7FhQbexfb65yYCI5iHI0UCbzSgOpe519rKN
         d1K4pd7QNK2fGc9f22NGacbc0SEFRVJ62/L4JoqvgOg5p0nC2Su7t5FVJsuA7qb5RR5E
         7BwBOr/f5oJNWrFHYP2IU5xKCUwTFFhgxYvAT8pS0OLO/YC/wH9Qff4GXug1rj6+HPQM
         6MBFj5Mkdq661Sp8Jd8KP1Sh0X+dgT+sRtNPJknpB32tY4s/wfwgsR7yl94gF+cy1aWQ
         3QXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWI+MbI5x4C2Le8WYWNG1AeQBTfy+uSUqXU6Gr7ppSSzswh9XEVOEwszHnQhHrJRU0F4ifmZ5AFv/tTgL/eQcBq+W1q
X-Gm-Message-State: AOJu0YyqZ4MgzQt9w4pAtlptmAralGqfT64700IRtWRLtwM/Are3Pt6l
	It58nmA9wTVf/KraNJDEdIZu4TFBx4Ykupfqol3VddCzeja21U57
X-Google-Smtp-Source: AGHT+IFZbtU7rOQxkkj6cesJgK7vAzyFAtMiMK+nZ/sLlmWkv8FYDQnCfG7JqFhH5FkYWgLdW+bq5A==
X-Received: by 2002:a05:6a00:cd2:b0:6e7:1cd9:c032 with SMTP id b18-20020a056a000cd200b006e71cd9c032mr2488662pfv.6.1710835208039;
        Tue, 19 Mar 2024 01:00:08 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:00:07 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 09/35] powerpc: Fix stack backtrace termination
Date: Tue, 19 Mar 2024 17:59:00 +1000
Message-ID: <20240319075926.2422707-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The backtrace handler terminates when it sees a NULL caller address,
but the powerpc stack setup does not keep such a NULL caller frame
at the start of the stack.

This happens to work on pseries because the memory at 0 is mapped and
it contains 0 at the location of the return address pointer if it
were a stack frame. But this is fragile, and does not work with powernv
where address 0 contains firmware instructions.

Use the existing dummy frame on stack as the NULL caller, and create a
new frame on stack for the entry code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/cstart64.S | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index e18ae9a22..80baabe8f 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -46,6 +46,21 @@ start:
 	add	r1, r1, r31
 	add	r2, r2, r31
 
+	/* Zero backpointers in initial stack frame so backtrace() stops */
+	li	r0,0
+	std	r0,0(r1)
+	std	r0,16(r1)
+
+	/*
+	 * Create entry frame of 64-bytes, same as the initial frame. A callee
+	 * may use the caller frame to store LR, and backtrace() termination
+	 * looks for return address == NULL, so the initial stack frame can't
+	 * be used to call C or else it could overwrite the zeroed LR save slot
+	 * and break backtrace termination.  This frame would be unnecessary if
+	 * backtrace looked for a zeroed frame address.
+	 */
+	stdu	r1,-64(r1)
+
 	/* save DTB pointer */
 	std	r3, 56(r1)
 
-- 
2.42.0


