Return-Path: <kvm+bounces-30363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D27619B9856
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:21:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92761282F34
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5E41CF2A9;
	Fri,  1 Nov 2024 19:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XIXA/UZg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C981CF29A
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730488878; cv=none; b=IxYIv5Atyl1hrFst5j1qan2VD67NAkO2JLQl3rmwSaF7uYjzX28KgRtNIFLiklyVyDybmA/eOF7zerNg1ZcRarOD1yDWp6+xkob7hCkBgehd9ojT6SpYXHqqmAAGzmxEl5oHaO3/uTIZALgKKdrpzL8ZUMEfBV5pSFyYop9Scgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730488878; c=relaxed/simple;
	bh=gDCwC1SPleUIBwKe9fTtquqbqUFzDDTJZqQXk2CUcQA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=s6Y9uFDk950s9Sk4aTqMO5EDiuQZnno9baeykhIwD094x2kdsy9fenFvkfkLJ5G7WLQf6YXdX1BfEaX2eipR8fkEA18gRIYUqf89JvOxKHWheR2izqR4oz5tYNl8059k81PGaC3zpus+DHApD5VwLSf3QnuTetS+xYdnwkHoz4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XIXA/UZg; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e35199eb2bso45583527b3.3
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730488876; x=1731093676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gRx4ATohdQbBBEdds8jqGttW3H5chvC7bMcPq5abO9s=;
        b=XIXA/UZgiYmi/jxgsuPDVX9x1ek3jrxJCB4306y/LljpzgU4L7LHWCkZ9JWCGWOrTT
         T0AOHo00NGuIdY+pP3rCJt68rnQvKK/mW686qdBywmZa3/6P8sVhUl7ThnURDlgYtf0k
         NI4SUj0BX/Jl9nDg3dqt5mRif+XzMn7FHjj/6g/oEyWK97P1zJ+7zQZueklG1Abryjeh
         G+l4B4uo7tLTypVBB7tmb4PsLIjKkxn5LcbJYRNVHzPcCcSsMtGRxS/a7QNf87Jh5pOL
         93D9jzsQqjAmkX0Ine8t+r7N6SIdleLq77LISMJpP/PvYnCYPIJQUl4/9paONi3D93b/
         O28A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730488876; x=1731093676;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gRx4ATohdQbBBEdds8jqGttW3H5chvC7bMcPq5abO9s=;
        b=vTZcT3YVZjDaZ6IJQxEdCQVsTZY9eukVR39yoxEwGw5h+flSis+T6TFBoiiHQr5Uv5
         VAV4mIMAMXjSqln5pTSH7CiNgQIbQBb9gbl0wqTX+Ur3F68XW+bRQnqT97BdQLQfq8q8
         0yc4e9WbH4SV2rjTe00u+lmFSXjIln0rXPVn1kXcfgBlRueDOzAe/27bi5HO8NCP7XQM
         Hk2p7SxuIOQMixlDWbUutbbETfoYRdhWM/B4r2g5pHv7czXN0PD7VnaoYxjxV0EphRQD
         45zurGi1x/BsXwrrXKJ5DRQ0Tsg8n+5t/zpP/CEhjZevioBZ1efct4q4eG0964oOGmqy
         xOKw==
X-Gm-Message-State: AOJu0Yzi3oq0GG1ZGW2NKDwWd9njYFWWSFPfTlJ4sFnt46A9ci0hgaUL
	aM9gDKOpmum8a6B0PpY5ggHSMDyHIVch5n7MOUNgP9oX7tTJWOEzATJy9mTOnWZMV78jaZmNSXG
	Z2Q==
X-Google-Smtp-Source: AGHT+IHyeXiqfos8eUR1QXSm5Yxh076bg1NHvY90DfQOpetXU7pbsHu/DXBbVvfOG8iUCJwqIfmVk5H37TI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6f8e:b0:6e3:2bc1:da17 with SMTP id
 00721157ae682-6ea64bc93a8mr525467b3.4.1730488875839; Fri, 01 Nov 2024
 12:21:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 12:21:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101192114.1810198-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: nVMX: Fix an SVI update bug with passthrough APIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Markku=20Ahvenj=C3=A4rvi?=" <mankku@gmail.com>, Janne Karhunen <janne.karhunen@gmail.com>, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Defer updating SVI (i.e. the VMCS's highest ISR cache) when L2 is active,
but L1 has not enabled virtual interrupt delivery for L2, as an EOI that
is emulated _by KVM_ in such a case acts on L1's ISR, i.e. vmcs01 needs to
reflect the updated ISR when L1 is next run.

Note, L1's ISR is also effectively L2's ISR in such a setup, but because
virtual interrupt deliver is disable for L2, there's no need to update
SVI in vmcs02, because it will never be used.

Chao Gao (1):
  KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active w/o VID

Sean Christopherson (1):
  KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/lapic.c            | 22 ++++++++++++++++------
 arch/x86/kvm/lapic.h            |  1 +
 arch/x86/kvm/vmx/nested.c       |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 19 ++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  1 +
 arch/x86/kvm/vmx/x86_ops.h      |  2 +-
 7 files changed, 43 insertions(+), 9 deletions(-)


base-commit: e466901b947d529f7b091a3b00b19d2bdee206ee
-- 
2.47.0.163.g1226f6d8fa-goog


