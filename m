Return-Path: <kvm+bounces-53482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D80B12674
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B8E6AE0C18
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F18725F799;
	Fri, 25 Jul 2025 22:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UQI/986K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5103925A645
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481243; cv=none; b=I6wSPXqB8wPnSL63ul/cgsQh/3gra/ib69ENuYp8PY9B5l/LTPibWhz7tUoDzJRP5aqsUUSqoB6HEsmikNBz4xpYqdEbtHKIPWv0hmohz5i7UaXrO335/rxMF9eQ6eJpKA+wt0OcIcnqmA1plQRJh2tJ0mOQgnW43aq7U9p3t6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481243; c=relaxed/simple;
	bh=jBeHSRrbfiCPqnsth1j93uEVW+m4bKblVbZo6/VXE+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aEZ8FuacucScNUPI2nZl/e6PuDqBVFiErm4Cl7yBmT+j6pwQBgnDPOgqMUp+6Ee0BM/eVj+VnXyTuw2Qr7L6ug7qCSsCKmbRV1xhQVllt4Txkgc7Tisb+Ic5/MQsJ1iGCpt+f2lDLxYsd8y5V5skPj9nHsDRBy33gFpW/PLlZGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UQI/986K; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2fcbd76b61so3367950a12.3
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481241; x=1754086041; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PwJz4ymHNTqE6inrZIr6bGmI9Pv6s5NhWYS0oHIopVI=;
        b=UQI/986KkzySIqUFNHoFF3kkopWavNW7O3SHC0gxj9d6t8V87ojvE7PK4X+BTXeo0N
         82UiHc9vzHJPUTWIJORZZjern2lWwA5XB8UnpT1aLQm0tdnrX5In+0KZVnXgBYB3plO3
         yHUM35RqKVQK9Nzh5+MmWw6ET+a+zxnr8RgB50ORz9y87zYNQJ52+d2GWwPAG2qZBfId
         akT6gfVzjWEsRI8H5gL4VdSKmN6GqJDoAveobHPuq+Fvtgx7+xH03d7oRNc5qmKebMxq
         iGJOAmfIZsVomHJN0a8uhB91T8A3M84zjSct7ng4i38mgetKiEV5ZYnb2H6iwYhfrbjX
         MKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481241; x=1754086041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PwJz4ymHNTqE6inrZIr6bGmI9Pv6s5NhWYS0oHIopVI=;
        b=IKGICtyvaIugt8KCkuh35g4xEUVweVkyKFl4f0eU2ErP1JWtnMpoQMzfJ9aP1GVnj/
         TyvLLXC5gItYOxpKPSVVwl5RHmOdqbbmrB3l1NT9tEi2zHFpMqy0XAGgabPQPV2tURu7
         N+vV7nrJ04caP6SavAuFbq6PJz8pB2hNHO/XzsOBcf9U4VfiyxUNhAjteI9o3D4yFP6x
         nokn6y17ssEuPiFb1UQUvXfhKIlOg1OynsfzJpt6WypyZfBfeHqKsiwuJVRKkKdCC+MR
         0UpPAujaEBqOy6uKoTvonp1NxVuP3EIN37ldbN9zQJMipdDW1bovHIHRMWH2esHvZgsP
         POmQ==
X-Gm-Message-State: AOJu0Yyj3z77SJ89x3cd9VSahEht6CXY6FGLzuSLjbA9dGsOq1NV3JpT
	yh+ORKME4zI7zmiwwgjWwr3gB2kW37YouVXPrtcCANktmrUkdBdePgHbGx+JefRaKQXpZIYipZx
	udsJglA==
X-Google-Smtp-Source: AGHT+IHSC0u4PoZgaEdKSN3v8CxTBiEbUfAQzpTz2XoNDRZ78lNta8R4Q0QHNwo42nWXnUXABWMwNNiLh3g=
X-Received: from pgc20.prod.google.com ([2002:a05:6a02:2f94:b0:b2c:4702:db0e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1590:b0:235:2cd8:6cb6
 with SMTP id adf61e73a8af0-23d70213425mr5233958637.34.1753481241628; Fri, 25
 Jul 2025 15:07:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:03 -0700
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-4-seanjc@google.com>
Subject: [GIT PULL] KVM: Generic changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A few one-off changes that didn't have a better home :-)

The following changes since commit 28224ef02b56fceee2c161fe2a49a0bb197e44f5:

  KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities (2025-06-20 14:20:20 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.17

for you to fetch changes up to 87d4fbf4a387f207d6906806ef6bf5c8eb289bd7:

  KVM: guest_memfd: Remove redundant kvm_gmem_getattr implementation (2025-06-25 13:42:33 -0700)

----------------------------------------------------------------
KVM generic changes for 6.17

 - Add a tracepoint for KVM_SET_MEMORY_ATTRIBUTES to help debug issues related
   to private <=> shared memory conversions.

 - Drop guest_memfd's .getattr() implementation as the VFS layer will call
   generic_fillattr() if inode_operations.getattr is NULL.

----------------------------------------------------------------
Liam Merwick (2):
      KVM: Add trace_kvm_vm_set_mem_attributes()
      KVM: fix typo in kvm_vm_set_mem_attributes() comment

Shivank Garg (1):
      KVM: guest_memfd: Remove redundant kvm_gmem_getattr implementation

 include/trace/events/kvm.h | 27 +++++++++++++++++++++++++++
 virt/kvm/guest_memfd.c     | 11 -----------
 virt/kvm/kvm_main.c        |  4 +++-
 3 files changed, 30 insertions(+), 12 deletions(-)

