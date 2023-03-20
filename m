Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300186C1BAD
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 17:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjCTQb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 12:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbjCTQbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 12:31:39 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2288680
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 09:24:25 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id n8-20020a17090a2bc800b0023f06808981so4549477pje.8
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 09:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679329465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aVYMsUe392bOA51AaoYinxkg/ZveVBCWl2uURIaoZUU=;
        b=U++x0RG2aQLbQMI+FZObbfICiQioNipfz53TOkUdevZvfpZuOa5qEQbovybb+DF6Yy
         2+b2YFT1TvrrzI6Xgh0byuCKWVeuWWSyq3qEcGA0O1tVYeHXE011kIzdh0c65SvSsT8B
         DPzWShnEyF3wF06wJRVnmt4HyeCJ65bm8JYx/tNzNfjlNAIoN88WAWwrwBhKgAydZFXK
         ETzlYD/fCphCSmsvjNNvMwIKetngDZ0R0fmxMsRnFjgz2wWI0aDRrvIUV1aO5yyFM/4+
         3tb2rBO3bIg+lnWlakzLfUgke4YWxkyaVK9d8Ds5ea8KRpYlwUQ3esLBLcm+oHULqPDO
         FPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679329465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aVYMsUe392bOA51AaoYinxkg/ZveVBCWl2uURIaoZUU=;
        b=XTssznoXZOplrGV63Tuf6jI5qBRJkS482DBXiiWbxJQAwPPgtmf3cLoWLU25sDCAjS
         BCX9NTmZG3p21qtmBqWBdYzCz+I8JLJntElk/43a5DzpjVCBLpahe10B9WqVURSdND3M
         pvSGSGJq4M63tB1yk5Ry+7AOHgQ+1hhBekPaYU9JZo0aUEQlD2j2IOi96Py0BUn0Vzws
         nn9LqMYJvI+bUiyQ76yjDOOguiQ6hFYu6erwp0h/gZcUOH7nFIuD87STgNqth1yAvie3
         kAxSoF9KAWdBBnG/3C8YSOyhBc0UDGpKhIUSj33c3CEIXpnoDpkCFkDzgazvyYt+X8m8
         UVKA==
X-Gm-Message-State: AO0yUKUhGpxTo9WAP8hNAVau6qSJkQ8ih2MrNrRoNFsqjyjNyZCMFivS
        8yXDZ8Hs4CkQVlmlCvXdgXIO11+5Oaw=
X-Google-Smtp-Source: AK7set9Dz5tG1ZIPCM3pJnvPFABnvcgBw4GGwXpg+AprPTddlLwNkv9e6+wqSREbZn0nDbHJnaz2viPUmNQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d0e:b0:625:dc5b:9d1d with SMTP id
 fa14-20020a056a002d0e00b00625dc5b9d1dmr8347160pfb.0.1679329464895; Mon, 20
 Mar 2023 09:24:24 -0700 (PDT)
Date:   Mon, 20 Mar 2023 09:24:23 -0700
In-Reply-To: <301c7527-6319-b993-f43f-dc61b9af4b34@redhat.com>
Mime-Version: 1.0
References: <20230201132905.549148-1-eesposit@redhat.com> <20230201132905.549148-2-eesposit@redhat.com>
 <20230317190432.GA863767@dev-arch.thelio-3990X> <20230317225345.z5chlrursjfbz52o@desk>
 <20230317231401.GA4100817@dev-arch.thelio-3990X> <20230317235959.buk3y25iwllscrbe@desk>
 <ZBhzhPDk+EV1zRf0@google.com> <301c7527-6319-b993-f43f-dc61b9af4b34@redhat.com>
Message-ID: <ZBiIt2LBoogxQ2jP@google.com>
Subject: Re: [PATCH 1/3] kvm: vmx: Add IA32_FLUSH_CMD guest support
From:   Sean Christopherson <seanjc@google.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Nathan Chancellor <nathan@kernel.org>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Ben Serebrin <serebrin@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023, Emanuele Giuseppe Esposito wrote:
> 
> Am 20/03/2023 um 15:53 schrieb Sean Christopherson:
> > The patches obviously weren't tested,
> Well... no. They were tested. Call it wrongly tested, badly tested,
> whatever you want but don't say "obviously weren't tested".

Heh, depends on how you define "tested".  I was defining tested as "tested to
work as expected on systems with and without support for IA32_FLUSH_CMD".

But yeah, I should have said "properly tested".

> I even asked you in a private email why the cpu flag was visible in Linux and
> not in rhel when using the same machine.
>
> So again, my bad with these patches, I sincerely apologize but I would
> prefer that you think I don't know how to test this stuff rather than
> say that I carelessly sent something without checking :)

I didn't intend to imply that you didn't try to do the right thing, nor am I
unhappy with you personally.  My apologies if my response came off that way.

What I am most grumpy about is that this series was queued without tests.  E.g.
unless there's a subtlety I'm missing, a very basic KVM-Unit-Test to verify that
the guest can write MSR_IA32_FLUSH_CMD with L1D_FLUSH when the MSR is supported
would have caught this bug.  One of the reasons for requiring actual testcases is
that dedicated testcases reduce the probability of "testing gone wrong", e.g. a
TEST_SKIPPED would have alerted you that the KVM code wasn't actually being exercised.
