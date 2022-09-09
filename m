Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCFD5B3B32
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 16:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbiIIOx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 10:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiIIOx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 10:53:57 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F8D3CBDB
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 07:53:55 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f24so2046006plr.1
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 07:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=+yOg8NsIzlPWzR+/oLmBAIEj5goviaZHylN0pyWXIpg=;
        b=YZN7pjUqrQkZISU8YG6JdiBjt1ZLo44dsYe1HlvNSTTXS8pI536yOP/aHVByS1Q2l4
         r+zNinmWULcg3HY+KirQOwL1EjOXNdZiyAk6Xp/ybgdY6up99xylVtdi22+Lv1MGNKPb
         IjZNsnCW4p9sG7ll4jgk1ye7g85cQOVvwebdKX9fDLAZ4YPDqjZF7wP/jiuxgdlYO/mZ
         UtWgzHRWp1FGuhjciPbIsuzRRz17mZxWUbKOwkzHKAwZF1S4ICcIX9h6lKfwHdinGkXp
         hkVKjnFBdOmYr7pLD6VuToX5tBvm9lQZd4K8hrpFh3tONaje5NKBs74A+KRaJCZlzg/B
         5VSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+yOg8NsIzlPWzR+/oLmBAIEj5goviaZHylN0pyWXIpg=;
        b=39eYaGKNxCcJFQl0ov1TWgwHdy6DJN6/c8UkhidYn0O2mJQesWUZc7mbOvU1fP/Ife
         6mAbBVSoc/VggiJ5GoSQ8QCZA1XOtU7DzjcpUMoi8c32GLEALULja4bF2hbXVcngxpNC
         cEZ2Kwt0IWXGyVkNQihN3c38531VaBq/oWcg9ZJtgvOSF/g9einFgvZoXw/AsvFcp6vh
         0Z1tNOe2LyL/oCDHeqIELcMKhcO+FJUFgUBG7ooZH59I+Ts83IgVMavl4VDawXOZmMkn
         oOEaobphJwsNZGN+sIWAbZqyKxi+qrR2ZR1FU+u7362Tf2fBL5xUUBpKbaVSF/zVJcSP
         tnMw==
X-Gm-Message-State: ACgBeo18Q5TbyN8Is7KEpbcnyp6iLcdg8f1NmmEAX5zZS2nIIf+wlvOT
        PC3v0QVlrGdnOqtERcc4593cqg==
X-Google-Smtp-Source: AA6agR753jqgbbHfrywV3a4TlfjtMJWgZXqotzz+E0wpo/x5m/kWB/2/yDwT8R5Ii9GYhNItYY+EjA==
X-Received: by 2002:a17:902:904b:b0:172:cd04:a3d3 with SMTP id w11-20020a170902904b00b00172cd04a3d3mr14169355plz.173.1662735234670;
        Fri, 09 Sep 2022 07:53:54 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b7-20020a170903228700b0017509940418sm618020plh.79.2022.09.09.07.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 07:53:54 -0700 (PDT)
Date:   Fri, 9 Sep 2022 14:53:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm/x86: reserve bit
 KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID
Message-ID: <YxtTfn+cckhBY+BW@google.com>
References: <20220908114146.473630-1-kraxel@redhat.com>
 <YxoBtD+3sgEEiaFF@google.com>
 <20220909050224.rzlt4x7tjrespw3k@sirius.home.kraxel.org>
 <87tu5grkcm.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tu5grkcm.fsf@redhat.com>
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

On Fri, Sep 09, 2022, Vitaly Kuznetsov wrote:
> Gerd Hoffmann <kraxel@redhat.com> writes:
> 
> > On Thu, Sep 08, 2022 at 02:52:36PM +0000, Sean Christopherson wrote:
> >> On Thu, Sep 08, 2022, Gerd Hoffmann wrote:
> 
> ...
> 
> >> >  arch/x86/include/uapi/asm/kvm_para.h | 3 ++-
> >> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >> > 
> >> > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> >> > index 6e64b27b2c1e..115bb34413cf 100644
> >> > --- a/arch/x86/include/uapi/asm/kvm_para.h
> >> > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> >> > @@ -37,7 +37,8 @@
> >> >  #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
> >> >  #define KVM_FEATURE_MIGRATION_CONTROL	17
> >> >  
> >> > -#define KVM_HINTS_REALTIME      0
> >> > +#define KVM_HINTS_REALTIME                      0
> >> > +#define KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID  1
> >> 
> >> Why does KVM need to get involved?  This is purely a userspace problem.
> >
> > It doesn't.  I only need reserve a hints bit, and the canonical source
> > for that happens to live in the kernel.  That's why this patch doesn't
> > touch any actual code ;)
> >
> >> E.g. why not use QEMU's fw_cfg to communicate this information to the
> >> guest?
> >
> > That is indeed the other obvious way to implement this.  Given this
> > information will be needed in code paths which already do CPUID queries
> > using CPUID to transport that information looked like the better option
> > to me.
> 
> While this certainly looks like an overkill here, we could probably add
> new, VMM-spefific CPUID leaves to KVM, e.g.
> 
> 0x4000000A: VMM signature
> 0x4000000B: VMM features
> 0x4000000C: VMM quirks
> ...
> 
> this way VMMs (like QEMU) could identify themselves and suggest VMM
> specific things to guests without KVM's involvement. Just if 'fw_cfg' is
> not enough)

I don't think KVM needs to get involved in that either.  The de facto hypervisor
CPUID standard already allows for multiple hypervisors/VMMs to announce themselves
to the guest, e.g. QEMU could add itself as another VMM using 0x40000100 (shifted
as necessary to accomodate KVM+Hyper-V).
