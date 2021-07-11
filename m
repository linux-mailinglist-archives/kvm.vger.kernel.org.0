Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6353C3EF4
	for <lists+kvm@lfdr.de>; Sun, 11 Jul 2021 22:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhGKUQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jul 2021 16:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKUQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jul 2021 16:16:36 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D661DC0613DD
        for <kvm@vger.kernel.org>; Sun, 11 Jul 2021 13:13:47 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id n14so37887659lfu.8
        for <kvm@vger.kernel.org>; Sun, 11 Jul 2021 13:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=HkkE83YWXSph8GGIQ7a8kcVSWWojDzOTgjqgI2j1TWo=;
        b=UUylzr1hG+ZQjAhsc+9yWJYeijJ2x+miim2+7b/KM6QSUabvG6o9hQ2P0ZiO6pacO9
         uYSX+UUKZYEbYZm/LMy1M901MLhaAn5skTZpAkAi1isP0E/19XcfuoqcN2CbTXFeLdQc
         5h5ATDmOJW1CoXMk1FY1g/fNmDGYdDzoHq60d4OxXFdOlOjfCTv770WeCqo6dIrugDbY
         L3cMS1d/CxcSiTM1OfjWMVJqyTeIkUTkAm5rveGP4Y4Rezn//OCqaBcYLkOifLAMOIr+
         VMek4FnVrxYpgTcsWBzt5Ug0xcvtLyKfrbT2Gy19jNOGLL6rWiy5wLqpWhx6CHwE7ka0
         +thA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=HkkE83YWXSph8GGIQ7a8kcVSWWojDzOTgjqgI2j1TWo=;
        b=CcKo8maZSARl+yJbqeIAzlo+3KiltjtAQWnHUZI2/4XDY2pKpON7jfFyZrjoBwZZSS
         WB2NFHguIuzqPVCxypKIU1dWi/0EVB1rWD5Edx/URrqsCqHeZ/bnSRw43f8GSDnwTZty
         LvQVaIym9e0tDMZb2BGXqrn24eBDQ1ySn2oueJ6v5PFxU3dsyZ9At0m3cQJZw9z3aMLr
         IS/hMJEO1ruqY92x26UckLA29PirYkRYvy0UQWBIlwQf8zowl9XKc1dnnnz1/RCm1WMS
         XHU8pLksukLNp2B1mdsbkE3boVBEDAKt2J/beK4W7Uv6dLCXsLs3wWLPeD/ngCnsWkpZ
         PEhg==
X-Gm-Message-State: AOAM530qII5DK1QTk8M05WHwnacWUO9N5VlqR86QH/W+anzi0P5JRJOd
        y2VKcTiz8+cHrlZ/N+3LsFc8mg9FEbs7rGH/bonQ4yzePTTYNKMJI5o=
X-Google-Smtp-Source: ABdhPJyKW8APxPy/WdNLH5AQFZlV2Reke51kIv1QMnURdqM9GxloNk/zRZujUtXhKGCwxZYFaSvSih2DNjQQSE4d8Kk=
X-Received: by 2002:a19:2d0a:: with SMTP id k10mr38478844lfj.301.1626034426019;
 Sun, 11 Jul 2021 13:13:46 -0700 (PDT)
MIME-Version: 1.0
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Sun, 11 Jul 2021 15:13:39 -0500
Message-ID: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
Subject: About two-dimensional page translation (e.g., Intel EPT) and shadow
 page table in Linux QEMU/KVM
To:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

I hope you are very well! May I know whether it is possible to enable
two-dimensional page translation (e.g., Intel EPT) mechanisms and
shadow page table mechanisms in Linux QEMU/KVM at the same time on a
physical server? For example, if the physical server has 80 cores, is
it possible to let 40 cores use Intel EPT mechanisms for page
translation and the other 40 cores use shadow page table mechanisms?
Thanks!

Best,
Harry
