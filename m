Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F5C4ED048
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 01:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351828AbiC3XoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 19:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343740AbiC3XoP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 19:44:15 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637C65A097
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 16:42:28 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id t11so39498259ybi.6
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 16:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sFzKhHOoRyTVpr52xMm1knuU49YxhisG7vddivzWO2M=;
        b=g6zqsF0+yuqQFC0iPHTGP+5yBxPoTF7UoQ9EK6cFdFBv4rAy8KJEOTAevZQBsu129C
         jWx247NofR5yMjC6vWJCtiRroZrIKP7ZD+8nsP+EAoRzB1wHjyHZwiAAq+lnAp3oOLSY
         GEB8C+1vWGfzA7Vz58OCzJ4pFyNYGILTZ4eSbLX/SGfE1E62mrrY5OAlKqSFwJtPSQoR
         CYMp+BTQ1x2BjvK3LoxwT0sXp4X9vak8jH5fABFUHEbFivcJ6KtqJQZdYxFYs9eGfhyj
         OQpCoJjH70Tn0Lq9dRPmnlC20VntvYK3XZaGTcTQaLk+irN2W4z5yeBoKFjlnHqyLrsa
         gTvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sFzKhHOoRyTVpr52xMm1knuU49YxhisG7vddivzWO2M=;
        b=swFRPivYZKPIXniqUCrhDi8AcBHOF+2vARb/tEkAboPU2NFDufRnCiqUxeevCc1BzK
         gLCaSeDwhSKvFcqlDjMAOoFQO88CgnFKj2c0YJymkJ6n7bGbr+nUGHqro24VdurebREv
         AetuSG8rgYDD8d//+Dsifcs2PV6v0V9A5olc8BxVPh4KugHvFu8tQBawxBj5ftRIwE3t
         zR27NQdXgCJn0lB2jwOc3AXSiRLx1sb9DUeSu6bLq8bwI8u3kxGn0g2rUKSMRXxrn48H
         n2qRjzoTcU4lrpI+YfdAxJfRGjph930tbKCn5+10ZOKAJdXAhArgUrZ+XETFxMUhHc6O
         2SQQ==
X-Gm-Message-State: AOAM531exYPG+djnQlW+R3oFaayTgYdASUZAUuIIujHIUFNdJh44/lDU
        JKIx84YtZSH/1A3NfB19FyhGqGmKQ52hJrPeoVdWVg==
X-Google-Smtp-Source: ABdhPJzMv6rOEFkM+lPxchcVQP3SxrX21qtRVYYB0rFUxyUvPuH3hfL8GwkekKn7qcutgUfxOtjtmIa6jmJTbsQVlR0=
X-Received: by 2002:a25:780a:0:b0:633:ccea:3430 with SMTP id
 t10-20020a25780a000000b00633ccea3430mr2125795ybc.26.1648683747537; Wed, 30
 Mar 2022 16:42:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com> <20220330174621.1567317-11-bgardon@google.com>
 <YkSbH3XR0YFzrZik@google.com>
In-Reply-To: <YkSbH3XR0YFzrZik@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 30 Mar 2022 16:42:16 -0700
Message-ID: <CANgfPd9V8+WfhvQO1TdOFnd4H=ux1Qrn6CB8OWrxQrErRekVCw@mail.gmail.com>
Subject: Re: [PATCH v3 10/11] KVM: x86/MMU: Require reboot permission to
 disable NX hugepages
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Mar 30, 2022 at 11:02 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Mar 30, 2022, Ben Gardon wrote:
> > Ensure that the userspace actor attempting to disable NX hugepages has
> > permission to reboot the system. Since disabling NX hugepages would
> > allow a guest to crash the system, it is similar to reboot permissions.
>
> This patch needs to be squashed with the patch that introduces the capability,
> otherwise you're introdcuing a bug and then fixing it in the same series.

I'm happy to do that. I figured that leaving it as a separate patch
would provide an easy way to separate the discussion on how to
implement the new cap versus how to restrict it.
I don't know if I'd consider not having this patch a bug, especially
since it can make testing kind of a pain, but I see your point.
