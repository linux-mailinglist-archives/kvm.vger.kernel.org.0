Return-Path: <kvm+bounces-22364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB15093DB39
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 01:53:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73E92B232C9
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 23:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA47154BEC;
	Fri, 26 Jul 2024 23:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lalj5fIk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA5614F13E
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037962; cv=none; b=ku2quFmkJlXsdnFMerszXZMFbv/MYyN3RWNXNLC12WimHXO+KhFBUBC6RiPuBeNXOvqSGbblIECK0aXwaBsloojsERzGxe7rt4IGdmczejeDNE+a5nrDHwV+tOUHqvhQf+kPksMg1jURablVYEVgcktWocOg0AqaEjhHkTHSP4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037962; c=relaxed/simple;
	bh=24lki3QCeS0kH+gNN4dUIYpp1e6lnIRlAVL0zCm0YAQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lY+l24ty+ri/n2npPts7mm2EldRhyQU17mbPeqY2sDUngIrOYARXwGTOzmZlIoxpcPo/DvGDficSBUlexRQdzx+giesOnn6NcjIRwU26+h1yc5A6d3aZRb01Ex4WtXu/WR4jrB4lKW58gT5KkFaEltWbjpqmy1GuUL0YncWpwqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lalj5fIk; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc53227f21so12110565ad.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037960; x=1722642760; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=B44llYCZd4EZ9BiHApjJ5QQ8CK6GbkfpTxw4rYmbmqk=;
        b=Lalj5fIkwkGl2wXKHBt/CgDFS8mvX4OcFzml7HM0bQkTKswl8h/F2c8ROsBEnbuF8t
         cc/UsIXS9HUwR2l+Yhgpt895QAZLEr4FoD0rd8c35vYgQW2LqCb8VFg6hdnWuVF7yaCH
         gIV0Wsj82oxWUmm7/A5SUCotOYbOdFUusmUlAeVXn68NxViv33V1PiEvD2onaGs8pu8F
         C4+6jmvCNll/9jT5RJNTT+WWcDG0zYyfqYYVdz8LPdL2bhfhoXUtSa2adOn+2yXnUqnu
         3rYp+/5nVJBw/h5jVu+WyDZIXeBdp5vvJW0MpRVO/w89vdts0QkELqlXoKT2G15bjFpr
         mNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037960; x=1722642760;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B44llYCZd4EZ9BiHApjJ5QQ8CK6GbkfpTxw4rYmbmqk=;
        b=hXJUQcJTaboI6dLN+QIBAwqNsvxgj8c9z74s3LD1nNtd0qQM/k5XV27ojpXi+iL6QI
         /wQ5c/YYCfJd7ZCno8a0rmZZuwH0DHIZQqj/KkxAY9McnUK98KfXC/aSkkdRumgyKGvo
         5t7PrMrVYxATUATVDKPk5gEYAqNb8jfVdTIB/eEJwP6vHwcQBuqaJpx3+0cTgDa5llUm
         QOeoTpigFtVubxyPNgJrbdA5abWJAZwTCtWNH/eM+GAfoGjhypWUDfJHhwGKMvWM726p
         wmAVpJF1Yz242p5bmqmus3wxRe6FJXcmGgLe3zJCmNDULfxqAYI5vsPXsK99A2VucbIi
         sETQ==
X-Gm-Message-State: AOJu0YzqPITbNJF1bDvLP+APDmP+txHIXw1pOhWcfzh9SzDiKBsw3Y/X
	t4l5ZTXhaHg1kzGXrWyQpcocsbJ6XSHmlTRow31WpWbpJAYCk56VSy4K1qORTLOAdJdEJ2NWRy4
	GSg==
X-Google-Smtp-Source: AGHT+IEjG0ZQEVlDvyCmqtjyibvaIBPxkBHQDdDjj94pZYYC/xb/lJ2iSbTktb4rvu/gOGNYLlpIc1q2Vcw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2b0e:b0:1fd:7097:af5c with SMTP id
 d9443c01a7336-1ff048d8505mr410065ad.11.1722037959655; Fri, 26 Jul 2024
 16:52:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:10 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-2-seanjc@google.com>
Subject: [PATCH v12 01/84] KVM: arm64: Release pfn, i.e. put page, if copying
 MTE tags hits ZONE_DEVICE
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Put the page reference acquired by gfn_to_pfn_prot() if
kvm_vm_ioctl_mte_copy_tags() runs into ZONE_DEVICE memory.  KVM's less-
than-stellar heuristics for dealing with pfn-mapped memory means that KVM
can get a page reference to ZONE_DEVICE memory.

Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/guest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 11098eb7eb44..e1f0ff08836a 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1059,6 +1059,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 		page = pfn_to_online_page(pfn);
 		if (!page) {
 			/* Reject ZONE_DEVICE memory */
+			kvm_release_pfn_clean(pfn);
 			ret = -EFAULT;
 			goto out;
 		}
-- 
2.46.0.rc1.232.g9752f9e123-goog


