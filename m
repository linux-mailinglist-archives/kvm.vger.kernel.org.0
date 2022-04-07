Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EDE4F8219
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 16:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344244AbiDGOvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 10:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiDGOvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 10:51:00 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A1DBD8B1
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 07:48:41 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id e8-20020a17090a118800b001cb13402ea2so1988327pja.0
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 07:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xTAdH7bvajIuFt6h+olEW4JO3CVC81fz3OwWMJAT8VE=;
        b=DCm5Tc/yyjMbLdElqppH356pwNOj1UjgYHWs8iyAsgdb2oSyHZYCzxV+kxiCxzRtXB
         5YlQDcRKt07jpmdfkRo0VF2iVjs3+tUrp8ljDDyBYxZvp30e+3ZFONzHa09czmL/IxIW
         hbIX0LUrA3Vkeqe4RBCNfcrEAd/ljBzCMWJNGFQFZ7jdN75kT5D45LdSQLqG/dimnMh0
         1neuqsLF7T8cDW8b/QKOrfj6Qm9GthyZh4qwyjlCHWxkn0bmIoZdR8oOG4khhpGw0+Qh
         OUVN9NcVKBe4ACa9YhCd3+tDgW15zBOsSdEVlsUr4pld2/SpD2euKuragp+l/Zk52p8h
         s5wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xTAdH7bvajIuFt6h+olEW4JO3CVC81fz3OwWMJAT8VE=;
        b=ypigo7Wrm8er67BFT2MfL0XUxab3KnGh0KofvVe9khRLypIZCokY6tmdirdV7lRrLl
         2QU96AaRyPYUlkjeG1LaJPvUmWDeWLvSOFimGRJgFpWOyVdZ6cn1sLAw5EM6czWeAk0/
         9GXrD+MrelSrYfJ8P1hx9zMYdx+/lH1qUsYwfi+jB0gIWQoL2iTWHO7kKJQpFgOChyxM
         IgvuUrAK9jq5dol8zkZJsqx+q1sYaEHL7/YfCqChcTH9Fnyqn4+iy6npytn7A9M/g1O8
         QNi2egd2FcmHDPVX06i8jL9Ck6KMQRKRpdo27LXZ/WqPhJV/fNG0+lPiNp40h2Nvi9iR
         kaZw==
X-Gm-Message-State: AOAM533TosdeT+wsmAGl6OyksV2o5gFqX7BYLSWcO8/pGJAV2FvUJp0q
        /baKBSAf1K4icAq2o+6jlXSmUg==
X-Google-Smtp-Source: ABdhPJyksTyJ2T8rwlo6ws0r7KZJUOS4bheICXISshsSc296OQyvPoQDgo6muuyBkRwK4ZNTbQf35g==
X-Received: by 2002:a17:902:ce82:b0:156:bb3c:3297 with SMTP id f2-20020a170902ce8200b00156bb3c3297mr13889455plg.159.1649342921065;
        Thu, 07 Apr 2022 07:48:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p4-20020a637404000000b00375948e63d6sm18878717pgc.91.2022.04.07.07.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 07:48:40 -0700 (PDT)
Date:   Thu, 7 Apr 2022 14:48:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 091/104] KVM: TDX: Handle TDX PV CPUID hypercall
Message-ID: <Yk75xJjUghPTjTjT@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <e3621e9893796d2bd8ea8b1f16c1616ae9df3f37.1646422845.git.isaku.yamahata@intel.com>
 <adea5393-cbe9-3344-0ef5-461a72321f72@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adea5393-cbe9-3344-0ef5-461a72321f72@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022, Paolo Bonzini wrote:
> On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Wire up TDX PV CPUID hypercall to the KVM backend function.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/vmx/tdx.c | 27 +++++++++++++++++++++++++++
> >   1 file changed, 27 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 53f59fb92dcf..f7c9170d596a 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -893,6 +893,30 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
> >   	return 1;
> >   }
> > +static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
> > +{
> > +	u32 eax, ebx, ecx, edx;
> > +
> > +	/* EAX and ECX for cpuid is stored in R12 and R13. */
> > +	eax = tdvmcall_p1_read(vcpu);
> > +	ecx = tdvmcall_p2_read(vcpu);
> > +
> > +	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
> > +
> > +	/*
> > +	 * The returned value for CPUID (EAX, EBX, ECX, and EDX) is stored into
> > +	 * R12, R13, R14, and R15.
> > +	 */
> > +	tdvmcall_p1_write(vcpu, eax);
> > +	tdvmcall_p2_write(vcpu, ebx);
> > +	tdvmcall_p3_write(vcpu, ecx);
> > +	tdvmcall_p4_write(vcpu, edx);
> > +
> > +	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> > +
> > +	return 1;
> > +}
> > +
> >   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
> >   {
> >   	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > @@ -904,6 +928,9 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
> >   		return tdx_emulate_vmcall(vcpu);
> >   	switch (tdvmcall_exit_reason(vcpu)) {
> > +	case EXIT_REASON_CPUID:
> > +		return tdx_emulate_cpuid(vcpu);
> > +

Spurious whitespace that gets deleted by the HLT patch.

> >   	default:
> >   		break;
> >   	}
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> but I don't think tdvmcall_*_{read,write} add much.

They provided a lot more value when the ABI was still in flux, but I still like
having them.  That said, either the comments about R12..R15 need to go, or the
wrappers need to go.  Having both is confusing.
