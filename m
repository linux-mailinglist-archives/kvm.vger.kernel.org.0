Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5E653FFBC
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 15:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244492AbiFGNMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 09:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244484AbiFGNMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 09:12:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47F3E26D0
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 06:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654607533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9btwV5h8ptlMevpkwB1eHlF3KzuEFXT7bT70FrlkmYo=;
        b=aF5f2xVrkAC46+7d+wi6wLLa/bRrZ927vXem16N51JolEgSBDt0iZHzfBfPPDGY69u5qL3
        4RVH9HYxgDSYwSaT15F984ZgAbLgJmxZml4d15AaKvnu1guXOVb8NiHbLeRFsjr9w9Itzx
        ic6NZJcS4eFKex2OyXx6sKIpMwTdaC0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-yvYgoGBvMHybaTSJy6yHEg-1; Tue, 07 Jun 2022 09:12:12 -0400
X-MC-Unique: yvYgoGBvMHybaTSJy6yHEg-1
Received: by mail-qk1-f200.google.com with SMTP id bp18-20020a05620a459200b006a6a7b1f0acso8181278qkb.13
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 06:12:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9btwV5h8ptlMevpkwB1eHlF3KzuEFXT7bT70FrlkmYo=;
        b=o7w+Vd7uceK1AwptpdQ4Ud4KyH95OUodgnSeSUU58XRE7Wyx9x3uITHuSPgiO218WE
         +EWEifaK/Xf+dVpllMS2pOO0N3tttoMUuajyPV4H4B4gzeF5UdPvH1G8AOEpDow1UROA
         1W4aa81DaTsryyLkhFn9l7zRuCqbUAmhnnAF1xhHoQ2A3p22IZZ5Z9xv4qTMz9uO6RlA
         naHgLTFlQUkg1t/XJVVq4NYuzjb/UJQSmNyCwNttQgeCkQ5u9bQEDVKlzXMApdY1ZEYN
         csBqi6rsOc8TaTmwEHZkszZXVt6zVOHAHgMA96LznGVw0MKl8A5JcoIb+KfJ5AuCdlLQ
         +m5g==
X-Gm-Message-State: AOAM533vUTzcVAbXtnn7rsTeqxQwpStsT4CwuxAX9HSUM0uAx8eC8ufk
        AUfZLWvd2V2b4KNM6zhXOBGD6VecqX3pBJs7PYKMTj/oBgNm3WCHI9Yg1hzAzVSt4qjguOZKaJH
        AQiOfvFipoynf
X-Received: by 2002:ac8:5b56:0:b0:2f3:eb25:910e with SMTP id n22-20020ac85b56000000b002f3eb25910emr21765650qtw.616.1654607531785;
        Tue, 07 Jun 2022 06:12:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgRxov7esT5ohMTS6e7S7z/0M9eKjObmAkoEzTAIFijN8q1p+yBedH4yEcAFlw5AKUHzN/eQ==
X-Received: by 2002:ac8:5b56:0:b0:2f3:eb25:910e with SMTP id n22-20020ac85b56000000b002f3eb25910emr21765618qtw.616.1654607531527;
        Tue, 07 Jun 2022 06:12:11 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id z22-20020ac87116000000b00304f7449e17sm1439142qto.93.2022.06.07.06.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 06:12:10 -0700 (PDT)
Message-ID: <45e9ccafcdb48c7521b697b41e849dab98a7a76c.camel@redhat.com>
Subject: Re: [PATCH 4/7] KVM: SVM: Report NMI not allowed when Guest busy
 handling VNMI
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Santosh Shukla <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 07 Jun 2022 16:12:07 +0300
In-Reply-To: <da6e0e9375d1286d3d9d4b6ab669d234850261eb.camel@redhat.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
         <20220602142620.3196-5-santosh.shukla@amd.com>
         <da6e0e9375d1286d3d9d4b6ab669d234850261eb.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-07 at 16:10 +0300, Maxim Levitsky wrote:
> On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
> > In the VNMI case, Report NMI is not allowed when the processor set the
> > V_NMI_MASK to 1 which means the Guest is busy handling VNMI.
> > 
> > Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index d67a54517d95..a405e414cae4 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3483,6 +3483,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
> >         struct vmcb *vmcb = svm->vmcb;
> >         bool ret;
> >  
> > +       if (is_vnmi_enabled(vmcb) && is_vnmi_mask_set(vmcb))
> > +               return true;
> 
> How does this interact with GIF? if the guest does clgi, will the
> CPU update the V_NMI_MASK on its own If vGIF is enabled?
> 
> What happens if vGIF is disabled and vNMI is enabled? KVM then intercepts
> the stgi/clgi, and it should then update the V_NMI_MASK?
> 
> 
> 
> 
> > +
> >         if (!gif_set(svm))
> >                 return true;
> >  
> > @@ -3618,6 +3621,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> >  {
> >         struct vcpu_svm *svm = to_svm(vcpu);
> >  
> > +       if (is_vnmi_enabled(svm->vmcb) && is_vnmi_mask_set(svm->vmcb))
> > +               return;
> 
> This might have hidden assumption that we will only enable NMI window when vNMI is masked.

Also what if vNMI is already pending?

Best regards,
	Maxim Levitsky
> 
> 
> 
> > +
> >         if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
> >                 return; /* IRET will cause a vm exit */
> >  
> 
> 
> Best regards,
>         Maxim Levitsky


