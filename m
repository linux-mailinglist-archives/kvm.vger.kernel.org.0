Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D910A2CF477
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 20:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgLDS7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728504AbgLDS7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:59:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596C2C0613D1
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 10:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=fIFbGiid75+KHlRFBYwy0hInUkkYCDkBmlAosuozf84=; b=UKKnluO0PMkQAfVAEn3f+qI1OK
        JiCDZ5Iq1YJ6+d7QTtMnLwEw/pqb7rBm4AjxPwe7V5W70m8W4jAS+TE7c6O1Oj+WY6v+7lQqLXbie
        rcKqNLi+xzXNhU236eEJwyo430+4chiN9bhCwW7oER2YzkAkuTZ0j+8ZT4OmDjMtXu32jo4AY3V4W
        oWwfId30HgvvVdQZ0WRvOGS+hRnB1FtUi8ECb/VBgWNm3f6EWgf4/kh/I469chO0QXrAiKXU0QGJn
        t7Tr7bku8y9wE0wnCB+yefNkt9+yScul6TYmiVP5mXGPkfYrlhc36qUbZNR21GN8k7j+j14KiBfej
        MH6RaJhQ==;
Received: from [2001:8b0:10b:1:782d:346f:3c1:eeee]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klGIH-0000sZ-Fb; Fri, 04 Dec 2020 18:59:01 +0000
Date:   Fri, 04 Dec 2020 18:58:59 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <776337d6-c00b-754a-c9f6-830b76e47c30@amazon.com>
References: <20201204011848.2967588-1-dwmw2@infradead.org> <20201204011848.2967588-4-dwmw2@infradead.org> <776337d6-c00b-754a-c9f6-830b76e47c30@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 03/15] KVM: x86/xen: intercept xen hypercalls if enabled
To:     Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <EF745123-443D-4556-AD7C-55A94726A27C@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4 December 2020 18:26:54 GMT, Alexander Graf <graf@amazon=2Ecom> wrote:
>Why does any of this have to live in kernel space? I would expect user=20
>space to own the MSR and hcall number space and push it down to KVM=2E=20
>That means it can also provide the shims it needs=2E

Because the kernel is already trapping the VMCALL and handling all the KVM=
 hypercalls, because it's much more efficient to do so=2E

This is just a way to allow userspace to see those exits and handle the hy=
percalls *instead* of the kernel=2E

I suppose you can make the case that none of the KVM hypercalls should be =
handled in-kernel and it could all be done by trapping to userspace=2E But =
that ship sailed long ago, even if you were right and the additional latenc=
y of handling the KVM hypercalls was indeed acceptable=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
