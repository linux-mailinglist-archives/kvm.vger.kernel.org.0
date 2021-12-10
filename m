Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFBD4706D2
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 18:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244433AbhLJRTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 12:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240541AbhLJRT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 12:19:28 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC65C061746
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 09:15:53 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id f125so8670690pgc.0
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 09:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UMrzB2tdu6/xx/d1uQQ6wQQLAITMIeubpud/gYna4to=;
        b=i2zf9phpRnges3aEO7Diyhs1nKOw8VKTrbbCYgbFzd1baWaHz0IuhEhf1KNVZ0QWOQ
         UL/LDQ5hBk0H6evJltP87hDp/kj58MPuJ+v7IOyTuLCoOSNpVIQMoVMy5mDkqPReGYYP
         guDN4k4gHfLgdhI1Ml0k7HkdOfUY3PYWFepjLjT//ogNpTrQjk+SRcv2onIKpD87HZLn
         IjtwSQaeRjk6YpL6HceEaX7+TVGYwIPurv35m9BAzk16mtiHNtiBVsKxzm9lDLurisyE
         WvW0Y2YnhNShD/pJhGm/16YKyACH6nciiAC2IqMG6E6gJ/pMn1VeDIy4bQhzvaeQgcXP
         0Fnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UMrzB2tdu6/xx/d1uQQ6wQQLAITMIeubpud/gYna4to=;
        b=PwXYUTAss7I8uVEbEd+8w8VwT0BLgUDWCO5jYzsRpQXjNoDjVjgU8gxCxxpgsi9oHp
         Fv3W2lAu30OIYs3P1orySKuCXy/ltn/k5UwoBrKpqTaNt1voLmISlUcMuyHfMz5Ip1fD
         rAU5dBR6YWQmmNkvtIC20FKyHvYXRQdwQw5cWvKBbElRk2k5UhAF4jKOd5zN+HByQjhA
         W6qydQ6cftu4ZO5Rnj9GbScONnCbfiSarDjgANP8Dr6FgXr5YE220y4ULi6TgZRp8e4v
         nduiqiiXanHo8Q5LZqo4b3Qk15PGZJuK2BTOPwjppczvX4BoJS2xgr7orLI1yVXLW72v
         ijUA==
X-Gm-Message-State: AOAM53006ZuJ8LmMh6ij0VZ/k74AokN3ZqkY9tP18E0Ss0Aa3b8oX1BE
        XRIPt72hVNDSHl5X2qmzM9imYg==
X-Google-Smtp-Source: ABdhPJzF3nvXT/AaT07Jxwm0Zi8wGnHag5H/JWznkFCDD3izvMG8NkoU7eJTWyvx2x+Sdxqe9DqjIw==
X-Received: by 2002:a05:6a00:1c56:b0:4a4:f8cb:2604 with SMTP id s22-20020a056a001c5600b004a4f8cb2604mr19377491pfw.34.1639156552569;
        Fri, 10 Dec 2021 09:15:52 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w6sm4184989pfu.172.2021.12.10.09.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:15:52 -0800 (PST)
Date:   Fri, 10 Dec 2021 17:15:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH 1/7] KVM: x86: Retry page fault if MMU reload is pending
 and root has no sp
Message-ID: <YbOLRLEdfpl51QLS@google.com>
References: <20211209060552.2956723-1-seanjc@google.com>
 <20211209060552.2956723-2-seanjc@google.com>
 <c94b3aec-981e-8557-ba29-0094b075b8e4@redhat.com>
 <YbN58FS67bEBOZZu@google.com>
 <8ab8833f-2a89-71ff-98da-2cfbb251736f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ab8833f-2a89-71ff-98da-2cfbb251736f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021, Paolo Bonzini wrote:
> On 12/10/21 17:01, Sean Christopherson wrote:
> > > KVM_REQ_MMU_RELOAD is raised after kvm->arch.mmu_valid_gen is fixed (of
> > > course, otherwise the other CPU might just not see any obsoleted page
> > > from the legacy MMU), therefore any check on KVM_REQ_MMU_RELOAD is just
> > > advisory.
> > 
> > I disagree.  IMO, KVM should not be installing SPTEs into obsolete shadow pages,
> > which is what continuing on allows.  I don't _think_ it's problematic, but I do
> > think it's wrong.
> > 
> > [...] Eh, for all intents and purposes, KVM_REQ_MMU_RELOAD very much says
> > special roots are obsolete.  The root will be unloaded, i.e. will no
> > longer be used, i.e. is obsolete.
> 
> I understand that---but it takes some unspoken details to understand that.

Eh, it takes just as many unspoken details to understand why it's safe-ish to
install SPTEs into an obsolete shadow page.

> In particular that both kvm_reload_remote_mmus and is_page_fault_stale are
> called under mmu_lock write-lock, and that there's no unlock between
> updating mmu_valid_gen and calling kvm_reload_remote_mmus.
> 
> (This also suggests, for the other six patches, keeping
> kvm_reload_remote_mmus and just moving it to arch/x86/kvm/mmu/mmu.c, with an
> assertion that the MMU lock is held for write).
> 
> But since we have a way forward for having no special roots to worry about,
> it seems an unnecessary overload for 1) a patch that will last one or two
> releasees at most 

Yeah, I don't disagree, which is why I'm not totally opposed to punting this and
naturally fixing it by allocating shadow pages for the special roots.  But this
code needs to be modified by Jiangshan's series either way, so it's not like we're
saving anything meaningful.

> 2) a case that has been handled in the inefficient way forever.

I don't care about inefficiency, I'm worried about correctness.  It's extremely
unlikely this fixes a true bug in the legacy MMU, but there's also no real
downside to adding the check.

Anyways, either way is fine.
