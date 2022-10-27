Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C16E60FC54
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 17:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbiJ0Pug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 11:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbiJ0Puf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 11:50:35 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B121017F9B8
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:50:29 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c24so1917993pls.9
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gHoxcurLVa6zT8ka5qbo9UCrZsd+9SrDP+knEFffmmk=;
        b=s1JQ99HFwEez/1xPDPuWPGVWjuuzLv1fa1lBY7S4RgUIt0+qqyz08SdkuCw7xExtGW
         /iSBlEtgg+liHiiZiv67aCXoXHA+E/aTsu88nZIIwQw6yPPbM9sxFRZWjlKJIxSsVbG/
         kKXuldIPFWiPOSDiB+f2STLVPxgfUQlLKFDE18osHPwW8+AZbyjaNM6sR/89eAMBmXSs
         h4kFYY9vG7pi7/bFKQxyjQhRFCWUvCJ487uqtdv1+ehuShxb0o7487TebHYWinP5amEx
         cerUDWGZYsj3jggL0JzkYDGmvfvr3MZXmbf++BCSivILcoQTgtLfb3yP5qVkDQ5MUOFt
         6qMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHoxcurLVa6zT8ka5qbo9UCrZsd+9SrDP+knEFffmmk=;
        b=wHkjRTe/7QiyQi1QYkGB+eJ2HAumW/WwKdO1zwCy2yASl/m9xc/3UF7fDnjzoXCRwz
         sXKlUYV2xf6woH9XCUVF4wm0AxeV3yifS3YMuzAJCrnho1QmQPIzenKttC8jTctXEL2z
         4a4pp4VvXABXDNTYu1YfFE9S+az74YDFhNtEm0Bc1p8UUiU/mYiFVxRe2+OBdDtXy8Vu
         Biu2xbDTIOQCgZ/bitcm41rYvCzw8H80bk522Fet8O1Sj8zkMwv6R3YyLZPGkaMUTcsz
         J7XFzvMempWYRAHb7GDiD9OGB27cv5Msb8nPUwyIkgzzlarqKMDEGOcVJnW6Zgp0YVVa
         asCA==
X-Gm-Message-State: ACrzQf0ndyNqaHXjILY7aMBzGdlFbhG4UeBq1msRv4n0/IvoyE3QzSuD
        KoStUghulKL6I7vx7XOqHLx5yQ==
X-Google-Smtp-Source: AMsMyM5hQ3rI68pCvqhHpmpMm9gSRogt5LQgnkC5zNPamhHn5wpF/I3hdOqm0HRiQMWsZ9dAcqk0WA==
X-Received: by 2002:a17:902:8a88:b0:17f:8642:7c9a with SMTP id p8-20020a1709028a8800b0017f86427c9amr51279154plo.13.1666885829111;
        Thu, 27 Oct 2022 08:50:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m4-20020a170902db0400b00186a2274382sm1385580plx.76.2022.10.27.08.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 08:50:28 -0700 (PDT)
Date:   Thu, 27 Oct 2022 15:50:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 01/16] x86: make irq_enable avoid the
 interrupt shadow
Message-ID: <Y1qowfkxEGWizEls@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-2-mlevitsk@redhat.com>
 <Y1GNE9YdEuGPkadi@google.com>
 <a52dfb9b126354f0ec6a3f6cb514cc5e426b22ae.camel@redhat.com>
 <Y1cWfiKayXy5xvji@google.com>
 <35223fa0e5f09b33180ba161e1b2e16ce0d0669f.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35223fa0e5f09b33180ba161e1b2e16ce0d0669f.camel@redhat.com>
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

On Thu, Oct 27, 2022, Maxim Levitsky wrote:
> On Mon, 2022-10-24 at 22:49 +0000, Sean Christopherson wrote:
> > On Mon, Oct 24, 2022, Maxim Levitsky wrote:
> > > I usually use just "\n", but the safest is "\n\t".
> > 
> > I'm pretty sure we can ignore GCC's warning here and maximize readability.  There
> > are already plenty of asm blobs that use a semicolon.
> 
> IMHO this is corner cutting and you yourself said that this is wrong.
> 
> The other instances which use semicolon should be fixed IMHO.

The kernel itself has multiple instances of "sti; ..." alone, I'm quite confident
this we can prioritize making the code easy to read without risking future breakage.

$ git grep -E "\"sti\;"
arch/x86/include/asm/irqflags.h:        asm volatile("sti; hlt": : :"memory");
arch/x86/include/asm/mwait.h:   asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
arch/x86/include/asm/paravirt.h:        PVOP_ALT_VCALLEE0(irq.irq_enable, "sti;", ALT_NOT(X86_FEATURE_XENPV));
tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c:            asm volatile("sti; hlt; cli");
tools/testing/selftests/x86/iopl.c:             asm volatile("sti; pushf; pop %[flags]"
