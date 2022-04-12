Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297884FE659
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 18:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242741AbiDLQ4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 12:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbiDLQ4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 12:56:51 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FFC5F4D5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 09:54:33 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id h15-20020a17090a054f00b001cb7cd2b11dso3642920pjf.5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 09:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=etpjHgNhUiEZ2nKmyv9mfFXNnIT/XJysNFqQneaN/gk=;
        b=AL7eJdW+bNZt14ZiJJbc9R9Son1sPiMtiVDbAWLS/7ChbjqPPOXyeAvZZUpQMU23ZF
         yPbUxtkLQmnCO+PcquczhQUq1gYYMi5rsDv2Hr7ebUSwxwLLzW2tPJZSJD+Mb7y537u2
         IbyKJJBY7zq80Z3DZFHGBiVARMJROeANVY9qAU/I7k4BOvI/QmMnyhlzDT7nia8DRq/i
         L0TGQnyHSezJph4kKMQq2EE3RUWjujiOjZ6FHD2IVvyvIPNoIRyfK3w6twDBjiuWwz0i
         Q87VQfTVImLJP0Dx6doBiOkU9berj6DeWveTyWYhBrNnDGk1v00CCd3/fcCzEdJLkNf4
         3FUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=etpjHgNhUiEZ2nKmyv9mfFXNnIT/XJysNFqQneaN/gk=;
        b=KDPcBL49Oo3XiMwJLgYbYeQAJyPhnhstvsR7ONVE4VhmDZOVO0hIT69bOLXY5uCtDo
         smWqD6kVKYL++Auw2nclMWcFXEb30zTziA6prxZOuJgEsY3P0MYUlFHtMfBDzpV1o9Lx
         BgMBZFsAJUk1AIv/leElV9f3AK+AMFq4lXi7g8sI8kgfyxs+WZAl5csvSeFqfoLEFGFE
         opYDb0KnTIms0jDixxPqyc6u/XNuRbWLhg5zmykKxxPvpA2r+nkOZIDlI4CRU8NKqsrl
         V1S3bnLYhpWas3qox06CRUocuO7Vw3vO+veHIUimoMMLToQWU4ohzp7r2HG67JWCRlsc
         iYTw==
X-Gm-Message-State: AOAM532Fm/UE4z7PzPTlkKoDsEUfbhvW1XEmtZYThZ+p2CZSGpd3rlGi
        j6eWL3C5njNIuvmPQdRdX2gRQw==
X-Google-Smtp-Source: ABdhPJxxRahLJp5+nJFyj5bj0UoDAjRndj3jthXuqerUdWcczCvkjJQwO3KFVZe67lZlmYIJVmkTBg==
X-Received: by 2002:a17:902:9b92:b0:158:9b65:a78 with SMTP id y18-20020a1709029b9200b001589b650a78mr619110plp.53.1649782472366;
        Tue, 12 Apr 2022 09:54:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k23-20020a17090a591700b001ca00b46cf9sm46586pji.18.2022.04.12.09.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 09:54:31 -0700 (PDT)
Date:   Tue, 12 Apr 2022 16:54:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Add support for CMCI and UCNA.
Message-ID: <YlWuw7ANhiiLojQX@google.com>
References: <20220323182816.2179533-1-juew@google.com>
 <YlR8l7aAYCwqaXEs@google.com>
 <CAPcxDJ4iXwSRK9nRTemkMvhjE5WePeLuc0-60eRCOq5bRRHX0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcxDJ4iXwSRK9nRTemkMvhjE5WePeLuc0-60eRCOq5bRRHX0A@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, Jue Wang wrote:
> > > +
> > > +                     if (!(mcg_cap & MCG_CMCI_P) &&
> > > +                         (data || !msr_info->host_initiated))
> >
> > This looks wrong, userspace should either be able to write the MSR or not, '0'
> > isn't special.  Unless there's a danger to KVM, which I don't think there is,
> > userspace should be allowed to ignore architectural restrictions, i.e. bypass
> > the MCG_CMCI_P check, so that KVM doesn't create an unnecessary dependency between
> > ioctls.  I.e. this should be:
> 
> I think the idea was writing unsupported values into an MSR should
> cause #GP.

Right, but when userspace is stuffing MSR values KVM only needs to prevent userspace
from writing values that are completely bogus, i.e. not supported by KVM at all.
Userspace is allowed to violated the guest vCPU model.

> The code is consistent (copied) from the code that handles MSR_IA32_MCG_CTL:
> 
> https://elixir.bootlin.com/linux/v5.17-rc8/source/arch/x86/kvm/x86.c#L3177

Ah.  Sadly, KVM has these sorts of bad examples lurking in dark corners :-/

> Can you elaborate what unnecessary dependency between ioctls this may cause?

Enforcing the vCPU model checks on userspace write means userspace must do
KVM_X86_SETUP_MCE before KVM_SET_MSRS, otherwise stuffing the MSRs will fail.
It's not a big deal since userspace is likely using this ordering given that no
one has complained about MSR_IA32_MCG_CTL, but it's easy to remedy and it makes
the code simpler.
