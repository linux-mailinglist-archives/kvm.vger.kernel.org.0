Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77D77B0D2A
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 22:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjI0UKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 16:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjI0UKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 16:10:07 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FABCC
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 13:10:04 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59f8134eb83so143793687b3.2
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 13:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695845403; x=1696450203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=psOShRUSEQe8zIonthIGZttrDfLL/2gSo0mpPuWUP7c=;
        b=Hxnd+Za138b8fb4G2r7r4tiL2O5XlTBcWH/Rp89IzT16+WRNDi0dHQNM9NCRcBOvgh
         t4CJvMsulE9S6507KkFS0agWtvYQAHVxqJV+lOdrYJf8eVdTcDdwvRpE7EG+26M4r6j3
         g+yC8uYzMF8EDtufU9294jrWFpB9axtbL1d8S5yjagIUcH1ugavMrJkvVWQwyOHVbkrI
         IRYu7VRu9MfT9KeHzdRS58DV24xlnI7zxAC9vkZ46zIUB53Gm/xdgEUOIBmJDORCOP4x
         G1sDm+Jj+KnAOSyKXVMOeCi4OpyeoVDl99eV0O7qA1m61em0zu6IXm1ZlcCoihznFcDO
         mbhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695845403; x=1696450203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=psOShRUSEQe8zIonthIGZttrDfLL/2gSo0mpPuWUP7c=;
        b=BGx2PhGYiDt+O4i6F74MBWXmZ9jZyClpHsM3RnQygEP64ZR8xfAvhA2Mmklovu0Rp1
         +5qXZ0F6r/lv2pRjqRBIgI1OIyds4XtHTSOSGp6o2UMm2oWtQdH9JE91UjgUl+PEbQiw
         GgD5ipVDVrzrkTMrNaI4+o5K0k7Lh5c6LNvFsmhe97G9eluD6tgeNd5BC6PO5lH/LE5m
         z2tonLh/6EYyZY6CVRJTmNY3UBFKYzAcVd0TTRnEDJM9t/lsDQQ6N1gKjHEZqIe9MPB6
         FnA6BpDpBs1sVBTcaX8639rM4TsL2NyeS4+9AShs1QeXJdIYzuWMSazV4OPKdVUgWprn
         gCnQ==
X-Gm-Message-State: AOJu0YwO2sTHgZgi3omnASyUaf9A+hVWYRb7XNG4j3JPX8f/oUqsmKYJ
        r0itY2xTVQadhjrihC7X/X/ujKkcI2I=
X-Google-Smtp-Source: AGHT+IG5w7DmAJaClZiOjkmowcDJR/iiFdPB8zaGrAi3UXJB6RD28SM4z2s4iW9X1FeipKfBl6KyfDrABpQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b65e:0:b0:586:a58d:2e24 with SMTP id
 h30-20020a81b65e000000b00586a58d2e24mr53326ywk.5.1695845403609; Wed, 27 Sep
 2023 13:10:03 -0700 (PDT)
Date:   Wed, 27 Sep 2023 13:10:01 -0700
In-Reply-To: <13480bef-2646-4c01-ba81-3020a2ef2ce1@rbox.co>
Mime-Version: 1.0
References: <20230814222358.707877-1-mhal@rbox.co> <20230814222358.707877-4-mhal@rbox.co>
 <13480bef-2646-4c01-ba81-3020a2ef2ce1@rbox.co>
Message-ID: <ZRSMGdxk2X-cXr6z@google.com>
Subject: Re: [PATCH 3/3] KVM: Correct kvm_vcpu_event(s) typo in KVM API documentation
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org
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

On Tue, Aug 15, 2023, Michal Luczaj wrote:
> On 8/15/23 00:08, Michal Luczaj wrote:
> > I understand that typo fixes are not always welcomed, but this
> > kvm_vcpu_event(s) did actually bit me, causing minor irritation.
>                                  ^^^

FWIW, my bar for fixing typos is if the typo causes any amount of confusion or
wasted time.  If it causes one person pain, odds are good it'll cause others pain
in the future.

> Oh, I do feel silly for sending typo fixes with typos...

LOL, I'm just disappointed your typo isn't in the changelog proper, because I was
absolutely planning on leaving it in there for my own amusement :-)
