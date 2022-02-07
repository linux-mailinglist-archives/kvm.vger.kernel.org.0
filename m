Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92454AC8A9
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 19:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbiBGSfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 13:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236597AbiBGSeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 13:34:24 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9FBC0401DA
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 10:34:23 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id i17so14447491pfq.13
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 10:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oRG2TiY9mG+YoDpNb+VerVbc2kDW6LhY2HHnO5JTkeE=;
        b=mexx4JrzpbsIXqTZVlSrEXc56yfu0wg9kNOaa/PU9KXIL7ooEtk0K5yTsLvoC3xceS
         DKNO9hr9ANoXH7d6oaSMfZiKEBrxhncROpu32tKko4z/sHorD2EyPAhf/ld2Ff5oKKRI
         THeDwsv6tUMvYjfhpzuune7PEXLvErXm77phiYQeuQ1s1QC0+ab/tf4AMnhjXgI0IhsU
         WFjEQDC9NMZhZdx3S90UwcC1uX3NaZlUXHXDd6aujpr3nioDa2tiyydbsFGuU8Wwuf6w
         yK0MPMRKlQ9wodiEpB/s6ypwCRK50QdOFJQQ3nU5Fw/m0qQNj9rq61fTlwzweC2iU5q8
         s0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oRG2TiY9mG+YoDpNb+VerVbc2kDW6LhY2HHnO5JTkeE=;
        b=0m6iUvx/dTUIPM4eC3hgaVLrni9ippjq8HC8TZbulAYIzOf56enjyz1YRTsvHpHIcP
         v1Ry7gqaoUqz8ADCdZxqmHUUrJjYYOUdAuTaqSB8+kyztZpTdtdKs6dqlmqfbfrcrmDX
         2hTDXhWa5iLIybpmh5Y7xGmSryKJXrOj2DZKk8/LSD6IjbWcYxaECR8Zv54aKSkdZd/3
         CHB8Fr1zr+k6J5IAY3f1+JWc3LIkrYUtzYMNyZuVlktNxqJZ6dAu7ZsG4e3VcBZd/o25
         t4H18MpaXF1HeDaPH8jlz8U3cYJcFF7+0rcTURR0uHxI0xL25XABUL8JkOTC486XzXt8
         1xBQ==
X-Gm-Message-State: AOAM532tzi3o3fYijVkPcDR6Z7jn7I3JBkv6+Higvy+h8hSxm2l7DH53
        mfSuDNSPraesO4RoZXfjOydIfA==
X-Google-Smtp-Source: ABdhPJz+dNgUQDrmKwMhX2oQrJW6vTFqeRRdvXkUogO2qHmqY58m4LHGowMbfB0IFgqKGxcfr7Biqg==
X-Received: by 2002:a63:4b4a:: with SMTP id k10mr572630pgl.488.1644258863265;
        Mon, 07 Feb 2022 10:34:23 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v20sm13146105pfu.155.2022.02.07.10.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 10:34:22 -0800 (PST)
Date:   Mon, 7 Feb 2022 18:34:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/7] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <YgFmK2ZIh2wSQTnr@google.com>
References: <20220204204705.3538240-1-oupton@google.com>
 <20220204204705.3538240-2-oupton@google.com>
 <ce6e9ae4-2e5b-7078-5322-05b7a61079b4@redhat.com>
 <YgFjaY18suUJjkLL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgFjaY18suUJjkLL@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 07, 2022, Oliver Upton wrote:
> Until recently, this all sort of 'worked'. Since we called
> kvm_update_cpuid() all the time it was possible for KVM to overwrite the
> bits after the MSR write, just not immediately so. After the whole CPUID
> rework, we only update the VMX control MSRs immediately after a
> KVM_SET_CPUID2, meaning we've missed the case of MSR write after CPUID.

That needs to be explained in the changelog (ditto for patch 02), and arguably
the Fixes tag is wrong too, or at least incomplete.  The commit that truly broke
things was

  aedbaf4f6afd ("KVM: x86: Extract kvm_update_cpuid_runtime() from kvm_update_cpuid()")

I'm guessing this is why Paolo is also confused.  Without understanding that KVM
used too (eventually) enforce its overrides, it looks like you're proposing an
arbitrary, unnecessary ABI change.
