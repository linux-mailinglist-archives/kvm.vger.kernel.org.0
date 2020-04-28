Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39C21BCF04
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 23:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD1Vmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 17:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726272AbgD1Vmp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 17:42:45 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54514C03C1AD
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:42:44 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f3so25065193ioj.1
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rfmlo41ts2i7Zcv0kqVybUxAnbR3sTlhoiDkLxdhqcM=;
        b=jzYQ2rTc5iGSeW867YpgJb0e0aw2v+lG7u1PpshHvK+b6XV/dUh6YTFnf/tFVjoHSL
         BU4n4+hcpwwPAURGSbzgxuxkjBKwGmDDH8fhJ6Noim6yF2Ko55IlWL3GaMHWQIEE85z8
         stYWqfldjztBG7VdjBUxgxmYYt7ch8ZcywOPIpqIy8JW+yYySgvhJYT/a2dBQLTPNYo6
         TtGt6ctYXhojzWnBpNIFQzBu/3qfIkUvqHKv/BAXbgbmwYbakHDJ4C2IA1PvjgV2JQK5
         3zqvrwVubOUgBRTJ59l1iaxH/JjFjMKorIeIuTq3Oo0trW8vjEUnPKDt2enyUWMjCT9R
         lGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rfmlo41ts2i7Zcv0kqVybUxAnbR3sTlhoiDkLxdhqcM=;
        b=O/0l7u/vTDSrdbcGIXnUT49VtCThJE1LeJu+5dJMlrGz/ct20zIoJhrGgqAbSXr6IL
         vUsQioVltPxc4VRk4rKLPjl/h7P8jf6tMCvo0a73t+feLaZXdSmsecYlJLfRffzKw/UH
         LKraaFct14EWY92UHFtpDK6FyQUoaf67j0o51BYugk5nn3ipEbLXfClrJcReQkLisrwH
         pkY0j+Pn/l4gFBpSppsz+dLQdXW881Ytv4oNsjwU7JgxmOqNeR/9eWkYv3RPRr3NwRGc
         amNtExt9Kyndr+cNg/HK53FAcb+BbSYddSwmm+NVGIcjMj8n58N7zFtqlKEn4tud/VYh
         M+mA==
X-Gm-Message-State: AGi0PuaOlZevpTDjHjVSo+764L4cbGvcJzbJBeDzND2vWKfBrh+WbqFn
        td7JSENCQ6fD2AD9IJM21VLCC+SgilHVLSMJs+JEOw==
X-Google-Smtp-Source: APiQypK7/mohAHqrxGWpCG7N79ayXvDCuEmqwdOh2T1wVp1srOrMpFaJDheHtIywUbwKQ4GJrCnqek9FIrXvz7vYYDc=
X-Received: by 2002:a05:6638:bd0:: with SMTP id g16mr27759289jad.48.1588110163502;
 Tue, 28 Apr 2020 14:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-5-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-5-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 14:42:32 -0700
Message-ID: <CALMp9eRPfvsx+uu4RFbDiLrL4pY9_NiZkivWqUi8gUSAMHv-ZA@mail.gmail.com>
Subject: Re: [PATCH 04/13] KVM: x86: Make return for {interrupt_nmi}_allowed()
 a bool instead of int
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Return an actual bool for kvm_x86_ops' {interrupt_nmi}_allowed() hook to
> better reflect the return semantics, and to avoid creating an even
> bigger mess when the related VMX code is refactored in upcoming patches.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
