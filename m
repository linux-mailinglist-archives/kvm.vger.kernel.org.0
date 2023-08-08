Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D962774F00
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 01:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjHHXLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 19:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjHHXLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 19:11:24 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF17101
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 16:11:23 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2680007cdeaso4154075a91.1
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 16:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691536282; x=1692141082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ojsc/u6rUVpX8HdGmZzouIRwar1EemcmsKTh2MHMIRg=;
        b=06plQQVWsgx7IKWxM0lUaNqesObzvOL8NEZgPuTF70P/ac3lodpKxIkb0jj9Bjgohs
         hkAsa1AunIVA+5m6CaKJ4QPvWYMSmjfHdNVkluxlzHt9GDpIIcBG+pQH0NOofk7pRPcG
         UEQliX2XJed/IR9kx4J++VPBFUpJi+rPKV3BBy3gmHNdoN/pyrFDA08l8wRcIRpMhAuL
         PSWcRS0KzMDoQbHpvNFKcBeQ0ZZ6jLxJPB9qtsvDvzFJj2ljHkhhAXZm7AcAIYYTJ8Ex
         AwA0veMnDzZM2bCWrq+U1gCyF4gZyUmwAenlNWYLLAPyyTXMjHX34yJaySH7VIrfC0zx
         0ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691536282; x=1692141082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ojsc/u6rUVpX8HdGmZzouIRwar1EemcmsKTh2MHMIRg=;
        b=ItDqKeCmMTwsDkKPOQEBp4GFVZbC6VAKhgVoTRwGLn4DFQ1nh1rnyKlfDTij16GWuA
         Ln9x5oX4L7rbdHaRcoEjRXgMfUwgZ4rDwzdC/UHxjbG5HESghoVsa02gea9X+0D5AYGt
         RwxlB+LwYEkWamwFRhuOIgTNqUxu3YeQHNJOJLc7SErnxMRBU5aPZRsaXMU1NzOm8Lq3
         SJLhMR7H0FAohcuTXq6YCkGoG0rWCpheLQo48Gb0YiACy+x3wEvFKSj1VJ3AnuOiphOd
         DNKAyGOZ6AAdI+XAPH9vjYWbRItJKHiSuZdtDdOYsF7wruaGOz9dQiTlVW7+Gq1+K3zd
         UIxg==
X-Gm-Message-State: AOJu0YwmmsRcBVAr0d0Ma319yKpZxV4VFC6ZCvg5tEThjkRz7nUxu6DZ
        puJMg0xhdqKYd7hYm+SKRchurdohqY0=
X-Google-Smtp-Source: AGHT+IHzS9zA8UwhpC4eUpMDZdJASDaKyuAg60aRHUVvqAyijrJC3sB28HYLE92EVctTnXF7euJALl+qRJw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:858a:b0:263:3b44:43ae with SMTP id
 m10-20020a17090a858a00b002633b4443aemr21798pjn.8.1691536282499; Tue, 08 Aug
 2023 16:11:22 -0700 (PDT)
Date:   Tue, 8 Aug 2023 16:11:21 -0700
In-Reply-To: <5c7309cb-30be-fe99-8563-d33098adbfe9@rbox.co>
Mime-Version: 1.0
References: <20230728001606.2275586-1-mhal@rbox.co> <20230728001606.2275586-3-mhal@rbox.co>
 <ZMrFmKRcsb84DaTY@google.com> <222888b6-0046-3351-ba2f-fe6ac863f73d@rbox.co>
 <ZMvY17kJR59P2blD@google.com> <5c7309cb-30be-fe99-8563-d33098adbfe9@rbox.co>
Message-ID: <ZNLLmSCHL6jDa3Ie@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Extend x86's sync_regs_test to check
 for races
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023, Michal Luczaj wrote:
> On 8/3/23 18:41, Sean Christopherson wrote:
> > +/*
> > + * Assert that a VM or vCPU ioctl() succeeded (obviously), with extra magic to
> > + * detect if the ioctl() failed because KVM killed/bugged the VM.  To detect a
> > + * dead VM, probe KVM_CAP_USER_MEMORY, which (a) has been supported by KVM
> > + * since before selftests existed and (b) should never outright fail, i.e. is
> > + * supposed to return 0 or 1.  If KVM kills a VM, KVM returns -EIO for all
> > + * ioctl()s for the VM and its vCPUs, including KVM_CHECK_EXTENSION.
> > + */
> 
> Do you think it's worth mentioning the ioctl() always returning -EIO in case of
> kvm->mm != current->mm? I suppose that's something purely hypothetical in this
> context.

Hmm, probably not?  Practically speaking, that scenario should really only ever
happen when someone is developing a new selftest.  Though I suppose a blurb in
the comment wouldn't hurt.
