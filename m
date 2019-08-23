Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1AF9B848
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 23:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436972AbfHWVmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 17:42:50 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44160 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436967AbfHWVmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 17:42:50 -0400
Received: by mail-pg1-f195.google.com with SMTP id i18so6459658pgl.11;
        Fri, 23 Aug 2019 14:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/Ex0VsF7RcVYV+8v1fpwxXzCTkxEkPv9xKjjFVVJ2VM=;
        b=dl9v5/lC1J79HPvdEY3hId6g+g516FVcJoG91q99hS3CxeuK7OVqkfNaS2kqI6sO7J
         RllVY6jeujUR3kHo9noIrlTT7ExguNPNNY4ysmzwRnxOjvAG+iilHfL+4BSnrVTEWKCz
         DtM7fWBIGngOi7qIgdsenEUZcQcrQfFioegVT6suLp78MOwWfXW+FLj/vH9vNP3Sa3Yq
         eG7TBe3TCHkf7Q5idJj5lS4r9mzTqXS4iDf4sgSLXm5n+rpSRhvH8lRu+WtURsrXdK3d
         UmpTdqHBd+bvvt6D/N1s/KkndqNvuEnsqFnoBwk3QvYj+gXg9ey8nDy1MFjoomfzzraq
         YyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/Ex0VsF7RcVYV+8v1fpwxXzCTkxEkPv9xKjjFVVJ2VM=;
        b=U4nJsIctkPbFp2GIjQtPWnJBbuUlJGbX6+m4+6xK5f6hMQxI7GYuzmCisWQFTkKvh+
         UycLID3guX3ZF2Owyl7Am5iVUIrwii6Q9kBvLmWm9dWx7JGiMPNFarn166gMOz7K1NHJ
         r4yqMN1jnOedUVY+6TM28e9P8dtZ4bBbezlVFwoNpQaNctMW9CdfZ9Sii55Wt9K22+tZ
         u4WtHi5AaNnAlz617s0xy0tnF6rUakBBArf+icNrq448xPWQdXIxcHxtK5Fgh/f9grRX
         IaombdnLGHN8XAp+vS+CWAH65jMdQGr5ajaOoIqJv4eenNos6gB61lNaKea75ZYHbiLo
         outw==
X-Gm-Message-State: APjAAAXv+/9ycsYUhw/t0iefs0y7/OFU+KZ8CQEtA8s2eILNShYTivZF
        3Ts3ZozNT3b0Vy8i1J2lLFQ=
X-Google-Smtp-Source: APXvYqyRvZ2n7IKYtQC3lJYMrcYDCd6VEgDCQnBID4DkEeadx/+3PzT40FYNFx2wJP0O1brLR6Ksxw==
X-Received: by 2002:a63:9e54:: with SMTP id r20mr5957518pgo.64.1566596569079;
        Fri, 23 Aug 2019 14:42:49 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id n28sm3153636pgd.64.2019.08.23.14.42.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 14:42:48 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] KVM: x86: Don't update RIP or do single-step on faulting
 emulation
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190823205544.24052-1-sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 14:42:46 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D49D02CD-4D29-48C0-B61C-FBE50C79D802@gmail.com>
References: <20190823205544.24052-1-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Aug 23, 2019, at 1:55 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> Don't advance RIP or inject a single-step #DB if emulation signals a
> fault.  This logic applies to all state updates that are conditional =
on
> clean retirement of the emulation instruction, e.g. updating RFLAGS =
was
> previously handled by commit 38827dbd3fb85 ("KVM: x86: Do not update
> EFLAGS on faulting emulation").
>=20
> Not advancing RIP is likely a nop, i.e. ctxt->eip isn't updated with
> ctxt->_eip until emulation "retires" anyways.  Skipping #DB injection
> fixes a bug reported by Andy Lutomirski where a #UD on SYSCALL due to
> invalid state with RFLAGS.RF=3D1 would loop indefinitely due to =
emulation
> overwriting the #UD with #DB and thus restarting the bad SYSCALL over
> and over.
>=20
> Cc: Nadav Amit <nadav.amit@gmail.com>
> Cc: stable@vger.kernel.org
> Reported-by: Andy Lutomirski <luto@kernel.org>
> Fixes: 663f4c61b803 ("KVM: x86: handle singlestep during emulation")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Seems fine. I guess I should=E2=80=99ve found it before=E2=80=A6

Consider running the relevant self-tests (e.g., single_test_syscall) to
avoid regressions.

