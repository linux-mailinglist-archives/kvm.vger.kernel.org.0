Return-Path: <kvm+bounces-2562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BDEE7FB238
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:57:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF6C7B20C4C
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 06:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2356F10A33;
	Tue, 28 Nov 2023 06:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P6jvBnw1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC40D45
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701154653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zE7AjBo0QlaKZ2cgSA3NucVJmj83lcIek7eIT3JkpiM=;
	b=P6jvBnw1GFHIucNwPybQKen/6XxR1AHhmvG1kd4t4GSNuMhvUKVjFafsXOVH6qiyLIunMa
	Ofu81sBz03MYe3M5YQE8m6nLHUh2zv1XZ9wk3XSiHGP5aS4uc4OqiLC9N/VpIafdGbAxWM
	+l9uAdRWS+/77R4JQsJ/KvHhcRE+hDk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-218-S2Iu91DsO8eDnPQhIxwXkg-1; Tue, 28 Nov 2023 01:57:31 -0500
X-MC-Unique: S2Iu91DsO8eDnPQhIxwXkg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33303db14d9so1157031f8f.1
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:57:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701154650; x=1701759450;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zE7AjBo0QlaKZ2cgSA3NucVJmj83lcIek7eIT3JkpiM=;
        b=m05H875Tak1xYwwxrjhQRjsuFeWrj6pFNHIuyw2WOqwqjccY0HeOUTx6/jwMcPQOQQ
         sZE5gwfedw7l/8yJbJVoIn0en/WuMYtn6Aroz2yp/4L1tpx/Hak/GW/svbbRn+39W4U3
         qHlrrjv6Vp2FdAzBvF/m0qBMs8L50ahmCGPRT7sbAThXxWcZfpATRolb6JhSePXmOk94
         M3F4of3MNgtnQve8Q5BJXn9plhIfofIzFSv3mRX0piSlW+76J5r2/3O0+LWZFEsI7+zU
         aXK5XSQK8rNmNEgQRBphV7qE5oDvvJSud3Ym2WzaFPH+mzVW/mJPteu9ctuzDcOddXRP
         ESYg==
X-Gm-Message-State: AOJu0YwV9YKvt7ygQWdbBnMKe/KpZESTP9BKTB1brDw7i2rzHCw8TOXG
	OBW/JYmy5+RirAfZRERGqWmyXOrV725MSY/iR+JVAaVlnUztm6SlSZmJM+lO1v73it/VS50GiV0
	9YICOnMd5TCIX
X-Received: by 2002:a5d:4e0d:0:b0:332:eeb1:3e80 with SMTP id p13-20020a5d4e0d000000b00332eeb13e80mr7503284wrt.65.1701154650489;
        Mon, 27 Nov 2023 22:57:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGuKvJa1plwBP9iOcPdK/Bc4OfaF0tZQAtzwb+kY2MIbTgJZvON/HwoZP0xn6KzocdjY7zbXA==
X-Received: by 2002:a5d:4e0d:0:b0:332:eeb1:3e80 with SMTP id p13-20020a5d4e0d000000b00332eeb13e80mr7503267wrt.65.1701154650128;
        Mon, 27 Nov 2023 22:57:30 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id o3-20020a5d6843000000b00332fd9b2b52sm6125983wrw.104.2023.11.27.22.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 22:57:29 -0800 (PST)
Message-ID: <e85fb226e28ada35efe9abd208ddb60d92e9f14c.camel@redhat.com>
Subject: Re: [RFC 03/33] KVM: x86: hyper-v: Introduce XMM output support
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Alexander Graf <graf@amazon.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  Nicolas Saenz Julienne <nsaenz@amazon.com>,
 kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 pbonzini@redhat.com, seanjc@google.com, anelkz@amazon.com,
 dwmw@amazon.co.uk,  jgowans@amazon.com, corbert@lwn.net, kys@microsoft.com,
 haiyangz@microsoft.com,  decui@microsoft.com, x86@kernel.org,
 linux-doc@vger.kernel.org
Date: Tue, 28 Nov 2023 08:57:27 +0200
In-Reply-To: <b83e86a4-4692-45e7-8237-4efd9d5f7daf@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-4-nsaenz@amazon.com>
	 <82c5a8c8-2c3c-43dc-95c2-4d465fe63985@amazon.com>
	 <87o7g4e96v.fsf@redhat.com>
	 <b83e86a4-4692-45e7-8237-4efd9d5f7daf@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-08 at 13:16 +0100, Alexander Graf wrote:
