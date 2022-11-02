Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DC8616D56
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 20:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiKBTDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 15:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbiKBTDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 15:03:39 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0E5DEF7
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 12:03:38 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m6so17277543pfb.0
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 12:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vRtNvifkXqjcZNm6IA/vjDsapRYf5UOIeKJfNrajLsc=;
        b=QtfMlT9FUEI1EuThdGHpbYKqVPufQuoFnVgZeOhYrGLZNXMELxOpN24mXMnMw0GY7s
         8jzSJcMD2zLDTd7RJZsHWe3BvznFh0QWTT0rppZ6vCt49W7xXSDZTm3PgyyOEDq/MKN3
         pHaidlMoE5wNDXUBkly8uoCeIYsvJf+msvt0HCAJOw3xNjbvNnbhOdpIJbR7r8ulsDfT
         0zHGG4f8UWYYOkuyYkUangmbDIJI4JR+rtfznr9ktVRnBj3uLrRTIhhU6qm8flZvUOzg
         GNHIvi2hynL3g7356RQfm7v2cXCYVdafZyYb6VdcVU2d3xtz+1GdZ8RPl6dQhSQ0fDec
         W3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vRtNvifkXqjcZNm6IA/vjDsapRYf5UOIeKJfNrajLsc=;
        b=EFUp+gnbj7dpWj91qKZ7u42IA6pGaIg+AsD3mvLSiKxYbv3hi2GQ66bO+YNR2gf0Y/
         8I2L80Z/Mw4TFXoWOi9UwW4HXlIBi/tR2tBq9ltzE5/DVJNgVZV6Ng9MN8xQ2XZaVbm3
         FJlUjd684wYq+corZkPfAnZMMelrvVg9ck7IqczI1tZBYcpUyg654Cslzd/fpp3fgKkj
         mF5RGnvsDITsYxJrhyXGsf0ax5fCKCmd7BBd7bqDd2ur0dVT0t5XUq+rcqlYriXQPhTP
         7xVepW0tVBsx5X2BcDQSI7808BbJ5nT0Lu/bIow1Y6NCSyTViyYA5Bnk3gEA/G7MdKny
         N3cw==
X-Gm-Message-State: ACrzQf1SsrQ4EHeS1cCAUPTjlZwWotUpagZSkc0e7Ivy/n+C/W+Ju/gf
        OJeDuMeU7UPms0PQ9eWstWjakg==
X-Google-Smtp-Source: AMsMyM5CXauuPYlDHXQSZEU1j5wopZb9AjXMFBJ3wmzIzK4DSOVbOhyASRjO62KpZCgHpX71XdBPdw==
X-Received: by 2002:a05:6a00:b50:b0:56d:a232:6d9b with SMTP id p16-20020a056a000b5000b0056da2326d9bmr13810006pfo.26.1667415818214;
        Wed, 02 Nov 2022 12:03:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e2-20020aa79802000000b0056b6acb58a0sm8809682pfl.102.2022.11.02.12.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:03:37 -0700 (PDT)
Date:   Wed, 2 Nov 2022 19:03:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 04/10] KVM: selftests: Move flds instruction emulation
 failure handling to header
Message-ID: <Y2K/BvYwX06lsOH+@google.com>
References: <20221031180045.3581757-1-dmatlack@google.com>
 <20221031180045.3581757-5-dmatlack@google.com>
 <Y2ATsTO8tqs4gtz/@google.com>
 <CALzav=eqiCbYaNUgSEsZrRGEA2pv3x5j=oUvbm=_Gho4t50H1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=eqiCbYaNUgSEsZrRGEA2pv3x5j=oUvbm=_Gho4t50H1g@mail.gmail.com>
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

On Wed, Nov 02, 2022, David Matlack wrote:
> On Mon, Oct 31, 2022 at 11:28 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Oct 31, 2022, David Matlack wrote:
> > > +
> > > +static inline void assert_exit_for_flds_emulation_failure(struct kvm_vcpu *vcpu)
> >
> > I think it makes sense to keeping the bundling of the assert+skip.  As written,
> > the last test doesn't need to skip, but that may not always hold true, e.g. if
> > the test adds more stages to verify KVM handles page splits correctly, and even
> > when a skip is required, it does no harm.  I can't think of a scenario where a
> > test would want an FLDS emulation error but wouldn't want to skip the instruction,
> > e.g. injecting a fault from userspace is largely an orthogonal test.
> >
> > Maybe this as a helper name?  I don't think it's necessary to include "assert"
> > anywhere in the name, the idea being that "emulated" provides a hint that it's a
> > non-trivial helper.
> >
> >   static inline void skip_emulated_flds(struct kvm_vcpu *vcpu)
> >
> > or skip_emulated_flds_instruction() if we're concerned that it might not be obvious
> > "flds" is an instruction mnemonic.
> 
> I kept them separate for readability,

Ha, and of course I found assert_exit_for_flds_emulation_failure() hard to read :-)

> but otherwise I have no argument against bundling. I find skip_emulated*()
> somewhat misleading since flds is not actually emulated (successfully). I'm
> trending toward something like handle_flds_emulation_failure_exit() for v4.

How about "skip_flds_on_emulation_failure_exit()"?  "handle" is quite generic and
doesn't provide any hints as to what the function actually does under the hood.
