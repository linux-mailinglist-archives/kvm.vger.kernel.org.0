Return-Path: <kvm+bounces-18461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A0D8D5610
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 01:12:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AEA01F27511
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9927A18413D;
	Thu, 30 May 2024 23:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mb9IFab9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A39C183991
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 23:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717110768; cv=none; b=ESq8Tz71Zcw7e/2hqwWu8Ml7uuhzfaVUiPVvizNN/i+uBD6utjbdxTu2A9m4UdyKzXHa1FJ6Yi+0KEAnBJuqN90knukZt9b7B6c8yLyi/iaZj5ddw4iW99EFy65qG3pF8D0DaHBAD/pi0aUz4EeYzxtPqcTzlCOgCvEq0JLI5no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717110768; c=relaxed/simple;
	bh=eTliIFmIq5hD6o87LUn9o7uoz31PWHrz5z33kKfUKVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t14Zjhonuk/2EFgmbQm3il9kPUXilfZ0017l7lzt+rv3ya57ILBOFZnhRPS9pumMqBm5H/yT41NgQEXCV9uhvPndkzLjwQadizIZJEMi7JHqLIjIaTk/nAWt4cCm0U9k5AHY5bnxg5GoggibVG5/ix49z0NfWpPiKSRhpuR7WNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mb9IFab9; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df78b56f6caso2196117276.2
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 16:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717110766; x=1717715566; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4ujQILWXT37aY3kE457ngW3RW7Zg+FC2HbFYHJC4pvU=;
        b=Mb9IFab9AbS7uPGRhsGuyWeIM2h975b5GA4RLtTqQyW62Fe2XkrI1v9tfxcfjm5PN1
         UNs4CQqax3Ipr9l47lxRCibKuSZtzbH1j8CZasFYgCr8NwImBmkRiB3SSMTo3W+tUHDH
         lQGp7thJIWMItWVWuMrP4VH7pIjW4vFFkXE7EY0iJYHhAYdZH1IRGsIVttV2S0uvPGbH
         VgazKCrggw+PXMvFy5LSEWS6x1VMvUr9HhFDmJvjCoTWZ8Hs0Jprj0EKvM6P4U1nsmUK
         eKDbjZvjPTJpZM6PMkwcWeXenw8oYxJ5LTEzdbxlEUNK1pNxWM9E0HseEV/OITDDh0Ly
         FQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717110766; x=1717715566;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ujQILWXT37aY3kE457ngW3RW7Zg+FC2HbFYHJC4pvU=;
        b=kaOJ7dyGws2VRw+PdCd2e1v2v80DXx+yP3Zg2kDhdjVklMrxySQ3ObyCHBt4PoUV6A
         15pnWP6jXNv6EDJ/m1t5NjQOjmNZjO265o25X01ZQZUSXSs/uGfE7xXmYWkrPOF2HRJ8
         KCaDX12+lFB+9/6lYZ9+rVQnbbfhp/XYXkUybtczuat2BZnMbSEp/JdUPXr5np68ihhI
         l5zHwHXTw9kaCcgIHryr+g3sfYCnMSoBKXUOI5eKfyq7EMojTcn77kbA+AZHCw1oitxo
         TR8TQPq52kXyL6PG14xq5XdrU9mXZKeOjNR4/nNHRy0hWK1wTkrAt49Ai4H1EOCbhYzx
         +zyw==
X-Forwarded-Encrypted: i=1; AJvYcCXv+Yg2T7gE8CEft8nWCuq3NX6xgtiNr0IXGIUErHB02yqspoMVf4+1A7u/vjrFofB6M4IzDQp6+A4Lqc2lZf1qsPZf
X-Gm-Message-State: AOJu0Yxo4ZRAnEgwQthjBCiBwlMQKWPzaIAJBKMwHCp8P7B4vo0kuuWC
	KxRBpxMLlhdOQjVBynhvMP7h2RuaMiGu4cZLag7K2Tq6eXwJjkkSzJF2DmRkXI2LHiudsMXr3re
	9Xg==
X-Google-Smtp-Source: AGHT+IEAQHQsziEnFHzzDoTXb1hDyQWDXePK8y3omtZyZP05+3DME7KShTXce2KWXPCtCEuE7AfCdcVqpzc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1003:b0:df7:62ec:c517 with SMTP id
 3f1490d57ef6-dfa73dba365mr10840276.11.1717110766469; Thu, 30 May 2024
 16:12:46 -0700 (PDT)
Date: Thu, 30 May 2024 16:12:44 -0700
In-Reply-To: <f2952ae37a2bdaf3eb53858e54e6cc4986c62528.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <Zjz7bRcIpe8nL0Gs@google.com> <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
 <Zj1Ty6bqbwst4u_N@google.com> <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>
 <20240509235522.GA480079@ls.amr.corp.intel.com> <Zj4phpnqYNoNTVeP@google.com>
 <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com> <Zle29YsDN5Hff7Lo@google.com>
 <f2952ae37a2bdaf3eb53858e54e6cc4986c62528.camel@intel.com>
Message-ID: <ZliUecH-I1EhN7Ke@google.com>
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend specific
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	Bo Chen <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 30, 2024, Kai Huang wrote:
> On Wed, 2024-05-29 at 16:15 -0700, Sean Christopherson wrote:
> > In the unlikely event there is a legitimate reason for max_vcpus_per_td being
> > less than KVM's minimum, then we can update KVM's minimum as needed.  But AFAICT,
> > that's purely theoretical at this point, i.e. this is all much ado about nothing.
> 
> I am afraid we already have a legitimate case: TD partitioning.  Isaku
> told me the 'max_vcpus_per_td' is lowed to 512 for the modules with TD
> partitioning supported.  And again this is static, i.e., doesn't require
> TD partitioning to be opt-in to low to 512.

So what's Intel's plan for use cases that creates TDs with >512 vCPUs?

> So AFAICT this isn't a theoretical thing now.
> 
> Also, I want to say I was wrong about "MAX_VCPUS" in the TD_PARAMS is part
> of attestation.  It is not.  TDREPORT dosen't include the "MAX_VCPUS", and
> it is not involved in the calculation of the measurement of the guest.
> 
> Given "MAX_VCPUS" is not part of attestation, I think there's no need to
> allow user to change kvm->max_vcpus by enabling KVM_ENABLE_CAP ioctl() for
> KVM_CAP_MAX_VCPUS.

Sure, but KVM would still need to advertise the reduced value for KVM_CAP_MAX_VCPUS
when queried via KVM_CHECK_EXTENSION.  And userspace needs to be conditioned to
do a VM-scoped check, not a system-scoped check.

> So we could just once for all adjust kvm->max_vcpus for TDX in the
> tdx_vm_init() for TDX guest:
> 
> 	kvm->max_vcpus = min(kvm->max_vcpus, tdx_info->max_vcpus_per_td);
> 
> AFAICT no other change is needed.
> 
> And in KVM_TDX_VM_INIT (where TDH.MNG.INIT is done) we can just use kvm-
> >max_vcpus to fill the "MAX_VCPUS" in TD_PARAMS.

