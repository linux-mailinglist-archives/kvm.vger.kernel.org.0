Return-Path: <kvm+bounces-36394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B1D3A1A739
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 413E87A1C86
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F8B212D96;
	Thu, 23 Jan 2025 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a+3HyyGs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8B820E707
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737646851; cv=none; b=tjuPpjgddo3ZPyhGnWlXrzxUkRzGEfH80wCYaCw1gBhV58htdGtJIb+oqU/Bvw/huQWRFWoArCyk3PsTv2m8MGppIZzM4I/h/VNQzk/A6FnjrUCXWrdUaX5P0+5DKuQFE6nwrCYoJBc9ImFpSrBrmaFRr5Bk5apq7AKmSla86Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737646851; c=relaxed/simple;
	bh=co12U4X74JFoJuj8UJexv33PQ8XOCDqtcVm4ziC/hxE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JhLBVU+5v6OCNY7Yfnnmi3dM9x3AjCK/t6Dddbr92wTDQIaIOchDyHMySPPg6t26jws9q+qVXnRvS4rF0arnLMQa+EaxteOK5Rnq5C7pGkvAqDtMmlCFvvROQ5xBdJ1qvhLMl+WzapKZpzVPt7GxACjkl5fhf6nn0HvvAuTUx+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a+3HyyGs; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef728e36d5so2200112a91.3
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 07:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737646849; x=1738251649; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hXJfuH1Qw8fQdfq9xBbI4GJEjCv9MkfOuPmdQOeNFmY=;
        b=a+3HyyGs+MmQ/66RBv6bezbidAZegnaesOQt8r5NWYLr30grQmJ2p81vXepj/EzJOa
         xhspg9EwAJ/gxfNvfs3hzmWxwIYgZ5SscKlgHmCco8ZYQEtV54OBjsbeOgANu3Ep6Sue
         pkrDTumZnECCiICr8XbYUF+Ml9cGzdm0t3c7kBuyqbb9H8XmkfTXoo5e3UwPKvx0Qicf
         tMaz9iHHIbcIgX1uiHXnL0H0RjLmkEIKNVqRUQ5fdtERkSD+xQwKL9S+jry6sLREeZo6
         c/XDyLiT3XfT3l/a/Ltm02hP+q0G08JBxaDdsFZZpOpcCsNR6YlmfI0JnDBhDBYh469v
         qjGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737646849; x=1738251649;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hXJfuH1Qw8fQdfq9xBbI4GJEjCv9MkfOuPmdQOeNFmY=;
        b=C2OXjZWD1JP2R47eHZQTJ20uvtIB+EA8Velwq3A6VkL9vUEh8LuL7KpcX6DZPxTlHc
         pyiQsLeWSn8MKQ4/R1FaJdjbR8mXN8X+1o8nVcKquUnctEZzpLrSK9o1BiRwJVnDieQW
         ouN/VFCfpp+RSY0DgxETAgkazh6xCrh87lNgyqKRDUCMbVWt44EB1rhzRnP+zbrZBR0b
         STpZCqNPumio/UcAa/kYhVte7M2OcGjdtjrhzhXn0ua2WhDO7gCksfoU1bz7ByOzj79U
         ESRP6pRVmoWFCc8A1DTNMSXGx/fbSGDvdGnbw+B0XXjnUIL6rx2DOLQOtbY3oQtOBYTp
         jxew==
X-Gm-Message-State: AOJu0YzeKyEAyCzE1ATB+XBiUjhwGLDm+A0iYTcGp2x9zzkQpe5yZ/LO
	gh1FE+I+6soC0kt3H1bffhij9ts5xVUR1GGfc7PO39jMRPN+oYY0f33bq7shPK2cPJFqqMifD+e
	FhA==
X-Google-Smtp-Source: AGHT+IHDfufRTFFSBNFFDtj7SPFrh2iVBfRVpm/m3xqs6cUojcuumRSViHLchBbosCu7SEDhXUGAfMV4l+I=
X-Received: from pfbjc40.prod.google.com ([2002:a05:6a00:6ca8:b0:728:e945:d2c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:32a2:b0:1e1:afd3:bbfc
 with SMTP id adf61e73a8af0-1eb214600b9mr44773260637.3.1737646848849; Thu, 23
 Jan 2025 07:40:48 -0800 (PST)
Date: Thu, 23 Jan 2025 07:40:47 -0800
In-Reply-To: <679258d4.050a0220.2eae65.000a.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <679258d4.050a0220.2eae65.000a.GAE@google.com>
Message-ID: <Z5Ji_5-ZXFavCMLN@google.com>
Subject: Re: [syzbot] [kvm?] WARNING: suspicious RCU usage in kvm_vcpu_gfn_to_memslot
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 23, 2025, syzbot wrote:
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x226/0x340 kernel/locking/lockdep.c:6845
>  __kvm_memslots include/linux/kvm_host.h:1036 [inline]
>  kvm_vcpu_memslots include/linux/kvm_host.h:1050 [inline]
>  kvm_vcpu_gfn_to_memslot+0x429/0x4c0 virt/kvm/kvm_main.c:2554
>  kvm_vcpu_write_guest_page virt/kvm/kvm_main.c:3238 [inline]
>  kvm_vcpu_write_guest+0x7c/0x130 virt/kvm/kvm_main.c:3274
>  kvm_xen_write_hypercall_page+0x2ff/0x5f0 arch/x86/kvm/xen.c:1299
>  kvm_set_msr_common+0x150/0x3da0 arch/x86/kvm/x86.c:3751
>  vmx_set_msr+0x15da/0x2790 arch/x86/kvm/vmx/vmx.c:2487
>  __kvm_set_msr arch/x86/kvm/x86.c:1877 [inline]

The Xen hypercall page MSR is configured to be MSR_IA32_XSS, which results in KVM's
write of XSS during vCPU creation to do bad things.  I'll post a path to restrict
the Xen MSR to the unofficial virtualization-defined range, and cross my fingers
that doing so won't break userspace.  There are myriad things that can go wrong if
KVM effectively lets userspace redirect any MSR write.

>  kvm_vcpu_reset+0xbea/0x1740 arch/x86/kvm/x86.c:12456
>  kvm_arch_vcpu_create+0x8dc/0xa80 arch/x86/kvm/x86.c:12305
>  kvm_vm_ioctl_create_vcpu+0x3d6/0xa00 virt/kvm/kvm_main.c:4106
>  kvm_vm_ioctl+0x7e2/0xd30 virt/kvm/kvm_main.c:5019
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:906 [inline]
>  __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f

