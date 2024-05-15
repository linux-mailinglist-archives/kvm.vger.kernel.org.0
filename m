Return-Path: <kvm+bounces-17482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4FFF8C6F42
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:39:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00E3B1C21455
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68CCB15B0FE;
	Wed, 15 May 2024 23:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HP/aTBT0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2589E15B0F8
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 23:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715816331; cv=none; b=fxKAhCtkax+Tk2sHTSraxou6AQKXi/Eit/jMWdjEfVVsZdNXDQ+ADvEfRw0h1xJl9ky7hjDq8gn0WLYeN/i2EpOB6oFCNmYTG1xn9fTiH69A3OMGtBH8x1cmkiCtfCBkW0yxNDmUqfvlNkb1gDpdQHDxNq5gbb5DVVVJ6FRnUgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715816331; c=relaxed/simple;
	bh=LrhcmnqbvXlfMxqRj+JfkKFzkgxTODJrJww+lA0v+g4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m7ELN87zgf1M9OtqOznMUZsUqWBQEt+qzzhsCwUqcpqaojt4/qT9YTo2VIv+fivpjbeZoZ5bw/dtlqW9WEa4gcv+IHOfzY+Sw63Nbl9jIleDSy4L0WuY+aCw7TswopGV3n33ETlU9KmFGAGdzm67J+5bdLeYNjTbOIPKlUlO52k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HP/aTBT0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6202fd268c1so133088767b3.2
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 16:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715816329; x=1716421129; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VxHwWqhZCDTeqX7ABJ/MC4TG+j2XaIlpsAn6kujEg3E=;
        b=HP/aTBT0twuuunpvSUm4g29kdoJhlpJn4qwqZJazpM8YixKzIZGbpU5zss7Qh7YhmX
         349hGBC3SZviCnfhRQvd6QtEbUcQmdvQP86V1evRytQKFrtE90JJQUiYD5M+4SoeRJUV
         IAImqe0k2jho1aF20iqF+LlbG8FZ8jyJzhF1iNDVq/ntYwnP3tC25P7iujVX8WElLqlP
         FyA63iS4zcy6iQlGU0kqD1BAx8zJeLd/orvy6rT1mgkVdsdPwsmVuuKX44IEoBLZMi9z
         ZteDPCbQ9bGNDl/8pQ3A3Eu7taXFDTwbjBINcB09mSlbDvuJ4KVNMw8AgXLMcI+aB6nw
         9Z5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715816329; x=1716421129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VxHwWqhZCDTeqX7ABJ/MC4TG+j2XaIlpsAn6kujEg3E=;
        b=gqzz6l69Ng5yzD+rZHttClU0tntP9RkW9re5ENlVvilb8ot3c6Rse7udboMD8qLtkQ
         mug9wIQWrURv7nOs6G0ILLHWaJSWTsRO1+7pw0UyFCwksRkXfAyIZix3851yI/esArVc
         z0mYxeCxo7ndQhEtklOizFfjEzIh2nEWMzPwopZfIwbSK8X+FvznsTmHv37eNnRT+J6m
         uhE1o84O8bop5QLIoFE/OCyNGy4s8qB+RBRzGSh17cLLtw89iefk7KO9Tdi6Wap3BIT0
         2lkTkLDZDOuMwBPggB/RgpnjDebkSlfYcX2ukHmNOaGnjwBE5TGk+T9K4Q7RWfBy9R3e
         kGtg==
X-Forwarded-Encrypted: i=1; AJvYcCWlfeljIRGQZINYYVQ8Pipg4bvdwJVVSb8QwGPz2YVVPQ8lG6oqUrMrHgAoKSaJ8W7zzD/k0W9/MN8tOWa+RmKkClIC
X-Gm-Message-State: AOJu0YwKM5JqkOtze9UMXc8nszkMsh7vJuyWIbWRUZKwQGjp3oumjAcC
	qcqQ5fhDTm296mjRiqaWuQpmAn9oP9mZP6gmpm5R2Jnnxe24uhTwWgYbBDiJGlYYTvE94Ijm+Q9
	hiQ==
