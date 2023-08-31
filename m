Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9DA78F0F1
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 18:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346729AbjHaQLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 12:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243712AbjHaQLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 12:11:10 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243F71B1
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 09:11:03 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-26d63b60934so1192678a91.1
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 09:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693498262; x=1694103062; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iB3LXAZFghXeVvnwdo2HBopRNlG+ea2UbPoVCxVRfBA=;
        b=My2nM8aOODM862BxpTUGmX4IcMAG1xm6wO95JhKAz1S5Vn7MDSWeZvm8Oso+VsDH5W
         QiaQRT7M+TUxOIc8Lm0vzwSI23WijX6igfuQcozYx/kGlOoRCsbT+byvPKeOEFm90Dld
         Fj1cvkjbuqr8BuYNW25gZ9GDJWd+Ojl5pPPr2I5UqjomnYsJpX1ZhGqq2iGwRSD4vlGM
         DflkZ0ocLSAWQEoz+feuFkRzTlPT7HPABxfij2b7ixbDazKrsDzf+ez8IhWNGG2CBITg
         2m10iF+W6w/3UMG2KEFPbpJbpolUBJsH9h9Mbo7XaGRLKSbiLw6q9oJedTphaJRB7ZlI
         BhJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693498262; x=1694103062;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iB3LXAZFghXeVvnwdo2HBopRNlG+ea2UbPoVCxVRfBA=;
        b=Kwjc/oz8F/nvU0oXpiWSewpFiEYufRzS0QR42Jw/7JuNw6wOd3JU5kP21JZs9862cc
         XbGJLEzRmLKwREgr7z7tuITWcPn+RdDm5M4xkRS/QzHLQKfHsTbraKWlxOQIbhqLCEAm
         0RDXisYcREkDrM5CBPGqtojQINb5nhpMz2bQWEM3hQAbfJHVEGt0AoxjOWpw7MnsG7kx
         9RNo5fTtno3/tTfmqwk0wsohkMXTeecgzFgYNwq1LNpTG9tX3kEz6QLov0W9l+p6tdbX
         0Nr4rFg7pLFemoaenJK4wcV4QsdMrvY4sN+XVGySMtR57HoDw1sCTpokRt6VEM9TZTH8
         INxA==
X-Gm-Message-State: AOJu0Yx6w7an2g3nlGC+phM9cPyVwGc6RXW6iUZpz5uP0Ldd6w3SXYP6
        trY2lAyJg8l8EtW/A8dc1mp2ufQ7kPM=
X-Google-Smtp-Source: AGHT+IGyBhJnapmMHK4Z1oZ4+3bPLoyELO7vJv0KTl0PtWnmatDJoHfM6+bwBYhcreMVseAOjaV1D4vE6sA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e557:b0:263:3437:a0b0 with SMTP id
 ei23-20020a17090ae55700b002633437a0b0mr1008643pjb.3.1693498262512; Thu, 31
 Aug 2023 09:11:02 -0700 (PDT)
Date:   Thu, 31 Aug 2023 09:11:00 -0700
In-Reply-To: <7a6488f2-fef4-6709-6a95-168b0c034ff4@gmail.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com> <20230729013535.1070024-17-seanjc@google.com>
 <6c691bc5-dbfc-46f9-8c09-9c74c51d8708@gmail.com> <ZO+roobNH2QbZZWn@google.com>
 <7a6488f2-fef4-6709-6a95-168b0c034ff4@gmail.com>
Message-ID: <ZPC7lLW8haAlQZu9@google.com>
Subject: Re: [PATCH v4 16/29] KVM: x86: Reject memslot MOVE operations if
 KVMGT is attached
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 31, 2023, Like Xu wrote:
> On 31/8/2023 4:50 am, Sean Christopherson wrote:
> > On Wed, Aug 30, 2023, Like Xu wrote:
> > > On 2023/7/29 09:35, Sean Christopherson wrote:
> > > > Disallow moving memslots if the VM has external page-track users, i.e. if
> > > > KVMGT is being used to expose a virtual GPU to the guest, as KVMGT doesn't
> > > > correctly handle moving memory regions.
> > > > 
> > > > Note, this is potential ABI breakage!  E.g. userspace could move regions
> > > > that aren't shadowed by KVMGT without harming the guest.  However, the
> > > > only known user of KVMGT is QEMU, and QEMU doesn't move generic memory
> > > 
> > > This change breaks two kvm selftests:
> > > 
> > > - set_memory_region_test;
> > > - memslot_perf_test;
> > 
> > It shoudn't.  As of this patch, KVM doesn't register itself as a page-track user,
> > i.e. KVMGT is the only remaining caller to kvm_page_track_register_notifier().
> > Unless I messed up, the only way kvm_page_track_has_external_user() can return
> > true is if KVMGT is attached to the VM.  The selftests most definitely don't do
> > anything with KVMGT, so I don't see how they can fail.
> > 
> > Are you seeing actually failures?
> 
> $ set_memory_region_test

...

> At one point I wondered if some of the less common kconfig's were enabled,
> but the above two test failures could be easily fixed with the following diff:

Argh, none of the configs I actually ran selftests on selected
CONFIG_KVM_EXTERNAL_WRITE_TRACKING=y. 

> diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
> index 62f98c6c5af3..d4d72ed999b1 100644
> --- a/arch/x86/kvm/mmu/page_track.h
> +++ b/arch/x86/kvm/mmu/page_track.h
> @@ -32,7 +32,7 @@ void kvm_page_track_delete_slot(struct kvm *kvm, struct
> kvm_memory_slot *slot);
> 
>  static inline bool kvm_page_track_has_external_user(struct kvm *kvm)
>  {
> -	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
> +	return !hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
>  }
>  #else
>  static inline int kvm_page_track_init(struct kvm *kvm) { return 0; }
> 
> , so I guess it's pretty obvious what's going on here.

Yes.  I'll rerun tests today and get the above posted on your behalf (unless you
don't want me to do that).

Sorry for yet another screw up, and thanks for testing!
