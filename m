Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FEB24A8E3
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 00:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHSWJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 18:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSWJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 18:09:16 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA569C061757
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 15:09:16 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id q9so20340024oth.5
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 15:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P2aZms47v6extSBzv//sF/AtrAyAelQrYrDctYBpr04=;
        b=KEYsVedFdZOQOSKvm37iFMygyWYKzyeKVhW7GTGsl2VQmKBUg/hkZq15rfVRQfC5eu
         dUtnTcGVi3clYiP8Mj5/69CXlvkgXFTYDkUlcWkoQ9qBcKDdXnK7v5CcO25kpXzKE5xS
         UoFKnLSkqfQ+sQDk6RybtzVcijHxCY5agHtf1D0MUFmQi8DMQy/bw26109HhW7KpI7KN
         F0tQYmHfj9dQhoyiwlrrYHPfIlB78enPqA7h59oq5DS6DdzqdUwcmXqOjNqtzotEtrrQ
         vgk5zbQjOqe3nwzXchl3hOB6/KvfHZuUlrSKoIgZyzXCwG73zgJnYCtd14yyyX7tvkYG
         /gXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P2aZms47v6extSBzv//sF/AtrAyAelQrYrDctYBpr04=;
        b=X6HzMTtq8sDAOUFlUXMGOdYi7m2yp5VB1R9lHV5FzXhPzeEaGkdUTPLY7Mk2ME+uxI
         bx4kmqhyAV7kRmdT1Vry2KEu3N7YNp4LjUsZYF28OkceUBMKhaTCjM0g36ACkkDkL4iK
         jxkMtNS7w3/U5zAvupQhfScjEo9h/bIRk3MKLGqE7pmWIt+CsRqN2Efy7xXY09FLun1J
         5Qe0wXtkbNEbfH84hm0rzJyDz0OI9OkiBKUaN0TSXl3j/wjRk/LGDC7x2frc+k6tphOh
         ZCCPuogX2RXaR35K18OUBTsw3l921PP+lXbf2zMWi/XgPuWJyn6tlwq8Kxd0O7RArt1E
         ZcLA==
X-Gm-Message-State: AOAM532VOIRHnPr3rE0Xp7K381i9eD9ZYm4vZWLDeQtb19FVNlxI62QQ
        rRG2JB5tuC8o2YG1aRpuzuynYw44C+e5hoP46uOXng==
X-Google-Smtp-Source: ABdhPJzt1m4Jk/Vfsw/369PYrT54BgnJK9X0NCnwn7bI4EEVd9vbywxvaU0LIHS+rgWiI+SfMc+IIrkD07Q745+LHBc=
X-Received: by 2002:a9d:ae9:: with SMTP id 96mr18674otq.241.1597874955900;
 Wed, 19 Aug 2020 15:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200803211423.29398-1-graf@amazon.com> <CALMp9eRHmhmKP21jmBr13n3DvttPg9OQEn5Zn0LxyiKiq2uTkA@mail.gmail.com>
 <B0FD5408-E2C1-444C-AFCE-7C622EA75F66@amazon.de>
In-Reply-To: <B0FD5408-E2C1-444C-AFCE-7C622EA75F66@amazon.de>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 19 Aug 2020 15:09:04 -0700
Message-ID: <CALMp9eS5+mV2SC-v4gusocrWtXpm-QzGoOTDGhFS9NEmuVNTDw@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] Allow user space to restrict and augment MSR emulation
To:     "Graf (AWS), Alexander" <graf@amazon.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 2:46 PM Graf (AWS), Alexander <graf@amazon.de> wrote:

> Special MSRs like EFER also irritate me a bit. We can't really trap on them - most code paths just know they're handled in kernel. Maybe I'll add some sanity checks as well...

Why can't we intercept EFER?
