Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288D664D4A1
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 01:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiLOA1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 19:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiLOA1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 19:27:00 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4752C100
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:26:57 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d15so5163772pls.6
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rcunyvgXRo9j9kE9DbU9rjLVqCuJrVTsarGP4SUpt9I=;
        b=AkELxn+C0aGIiYzI5u8ykRdKZ2n/3pH2iGZitGEuDr+B18Z3jg3g7h9eZhahNUn7wV
         qRzqcoVvCMuOI2+zn1z3+dGE10G1uayMxuCtJfZeeKHo1iOZgXi8m6MWuc1j6JZTE0zB
         4+zXarar1zu5pDOpX4SWN6/8wXmy1nGyO7Q2JhdAjqm43EmoHLzg+D63t5oirgZODYlq
         vVmkC0EQKW1llysKttuTpzJhoNv/lBRC8625c6LbvaE62+cHxQ5PY9qAKLqeVPxjpq0d
         sCLj52EOWISgzdnejXzSiuDYBvcPxvAbrv1OtJXMtL3KWOBG4G+UUW+wz17qwI5fkt6I
         gvCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rcunyvgXRo9j9kE9DbU9rjLVqCuJrVTsarGP4SUpt9I=;
        b=6p5MdJb44X2QnDgo4UFByLEf15sTecPJvT1cbfFGDuZceE6qyQHtzRqiyVVM0nqqHa
         KN4bmr7IAKLgDWZPIF74gHozlYf9MB550/itKwCKTUz539WBOON5ibSaldR2jep7hsP8
         Facunm2OFEKrc5dofAUW+w83XHxW6vwSHfD8aizANQ75VruDq7HiRMbemZScgfcE6GET
         6IuhpC7Ng+dZjCyUTnhPdvMH27KOikhYxrVTu+HGjFZJ9c9Y5b44DTJViMD6JpcbpnsE
         d88G2m7JLxGwp6QEUIC4kaBdwCfIZ62e1ic1b3Y5W5h1Q209NqxyCS2W7wN7/4MS+j9j
         Varg==
X-Gm-Message-State: AFqh2kobDjxMbfnj9mE+156AshPRWYZZTqeUMLeJ3vzNOLReK+TlwWIf
        b214rJDLy0X1f03mLn9juUgzMw==
X-Google-Smtp-Source: AMrXdXvZLFTTMYZOrc2CMZeYZitNAcQNgAW1T2i6WTGcbITzYZT4JNRmhbR1n3ESIPKZsooaZzUPrQ==
X-Received: by 2002:a17:902:b187:b0:189:58a8:282 with SMTP id s7-20020a170902b18700b0018958a80282mr656357plr.3.1671064017325;
        Wed, 14 Dec 2022 16:26:57 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jj7-20020a170903048700b00189fdadef9csm2439889plb.107.2022.12.14.16.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 16:26:55 -0800 (PST)
Date:   Thu, 15 Dec 2022 00:26:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/7] KVM: VMX: Provide separate subroutines for invoking
 NMI vs. IRQ handlers
Message-ID: <Y5ppzEEqFB1XqhoJ@google.com>
References: <20221213060912.654668-1-seanjc@google.com>
 <20221213060912.654668-7-seanjc@google.com>
 <BN6PR1101MB2161B2CB247273CDD85F4C19A8E09@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR1101MB2161B2CB247273CDD85F4C19A8E09@BN6PR1101MB2161.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022, Li, Xin3 wrote:
> > +
> > +	/*
> > +	 * "Restore" RSP from RBP, even though IRET has already unwound
> > RSP to
> > +	 * the correct value.  objtool doesn't know the callee will IRET and,
> > +	 * without the explicit restore, thinks the stack is getting walloped.
> > +	 * Using an unwind hint is problematic due to x86-64's dynamic
> > alignment.
> > +	 */
> > +	mov %_ASM_BP, %_ASM_SP
> > +	pop %_ASM_BP
> > +	RET
> 
> For NMI, after this RET instruction, we continue to block NMIs. IRET instead?

No, IRET has already been done by the kernel-provided handler, e.g. asm_exc_nmi_kvm_vmx()
by way of error_return().  That's why the CALL above (that got snipped) is preceded
by the creation of a synthetic NMI/IRQ stack frame: the target returns from the CALL
via IRET, not RET.
