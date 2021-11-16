Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38ED8453ABB
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhKPUPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhKPUPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:15:43 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309A0C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:12:46 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u17so139159plg.9
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hPUDmE4iqUVbfnpnjy6JZAd5PXVFUlLHYstHCTZX1/g=;
        b=szeTrShUjcCHEnJSzmHXNo5NwaUaT2peWqbdfIzVJXkzsdKO6lbDb36U+UJo6QU+VC
         aaA2ItHvFdq/g1BBdhVcBUAoPj483RJBksMnbgk+Bvv7acqLMg/jvhASq9v2Rmte79F7
         LiZnsrhqkYb2PKaOMraSv+a5aote70df0l2VpwmTiV7UXbcy088uh3+CHONZO9y4+A4s
         UHB7mbHx62a4A+QmwuFnzzYBCJbvZVvDCtyBYvhfxFkNwC0lVSauAbA2xd+P+tFTDDNO
         EBp1AntSApoEcNUxgUhsnf/GHcp+FAMND6hbsPndB+ulawrbuyL487QH4l/UADG6PWqY
         Az/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hPUDmE4iqUVbfnpnjy6JZAd5PXVFUlLHYstHCTZX1/g=;
        b=fmNXQZF4zeZRcZGbefkbZ/3c0s4ilEBK7GHVphueDwrq3NOEj0QXh0UfdX95PHHMpp
         HJ+wYXkLvNygwUoOc/8pw8Oa6cvhqtQu/lbEWgxGc6al25nYTH+IKtfLJe2SmSr8fgQ8
         jppFpMhk495dezaMszCkogkYu8popC7qXXM8MjsULuqsE+v7KC6mTRXn0v9yGRMOTlJY
         aqrF/P1Fta/+bmds5vUtwaHjEcOIucCqmFzlM+kb5UNuras0YuC5P52tawzt7vOUjATz
         xQXH30EPim3EfPlPoFYMbEg1BypcMpC4BqKF5TSzEhKGEvDt2cd8/BBltR6eKEwdijUE
         mSnw==
X-Gm-Message-State: AOAM531YGCsLvUzDC3BTy7ilA2yPx6evzYbdFF7OZQz9CgfIl9bFiF0/
        WUBIOtPkbeLSWoe9niBdhTlUFQ==
X-Google-Smtp-Source: ABdhPJyA8KiYciUTHY85AmIpEqEfSQYYTJ6DX1SXKH+4SCUH4jwtRLz4BeBJMZS15GB54WjD7k2VsQ==
X-Received: by 2002:a17:90a:ce14:: with SMTP id f20mr2193681pju.121.1637093565555;
        Tue, 16 Nov 2021 12:12:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g1sm19179071pfm.25.2021.11.16.12.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 12:12:45 -0800 (PST)
Date:   Tue, 16 Nov 2021 20:12:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Thoughts of AMX KVM support based on latest kernel
Message-ID: <YZQQuQDWPhcJG6pM@google.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <87k0h85m65.ffs@tglx>
 <YZPWsICdDTZ02UDu@google.com>
 <87ee7g53rp.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ee7g53rp.ffs@tglx>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021, Thomas Gleixner wrote:
> Now you could argue that the interrupt/softirq XSAVES should also read
> the XFD MSR and save it in guest_fpstate.xfd. Same in schedule()
> and kvm_put_guest_fpu(), i.e:
> 
>       XSAVES
>       if (fpstate->is_guest) {
>             rdmsrl(XFD, xfd);
>             fpstate->xfd = xfd;
>             __this_cpu_write(..., xfd);
>       }
> 
> We can do that, but I'm unhappy about this conditional in schedule(). So
> I was asking for doing a simple KVM only solution first:

Ah, the schedule() conditional is the part I was missing.  Thanks!
