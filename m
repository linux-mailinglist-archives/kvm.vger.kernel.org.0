Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408F658464B
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 21:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiG1S4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 14:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiG1S4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 14:56:04 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE96205F4
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 11:56:03 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id f7so2881319pjp.0
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 11:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Bvq190uYRxwRpB0SDsOwrjOA2Tovqp3zJ8Noufja73c=;
        b=Lu6i5dvS3bzFKsbUZm3QfSW51jaI2HbWilk1MngHkXXuftVS75s7FdZX0hDEzAL2a7
         ZgJ8KOJwK2W5/7nSyRs6TCgi8Zme4WANlnYFbxMB5qKSWj/aCPbcJ6rQR111qvPoLI1U
         5RCG+k1iwjFk7qUZVqy6buNBw5ulkalystXDPIsQpt/zpi7PndijUdxbxeNgQHh6RwvA
         TQmQDxVEhcec47BJO09Hl9loIL9DLBtVEqp+1ICze1WQWFLrIHUQmlX4t7a4z3alKcjn
         2oDuUtLQSPLaWdLNhf6tLw+u55lln6hI9kGahERddlADumJ7KFV5rpW4REzUp9CDAHHT
         e/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Bvq190uYRxwRpB0SDsOwrjOA2Tovqp3zJ8Noufja73c=;
        b=Zn7L3M3IcQIxxQufP/VRgnXJFjDCZwLxLU0XYPXc5Kx9wBjkJRYpVjzpHiYpLuQ5v1
         c5KUuiKB4HVD7DPEQ+z7mO2CntgowX7BZqKzfT/A4p0VAxHjP49T8CaGgotF3t6B3ZjE
         aTWkV6cMjkYsOX9LMKLuFNIAbm+4hs4ioBl+LUuVnixeK7z5rgP59icS6DR9+T82ovmf
         a/1XzUUX8Wp3y+hddW93pifrhXVYFf3nVRX3Gk5ALOXkwkziWIwli10TQOQnhchE9Qao
         KVmLMOuciOQIgFsYt8SCTAjnNSZha2am5PEdPPyGLehG8r2T4zZESdEz/tyqfg9UowUD
         jrZQ==
X-Gm-Message-State: ACgBeo1f90TXEuDBfGeUKa2CM3QCYrFv2eJZp5fTgsJ0AtL8ApKX+h2W
        apRtbk2xrCkp58KChnMtkN8N/g==
X-Google-Smtp-Source: AA6agR4noA+jGjLcQbcbdUm+DN2Q1tPxz2EM/wcktmFiqiv2dwFZBnRYzDtSOaOGVYxz3jakjaGk9A==
X-Received: by 2002:a17:90b:1c8e:b0:1f1:b5a8:330f with SMTP id oo14-20020a17090b1c8e00b001f1b5a8330fmr732906pjb.179.1659034563057;
        Thu, 28 Jul 2022 11:56:03 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r17-20020aa79ed1000000b00528c26c84a3sm1138822pfq.64.2022.07.28.11.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 11:56:02 -0700 (PDT)
Date:   Thu, 28 Jul 2022 18:55:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dmytro Maluka <dmy@semihalf.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for oneshot
 interrupts
Message-ID: <YuLbvl7BBuLTBXO7@google.com>
References: <20220715155928.26362-1-dmy@semihalf.com>
 <20220715155928.26362-4-dmy@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715155928.26362-4-dmy@semihalf.com>
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

On Fri, Jul 15, 2022, Dmytro Maluka wrote:
> +static void
> +irqfd_resampler_mask(struct kvm_irq_mask_notifier *kimn, bool masked)

Ugh, I see you're just following the existing "style" in this file.  Linus provided
a lengthy explanation of why this style is unwanted[*].  And this file is straight up
obnoxious, e.g. a large number of functions put the return type on a separate line
even though it would fit without any wrap.

My vote is to break from this file's style for this patch, and then do a follow-up
patch to fix all the existing funky wraps.

[*] https://lore.kernel.org/all/CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com
