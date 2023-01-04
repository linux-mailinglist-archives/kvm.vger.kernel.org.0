Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AF665DDF5
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 22:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbjADVCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 16:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240191AbjADVCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 16:02:12 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D571018E25
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 13:02:09 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id cl14so1000328pjb.2
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 13:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vISU1FPw/aHrMjNc1nhfkvc/GB6EDt7VqnAMVm3EwR8=;
        b=Yys+zW+APt41+V6DFzV6RlAoKO3RDaZS4urhgcG21g5jEoQkGshVFRpCiNVeWEOSCY
         4mR3YaDMEeHw+vLm9cARMoldChkzG+Zx6QeTVgg77MvcNBo++cuvTDuKSzHY+IWE9Ix9
         c0I6gZp3ZtVTPr5qwk3wLhAaGZMjuIN/t5XfSIRTbLLHUm09Tg6bHNJnwElPUSoz6c0b
         8hS5A9oJduawQvt0dENYSjIkH+PeCcGsZscu/YpOjd50t53fE4ixC+WJEl8BBpYriSMk
         ZscCHfIKLPLSf7UB9m7dwaa5gEcezi50l7K6ff4w7JnsYT7+YTRZ+6F8MdB0Gmt/6nv3
         Zskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vISU1FPw/aHrMjNc1nhfkvc/GB6EDt7VqnAMVm3EwR8=;
        b=AXeKuLCEBAoEI6Uah1KDwclpluLc0Z6jtSzmCHf1VclHaT+TxRm5OpCVxWFo5iCjWE
         gAJLnK4VAx+5EyDIdiT/nzaUcR2kU5/xU86h5BOLgqkzB8gRdY6/xK2jyfdpPoOIob5p
         nXojtsgdzFcUPXjJt1Rk5XtABMVZrhjT5LV6TkCCGxLNlaUyvUzuLu5bm4solaZiH4lo
         FA44H+ckB57STM6owRmZycTztAZDNdSVGooIwMly7lR0Cfg7ImEnEsRekmw1DrldXHjh
         31A6NbdAeMkupRoZT0yBpQ7/YNzJqiN3ahN7EB1557cOLagq0NF/YwiAZl9wP5TBs3mK
         qDRg==
X-Gm-Message-State: AFqh2koXZavf/mTNj7Xm1zKXH6YPccObXWJ6modhRdyHAMQdya1cv86o
        /djrje0fQ9IoZwEF2Jam8E7xZQ==
X-Google-Smtp-Source: AMrXdXs/blzzQEv+PAikgMz8k3fGTAtkg7tfb5Q55cnqvuB69irdaYC8fBDzwVlI5B3qGBKi1YCwow==
X-Received: by 2002:a17:902:a608:b0:189:b910:c6d2 with SMTP id u8-20020a170902a60800b00189b910c6d2mr4410257plq.1.1672866129202;
        Wed, 04 Jan 2023 13:02:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c18-20020a170903235200b0017ec1b1bf9fsm5903503plh.217.2023.01.04.13.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 13:02:08 -0800 (PST)
Date:   Wed, 4 Jan 2023 21:02:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/cpu: Process all CPUID dependencies after
 identifying CPU info
Message-ID: <Y7XpTAFV6BLT8KgB@google.com>
References: <20221203003745.1475584-1-seanjc@google.com>
 <20221203003745.1475584-2-seanjc@google.com>
 <Y5INU3o+SFReGkLz@zn.tnic>
 <Y5IQNY/fZw2JFA0B@google.com>
 <Y5IUsB83PzHCJ+EY@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5IUsB83PzHCJ+EY@zn.tnic>
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

On Thu, Dec 08, 2022, Borislav Petkov wrote:
> On Thu, Dec 08, 2022 at 04:26:29PM +0000, Sean Christopherson wrote:
> > But it's not really a hardware issue either.  More like an admin/user issue.
> > 
> > The problem is that if a kernel is built for subset of CPU types, e.g. just Intel
> > or just Centaur, and then booted on an "unsupported" CPU type, init_ia32_feat_ctl()
> > will never be invoked because ->c_init() will point a default_init(), and so the
> > kernel never checks MSR_IA32_FEAT_CTL to see if VMX and/or SGX are fully enabled.
> 
> Yeah, you called it an "edge case". I'm wondering whether we should even
> worry about that case...
> 
> I mean, the majority of Linuxes out there are allmodconfig-like kernels
> and booting on unsupported CPU type doesn't happen.
> 
> Hell, I'd even say that if you attempt booting on unsupported CPU type,
> we should simply fail that boot attempt.
> 
> I.e., what validate_cpu() does in some cases.
> 
> IOW, I don't mind what you're doing but I wonder whether we should even
> go the trouble to do so or simply deny that by saying "Well, don't do
> that then".

I agree with the "don't do that" sentiment, but IMO refusing to boot is too much.
Unlike the validate_cpu() cases, the kernel can likely boot and run just fine,
albeit with limited feature enabling.

And there's a non-zero chance we'd end up with a kernel param to allow booting
unknown CPUs, e.g. for people doing weird things with VMs or running old, esoteric
hardware.  At that point we'd end up with a more complex implementation than
processing dependencies on synthetic flags, especially if there's ever a more
legitimate need to process such dependencies.
