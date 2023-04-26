Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F796EF8CF
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 18:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbjDZQ4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 12:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjDZQ4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 12:56:04 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25A73599
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 09:56:02 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63d3b5c334eso4984108b3a.3
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 09:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682528162; x=1685120162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TLtDRjMjMhUauQTfVjTwks2U9xARAIB2c32l6X3FD+Q=;
        b=7dZxd0/7JHac0T+Cv2Wf4Z85eHRXtIHuNqAfzRAkmZf7OX37ouxMWyfnKNy0LQfCbv
         NhNDooT3eprDgzDK67IrumTU+QVW4ntQfUjZTCbtn0bhQPcsBP09aPjTsPZwlWs4rog+
         Zy0hP1AGcKh2rzywN1xwvChzFornLI3vdqGQ8iDZjpSd8IWObZJ12pVwAs+w5ABNTJlv
         pDbd7YSEEjrziDQ6+1rGAgZHgXb34776GLqnHM9rLPt0B+I8nRDVHnOrtrMVjrQBci1l
         bAyWOIh7Ll5dG2mpmfMPV+7Zyht9hESvhlEGk/FWqn+meWW7RLus8qqnP7n8TvZNETwg
         F24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682528162; x=1685120162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TLtDRjMjMhUauQTfVjTwks2U9xARAIB2c32l6X3FD+Q=;
        b=QF5NGbXFqInTCsqyTIlbq/laYui9ui/J3FY9Y80AxpjqJXH2mhpxDigZaDXD1lFB/u
         3Un+e2bjRwiA69fgrs917Y/vp16l+Hl45TuMnk/HAlpvrB50wxfZkB57r2qQOyXa+vrT
         YmTDO5pJ1kSpHbVsyOzX+gyR0ClUaivvrhnMEaZYCwxD3KYkpk9bLAb7cVd0NL0r9EFc
         qj9b0/9B2NDOtLJTeovUsa85YQYqOWZtC5lrQ9u6sZJz8hPO3J8go3vFHAQLpdICFxv2
         d/lS3V//l6MQ7ymzwTQcLbSvHRt/ZOm2AFbvCGIDJu5rUQsAknJLpywqY1CUCmiE29yI
         utbQ==
X-Gm-Message-State: AAQBX9dgfQbh/a8taWBAXE9STO6VkPx2z2XHeQlyH2AiC9l4yC1x+5z3
        Lbm2eCzGExRsGtDkVRjG+5r1POah558=
X-Google-Smtp-Source: AKy350Y3mlmjd1pqRsrZI2x6e/W959s9/299pvAYOMxJOnQ1S5fmSFYRp5P+DHpNT1clQpfA3W+fc7MQUo8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8890:0:b0:625:5949:6dc0 with SMTP id
 z16-20020aa78890000000b0062559496dc0mr8750261pfe.4.1682528162349; Wed, 26 Apr
 2023 09:56:02 -0700 (PDT)
Date:   Wed, 26 Apr 2023 09:56:00 -0700
In-Reply-To: <20230426082601.85372-1-abusse@amazon.com>
Mime-Version: 1.0
References: <20230426082601.85372-1-abusse@amazon.com>
Message-ID: <ZElXchs9iGMtS6vm@google.com>
Subject: Re: [PATCH] KVM: x86: Add a vCPU stat for #AC exceptions
From:   Sean Christopherson <seanjc@google.com>
To:     Anselm Busse <abusse@amazon.com>
Cc:     dwmw@amazon.co.uk, hborghor@amazon.de, sironi@amazon.de,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 26, 2023, Anselm Busse wrote:
> This patch adds a KVM vCPU stat that reflects the number of #AC
> exceptions caused by a guest. This improves the identification and
> debugging of issues that are possibly caused by guests triggering
> split-locks and allows more insides compared to the current situation
> of having only a warning printed when an #AC exception is raised.

Irrespective of the inaccuracy Xiaoyao pointed out, I don't want to add a one-off
stat for _any_ exception.  I agree with what Marc said[*] when we (Google / GCP)
tried to push our pile o' stats upstream:

 : Because I'm pretty sure that whatever stat we expose, every cloud
 : vendor will want their own variant, so we may just as well put the
 : matter in their own hands.

That doesn't mean I don't want a massive pile of stats about all things KVM, quite
the opposite, but I don't think they belong in upstream where KVM has to maintain
them in perpetuity.  E.g. at some point in the (distant) future, split-lock #AC will
be completely uninteresting because all software will have been updated/fixed.

FWIW, we looked at using eBPF for our out-of-tree stats and ultimately decided that
carrying patches to add our stats would be significantly easier to maintain than an
eBPF-based approach, e.g. rebasing this patch is trivial.  But the challenges we
anticipated with switching to eBPF were largely specific to running at scale.  eBPF
is a very viable approach for gathering information for debug, development,
individual users, etc.

On idea I had for easing the pain of out-of-tree stats was to clean up KVM x86's
tracepoints, e.g. to give eBPF programs more stable and useful hooks, but also to
allow CSPs like us to play macro games to "inject" stats at key points, e.g. add
infrastructure to #define overload tracepoints to make KVM trampoline through
out-of-tree stats code.  But we haven't pursued that idea because (a) as above,
carrying patches for out-of-tree stats requires minimal effort and (b) it wouldn't
eliminate "invasive" code because we'd (GCP) inevitably want stats in places where
a KVM tracepoint makes no sense.

So as much as I advocate for pushing code upstream, this is one of the few areas
where I think it's better to carry code out-of-tree.

[*] https://lore.kernel.org/all/875yusv3vm.wl-maz@kernel.org
