Return-Path: <kvm+bounces-9422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E539485FDD2
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:14:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 223F61C23913
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 751BA157E9F;
	Thu, 22 Feb 2024 16:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4MvuR8OH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446EC157E80
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618314; cv=none; b=p0UTpDaQZBScaZ+o/nZ42psNqnJtkS88HJskwhyLvratqleEs91J+hJUvZY1Aieg8TvhXtadoUOJstJLOH7KHiNl7bvYpI5D4VcNFDTXHQtIDWk/+1mBnNLehpi1ewCXzRQqxipVfaqdklCwqcptoLaOLfSXNb8trVswJ6ABWpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618314; c=relaxed/simple;
	bh=X5CTKYo58HHafOhpr0rnGZtDOO9drroKYxobKreBkos=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XCOgTsgDzlxuWHijVxxtpxO5O6Cbk5zJZNMiw6in3jQ6JyQ3iZcWetXuLtr9LGEeLZJCi3M2gyExDAWP9q7u7TqgolNen0ceIMbiFNFuPabgXIDKLH+F/V6/ZfosVvgZrGW9Q2tp3HLqjTcmykwFdNkNLToSDRvKiuCH2v8szf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4MvuR8OH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6083fbe9923so37382447b3.1
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618312; x=1709223112; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x7q06n6+Cfi5piogEKrJk5NdgWbh3+ffeAar7OiRx3s=;
        b=4MvuR8OHiYTMZi3QT11Oax3MwbvSrF1xCp73+IYs0Enoa0bJFD7/IaMwiyYVhI8c0Q
         NdWzM7Rm4IineEkwZfFqLgtakNfK0gGdnDb9yXOBJpyfYxUrzdEyBGNkmDm6GGnv9kzN
         Oxc9s4UKzQppILIitpGp8H8muider93DD6TGU35co5qAb6hsZ8rUQ7Reaj9NWlFRrfVH
         6PPXnCudNUOuH2qMcIpCLO4RLIK1qhfqiKMJQ65u5YDhxxRiaTeHb+TjjucpAfkOieK7
         Pjh2F7zPZzvjaL9fNJPATldOvcdGUTo0rL5ns8nAKnbsFQGdQuMFrr2HNruosXeh1PQ/
         gGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618312; x=1709223112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x7q06n6+Cfi5piogEKrJk5NdgWbh3+ffeAar7OiRx3s=;
        b=r8Z0iFu0QTqpBZlfvRi8diTm0JT35KHOc2Wr1iaMg1jijEqqxXmQYS6ONHa3N4Iooz
         svT+1JjDCSJvilOjmjyj91aMF6TUrkeC4tbgyHtZz6ExzT2yJ4gBOlu1nWrkhBmNcInv
         bRyA3aTK027A+P/um4OQHitJmY6MY566049qVMNpOUBTr60U+XMcHcXe4uY+Gfx/E3Qg
         stXsYQfKCnILexSbKjlbMj63II2qBaZpIv1/1c5cuXSkZSi2xF4kYFDZ64TNiNwT1fdK
         5GRWtdTTuvtGERIKEFsfgAy5v7uf+SqfbvfUjtzWOjzYqfz5Sgb8tv0Al1FD2+7ssH2p
         eg6g==
X-Gm-Message-State: AOJu0YztBe6VzQhQWjW3PUR99anbJlD7nAy9N6Nar/RLIYzThW1fDXay
	0QInopM0OLlT1UCEbAEYgqo159FNhYanJBlFTZRJLQ1hk2D9XN5fW4zvtZtzxdpvYRbt2q/xliY
	0fi49wHB5a+qKAgUVdpJJndltOXjHx/RXz7qeT4j4P4Ro5ZWX8FeW0Q2EbeAS4f8j9jSLpKktg4
	KKKmdmS3SQhq2Y/TLyJTzEJkw=
X-Google-Smtp-Source: AGHT+IHMwP7mtHKT127TxYqntr8FVuJ7TVNM66KxywWU4Ngx0R+m7wXDu6r4saiVjzNmhTgu/W91QxWrOg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:f101:0:b0:608:9758:e8b with SMTP id
 h1-20020a81f101000000b0060897580e8bmr613552ywm.8.1708618312398; Thu, 22 Feb
 2024 08:11:52 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:47 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-27-tabba@google.com>
Subject: [RFC PATCH v1 26/26] KVM: arm64: Enable private memory kconfig for arm64
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Now that the infrastructure is in place for arm64 to support
guest private memory, enable it in the arm64 kernel
configuration.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 6c3c8ca73e7f..559eb9d34447 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -40,6 +40,8 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select XARRAY_MULTI
+	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_GENERIC_PRIVATE_MEM_MAPPABLE
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.44.0.rc1.240.g4c46232300-goog


