Return-Path: <kvm+bounces-5953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CB81829185
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:39:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51292288F5C
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B3D23D5;
	Wed, 10 Jan 2024 00:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B66GLCv0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24464186F
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 00:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5f8ffd9fb8aso35942717b3.3
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 16:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704847180; x=1705451980; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LHQh+E98QwgdFrnlGd6RgJxgR303fsUw0Anefm352AA=;
        b=B66GLCv08sgT4r1YY+xCUUulNTKi6Bx3G8J2aZOBePu4guo6AZ5/x+YWrs+aujWY6v
         rcMYYWIcxz1lKVAZuQva0ABdJtKlt6N1OX50Ex7LV3/esSz3PTYk2aJEOEfozGuVWK8D
         og5pt3pnx5OienWVvqcCHLl9nAvOnDmuj6PHttqbTezsx8SdLTo29AISem5GueIZqatN
         ZCG3jgy+4rGfKz+56ihU6SNDamIssxswKKF8dCqBz6IFT4tEKLEcPVz3AGVwJ2/EetLM
         h0oFyZe4TVP663WvbeajSWvzBTK+QsFvmsgc9Pn+eryRUJdPOInypUR5NVOSbS7uKpU/
         fmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704847180; x=1705451980;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LHQh+E98QwgdFrnlGd6RgJxgR303fsUw0Anefm352AA=;
        b=GZrjjqnpvPPMuFXX8dW0NGdGLtOvzTHYJ8gUChCiVDqmpfAnJidTtb3XjmfVVRtde+
         8qSTlFeZ2WoI4I4IYH/dJ/AGCB8x9+UVEYKcNramZpWcwZlPIwYhgih7QY0HFHJ+ODRN
         9AMWeYuu67HN9basJRGkbulCZLRavYYOKF627FM+TDdG+DH71DwSoH05LDtE/oC6BTTp
         /t5tp41xQr6AfUUOUwIlSJjmbK5/oAt64jJY+EdlZDEVlMVjtvm0I/NYY/tGI1kMxJfd
         SCJloRsURYlzXwCoJ9+NXGpZjdksZ2BVH5cymMA9d16+1pGjzvgxc2919Ve4/aJsJEM/
         zR5g==
X-Gm-Message-State: AOJu0YzFAQhs9Yc3Uce5pM5HK+zLyYUuF6jxd3ni51ceAkef5mkZl+pp
	VdbD0mDxL7kHHnKOy7oAYMdDCDAQCO+nDOelWw==
X-Google-Smtp-Source: AGHT+IHP62CliFkA96b/wsoXBHQfk8j/9CsO0CFacwbCORasfGjPKUyyyxuM77uw7yuAmCJ/BeVTJxjwd6o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3387:b0:5e6:bcea:df68 with SMTP id
 fl7-20020a05690c338700b005e6bceadf68mr168367ywb.8.1704847180253; Tue, 09 Jan
 2024 16:39:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 16:39:34 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110003938.490206-1-seanjc@google.com>
Subject: [PATCH 0/4] KVM: Clean up "preempted in-kernel" logic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Provide a dedicated helper to query if a *different* vCPU was preempted
in-kernel.  x86's VMX is an oddball and can only check if the vCPU is in
kernel (versus userspace) if the vCPU is loaded on the current pCPU.

The existing kvm_arch_vcpu_in_kernel() "works", but it's an ugly mess as
KVM x86 is forced to check kvm_get_running_vcpu() to effectively undo the
multiplexing.

Note, I was sorely tempted to eliminate kvm_arch_dy_has_pending_interrupt()
and bury that logic in VMX code, but I ultimately decided to keep it as an
arch hook as it's entirely plausible that some other architecture can do
cross-vCPU IRQ checks, and if KVM is going to have the (somewhat dubious
IMO) logic, it's probably best to keep it in common code.

Sean Christopherson (4):
  KVM: Add dedicated arch hook for querying if vCPU was preempted
    in-kernel
  KVM: x86: Rely solely on preempted_in_kernel flag for directed yield
  KVM: x86: Clean up directed yield API for "has pending interrupt"
  KVM: Add a comment explaining the directed yield pending interrupt
    logic

 arch/x86/kvm/x86.c       | 16 +++++++---------
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 22 ++++++++++++++++++++--
 3 files changed, 28 insertions(+), 11 deletions(-)


base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
-- 
2.43.0.472.g3155946c3a-goog


