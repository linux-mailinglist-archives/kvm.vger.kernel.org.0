Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B1D54388C
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 18:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245190AbiFHQNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 12:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245179AbiFHQNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 12:13:37 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0C3CFE12
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 09:13:36 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o6-20020a17090a0a0600b001e2c6566046so24277646pjo.0
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 09:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m3kvIC6WtUXKswj3UwH3plLtsrpkEWhat3U9xjuNqBo=;
        b=RmIxWJ96SN3ImjN70MGPV27c47ydh94sIUUauXreF5C+cSBd+X4FRvthrtgfFUlCXu
         Evqq83wGsKYpMlwU98dlDm931xvSNTJPiyXNeuWU7y2B5CyeXlCaR/o1frdBxqX21xSK
         l3y1K9S+HDkgCRhnpEjV/d8Mxxv9otaTU15g+jBuLtzJYmy9vnlrs65QMEAE433XYbY2
         8XSGnYoNDufVGMmKPdvnECWM3LH4k4Rx22P3yz60xdjr9JFWrvK+BUsTGRU35v8lqz02
         TZ3JqxgaVXBJtVWVcJl/XkGCFlsQKOLR6u9+856KMYt3cm1+HSxxEXJKGsosbl4uNoAl
         Tlww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m3kvIC6WtUXKswj3UwH3plLtsrpkEWhat3U9xjuNqBo=;
        b=FId2VtaPn1ZhEdSUa2DT/GHTn+MMyl5pIMwqnlBy7nYup1tI9FgU5lxWCsVoGbv17+
         MdXKHmFNy+B9kToQRQg8IoE16cPw3yEtATYGYAhMcLlA19voeukTbwYaOsNnJJeVSRTr
         JqNMV4/p2HBnWfTtmniPMLR6YJ6ofC9xXzCtJx7Qeqxx0S/0swRtMN9Xg+89cYvcuGJA
         z947GvAYqiHOwB6m27fS6+oLOupwh4YKNCFGlSCnI/9LaEFdZcgSOVcQqkMhtT/imovo
         sf45hYiujZ+hD8fuaATSurtsgXbnL1gcsHOWXNlwB0EnzsYpc5c22OLorKYU+JMza4C3
         h9Cw==
X-Gm-Message-State: AOAM531rbftMkNNrcbeXlDO5pBjvPEU19y7++4mcKq7FRj6pwLTEe3Ts
        sI+jyiJZqC8bf6f2aYdO1FF+0Q==
X-Google-Smtp-Source: ABdhPJyn4Qh42PxCtr+zv06ogrgkchKdEEQphz4zouHqjP09iYkInzJLD6QRVP3dx3InQb0JRT5qgg==
X-Received: by 2002:a17:90b:4d8a:b0:1e6:87ad:bfd3 with SMTP id oj10-20020a17090b4d8a00b001e687adbfd3mr36970045pjb.138.1654704815423;
        Wed, 08 Jun 2022 09:13:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i3-20020a170902eb4300b00161ccdc172dsm14756186pli.300.2022.06.08.09.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:13:34 -0700 (PDT)
Date:   Wed, 8 Jun 2022 16:13:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 045/144] KVM: selftests: Make vm_create() a wrapper
 that specifies VM_MODE_DEFAULT
Message-ID: <YqDKq2epCx6gno0c@google.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-46-seanjc@google.com>
 <20220608150142.nnhiyp5svrrkenxv@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608150142.nnhiyp5svrrkenxv@gator>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 08, 2022, Andrew Jones wrote:
> On Fri, Jun 03, 2022 at 12:41:52AM +0000, Sean Christopherson wrote:
> ...
> > +/*
> > + * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
> > + * loads the test binary into guest memory and creates an IRQ chip (x86 only).
> > + */
> > +struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
> > +struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
> > +
> >  static inline struct kvm_vm *vm_create_barebones(void)
> >  {
> > -	return __vm_create(VM_MODE_DEFAULT, 0);
> > +	return ____vm_create(VM_MODE_DEFAULT, 0);
> > +}
> > +
> 
> I don't [overly] mind the "____helperhelper" naming style, but in this
> case wouldn't __vm_create_barebones() also be a reasonable name?

I don't love the four underscores, but I want to use the "barebones" name only for
cases where the intent is to truly create a barebones VM, i.e. I want to avoid the
common path taking a dependency on "barebones".
