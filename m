Return-Path: <kvm+bounces-64262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 38FF7C7BDF0
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 23:34:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B0664353BA5
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 22:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC802FFDC9;
	Fri, 21 Nov 2025 22:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lrOrxvaX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40B1296BA4
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 22:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763764489; cv=none; b=Wu4WPuuyuocqtphsfmU3eDQlFWGN3fpFOQvEEmCcsrG/zG79FidDZXseXv2AZBcVdbscZXHfj/6H6rQfqTk18VKSOgdJqG5HmKSAd0pJXXjnecC0zmEGdJUSCpkRtvGAtj7PNKr64/ZTEes3FK4IAYjye94bVQswH5OgLXlJxcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763764489; c=relaxed/simple;
	bh=cTbUnHvDNUozzLON9K5ImnFSh2jwb0d22TxPB4B/u2g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cu4xfnY8bW/HpoRxGlY7DwCgUstI/GFhYSlTSmkwOftUt4NOB5V5Wccz1++t2mvxXXjdS/jURcNxMiPUOkaEMGjPBB1M6tj2YAgIG2IWFHyRPK8qVcs10X7XwuDhUmYo5Y2mVHhWSD/K9iXqf2xFlsDXzHLP9Fg00NsiYiNhLbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lrOrxvaX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3438b1220bcso2946808a91.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763764487; x=1764369287; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vx6+2Xu+cmWD3DR2f6Bb1A/tI6pVySbnlcRSZM/VK3g=;
        b=lrOrxvaXiRkAU/JdAn7xAz5V53AXyJHuEOOj+zEDR9ovOQR8SD8QRhuC639jI8DBQL
         DqfzALNjrRPSlIl9TakH6UMMABySMsVV6vxccT1nULKm+dCTC2LrAJbETSAne0uGUYhu
         wnzaQ8swAafDFmmL6hCdszQvHlkeZJABsQjCPRahwm6WL0SlGljg8NoS0Z9+S/TVbwpG
         NQCshoNJNiYAXoLt8vJ58e1fO+1YJNelhs04VUXIQgL7V8eMxTVlnZ13FovEnsCKmbJv
         E60yeLNtU5zpFGdAbzzYaMhaJuwm3WUXUbC/GloUk3ZI2aWLudNvRWQ9PBDQx9l+x+c9
         941g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763764487; x=1764369287;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vx6+2Xu+cmWD3DR2f6Bb1A/tI6pVySbnlcRSZM/VK3g=;
        b=RKMqAV+sNdSsTo2MLqE99+K53t1/QLufyLPDKKvkWhF+xOOUxsO1tfjG/XNEF7CSd8
         8QKfwAduTcDPC9jQ65D3/RUBc/Hd7xtCc+pDKztQsrbto9EJ70JiYIvFlbdU7NjPmhNy
         lb36oAJiv7PonGsBekASwSm5OSJIYq0ZI5ZuOHoJuKrU+UMO4ummb+JSh4pSh01XoTVl
         P217e1LJRoVA0uK06HyaPRumF6qx7X0Eogzt9jC8GWj0eb7vWG5geET+OYEHFmvq9O71
         8haH84ObTn5YkWGD8vOAPwuXm9zhR/uoN0fh+gTHoPr+EBy+tGeYRLpj1UZcwHBe7vIP
         ETfQ==
X-Gm-Message-State: AOJu0Yy/23Ny6KFhaGfN9xp4O0swgQ09qROdpKtS+GAhXhYMjoqm0aEQ
	YhS4ICDXXa1nW0a/HEE1qNxkEosWafqI3kWKLT6Ph+3vuQUFwJw7yUaKJZhTled2EN6xzKgj5t/
	l6nuxoQ==
X-Google-Smtp-Source: AGHT+IF0ziTgjKCokZh6HDF3l3yHXzPKDTh9XJ1a2MRcjADOXhNWY94EjWtiVgfLreC1hBZZ3XSrtCqOAEI=
X-Received: from pjbgg6.prod.google.com ([2002:a17:90b:a06:b0:32d:69b3:b7b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c04:b0:32e:c6b6:956b
 with SMTP id 98e67ed59e1d1-34733e48e4fmr4232285a91.4.1763764487117; Fri, 21
 Nov 2025 14:34:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 14:34:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121223444.355422-1-seanjc@google.com>
Subject: [PATCH v3 0/5] KVM: nVMX: Mark APIC page dirty on VM-Exit
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Fred Griffoul <fgriffo@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Extended version of Fred's patch to mark the APIC access page dirty on
VM-Exit (KVM already marks it dirty when it's unmapped).

v3:
 - Fix a benign memslots bug in __kvm_vcpu_map().
 - Mark vmcs12 pages dirty if and only if they're mapped (out-of-band).
 - Don't mark the APIC access page dirty when deliver nested posted IRQ.

v2: https://lore.kernel.org/all/20250910085156.1419090-1-griffoul@gmail.com

Fred Griffoul (1):
  KVM: nVMX: Mark APIC access page dirty when syncing vmcs12 pages

Sean Christopherson (4):
  KVM: Use vCPU specific memslots in __kvm_vcpu_map()
  KVM: x86: Mark vmcs12 pages as dirty if and only if they're mapped
  KVM: nVMX: Precisely mark vAPIC and PID maps dirty when delivering
    nested PI
  KVM: VMX: Move nested_mark_vmcs12_pages_dirty() to vmx.c, and rename

 arch/x86/kvm/vmx/nested.c | 25 ++-----------------------
 arch/x86/kvm/vmx/vmx.c    | 11 ++++++++++-
 include/linux/kvm_host.h  |  9 ++++++++-
 virt/kvm/kvm_main.c       |  2 +-
 4 files changed, 21 insertions(+), 26 deletions(-)


base-commit: 115d5de2eef32ac5cd488404b44b38789362dbe6
-- 
2.52.0.rc2.455.g230fcf2819-goog


