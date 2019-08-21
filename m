Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BA3984B9
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 21:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730001AbfHUTrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 15:47:47 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33415 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729879AbfHUTrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 15:47:47 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so7144041iog.0
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 12:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8+BtOM+3vO2u6/0CQmN1n87ARVo5K8I8VEywZXCtgLY=;
        b=c2w/mJlehUD6/LiHkmRwQFgU7A5T8czN5pnMMHJiQ/xEg9Bfn/NYZh7lMic93gbMii
         roHC5uqI1hHPWP9B+8A1EgMbfzWCAmDGuFTVG4/ix1xHsNitc9H2tcdMeoj5iLJ2GhuG
         fug4Ke+IbBjCWnnWzxDeQ5u158euo7zSklywVQvvw4M5fEJlzOBS2iyzl108r4I/pOqy
         NLi81+QohnyuhdgiCU7LNgAio1U2uxPMb91FIwxdXxEj1C2NC/+kLiyF0hopskiRUIpI
         R1nAefhp6Hj3IllDqukMdl+6VwXnTc0HYFbY7t093HRBB27QfLu0J+jU3kFnZ5wUU6fq
         qZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8+BtOM+3vO2u6/0CQmN1n87ARVo5K8I8VEywZXCtgLY=;
        b=nzrYJKMUZbb/toDV+Q3QcUup7lglBwtcIP7hu1Vueo0x2+6CX7pdtjlSK8TAJ+3xMa
         rNNyqVerCz7AEZFJpTrjoWB2DJ+zUvdERcl9AduaRUhHRxQur4JCgb0nn9N6DhP4MzLA
         GZUhb2yBVJTiVlvYmutEA5bmDxi2u76fRYL0OsMsjBFyS5E4MYrft45e7AraNuGDH9gb
         3DqQZdc379Dhro0W9D9hrFprMyLe37vD33mah4rrt7NvY3ouv7lwm8ShQb9Doq5nfLaD
         9A/5PfWfq3lqqocYkeYEnLe9/Izva3xX6+EwfvVWFq/f3rnI3rTDvkkFTnayGZ0Nkxt9
         +/AA==
X-Gm-Message-State: APjAAAUWTcJH857MW8OPFbIUVOUCkfizySTZGjEq7euD2mcP3XT1BBfz
        8K3DNIiTI2AE1v6CgRTGCYsj9VEnry8qHTqnuQ0Pqb/ManE=
X-Google-Smtp-Source: APXvYqxmuM2Iy92v/ONpVWmMF8SZinCG9Ze+5FLH635jZ1tfongFVtR6v37dxy3ceftTRJo4MWkcs4spDIMONi1dr+s=
X-Received: by 2002:a02:c65a:: with SMTP id k26mr11780341jan.18.1566416866453;
 Wed, 21 Aug 2019 12:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <1566376002-17121-1-git-send-email-pbonzini@redhat.com> <1566376002-17121-3-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1566376002-17121-3-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Aug 2019 12:47:35 -0700
Message-ID: <CALMp9eS=qsrOE2yaJAFZK6VhFEtkx2vjCQkYa8UMjeWYDOQQgg@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: always expose VIRT_SSBD to guests
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, jmattson@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 1:27 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Even though it is preferrable to use SPEC_CTRL (represented by
> X86_FEATURE_AMD_SSBD) instead of VIRT_SPEC, VIRT_SPEC is always
> supported anyway because otherwise it would be impossible to
> migrate from old to new CPUs.  Make this apparent in the
> result of KVM_GET_SUPPORTED_CPUID as well.
>
> While at it, reuse X86_FEATURE_* constants for the SVM leaf too.
>
> However, we need to hide the bit on Intel processors, so move
> the setting to svm_set_supported_cpuid.
>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Reported-by: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