> On 08.11.23 13:11, Vitaly Kuznetsov wrote:
> > Alexander Graf <graf@amazon.com> writes:
> > 
> > > On 08.11.23 12:17, Nicolas Saenz Julienne wrote:
> > > > Prepare infrastructure to be able to return data through the XMM
> > > > registers when Hyper-V hypercalls are issues in fast mode. The XMM
> > > > registers are exposed to user-space through KVM_EXIT_HYPERV_HCALL and
> > > > restored on successful hypercall completion.
> > > > 
> > > > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> > > > ---
> > > >    arch/x86/include/asm/hyperv-tlfs.h |  2 +-
> > > >    arch/x86/kvm/hyperv.c              | 33 +++++++++++++++++++++++++++++-
> > > >    include/uapi/linux/kvm.h           |  6 ++++++
> > > >    3 files changed, 39 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> > > > index 2ff26f53cd62..af594aa65307 100644
> > > > --- a/arch/x86/include/asm/hyperv-tlfs.h
> > > > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> > > > @@ -49,7 +49,7 @@
> > > >    /* Support for physical CPU dynamic partitioning events is available*/
> > > >    #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE  BIT(3)
> > > >    /*
> > > > - * Support for passing hypercall input parameter block via XMM
> > > > + * Support for passing hypercall input and output parameter block via XMM
> > > >     * registers is available
> > > >     */
> > > >    #define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE               BIT(4)
> > > > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > > > index 238afd7335e4..e1bc861ab3b0 100644
> > > > --- a/arch/x86/kvm/hyperv.c
> > > > +++ b/arch/x86/kvm/hyperv.c
> > > > @@ -1815,6 +1815,7 @@ struct kvm_hv_hcall {
> > > >       u16 rep_idx;
> > > >       bool fast;
> > > >       bool rep;
> > > > +    bool xmm_dirty;
> > > >       sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];
> > > > 
> > > >       /*
> > > > @@ -2346,9 +2347,33 @@ static int kvm_hv_hypercall_complete(struct kvm_vcpu *vcpu, u64 result)
> > > >       return ret;
> > > >    }
> > > > 
> > > > +static void kvm_hv_write_xmm(struct kvm_hyperv_xmm_reg *xmm)
> > > > +{
> > > > +    int reg;
> > > > +
> > > > +    kvm_fpu_get();
> > > > +    for (reg = 0; reg < HV_HYPERCALL_MAX_XMM_REGISTERS; reg++) {
> > > > +            const sse128_t data = sse128(xmm[reg].low, xmm[reg].high);
> > > > +            _kvm_write_sse_reg(reg, &data);
> > > > +    }
> > > > +    kvm_fpu_put();
> > > > +}
> > > > +
> > > > +static bool kvm_hv_is_xmm_output_hcall(u16 code)
> > > > +{
> > > > +    return false;
> > > > +}
> > > > +
> > > >    static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
> > > >    {
> > > > -    return kvm_hv_hypercall_complete(vcpu, vcpu->run->hyperv.u.hcall.result);
> > > > +    bool fast = !!(vcpu->run->hyperv.u.hcall.input & HV_HYPERCALL_FAST_BIT);
> > > > +    u16 code = vcpu->run->hyperv.u.hcall.input & 0xffff;
> > > > +    u64 result = vcpu->run->hyperv.u.hcall.result;
> > > > +
> > > > +    if (kvm_hv_is_xmm_output_hcall(code) && hv_result_success(result) && fast)
> > > > +            kvm_hv_write_xmm(vcpu->run->hyperv.u.hcall.xmm);
> > > > +
> > > > +    return kvm_hv_hypercall_complete(vcpu, result);
> > > >    }
> > > > 
> > > >    static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
> > > > @@ -2623,6 +2648,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> > > >               break;
> > > >       }
> > > > 
> > > > +    if ((ret & HV_HYPERCALL_RESULT_MASK) == HV_STATUS_SUCCESS && hc.xmm_dirty)
> > > > +            kvm_hv_write_xmm((struct kvm_hyperv_xmm_reg*)hc.xmm);
> > > > +
> > > >    hypercall_complete:
> > > >       return kvm_hv_hypercall_complete(vcpu, ret);
> > > > 
> > > > @@ -2632,6 +2660,8 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> > > >       vcpu->run->hyperv.u.hcall.input = hc.param;
> > > >       vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
> > > >       vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
> > > > +    if (hc.fast)
> > > > +            memcpy(vcpu->run->hyperv.u.hcall.xmm, hc.xmm, sizeof(hc.xmm));
> > > >       vcpu->arch.complete_userspace_io = kvm_hv_hypercall_complete_userspace;
> > > >       return 0;
> > > >    }
> > > > @@ -2780,6 +2810,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
> > > >                       ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
> > > > 
> > > >                       ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
> > > > +                    ent->edx |= HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE;
> > > 
> > > Shouldn't this be guarded by an ENABLE_CAP to make sure old user space
> > > that doesn't know about xmm outputs is still able to run with newer kernels?
> > > 
> > No, we don't do CAPs for new Hyper-V features anymore since we have
> > KVM_GET_SUPPORTED_HV_CPUID. Userspace is not supposed to simply copy
> > its output into guest visible CPUIDs, it must only enable features it
> > knows. Even 'hv_passthrough' option in QEMU doesn't pass unknown
> > features through.
> 
> Ah, nice :). That simplifies things.
> 
> 
> Alex


Besides other remarks I think that this patch is reasonable,
and maybe it can be queued before the main VSM series,
assuming that it comes with a unit test to avoid having
dead code in the kernel.

Best regards,
	Maxim Levitsky

> 
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 





