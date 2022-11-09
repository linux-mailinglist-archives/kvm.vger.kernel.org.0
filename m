Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6284B6236B1
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 23:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiKIWmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 17:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKIWmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 17:42:15 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DB2D13D
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 14:42:15 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id l2so18054pld.13
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 14:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKiMsUeXYzlgxWfF0WcmHUUjbEiQdWPsUbhG4FuUTvU=;
        b=cD4gLgROz4g4LtmSRbdLXGAjaJuR6pnQPfjazM0yU0Hn/lv/WT5o4Her5FZZKbaJvo
         3llk8DYE2nZDW2sbqQRiQfbjE1ZapQwwU0U2Cv08c9Ebk8FU0i0XK4awq7K7iidJf8OH
         3GcfjHTDxs/DR50LOoQvFL4LWTUNBDsk4dxtwc4SeMTKq2oVpauMgfCUNtsr3uNWy3cz
         RpG+CtA8bVTi2doo034FUCj8Kt6OAO4pYKClaQOLsbg15mz+DJmaYa7LRAgZji6biWZu
         +q6Wz7oH6l72tqHN4GUlfyDALVakTWYywy2upo+HFDthGSfQgKq+AvRIE4mmZZ0GudzA
         bgyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZKiMsUeXYzlgxWfF0WcmHUUjbEiQdWPsUbhG4FuUTvU=;
        b=s0QK98QsiTb29QwngcPsv56d7+64Af6i+GXiaKu0Hk3wzYHRE7uCCaUNoS3NcNM7Hd
         Rf6KKfx5h5lU+N5qXeeZUgfkgufjnc/RE2bE5nQgLD87Xcpfgm8vMhc0vU5WF5DLbuvZ
         pLWtwsKikp7ZwBVEV03L/AG70a0aTxRy6hcfy12NNe+SZ90LVhvVsPGUZANOTcoe7nXJ
         uybZ8Kou6Pcl3pUQJvZwCKc4R92KnqmcOGRQyfW37hKfWyqDeIEyjFKkVEcasOVihueX
         Szdv37Eqpt+zDcqSf9PKnmOJ6xdHMlISe/obK0Qf+0qFv6WCSFytxDvrS+NXEafzpiRn
         QvWA==
X-Gm-Message-State: ACrzQf3a3ee+t2b0b5fnqXvUd2AeNsoZvuccgzTDv92Seyo0lM9pvNHD
        gUbLUyOhZFAI4/gcZW/YIj0wMg==
X-Google-Smtp-Source: AMsMyM7VhBvIBJZq8DOffvWOeCdh5Qe5jEL63Uu0jploe/nMqN4VkZSgtUrZB0hVopNblvbQ13kL9w==
X-Received: by 2002:a17:902:e811:b0:186:8a61:ea76 with SMTP id u17-20020a170902e81100b001868a61ea76mr63663058plg.10.1668033734747;
        Wed, 09 Nov 2022 14:42:14 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f5-20020a655505000000b00434760ee36asm7850505pgr.16.2022.11.09.14.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 14:42:14 -0800 (PST)
Date:   Wed, 9 Nov 2022 22:42:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 09/14] KVM: arm64: Atomically update stage 2 leaf
 attributes in parallel walks
Message-ID: <Y2wswsHgDHIIXram@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-10-oliver.upton@linux.dev>
 <CANgfPd9SK=9jUYh+aMXwYCf2-JtoJtSZ_BDmbjiZX=nvG-9uXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9SK=9jUYh+aMXwYCf2-JtoJtSZ_BDmbjiZX=nvG-9uXA@mail.gmail.com>
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

On Wed, Nov 09, 2022, Ben Gardon wrote:
> On Mon, Nov 7, 2022 at 1:58 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > @@ -1054,7 +1066,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
> >  bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
> >  {
> >         kvm_pte_t pte = 0;
> > -       stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL);
> > +       stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL, 0);
> 
> Would be nice to have an enum for KVM_PGTABLE_WALK_EXCLUSIVE so this
> doesn't just have to pass 0.

That's also dangerous though since the param is a set of flags, not unique,
arbitrary values.  E.g. this won't do the expected thing

	if (flags & KVM_PGTABLE_WALK_EXCLUSIVE)

I assume compilers would complain, but never say never when it comes to compilers :-)