X-Google-Smtp-Source: AGHT+IG1VymRwYPhDDRuWF6qTtiMKj/CRUAbL/zk5uaIGds/1vBcmZIwr7OftjRa+r7/Zg3Iis8ka/uKU8g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6202:b0:61a:d355:168f with SMTP id
 00721157ae682-622affe5533mr45697717b3.5.1715816329189; Wed, 15 May 2024
 16:38:49 -0700 (PDT)
Date: Wed, 15 May 2024 16:38:47 -0700
In-Reply-To: <20240507154459.3950778-8-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240507154459.3950778-1-pbonzini@redhat.com> <20240507154459.3950778-8-pbonzini@redhat.com>
Message-ID: <ZkVHh49Hn8gB3_9o@google.com>
Subject: Re: [PATCH 7/7] KVM: VMX: Introduce test mode related to EPT
 violation VE
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, May 07, 2024, Paolo Bonzini wrote:
> @@ -5200,6 +5215,9 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  	if (is_invalid_opcode(intr_info))
>  		return handle_ud(vcpu);
>  
> +	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
> +		return -EIO;

I've hit this three times now when running KVM-Unit-Tests (I'm pretty sure it's
the EPT test, unsurprisingly).  And unless I screwed up my testing, I verified it
still fires with Isaku's fix[*], though I'm suddenly having problems repro'ing.

I'll update tomorrow as to whether I botched my testing of Isaku's fix, or if
there's another bug lurking.

https://lore.kernel.org/all/20240515173209.GD168153@ls.amr.corp.intel.com

  ------------[ cut here ]------------
  WARNING: CPU: 6 PID: 68167 at arch/x86/kvm/vmx/vmx.c:5217 handle_exception_nmi+0xd4/0x5b0 [kvm_intel]
  Modules linked in: kvm_intel kvm vfat fat dummy bridge stp llc spidev cdc_ncm cdc_eem cdc_ether usbnet mii xhci_pci xhci_hcd ehci_pci ehci_hcd gq(O) sha3_generic
  CPU: 6 PID: 68167 Comm: qemu Tainted: G S         O       6.9.0-smp--a3fee713d124-sigh #308
  Hardware name: Google Interlaken/interlaken, BIOS 0.20231025.0-0 10/25/2023
  RIP: 0010:handle_exception_nmi+0xd4/0x5b0 [kvm_intel]
  Code: 03 00 80 75 4e 48 89 df be 07 00 00 00 e8 24 79 e7 ff b8 01 00 00 00 eb bd 48 8b 0b b8 fb ff ff ff 80 b9 11 9f 00 00 00 75 ac <0f> 0b 48 8b 3b 66 c7 87 11 9f 00 00 01 01 be 01 03 00 00 e8 f4 66
  RSP: 0018:ff201f9afeebfb38 EFLAGS: 00010246
  RAX: 00000000fffffffb RBX: ff201f5bea710000 RCX: ff43efc142e18000
  RDX: 4813020000000002 RSI: 0000000000000000 RDI: ff201f5bea710000
  RBP: ff201f9afeebfb70 R08: 0000000000000001 R09: 0000000000000000
  R10: 0000000000000000 R11: ffffffffc0a3cd40 R12: 0000000080000300
  R13: 0000000000000000 R14: 0000000080000314 R15: 0000000080000314
  FS:  00007f65328006c0(0000) GS:ff201f993df00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 00000040b5712002 CR4: 0000000000773ef0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  PKRU: 55555554
  Call Trace:
   <TASK>
   vmx_handle_exit+0x565/0x7e0 [kvm_intel]
   vcpu_run+0x188b/0x22b0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x358/0x680 [kvm]
   kvm_vcpu_ioctl+0x4ca/0x5b0 [kvm]
   __se_sys_ioctl+0x7b/0xd0
   __x64_sys_ioctl+0x21/0x30
   x64_sys_call+0x15ac/0x2e40
   do_syscall_64+0x85/0x160
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7f653422bfbb
   </TASK>
  irq event stamp: 0
  hardirqs last  enabled at (0): [<0000000000000000>] 0x0
  hardirqs last disabled at (0): [<ffffffff85101206>] copy_process+0x366/0x13b0
  softirqs last  enabled at (0): [<ffffffff85101206>] copy_process+0x366/0x13b0
  softirqs last disabled at (0): [<0000000000000000>] 0x0
  ---[ end trace 0000000000000000 ]---
 

