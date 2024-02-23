Return-Path: <kvm+bounces-9589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C94F4861E9E
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 22:17:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84467288CD2
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB45149398;
	Fri, 23 Feb 2024 21:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ztmZdLIw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D891474C0
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 21:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708723036; cv=none; b=LFa/Vg2APs2cvxjL5yx/jjB6tcD68Mho14fgS2bByLobpw2u+8iFqe3JJDp/4OYkgY6Gwm+LdgD3nhWFg84IiMUEArYCZUljx1ttTUWgHYCIgsG1cZopnFzMbRKezOUeAE7I7cn4zoswoNGS+hYalzL+1v2h8Dxo1IG9AN7i2uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708723036; c=relaxed/simple;
	bh=LxisIv95tuvftO3gGiQktt0Eq+u0gN9VsyqvSkXAJe4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=V/uXhp4tXkhmIghP2Me9OmU8EyYBNdAmLJgFf9SC8DGjzfWmcvS7Zko7a53XTc1zbApaZFbV969xcmvXvfzNgIva30Bw0Ph3kVWNqSm6k1LA4nSWxvMEr3Smqp/oI+7rNtLDtyAi+mnmqBs9X22wj/mwacG2dxvr3vQbwHngxHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ztmZdLIw; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-607c9677a91so22466167b3.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 13:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708723033; x=1709327833; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2XDFyxdBjQUJNu4zRViJQEh+44N1On/mabiEHEUEPoU=;
        b=ztmZdLIwg8YfpJMxhAUzfJZEnwUFV3y9sE0uhfEM8JcMQDcCq9rbEoElyjEXx8N3BR
         l4BaSZX+enW8V+Xxr2mkAGKAQxy/4K4lWJ+XwQaPWx+z7ynEIsfYlwJdClc12Iy62fdX
         s1FVvnmmmuFLrmtpASan9HvF7bi8HCJEsy8KLUezdEcATeWdjiQompLMyD/pPKVyxfWB
         RWmuX0U1dvp/4OzpjVphNbbmbsIBsKlNgtQev0W81GnAwWpHr+ttgdTyuGTAlaQr4mlC
         IT/wxzDTSuZSY3L6B+tkNHqqouEC2yedGCAFDMnz5vmJs9QReBJjscuU7HBOvBPHDMYB
         df/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708723033; x=1709327833;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2XDFyxdBjQUJNu4zRViJQEh+44N1On/mabiEHEUEPoU=;
        b=fWMk8LaVqt3ijMHqBR8dh9ibkWxZV060KXJgnoSq4oCjfY5KIIi64O4AUTFhuby1s4
         WTzqkcWB57ElmNjPT9Eo5RcpcChL/lnk3rpbxRl/Cot4P4u8s91qhUvlvPscAIUANt0z
         jY1kgPni1FSv1YpRBXtag1KfAxj0pYIVrGsDXvw+PiHUvE5y0E1QVgkiquhXya80B5r/
         bJMLx/LXCTMiGTcYm+fQnHJj6ixxhEW4gYroA1newenkFnPmWdjLck8E19KmhRm/Mu6u
         pQaeh5lB3v2JC4Deyi+SHpkWpyQ4Ud5S9jXAjfbuum8Jm8E3841w3D5ejwOMabI1k9/C
         RCgg==
X-Gm-Message-State: AOJu0YzLmsITW1D4gIqAHyZenbVdbwwrPm6RLd2q2P7Tc1R3lLy2e0WG
	LFve+MGHCld+CGiya9ylUFdJToeahHQfaN0taVCgQjJmyTZRSzZ8zJD6S/9OUESESVjCsM1X2dO
	g1Q==
X-Google-Smtp-Source: AGHT+IE34KxuSlwnjSNuZi+Gwb2PGg40d6LuI8hIXoHS9JKYn1aVmeC4NARWu4Wm4ebK2/qBz6VielbkT6E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:914b:0:b0:608:b3e0:3edd with SMTP id
 i72-20020a81914b000000b00608b3e03eddmr232170ywg.3.1708723032945; Fri, 23 Feb
 2024 13:17:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 13:16:23 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223211621.3348855-3-seanjc@google.com>
Subject: [GIT PULL] x86/kvm: Clean up KVM's guest/host async #PF ABI, for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

An early(ish) pull request for 6.9 (not 6.8!) to clean up KVM's async #PF
guest/host ABI.  Due to a goof many years ago, the structure shared between
the guest and host was expanded to 68 bytes, not the intended 64 bytes (to
fit in a cache line).

Rather than document the goof, just drop the problematic 4 bytes from the
ABI as KVM-the-host never actually used them.

The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:

  Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-asyncpf_abi-6.9

for you to fetch changes up to df01f0a1165c35e95b5f52c7ba25c19020352ff9:

  KVM: x86: Improve documentation of MSR_KVM_ASYNC_PF_EN (2024-02-06 10:59:52 -0800)

----------------------------------------------------------------
Guest-side KVM async #PF ABI cleanup for 6.9

Delete kvm_vcpu_pv_apf_data.enabled to fix a goof in KVM's async #PF ABI where
the enabled field pushes the size of "struct kvm_vcpu_pv_apf_data" from 64 to
68 bytes, i.e. beyond a single cache line.

The enabled field is purely a guest-side flag that Linux-as-a-guest uses to
track whether or not the guest has enabled async #PF support.  The actual flag
that is passed to the host, i.e. to KVM proper, is a single bit in a synthetic
MSR, MSR_KVM_ASYNC_PF_EN, i.e. is in a location completely unrelated to the
shared kvm_vcpu_pv_apf_data structure.

Simply drop the the field and use a dedicated guest-side per-CPU variable to
fix the ABI, as opposed to fixing the documentation to match reality.  KVM has
never consumed kvm_vcpu_pv_apf_data.enabled, so the odds of the ABI change
breaking anything are extremely low.

----------------------------------------------------------------
Xiaoyao Li (2):
      x86/kvm: Use separate percpu variable to track the enabling of asyncpf
      KVM: x86: Improve documentation of MSR_KVM_ASYNC_PF_EN

 Documentation/virt/kvm/x86/msr.rst   | 19 +++++++++----------
 arch/x86/include/uapi/asm/kvm_para.h |  1 -
 arch/x86/kernel/kvm.c                | 11 ++++++-----
 3 files changed, 15 insertions(+), 16 deletions(-)

