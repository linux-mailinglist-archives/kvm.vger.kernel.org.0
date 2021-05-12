Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1217237EBCD
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 00:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244527AbhELTh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 15:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351519AbhELSA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 14:00:58 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224B7C061574
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 10:59:49 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id v22so18158624oic.2
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 10:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aXM1egTDBCpNuVBdORpBVDDCuXkPQJZWg02VwSi1GvQ=;
        b=D8RSL+qFl5gHNtI07aLFo/qmiUPO6xWnlhQDI8QfjhUeyts6k65XvtLW6SMv4MnvvZ
         Zo9tf0S55DW1L+9gorsqbcydNjXISG+lGx3nwb4iocqfKlXlrntKQDKL5gShXPqDG16T
         zdbMqoWgEY35BZPRMs4tOTK2GZ/eLISwieBfiJURr3eU6+e9l9VYXYV5atSsgnwFYz5K
         2pexZ1qN/jYgcFKbH9FO+Amp1rlHDzRJTgi+jy744U+TJV5hqYMuAuoBaY3EpkbWrei2
         paWmYGcpUYZ0H/VxTA5erBCipYRbtx6VKHFHesPAjpSPwUlLBE2D9AGtUdnM9zAFOBsO
         +yYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aXM1egTDBCpNuVBdORpBVDDCuXkPQJZWg02VwSi1GvQ=;
        b=iBUtpLPLK9GehD/5YhcJ31LLGruFqODpl5V/MdAnlWLhZ9x4/AuA+PYbTPCCDoG6sk
         60asGia3PiytCAZD4XGSYD32YGvt+yTgLKyxgSty580JJ4EqGshm2Ie06zsJhnOcB5uq
         Sak3Smao9v/np0I06OLawa7EKCcm2bwtzFApZC5IbbOmLb53dE2r6MAnWwN7vGemF8rO
         yQAcJOwhmBB/oCw2O36b9MpvG3FswVj1tXJONG7xc+picMywa88k2r3kRq7EHJcPl1yC
         e7mLb9pshgJKwyMTPBHorBTdFVkh4Ffc3vrSQ3wICY/sn0/nO2Q0uuWJinsBdWkou6eN
         7H/A==
X-Gm-Message-State: AOAM530qLjC5qNZhzJYjyUXIPwWQLOurWUbS1AKI3OfOUr/yFD03Fr/E
        KO8hW2KeihsE/49OhXB+DaqzzuYe0tgDDs23auaPgw==
X-Google-Smtp-Source: ABdhPJxGUto1IDoJOaIEnowc3aJNgyrPEMZs3dG6OYOWa0E0okeVNdTs/3VBiB5zjDguABWwvdRhIkn9Ik3oCWi+h2Y=
X-Received: by 2002:aca:280a:: with SMTP id 10mr8639585oix.13.1620842388285;
 Wed, 12 May 2021 10:59:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210512014759.55556-1-krish.sadhukhan@oracle.com>
 <20210512014759.55556-3-krish.sadhukhan@oracle.com> <CALMp9eTCgEG=kkQTn+g=DqniLq+RRmzp7jeK_iexoq++qiraxQ@mail.gmail.com>
 <c5c4a9d2-73b5-69eb-58ee-c52df4c2ff18@oracle.com>
In-Reply-To: <c5c4a9d2-73b5-69eb-58ee-c52df4c2ff18@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 12 May 2021 10:59:37 -0700
Message-ID: <CALMp9eS=M-2KUu-A6tt7gUZgyMADnOSzt0vmMpKBJibPuY3dAA@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: nVMX: Add a new VCPU statistic to show if VCPU
 is running nested guest
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 10:56 AM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:

> But I am curious about the usage you are thinking of with this.

I'm interested in tracking usage of nested virtualization.
