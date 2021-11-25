Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC0B45E195
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356915AbhKYUdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244587AbhKYUbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:31:38 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C24FC061759;
        Thu, 25 Nov 2021 12:24:54 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637871892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Pow8ZvIwto7WGV9kVhPczJYtDBpiQ5V4PVYGLMe0Ss=;
        b=VMXOt4UStl3V8dSj6uFxjc5Co+bpM+ITkdzXe+35Mvgi2ia3/VcE4HLv3GZ7lB6Xxj95cO
        snPUv3fF7ZM7IXP2D6BZfbHgvU+PM3Vw/7CBc9uCbvqnak715cbdElAENuZmxHOF8agP65
        Rn1bUXrc9VjuFYt0IbO1WKUjTjPtmOsERMGd74IDMwpCupzUw+CX0STx72IP6BS9mQsWaP
        TMOLih4LxKgM8YqRblX8Q06TrnYfePKexqyYTZUvES/3/Vt99lYVrXEUtKeiEon63aa+/w
        ngTMttGGEcfVZ+vUYayhLCdGq8EkmPCnuor4NFf3/NCYed4be24UjOGD0HbOQw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637871892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Pow8ZvIwto7WGV9kVhPczJYtDBpiQ5V4PVYGLMe0Ss=;
        b=PUdUfjMZRwsTtAj6X0/r1fGLZEJ2y3YjXZ2wl/qB9uOgjnkr+8LccX1teirglLHAX8XMr1
        MpJbR0PU88vzVeDw==
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
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 49/59] KVM: VMX: Add macro framework to
 read/write VMCS for VMs and TDs
In-Reply-To: <87a52a66a43bf05ccb8ef3ebd1f93bd00e7b07c4.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <87a52a66a43bf05ccb8ef3ebd1f93bd00e7b07c4.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 21:24:52 +0100
Message-ID: <87h7c0htkb.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:

> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Add a macro framework to hide VMX vs. TDX details of VMREAD and VMWRITE
> so the VMX and TDX can shared common flows, e.g. accessing DTs.

s/shared/share/

> Note, the TDX paths are dead code at this time.  There is no great way
> to deal with the chicken-and-egg scenario of having things in place for
> TDX without first having TDX.

That's more than obvious and the whole point of building infrastructure
in the first place, isn't it?

> +#ifdef CONFIG_INTEL_TDX_HOST
> +#define VT_BUILD_VMCS_HELPERS(type, bits, tdbits)			   \
> +static __always_inline type vmread##bits(struct kvm_vcpu *vcpu,		   \
> +					 unsigned long field)		   \
> +{									   \
> +	if (unlikely(is_td_vcpu(vcpu))) {				   \
> +		if (KVM_BUG_ON(!is_debug_td(vcpu), vcpu->kvm))		   \
> +			return 0;					   \
> +		return td_vmcs_read##tdbits(to_tdx(vcpu), field);	   \
> +	}								   \
> +	return vmcs_read##bits(field);					   \
> +}									   \

New lines exist for a reason to visually separate things and are even
possible in macro blocks. This includes the defines.

Aside of that is there any reason why the end of the macro block has to
be 3 spaces instead of a tab?

Thanks,

        tglx
