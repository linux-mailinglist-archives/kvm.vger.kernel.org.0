Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D824646338
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 22:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiLGVZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 16:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiLGVZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 16:25:42 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BDE81DA4
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 13:25:41 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so2668545pjp.1
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 13:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n7Wqad3a8IV5+ECQhv7lWrLN4DRro+qo2JkXKZnEYlk=;
        b=aA9X9Fd7k9K0PV7K3Z3gnZwSu8VOuiCOXNS6E8bHwHi6cg1VJ+PCAG375nLpa9ng78
         W2ZwL2eG/vrKXXQRZFJMZHpnSMUkBFF3L27LwIHGNS90X14+Ef0jl6h9smk/ows9PeZ/
         KpLm6WfIMp4xVPMerzBCsNnDWznbZp9wwf1VAn6CKSjWpeHnk+i/XyMgNtQI1+JK5cFz
         fSIHo0SHR1CB+sDox/cABXVK2iDaTIxBCKvgDiIQ7PeMh6YK+IVOTsJhDwTqvcYJ1v/9
         znol9s8Hikopre/rr1erAQdY0rA+DJc/9zNLS4Chk3hF3sOFNwaCTgSN47yLRAmjHd+H
         0VPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n7Wqad3a8IV5+ECQhv7lWrLN4DRro+qo2JkXKZnEYlk=;
        b=qtSL7DguYsPe7M/nT2ddiiLz+FsKocuaZh+d2mpL1xpK6Kgf+vuWs4telAYXleUV+f
         Rjw1IKRGyTjzKua4Xsgy6ZiESCG39Qd7ZAE/pWLyTOnmhXopY2+mLmVyZ4okdMPQmT2U
         9jPh2UG77S8q8OQJ/etYTs1g0mduSUtHDw+TQa+bDZHt0ETUwfbse3RRsyKLMmolbTUu
         nDLMAn77DLXMju9jDRG9MSKsoVZxI1gXYdU/cXftPCv8PzX5Uc8le66Ey9yEyhfCPq0W
         kYQz5ycmh+B/F6iAq5hxraue95au643fR1Le51cxUykhX6iorjdgSG9OaBx+Ifag1skE
         T1xA==
X-Gm-Message-State: ANoB5pn8wjL97jgr7/CIFe5eqgiW0hwY5g4nOu6yrnl1mrPUsnSaTHZv
        +jBsSAwuyWN+c67cYD/Ht35PqA==
X-Google-Smtp-Source: AA0mqf41RecvyUijjUGjKliHLNPG9FPRbNNOgwX4eGv1lZljQ1dLvQnmSxhSfIejb2l/XPFBc1KQwg==
X-Received: by 2002:a17:90a:5641:b0:219:c2f2:f83c with SMTP id d1-20020a17090a564100b00219c2f2f83cmr725499pji.2.1670448341034;
        Wed, 07 Dec 2022 13:25:41 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c9-20020a63ef49000000b0046feca0883fsm11675494pgk.64.2022.12.07.13.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 13:25:40 -0800 (PST)
Date:   Wed, 7 Dec 2022 21:25:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: adjust entry after renaming the vmx hyperv
 files
Message-ID: <Y5EE0MOaLGZUqa38@google.com>
References: <20221205082044.10141-1-lukas.bulwahn@gmail.com>
 <87pmcydyp0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmcydyp0.fsf@redhat.com>
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

On Mon, Dec 05, 2022, Vitaly Kuznetsov wrote:
> Lukas Bulwahn <lukas.bulwahn@gmail.com> writes:
> 
> > Commit a789aeba4196 ("KVM: VMX: Rename "vmx/evmcs.{ch}" to
> > "vmx/hyperv.{ch}"") renames the VMX specific Hyper-V files, but does not
> > adjust the entry in MAINTAINERS.
> >
> > Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> > broken reference.
> >
> > Repair this file reference in KVM X86 HYPER-V (KVM/hyper-v).
> >
> 
> Fixes: a789aeba4196 ("KVM: VMX: Rename "vmx/evmcs.{ch}" to "vmx/hyperv.{ch}"")
> 
> maybe?

Ya.

> 
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > ---
> >  MAINTAINERS | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index ceda8a0abffa..8fda3844b55b 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -11457,7 +11457,7 @@ F:	arch/x86/kvm/hyperv.*
> >  F:	arch/x86/kvm/kvm_onhyperv.*
> >  F:	arch/x86/kvm/svm/hyperv.*
> >  F:	arch/x86/kvm/svm/svm_onhyperv.*
> > -F:	arch/x86/kvm/vmx/evmcs.*
> > +F:	arch/x86/kvm/vmx/hyperv.*
> >  
> >  KVM X86 Xen (KVM/Xen)
> >  M:	David Woodhouse <dwmw2@infradead.org>
> 
> Reviewed-by: 

Since Vitaly left you hanging :-)

Reviewed-by: Sean Christopherson <seanjc@google.com>
