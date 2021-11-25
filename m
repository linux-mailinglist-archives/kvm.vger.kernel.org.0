Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8EB45E0F9
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 20:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243928AbhKYTbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 14:31:53 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54024 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhKYT3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 14:29:51 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637868399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MI+SfJGn+IjRpP8EdCyxmW0iJCGSvp+elicPiF3BXVE=;
        b=sjSYPczvr0Fnk+BjfZy2sGJT0vtL0c4qWgvK+EEXXgpkw7l17Z/8rbKUZBvGGqI4P7Sa8B
        +Fdz7l+yLXLvhaEP221ghBi3XM4024EiuarBh1x4jqW/QBGpo9ln1NmcSYpcV8rMyvbZqB
        UF0DXrErC8CsLChsvTMNvVJdu1q49BzE7VBscQiXwlVwZHLWX9WlGQ4lkKrk4Na/jWlaxe
        pr3ji/LAQVPK+UNMGhabTeGqKZi7RCStkYwOfnEthHksK6P72BWKpaD2eFscUNfQy4pAlA
        NePfUdPe2tRBUyxyYhx7WScmWT5jBTNj45fZTndYJn0iTYGuGd9NKf64w/HImA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637868399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MI+SfJGn+IjRpP8EdCyxmW0iJCGSvp+elicPiF3BXVE=;
        b=dyeLW596ga9en350GC2QUAkZy0WhOYKDJhNdxW8TW6saT0mxWOXsNQAR5mrklu2Zlk5Pqa
        xgGV2lh8/5/lXeAw==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v3 15/59] KVM: x86: Introduce "protected guest"
 concept and block disallowed ioctls
In-Reply-To: <3e78c301460dfabc2aec22bde3907207011435b9.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <3e78c301460dfabc2aec22bde3907207011435b9.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 20:26:38 +0100
Message-ID: <87r1b4jatt.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:19, isaku yamahata wrote:
>  
>  static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
>  {
> +	/* TODO: use more precise flag */

Why is this still a todo and not implemented properly from the very beginning?

And then you have this:

> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;

...

> +	/* TODO: use more precise flag */
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;

and a gazillion of other places. That's beyond lame.

The obvious place to do such a decision is kvm_arch_vcpu_ioctl(), no?

kvm_arch_vcpu_ioctl(.., unsigneg int ioctl, ...)

     if (vcpu->arch.guest_state_protected) {
     	  if (!(test_bit(_IOC_NR(ioctl), vcpu->ioctl_allowed))
          	return -EINVAL;
     }

is way too simple and obvious, right?

Even if you want more fine grained control, then having an array of
flags per ioctl number is way better than sprinkling this protected muck
conditions all over the place.

Thanks,

        tglx

    

