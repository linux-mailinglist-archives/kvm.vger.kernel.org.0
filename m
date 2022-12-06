Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF7C644BC3
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 19:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiLFScU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 13:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiLFSbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 13:31:51 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED332FA7E
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 10:27:08 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 21so15303050pfw.4
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 10:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UK2Ov4vIIB569X5qj1bj7VKGvVg/xKlS5gW5F5KP4x0=;
        b=Q5jcQd4e/dID63d6UhYOxzlnA0bJMNl8YNulMSkVJ40hmXRE12e8wTns3DltqElZEa
         SoXi43QTNRT31uSQHijjDjOYMg/+7/eQWTmrNRmq9RR6hT32UTVAsoLos0xg+zno8VQ5
         5d9QORUhYO29AcJQcwbd60Y7l0pVvMF5RGeiMH2OOm34dlncciQApuLzgFA9k59CAIyo
         R/w8+11u8+dZimhHjyU1khsCX3pCGbXTECI22WVzfvqGZWJz0zFlZP8GLtm55bvOIwSL
         7opHLjgIRQ/RafN1yCY9vcBwLSOcKsYnzekS/+Miy4Aq3iOjfkNWLCWmQ49+g2hvvxVk
         reHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UK2Ov4vIIB569X5qj1bj7VKGvVg/xKlS5gW5F5KP4x0=;
        b=u9KJ4kDgV9Nmz0E+ayUmVveFUawo4bykCe/k6bcm4GJGXjdPor/BZJ6VFGNkNMpUYH
         lvZYbfC3RvJM8vuptfhhWG6tSAkZi1aJt7hiEKwOnfHH4a+0kDFeWQ0IX69uFocIXhj5
         ZTgkoRk0OCDbczv3iUwJgiaLT3/zXABL7P0shZozYiJIDQOI7u5/vkz21COhl4f4DbqN
         f2tscALP7nO6ouN7f1mG5DW2UQlAGgz9qrcUXoPTp9s0Uoqx/Fk0WzKdf80LG1jzxLX0
         CEnxg59il041WDWFu1nsWX5pQCqPNuD1Zxu9ApGfnRjMF5aHz08ktEWhRcckEwhD5gmu
         X5Sg==
X-Gm-Message-State: ANoB5pn8Ia4mBypoXLGiBXfmciYvWrXrctJr6BUo5/sNUCZeRJEEsjv2
        UvRHmMtsX18RNumqsNPuJIJkHA==
X-Google-Smtp-Source: AA0mqf5p0E7XA95WCYaopn7qNifORYZNTvxupSwbqpg2++nCK6+z1rOX/fnRK//z6/mv8j59N8bR1A==
X-Received: by 2002:a63:500b:0:b0:440:4ad7:cde9 with SMTP id e11-20020a63500b000000b004404ad7cde9mr60515229pgb.308.1670351227926;
        Tue, 06 Dec 2022 10:27:07 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o1-20020a170902bcc100b00187197c4999sm12961794pls.167.2022.12.06.10.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 10:27:07 -0800 (PST)
Date:   Tue, 6 Dec 2022 18:27:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH 07/13] KVM: SVM: Add VNMI support in get/set_nmi_mask
Message-ID: <Y4+JeAiT8IpTXux9@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-8-mlevitsk@redhat.com>
 <Y3aDTvglaSfhG8Tg@google.com>
 <5bde88433d6962e38a4c2ddad778395cea98d13b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bde88433d6962e38a4c2ddad778395cea98d13b.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 04, 2022, Maxim Levitsky wrote:
> For vNMI case it turns out that we don't need to intercept IRET at all after all:
> 
> Turns out that when vNMI is pending, you can still EVENTINJ another NMI, and
> the pending vNMI will be kept pending, vNMI will became masked due to
> EVENTINJ, and on IRET the pending vNMI will be serviced as well, so in total
> both NMIs will be serviced.

I believe past me was thinking that the "merging" of pending NMIs happened in the
context of the sender, but it always happens in the context of the target vCPU.
Senders always do KVM_REQ_NMI, i.e. always kick if the vCPU in running, which gives
KVM the hook it needs to update the VMCB.

So yeah, as long as KVM can stuff two NMIs into the VMCB, I think we're good.
I'll give the series a proper review in the next week or so.
