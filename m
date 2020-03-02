Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6AB17570E
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 10:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgCBJ2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 04:28:14 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37195 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgCBJ2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 04:28:13 -0500
Received: by mail-pj1-f66.google.com with SMTP id o2so2262759pjp.2;
        Mon, 02 Mar 2020 01:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PY4MuK9MtCzBBPb4BM+bF8sugRCFY9M8l8A3pQbpdiw=;
        b=sH6kyBtDw0rtBL8JJCp0gjcaIXkgXwiRFurf3c/d+4vPM+9vWt287P81nKtqzYG0ay
         5LF5ZvgufuVwc0sxB/FUyX4E8LUUFoOAqBgsnezhD8RT/9n1Uzt/1xc1wYuUa7OaLjiJ
         lgvUFYzwNd0x0iY2+dE6EvBRCNCGQ6C2UUAxQAWhC5g251G7fQDxCdtCY1N+pkHQHt0O
         nRGLbt9L3RCF+nWlrzzqpG2CEphWVeLnwASyFQOQLELIObjMpjURtbGasFsETeQh9gxM
         TtVR69dovPrIrMvDbtFM2nyhKg3A2/j/5i6wGTahMAHbG0wgBl69tx4+TevNucn0A2kr
         yKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PY4MuK9MtCzBBPb4BM+bF8sugRCFY9M8l8A3pQbpdiw=;
        b=n+/TvlhA9JEM2oGoRhrtIibXOmX2guZnA4cDYWb136V4KegQbgyaR1Z1IZSrmHNFh6
         5YhAQHbjhmL+fpLrXPW7SaNLJ9Xlt4mnR4X5fP1Bnj5hBhfFiJp0KvsMV0sOoWafel6F
         pcUAQTYnLr0993L5EaM5mPrup+OmpqploxxlcFhJD0ukyuBZ8G1uf7Zh6WIGjpyKyr/y
         R8jkwQMtOkkgeCQemthVjC/IeOScXuyBEAq02iJuncUrkqmq/xuINs6BQZw/CW4eWMpW
         aRSt66CwYjgVTqlLZ71jbKrd83kaIONCVdzXHGTlP2eZxoHWbjMvWdYPXKngn1j2DGqR
         xQNw==
X-Gm-Message-State: APjAAAUWJ64GhzqgurMOLoCeBK/PvDMj5SiLL119Yrq9y+ooFE6QbfOn
        CdNebKBKaC+PvQbNNw9wdvY=
X-Google-Smtp-Source: APXvYqyeNNsZf2cgZjbOAIPSLGSZ+N52xHOXT7mNYakDKjVkVzamzuWHN7a0r80GFylvRLX8MXK76g==
X-Received: by 2002:a17:90a:d101:: with SMTP id l1mr21047899pju.130.1583141292001;
        Mon, 02 Mar 2020 01:28:12 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:999b:d09b:90a3:47d8? ([2601:647:4700:9b2:999b:d09b:90a3:47d8])
        by smtp.gmail.com with ESMTPSA id x70sm11811963pgd.37.2020.03.02.01.28.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 01:28:11 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v2] x86/kvm: Handle async page faults directly through
 do_page_fault()
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <53626d08de5df34eacce80cb74f19a06fdc690c6.1582998497.git.luto@kernel.org>
Date:   Mon, 2 Mar 2020 01:28:04 -0800
Cc:     LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: 7bit
Message-Id: <34082A11-321D-4DF0-A076-7BBF332DCA66@gmail.com>
References: <53626d08de5df34eacce80cb74f19a06fdc690c6.1582998497.git.luto@kernel.org>
To:     Andy Lutomirski <luto@kernel.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Feb 29, 2020, at 9:50 AM, Andy Lutomirski <luto@kernel.org> wrote:
> 
> KVM overloads #PF to indicate two types of not-actually-page-fault
> events.  Right now, the KVM guest code intercepts them by modifying
> the IDT and hooking the #PF vector.  This makes the already fragile
> fault code even harder to understand, and it also pollutes call
> traces with async_page_fault and do_async_page_fault for normal page
> faults.
> 
> Clean it up by moving the logic into do_page_fault() using a static
> branch.  This gets rid of the platform trap_init override mechanism
> completely.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Indeed the async-PF mechanism is only used by KVM, and there is no need for
over-engineering the solution just in case some other hypervisor ever
introduces support for a similar paravirtual feature.

Yet, this might be a slippery slope, making Linux optimized to run on KVM
(and maybe Xen). In other words, I wonder whether a similar change was
acceptable for a paravirtual feature that is only supported by a proprietary
hypervisor, such as Hyper-V or VMware.

