Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB33E4C905D
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 17:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbiCAQcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 11:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236208AbiCAQb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 11:31:59 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7428D5C667
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 08:31:15 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id m13-20020a17090aab0d00b001bbe267d4d1so2213454pjq.0
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 08:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6jVdVhZ/PX1RQ+F2J/N7Wi0Epu+QUrcTFuFOjJu3yvg=;
        b=EiyC3jiQYZWgQziJlTfFIb9km0pyKksaEl018V+KwL+9NwfefWny7QIjtTju1hcH8E
         zFFC5tdrAieXovAiXyYHe5OloYzfsUeLYK/ZWFZ4IgOShHk+G0nRzG/G7+XBU4oj/LM6
         m864fHcNwh3qt303r6oTcwO0x2KWNruxeCWQfmyElTro4rroTBoUd9FyfVmyLZXsePQB
         Dl55BFoPqpsUbyyDo6B3U2m66AVEabkaRCCKM7c8wcqRCTuWiDzV8i3dZTuTa3FKtSqg
         EZi2+FsqpCP9v0c8LK0bZES6dEiKbTKMbIhA2XywlKzAnYMhYi1H9QJ+lUG/+Z8PmJb7
         H3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6jVdVhZ/PX1RQ+F2J/N7Wi0Epu+QUrcTFuFOjJu3yvg=;
        b=S9O9/m/9MFSUHz5hiYShSRCHOMmIdhsJok6BEadFt0/JGGujrvAAtGTxskDyvIZVZn
         IJpnkRQmWVF3cH1Ei0XOYexml/U2f3WH95lZWDn3mZejWznvS8OJmVo2Rz51AD/9Gy0M
         QK5kxwQF5V1yaCkApq9Fj7CDDnGpGF42E3Dar69aJpBqZDa1u+qpY+8cjBdRzxREOQ27
         ZTr5wAlhFf86MVKx2Ibse1LShJk5yyrkPsqVYlUi12yBKgRUNtM6wfngIY1CCiP8PsGb
         gVblOEscvIm2iNag024qk1s1bqO4+wEYwHYKfAPAQTy286DoyaBK6HJTOdZxfOMWPnd6
         cFCw==
X-Gm-Message-State: AOAM531ZGsurNYGaxRl5pBS93tWcBhmtuf5MMxdL0oSmlazxpL+Z8ZWM
        lWlpN/BbthTrCgQoHg1v8CCdCg==
X-Google-Smtp-Source: ABdhPJwRhnOCWVs+nTyAnV4Bkol2CdMiJ1PzAB3dyOjKWluh1b+oelAli3twkYxK5O5lIJguP3uCNw==
X-Received: by 2002:a17:903:310d:b0:151:6d4b:a274 with SMTP id w13-20020a170903310d00b001516d4ba274mr9655599plc.130.1646152274727;
        Tue, 01 Mar 2022 08:31:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c7-20020a056a00248700b004e1dc9aeb81sm18836302pfv.71.2022.03.01.08.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 08:31:14 -0800 (PST)
Date:   Tue, 1 Mar 2022 16:31:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Subject: Re: [PATCH 1/4] KVM: x86: mark synthetic SMM vmexit as SVM_EXIT_SW
Message-ID: <Yh5KTtLhRyfmx/ZF@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
 <20220301135526.136554-2-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301135526.136554-2-mlevitsk@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022, Maxim Levitsky wrote:
> Use a dummy unused vmexit reason to mark the 'VM exit' that is happening
> when kvm exits to handle SMM, which is not a real VM exit.

Why not use "62h VMEXIT_SMI"?

> This makes it a bit easier to read the KVM trace, and avoids
> other potential problems.

What other potential problems?

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7038c76fa8410..c08fd7f4f3414 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4218,7 +4218,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>  	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
>  	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
>  
> -	ret = nested_svm_vmexit(svm);
> +	ret = nested_svm_simple_vmexit(svm, SVM_EXIT_SW);
>  	if (ret)
>  		return ret;
>  
> -- 
> 2.26.3
> 
