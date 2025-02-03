Return-Path: <kvm+bounces-37116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A3C6A2557C
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 10:10:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4ED718836E1
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492F6137932;
	Mon,  3 Feb 2025 09:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cWlJ/a9c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F7310FD;
	Mon,  3 Feb 2025 09:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738573755; cv=none; b=DHwsg1FQw39AgNbEb8SzKbmWSqlD8HgkYs+JHvxEHL48qGtxAiwqSYZJSKbc+vtzzPXioQf5Nli1CT776qg+o34AaH/VQrNRZWggRnw4pZ8dvqmNCgVSKnbsRuFDN6WTHY166WZjvdodTqTnN3UJS/vS3GpHZXdNsuBJcD90xAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738573755; c=relaxed/simple;
	bh=PzSsmuxv/dl/eGhBui1ovtcG9ANLBcUrpyKDERCYIW4=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=cOVA7QEXI2aBUxLedgMOJqcxQx2WhrEeUc45fQmEjSiwYHFUcLALOJMRUx55woUtJR73yJWTxEG2CzK6ET87FWQMLWVVr7+L+ppWI2Bhh9S6i6Jl0GLABsyMgckZQmSwV2Nz2F9pUubW15eVkPdI7T97jQXfyXJ2+k3ZYXM1Vlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cWlJ/a9c; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aaf0f1adef8so795131766b.3;
        Mon, 03 Feb 2025 01:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738573752; x=1739178552; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2fp8SmhnQZOxKTynbVKVR0AODdUJ3d4398e82PaNZqQ=;
        b=cWlJ/a9cfH8Rad48WCsmJpwW4kAIcU/y2TjrTEzXgvhj2wMCfpjLZwUVsdIOLzXdKl
         5Kr7/IGWzGEQQNmoMfJs8PM5D+vOpbVdtptNQhlUpOAmJxtP7YAgd1u29dvXLJrWlfGz
         6YfaDufdFeyzXo7H+GE0i7yVcRC6dObYmcr2QiqWF8CVRL5r4FCq9QM2KOz0LYOWl5vu
         V2oFz2RXuR+nO2NttvLjIQ/zTSYhxOt+ts+Uh1tdmbL/l9T5Gsoi/QCBmw8jgaWSBC30
         V+zfI5H4xLROmeiGgkuRjc7kQ8Br+HPhYiIOEX2wyYNZgvL7dWUL/eaOcFQvonihrCwp
         3WFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738573752; x=1739178552;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2fp8SmhnQZOxKTynbVKVR0AODdUJ3d4398e82PaNZqQ=;
        b=smM9+d6vw+x4uIzEn3za3RCBiRhnKkYwPOnQZdKVoKulxzuGuS3COshwZ/aQnIlqKG
         fDoVdXjBj3lJPjMxYujuBSbj/YEJvOv0YEcM90g9KyfKReHx8+JZU81bfPO+vhiMPOvO
         RNTAhymgxtSk384HwYX5tMO9y65uFxIEsmr6a9ZmBMEsbQUDpU0/VQAHyw9zhsL7uu7Q
         9ejZfdkLGhXrQZdzu7dxFttf0B6IYJVclOtuiy6qUYckfC0/dpv30G2WK5WXZXqT6DY/
         L3gw6bMNSjC2hiKD3K+6+WkarSYxCjdBo7ld4Y/0KoXTGZsrd24H1hovsjhMUHe3klNY
         d+lQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhyqRUEWO9KgTL6A2z1Q3x+Hkv0jlxpMFQAByYtHnxyOF0X1E12itSsRhuPRABLen4W7Xg26j4t5z1QKU=@vger.kernel.org
X-Gm-Message-State: AOJu0YywstmpWrAXeWrhaqzhgw+m7jGWTApODwkmR2faN3Eky2xLaASa
	o69eM7DDn5VXLsvlB9Eeib3QwXdUSkiqyHAzzEc5ReJUkFiSTMqO
