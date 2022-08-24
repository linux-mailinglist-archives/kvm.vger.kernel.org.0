Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616345A04D7
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 01:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiHXXuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 19:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiHXXuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 19:50:13 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF23E0E5
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 16:50:07 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso3223307pjl.1
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 16:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Rtwz6fTrcBg1TFOL4QPsRuemhonZKT/5mDP1AugotzM=;
        b=E7AVGBdju1UilU2hXPAD9L9HDIi8n4+7AYJ4RUcSBRnETl2cJwY+/KYkuRgm9hjPxq
         5sJeOck29St3C8/W/HJNzpu90bBcuMtKeoAxYdB1ONfwbA+3opFpQdjIsMWUue28wonP
         reaMSiF8olj9of04DketTD+5jIg69xEPL4dzNbo56JQmiAcjkQlxK9B7yJnSW/jFX/6c
         XB+5P1f1Gs0cjTJ5gdnmBD2Td+Hmp0GlikNorn79ayUxu99bTuzp/YY7ajNFjIA4CO7C
         UjCIcYx+FTpVEUT/+/E1jqkzZYkS2fq84cw4HBhShBBfE/jPEJI//fqKpq4X9WOOYBrf
         +5ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Rtwz6fTrcBg1TFOL4QPsRuemhonZKT/5mDP1AugotzM=;
        b=CjtgYHmxLUednSc19hsHSHsyyMNIn1zDC+ndM4ITWlnHiO7EibXFd+i1MzBVLzwt1R
         FuRZRC3/YH0w9mFo2xohDtM0Pnqe3WsKZeX1HXCmPEXy49nABJ7AIFi4qMcG/B1P1hpB
         gDB4GURpnIDgt+2t6VVcbo/8sg/GaJbwnQ8Xntd6yJhg1NhA0uBLQX+8B5G2F7S+76Wn
         ukzppUO0zAS9qBXw/pmZGb7wgS3ztNjraup81DNOJuc6Bn4Rc/vjepAXljRNbLEX80Nf
         dSDRIgaZjhb06c/XffIFs2ZErGK0TZQK2DVNK97g0cT5+ac9MpK7t95CnPBA45tBeAI2
         D3Iw==
X-Gm-Message-State: ACgBeo1PuytxweDTaaOxKd7A9qQYFCMohf65DLYbPmEzu0yEFePj7b4L
        S9b5UIBRSPBOJpA+J8+XXl8XvQ==
X-Google-Smtp-Source: AA6agR4fl4nEP7dCRJhxPprT2MslA2V+Sjpudndncruk7Aw8ByEaiFr52iVnF3+aNwZiEzdhhorhkA==
X-Received: by 2002:a17:90b:4b8d:b0:1fb:4def:1fc1 with SMTP id lr13-20020a17090b4b8d00b001fb4def1fc1mr1528016pjb.121.1661385007388;
        Wed, 24 Aug 2022 16:50:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n3-20020aa79843000000b005368341381fsm7842821pfq.106.2022.08.24.16.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 16:50:07 -0700 (PDT)
Date:   Wed, 24 Aug 2022 23:50:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 13/13] KVM: x86: emulator/smm: preserve interrupt
 shadow in SMRAM
Message-ID: <Ywa5K3qVO0kDfTW9@google.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
 <20220803155011.43721-14-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803155011.43721-14-mlevitsk@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022, Maxim Levitsky wrote:
> @@ -518,7 +519,8 @@ struct kvm_smram_state_32 {
>  	u32 reserved1[62];
>  	u32 smbase;
>  	u32 smm_revision;
> -	u32 reserved2[5];
> +	u32 reserved2[4];
> +	u32 int_shadow; /* KVM extension */

Looking at this with fresh(er) eyes, I agree with Jim: KVM shouldn't add its own
fields in SMRAM.  There's no need to use vmcb/vmcs memory either, just add fields
in kvm_vcpu_arch to save/restore the state across SMI/RSM, and then borrow VMX's
approach of supporting migration by adding flags to do out-of-band migration,
e.g. KVM_STATE_NESTED_SMM_STI_BLOCKING and KVM_STATE_NESTED_SMM_MOV_SS_BLOCKING.

	/* SMM state that's not saved in SMRAM. */
	struct {
		struct {
			u8 interruptibility;
		} smm;
	} nested;

That'd finally give us an excuse to move nested_run_pending to common code too :-)
