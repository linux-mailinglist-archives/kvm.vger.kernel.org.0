Return-Path: <kvm+bounces-23151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C099464A7
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:51:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02D4B28304D
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE54413A403;
	Fri,  2 Aug 2024 20:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tbEXVM5M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB78139587
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631817; cv=none; b=cOumjstcWQwg/KQy/0rE/+kK8vHt4Z4NWF0RJmeJ8QGayRc2q3eWTEO3uSS+xWKpoMzzDqFsOu3tT/n1/E2Met+ytqxS5DjtfHUtxzZpWHXQumziN8mbp5laKgfF6Kxi/ZaTMi6AGQBM52OwuCIkz2rWd1m2o7NJXsCQ4o9VCO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631817; c=relaxed/simple;
	bh=96WKGVZv6MYMzFgE5HIqk4A3cYSg0BZ1Uq2YbSu01Vc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=slb/ElnhNpIkoovKZy0DB5+UT3RAbbzgAwpys8WJmq06oFO8khpYReSF//exlSBDnOOLdRRJrIafVR4POy8DLA5jQNToRK8J5Rs6Tu62yB51+fJbtcF6GWqKs4HJQHXMBT0n7KeEnY8++T5zk2JcYQR0rHHJ1wNvAT2vXytloaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tbEXVM5M; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70e923f6632so8366310b3a.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631815; x=1723236615; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9TDEuE7b7M7Fc+GA7/BL6fAQx5gD/oVWr+JWhTN6LC8=;
        b=tbEXVM5MUJ/l0SizyJmWvJysjPUAHEPogxkJjnLn39aznWnN3dbfn2lwwC145tQrkL
         EDIu4yyEyGZk/Fm8XUXlqpoiieN1jl05x/u2YxdBWD5VEOVOmstxTET7XvaJhFfyP+KJ
         nJ0LRJToFlNK8k5Yu2orl1MQ+FATmQLR64uhyo7B2D4Mhci8fy7A1HQI5Mj8+fGq1gAU
         hk+GBYAQLwrTjb+6O4cs6qkXtbax7a5aF0xZ9uPM8neRSARc/cAm1zskEuEFCyKDTmN9
         nA69N14E9U2WWp643we01/D0yckIarwS5jCu+Vviza39hfKZeTNl8p1iboVnW9yliKK4
         Iqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631815; x=1723236615;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9TDEuE7b7M7Fc+GA7/BL6fAQx5gD/oVWr+JWhTN6LC8=;
        b=IAk6BUU+yyffmOBw6ZYHLb3GR8QXViJkLXjeg3C8NZSwfcshtgnWlY+ATKTH7gNeTa
         /H7ZwSXozaQgwnJLMjJBFK77isNH9P8oX76HOc1tVtDqhviHlaT0zWFbWwBOiiyy1JQ1
         gOTMv+IasUDVYfAd0Q88GmDfmYaPGMA/X9qqhMaXusLiG9o7geGOgVCdhQ6eQZYvKhq7
         YbsISHBQcbPA4sdM2hGF0EPeDnwIQogMw0mAvAYpV78lsuhOp7IW66jVhmORhLxvMAIq
         vqQxVb+/KanLhGL14g98QuLkKbImrgH9vwckoucP3TtrTwY60t2/UjBqmTTVD6FYpvtI
         +MXg==
X-Gm-Message-State: AOJu0Yzbrwh6AHXehyrpIog82mBQzEoepZrw4E44Q+8G+dCcyUIIFJtD
	ArfpmZE8wxr/YR/AP7zPqvJ13f3nCF4uPn/WxVMzDdJnkgeZyaoaM66gCs8gBdgiiG66Ihpux7z
	mSg==
X-Google-Smtp-Source: AGHT+IGmstI5tuapD/d9fVDrQq8mrfrk57GkjBrOBNxVboWhlaf2L+9JkUsv0iGblKu/0wbgzPE1ESYXn7U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:914c:b0:710:4d3a:6bc9 with SMTP id
 d2e1a72fcca58-7106d04604dmr86509b3a.3.1722631815035; Fri, 02 Aug 2024
 13:50:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:50:02 -0700
In-Reply-To: <20240802205003.353672-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802205003.353672-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802205003.353672-6-seanjc@google.com>
Subject: [PATCH 5/6] KVM: Disallow all flags for KVM-internal memslots
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Disallow all flags for KVM-internal memslots as all existing flags require
some amount of userspace interaction to have any meaning.  This will allow
moving the flags checking from __kvm_set_memory_region() to
kvm_vm_ioctl_set_memory_region() without creating a hole where a KVM bug
could silently succeed and create a bogus memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 42ec817d6a7e..84fcb20e3e1c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2104,6 +2104,9 @@ int kvm_set_internal_memslot(struct kvm *kvm,
 	if (WARN_ON_ONCE(mem->slot < KVM_USER_MEM_SLOTS))
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(mem->flags))
+		return -EINVAL;
+
 	return  kvm_set_memory_region(kvm, mem);
 }
 EXPORT_SYMBOL_GPL(kvm_set_internal_memslot);
-- 
2.46.0.rc2.264.g509ed76dc8-goog