X-Gm-Gg: ASbGncu1nXEPNiuI9L80DDV0HuAIXzYmE6e6ZWcEnbcaYDSTy08hsAp8HoHZbMogXpF
	viNXf7DMhCCBSDGqwzpqcQUbn71OdkQXFjI/mjhermQN6E5bpmxL7vveKana6nMFkUy+/Qi1Rwl
	w/Fcoco1KMcdxpR8FgnY5IH7PwR6EopbBt63/hk6dww9Jjy6XULKITcB/PE6WKMI6QZVp/lEoJW
	dkN/+T7MLjBkhBaHYfo4P6shCb83Q62kgXli99YrKpyDmD+vu6SFO1FwZOqNQ0PTKpo61rldQqV
	R0GAbf+V7AVJY5QbAcKkxpjbVtEZUNoRi/4qayM3HLTKFZxs
X-Google-Smtp-Source: AGHT+IE5gNJJtnS5lyVKLajFYmcAjzGWdPxv7bmPCyrqxygaCgCJlVGWrpwgYrsTDZQjUmZST+YXRA==
X-Received: by 2002:a17:907:3d8d:b0:ab2:d8e7:682c with SMTP id a640c23a62f3a-ab6cfdbdd76mr2662133066b.38.1738573751506;
        Mon, 03 Feb 2025 01:09:11 -0800 (PST)
Received: from [192.168.14.180] (54-240-197-239.amazon.com. [54.240.197.239])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e49ff876sm719683266b.115.2025.02.03.01.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 01:09:11 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <9e37bad3-86e2-4093-afd4-a2c2f9873c3a@xen.org>
Date: Mon, 3 Feb 2025 09:09:09 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 1/5] KVM: x86/xen: Restrict hypercall MSR to unofficial
 synthetic range
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com,
 Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
References: <20250201011400.669483-1-seanjc@google.com>
 <20250201011400.669483-2-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250201011400.669483-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/02/2025 01:13, Sean Christopherson wrote:
> Reject userspace attempts to set the Xen hypercall page MSR to an index
> outside of the "standard" virtualization range [0x40000000, 0x4fffffff],
> as KVM is not equipped to handle collisions with real MSRs, e.g. KVM
> doesn't update MSR interception, conflicts with VMCS/VMCB fields, special
> case writes in KVM, etc.
> 
> Allowing userspace to redirect any MSR write can also be used to attack
> the kernel, as kvm_xen_write_hypercall_page() takes multiple locks and
> writes to guest memory.  E.g. if userspace sets the MSR to MSR_IA32_XSS,
> KVM's write to MSR_IA32_XSS during vCPU creation will trigger an SRCU
> violation due to writing guest memory:
> 
>    =============================
>    WARNING: suspicious RCU usage
>    6.13.0-rc3
>    -----------------------------
>    include/linux/kvm_host.h:1046 suspicious rcu_dereference_check() usage!
> 
>    stack backtrace:
>    CPU: 6 UID: 1000 PID: 1101 Comm: repro Not tainted 6.13.0-rc3
>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>    Call Trace:
>     <TASK>
>     dump_stack_lvl+0x7f/0x90
>     lockdep_rcu_suspicious+0x176/0x1c0
>     kvm_vcpu_gfn_to_memslot+0x259/0x280
>     kvm_vcpu_write_guest+0x3a/0xa0
>     kvm_xen_write_hypercall_page+0x268/0x300
>     kvm_set_msr_common+0xc44/0x1940
>     vmx_set_msr+0x9db/0x1fc0
>     kvm_vcpu_reset+0x857/0xb50
>     kvm_arch_vcpu_create+0x37e/0x4d0
>     kvm_vm_ioctl+0x669/0x2100
>     __x64_sys_ioctl+0xc1/0xf0
>     do_syscall_64+0xc5/0x210
>     entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    RIP: 0033:0x7feda371b539
> 
> While the MSR index isn't strictly ABI, i.e. can theoretically float to
> any value, in practice no known VMM sets the MSR index to anything other
> than 0x40000000 or 0x40000200.
> 
> Reported-by: syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/679258d4.050a0220.2eae65.000a.GAE@google.com
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: Paul Durrant <paul@xen.org>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/xen.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

