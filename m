Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A356D7F7A
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 16:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238556AbjDEO36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 10:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238606AbjDEO3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 10:29:46 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C177283
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 07:29:24 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-546422bd3ceso182289237b3.21
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 07:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680704964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a5u2H7ZEO3TszmavvnixxGfVxjz1Pv5eD5xjN/onnh4=;
        b=S6BennQgreYYXsNtmEqG7v64FLfRVI+5pMcL/rbiPnPH7Ppm6QOn/0dH/xIV14iqLm
         WcRcocmc+MiF1cMZ7mWVRXb2sRTDV11t5QJ0vddd7ZcWpw6gD1+OVtHQY/8e8w79ypR7
         nUI6apEgHT4Jr/ZzQB6hVuxgmeZ6bRCoosefeTrOVp0ibsLBezq+2/CMYfM+V9aUkZ+e
         67S1OUfHpoVxNdCZY8/wyKlW4j95odSITlqSJF/vTlmy/VBZjGFy7jkt2wi9RIna3Olv
         ZLDq6EqBGMjkLDufCgEBEl7cm5271G5q3QHN/vklASMvYFUeHwgThvMNbAHhCfd/PqcJ
         ADqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680704964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a5u2H7ZEO3TszmavvnixxGfVxjz1Pv5eD5xjN/onnh4=;
        b=p2KOfIDU3oRgxJj/yCtEMpuW8GohXoVggugewnY/qItgS/eU5ExVco+kna8Nh3jJs4
         lQa/CJQweEMqsFXH+CBUmD8o6fDH+wO3XBR08jhcuQTr66rab2f2YVAVwu7h8rXXBnqM
         oOzF4YG4+QmgA3M3IJT1EMqR7JfUFexiWtYKkIYEt4yo8LplWJXCsFehVsHRMVegJXBt
         bR4Xs7v03Y66B0QAvHGZ8O1VjdKJGjlZIrYBW+trFFGROtcoqfIJy0XXVUuutZm+O2RA
         GOE3bQo/DAqwVXDNABtjrSaISBz0zhqVuGWXkRUw0OW5quHQqKnwcgBaerTSMztsU0G7
         k5Og==
X-Gm-Message-State: AAQBX9fzu0fXahmRNb5A+vxbLFG07swmzvN5W3XHAXaVo1CIyhv8O0QB
        l3XUVLDI2xNLUdNfWLliP7nXMAWHX9o=
X-Google-Smtp-Source: AKy350bNIdYEFf2MKPfUwFwc9bq9JiNvccixMvxhyi20+IRpj/IuwIn477gV9Xqr1mqOSzKp5YKkPXgcKPQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:10d:b0:545:f3ed:d251 with SMTP id
 bd13-20020a05690c010d00b00545f3edd251mr2067685ywb.1.1680704963884; Wed, 05
 Apr 2023 07:29:23 -0700 (PDT)
Date:   Wed, 5 Apr 2023 07:29:22 -0700
In-Reply-To: <6fcaf791-da24-fae7-af03-3e19a781fd26@grsecurity.net>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com> <20230404165341.163500-7-seanjc@google.com>
 <6fcaf791-da24-fae7-af03-3e19a781fd26@grsecurity.net>
Message-ID: <ZC2FwphMDTz3ESLQ@google.com>
Subject: Re: [kvm-unit-tests PATCH v4 6/9] x86/access: Try forced emulation
 for CR0.WP test as well
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023, Mathias Krause wrote:
> On 04.04.23 18:53, Sean Christopherson wrote:
> > @@ -1127,6 +1128,10 @@ static int check_toggle_cr0_wp(ac_pt_env_t *pt_env)
> >  
> >  	err += do_cr0_wp_access(&at, 0);
> >  	err += do_cr0_wp_access(&at, AC_CPU_CR0_WP_MASK);
> 
> > +	if (!(invalid_mask & AC_FEP_MASK)) {
> 
> Can we *please* change this back to 'if (is_fep_available()) {'...? I
> really would like to get these tests exercised by default if possible.

"by default" is a bit misleading IMO.  The vast majority of developers almost
certainly do not do testing with FEP enabled.

> Runtime slowdown is no argument here, as that's only a whopping two
> emulated accesses.
> 
> What was the reason to exclude them? Less test coverage can't be it,
> right? ;)

The goal is to reach a balance between the cost of maintenance, principle of least
surprise, and test coverage.  Ease of debugging also factors in (if the FEP version
fails but the non-FEP versions does not), but that's largely a bonus.

Defining a @force_emulation but then ignoring it for a one-off test violates the
principle of least suprise.

Plumbing a second param/flag into check_toggle_cr0_wp() would, IMO, unnecessarily
increase the maintenance cost.  Ditto for creating a more complex param.

As for test coverage side, I doubt that honoring @force_emulation reduces test
coverage in practice.  As above, most developers likely do not test with FEP.  I
doubt most CI setups that run KUT enable FEP either.  And if CI/developers do
automatically enable FEP, I would be shocked/saddened if adding an additional
configuration is more difficult than overiding a module param.  E.g. I will soon
be modifying my scripts to do both.
