Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D405F729B
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 03:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiJGBp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 21:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiJGBpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 21:45:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F458F971
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 18:45:53 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id b15so3215804pje.1
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 18:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=onv5P620AmNNedNAxg3+XP3vAvUoceHtCwXWh28hGnQ=;
        b=dQJMrDwL5UVoakMYkWxfUudErzh3bGhynK3gdAmH+Fpm4v4X+h1T/mKrTToRfXSbBk
         S3eNc12+zyP7OoYNK5iajT8AONZaYAdGsIaadggClYf/+9cCYtKjWo+Q8l8o4a7UPN/g
         RRdQHCKruaoEqYGGKkWbgv0ok+oYfhow67fnvpa6pqUc6xuvXf8ucXdc4SVAdurDm35e
         89aWKO+49BxAzDOgmzw4nyW6C5vJpowdFsKGl6sxttfdUHmP/OxAVx7pu6fUfztvjyqS
         uU6yGQtWzNsugPAAyY6HQsY37SoEbtIHXNfdy1MjmG+yDfQ/2DZxmuOHBbAZfUT14Jdm
         US7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=onv5P620AmNNedNAxg3+XP3vAvUoceHtCwXWh28hGnQ=;
        b=bXrGzIgU4ZLO7mN7SPC4Ve0VDT5puqC6dI9C+lxeNBQeBmW3DZIU/FFvqrsLtzzbMw
         i7iyJjM/mg8SWdB8jyOlIy8whfsL4QcQY9BRJbkAuZjzb+MeTCBV7Y21M65atWLLtqRV
         /D1c1pMn85Gl/P58GY6+zgWzbm/FLC/RIq6ULRfOMEtY4yNKzqARRojNX9V7Dx4deL0N
         F1YswVNdBo/e0z6zug2Xob6+FSN+3lGxuid5U+sHBUstcKMCAdA8BF7WMfliMNvmbpjY
         5DcCNun6hTjDDxr1MzDiykrSM5RmMHB25jCWYpBxyxwYt2oWpLPQE9jOz2cYd2hmp1MI
         06IQ==
X-Gm-Message-State: ACrzQf1ErfUv8MBZ1ExwXSlJZGbgxIa2UGB63d9Dx4MUQ/DKIynyVWBQ
        SymM75lfcCjdwhJ/TZE2Km+ZCQ==
X-Google-Smtp-Source: AMsMyM6s5wEJXDvb3j8PLSCoebp5LNqIQLh/ASkusre74Q4oT+0bwwL+LTbvlrCBBHDuufXmzYuOgw==
X-Received: by 2002:a17:902:f789:b0:17f:8cb6:7da3 with SMTP id q9-20020a170902f78900b0017f8cb67da3mr2654285pln.167.1665107153339;
        Thu, 06 Oct 2022 18:45:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902d48400b0017f637b3e87sm251570plg.279.2022.10.06.18.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 18:45:51 -0700 (PDT)
Date:   Fri, 7 Oct 2022 01:45:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Wyes Karny <wyes.karny@amd.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] KVM: x86: Expose CPUID.(EAX=7,ECX=1).EAX[12:10]
 to the guest
Message-ID: <Yz+EzB0Y0tRl7rAz@google.com>
References: <20220901211811.2883855-1-jmattson@google.com>
 <20220901211811.2883855-2-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901211811.2883855-2-jmattson@google.com>
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

The shortlog is trying to win some kind of award.

And technically, KVM_GET_SUPPORTED_CPUID advertises features to userspace, not
to the guest.  How about this?

  KVM: x86: Advertise fast REP string features inherent to the CPU

On Thu, Sep 01, 2022, Jim Mattson wrote:
> Fast zero-length REP MOVSB, fast short REP STOSB, and fast short REP
> {CMPSB,SCASB} are inherent features of the processor that cannot be
> hidden by the hypervisor. When these features are present on the host,
> enumerate them in KVM_GET_SUPPORTED_CPUID.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>

With a less cryptic shortlog,

Reviewed-by: Sean Christopherson <seanjc@google.com>
