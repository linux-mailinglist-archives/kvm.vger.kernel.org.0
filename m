Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686695BB528
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 03:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiIQBDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 21:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIQBDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 21:03:04 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB462CC8A
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:03:04 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id d64-20020a17090a6f4600b00202ce056566so1334056pjk.4
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=PyoFRYpyiLA2IWYuOc5AKxILn6uN9ogs3pnz/FQllOg=;
        b=h0XEg7OsxTMAj6+5qiE4a2ORlViR5bBJ8WhbnnxtYQ/yUxcvYJACxmiXx4AgjHNBHH
         nGGMMWwXoczMjZqnvrhTiKiYoHgJVP6H8jhcAI2X3jPUAQSLnRD5oaZMRPuqssC6Fc8b
         kmBZ2UGDPo5nbXF3FTQHDH6essi0luzyQDFAHNBsNQ/jgu1a10Gk4CFurm8ap8mdrYI8
         VJzEkEBX7KjEfaL7G6X/uRqkvYaBxB0zvtbKv9Es+0S6SvrJFGdCdoDeGTCwVJtKK38o
         1fdlT7qg4CrKxBeeQGKHaEBpLkfBfoEXP2jjBdPzX3rbV4GTXS9IkQRVcoSd2YsmjplQ
         eB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=PyoFRYpyiLA2IWYuOc5AKxILn6uN9ogs3pnz/FQllOg=;
        b=Tx5NoIb0dmQBRtvDs7w1EZEl/W4bG092RPPS0Euef9epEkeQ8DD1qNaaljmPb+FRHE
         E88pX8KwKgvT2U0fEP6ia9JBDTHULQXU9YrQXDolPkkN1amQ1AQHXkP8je4QEayHQ5mu
         ewcWzm3Te1Bohwg/wRYnI44QuQZqFklVOEr2isdbUiLg5XH1qStWsGqcC4sBo8yo0/oH
         XmfBvOthDgc9bkzeTAbfLOMaWPWfoVJY8TqQvPN4/umfbrrJAr6cttb2FtM4C9Tx9Ta5
         wmi1jvpMKBhmPvU5GaPsPk4lN1waqjcXe0mjgCQuSJLQyzrkdwQCJDC1HGeAIXk7Byu0
         VPoQ==
X-Gm-Message-State: ACrzQf0p4oWGZkQMuD6K7qF/Tguvu9/gAz1T53C/fF8NsY5Ku5rF0eNA
        TLl2KgfAuYKJAdXzx4vHzK2hSQ==
X-Google-Smtp-Source: AMsMyM476AUgH8ZUOlqN0Pd+hJdnW3q3heEXNyqjJCgA/fWYAmvRyslqEw3I0qzUlS+xLycQo5kcQQ==
X-Received: by 2002:a17:902:da8f:b0:178:399b:89bb with SMTP id j15-20020a170902da8f00b00178399b89bbmr2464261plx.57.1663376583458;
        Fri, 16 Sep 2022 18:03:03 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j15-20020a170903024f00b00176d6ad3cd4sm15038944plh.100.2022.09.16.18.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 18:03:03 -0700 (PDT)
Date:   Sat, 17 Sep 2022 01:02:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com
Subject: Re: [PATCH v3 0/7] KVM: x86: never write to memory from
 kvm_vcpu_check_block
Message-ID: <YyUcw49208H3jgMi@google.com>
References: <20220822170659.2527086-1-pbonzini@redhat.com>
 <YxoMCp+rMV1ZmRlU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxoMCp+rMV1ZmRlU@google.com>
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

On Thu, Sep 08, 2022, Sean Christopherson wrote:
> On Mon, Aug 22, 2022, Paolo Bonzini wrote:
> > The following backtrace:
> > Paolo Bonzini (6):
> >   KVM: x86: check validity of argument to KVM_SET_MP_STATE
> 
> Skipping this one since it's already in 6.0 and AFAICT isn't strictly necessary
> for the rest of the series (shouldn't matter anyways?).
> 
> >   KVM: x86: make vendor code check for all nested events
> >   KVM: x86: lapic does not have to process INIT if it is blocked
> >   KVM: x86: never write to memory from kvm_vcpu_check_block
> >   KVM: mips, x86: do not rely on KVM_REQ_UNHALT
> >   KVM: remove KVM_REQ_UNHALT
> > 
> > Sean Christopherson (1):
> >   KVM: nVMX: Make an event request when pending an MTF nested VM-Exit
> 
> Pushed to branch `for_paolo/6.1` at:
> 
>     https://github.com/sean-jc/linux.git
> 
> with a cosmetic cleanup to kvm_apic_has_events() and the MTF migration fix squashed
> in.

Oh the irony about complaining that people waste maintainers' time by not running
existing tests :-)  I suppose it's not technically ironic since I was the one doing
the actual complaining, but it's still hilarious.

The eponymous patch breaks handling of INITs (and SIPIs) that are "latched"[1]
and later become unblocked, e.g. due to entering VMX non-root mode or because SVM's
GIF is set.  vmx_init_signal_test fails because KVM fails to re-evaluate pending
events after entering guest/non-root.  It passes now because KVM always checks
nested events in the outer run loop.

I have fixes, I'll (temporarily) drop this from the queue and post a new version of
this series on Monday.  As a reward to myself for bisecting and debugging, I'm going
to tweak "KVM: x86: lapic does not have to process INIT if it is blocked" to incorporate
my suggestions[2] from v2 so that the VMX and SVM code can check only for pending
INIT/SIPI and not include the blocking check to align with related checks that also
trigger KVM_REQ_EVENT (and because the resulting SVM GIF code would be quite fragile
if the blocking were incorporated).

[1] It annoys me to no end that KVM uses different terminology for INIT/SIPI versus
    everything else.
[2] https://lore.kernel.org/all/YvwxJzHC5xYnc7CJ@google.com
