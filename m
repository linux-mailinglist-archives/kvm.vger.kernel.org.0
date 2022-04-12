Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E6A4FE665
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 18:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357883AbiDLQ72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 12:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbiDLQ71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 12:59:27 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1555F4DA
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 09:57:09 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id h15-20020a17090a054f00b001cb7cd2b11dso3650118pjf.5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 09:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yr7tTIqvdQEdgguyCeZ5NPGFEfx6YJUOR7r+7xfLEos=;
        b=ft1f9O0xWxl+XERRl50bUXGuCTkcpeNHvfs2Xd9zXfMKQQHin2adrFAVgsssvV5c8o
         EWt/OqN+bJsX08ywBG7Wxj0s0UIqvpfadFpaRw6Gr9zmGR0ZJE0JbRujhohWX9iqAyXF
         hylMiHWEHpPwc5kjEixKeoNH6xdwPtloIpDWN6eEICwJhRB1LgBl5SHFrjoZ/XUhF2MJ
         A29vc6oGfjMcZJJLLnc57a6GcPVvb3lDJ+hOxfbYc5Rv5YGVlkbhW6CJPWFyNtzYV2Kc
         5Zmn+sbHdEfAUm1MDmKj+UbxnKhn6AygBryYlpkVs2sDPpSbnblm5mZSdRa6pl+xI9CK
         2NFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yr7tTIqvdQEdgguyCeZ5NPGFEfx6YJUOR7r+7xfLEos=;
        b=brR5as8kYdn4q0ASGVL2nOeHvQJYg3Z+0hOdgkJLK1OaN5ORmEgq3uXuPnonAy6rHb
         XBCwnJp30yvAvnXL5qM/SamaJ+JWi8eFaLqEAdnhLfQOXbWgPtrKy4Ojh3w2EwGksRRa
         vrEhxxMgEsCQcKB6v35K+xnzqfHHjRq4CoiJ1fj81k7d4H0ZBK/yEAryJ/0vdvzvPrSR
         Svcw7W85xrfo5zHKhjQzyxhq2LIzMu2nOaIb8YgpyLNFDO2Cqe8/8xZJdiCWfAkTzaj4
         VqOIokgXV+a7c0gc+EktKjxboZav5JORhlG7xZmOcnpIsSh+jPMWMMO5gT30dbmFuEjc
         yMcg==
X-Gm-Message-State: AOAM530xqc+72qzR3EgDntge8I0GpdlBQsRPnP1sCeiGYanWhQ5ZalLL
        b/AL//Z15+CH7bG8+oyHdJEBU7eGElNndw==
X-Google-Smtp-Source: ABdhPJz9MfZ4kYDdUxCq+1wwwqr6bhq5tzOhOI5Z+/klqizhkQ2zn2yuqsS3TDHr6ZTsqAr/oVkXng==
X-Received: by 2002:a17:903:281:b0:14c:f3b3:209b with SMTP id j1-20020a170903028100b0014cf3b3209bmr38522483plr.87.1649782628346;
        Tue, 12 Apr 2022 09:57:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h14-20020a63384e000000b00366ba5335e7sm3341071pgn.72.2022.04.12.09.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 09:57:07 -0700 (PDT)
Date:   Tue, 12 Apr 2022 16:57:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Add support for CMCI and UCNA.
Message-ID: <YlWvX9JakRD7IzcD@google.com>
References: <20220323182816.2179533-1-juew@google.com>
 <YlR8l7aAYCwqaXEs@google.com>
 <CAPcxDJ4iXwSRK9nRTemkMvhjE5WePeLuc0-60eRCOq5bRRHX0A@mail.gmail.com>
 <CAPcxDJ7gJD-iC0usZj5U88V4JGUdQ=Bwt-DSgVWwSt7yTTz1AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcxDJ7gJD-iC0usZj5U88V4JGUdQ=Bwt-DSgVWwSt7yTTz1AA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, Jue Wang wrote:
> On Tue, Apr 12, 2022 at 7:22 AM Jue Wang <juew@google.com> wrote:
> > > > +             return 0;
> > > > +
> > > > +     if (lapic_in_kernel(vcpu))
> > >
> > > Any reason to support UNCA injection without an in-kernel APIC?
> 
> Even without a viable path for CMCI signaling, the UCNA errors should
> still be logged in registers so it gives consistent semantics to
> hardware for e.g., MCE overflow checks on an MCE signaled later.

Right, what I was suggesting is that KVM reject the ioctl() if the VM doesn't
have an in-kernel APIC, i.e. force userspace to use KVM's local APIC if userspace
wants to also support UNCA injection.

Side topic, please trim your replies, i.e. delete all the unnecessary quoted context.
