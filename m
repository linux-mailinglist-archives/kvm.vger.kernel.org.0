Return-Path: <kvm+bounces-50729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9687BAE8903
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 18:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A62B174372
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D211A7264;
	Wed, 25 Jun 2025 16:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P+j+eXeO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351BF381C4
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 16:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750867255; cv=none; b=EuUw5+RcmHPq4tqfcmSMQj+vWkNyAD01dWNmlJ0nwc5nP1mbQIeGPhC8PZFxjozt1trN7Mei8g8NlnoeSfQv0Yibgrl+vyvfP98klanL8MntfTjP7gPStLbhnPfgrR3hsKbKKSmcEUrQrHbP4NW5AOOu77oy1010KG4EPBX6RJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750867255; c=relaxed/simple;
	bh=FQFAU8J92YBJOIwviIOuWy+syYqT13CticcqgFA8fNQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tajhlAx7yc5YpcTmeplEssQQCOh6aVU1o2Qw88nO+VX/tTMkihMI5V4PMASdSFGlof9w5X2h9O4uLWW7CWnKOH0E7aDWyBpYEq6dXAdvz8GXjwvt5hk62hycSE/YYPuvXfXulrltDzGhifln10mfI5HxDrIlnIGAFgX4NORwpyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P+j+eXeO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750867253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fVPSomnM/XHJegYDF8a486UxXjZV1B4u2XNVJqXqkPE=;
	b=P+j+eXeOA2w3SmjSCIqPA1YMkS7zXYvUmKXGv6obon7H/ytE6GcEAiUGiAaiuWxclZK1M4
	Hhs/ZivtKVqvJYa7PiNYRJ8sfM+jTAQJxvYvx/YQMmlTwWM5Z+n5G4USgeuQJz8/ARS2tW
	Y/jgA1JzjYkk0Har/X9Mf92lSJrxpSQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-EjJkDi1TOxy93Ty39nYsAQ-1; Wed, 25 Jun 2025 12:00:51 -0400
X-MC-Unique: EjJkDi1TOxy93Ty39nYsAQ-1
X-Mimecast-MFC-AGG-ID: EjJkDi1TOxy93Ty39nYsAQ_1750867250
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a50049f8eeso924793f8f.3
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 09:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750867250; x=1751472050;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fVPSomnM/XHJegYDF8a486UxXjZV1B4u2XNVJqXqkPE=;
        b=cU/j32+Vzl0IuIoWP/GldEDZJl5EZXpzi57KEAAaPJreli945YiQZXPItYFyzeMk72
         +vPij/gzJxhZATJfhqR1M4Xn4vQgy/5Q+IFkNtBDtTS3azy46Xv0USDrgsHkBamD/Stq
         CvkG4HNLULt3+P6GuVeUGpUc3GoVayxFLBA4fTqkhTWGcl0Ge82EO82/sDHfNw7Xsyer
         sJD+SiHbdCvlHZF/Q66b4Z/VVIs/qSGCXH78nkJ0E4BlIFehLrE+7KK2vXEpDz0gZu0X
         OClMHXWzuI+xzSPSNrcCbxf5kgy+SviDOdyi0AATgCH+MawU6L22bCONhonbsDpH3io2
         +FQg==
X-Forwarded-Encrypted: i=1; AJvYcCWS4YSeKebtw40q+RO3ltacUufN05XCYsESHb2bkwa00KTKG2921CzCJ9XG34GN4/qkvqI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxar1P6MibOrx0IT6wMDJvZXqqZieYRy8QC7Ar9pM+Bme//mnGN
	Urv8dWK3bEZdeaSgsH9S6RkSFRJ9YW7AMLZD2eZifoTetsRiGF31OCcknBwrNpktONezkgeyr9v
	76KKZjz1yxGfLxEQn4W/vr6HG5CSrNcru6pIILn8sIxddJTtp6VPnjg==
X-Gm-Gg: ASbGncsws0ips8R4JjU1V5Tsg8iWkjkQB7+eP348kCqx87A1C/r0Qx/KAYhhQwoYfdc
	jpBAeuhC2joDZL2cJLM+ouor8q0u4TZRNSQHda5i0FMNMZhVBur99hpTuDO+AP4vmCRyWrgmMvg
	c3VI4su4rjoPFvw9mfFOMqiCotU6kkf7noyPhrFgRPCfljk/quOSzjb2vyrSShA4cGd46UELF3S
	jqHr9hwWhq6XI8FLmaQD8CrAdoqaMAJDPqtruEzc8uqfGNmCofpoCn8fKJS5MBKKPfZHvMtetpq
	GcAsGImJpUjG5YXQhQ==
X-Received: by 2002:a05:6000:200d:b0:3a6:d95c:5e8 with SMTP id ffacd0b85a97d-3a6ed66464dmr3440598f8f.35.1750867249894;
        Wed, 25 Jun 2025 09:00:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEx8ud9+gtyW7duD6Uk77aUjb1DTQPtQAWhhJNwbC5QYNwTl1QD0WHHRtck+a2LtJywDfOJBg==
X-Received: by 2002:a05:6000:200d:b0:3a6:d95c:5e8 with SMTP id ffacd0b85a97d-3a6ed66464dmr3440529f8f.35.1750867249336;
        Wed, 25 Jun 2025 09:00:49 -0700 (PDT)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e805dc00sm5135456f8f.31.2025.06.25.09.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 09:00:48 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Manuel Andreas <manuel.andreas@tum.de>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com
