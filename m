Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17A065CB1B
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 01:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbjADAul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 19:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjADAuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 19:50:39 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF5F295
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 16:50:38 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n12so21733868pjp.1
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 16:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qiXxV2Hfa6NF/4ylZM+g7WvF4+7PZbuEwjwOszBrON4=;
        b=X1gfDcjSYLcBbE0MBBhwhK7htLKCvb7xiAhW84JJ8aR2Pj4C/Pqyu1xYLrpco24N6I
         C9J4IiYkw3j/UaqXUUFDvfYuxTV/W1PEByDZO0nLhXVDhQBEEYbkWvAc/QrdgV/sWe9p
         yd8EukT4278a/13eUsqTspQqTK+PO/lrb3dgkeuFP/Ggm6iHdv5OIvhBRaqiDmz+DT6m
         G5aOcyJFapCbF7bqQlrlr6MLuKYN3wDADKSYL+m4fAeRxOZiGuwWYXVA3rpzpNcqEhgh
         G851VezyQ+DuRZMMfEVjF8ForgLRPohL1fV6h73KcisSwFQS0nRBEESKvhxtVc2Sx9vL
         9xpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qiXxV2Hfa6NF/4ylZM+g7WvF4+7PZbuEwjwOszBrON4=;
        b=bxBjbSameyMYA6S43NYbDH1MD9ZpUfPvgaYwyOig+lA/0HXsBjg3UrViK9hoUvrAPA
         4j/AMRtj4sl770YMWXN0AL0rD5r1D9oPObjnnNn91CUu4oopbDzsSZyq5oF0tCDMaD4P
         ksNqPBqjKf2v18r9zG8c8nny4aGPM6D9XOnZ1AvmrQ8codYTioOBr7iX1Hc6KwUEgurg
         cTiL5BqFV8TXIEz7XILww8PqlMV5FHgfKDd2qPsrVFzGR6VzlkVRKXacAxb9osxejVuA
         KapvzqPRbJQL6esqOsXaJaYQQEt2hXY4KcLYuPNfNDFlGl4wmKdvx9C1rlQcwnI/+17+
         yPVQ==
X-Gm-Message-State: AFqh2kpsFRQRddTx8xXZdo9mxehwRuUjwIfiy/Tr7f+mhbuFkv/L8yoq
        7BuK0IYNvP+Z+j5g9c7VZPp68Q==
X-Google-Smtp-Source: AMrXdXvtFqhaSn3Tw9QYHWUPgyOXDjo3XDFOrsnNrIE80F2Yb82IIBW1/ye7zb7YefnrkcgKD3AD/w==
X-Received: by 2002:a17:90a:8b8c:b0:219:c2f2:f83c with SMTP id z12-20020a17090a8b8c00b00219c2f2f83cmr3726315pjn.2.1672793437914;
        Tue, 03 Jan 2023 16:50:37 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id mt2-20020a17090b230200b00225dfb6e8b3sm16083571pjb.11.2023.01.03.16.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 16:50:37 -0800 (PST)
Date:   Wed, 4 Jan 2023 00:50:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 19/27] KVM: x86/mmu: Use page-track notifiers iff there
 are external users
Message-ID: <Y7TNWYaJ9PA6HZL0@google.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-20-seanjc@google.com>
 <Y6vogAvkktOPLwK9@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6vogAvkktOPLwK9@yzhao56-desk.sh.intel.com>
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

On Wed, Dec 28, 2022, Yan Zhao wrote:
> On Fri, Dec 23, 2022 at 12:57:31AM +0000, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> > index 2b302fd2c5dd..f932909aa9b5 100644
> > --- a/arch/x86/kvm/mmu/page_track.c
> > +++ b/arch/x86/kvm/mmu/page_track.c
> > @@ -193,6 +193,7 @@ bool kvm_slot_page_track_is_active(struct kvm *kvm,
> >  	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
> >  }
> >  
> > +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
> >  void kvm_page_track_cleanup(struct kvm *kvm)
> >  {
> >  	struct kvm_page_track_notifier_head *head;
> > @@ -208,6 +209,7 @@ int kvm_page_track_init(struct kvm *kvm)
> >  	head = &kvm->arch.track_notifier_head;
> >  	INIT_HLIST_HEAD(&head->track_notifier_list);
> >  	return init_srcu_struct(&head->track_srcu);
> > +	return 0;
> Double "return"s.

Huh, I'm surprised this didn't throw a warning.  I'm pretty sure I screwed up a
refactoring, I originally had the "return 0" in an #else branch.

> > +#endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */
> > +
> > +static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> > +					const u8 *new, int bytes)
> > +{
> > +	__kvm_page_track_write(vcpu, gpa, new, bytes);
> > +
> Why not convert "vcpu" to "kvm" in __kvm_page_track_write() ?

No reason, I just overlooked the opportunistic cleanup.  I'll do this in the next
version.

Thanks much for the reviews!
