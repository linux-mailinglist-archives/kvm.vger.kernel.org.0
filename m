Return-Path: <kvm+bounces-10135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D55B86A06A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:43:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD17CB33C84
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72637524DF;
	Tue, 27 Feb 2024 19:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gpXQSge9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E50751C45
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061896; cv=none; b=oG6KiLP8p4ba0L3vzNdwG1iQe0HVc5/pFBZUcmqSRrdn5y8Q5LxchDruI4LKL0Q0fG5UC5rGIL6/01h8H+rb6u4zrKYx5FM1CU9QX7D5JvRCQ3tl7UtjF+OeBalkRiblD6CnRoq1Hg65rwGL8AwrqlNQMPJM7v6IxZQ5lnxtMcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061896; c=relaxed/simple;
	bh=j8KX1tv3Hvz6e7f+fcz1K93KW8sT/QwCilsZwY114+I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GqS4TMOigG8ZKawC1aCn9ityO1B+GZptzxplupjBZL2tEIl/HEiI6gs/1gDndcoIwzWh2WWkXHdSAQMXmerbxIZqKlspDYTyoeu9fvs0bNHdeTqvy3ikC2i176qD+/Oi4XnlWjAwjzfOg+6k+mMxa/uRZQP3l1Lc2T/wVHBBt0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gpXQSge9; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64b659a9cso7166320276.3
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 11:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709061894; x=1709666694; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eqDAfWfzOe3yEn60Ghh6DXq/NTfhJkyT/Z1pYjZx3eU=;
        b=gpXQSge99fsqylvMrrOgCKN39Usfhqgp3O2VDySTac53BMm9ly8ZsJyFCXCO9GQo1M
         upF5Q6MMdzqHuex9lm6kDLv9QefIaRsXU0PrL/o8yCxprzDT4FJs+GTkh2Sub5raY2j4
         2zHXeDyas6IWo1rO6TvBLEMqqk/cVBZVo/Wr1L9qYGO2kzOk1Tx7x4EWwTfMUq0N+w45
         WIqCaKbv3xqxWbqYXRS69pThGkYYt5lcRIYrXYS5LwVp8znd7utut8cjkpwyJ0UwwVm3
         56LmstAr/8X9HRfKw7pVdtcpN6EDVf5TPsj1FU6abDtXgTJtoTwLVnqODEGRmQ2grVWW
         DUxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709061894; x=1709666694;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eqDAfWfzOe3yEn60Ghh6DXq/NTfhJkyT/Z1pYjZx3eU=;
        b=uLwKOAbxx0V0z3OKXNpWvE49nZTF0CtoK2eEvBKgoMnYklrEAAGMB8h0S3OIV2JGc2
         tFpNCr6NIZevkngGWDeFRQFfKmZ3LhiBaT9aGnqwSly9M8H5I+YPg3ySRRzmsJXURpBw
         vDJ6sn4Gkwbx+l1SyCAY5gwGHDdOv4MFlD22tVlOpGxDAuuK2LOKgQa5er0W+8j2Yv5h
         9L/RWdELsM5ytBL1w468ByzDZxAjk6NRqWgmAx/EmGA+wXJeCkJl+8ulzp9D5MDuDzHr
         PMl1DGKf0b7fjcrLF2rq4j/eF85/3euhmfe15jYYBaU8KilAeAUJMlfRc6Zs6ksYPeLJ
         pBHQ==
X-Gm-Message-State: AOJu0YzzRRYZNNI+AcZR8c/BpDHW4/u+HXJ41cocuumDzJ52pN+u1oe4
	ExL7xlImQ1P4yiRi788pPwOeBA8e64azlQAb5jai8KNz7sgrrWSUeL0JAyxfjYZPsOZfB+qxoXL
	N8A==
X-Google-Smtp-Source: AGHT+IGc4W+ie/uDNYnmYeY3uQdtVNUwLz8rzxkN7qcEc91ZfMlyo9WsIB7WDreONTs2KH+NM30eCFNheiU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18d5:b0:dc2:4ab7:3d89 with SMTP id
 ck21-20020a05690218d500b00dc24ab73d89mr23699ybb.1.1709061894137; Tue, 27 Feb
 2024 11:24:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 11:24:51 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240227192451.3792233-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SVM changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a single series that allows KVM to play nice with systems that have
all ASIDs binned to SEV-ES+ guests, which makes SEV unusuable despite being
enabled.

This is the main source of conflicts between kvm/next and your "allow
customizing VMSA features".  guest_memfd_fixes also has a minor conflict in
kvm_is_vm_type_supported(), but you should already have that pull request for
6.8[1].

There is one more trivial conflict in my "misc" branch, in
kvm_vcpu_ioctl_x86_set_debugregs(), but I am going to hold off one sending a
pull request for that branch until next week.  The main reason is because I
screwed up and forgot to push a pile of commits from my local tree to kvm-x86,
and sending a pull request for ~3 commits, and then another for the remaining
16 or so commits seemed rather silly.  The other reason is that I am hoping we
can avoid that conflict entirely, by adding a common choke point in
kvm_arch_vcpu_ioctl()[2].

[1] https://lore.kernel.org/all/20240223211547.3348606-1-seanjc@google.com
[2] https://lore.kernel.org/all/ZdjL783FazB6V6Cy@google.com

The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:

  Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.9

for you to fetch changes up to fdd58834d132046149699b88a27a0db26829f4fb:

  KVM: SVM: Return -EINVAL instead of -EBUSY on attempt to re-init SEV/SEV-ES (2024-02-06 11:10:12 -0800)

----------------------------------------------------------------
KVM SVM changes for 6.9:

 - Add support for systems that are configured with SEV and SEV-ES+ enabled,
   but have all ASIDs assigned to SEV-ES+ guests, which effectively makes SEV
   unusuable.  Cleanup ASID handling to make supporting this scenario less
   brittle/ugly.

 - Return -EINVAL instead of -EBUSY if userspace attempts to invoke
   KVM_SEV{,ES}_INIT on an SEV+ guest.  The operation is simply invalid, and
   not related to resource contention in any way.

----------------------------------------------------------------
Ashish Kalra (1):
      KVM: SVM: Add support for allowing zero SEV ASIDs

Sean Christopherson (3):
      KVM: SVM: Set sev->asid in sev_asid_new() instead of overloading the return
      KVM: SVM: Use unsigned integers when dealing with ASIDs
      KVM: SVM: Return -EINVAL instead of -EBUSY on attempt to re-init SEV/SEV-ES

 arch/x86/kvm/svm/sev.c | 58 +++++++++++++++++++++++++++++---------------------
 arch/x86/kvm/trace.h   | 10 ++++-----
 2 files changed, 39 insertions(+), 29 deletions(-)

