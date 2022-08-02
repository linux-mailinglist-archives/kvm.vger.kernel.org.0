Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E6F5883B5
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 23:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbiHBVnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 17:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiHBVnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 17:43:33 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AED19C01
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 14:43:32 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 206so9966945pgb.0
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 14:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=glIoMvy+V8piFljmDBSx1DXBvemkA6EbTrCh0bvpQQM=;
        b=bXtC5cvRALUa/1WE0ly/zfA9Ixmtzw5XKDDqJ7xA/MZ2JEiS0E84uQe9/5YDrlj1j1
         bPiKiu1wZ5qOKDN9EkX5fFU1UgNTVLbTTuGJNjJDmLCSdzSNfL3IFteLCTlz1lCwvgdJ
         7l/KGtCLKdTW+9LqNbdBak5iOfLoU8BzAyb4p4MRp62KCRXTcK6aEv+iuElX9guDUtF9
         A9dlpmOgwwMBQOSSCcAvoaHZLyxMFgFL+ccMmbyx7gdDjnIyRr1uqbTp0VCd0PXpZJbt
         C0s+liN2XOmtcDLOR5jgbx/uMe7kL1/foBA5s7E8Pi+GDq7JLbzmPxvQcQ8JFgeawTOH
         LZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=glIoMvy+V8piFljmDBSx1DXBvemkA6EbTrCh0bvpQQM=;
        b=xZXjPGqFgbR+CZseMvIQsHCli/m98JylOJGya2g8wDV26QN0/2Tf3ZIGGSBjN39NJE
         TabIkv7du7fwAdWy7OF0ktr1goEL7V726eDabzrACy2h2RrW6ThHiGsmvaGdc7DrLemM
         RzBX88MHoSRjRgxuVDt3J19TD97OLM2jxJRZbQV50dNN34jryl/qVybvv4bYTqnM4WcP
         WZ3CwS41z1KGbYeN+IkCOq2aol+brbrpA3LklQGrsvaIEdhzdPiXzhn2EGJqan1pQK/h
         tPrEmCLf3ouCQl/Imv8RALZFL5Pv+KplGbGdj6ZaFKGvE6YUpe32RPRVVpKm/OMBgrYh
         PPUg==
X-Gm-Message-State: AJIora/mkSx7a3b3cvue74M6/hJmJDTqkRE6WpOfNGifJi2vv+OM95dF
        JLs5umoiYSgz0U3a/SHKRDzdLQ==
X-Google-Smtp-Source: AGRyM1t8NwHkIq41xaU0E/q8nllWxF+IG4nAKsFzU5BfqUvk9QC8EJW8Bvrd7zkDShHaMjlywqZsRw==
X-Received: by 2002:a05:6a00:16ca:b0:52b:cc59:9488 with SMTP id l10-20020a056a0016ca00b0052bcc599488mr22807097pfc.0.1659476611335;
        Tue, 02 Aug 2022 14:43:31 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902ecc900b0016c28fbd7e5sm149763plh.268.2022.08.02.14.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 14:43:30 -0700 (PDT)
Date:   Tue, 2 Aug 2022 21:43:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dmytro Maluka <dmy@semihalf.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Move kvm_(un)register_irq_mask_notifier()
 to generic KVM
Message-ID: <Yumafj7MQrG6nRjr@google.com>
References: <20220715155928.26362-1-dmy@semihalf.com>
 <20220715155928.26362-2-dmy@semihalf.com>
 <YuLZng8mW0qn4MFk@google.com>
 <1cdff41c-c917-1344-02bc-ad5cf5c79ab1@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1cdff41c-c917-1344-02bc-ad5cf5c79ab1@semihalf.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 29, 2022, Dmytro Maluka wrote:
> On 7/28/22 20:46, Sean Christopherson wrote:
> > On Fri, Jul 15, 2022, Dmytro Maluka wrote:
> >> In preparation for implementing postponing resamplefd event until the
> >> interrupt is unmasked, move kvm_(un)register_irq_mask_notifier() from
> >> x86 to arch-independent code to make it usable by irqfd.
> > 
> > This patch needs to move more than just the helpers, e.g. mask_notifier_list
> > needs to be in "struct kvm", not "stuct kvm_arch".
> > 
> > arch/arm64/kvm/../../../virt/kvm/eventfd.c: In function ‘kvm_register_irq_mask_notifier’:
> > arch/arm64/kvm/../../../virt/kvm/eventfd.c:528:51: error: ‘struct kvm_arch’ has no member named ‘mask_notifier_list’
> >   528 |         hlist_add_head_rcu(&kimn->link, &kvm->arch.mask_notifier_list);
> >       |                                                   ^
> > make[3]: *** [scripts/Makefile.build:249: arch/arm64/kvm/../../../virt/kvm/eventfd.o] Error 1
> > make[3]: *** Waiting for unfinished jobs....
> >   AR      kernel/entry/built-in.a
> 
> Oops, sorry.
> 
> > And kvm_fire_mask_notifiers() should probably be moved as well, otherwise there's
> > no point in moving the registration to common code.
> 
> Good point, we can move it right away, even though it is not called on
> other architectures for now.
> 
> > The other option would be to make the generic functions wrappers around arch-specific
> > hooks.  But IIRC won't this eventually be needed for other architectures?
> 
> Right, I assume we will eventually need it for ARM at least. Not in the
> near future though, and at the moment I have no non-x86 hardware on hand
> to implement it for other architectures.
> 
> Actually I feel a bit uncomfortable with generic irqfd relying on
> kvm_register_irq_mask_notifier() which silently has no effect on other
> architectures. Maybe it's better to keep
> kvm_(un)register_irq_mask_notifier() in the x86 code, and for the
> generic code add a weak version which e.g. just prints a warning like
> "irq mask notifiers not implemented on this arch". (Or maybe instead of
> weak functions introduce arch-specific hooks as you suggested, and print
> such a warning if no hook is provided.) What do you think?

If the entire concept of having mask notifiers is x86 specific, then moving it to
generic code obviously doesn't make sense.  But if the concept applies to other
archictectures, then IMO the list belongs in "struct kvm" with generic, common
helpers, even if no other arch calls kvm_fire_mask_notifiers() at this time.

Paolo and/or non-x86 folks, any thoughts?
