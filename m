Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51373608014
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 22:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiJUUql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 16:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiJUUqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 16:46:11 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112572F380
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:45:42 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id j12so3394607plj.5
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QlcZb3i3xodqSh4YItAkXI25XiHSarDw1bC3ewW5j7Y=;
        b=Cr8t+ROcfK2W7A8lV+VhbS4oJYYiLJDD606ikiWoH3wZCWeYQPuqVNgTvnOmDYJORA
         b31kRWGkUAjrD8BJFXpCfRX9OEHVkEJpwi5SwBjZCR+cML+HuRBYN7Vuv93C7ejE/yzF
         BgucxlgPoGrscNkaICTkrLvDEuydRcrYnDuosBTPqQ/WEvP6S98oe6nDEYo+rMDjdeaA
         iD9/COfUr66F/3FEK3tS6Bl+WhuF6SQU9NJlGRgX4qzk9mwzxAAcu+qKynMVsnz7Zg6i
         F6+30s4y2IcM9+SRgWUS7SnUm4fOgVb8kOYN6pYpKba9ZBKDUZvgbwgS/hSXsrxSrYms
         lNdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QlcZb3i3xodqSh4YItAkXI25XiHSarDw1bC3ewW5j7Y=;
        b=J/FPWglD1/6ZI0xD13S6SZsbzcUbcryh2VYmdLwswJsxd8IaJfZXy4fPI78yC91zeN
         GDKXYD8wysWYEAgzuiXeWjwW4f0LjrUkEfU5hZDaXrhDdrlORZED4x9O+q+0pMT0a2A/
         brbsQ8Fg9ievaV5qF4jxX1FQPRuY86LnRBOpC9SFFa7lOWjaosfhGRONk0tei/VbNPyC
         yJrWGC2e2yMqMX6lYwodMD9M2Wp4h7+71k31wAgqb6XNuskZ9a7i8wC8/7bOiAOVDI9G
         K5vr9KFygvF0zo4atloyBY8twoz85yB0y2VK9pww9nqcQEYQtETdOS9+MI5vL0IBtpvT
         Bo9Q==
X-Gm-Message-State: ACrzQf30Ved7zpsckGGpBZylvpFGGRaXBtSeBVo+Bqe99GtfJsevEV0l
        Oc1/DmG7w3bDDZKu+M13W1gX1Q==
X-Google-Smtp-Source: AMsMyM6mixn9mZqW7u6uZFvTMTHjpUboWCmyjIThG3N4zeer0wX88+wMPhQo64zaKdN6O+XCSkpaqA==
X-Received: by 2002:a17:902:be18:b0:178:b9c9:97b8 with SMTP id r24-20020a170902be1800b00178b9c997b8mr20398229pls.38.1666385126397;
        Fri, 21 Oct 2022 13:45:26 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q5-20020aa79825000000b005695accca74sm4837001pfl.111.2022.10.21.13.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 13:45:25 -0700 (PDT)
Date:   Fri, 21 Oct 2022 20:45:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vasant Karasulli <vkarasulli@suse.de>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] x86: efi: set up the IDT before
 accessing MSRs.
Message-ID: <Y1ME4jXPwsgT67B8@google.com>
References: <20220823094328.8458-1-vkarasulli@suse.de>
 <YwfuxxgGFVDpLOOR@google.com>
 <Y0gVW+wzPSEPeci7@vasant-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0gVW+wzPSEPeci7@vasant-suse>
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

On Thu, Oct 13, 2022, Vasant Karasulli wrote:
> Hi Sean,
> 
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> >
> > >  lib/x86/setup.c | 20 ++++++++++++--------
> > >  1 file changed, 12 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> > > index 7df0256..712e292 100644
> > > --- a/lib/x86/setup.c
> > > +++ b/lib/x86/setup.c
> > > @@ -192,8 +192,6 @@ static void setup_segments64(void)
> > >  	write_gs(KERNEL_DS);
> > >  	write_ss(KERNEL_DS);
> > >
> > > -	/* Setup percpu base */
> > > -	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);
> > >
> > >  	/*
> > >  	 * Update the code segment by putting it on the stack before the return
> > > @@ -322,7 +320,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
> > >  		}
> > >  		return status;
> > >  	}
> > > -
> > > +
> >
> > Huh.  This causes a conflict for me.  My local repo has a tab here that is
> > presumably being removed, but this patch doesn't have anything.  If I manually
> > add back the tab, all is well.  I suspect your client may be stripping trailing
> > whitespace.
> 
> Yes, I think my client was stripping trailing whitespaces. Do you want me
> to send a new version of the patch with that formatting?

No need, I'll put together a KUT PULL request next unless Paolo beats me to the
punch.
