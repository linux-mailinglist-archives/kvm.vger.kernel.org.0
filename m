Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F5C25184D
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 14:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgHYMLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 08:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729051AbgHYMLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 08:11:36 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5ABC061574;
        Tue, 25 Aug 2020 05:11:35 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id e11so10164244ils.10;
        Tue, 25 Aug 2020 05:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y0fqJAi2q1wLdvWz2fG2+Ma0IiMVbAmyb/CXLp46wV4=;
        b=J+lbKQ8ZWXW+rZRvfI0n3+KbSsRmAQiWkv4Q0JtH2LcPvtJx/FaQlbnZqhY6vZkVM6
         zpkNW+fpbwGHhSYAmUcQFwBvrzvbxs+iuOAY+ZbHdmAbnJaUfh72Key3s8Y2Tsy/Doe7
         1acNNB5bLjwpS4+OnuQkyOiltLS0ruy7wYM7s74NbMNylzrX9dcHPGhTJb5erEWxR209
         kJMoCDzdw4SjO9ysuZf75VZOLfgt/C6fxlIpJkvpW2hq4o3Wp45AeMhiuXEEtljuRjVg
         mQvRKtuoD4RpOrS2atQMK1UX+7d4FPJII4PzV6M7BdTDPp7rRAE5UQFjJer8OtfmtQ28
         +D3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y0fqJAi2q1wLdvWz2fG2+Ma0IiMVbAmyb/CXLp46wV4=;
        b=ELpJHIT20DJHHZE4oIf7sbYRcxJRFe8fq90Y/069K8QauOLzxQuFGYW/dLKxD5/39M
         7ddCou5lwaS9n0rQWKPIxULs6Q/0iYSGRWt0HR96zd/N90YkzuwiPQro9IYyKPsWvGoB
         ZHNEBTalqMKQMb7ubO56fkHF2jO7uG84oi+Uco4VmNdLms/D0YWUxm94iptVVfaZeNcA
         IVU14ZCOMgheRblwy9jDRyRyIar8F8hUIOPa3tNM42l73nPnAIL35Ns/blTUHu+YolqP
         rWuHrVxCv7+9qoBvHJB0jity0H3tfPso7N+ACvL8iIn8iEbM1h9A+8FVi68+IUPzHs1g
         5Lcw==
X-Gm-Message-State: AOAM530RJ4j+psQuxuyFtbN9R48xJH6zz3PncvGLVFB+CAVpP5lY1pqN
        +kP8zYLdPkPw1qQGOQ9LJK+emLF/GnoZ6+NScZXuMXKPdZ8Y
X-Google-Smtp-Source: ABdhPJw1wsBg30NMrUWDxgSVJ06a4iXUNVqdmIBtQII2d10y4Id3bTjHiUJHWlyU+nUBrC+CAOUV4AcEleFyg4koMKk=
X-Received: by 2002:a92:5a8c:: with SMTP id b12mr8199951ilg.27.1598357494861;
 Tue, 25 Aug 2020 05:11:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200821105229.18938-1-pbonzini@redhat.com> <20200821142152.GA6330@sjchrist-ice>
 <CAMzpN2h79bi5dd7PxjY45xYy71UdYomKa1t2gNxLtRpDkMs+Lw@mail.gmail.com> <874kor57jm.fsf@nanos.tec.linutronix.de>
In-Reply-To: <874kor57jm.fsf@nanos.tec.linutronix.de>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Tue, 25 Aug 2020 08:11:23 -0400
Message-ID: <CAMzpN2jQofGQ18PsEobeqfGX6ux=xuun_SQZhY=E3n1pzvEoAQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86/entry/64: Do not use RDPID in paranoid entry to
 accomodate KVM
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 25, 2020 at 6:44 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Fri, Aug 21 2020 at 11:35, Brian Gerst wrote:
> > On Fri, Aug 21, 2020 at 10:22 AM Sean Christopherson
> >> >  .macro GET_PERCPU_BASE reg:req
> >> > -     ALTERNATIVE \
> >> > -             "LOAD_CPU_AND_NODE_SEG_LIMIT \reg", \
> >> > -             "RDPID  \reg", \
> >>
> >> This was the only user of the RDPID macro, I assume we want to yank that out
> >> as well?
> >
> > No.  That one should be kept until the minimum binutils version is
> > raised to one that supports the RDPID opcode.
>
> The macro is unused and nothing in the kernel can use RDPID as we just
> established.

It is opencoded in vdso_read_cpunode(), but the RDPID macro can't be
used there.  So you are correct, it can be removed.

--
Brian Gerst
