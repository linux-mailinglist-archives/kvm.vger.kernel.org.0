Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77214549CDA
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346280AbiFMTGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347727AbiFMTGh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:06:37 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3B7BA545
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:57:53 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so6513287pjg.5
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6WnBXAP3VJw9uo1dqMEWnA7hq53QXaDQK+ygpUYK+m8=;
        b=bbkJ8UyYSGZYDx5BMTxVXton0rczQTlxOhqDSn42p8Is+DZniRdmnS2EkoAaSN45A8
         r7Rhb122NbGhNB+JA21XegJj5Nq2k/cGbBuRIYTDeSoJairL8lvjO+FfAx/jtANPKzbK
         FlG7i1dPB4lI4A40XFGmFKaadrh2PDtyEP5VqDVnAS8EblnN3I8LVzsVNE8JE8w/fpyX
         xO58AmRGoaWRiXOMVD1xVpWHPyKHLqLGof0XMigMIuloGIJkRXAzIubhkvVcZiib+dOj
         kygUxV93Sn4xDBlNFlemRFtOGksWtrl9K14NHZv785eoaJwzt2N6FoNFQWAay72XQwDi
         nHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6WnBXAP3VJw9uo1dqMEWnA7hq53QXaDQK+ygpUYK+m8=;
        b=WzdYlqZlSazKKqjyWnlVLLyYVhiTgTg8y54ZjFpAd2XXa/izaRtTqtAnhl3pmHjXGm
         uSQQAqWGJ++N7QKE5z9XT7JACiB+XxwNsooFJX7uQjTJCAmzbmn5n4AmDiefmdXwaeJC
         6dcmb5XSdv+F6s/reTKhW03CijMx+k9ODUj4bKz73XSdnBKy+JNpiDVE4LaphDI7kIzF
         zdAl+ocYhCQjGX8GBLVSmtm9QtjVde64jCFk0jCKrfM7oPktx+VRghvd4QKUJXQQqZAR
         q9BliKByBM7m3IwqafGwtd5L/ntb8Ma0S5u5oMZm1/B+0VB/GPTOtCR/ifX/9aha5aRP
         VIgQ==
X-Gm-Message-State: AJIora8vgOTnpmGyqACteVtrgjiXe2wzBHvrszn3uS2ffFPorOCqLLtl
        4xeC9mwf1jyjn8ByyDyQ4RzyVg==
X-Google-Smtp-Source: AGRyM1ufnTxIPxw3raWH4v1l5QStubOuXiPZsultTxaadqd10byXlrFmiBHZH+28wbycCnFFShzPtQ==
X-Received: by 2002:a17:90a:bb92:b0:1e2:f8a0:b0cf with SMTP id v18-20020a17090abb9200b001e2f8a0b0cfmr783062pjr.28.1655139473236;
        Mon, 13 Jun 2022 09:57:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id jg21-20020a17090326d500b001679a4711d9sm5369338plb.162.2022.06.13.09.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 09:57:52 -0700 (PDT)
Date:   Mon, 13 Jun 2022 16:57:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
Message-ID: <YqdsjW4/zsYaJahf@google.com>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
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

On Mon, Jun 13, 2022, Paolo Bonzini wrote:
> On 6/13/22 18:16, Anirudh Rayabharam wrote:
> > +	if (!kvm_has_tsc_control)
> > +		msrs->secondary_ctls_high &= ~SECONDARY_EXEC_TSC_SCALING;
> > +
> >   	msrs->secondary_ctls_low = 0;
> >   	msrs->secondary_ctls_high &=
> >   		SECONDARY_EXEC_DESC |
> > @@ -6667,8 +6670,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
> >   		SECONDARY_EXEC_RDRAND_EXITING |
> >   		SECONDARY_EXEC_ENABLE_INVPCID |
> >   		SECONDARY_EXEC_RDSEED_EXITING |
> > -		SECONDARY_EXEC_XSAVES |
> > -		SECONDARY_EXEC_TSC_SCALING;
> > +		SECONDARY_EXEC_XSAVES;
> >   	/*
> 
> This is wrong because it _always_ disables SECONDARY_EXEC_TSC_SCALING,
> even if kvm_has_tsc_control == true.
> 
> That said, I think a better implementation of this patch is to just add
> a version of evmcs_sanitize_exec_ctrls that takes a struct
> nested_vmx_msrs *, and call it at the end of nested_vmx_setup_ctl_msrs like
> 
> 	evmcs_sanitize_nested_vmx_vsrs(msrs);

Any reason not to use the already sanitized vmcs_config?  I can't think of any
reason why the nested path should blindly use the raw MSR values from hardware.
