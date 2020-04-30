Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6BD1BED14
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 02:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgD3Apa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 20:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgD3Apa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 20:45:30 -0400
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B8DA2083B
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 00:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588207529;
        bh=N3ANq6sB2a8lmCCJej+V3dGn8w0n7uzbK/eRXsHO3uo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xg+cdf9Squc1qTKUxLzUxFRpT+9TYfeljsABrROZLaiBeMCDnwDHdkQ8GsoDUi2UU
         fIUhxPNAZh/tdtR6cOwQYlph0s2+lDL0vDKeNrE9nGoJSn9aVkoUM/3+J0lm7XTusA
         23+gHtfzQB9p87PIZja5Ai0Bj29UxM+2OZ9iiG9o=
Received: by mail-wr1-f51.google.com with SMTP id b11so4754683wrs.6
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 17:45:29 -0700 (PDT)
X-Gm-Message-State: AGi0PubWS6nPSgzld2Wp3a/5GxclpVGEW3on3k1nTFf/CzFcgM3ZcUO3
        5M+WG6O30GzcqCT+MB3Y1n0FXlh39dLfszJvMOTE+Q==
X-Google-Smtp-Source: APiQypJJOJY3YRF/QTUlTHF0NHfRgu9K+ytc2U5m1lBDYPfYqr3cUXh6I1WPp1YkIROgmKABgcygbJdL9Km/lxxCjH8=
X-Received: by 2002:adf:bc05:: with SMTP id s5mr880712wrg.70.1588207527548;
 Wed, 29 Apr 2020 17:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200429093634.1514902-1-vkuznets@redhat.com> <20200429093634.1514902-5-vkuznets@redhat.com>
 <CALCETrXEzpKNhNJQm+SshiEfyHjYkB7+1c+7iusZy66rRsWunA@mail.gmail.com> <0de4a809-e965-d0ad-489f-5b011aa5bf89@redhat.com>
In-Reply-To: <0de4a809-e965-d0ad-489f-5b011aa5bf89@redhat.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 29 Apr 2020 17:45:16 -0700
X-Gmail-Original-Message-ID: <CALCETrWQBmmVODuSXac965o29Oxqo6uo4Ujm2AN2FUMztwCnzA@mail.gmail.com>
Message-ID: <CALCETrWQBmmVODuSXac965o29Oxqo6uo4Ujm2AN2FUMztwCnzA@mail.gmail.com>
Subject: Re: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf
 page ready notifications
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 29, 2020 at 10:40 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 29/04/20 19:28, Andy Lutomirski wrote:
> > This seems functional, but I'm wondering if it could a bit simpler and
> > more efficient if the data structure was a normal descriptor ring with
> > the same number slots as whatever the maximum number of waiting pages
> > is.  Then there would never need to be any notification from the guest
> > back to the host, since there would always be room for a notification.
>
> No, it would be much more complicated code for a slow path which is
> already order of magnitudes slower than a vmexit.  It would also use
> much more memory.

Fair enough.

>
> > It might be even better if a single unified data structure was used
> > for both notifications.
>
> That's a very bad idea since one is synchronous and one is asynchronous.
>  Part of the proposal we agreed upon was to keep "page not ready"
> synchronous while making "page ready" an interrupt.  The data structure
> for "page not ready" will be #VE.
>

#VE on SVM will be interesting, to say the least, and I think that a
solution that is VMX specific doesn't make much sense.  #VE also has
unpleasant issues involving the contexts in which it can occur.  You
will have quite a hard time convincing me to ack the addition of a #VE
entry handler for this.  I think a brand new vector is the right
solution.
