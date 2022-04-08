Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22204F9D2A
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 20:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiDHStT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 14:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239652AbiDHStG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 14:49:06 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC522250E;
        Fri,  8 Apr 2022 11:47:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id f3so9116850pfe.2;
        Fri, 08 Apr 2022 11:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C2cc8wDJI0KHhnhWBlNuXjLuYFkrSLE6YzwNDqHiY9U=;
        b=hqTxJ0bjpw0pPvqi5vhiOWx/NiKic1/B1QejDn3Jr3wHL+aXwVcj4vdPfukB7Hb/wc
         nRJ+kCQy7ASXwhGLmESZilROhTwIdpvXlSuuJUoLuvXqcg0/Ojp/LNTfr6PJsalKr7Dh
         WRe2JDVzfIwiT2EZPT8xP4+X9ZmeO2fO2oGSotYLjm4ZNkmM+P+C+UMNAgEP+0FfOdNX
         d8mHscY8CZ7cBq16KcgCQR8gj/3QRqqxZ+voJ3PaSNx7Ljp7HqjKPo0MeOhhZ6awlYu0
         /x6c30WZq7GcRygPqol0A083dNKCMs+peYkS1uQFmfBrz1fuGmZaxL8Aj4wQPYY2e8Gf
         TsTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C2cc8wDJI0KHhnhWBlNuXjLuYFkrSLE6YzwNDqHiY9U=;
        b=F4RFdCkwdkqVbOij10mTqi4aV69UzKGkIxdIwepFfatSCAmWCBD/1ADW6F6S96H3g0
         2Mw9FZ4rgW5b3yWkLgKUDPtdqwGVvve0WgGt/okQ89mEHDzHrEsJa5ERb0UAgXVtDtWa
         uZen12tdbSa9KJQX/9KbjGe36FcQRRzC6aW+exVkK0DrWlAGoa4Rwn73Q5rWMEDnj8Xn
         5jfKK6CORDKxOORS4wRcEJQP9Y+WSJ0gpsE8ouuES1dPCb7cZCQMveeY5yO7448BDjcy
         kf0tiU+KsSNNes3H5Lk3YyHRg4Hbj3VY6yPHfUmnH78JZjn5clYm5YhT8hT6Jzvx+x7P
         QTmA==
X-Gm-Message-State: AOAM5330aQH53XmPbBhZPfrsRo/P/oNjwBoR1kuix/VZqVRaQVUATYa7
        Y0pGOmDg9WqRIyn1xeK30N4=
X-Google-Smtp-Source: ABdhPJwle6zXb31FX5HJQB6fyFPDUniiwEmOw6/c0onKwA7DCmybjeepv5BBL7wgT1geOJylAcAinA==
X-Received: by 2002:a63:9d07:0:b0:398:9594:a48f with SMTP id i7-20020a639d07000000b003989594a48fmr16863035pgd.51.1649443620862;
        Fri, 08 Apr 2022 11:47:00 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id i2-20020a625402000000b004fdf66ab35fsm19017201pfb.21.2022.04.08.11.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 11:47:00 -0700 (PDT)
Date:   Fri, 8 Apr 2022 11:46:59 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 042/104] KVM: x86/mmu: Track shadow MMIO
 value/mask on a per-VM basis
Message-ID: <20220408184659.GC857847@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b494b94bf2d6a5d841cb76e63e255d4cff906d83.1646422845.git.isaku.yamahata@intel.com>
 <84d56339-4a8a-6ddb-17cb-12074588ba9c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <84d56339-4a8a-6ddb-17cb-12074588ba9c@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 05, 2022 at 05:25:34PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > +	if (enable_ept) {
> > +		const u64 init_value = enable_tdx ? VMX_EPT_SUPPRESS_VE_BIT : 0ull;
> >   		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> > -				      cpu_has_vmx_ept_execute_only());
> > +				      cpu_has_vmx_ept_execute_only(), init_value);
> > +		kvm_mmu_set_spte_init_value(init_value);
> > +	}
> 
> I think kvm-intel.ko should use VMX_EPT_SUPPRESS_VE_BIT unconditionally as
> the init value.  The bit is ignored anyway if the "EPT-violation #VE"
> execution control is 0.  Otherwise looks good, but I have a couple more
> crazy ideas:
> 
> 1) there could even be a test mode where KVM enables the execution control,
> traps #VE in the exception bitmap, and shouts loudly if it gets a #VE.  That
> might avoid hard-to-find bugs due to forgetting about
> VMX_EPT_SUPPRESS_VE_BIT.
> 
> 2) or even, perhaps the init_value for the TDP MMU could set bit 63
> _unconditionally_, because KVM always sets the NX bit on AMD hardware. That
> would remove the whole infrastructure to keep shadow_init_value, because it
> would be constant 0 in mmu.c and constant BIT(63) in tdp_mmu.c.
> 
> Sean, what do you think?

Then, I'll start with 1) because it's a bit hard for me to test 2) with real AMD
hardware.  If someone is willing to test 2), I'm quite fine to implement 2)
on top of 1).  2) isn't exclusive with 1).
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
