Return-Path: <kvm+bounces-24565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2478E957C76
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 06:38:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9877BB223A8
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 04:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B67682D94;
	Tue, 20 Aug 2024 04:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eDJDZ4mW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F297043ACB
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 04:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724128691; cv=none; b=a+XpCJWdCvYVHCeF5XL78/8whkZ/z9rzZ2YvG4ePftoISZ2bNVO/DKe0z5qxt2lc2IHLXeIE3J8Izfl69QCxV76EWGWy0e0ACVCq+nolfm99uDn6C6kY3FGex2S48AMFf3oVa3z/oRA8LU/278hjzCS7g39LU5jWhbCrdKopUwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724128691; c=relaxed/simple;
	bh=01z90h6lcHICM5qs1RevhXHV0040bxeRjlAcOfBD4m0=;
	h=Date:Message-Id:Mime-Version:Subject:From:To:Cc:Content-Type; b=f+uYwpY0CrdBDaPfkCASbaDLy2g4JDCxMwTi19poSgocUQ8yiNRBgpR5CIM8FQit0IGDJkc26vb3UjeSh5RmrnZxKVd0ZMlTznTsjaUKAxl71v7RfHRBBpVozrELqyryTYJqBhZ6Q0IUD9vmMSeFRkdJqVwyNXp7S8xN2w5Znko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eDJDZ4mW; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e117634c516so8289651276.0
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 21:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724128689; x=1724733489; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cYmSZG46+1D9koXZ08YLo6C2rK7AA5OHgMKW91U7KRg=;
        b=eDJDZ4mWgy/h2sB5132nwvK/5f7DQgEF9qn1wLf2wOb/yqOuSyjImZlpbd1kTwuPKu
         plOnIj+cL5owkfZo2wNikAUn8cdlCzQjVUC15rumaWrFV90i4kWE1/xvhGKxqCxG3h7m
         E53pf4LgiZrQgTmKLcp7tDGsvZ5YxYI1ue3CqG18mmIYtj6GoC7arbYMbdTfwB/elhPL
         cif31WswgnQrtorOqSX1qDzGO3UfI4V1GJFdquASr52yv6+0WH14dokU7lMA6ahR8+0r
         YJNdeOQlAckkkxqPTRwnIpyt13bDLmLujM/fCGMV5Zj6GrLkbGnpgiN0txMULr8luOWX
         6aPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724128689; x=1724733489;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cYmSZG46+1D9koXZ08YLo6C2rK7AA5OHgMKW91U7KRg=;
        b=E7mAapwiNQ0eO4dGkEW4ig8pS0ZVgLoRVdX4U/yB9BKIs4HyMrwN8133IfwPQ9xUFC
         qmPefK7+GcB86uGeOgGoAU75xLm5ndKzEosQR60Fqd1qM5Rb2NclpczOBQ1Dp0xDUGyf
         xon2aLfWDDOOrAqiMXgu7A+cOkrBVeGwWYnHV7ugzX8z75LtzxWjIdYtcBZr+i97djRY
         FiGxsJTR3KpvSIfM+JiguKSUqDuBiHLJNEsEs6RCc0dnvWiqEcnCNl96DWGQ+65korqn
         1sRL5lbumWYXCacmW+p3Jg6ElvHaqcbR27lPloIu0WvYSO57leExgAvugVm8zwAi6bKa
         7/KQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbcQPCfCMbEbgn0UAQi2U9aV2F0K20RtYZeWsD/8how2LlWv7SPXG0ns+Gd3fHGXZQaU0=@vger.kernel.org
X-Gm-Message-State: AOJu0YySq6svaLf4T3zRC0J1qJ/pRQzg2Y+xYT0Z58embxiZn+pmm7Uf
	qerpNUmhO2euljCe3p5XJSbLFYn3LwTTiva2i9huBNOw4SdABICo1//aof42T5UeXjVX9ikU0ce
	hPXt8BAkx0w==
X-Google-Smtp-Source: AGHT+IF4K1sQIMUkgyn2WKrZd5ulBrkbmjtdrJM4/Bb4XKeEBxffWJCKylJoJKRrv1CwuZjZw0RkEEIpLOyyKg==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:7c18:89e3:3db:64bf])
 (user=suleiman job=sendgmr) by 2002:a25:aad0:0:b0:e0b:ab63:b9c8 with SMTP id
 3f1490d57ef6-e1180fa06d5mr17946276.11.1724128688995; Mon, 19 Aug 2024
 21:38:08 -0700 (PDT)
Date: Tue, 20 Aug 2024 13:35:40 +0900
Message-Id: <20240820043543.837914-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Subject: [PATCH v2 0/3] KVM: x86: Include host suspended time in steal time.
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, 
	Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

This series makes it so that the time that the host is suspended is
included in guests' steal time.

When the host resumes from a suspend, the guest thinks any task
that was running during the suspend ran for a long time, even though
the effective run time was much shorter, which can end up having
negative effects with scheduling. This can be particularly noticeable
if the guest task was RT, as it can end up getting throttled for a
long time.

To mitigate this issue, we include the time that the host was
suspended in steal time, which lets the guest can subtract the
duration from the tasks' runtime.

(v1 was at https://lore.kernel.org/kvm/20240710074410.770409-1-suleiman@google.com/)

v1 -> v2:
- Accumulate suspend time at machine-independent kvm layer and track per-VCPU
  instead of per-VM.
- Document changes.

Suleiman Souhlal (3):
  KVM: Introduce kvm_total_suspend_ns().
  KVM: x86: Include host suspended time in steal time.
  KVM: x86: Document host suspend being included in steal time.

 Documentation/virt/kvm/x86/msr.rst |  6 ++++--
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 | 11 ++++++++++-
 include/linux/kvm_host.h           |  2 ++
 virt/kvm/kvm_main.c                | 13 +++++++++++++
 5 files changed, 30 insertions(+), 3 deletions(-)

-- 
2.46.0.184.g6999bdac58-goog


