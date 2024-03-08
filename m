Return-Path: <kvm+bounces-11405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA81876D41
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:39:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAE4728241C
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 22:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A88E604C2;
	Fri,  8 Mar 2024 22:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gvom0Mrx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD1E5B5BE
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 22:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709937442; cv=none; b=VPrEAfcGEz/kkTXZxjme3dg2GEqG4fWRKw4xt6q2KRtq8uzLV5kzdlO6cufDgx1/S123eTfe72BAQbh5shMWfFSe7BZttmAyjXVbwaL6qp1RL4saCAwjyx6QM1S+bNs9OYbRPGFWB46SpBhwtY1NDcv24pG9G05xpSYPvCXlkBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709937442; c=relaxed/simple;
	bh=oTLsXBJGTvQNP+F8nz36ySwkn2KtuRMCfbbJ8DJjo7c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FV+CvEw3RKW7CCF3MKQrAeTx5K58nj8+lcwQg62b2AMF6d5ENNXAddwrSv576iQtsQ55bTb0FO2NcdXxfINpGprRLToZYaLbRiC21OGgakiQJ56Q9qW3oJiFd+ZiJi1T28Stve12+BKYOdh8MD675ryhE4X9Ifovl/sRjYhYnIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gvom0Mrx; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8bdadc79cso1018655a12.2
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 14:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709937440; x=1710542240; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lWMLAd4YRkj0/Z7k3uFBUD+qopQGspHfKAITmgx51bs=;
        b=gvom0Mrx7D2v/gHRkxW41HKHJn18AdVlfnQ707wmy595uVHAJEq3k8OhU42iJTtN4T
         RMDSEQn7DnNGRToe5aqyiKwAOwjAUyxbkxPe58CoGFhX+4f2rrdyImjb7uxVoZ6uncxZ
         lUXIBUrkoXLKGAnoWqZw7077vCg9ddY0HvkdaP5dYXOSsPD49AI7V5SDBcJNHR420ZBe
         jxOGZcrxrTpAJEpTCvh5L4CnRsRZMFxRhLffQceMg7RsRKYxwCfUjYPgx3uk0Wg8zB6V
         HP+T5fl4fmgVbfmIdNBF0GznlIY9lUQL6RdS44WY0vMyxaFZJtLQj1RvH9sqcX6MnteX
         VDTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709937440; x=1710542240;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lWMLAd4YRkj0/Z7k3uFBUD+qopQGspHfKAITmgx51bs=;
        b=bpD8oj+lbgh5RB9D75QScvAwsL5pos5p99OKlIhKjbLnUW7h5gO4Y+/aMXDKFoAWRW
         KeM1kNmv+z4fQvzcnyexJzr2zOe6YZ7x8cr1AtVYWMMPoKyg8Dkufgv86xlsd+PY42cJ
         C6adxOU3TqX3O1b1KpNN30wIeEQl3r77rXMdiHyRr+/pGuYVDTuAH5CX3/NX6z0pyj9M
         XOXfE7h644AeRB/m9DCBa5nfcyZp2IpBTuREBrNqpSljl0xLOo3A8gcPwD4ztu8DJW1m
         4TKhInA3HXOpgbXIn1YsbnN/HUBYOYX7TVcwoK4e34wOuamlseiZ8oia7Cdt0iAX+A/i
         o2Bg==
X-Gm-Message-State: AOJu0Yz9fXosdCQUFb80rMD4+VIwxaZjbhI9swUc60ZF0u3qnxlY5Az8
	ZmSw0rsacG/k5OsedGup0qDQtGPvwSqIo7MgsooUypRIx1OjoPT8m/QFSGpP6PcfUCRer6XK67U
	UqA==
X-Google-Smtp-Source: AGHT+IHTEuDAeIruT3PfeRAeByE5iiR+I9sZhT3PrPc6Dx/SCkZhPZ13wb0W6yoxMOnZsUHNLvIP6VFn9b8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:b0b:0:b0:5dc:555a:c9d1 with SMTP id
 11-20020a630b0b000000b005dc555ac9d1mr811pgl.3.1709937440665; Fri, 08 Mar 2024
 14:37:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 14:37:00 -0800
In-Reply-To: <20240308223702.1350851-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240308223702.1350851-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240308223702.1350851-8-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: VMX changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A small series for Dongli to cleanup the passthrough MSR bitmap code, and a
handful of one-off changes.

The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:

  Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.9

for you to fetch changes up to 259720c37d51aae21f70060ef96e1f1b08df0652:

  KVM: VMX: Combine "check" and "get" APIs for passthrough MSR lookups (2024-02-27 12:29:46 -0800)

----------------------------------------------------------------
KVM VMX changes for 6.9:

 - Fix a bug where KVM would report stale/bogus exit qualification information
   when exiting to userspace due to an unexpected VM-Exit while the CPU was
   vectoring an exception.

 - Add a VMX flag in /proc/cpuinfo to report 5-level EPT support.

 - Clean up the logic for massaging the passthrough MSR bitmaps when userspace
   changes its MSR filter.

----------------------------------------------------------------
Chao Gao (1):
      KVM: VMX: Report up-to-date exit qualification to userspace

Dongli Zhang (2):
      KVM: VMX: fix comment to add LBR to passthrough MSRs
      KVM: VMX: return early if msr_bitmap is not supported

Sean Christopherson (2):
      x86/cpu: Add a VMX flag to enumerate 5-level EPT support to userspace
      KVM: VMX: Combine "check" and "get" APIs for passthrough MSR lookups

 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/kernel/cpu/feat_ctl.c     |  2 ++
 arch/x86/kvm/vmx/vmx.c             | 72 ++++++++++++++++----------------------
 3 files changed, 34 insertions(+), 41 deletions(-)

