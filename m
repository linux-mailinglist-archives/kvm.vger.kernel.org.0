Return-Path: <kvm+bounces-28250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F78996F4C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:12:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE5831F22695
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 15:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6CE1D271C;
	Wed,  9 Oct 2024 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hefr1fPy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED57519995D
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486300; cv=none; b=ieAFIzO/vivCg81JNmp9U1VzJEaJZi8wqsHXElbYUCjA5WWtoLYk+sz1kI0qmXygSiIP8em3D4ZLAay2J1kKYfe8bhwnbzXgwOrLTE6pGgT/nzXP5z2421rneV0nWKyxTGUgBxjWChsEFb0trba0tnIimx18teP63i09T4t96Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486300; c=relaxed/simple;
	bh=uPUaOv2QrzSaUf4LArS8+PSibvq85NPqivVxaIxcqnY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=raj+qRoU/byntLjeArXvZr8QWZxUBG6vZ7fgKDh3XHrsNDiaR3b+SsVZFyCrWgIdzeYXhiyGuQq6mfSh8P2g51QUC42Ll1c7RfjacDdkJKmBNRzHl7Wif5vEI7pTl4cdKp8Q3cKdw4P7R0mKryY1GG48GJPs5frDYIzg3zqkG4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hefr1fPy; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e29b4f8837so14077267b3.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728486298; x=1729091098; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a8TTqJOaZnfBA+i3DdeHlnHy8Opvxrk5SUeEQ665whA=;
        b=hefr1fPyrNDihae/WRAOV3FfbL2F/7jPh7jJGngO2Vi4WF1EPdyWquMDuWIBX4MXvX
         xtQ8atO52mQIdk+NO/rJNKjxJRzkZ3gUhTd1YHdNgRy8hCbPiadzKfncEFKSOfAK2x73
         24CHiFUmvrxHnyi1XEpoFVQ/Yhz6eEjVfoZgd9PYkeAe3gxVCyTXRl65fczI3wV1JfUS
         f4EYtNRpO+B2cr9ebW+gWQW+EIZm24xBHINCnFJmRQho2FdqL8WavN1M5y4ky15DHr9h
         iaV4GwrLeI0vweAvPYKREbiyZ8aqwxA4uTP5Z++3WSyNDAWhrDHKTZHDbqMTf09/NxuK
         2asg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728486298; x=1729091098;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a8TTqJOaZnfBA+i3DdeHlnHy8Opvxrk5SUeEQ665whA=;
        b=QIu6TPu34F4987xin6dd/8G1SZG4ylp5SvMFBLOcJ1REoR8st+AZ7U/BmV3vzB3LIf
         AkN9ZvRhnYgSJZzHEPaKLErTY9QKnj4Gt+O/7h6zTckLszpyM4oKe9Rqa0rgojzIx6fL
         tEZpwmmWvzMAJA3qeGl7SJAv1k8fOmtJRw1qpN7AY5GZSu5FGYsoBHl7fgYFnG8dr8vy
         aWS9clrkFbZvYPQtZdoWJ56J70ggz8rzFT1uqfarDa5/V8P35pYP4B1bTplecZmj3/TR
         S/qQGyGHHlju7E8Fb1mmAQ87s3eG3OH19H2l5KUWdZBp9g0oWVMpVHmdYwNgRLziQGTn
         0cew==
X-Gm-Message-State: AOJu0YxC+Bt8eHNPHjTilml3IbJP/M9MIsp+QDKEzOU5S2eGAZTlQC6S
	D9t0NmdlyVgFfXFD7U8flFraD49pI3sQ/TVttCPD+B5IJLIn/qEtFNXH4ZHSf6BVWlaQjBK61VU
	9lw==
X-Google-Smtp-Source: AGHT+IGxFiVDW/oEtOCIg0CVNCO6RB2GNcn8OUHtfbGXlgiBNs0NANmOo24ozhMrY1k+G+YEoGSelxcuUgI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2e81:b0:6be:523:af53 with SMTP id
 00721157ae682-6e30dfbaae9mr206247b3.3.1728486297981; Wed, 09 Oct 2024
 08:04:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:04:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009150455.1057573-1-seanjc@google.com>
Subject: [PATCH 0/6] KVM: Fix bugs in vCPUs xarray usage
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>, Sean Christopherson <seanjc@google.com>, 
	Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"

This series stems from Will's observation[*] that kvm_vm_ioctl_create_vcpu()'s
handling of xa_store() failure when inserting into vcpu_array is technically
broken, although in practice it's impossible for xa_store() to fail.

After much back and forth and staring, I realized that commit afb2acb2e3a3
("KVM: Fix vcpu_array[0] races") papered over underlying bugs in
kvm_get_vcpu() and kvm_for_each_vcpu().  The core problem is that KVM
allowed other tasks to see vCPU0 while online_vcpus==0, and thus trying
to gracefully error out of vCPU creation led to use-after-free failures.

So, rather than trying to solve the unsolvable problem for an error path
that should be impossible to hit, fix the underlying issue and ensure that
vcpu_array[0] is accessed if and only if online_vcpus is non-zero.

Patch 3 fixes a race Michal identified when we were trying to figure out
how to handle the xa_store() mess.

Patch 4 reverts afb2acb2e3a3.

Patches 5 and 6 are tangentially related cleanups.

[*] https://lkml.kernel.org/r/20240730155646.1687-1-will%40kernel.org

Sean Christopherson (6):
  KVM: Explicitly verify target vCPU is online in kvm_get_vcpu()
  KVM: Verify there's at least one online vCPU when iterating over all
    vCPUs
  KVM: Grab vcpu->mutex across installing the vCPU's fd and bumping
    online_vcpus
  Revert "KVM: Fix vcpu_array[0] races"
  KVM: Don't BUG() the kernel if xa_insert() fails with -EBUSY
  KVM: Drop hack that "manually" informs lockdep of kvm->lock vs.
    vcpu->mutex

 include/linux/kvm_host.h | 16 ++++++++--
 virt/kvm/kvm_main.c      | 68 ++++++++++++++++++++++++++++++----------
 2 files changed, 65 insertions(+), 19 deletions(-)


base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.47.0.rc0.187.ge670bccf7e-goog


