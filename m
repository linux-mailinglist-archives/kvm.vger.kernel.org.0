Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF2357C10F
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 01:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiGTXpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 19:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiGTXpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 19:45:03 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A07A74378
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 16:45:02 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q16so82094pgq.6
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 16:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KU83ueWiecIonFgsOmua6688d0DkD2VFBOUlUHHUAy4=;
        b=crqyaOZ4h4DvzDOZlV8IFj5TO9FwtQgfTEFwl7cozQVhZWdxg5P1oS0n1BbIuVeFKp
         sbFQo7UrR1IARKp4/YvvT1zQw53mH8orfl2Ymz0+ZC6W5iUeJArzkbAUQqmoF/hKDrLJ
         I+y+qIEaE6fK8dVPnwEZRQ+mmk1Ns6FDHr444ik57iNKxOzMmC/H5AHvYJFYveyesD5U
         tY5Lfz5lm6GQsJ6XyfW8NPwrkb16SHYikabjdrJnYs+5peu3N+4Qwh8UimWvjFY0fc/k
         9f+ws98TNylPdg3Ci2/quhtHPmPQcZx0P4ZTki4g9R+HO07lEoUC5AaVMYi1YzPxEAZ+
         Zadg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KU83ueWiecIonFgsOmua6688d0DkD2VFBOUlUHHUAy4=;
        b=1zvqbMI9g0O/Mwq74FjNKsTG0GObfrwmw6W3LI41GZsYHbu+dsXIH3qO9tQ/KKqP6S
         WphKiaYDIubMnyP7awN3Fpw/w/xuZUxi4A2XS2RvjYUN+t6dfnj8595f5r6h9l+3EToj
         Jv2s8cbnrCNSV9hRfXSyBiy034ud90wN8DC3fQ8G+Th/UFPvQBvQnkaZu8Ws2yd35Yrj
         dkTTZgUVozMVutZn2Y434tOF295UUwvhZ1ChGBs/R5XHEBZGW4zxBVin2jLmZXipVTEz
         EiT17ADxJgWk/SFWydTzwBcJpEFBL6ifBEJg2gKlSuSFQmds6TM4NxWTBVafyOcuBRCW
         81Mg==
X-Gm-Message-State: AJIora/KMO+MIjfAlsQNrmf5XhehV1Ddl03Fl15UBbzYN8nRXJqVwQSD
        Z2Ac1bhr5WjO+Zc2WrqYILXffw==
X-Google-Smtp-Source: AGRyM1vdQBK5v2aRMnAgAs2deluNWkY6gyBVKGcHEL3CX6GnUFo74D++CqaEmv7x7kTuGW4DwqbD/g==
X-Received: by 2002:a05:6a00:2407:b0:52b:29dd:915 with SMTP id z7-20020a056a00240700b0052b29dd0915mr34501978pfh.60.1658360701446;
        Wed, 20 Jul 2022 16:45:01 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b0016be96e07d1sm128016plh.121.2022.07.20.16.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 16:45:00 -0700 (PDT)
Date:   Wed, 20 Jul 2022 23:44:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 02/11] KVM: x86: emulator: introduce
 update_emulation_mode
Message-ID: <YtiTeZQ/n0LPTV/W@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
 <20220621150902.46126-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621150902.46126-3-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> +static inline int update_emulation_mode(struct x86_emulate_ctxt *ctxt)

Maybe emulator_recalc_and_set_mode()?  It took me a second to understand that
"update" also involves determining the "new" mode, e.g. I was trying to figure
out where @mode was :-)

> +{
> +	u64 efer;
> +	struct desc_struct cs;
> +	u16 selector;
> +	u32 base3;
> +
> +	ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
> +
> +	if (!ctxt->ops->get_cr(ctxt, 0) & X86_CR0_PE) {
> +		/* Real mode. cpu must not have long mode active */
> +		if (efer & EFER_LMA)
> +			return X86EMUL_UNHANDLEABLE;

If we hit this, is there any hope of X86EMUL_UNHANDLEABLE doing the right thing?
Ah, SMM and the ability to swizzle SMRAM state.  Bummer.  I was hoping we could
just bug the VM.

> +		ctxt->mode = X86EMUL_MODE_REAL;
> +		return X86EMUL_CONTINUE;
> +	}
