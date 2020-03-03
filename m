Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A03E176D8B
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 04:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCCDZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 22:25:57 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:36264 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgCCDZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 22:25:57 -0500
Received: by mail-il1-f193.google.com with SMTP id b15so1501082iln.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 19:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wzQcjQiljMZHk04fD58LGKeytnaqThE2ImCl62xxtGw=;
        b=gvtKrk97dyg8vZFA/UyhjwGK7wwLRLzO4JaKCmDnLPB4uaVOIWceJk3AVrSWG+tqn+
         i38ENLxtrVWCUEezxMcaWvK1ydOlXaZyDFBOHwQRYG34ddB9vCoOZHaW3FY4aBIgOIow
         qMvVJF1R2Y+In3LSEoce8WHpTlsDOVkVWe5f8NgQQ+t0kCsPHNYPlZcO8m7PbJjIFdUQ
         /RQ/Cs1N4e1qXZQRvabsrcNXQloJUPZbwatzhaZe1OxCbiUpGhBAy1I2WdBrWGIZnZaj
         vjHYWQ/6nk03klg/mtoRuhHh8HfURPYXbwuVz+PzgRzk8ugRU4ZUDractKKJTIbJ/X6J
         0FEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wzQcjQiljMZHk04fD58LGKeytnaqThE2ImCl62xxtGw=;
        b=VoCz3By29cFIdtjbh6hinX93kXr7J5rN1xu+bU2oVptZ0KeFDR12cqgQmZzOYgNcua
         XiR2qVFMkNIIyAo/KfBq4AS6LMrV4fPzQdmZU+Y4F3/F6AJU9rl0EypISDbSUwvAKG21
         gmB5bPApd2vp2Kqg5ynsNIDmnzM73CwtNUb+aHhiX93oll/Zcxd7wf6iVD1YSsK7fDqS
         ENGYLSB1B2TpzwELioR9BaGuLkC3i+UYqGpX52mOVfaLTBdp+IBaGzqPDcV7oT+qfWIL
         Q/5ASIbZ5EIRo9QfPY81wr5g8zKRveSZEq69dxXiVdt4+jHLnFyZXtPdd3kU8cXTGW7t
         rX9g==
X-Gm-Message-State: ANhLgQ15mEKJrRRPHGa51Y8M2Jga3l/xUKKsa1sS4sL8G6A4cyOXjpWq
        kPsMrJlNloY9AhsZxEoZy7ed/FwD/8XQ47cuio72FJ0e
X-Google-Smtp-Source: ADFU+vsXeBNw6lE9vPufNiNNr1E9nPXO3ou8dsPEfPthJokT+oEqBw0I0OoQKRXOLzdC/aMa2lzH9rdkH3GNL5fM9Lw=
X-Received: by 2002:a92:981b:: with SMTP id l27mr2882984ili.118.1583205954541;
 Mon, 02 Mar 2020 19:25:54 -0800 (PST)
MIME-Version: 1.0
References: <20200302195736.24777-1-sean.j.christopherson@intel.com> <20200302195736.24777-3-sean.j.christopherson@intel.com>
In-Reply-To: <20200302195736.24777-3-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 2 Mar 2020 19:25:43 -0800
Message-ID: <CALMp9eThBnN3ktAfwhNs7L-O031JDFqjb67OMPooGvmkcdhK4A@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: x86: Fix CPUID range check for Centaur and
 Hypervisor ranges
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 2, 2020 at 11:57 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:

> The bad behavior can be visually confirmed by dumping CPUID output in
> the guest when running Qemu with a stable TSC, as Qemu extends the limit
> of range 0x40000000 to 0x40000010 to advertise VMware's cpuid_freq,
> without defining zeroed entries for 0x40000002 - 0x4000000f.

I think it could be reasonably argued that this is a userspace bug.
Clearly, when userspace explicitly supplies the results for a leaf,
those results override the default CPUID values for that leaf. But I
haven't seen it documented anywhere that leaves *not* explicitly
supplied by userspace will override the default CPUID values, just
because they happen to appear in some magic range.
