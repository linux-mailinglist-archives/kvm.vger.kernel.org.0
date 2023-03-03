Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C696A9DC8
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 18:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjCCRg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 12:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjCCRgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 12:36:24 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D91415C84
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 09:36:23 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso6907143pjb.2
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 09:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677864983;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UjNXU1tEXsuTG4huv7r5UMJSNLOXXYqAwRyDV6iA0nY=;
        b=s9e/fu31hth4h2Ezrh++sCZEz7apyCzhh/ecfgZdCSv3b1e+JENsCuofnmp09mrVjb
         pLww16Zs2kSFitsAi0qb3RHZlU2GofisOBInmnPL/l1FDgQ1Bg12c2oPMvNUtVIiNU3p
         l8XFzb5HGZCekKW01QSWvD0VW768QdWuqh5g4eLGo1XCrAsuAqT/PLG1XOtxZaZcH7qj
         M7ZWdyC3sLFRnsMybpfu6AspGCkBwDkNOjxb2wBcVLI9kJAfd7StdtDX4AWnlZdC7jmi
         iCRQQ6VsJNu8vkh+Lf49Q3V5z5IsUV5JC5ojhGaBywaV8oV2sEF3cLrK6UdINl3nNJWd
         tSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677864983;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UjNXU1tEXsuTG4huv7r5UMJSNLOXXYqAwRyDV6iA0nY=;
        b=X6mC6hpreE8o80AoBLz67KKw8lC7095Lq1U7mGa9o1S9OWBhBQwGfSUDfF01tDV/yI
         86noicBETSl+yTVYVNhZbf73RVO2PwS/JxTSQgj7pTmNpAgqqWUh0ECD04fkRR8aHgAV
         IyBOCLqkgh41LYYtDf8jJII6ib1kWW0Znv5HNTSeMg/HA1Crb8HMXBhwhdggUkGLZ8br
         vSwwqmna7jBtu150mqcVI7jNAhhzBd0oyCOdkd9ZN2STeXYyiutG/IP6lYcbYp32cQ1v
         b/Tifi6u7c+OonbO3WyB3XqRdu/d+pKJOey6VVP4h6QHbfK+nEm4KKRsvB/In669FoFg
         rzpg==
X-Gm-Message-State: AO0yUKXbwWCugjnA8Ja9jNA4q9gkO3MKHgHcy3Bo2Ejk8av5p3FHdjJ2
        qw1wumaHRhxRL9Cf9O1Q7kV4VK25LnoULgc5r+Q=
X-Google-Smtp-Source: AK7set8thLIQH+7wkXPgqf3SnXnzYHJkd3YmLbiqXBcBE1bnZIf/qgdzipF1B7Rgs/q/mlvoGHpmTg==
X-Received: by 2002:a17:90b:4f8c:b0:237:6178:33b1 with SMTP id qe12-20020a17090b4f8c00b00237617833b1mr2565701pjb.19.1677864982773;
        Fri, 03 Mar 2023 09:36:22 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id fv24-20020a17090b0e9800b002340f58e19bsm1763623pjb.45.2023.03.03.09.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 09:36:21 -0800 (PST)
Date:   Fri, 3 Mar 2023 09:36:17 -0800
From:   David Matlack <dmatlack@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Message-ID: <ZAIwEZdYcrs5EcHE@google.com>
References: <20230301133841.18007-1-wei.w.wang@intel.com>
 <CALzav=eRYpnfg7bVQpVawAMraFdHu3OzqWr55Pg1SJC_Uh8t=Q@mail.gmail.com>
 <DS0PR11MB637348F1351260F8B7E97A15DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZAAsIBUuIIO1prZT@google.com>
 <DS0PR11MB6373DAA05CEF9AB8A83A6499DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CAL715WLo90-JkJe6=GfX755t1jvaW-kqD_w++hv3Ed53fhLC3w@mail.gmail.com>
 <DS0PR11MB63735E9AC8F4636AF27DAA4ADCB39@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CAL715WJsV3tPkMDK0exgHeuKOP9kJtc62Ra0jnRhT1Gd6AiEWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL715WJsV3tPkMDK0exgHeuKOP9kJtc62Ra0jnRhT1Gd6AiEWg@mail.gmail.com>
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

