Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF3D6BBE63
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 22:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjCOVCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 17:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjCOVCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 17:02:38 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E40A21A8
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 14:02:05 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id p9-20020a17090a930900b00237a7f862dfso1517888pjo.2
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 14:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678914060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UoDvobVQiPMq5acwjCe9688yztYKCiKKo2a8h2clq3Y=;
        b=ABsYD8ivxczrfhW46NqRAYHlkYUpTpC/r4227tqpcgEUGcqmOIJjmJkUXsyslLEZp3
         h6A5RbNktFzEqVzHBEIkMJCft6k2dqY8WR6mjI6m0voJrU/B3sWSQ+PlVuOXTLPytZ+m
         02xaQdGzHShm7xD1s3vveeUjSypDW+kpfzfx2tyf8OGH8SA+A2Wo+otnTl3myqa0/Hgg
         gcnUHxdx1vv/Ldm8vzJ7o+lOMOKa3WDhSFkx1Pq5cm9TieHZO7rIyzZYnAnsAhLKCIKq
         HByZO7+N7kUN+s1qfw5LCtY8jUR5kpsWzVT21LE24/wuBV5ZHgSnFHLUJBSZbhZ4bXkf
         ICDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678914060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UoDvobVQiPMq5acwjCe9688yztYKCiKKo2a8h2clq3Y=;
        b=79r1cYUoPYpFPqtb52O0n19ywbt38TWwAQgjf7kJSQsZLGfAY2TK1lFfF0UIU+TLU+
         W5l+QYy6rBF36OsqV82MD+oQIx5bC/QWDD/mAqpzojazlEYdGR7s5X40vcAk2QSzeSVE
         0aM3eOrkkOmQ7/waafk13aLsj3dSov5h6WjdR4jTGgscZ88Y8Br1fAPeyoAOOszybNOM
         Tk+69fbxdGHuWRYCoUvVxRj16Ac4V3WINoy8htIKa45BmQT00ylAaLS/x1m5n0K+ew9D
         zVeYaEYi3caRkLbIz4N7dhZpAI+dsXAt2GhhIpBXDFp7nslZBhSh5gRti3MKa77gjWWl
         Zk2g==
X-Gm-Message-State: AO0yUKUaRXn9B5m3ItT93rqB+y1xPmyBklLPzkitQJe8gTl0jT4le03g
        YJ1FOvmh62thuidbAR++U3SFLKMUeJs=
X-Google-Smtp-Source: AK7set9I2d7zMrmbQqwepgi6EVy423MROFM770G/8niG8EsRE4Q4WDIEw2I/e22xzRSKFbKIa6cM2vJUBss=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d48f:b0:1a0:144b:6489 with SMTP id
 c15-20020a170902d48f00b001a0144b6489mr398143plg.10.1678914059460; Wed, 15 Mar
 2023 14:00:59 -0700 (PDT)
Date:   Wed, 15 Mar 2023 14:00:57 -0700
In-Reply-To: <86ilf3y6u7.wl-maz@kernel.org>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com> <20230307034555.39733-8-ricarkol@google.com>
 <878rg25hbq.wl-maz@kernel.org> <ZA8+31vQA6vcQuK2@google.com> <86ilf3y6u7.wl-maz@kernel.org>
Message-ID: <ZBIyCQXPVEAkJZES@google.com>
Subject: Re: [PATCH v6 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023, Marc Zyngier wrote:
> On Mon, 13 Mar 2023 15:18:55 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Sun, Mar 12, 2023, Marc Zyngier wrote:
> > > On Tue, 07 Mar 2023 03:45:50 +0000,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > No functional change intended.
> > > 
> > > I wish people stopped adding this pointless sentence to commit
> > > messages. All changes have a functional change one way or another,
> > > unless you are only changing a comment.
> > 
> > The implied context is that there is no change in runtime functionality, which
> > does hold true for many changes.  I personally find the annotation helpful, both
> > for code review and when doing git archaeology.  If a changelog states that the
> > author doesn't/didn't intend a functional change, then _any_ change in (runtime)
> > functionality becomes a red flag, and for me, prompts a closer look regardless of
> > whether or not I have other concerns with the patch/commit.
> 
> And I think it lures the reviewer into a false sense of security. No
> intended change, must be fine. Except when it is not. More often than
> not, we end-up with seemingly innocent changes that break things.
> 
> It is even worse when things get (for good or bad reasons) backported
> to -stable or an internal tree of some description. "No functional
> change" can become something very different in another context. How do
> you communicate this?

For KVM x86, we opt out of AUTOSEL, so barring errors elsewhere in the process,
a maintainer needs to review such patches at some point.  And again, for me,
sending a patch to stable that was intended to be a nop is a flag that the backport
warrants a closer look, e.g. extra justification for why a patch that's (allegedly)
a nop needs to be backported to stable kernels.

I agree it's imperfect, e.g could lead downstream maintainers astray if they view
the disclaimer as a statement of truth as opposed to be a statement of intent.
But IMO the good things that come from being able to know the author's intent far
outweigh the probability of bad things happening because a reviewer and/or downstream
consumer put too much weight on the statement.

My opinion is certainly influenced by having spent far too much time digging through
historical KVM x86 commits, where it's all too often unclear if a buggy/flawed
commit was simply a coding goof, versus the commit doing exactly what the author
intended and being broken because of bad assumptions, incorrect interpretation of
a spec, etc.  But even with that bias in mind, I still think explicitly declaring
an author's intent for these types of changes is overall a net positive.

Anywho, I don't mean to step on toes and force my preferences down everyone's
throats, just wanted to provide my reasoning for including the disclaimer and
encouraging other KVM x86 contributors to do the same.