Subject: Re: [PATCH] x86/hyper-v: Filter non-canonical addresses passed via
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST(_EX)
In-Reply-To: <c090efb3-ef82-499f-a5e0-360fc8420fb7@tum.de>
References: <c090efb3-ef82-499f-a5e0-360fc8420fb7@tum.de>
Date: Wed, 25 Jun 2025 18:00:47 +0200
Message-ID: <87plerolow.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Manuel Andreas <manuel.andreas@tum.de> writes:

> In KVM guests with Hyper-V hypercalls enabled, the hypercalls 
> HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST and HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX 
> allow a guest to request invalidation of portions of a virtual TLB.
> For this, the hypercall parameter includes a list of GVAs that are supposed 
> to be invalidated.
>
> However, when non-canonical GVAs are passed, there is currently no 
> filtering in place and they are eventually passed to checked invocations of 
> INVVPID on Intel / INVLPGA on AMD.
> While the AMD variant (INVLPGA) will silently ignore the non-canonical 
> address and perform a no-op, the Intel variant (INVVPID) will fail and end 
> up in invvpid_error, where a WARN_ONCE is triggered:
>
> invvpid failed: ext=0x0 vpid=1 gva=0xaaaaaaaaaaaaa000
> WARNING: CPU: 6 PID: 326 at arch/x86/kvm/vmx/vmx.c:482 
> invvpid_error+0x91/0xa0 [kvm_intel]
> Modules linked in: kvm_intel kvm 9pnet_virtio irqbypass fuse
> CPU: 6 UID: 0 PID: 326 Comm: kvm-vm Not tainted 6.15.0 #14 PREEMPT(voluntary)
> RIP: 0010:invvpid_error+0x91/0xa0 [kvm_intel]
> Call Trace:
>   <TASK>
>   vmx_flush_tlb_gva+0x320/0x490 [kvm_intel]
>   ? __pfx_vmx_flush_tlb_gva+0x10/0x10 [kvm_intel]
>   ? kfifo_copy_out+0xcf/0x120
>   kvm_hv_vcpu_flush_tlb+0x24f/0x4f0 [kvm]
>   ? __pfx_kvm_hv_vcpu_flush_tlb+0x10/0x10 [kvm]
>   ? kvm_pmu_is_valid_msr+0x6e/0x80 [kvm]
>   ? kvm_get_msr_common+0x219/0x20f0 [kvm]
>   kvm_arch_vcpu_ioctl_run+0x3013/0x5810 [kvm]
>   /* ... */
>
> Hyper-V documents that invalid GVAs (those that are beyond a partition's 
> GVA space) are to be ignored. While not completely clear whether this 
> ruling also applies to non-canonical GVAs, it is likely fine to make that 
> assumption.

I wrote a simple test and ran it on Azure. Unless I screwed up, the
result confirms this assumption. The test was:

#include <linux/module.h>	/* Needed by all modules */
#include <linux/kernel.h>	/* Needed for KERN_INFO */

struct hv_tlb_flush {    /* HV_INPUT_FLUSH_VIRTUAL_ADDRESS_LIST */
        u64 address_space;
        u64 flags;
        u64 processor_mask;
        u64 gva_list[];
} __packed;

static inline u64 __hyperv_hypercall(u64 control, u64 input_address,
                                     u64 output_address)
{
	u64 res;

        asm volatile("mov %[output_address], %%r8\n\t"
                     "vmcall"
                     : "=a" (res),
                       "+c" (control), "+d" (input_address)
                     : [output_address] "r"(output_address)
                     : "cc", "memory", "r8", "r9", "r10", "r11");

	return res;
}

int init_module(void)
{
	u64 rcx = 0x0003UL | 1UL << 32; /* 1 rep */
	u64 status;
	struct hv_tlb_flush *flush = (struct hv_tlb_flush *)kzalloc(4096, GFP_KERNEL);
	void *out = kzalloc(4096, GFP_KERNEL);

	flush->flags = 0x3; /* all CPUS all address spaces */
	flush->processor_mask = 0x1;
	flush->gva_list[0] = 0xaaaaaaaaaaaaa000;

	status = __hyperv_hypercall(rcx, __pa(flush), __pa(out));

	printk("Flush result: %llx\n", status);

	kfree(flush);
	kfree(out);

	return -1;
}

void cleanup_module(void)
{
}

MODULE_LICENSE("GPL");

And the result of loading this module is:

[ 4228.888451] Flush result: 100000000

(1 in bit 32 means 1 rep completed, lower 16 bits == 0 indicate
HV_STATUS_SUCCESS).

>
> The following patch addresses the issue by skipping non-canonical GVAs 
> before calling the architecture-specific invalidation primitive.
> I've validated it against a PoC and the issue seems to be fixed.
>
> Signed-off-by: Manuel Andreas <manuel.andreas@tum.de>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/kvm/hyperv.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 24f0318c50d7..644a7aae6dab 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1979,6 +1979,9 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>   		if (entries[i] == KVM_HV_TLB_FLUSHALL_ENTRY)
>   			goto out_flush_all;
>
> +                if (is_noncanonical_invlpg_address(entries[i], vcpu))
> +                        continue;
> +
>   		/*
>   		 * Lower 12 bits of 'address' encode the number of additional
>   		 * pages to flush.

-- 
Vitaly


