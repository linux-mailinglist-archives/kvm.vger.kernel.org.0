Return-Path: <kvm+bounces-18958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA20A8FD9E1
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 00:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68D8B285E2E
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 22:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D4D1607AD;
	Wed,  5 Jun 2024 22:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rf3cBrKU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0411913A897
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 22:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717626694; cv=none; b=UW5ZOthlOzoVVc/+GNKvK3gqlgPHI6SM8m9xUbFtNwdgfw9ll/paxXpVmhjnylILS72PuS2wqf3B8b2ej9qtQNr/b2KeVJ9G/U75NLNQr7khjMZ9V5bZaDQ263h5qw/5BjnI3W8A1KsRTbss7/br/B4ejpZdQ9YN6Cjw+WLYJkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717626694; c=relaxed/simple;
	bh=/6CqWma6yCmunaVe/VZAglDNyyVOQMTGuxZqHkw86J0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bbYgA86hYwRAm76SME+28wzTFu4fY1dtl8Sgdr9EMB8i6zq6Dfcx1XPH7fWnaPobsR1oZ5trHkK7fOC109YAxhyP/R8FckcFhOcNmaXnf4BSbtE/mq+TmZEOd1/FEcZJoDzqTOlAoivR7ZQBfjcz0pTzUnwf+WreSmvLENQIRrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rf3cBrKU; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c9b5e3dd53so223375a12.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 15:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717626692; x=1718231492; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1DZi9jcUr8m8Wz2R3C8u3tmFWBJGE9sNTkhVXMRZct8=;
        b=Rf3cBrKUOGI0yF5MsnZLQka+oH2o40/cbT5OtomYtKk5lPArRZrqH+vX4X7Qq8PKnQ
         asHWxkkEetSR7Fo9axY6bY3RIDSt8w7G3MpDiKYObhQKusBZ1lUxRpr9jjG5+E2RCb+G
         kVI8+kIy/+254b7LdYSzZ6aaZaf3U9GGaDGr7KLd/ILKc/joxifCn2ZNa2RogGpT7U92
         D9hG7qyM34Rt/YIzaXdZQZ46MQDG+hrw2JBqb3DW/dt7zwdrT54AOTR4A/dLRL/USgn7
         O/W+Bod6ruphBeB+x5pkroIMbRvJQ1qSLCTa8YiDHvi7qzlWJz8HO08HEfdqEX0l2qJ2
         somw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717626692; x=1718231492;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1DZi9jcUr8m8Wz2R3C8u3tmFWBJGE9sNTkhVXMRZct8=;
        b=EoKUfkbwKsXgzVMy2gfTF/WOxjAwr4Oc2s3jJ+fWqSkwio22pOyYkU/MraGUExEOVD
         AmMaORyw4lnfqZ1tL+yc47OlmK2Dm14FPv2tbslBi+R5ZYt9V/iSWAT5nJD8XZRCXysP
         Gz+Y2diM/QJDB0oB3pWyvrRTrZFB4E+n86nyF958RyStR5/huoUUMVuHbx+hvlAcylhL
         pKU5pl9pj09+5MAqKmVyIlcOupwR6/WzgDgcQvjSd/OEwgIJvAh+7Xz9TFqweUqKDwh5
         AkjGpGZzXRHoLLR0MJ1V1kzXJffoD0U8oF+fuTM7ZCIy3oEd0vJdBPnJZUEGWSaVFaaj
         t8Dw==
X-Forwarded-Encrypted: i=1; AJvYcCUnNopm9FlTzl/qOqAy2kUSZwiNCKDx+pcmJjOawvXUGDkwH2819aPUs+wC1d3heLF8V7misTTe5XZeufxyGB/DSAoO
X-Gm-Message-State: AOJu0YzsKSKmQDQY9OBi5Q89ZBrkcoT/4oukZnlxyhF8S76qdw3XJTSA
	CjXy+e1k5kkf6rOBTaIDLuTGB+SCGsp4oTGUWmwdY1NMSHlY8P+p1vFIDHuxWHxNS2ddqcZdmn7
	F0w==
X-Google-Smtp-Source: AGHT+IFxIAsNNLX/wWjGP60ogXWIaQLOymz0x/zBX9xB35/C7Mt1LT8ejLa+96h+7LraXUc/eOJ/JdH+OAs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:b04:0:b0:6c3:101f:f8b with SMTP id
 41be03b00d2f7-6d94aa563d7mr8855a12.2.1717626691569; Wed, 05 Jun 2024 15:31:31
 -0700 (PDT)
Date: Wed, 5 Jun 2024 15:31:30 -0700
In-Reply-To: <20240605220504.2941958-2-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605220504.2941958-1-minipli@grsecurity.net> <20240605220504.2941958-2-minipli@grsecurity.net>
Message-ID: <ZmDnQkNL5NYUmyMN@google.com>
Subject: Re: [PATCH 1/2] KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 06, 2024, Mathias Krause wrote:
> If, on a 64 bit system, a vCPU ID is provided that has the upper 32 bits
> set to a non-zero value, it may get accepted if the truncated to 32 bits
> integer value is below KVM_MAX_VCPU_IDS and 'max_vcpus'. This feels very
> wrong and triggered the reporting logic of PaX's SIZE_OVERFLOW plugin.
> 
> Instead of silently truncating and accepting such values, pass the full
> value to kvm_vm_ioctl_create_vcpu() and make the existing limit checks
> return an error.
> 
> Even if this is a userland ABI breaking change, no sane userland could
> have ever relied on that behaviour.
> 
> Reported-by: PaX's SIZE_OVERFLOW plugin running on grsecurity's syzkaller
> Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
> Cc: Emese Revfy <re.emese@gmail.com>
> Cc: PaX Team <pageexec@freemail.hu>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 14841acb8b95..9f18fc42f018 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4200,7 +4200,7 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
>  /*
>   * Creates some virtual cpus.  Good luck creating more than one.
>   */
> -static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
> +static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)

Hmm, I don't love that KVM subtly relies on the KVM_MAX_VCPU_IDS check to guard
against truncation when passing @id to kvm_arch_vcpu_precreate(), kvm_vcpu_init(),
etc.  I doubt that it will ever be problematic, but it _looks_ like a bug.

If we really care enough to fix this, my vote is for something like so:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4965196cad58..08adfdb2817e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4200,13 +4200,14 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
-static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
+static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long __id)
 {
        int r;
        struct kvm_vcpu *vcpu;
        struct page *page;
+       u32 id = __id;
 
-       if (id >= KVM_MAX_VCPU_IDS)
+       if (id != __id || id >= KVM_MAX_VCPU_IDS)
                return -EINVAL;
 
        mutex_lock(&kvm->lock);

