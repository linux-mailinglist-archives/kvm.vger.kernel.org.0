Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7BB48E205
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 02:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbiANBKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 20:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiANBKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 20:10:08 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304B4C06161C
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:10:08 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso20611481pje.0
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dfHTMu5yyfREc50x2Kq3TV4XK0N3u2/ilz/wJ1H6bEc=;
        b=Qp0L93h2Bp9PLGVaYi0WSJZdkp402RO5l/aQCpgeknH84r7jXsj7pSuEYA955i7rn1
         W/p3e5Om59luBvf1WCuy9aMCOrdXM0d9zK5q9FPAIBUu+YPOluPJPYYDgGJHTgZdtQpc
         nUerIZBF1IuHj8vPAaqSwkIRpzapyybW2OQchtN+j/XvAyejjbCFcFTsNN3peB96A/cW
         U3rxmnuP7tXIc4sW/2zfK+HG8geZbnDbbhy93s2AOQI02kxI7/1FPXmzht3IuvE5V4jZ
         2AaVVp/32HkacH3MCRJUeaGvlUbX2c5ey2lnicXWxn/xg22G9auoTekB9x32FSWgUC01
         MK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dfHTMu5yyfREc50x2Kq3TV4XK0N3u2/ilz/wJ1H6bEc=;
        b=qyhZJCtEdb4VzXHpu7Ng/sVCUJLFs6YWEeF7ZYDnMQP5u4fS+NoYBU7cJJfv4LoOsi
         R7BGugEMiHeAYbih+DuBns1G3PIwf8cwWTBcYoWYzaKEi1f4sfAbhrE/dXFoqy0oRXH+
         GAgxuyrFpru7rQxLneDH23vAqJTcTB+Z2lW5rcIg+tXnXE1NWrbiIU6FCf/Y41V4f+hk
         LgizQErh4VTJHV0ZxlrhvJ/PPVjcXKvngIa4DUnAOXRvG1XVmXOsGmhKLS/64zFNlofZ
         VcMGyq/TCLqQJ7lbRc4odWiAyDekKiUxkMj/myGPI+cRyImfij7t3PXi4rKNV/4behCo
         P6Yw==
X-Gm-Message-State: AOAM532/qOXAJ9GHKdI2zlZO7heXkKziR4iB4MKLpMrgJG49I6DZDnJP
        PBGIOaB53TkCUy3bwQ2E7q04aLPtTg0/Yg==
X-Google-Smtp-Source: ABdhPJwJPF9HsoPu5KG5130tnrH/ZAmOSjZe/Jj2K4WwUe35vcCRE5fNeuBHwGHXHuwdjfoMvZZibA==
X-Received: by 2002:a17:902:76c2:b0:149:7fa3:2ace with SMTP id j2-20020a17090276c200b001497fa32acemr7109949plt.64.1642122607394;
        Thu, 13 Jan 2022 17:10:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y64sm3134915pgy.12.2022.01.13.17.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 17:10:06 -0800 (PST)
Date:   Fri, 14 Jan 2022 01:10:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
Message-ID: <YeDNa+/rF0YEVJAi@google.com>
References: <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
 <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
 <YeBfj89mIf8SezfD@google.com>
 <CAJHc60wRrgnvwqPWdXdvoqT0V9isXW5xH=btgdjPWQkqVW31Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60wRrgnvwqPWdXdvoqT0V9isXW5xH=btgdjPWQkqVW31Pw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022, Raghavendra Rao Ananta wrote:
> On Thu, Jan 13, 2022 at 9:21 AM Sean Christopherson <seanjc@google.com> wrote:
> > If restricting updates in the arm64 is necessary to ensure KVM provides sane
> > behavior, then it could be justified.  But if it's purely a sanity check on
> > behalf of the guest, then it's not justified.
> Agreed that KVM doesn't really safeguard the guests, but just curious,
> is there really a downside in adding this thin layer of safety check?

It's more stuff that KVM has to maintain, creates an ABI that KVM must adhere to,
potentially creates inconsistencies in KVM, and prevents using KVM to intentionally
do stupid things to test scenarios that are "impossible".  And we also try to avoid
defining arbitrary CPU behavior in KVM (that may not be the case here).

> On the bright side, the guests would be safe, and it could save the
> developers some time in hunting down the bugs in this path, no?

Yes, but that can be said for lots and lots of things.  This is both a slippery
slope argument and the inconsistency argument above, e.g. if KVM actively prevents
userspace from doing X, why doesn't KVM prevent userspace from doing Y?  Having a
decently defined rule for these types of things, e.g. protect KVM/kernel and adhere
to the architecture but otherwise let userspace do whatever, avoids spending too
much time arguing over what KVM should/shouldn't allow, or wondering why on earth
KVM does XYZ, at least in theory :-)

There are certainly times where KVM could have saved userspace some pain, but
overall I do think KVM is better off staying out of the way when possible.
