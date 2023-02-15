Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E983A697F6A
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 16:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjBOPVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 10:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjBOPU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 10:20:59 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EF272A4
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 07:20:58 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id y28-20020a056a001c9c00b005a8c5cd5ae9so4290723pfw.22
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 07:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iDukbJdwBzqD8cf3Dpo6Rb4XouWez9+Bscdl5lNP9jE=;
        b=ohreeci2tmJfITEyOGUGkEKnrkaY1n0D9pgJXvMVz+Ilu2jbR8TAIlYP/R/MvfTqoH
         Ke/LOWMGGHyEfy+IW2VArB3dtXeA4bi3uXACt8DqX1GWgBjY+uXq5j5yj1GtHhhUon4b
         6k18Uc8Loq/buM60b3SNXw401AaLdyv5aAhnpmy4R+cLSAi2cm9QXcqTswhCwnEg8YQG
         9hf5/D9JLV2TnBdAngWJEHUy6UDXLlG1/PY2bkNIJX0C9zaXP8G/CAvBsP/BnpKmOqA3
         VzbsnDa/AjdZIzeJ+zy4K6WPPAnhrS2rSjwkFtkxW+40qSsoq39UkbPolqF4/jU93dil
         JuQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iDukbJdwBzqD8cf3Dpo6Rb4XouWez9+Bscdl5lNP9jE=;
        b=G/3UhE3vJbiydJtHZ8cFpwXW0exe+WMxeGsQpByME84QUPKZEIxG9eXQuvB2jn4XmY
         U1tigrgW4kvx0FQCniKEmW2TzcF9I/VtLGNeDdoeZR6WoPlgYvHUHTT2DJ7ZD7XJ0tJS
         M+CcbcI3fNVjmVhH9s+wYBDlziAY6WqxPcDUjM1kbpOpmYj7D6q/uGgWg52SRmuK8p3+
         NCKv4ArpKx0aZtXYq4+UiceJ3RfEmp8Uot4sDnqqKsVyB6bcLCvStnlXYWUKD0GVEJdI
         48aDbbqrHECfa7OA7pMNk0zGUGjwkeWrhGDf9WcwKijBGMt/BGHeFZDHO9/BrPRlmuop
         72jA==
X-Gm-Message-State: AO0yUKWUqW+ZmksbPvd1RBqV80tjlz1vfePuSqV15pm+GTGMHe+s0KTa
        r0Sui/jJKGezlFDuJMnBehJXy9aSH+w=
X-Google-Smtp-Source: AK7set8S5SerR9f1nJdNDbGDT5znXEYryuJhEM9i7uc4EXq3U3S7jiJB/xHpbyswaGjzRWNCEa1V9zD4V/I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:338f:0:b0:4fb:9b70:2bfe with SMTP id
 z137-20020a63338f000000b004fb9b702bfemr461308pgz.2.1676474458212; Wed, 15 Feb
 2023 07:20:58 -0800 (PST)
Date:   Wed, 15 Feb 2023 07:20:56 -0800
In-Reply-To: <54d64f0e-871f-3004-d8a6-55c60affede0@gmail.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com> <20230210003148.2646712-7-seanjc@google.com>
 <54d64f0e-871f-3004-d8a6-55c60affede0@gmail.com>
Message-ID: <Y+z4WF03dD/ytPl9@google.com>
Subject: Re: [PATCH v2 06/21] KVM: x86/pmu: WARN and bug the VM if PMU is
 refreshed after vCPU has run
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
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

On Wed, Feb 15, 2023, Like Xu wrote:
> On 10/2/2023 8:31 am, Sean Christopherson wrote:
> > Now that KVM disallows changing feature MSRs, i.e. PERF_CAPABILITIES,
> > after running a vCPU, WARN and bug the VM if the PMU is refreshed after
> > the vCPU has run.
> > 
> > Note, KVM has disallowed CPUID updates after running a vCPU since commit
> > feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN"), i.e.
> > PERF_CAPABILITIES was the only remaining way to trigger a PMU refresh
> > after KVM_RUN.
> 
> A malicious user space could have saved the vcpu state and then deleted
> and recreated a new vcpu w/ previous state so that it would have a chance
> to re-set the features msr.

I don't follow.  vcpu->arch.perf_capabilities and kvm_vcpu_has_run() are per-vCPU,
creating another vCPU will not let userspace trigger this WARN.

> The key to this issue may be focused on the KVM_CREATE_VM interface.
> 
> How about the contract that when the first vcpu is created and "after
> KVM_RUN of any vcpu", the values of all feature msrs for all vcpus on
> the same guest cannot be changed, even if the (likely) first ever ran
> vcpu is deleted ?

I don't think that's necessary, as above the "freeze" happens per-vCPU.
