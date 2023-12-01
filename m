Return-Path: <kvm+bounces-3144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B91E9801027
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74F822819F5
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5309A4D5A2;
	Fri,  1 Dec 2023 16:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sb81ttRM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8A7193
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 08:32:22 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5c62c98f682so724046a12.2
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 08:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701448342; x=1702053142; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/K7HE0EB9COwZnWNHAn0RCBpw/EJerDEKjS1XCTH01o=;
        b=sb81ttRMy+4zDNQ3pBlsxtaovroVp6bOprAEQjGOKZqjl1VlY+AH9qes2XuFym/dfG
         6CuzeVxgDSh9s0x9SwuRY13U5jo+e2pb6iECKRbtETREHex7+URnpkgizRdvBlz1HXTW
         76EyyQiNlpCB4mzeGDYPdrwL5DaneL/LhpWQpBczUPRDmyQYZnrX0syjuG/4EQ01t97R
         SHPpnoajTXJ6aBkl5urglMFAJ/1iIU0lNpMN6zmXGl8X4HZUCkhXPPnT8hMRI4NbKcYl
         JtcD83MLhirCDMETTLLZJEN7n5PAUn/i8+b4fZp2csdMq4EL0J4/GdFNWwm6osa5slxq
         p/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701448342; x=1702053142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/K7HE0EB9COwZnWNHAn0RCBpw/EJerDEKjS1XCTH01o=;
        b=kB402TWvFWE2cW4/kXlVqROGLbEhPUouE/m0acHHsOUdiuNay9jslYyoPOghNBpdGT
         CMLCF9Lx60h3UeTcWCtilnDxav1K3qwl+eThR69nbnCR3UdS1aYadGEhDBmDwDCOCA+m
         Dk1kiVexP7Yciw/U/feQXVvFDgVVRiCJBJF2DC9RR5xKXfKKQIWtuGz7dGVxLhgLwBq4
         G5JHcSYDfZhN82qOJ8HXdEhLwBhjzhgqNw58z+XSEqin0C2SR6AGqcf2qjNqCDuEyeOm
         +H2ZeQN6+34xJg490rFO3V9UBlb3sYRCKRBqNilYy7SlyyNnsP3KVV9X3KotbcY7CRka
         /UuA==
X-Gm-Message-State: AOJu0Yw0JUNoJsYE8s05SXq+G6eFLg7D+MNREauiaDmE6eiKQgZ2PCMo
	5+Y2TIKGwlJGB7u4jxpCF8V434Qisn8=
X-Google-Smtp-Source: AGHT+IH1lYPeVLhg1fK/372dKtjjpuPIbf/djPz/KyZw6BQ3OgmjhAtwIR2bi7SaI0dtlhyObZ26zc2sufk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:211f:0:b0:5bd:bbb4:5275 with SMTP id
 h31-20020a63211f000000b005bdbbb45275mr3949230pgh.10.1701448342043; Fri, 01
 Dec 2023 08:32:22 -0800 (PST)
Date: Fri, 1 Dec 2023 08:32:20 -0800
In-Reply-To: <CXD4TVV5QWUK.3SH495QSBTTUF@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108111806.92604-1-nsaenz@amazon.com> <20231108111806.92604-6-nsaenz@amazon.com>
 <f4495d1f697cf9a7ddfb786eaeeac90f554fc6db.camel@redhat.com> <CXD4TVV5QWUK.3SH495QSBTTUF@amazon.com>
Message-ID: <ZWoKlJUKJGGhRRgM@google.com>
Subject: Re: [RFC 05/33] KVM: x86: hyper-v: Introduce VTL call/return
 prologues in hypercall page
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
	anelkz@amazon.com, graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com, 
	kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com, 
	x86@kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 01, 2023, Nicolas Saenz Julienne wrote:
> > To support this I think that we can add a userspace msr filter on the HV_X64_MSR_HYPERCALL,
> > although I am not 100% sure if a userspace msr filter overrides the in-kernel msr handling.
> 
> I thought about it at the time. It's not that simple though, we should
> still let KVM set the hypercall bytecode, and other quirks like the Xen
> one.

Yeah, that Xen quirk is quite the killer.

Can you provide pseudo-assembly for what the final page is supposed to look like?
I'm struggling mightily to understand what this is actually trying to do.