On Thu, Mar 02, 2023 at 09:53:35PM -0800, Mingwei Zhang wrote:
> On Thu, Mar 2, 2023 at 5:50 PM Wang, Wei W <wei.w.wang@intel.com> wrote:
> >
> > On Friday, March 3, 2023 2:12 AM, Mingwei Zhang wrote:
> > > > On Thursday, March 2, 2023 12:55 PM, Mingwei Zhang wrote:
> > > > > I don't get it. Why bothering the type if we just do this?
> > > > >
> > > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > > index 4f26b244f6d0..10455253c6ea 100644
> > > > > --- a/include/linux/kvm_host.h
> > > > > +++ b/include/linux/kvm_host.h
> > > > > @@ -848,7 +848,7 @@ static inline void kvm_vm_bugged(struct kvm
> > > > > *kvm)
> > > > >
> > > > >  #define KVM_BUG(cond, kvm, fmt...)                           \
> > > > >  ({                                                           \
> > > > > -     int __ret = (cond);                                     \
> > > > > +     int __ret = !!(cond);                                   \
> > > >
> > > > This is essentially "bool __ret". No biggie to change it this way.
> > >
> > > !! will return an int, not a boolean, but it is used as a boolean.
> >
> > What's the point of defining it as an int when actually being used as a Boolean?
> > Original returning of an 'int' is a bug in this sense. Either returning a Boolean or
> > the same type (length) as cond is good way to me.
> 
> What's the point of using an integer? I think we need to ask the
> original author. But I think one of the reasons might be convenience
> as the return value. I am not sure if we can return a boolean in the
> function. But it should be fine here since it is a macro.
> 
> Anyway, returning an 'int' is not a bug. The bug is the casting from
> 'cond' to the integer that may lose information and this is what you
> have captured.

typeof() won't work if cond is a bitfield. See commit 8d4fbcfbe0a4 ("Fix
WARN_ON() on bitfield ops") from Linus from back in 2007:

commit 8d4fbcfbe0a4bfc73e7f0297c59ae514e1f1436f
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Tue Jul 31 21:12:07 2007 -0700

    Fix WARN_ON() on bitfield ops

    Alexey Dobriyan noticed that the new WARN_ON() semantics that were
    introduced by commit 684f978347deb42d180373ac4c427f82ef963171 (to also
    return the value to be warned on) didn't compile when given a bitfield,
    because the typeof doesn't work for bitfields.

    So instead of the typeof trick, use an "int" variable together with a
    "!!(x)" expression, as suggested by Al Viro.

    To make matters more interesting, Paul Mackerras points out that that is
    sub-optimal on Power, but the old asm-coded comparison seems to be buggy
    anyway on 32-bit Power if the conditional was 64-bit, so I think there
    are more problems there.

    Regardless, the new WARN_ON() semantics may have been a bad idea.  But
    this at least avoids the more serious complications.

    Cc: Alexey Dobriyan <adobriyan@sw.ru>
    Cc: Herbert Xu <herbert@gondor.apana.org.au>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Al Viro <viro@ftp.linux.org.uk>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 344e3091af24..d56fedbb457a 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -33,7 +33,7 @@ struct bug_entry {

 #ifndef HAVE_ARCH_WARN_ON
 #define WARN_ON(condition) ({                                          \
-       typeof(condition) __ret_warn_on = (condition);                  \
+       int __ret_warn_on = !!(condition);                              \
        if (unlikely(__ret_warn_on)) {                                  \
                printk("WARNING: at %s:%d %s()\n", __FILE__,            \
                        __LINE__, __FUNCTION__);                        \
@
[...]

As for int versus bool, I don't see a strong argument for either. So let's
stick with int since that's what the current code is using and that
aligns with the generic kernel WARN_ON().

If someone wants to propose using a bool instead of an int that should
be a separate commit anyway and needs an actual justification.
