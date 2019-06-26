Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655EB56FB7
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 19:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfFZRle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 13:41:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44135 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfFZRld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 13:41:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16so3692115wrl.11
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 10:41:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=t2qwRs7koe0N7pYzHfarivbdbI697R0UkLvgOjEc6fg=;
        b=Zf3yYiI8GoNOm7/+rC9oEF9TG9CFYDmtOFjdfwXgZxs9teZtwJ7BuTIJHqNatXO36L
         dKle7rcPEoemjn77lZZ2DpZiZhtEd/H44MIpwu7BOsxJlkdJPGHGOj2SNgOwCe+Rel7b
         OCLyP4KuG8dNvZKEBlUKWeZY+T/DK44vQI/Hkn2sGXQpIXQCCAfa3pwHl9z2xq1cvZRN
         JHtgwMkHMaRwXD08F9Hroe9Na1vmuay44YX7JTST007SdS2khF05aXEuWaMtJK8N2jsR
         27nUtFjz7G3qZCTxbsLKL5v900LQzaRRpbMkoQNYDtwenk8DKNiAsxTeRWYVVvivNeSu
         fJjg==
X-Gm-Message-State: APjAAAWbBtOQCur+uJmwlIuXbg6IXKCLoJVFaEbpsPPlfxhnskp/hSCP
        c3NICD+VU/p5Gwh+0l1kWtVvS2ciWfs=
X-Google-Smtp-Source: APXvYqwJ4Z4pdKRax8Z2pKF/BL7aG7XRGilbIpnO+wMYHg1EmrVhaIhK8YsHNXK6Nvcm7thSb6IuMg==
X-Received: by 2002:adf:ee91:: with SMTP id b17mr4595442wro.182.1561570891172;
        Wed, 26 Jun 2019 10:41:31 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 72sm24638446wrk.22.2019.06.26.10.41.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 10:41:30 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Andy Lutomirski <luto@kernel.org>, Nadav Amit <namit@vmware.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/9] KVM: x86: Provide paravirtualized flush_tlb_multi()
In-Reply-To: <CALCETrW2kudQ-nt7KFKRizNjBAzDVfLW7qQRJmkuigSmsYBFhg@mail.gmail.com>
References: <20190613064813.8102-1-namit@vmware.com> <20190613064813.8102-7-namit@vmware.com> <cb28f2b4-92f0-f075-648e-dddfdbdd2e3c@intel.com> <401C4384-98A1-4C27-8F71-4848F4B4A440@vmware.com> <CALCETrWcUWw8ep-n6RaOeojnL924xOM7g7eb9g=3DRwOHQAgnA@mail.gmail.com> <35755C67-E8EB-48C3-8343-BB9ABEB4E32C@vmware.com> <CALCETrUPKj1rRn1bKDYkwZ8cv1navBne72kTCtGHjnhTM0cOVw@mail.gmail.com> <A52332CE-80A2-4705-ABB0-3CDDB7AEC889@vmware.com> <CALCETrW2kudQ-nt7KFKRizNjBAzDVfLW7qQRJmkuigSmsYBFhg@mail.gmail.com>
Date:   Wed, 26 Jun 2019 19:41:29 +0200
Message-ID: <878stockhi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Lutomirski <luto@kernel.org> writes:

> All this being said, do we currently have any system that supports
> PCID *and* remote flushes?  I guess KVM has some mechanism, but I'm
> not that familiar with its exact capabilities.  If I remember right,
> Hyper-V doesn't expose PCID yet.
>

It already does (and support it to certain extent), see

commit 617ab45c9a8900e64a78b43696c02598b8cad68b
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Wed Jan 24 11:36:29 2018 +0100

    x86/hyperv: Stop suppressing X86_FEATURE_PCID

-- 
Vitaly
