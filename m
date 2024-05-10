Return-Path: <kvm+bounces-17235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E5568C2DB4
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 01:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFD73B23C3A
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897CF1791ED;
	Fri, 10 May 2024 23:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jYK5wXfj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ADE176FC5
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 23:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715385063; cv=none; b=KfCFBUVGkWfKDeMTKFUFJNT4xGYdo0ONrAvjRPZwxy2WJ5/jsKlie6Lds1WMTtoL+jZxz0o+W7qQkw+FguFnbl0kMvS1q/79LARfRLB4b3bzuwhtr1vjwgC47HpbNRh9unN9YnckNIvavUOQ1tL+Ff2Qa9scGVFHeJvEbGRs4Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715385063; c=relaxed/simple;
	bh=nZEycZxtPiuAGf4oyhutoh+tYkTaBS+4qMYqttTiSIg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Eo+48JmAo//xTMz2mNyMS+KACPhhPg47DP5jvD5Ug6oovCKbcK+bo7/XV8lpqj/2tEpVHYeOb6w0Um9mJC8n5EfDXfevlsYTXUsLtuSG37shVRuUMHQrDjS1aFfG6y6/1PyfK6YrKrJlmWsGXhN+/sIcFysgivMBG0mF9V6MM2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jYK5wXfj; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61bea0c36bbso49086517b3.2
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 16:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715385060; x=1715989860; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rhXcmv1k83wDK+no5/X9uHny7rFjKrEKCxmTCk9+VLo=;
        b=jYK5wXfjshJMoOJrznIpUeIs3eFxQgy5Yalhzb2Iu7KwMAYYFHyBMoIDJkMt6Ln7++
         pNL7FuO7RTOs7CtDZ5hEca4BPPtcfzLAurmUuXYhHc2ngqRqe4DRv77m5equf998yagq
         A1tIWaUpaM5Sf/7SHTwADZufMu6vIOSjQ/CRAqpF8NNaQqyv/EJe4uk2Ce2MrrVtEyoV
         ZJC0YQP1X71YICH61ohWLOgzQ8HyWgoTW2jq3Gg1c1fb9G1GzYexykQgpQoJKJWKgy1j
         0dWghP9ln6cFbZx62Q7JypSYYjtzsNX35X4OjWey6cxCKW9ZsmbOPkMgL0X6mG5Fjg5H
         WP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715385060; x=1715989860;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rhXcmv1k83wDK+no5/X9uHny7rFjKrEKCxmTCk9+VLo=;
        b=bdX2/tJxM0YmvDUKOwuaETflIdCUtH3zMNTBTWiVzWX0EO2o8aHvISf25WM/v5KUt1
         G5e17fQ0aS7QHBwxMhkLiMQhajp5I4qCUcJZZZpZBfWijgxICWZUbAiIFNDislwnaUEj
         grb/ZgF6IBWrqZIwiPq63Ow/fnqqWIeJd0Wu0Lj/9QkFRWjwnthTzXp+xtij77dgbHEU
         FJ+YAjqKfV4Vh5fZui7iXIsR8yjROQAH2FuzUojCgY50opYK1z3yy0lUUcbH/F87Jj9R
         rM4znht4Vb1PkHFlxATukCeimUAGTiYiApZDzPi71Wq+qcbpFUPTKn+J9Zh+UcfFdGBt
         L0jQ==
X-Gm-Message-State: AOJu0YwuMWTgH7b/Kc7e+MxqMv81LG7fCFdD+SQ2MMHzsXBMCJ5R0FgB
	robsvVZVdML64XAtE5iImydzV9RL0XOGl9p2mW8DzrjvsW+PN0yMbtDdfn8eRu/5keXaV1/te8M
	0Fw==
X-Google-Smtp-Source: AGHT+IEB5DdN7OcsbBnLBO0w7krT5Fe7YWRSuCZCXfMKAhOTMKUqsl39LcxB438afJbzYl7osWEkN7/7wH4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:b96:b0:61b:791a:9850 with SMTP id
 00721157ae682-622b0168adfmr10514427b3.9.1715385060579; Fri, 10 May 2024
 16:51:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 May 2024 16:50:46 -0700
In-Reply-To: <20240510235055.2811352-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510235055.2811352-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510235055.2811352-2-seanjc@google.com>
Subject: [GIT PULL] KVM: Common changes for 6.10
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Nothing too exciting, a few cleanups and a fix for GUEST_MEMFD docs.

The following changes since commit fec50db7033ea478773b159e0e2efb135270e3b7=
:

  Linux 6.9-rc3 (2024-04-07 13:22:46 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.10

for you to fetch changes up to 2098acaf24455698c149b27f0347eb4ddc6d2058:

  KVM: fix documentation for KVM_CREATE_GUEST_MEMFD (2024-05-03 15:11:23 -0=
700)

----------------------------------------------------------------
KVM cleanups for 6.10:

 - Misc cleanups extracted from the "exit on missing userspace mapping" ser=
ies,
   which has been put on hold in anticipation of a "KVM Userfault" approach=
,
   which should provide a superset of functionality.

 - Remove kvm_make_all_cpus_request_except(), which got added to hack aroun=
d an
   AVIC bug, and then became dead code when a more robust fix came along.

 - Fix a goof in the KVM_CREATE_GUEST_MEMFD documentation.

----------------------------------------------------------------
Anish Moorthy (3):
      KVM: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
      KVM: Add function comments for __kvm_read/write_guest_page()
      KVM: Simplify error handling in __gfn_to_pfn_memslot()

Carlos L=C3=B3pez (1):
      KVM: fix documentation for KVM_CREATE_GUEST_MEMFD

Venkatesh Srinivas (1):
      KVM: Remove kvm_make_all_cpus_request_except()

 Documentation/virt/kvm/api.rst |  2 +-
 include/linux/kvm_host.h       |  2 --
 virt/kvm/kvm_main.c            | 59 +++++++++++++++++---------------------=
----
 3 files changed, 25 insertions(+), 38 deletions(-)

