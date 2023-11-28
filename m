Return-Path: <kvm+bounces-2570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 374AF7FB2B1
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE191B2100A
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6104E13ACA;
	Tue, 28 Nov 2023 07:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ViYkU0kQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A79197
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701156415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aDhxfrZ6A0IBRHudGpkZAOoM1jn0urSkC0LwcNBapbI=;
	b=ViYkU0kQPWRym9rgySUPrmYgvewMwjphtyt8W2TlvLzoXg1GbxGJzQ+ZjQLjv7GaGM5Qgb
	vbCJsc7WGRBrEWdORICTz8qvizGDdkvne8CKW4siCOrizj81HzXhLZxRHjVNWE1aNsUCe8
	v4nRkZftUiYHy6cDA2wrBAleH5PzNmk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-DRwa-qe9MOeBb0re3A6Fvw-1; Tue, 28 Nov 2023 02:26:52 -0500
X-MC-Unique: DRwa-qe9MOeBb0re3A6Fvw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40b3519a03aso35597225e9.3
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:26:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701156411; x=1701761211;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aDhxfrZ6A0IBRHudGpkZAOoM1jn0urSkC0LwcNBapbI=;
        b=w6iKRtSAcixlr4MCzWk9MULLUJhfsADOtGjuHZUgfzUMzX0ZNUlfUEekNe9DwcrLQB
         4UpQkfuI31+8BWe6XVcEh8fgVuB3PZSdCBZkaFu8DgiPPsiJKds1ehm89zlZ08BcnQiq
         tQs3rP5yvjBeffj6PbhoqMymSmMzVW73rsHN1KELonSKtw5r2U9iE3xhGZLB0lFGvfdw
         2XkoJDoTp5vjXuvWZ6ldMTTeBvgDiBiKaQpdnpdigtBxSxjmMcO2+ziRLUv02t1hhK2z
         4SMVfPoYT36iRehXRv9iYAHv+wSDj+WLg3/nRy7SuWfla0oUXTtKW67X4q5+VlIUZF/Q
         pLwg==
X-Gm-Message-State: AOJu0Yzgka9hXAPsFN94tISJ8AXarYvNDX4ilOSl/moDgP4Q6UvfOPv/
	/cKUu0Rqj86lf+G9gWhk+w1w/jNPW0oKQGKgb5qiH/EZVs2pgzZ7B/814j4WBuDMHVlRK3kZHkV
	YlUGYdjZ5xpG8
X-Received: by 2002:a05:600c:1f93:b0:401:2ee0:7558 with SMTP id je19-20020a05600c1f9300b004012ee07558mr10641334wmb.32.1701156411728;
        Mon, 27 Nov 2023 23:26:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4M7NxKP9raF3yxSld89xnv352HPd9UfYd6M9jkbwCiMadp3oGAStD9ceWph2CLoGlKw1rNQ==
X-Received: by 2002:a05:600c:1f93:b0:401:2ee0:7558 with SMTP id je19-20020a05600c1f9300b004012ee07558mr10641324wmb.32.1701156411350;
        Mon, 27 Nov 2023 23:26:51 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id l15-20020a05600c4f0f00b00405959bbf4fsm16310283wmq.19.2023.11.27.23.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 23:26:51 -0800 (PST)
Message-ID: <38e52b16dfb57d0759b0e196fc952f20a62b0d3f.camel@redhat.com>
Subject: Re: [RFC 11/33] KVM: x86: hyper-v: Handle GET/SET_VP_REGISTER hcall
 in user-space
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Alexander Graf <graf@amazon.com>, Nicolas Saenz Julienne
 <nsaenz@amazon.com>,  kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 anelkz@amazon.com,  dwmw@amazon.co.uk, jgowans@amazon.com, corbert@lwn.net,
 kys@microsoft.com,  haiyangz@microsoft.com, decui@microsoft.com,
 x86@kernel.org,  linux-doc@vger.kernel.org
Date: Tue, 28 Nov 2023 09:26:48 +0200
In-Reply-To: <b9c6ad26-ce8b-45f3-b856-8e6be2497f6e@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-12-nsaenz@amazon.com>
	 <b9c6ad26-ce8b-45f3-b856-8e6be2497f6e@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-08 at 13:14 +0100, Alexander Graf wrote:
> On 08.11.23 12:17, Nicolas Saenz Julienne wrote:
> > Let user-space handle HVCALL_GET_VP_REGISTERS and
> > HVCALL_SET_VP_REGISTERS through the KVM_EXIT_HYPERV_HVCALL exit reason.
> > Additionally, expose the cpuid bit.
> > 
> > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> > ---
> >   arch/x86/kvm/hyperv.c             | 9 +++++++++
> >   include/asm-generic/hyperv-tlfs.h | 1 +
> >   2 files changed, 10 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index caaa859932c5..a3970d52eef1 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -2456,6 +2456,9 @@ static void kvm_hv_write_xmm(struct kvm_hyperv_xmm_reg *xmm)
> >   
> >   static bool kvm_hv_is_xmm_output_hcall(u16 code)
> >   {
> > +	if (code == HVCALL_GET_VP_REGISTERS)
> > +		return true;
> > +
> >   	return false;
> >   }
> >   
> > @@ -2520,6 +2523,8 @@ static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
> >   	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
> >   	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
> >   	case HVCALL_SEND_IPI_EX:
> > +	case HVCALL_GET_VP_REGISTERS:
> > +	case HVCALL_SET_VP_REGISTERS:
> >   		return true;
> >   	}
> >   
> > @@ -2738,6 +2743,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> >   			break;
> >   		}
> >   		goto hypercall_userspace_exit;
> > +	case HVCALL_GET_VP_REGISTERS:
> > +	case HVCALL_SET_VP_REGISTERS:
> > +		goto hypercall_userspace_exit;
> >   	default:
> >   		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
> >   		break;
> > @@ -2903,6 +2911,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
> >   			ent->ebx |= HV_POST_MESSAGES;
> >   			ent->ebx |= HV_SIGNAL_EVENTS;
> >   			ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
> > +			ent->ebx |= HV_ACCESS_VP_REGISTERS;
> 
> Do we need to guard this?

I think so, check should be added to 'hv_check_hypercall_access'.

I do wonder though why KVM can't just pass all unknown hypercalls to userspace
instead of having a whitelist.


Best regards,
	Maxim Levitsky

> 
> 
> Alex
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





