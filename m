Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03BD47611F
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 19:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344033AbhLOSxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 13:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239233AbhLOSxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 13:53:20 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7611EC061574
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 10:53:20 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n15-20020a17090a394f00b001b0f6d6468eso4798999pjf.3
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 10:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ofLlu4vI5oc9F8yAJdCo2OL049xmEG3qVfEzoCZNq3s=;
        b=MMJevBACLSGNrI/y7YuIZH+V5RiQOSjeHU/mv8xomCH7Ptt3x6NoWOf12uOpSaepTL
         oz43yH4EfiYWtioiIgG9ttyi0MQaKOdZVf8oGHQxW6xZCLKdWdagO+MSKK0bF7u0XjdR
         CiMVoL4aAsV4+CB8dGJGAIsXrivRu5wTzLdMmJqBJj8W3wbOPc74y/2+0tygeu9jMSmg
         TspE2ykXZam7FhK4ugTgnmh91SvE2qS9tMUSuMGEn3jAzNP2Xwmwu4ebE6jfBz9vO9eX
         tBNwPhqJxXByXbKYNymRMoNwo1LHIm2ARkG7iCQIHeqEbdp50AkCFUIt/nrBNp/hdbYQ
         0tXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ofLlu4vI5oc9F8yAJdCo2OL049xmEG3qVfEzoCZNq3s=;
        b=V5Rcg4GTKDWeXyCA6eXYc7bbNlYKey+2j3nM6pUQAJTAStbwQa2hxm71nPvdaCpm2R
         /GxrkOywvq04MD06G2728kYQVXUL4VJlrW5+YE4LgPsl7uoz/TF9sgq2XzLzYxMftfS/
         0hxwn5zrM4Puek6kD1vhqaQJgxuebtK214teKQamD38VY+YJ4ZkxRUS6v/1hR+5FuadU
         9W3yf/zZj3zVtmc0e5DVF6arWX07v0DZcHUx57QDw83wZjS4dr70s+IqlndqsMcpLP+t
         Zk+mDBUGLoPXG7P6Mn4nzgcevO/yZ/VWaCdafJlAlfd+SRQzvfx6yZSZmh6Y+pHcQudY
         g3MQ==
X-Gm-Message-State: AOAM533fZrpKYYHWE/ZjuSw8GDUN3GBqWmMT43gXzvgYA1YSGKzeQmHA
        k5aY/LsvoLP9eJjU1wPDX71Teg==
X-Google-Smtp-Source: ABdhPJzjhnHaeY3OeD8Fy2oSut8c+bZMl2MgbvLYlH0uRFnNZ4HEAlsbNgGVabQMuhkGW18U/fNsAg==
X-Received: by 2002:a17:902:b615:b0:143:bbf0:aad0 with SMTP id b21-20020a170902b61500b00143bbf0aad0mr12280273pls.12.1639594399798;
        Wed, 15 Dec 2021 10:53:19 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g18sm3672838pfj.142.2021.12.15.10.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 10:53:19 -0800 (PST)
Date:   Wed, 15 Dec 2021 18:53:16 +0000
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
Message-ID: <Ybo5nOu7/bVPhzCK@google.com>
References: <20211209060552.2956723-1-seanjc@google.com>
 <20211209060552.2956723-2-seanjc@google.com>
 <c94b3aec-981e-8557-ba29-0094b075b8e4@redhat.com>
 <YbN58FS67bEBOZZu@google.com>
 <8ab8833f-2a89-71ff-98da-2cfbb251736f@redhat.com>
 <YbOLRLEdfpl51QLS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbOLRLEdfpl51QLS@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021, Sean Christopherson wrote:
> On Fri, Dec 10, 2021, Paolo Bonzini wrote:
> > On 12/10/21 17:01, Sean Christopherson wrote:
> > > > KVM_REQ_MMU_RELOAD is raised after kvm->arch.mmu_valid_gen is fixed (of
> > > > course, otherwise the other CPU might just not see any obsoleted page
> > > > from the legacy MMU), therefore any check on KVM_REQ_MMU_RELOAD is just
> > > > advisory.
> > > 
> > > I disagree.  IMO, KVM should not be installing SPTEs into obsolete shadow pages,
> > > which is what continuing on allows.  I don't _think_ it's problematic, but I do
> > > think it's wrong.
> > > 
> > > [...] Eh, for all intents and purposes, KVM_REQ_MMU_RELOAD very much says
> > > special roots are obsolete.  The root will be unloaded, i.e. will no
> > > longer be used, i.e. is obsolete.
> > 
> > I understand that---but it takes some unspoken details to understand that.
> 
> Eh, it takes just as many unspoken details to understand why it's safe-ish to
> install SPTEs into an obsolete shadow page.
> 
> > In particular that both kvm_reload_remote_mmus and is_page_fault_stale are
> > called under mmu_lock write-lock, and that there's no unlock between
> > updating mmu_valid_gen and calling kvm_reload_remote_mmus.
> > 
> > (This also suggests, for the other six patches, keeping
> > kvm_reload_remote_mmus and just moving it to arch/x86/kvm/mmu/mmu.c, with an
> > assertion that the MMU lock is held for write).
> > 
> > But since we have a way forward for having no special roots to worry about,
> > it seems an unnecessary overload for 1) a patch that will last one or two
> > releasees at most 
> 
> Yeah, I don't disagree, which is why I'm not totally opposed to punting this and
> naturally fixing it by allocating shadow pages for the special roots.  But this
> code needs to be modified by Jiangshan's series either way, so it's not like we're
> saving anything meaningful.
> 
> > 2) a case that has been handled in the inefficient way forever.
> 
> I don't care about inefficiency, I'm worried about correctness.  It's extremely
> unlikely this fixes a true bug in the legacy MMU, but there's also no real
> downside to adding the check.
> 
> Anyways, either way is fine.

Ping, in case this dropped off your radar.  Regardless of how we fix this goof,
it needs to get fixed in 5.16.
