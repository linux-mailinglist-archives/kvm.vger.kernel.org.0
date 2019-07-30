Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D79FF7A73E
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 13:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730949AbfG3Lqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 07:46:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42186 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfG3Lqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 07:46:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id x1so15514951wrr.9
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 04:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jUFjo7Q5G3zhSSdduVy1O7SlK8IlcyeyKFuG+AGKxmo=;
        b=kBWcGq6iB4aV6xpztCkG2tEtuMmLAYBwqPYmhaybXVRTcKPCH/0A86UYe09md70uZ8
         yn2iDjn+3Dgp12n4OYWX6NyL21HAH0CBZFVwYYUPMMNtaSYK+MG8gNhmNk+KNWw6a7fE
         dwWnJJA43KqaPFt45Tlw1NrYBJ8N42Az4TxIrr4OxVhUXDVxDRG3FgIo9uhVO+rOBsIZ
         cFmSpPLMsKIZvEVRtiO+ovWCn6fEta4bEYGcXfRwrnu+qAUrGUkBsae09phfIHt9Xl5O
         Qpeg/asi5QG/5T1UOljOCw2PaHC5xyM+Ostf01XPp3/m+GtaUX3UJ6twfuLKpmGZxiyl
         hcog==
X-Gm-Message-State: APjAAAUw0Yo+z8Xn1lvkSD0s82oMc9YumvOOOhZDxg2WcJxoug1+ezm1
        JenDtxmBLcGM0UPMStX9bvizOw==
X-Google-Smtp-Source: APXvYqyHKBNli8Rf99QJlDKCJPKF1DuxYyuY1jWeCqKjKdYHMM+R6nhlKvVAjYLLRTTFFL/2pUVi3A==
X-Received: by 2002:adf:d4cc:: with SMTP id w12mr130140913wrk.121.1564487204000;
        Tue, 30 Jul 2019 04:46:44 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a84sm80775887wmf.29.2019.07.30.04.46.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 04:46:43 -0700 (PDT)
Subject: Re: [PATCH] KVM: Disable wake-affine vCPU process to mitigate lock
 holder preemption
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1564479235-25074-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <19e0beb6-a732-ea1f-79a5-41be92569338@redhat.com>
Date:   Tue, 30 Jul 2019 13:46:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564479235-25074-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 11:33, Wanpeng Li wrote:
> When qemu/other vCPU inject virtual interrupt to guest through waking up one 
> sleeping vCPU, it increases the probability to stack vCPUs/qemu by scheduler
> wake-affine. vCPU stacking issue can greately inceases the lock synchronization 
> latency in a virtualized environment. This patch disables wake-affine vCPU 
> process to mitigtate lock holder preemption.

There is no guarantee that the vCPU remains on the thread where it's
created, so the patch is not enough.

If many vCPUs are stacked on the same pCPU, why doesn't the wake_cap
kick in sooner or later?

Paolo

> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  include/linux/sched.h | 1 +
>  kernel/sched/fair.c   | 3 +++
>  virt/kvm/kvm_main.c   | 1 +
>  3 files changed, 5 insertions(+)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8dc1811..3dd33d8 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1468,6 +1468,7 @@ extern struct pid *cad_pid;
>  #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
>  #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
>  #define PF_MEMALLOC_NOCMA	0x10000000	/* All allocation request will have _GFP_MOVABLE cleared */
> +#define PF_NO_WAKE_AFFINE	0x20000000	/* This thread should not be wake affine */
>  #define PF_FREEZER_SKIP		0x40000000	/* Freezer should not count it as freezable */
>  #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
>  
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 036be95..18eb1fa 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5428,6 +5428,9 @@ static int wake_wide(struct task_struct *p)
>  	unsigned int slave = p->wakee_flips;
>  	int factor = this_cpu_read(sd_llc_size);
>  
> +	if (unlikely(p->flags & PF_NO_WAKE_AFFINE))
> +		return 1;
> +
>  	if (master < slave)
>  		swap(master, slave);
>  	if (slave < factor || master < slave * factor)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 887f3b0..b9f75c3 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2680,6 +2680,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  
>  	mutex_unlock(&kvm->lock);
>  	kvm_arch_vcpu_postcreate(vcpu);
> +	current->flags |= PF_NO_WAKE_AFFINE;
>  	return r;
