Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93ABE5EC937
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 18:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiI0QPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 12:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbiI0QOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 12:14:51 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8456659CC
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:14:45 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id p69so12904091yba.0
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=uPI0eUCHkgELEP3u77wl8KjA2DXRWktw1wegZiHPZWQ=;
        b=cZRkt9SO2twpu7WIfVGvdhSz6Kdt10eWgv4TBL4AguhAlttKh2vzzPekJ9T+IZwlp/
         vfAY/Lc/NVgc9qv4coDTk0qjvNIfzg5ncP09TcrGN9WMvkv30OerDZewFwsjZizr5FQQ
         NigiyHiGuvVCaTD9Clup8gMeKo/YRroa3dK3u/JfcpwIw5YLlOQl+ZT+pmYyvjewijAW
         5EfUECeSZqUeHy7gMjKmdH+k6ejoIG7zaZw8CKIoPxLXAF51uTgEOU60HXjwsfrMSeA4
         Z2dMEBgSCvtYEyxUEEEZekKNbS9Dmx07FZgQSiegE9KK5wIC6wt4PhStc99gq73e82Wr
         PRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=uPI0eUCHkgELEP3u77wl8KjA2DXRWktw1wegZiHPZWQ=;
        b=VxJESVf8sO5aD+2X8x+qFV+FQ7qdfQYf3uBagBumXYsgQpkzWwGCx5KT6umeP60a3C
         JijF6K0FLprUK9+IjsyNYH4PrhcpPVQyCQn5QzQKhdDxi907UkL9shQttJvdHAFLnuvC
         Ho37bHSMoFyKcruxFV1FePZl4rWTG8f1uoiAI6TUuVf3uW6cx9C4j51IAEZhoxRuRhvk
         xx6fczkWZxKFhWUb9ek1N/o7mZgmjocbBwEu/Qr3bhnoxHYJYDasKUF0cNccc4u4tq7/
         zmj7Xm0umQYyeYqQAUlv2p0cvHfgBbAxLTqba4SHk+gzy0c/9K20qDBJ/Bb3Vh0wkezf
         xOHw==
X-Gm-Message-State: ACrzQf1hycLJpJxIRKXNhDJkKWbPs3uo9Oa5CGUUCzkjJ5Ltuhe8FC3w
        5BvGLZNrxcpVJC6gP170hcp8Z2wsc54T4Ih4MhFEow==
X-Google-Smtp-Source: AMsMyM7nZez03GNMLpqPE+E6nzZkdWm3rlQ8l7rpg/mGMxwGDo864lyvzjJ3kCNFO1G1d7fWZ0r+FiulbdtFgN5101s=
X-Received: by 2002:a25:40c7:0:b0:6af:ee2:25aa with SMTP id
 n190-20020a2540c7000000b006af0ee225aamr27022142yba.326.1664295284235; Tue, 27
 Sep 2022 09:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220921173546.2674386-1-dmatlack@google.com> <20220921173546.2674386-2-dmatlack@google.com>
 <1c5a14aa61d31178071565896c4f394018e83aaa.camel@intel.com>
In-Reply-To: <1c5a14aa61d31178071565896c4f394018e83aaa.camel@intel.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 27 Sep 2022 09:14:17 -0700
Message-ID: <CALzav=d1wheG3bCKvjZ--HRipaehtaGPqJsDz031aohFjpcmjA@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only parameter
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Sep 27, 2022 at 2:19 AM Huang, Kai <kai.huang@intel.com> wrote:
>
>
> >
> > +bool __ro_after_init tdp_mmu_allowed;
> > +
>
> [...]
>
> > @@ -5662,6 +5669,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >       tdp_root_level = tdp_forced_root_level;
> >       max_tdp_level = tdp_max_root_level;
> >
> > +#ifdef CONFIG_X86_64
> > +     tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
> > +#endif
> >
>
> [...]
>
> > @@ -6661,6 +6671,13 @@ void __init kvm_mmu_x86_module_init(void)
> >       if (nx_huge_pages == -1)
> >               __set_nx_huge_pages(get_nx_auto_mode());
> >
> > +     /*
> > +      * Snapshot userspace's desire to enable the TDP MMU. Whether or not the
> > +      * TDP MMU is actually enabled is determined in kvm_configure_mmu()
> > +      * when the vendor module is loaded.
> > +      */
> > +     tdp_mmu_allowed = tdp_mmu_enabled;
> > +
> >       kvm_mmu_spte_module_init();
> >  }
> >
>
> Sorry last time I didn't review deeply, but I am wondering why do we need
> 'tdp_mmu_allowed' at all?  The purpose of having 'allow_mmio_caching' is because
> kvm_mmu_set_mmio_spte_mask() is called twice, and 'enable_mmio_caching' can be
> disabled in the first call, so it can be against user's desire in the second
> call.  However it appears for 'tdp_mmu_enabled' we don't need 'tdp_mmu_allowed',
> as kvm_configure_mmu() is only called once by VMX or SVM, if I read correctly.

tdp_mmu_allowed is needed because kvm_intel and kvm_amd are separate
modules from kvm. So kvm_configure_mmu() can be called multiple times
(each time kvm_intel or kvm_amd is loaded).

>
> So, should we just do below in kvm_configure_mmu()?
>
>         #ifdef CONFIG_X86_64
>         if (!tdp_enabled)
>                 tdp_mmu_enabled = false;
>         #endif
>
>
> --
> Thanks,
> -Kai
>
>
