Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCBA6987B1
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 23:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjBOWQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 17:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBOWQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 17:16:12 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C369B43913
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 14:16:10 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id k9-20020a25bec9000000b00944353b6a81so24241ybm.7
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 14:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XrCcxlLanE1hw5a0xpT0A8Dl5UAfprFd59vy3LFZr7U=;
        b=dufJ2caSE7pFyPwErBK72yheI6BZZubW5yttXJiCleUurjqI1LdcOFnLRJEucAOC8N
         kiPpkUsSj7pevYLtxNzxDUqK27tZ49f22RF6mmoNtfWPnMIdz+GPO96fG+B9OQX2R6Qw
         9JdPj3S9/VwZF8Md99zWuwkHulC+8rStLL9J1k9A62mJ/JuvnCStL4NTJwoU+R4WVIyS
         nEP7SiGCDp1bz9MiOEEiYfvBY3t+xv5prj49IFk7yePPMChOrT0xmNOcwZtX8QEqlHYR
         VVssn+QEDpqM5cUS+0tHavgKKf16cTPNZECAS/bhuarkPkUefaExERGxFJReGRXBL0ki
         377A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XrCcxlLanE1hw5a0xpT0A8Dl5UAfprFd59vy3LFZr7U=;
        b=ZWZZPR4jytVA5hk63QO7uE5t7XAldkn6yzNcfHY8oWrvBDEbn6A8cjQ+CbjByujJmn
         A9QdAYu0Tj2LqQb5HSnWch8Q7W75p1sHRkGjFtDWts9C9IZXCxDnM/5eZkMWYOVozuKn
         Iq1OHy9qi1orxL10nBZ0seRbs0UraYHZOqHAA9Ks8khHJm5eUbmIBmMoOyucWq9gbUrU
         +03CZuTG9C6xmgoDMRz74tsw6gXFnVsRYA0G5XJBmDQnbCekAKvIP3AY783W8KOoVhm8
         syTL90lW56iy7rgWM8h8L1XzOOWPa+M06gl9tezBVu9O/YWHu01h85qgTVOSTYqzwtfe
         OY0g==
X-Gm-Message-State: AO0yUKV+dAMjL1CRrzndTM7hc7wSwG1943TtcwRdIm1wgXUTn7KAhO+L
        Xh2u+rHqc8eN1N2bKcl5E+1ZWljxrnY=
X-Google-Smtp-Source: AK7set9RveR7cZTWuYyYEu3ndpHZHwVU9G84NUcj4gM2LYDO3EY5laHoBKVkf7tYCQur1RoShx22rpfXEpI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1024:b0:8fc:686c:cf87 with SMTP id
 x4-20020a056902102400b008fc686ccf87mr0ybt.4.1676499369677; Wed, 15 Feb 2023
 14:16:09 -0800 (PST)
Date:   Wed, 15 Feb 2023 14:16:07 -0800
In-Reply-To: <20d189fc-8d20-8083-b448-460cc0420151@linux.microsoft.com>
Mime-Version: 1.0
References: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
 <Y+p1j7tYT+16MX6B@google.com> <35ff8f48-2677-78ea-b5f3-329c75ce65c9@redhat.com>
 <Y+qLe42h9ZPRINrG@google.com> <CABgObfaZQOvt6v0yGz3MR7FBU7DcrTTGmS6M8RWCX0uy6WML1Q@mail.gmail.com>
 <20d189fc-8d20-8083-b448-460cc0420151@linux.microsoft.com>
Message-ID: <Y+1ZpxAkome9s1Ve@google.com>
Subject: Re: "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing" breaks SVM
 on Hyper-V
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tianyu Lan <ltykernel@gmail.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023, Jeremi Piotrowski wrote:
> On 13/02/2023 20:56, Paolo Bonzini wrote:
> > On Mon, Feb 13, 2023 at 8:12 PM Sean Christopherson <seanjc@google.com> wrote:
> >>> Depending on the performance results of adding the hypercall to
> >>> svm_flush_tlb_current, the fix could indeed be to just disable usage of
> >>> HV_X64_NESTED_ENLIGHTENED_TLB.
> >>
> >> Minus making nested SVM (L3) mutually exclusive, I believe this will do the trick:
> >>
> >> +       /* blah blah blah */
> >> +       hv_flush_tlb_current(vcpu);
> >> +
> > 
> > Yes, it's either this or disabling the feature.
> > 
> > Paolo
> 
> Combining the two sub-threads: both of the suggestions:
> 
> a) adding a hyperv_flush_guest_mapping(__pa(root->spt) after kvm_tdp_mmu_get_vcpu_root_hpa's call to tdp_mmu_alloc_sp()
> b) adding a hyperv_flush_guest_mapping(vcpu->arch.mmu->root.hpa) to svm_flush_tlb_current()
> 
> appear to work in my test case (L2 vm startup until panic due to missing rootfs).
> 
> But in both these cases (and also when I completely disable HV_X64_NESTED_ENLIGHTENED_TLB)
> the runtime of an iteration of the test is noticeably longer compared to tdp_mmu=0.

Hmm, what is test doing?

> So in terms of performance the ranking is (fastest to slowest):
> 1. tdp_mmu=0 + enlightened TLB
> 2. tdp_mmu=0 + no enlightened TLB
> 3. tdp_mmu=1 (enlightened TLB makes minimal difference)
