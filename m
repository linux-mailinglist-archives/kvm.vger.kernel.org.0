Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C054B5462B3
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344642AbiFJJqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343647AbiFJJqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:46:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADA393DB6D6
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 02:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654854402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uFSrK6QjMWjmxXq2UmX5nbX9kQXYdC0Rrd+ljS/aypg=;
        b=gvJf3cpaxmpCB7V+FpJt47g7vieC2kmFVyl3nF5ssvmvuuwoS+IevRUmXaOODKbOFz0AfP
        0zVMFQOYk2IMiS7Dj7nAvodJAkBsXfq3+qH/H7uFQD8AW4Sa7LhVlf5U9gHgz6TwOLGzS7
        o3L3RudrQGzXNDcqbdn9+DnHVnxSONo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-ahJ8_wqOPYmKAYPYyfBNLg-1; Fri, 10 Jun 2022 05:46:41 -0400
X-MC-Unique: ahJ8_wqOPYmKAYPYyfBNLg-1
Received: by mail-wr1-f69.google.com with SMTP id bv8-20020a0560001f0800b002183c5d5c26so3916470wrb.20
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 02:46:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uFSrK6QjMWjmxXq2UmX5nbX9kQXYdC0Rrd+ljS/aypg=;
        b=JYh90Bo35wboWPk+B7IVZ7MHWv+9Y9ABhnvKzI1rx35n6sK4TwQdUSu5H1CTgThG5L
         PkRrOYU/WWE7QPwhfCY0HXg21m4+/F8LBVx0TT8TuPGFDZuPMpYohklF/t8y2uTFxJyZ
         udvL2uOWGS3zDVlhUfp9r6Y6NDJWhPNVrPvQsMPmAuXGL5OEM0XUmVj7UkwJdQbp6PjW
         Goj8OzBujRhcY3NSn/HbMLis0NWckj7jqaDa0mXOyBsGjnluXY7wL/NfekuDyH/XfOH3
         d/BDIeUtvwWvNhZYh0uLTKI0G9bimyzB5pRXHot9mTD6a9DCQM9jF8DCknn68BwICKKu
         LLVg==
X-Gm-Message-State: AOAM531HXNAXXi0QozlEcHscrs/qpDIpCnbb3DOduuKewd7Ma+9TQRXK
        pyP1XMyVU/tJg7PuN5LbXpyufy0hoB2I0imCdDxQawebxCIcWi0OsF25xsjVI+cOdAV4Gugkhpx
        C7uy9ZIeLB68x
X-Received: by 2002:a1c:4c12:0:b0:39c:6750:be17 with SMTP id z18-20020a1c4c12000000b0039c6750be17mr8137806wmf.21.1654854400462;
        Fri, 10 Jun 2022 02:46:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwU3TqojSiB2ZPtENgLzReySdlXbwaYQW8P6z/18TZYg166Ti+yAosoW2JeaOyBpxeWpicnZA==
X-Received: by 2002:a1c:4c12:0:b0:39c:6750:be17 with SMTP id z18-20020a1c4c12000000b0039c6750be17mr8137784wmf.21.1654854400250;
        Fri, 10 Jun 2022 02:46:40 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id b11-20020a5d4d8b000000b0020c7ec0fdf4sm31494421wru.117.2022.06.10.02.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 02:46:39 -0700 (PDT)
Date:   Fri, 10 Jun 2022 11:46:37 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org,
        anup@brainfault.org, Raghavendra Rao Ananta <rananta@google.com>,
        eric.auger@redhat.com
Subject: Re: [PATCH v2 000/144] KVM: selftests: Overhaul APIs, purge VCPU_ID
Message-ID: <20220610094637.lg5wf2f2w2pez4dq@gator>
References: <20220603004331.1523888-1-seanjc@google.com>
 <21570ac1-e684-7983-be00-ba8b3f43a9ee@redhat.com>
 <93b87b7b5a599c1dfa47ee025f0ae9c4@kernel.org>
 <YqEupumS/m5IArTj@google.com>
 <20220609074027.fntbvcgac4nroy35@gator>
 <YqIPYP0gKIoU7JLG@google.com>
 <YqItO2cbsGDSyxD8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqItO2cbsGDSyxD8@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 09, 2022 at 05:26:19PM +0000, Sean Christopherson wrote:
> On Thu, Jun 09, 2022, Sean Christopherson wrote:
> > On Thu, Jun 09, 2022, Andrew Jones wrote:
> > > On Wed, Jun 08, 2022 at 11:20:06PM +0000, Sean Christopherson wrote:
> > > > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > > index b3116c151d1c..17f7ef975d5c 100644
> > > > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > > @@ -419,7 +419,7 @@ static void run_test(struct vcpu_config *c)
> > > > 
> > > >         check_supported(c);
> > > > 
> > > > -       vm = vm_create_barebones();
> > > > +       vm = vm_create(1);
> > > 
> > > Hmm, looks like something, somewhere for AArch64 needs improving to avoid
> > > strangeness like this. I'll look into it after we get this series merged.
> > 
> > Huh, you're right, that is odd.  Ah, duh, aarch64_vcpu_add() allocates a stack
> > for the vCPU, and that will fail if there's no memslot from which to allocate
> > guest memory.
> > 
> > So, this is my goof in
> > 
> >   KVM: selftests: Rename vm_create() => vm_create_barebones(), drop param
> > 
> > get-reg-list should first be converted to vm_create_without_vcpus().  I'll also
> > add a comment explaining that vm_create_barebones() can be used with __vm_vcpu_add(),
> > but not the "full" vm_vcpu_add() or vm_arch_vcpu_add() variants.
> 
> Actually, I agree with your assessment.  A better solution is to open code the
> calls to add and setup the vCPU.  It's a small amount of code duplication, but I
> actually like the end result because it better documents the test's dependencies.
> 
> Assuming it actually works, i.e. the stack setup is truly unnecessary, I'll add a
> patch like so before the barebones change.
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index ecfb773ec41e..7bba365b1522 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -418,7 +418,8 @@ static void run_test(struct vcpu_config *c)
> 
>         vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
>         prepare_vcpu_init(c, &init);
> -       aarch64_vcpu_add_default(vm, 0, &init, NULL);
> +       vm_vcpu_add(vm, vcpuid);
> +       aarch64_vcpu_setup(vm, 0, &init);
>         finalize_vcpu(vm, 0, c);
> 
>         reg_list = vcpu_get_reg_list(vm, 0);
>

LGTM, Thanks 

