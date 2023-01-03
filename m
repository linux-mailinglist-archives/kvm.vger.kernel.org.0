Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB52C65C6B5
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 19:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbjACStE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 13:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238712AbjACSsU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 13:48:20 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B5213F04
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:48:02 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o31-20020a17090a0a2200b00223fedffb30so32029076pjo.3
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 10:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zPLabJ1YI0HZ9Wsi0ecPwiS5fdbOizZ50cPFPVQexEs=;
        b=R1w0pU6KGAQdeL1yc+Q0rNnUGDeCT5CF1GPhykJTBKwbfffFGUiaW2RFHT+nl42tQh
         QKAxyTPV/Tal6fZbW3qjOjO8FkxyrOP0q7XMptUlvkbwl7fDSgHqQBn4FdeBWAwX4T5u
         qHwNUgLImdYqQMbZUoFBqBFRn01Zkbu3qkJUtpOKQUwflGm4dmjTIaadw3iUNF7cn2Ft
         kq78APQxToGkRJ5lgLxMfqbYu4N49p0fi0whNcm9J6l0wq292ya7AD7uzQMuEXvynajn
         2ApzWg5UxQgiPKNxmCFyj7yIOFfREZrKaSOgLNKTrjE4EQgheMtj2KoCchD7l11nxoLP
         FFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zPLabJ1YI0HZ9Wsi0ecPwiS5fdbOizZ50cPFPVQexEs=;
        b=KOuRgYiwZ2/veZPj5pU+6Dnj+HNOyyW9+vY9+nkspHnHOPKtqzrfMQIwID2U+rOHHV
         qBjjWmvSWxrzh6bCsVlfsODrUEuO9CgCHrqIX3s6aOsYNB+lCmloBcD8/iJgJUyBhlfw
         bzXOfKMyBLzFFBJVOWYgLhlfPfszkNkpWTnhFfrDAPaf5GpYc9HJ6VkeRms4aCueRsvZ
         IefsiHdeW1+OpAJTbyASPOM6Ab4HhA/qHylvVnfuNhXYhGNrrX8kwbScyAetil//pINd
         fDx5GRyZN4sGQ7B7z+Q+HUh4+BFO2xbjk2d0rlwj6Z4lqbx7LpLex5XMxWlpi22fo8US
         2xGg==
X-Gm-Message-State: AFqh2kpREEY/2HZ09k+e+Uj0eWEVDPOUDMRTnpQoF/3pDkzslKwKBDDc
        QdsmGaktjI+fUUaAmiW7kgRpPg==
X-Google-Smtp-Source: AMrXdXubjSTI7gT8RJBzr8xtJ0VO4rdYpfRZAQU/fckOxRlIapOcyz8N/+AntS3ASdk1Lsr2VJ2bQQ==
X-Received: by 2002:a17:90a:8b8c:b0:219:c2f2:f83c with SMTP id z12-20020a17090a8b8c00b00219c2f2f83cmr3620407pjn.2.1672771681642;
        Tue, 03 Jan 2023 10:48:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b5-20020a17090aa58500b001fb1de10a4dsm4770495pjq.33.2023.01.03.10.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:48:01 -0800 (PST)
Date:   Tue, 3 Jan 2023 18:47:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
Message-ID: <Y7R4XY12Oyqymhyk@google.com>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com>
 <93332d0c-108c-7f10-1f21-6dd94abcfb7f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93332d0c-108c-7f10-1f21-6dd94abcfb7f@intel.com>
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

On Mon, Jan 02, 2023, Xiaoyao Li wrote:
> On 12/31/2022 12:24 AM, Aaron Lewis wrote:
> > Be a good citizen and don't allow any of the supported MPX xfeatures[1]
> > to be set if they can't all be set.  That way userspace or a guest
> > doesn't fail if it attempts to set them in XCR0.
> > 
> > [1] CPUID.(EAX=0DH,ECX=0):EAX.BNDREGS[bit-3]
> >      CPUID.(EAX=0DH,ECX=0):EAX.BNDCSR[bit-4]
> > 
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >   arch/x86/kvm/cpuid.c | 12 ++++++++++++
> >   1 file changed, 12 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index c4e8257629165..2431c46d456b4 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -855,6 +855,16 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
> >   	return 0;
> >   }
> > +static u64 sanitize_xcr0(u64 xcr0)
> > +{
> > +	u64 mask;
> > +
> > +	mask = XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR;
> > +	if ((xcr0 & mask) != mask)
> > +		xcr0 &= ~mask;
> 
> Maybe it can WARN_ON_ONCE() here.
> 
> It implies either a kernel bug that permitted_xcr0 is invalid or a broken
> HW.

I'm pretty sure KVM can't WARN, as this falls into the category of "it's technically
architecturally legal to report only one of the features, but real hardware will
always report both".
