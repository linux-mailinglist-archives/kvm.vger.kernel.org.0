Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4B9352C13
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhDBPB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbhDBPB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:01:57 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88965C061788
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 08:01:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t5so678003plg.9
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 08:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B4aR7GQ45Q6gcx4+A7SR+lq57+x+iu7A15kxK1uxDw8=;
        b=Y1RpiKElC5IcRA+tvkWQQDQOYuaveVlroBy+bX+KwaMDZxmvl8VuT+Wr1L03CsY2kr
         WTn8KuMLTRWbLnKYo5OUZi6VqnCO3tHBPd+olDL3TRGeWfA+0kLGsVEc2y1KiBw2UAhX
         0a6afsFfuZp8mTT+dXabdOkAhADiuAqG218Lz9dHgRZjKuP410cDMmYQR26/iqDRNnFW
         GiZn34bvY+YHmnfqOM7s1rOfOMAC6mAOcCdDRFghM06tpMlYlKqxxZgbrqlPayPVXOCc
         Whw6W8qA/jPibXV5bRBP8v01ctlkv1qA+SdwwYwA6lIqTKKQkSSm3gThBqqUARJEmVS4
         FB7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B4aR7GQ45Q6gcx4+A7SR+lq57+x+iu7A15kxK1uxDw8=;
        b=sa6jdYuHALUWYKVdNd48Qb+iSIEnCuOMlB/8bWnaZj2m6hyRRx43YwjdK6GrSqsvHh
         jY/mMPXb6141Me27Yf5acDgvlh6XB82rcfzloOdd9ih95TqTMT906aLMY3Gpwd4jKv6e
         ZQzLYRiq8wKhbNtC0RGVwfh6i27yIk+J2H6QJ1QFaAnd55z3DRXK0Zq+dC94wXngu7+b
         Z7d9lRipBDguq+aJPGrIg8cPWlRaE63SB4pwuBfzTQDMhAwsF2rgn7PdP57jjCsI4iHr
         41jZvu3nr4oq4qt1kYqlm3eSJS5mzEvCmEroGU4lsVxWjhTn1ZLwF+Uh3I3wTaYQz3Ym
         HqfA==
X-Gm-Message-State: AOAM533CnHYYeVOhRp+Geky/AQxqKYQLM9sbR7m4p11k5ZWQDnk00MW3
        XFgYiz9ZBa8o6bSu//MRbjKFlg==
X-Google-Smtp-Source: ABdhPJyHTdyW00d2fYIUBu8Gb42GRW8lHrIhdOr8eH36swUWCSaDZadQMjYvzkAFLilDtLjc1nPT2w==
X-Received: by 2002:a17:90a:f0d2:: with SMTP id fa18mr7041831pjb.187.1617375716012;
        Fri, 02 Apr 2021 08:01:56 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id y12sm8754606pfq.118.2021.04.02.08.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 08:01:54 -0700 (PDT)
Date:   Fri, 2 Apr 2021 15:01:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 2/4] KVM: x86: separate pending and injected exception
Message-ID: <YGcx3+6KKhpWkgbw@google.com>
References: <20210401143817.1030695-1-mlevitsk@redhat.com>
 <20210401143817.1030695-3-mlevitsk@redhat.com>
 <YGZRrOBVvlhVTyG8@google.com>
 <09c74206-ded2-900f-ef28-a2c5065a6626@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09c74206-ded2-900f-ef28-a2c5065a6626@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 02, 2021, Paolo Bonzini wrote:
> On 02/04/21 01:05, Sean Christopherson wrote:
> > > 
> > > +struct kvm_queued_exception {
> > > +	bool valid;
> > > +	u8 nr;
> > 
> > If we're refactoring all this code anyways, maybe change "nr" to something a
> > bit more descriptive?  E.g. vector.
> 
> "nr" is part of the userspace structure, so consistency is an advantage too.

Foiled at every turn.  Keeping "nr" probably does make sense.
