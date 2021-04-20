Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125123651E3
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 07:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhDTFqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 01:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhDTFqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 01:46:35 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D5EC06174A;
        Mon, 19 Apr 2021 22:46:03 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id w23so40590498ejb.9;
        Mon, 19 Apr 2021 22:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=fXjwTDCI0JfAHocBzWWyLFaiapoMwBLjcCP3SLFYBAk=;
        b=MnPb9ImWv0p0rgMN2zYifNQWHmjZOaByAYPAptzLn1ZqIziA9jpBwxd1EIPMlOzkAy
         8K2i+D3JXK99sIX2yLjyFgQaVdBE8KoeHpQtMz1to32aIRbKohDS6bSsZcY/Ag+/Vd3W
         xwbL5Hqp3L+zx4LOKKe3cx7Q+AWAWoIaMVubhDxB7f/OxRc2eNyqUnxXrhhlN6cCYJB2
         4rrO8MuAIUsViCaMxiMGLPDiLma+jOb4o+mV6Bk+CGl09I2lZFbN9M+tjqM70gZmTRv8
         +QERKuH+uMjI4A+rlZm9an1n76gBSC724dzenMRZ/a4y9o1pgM4jnhAVgd/vfhMABicw
         0Dog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fXjwTDCI0JfAHocBzWWyLFaiapoMwBLjcCP3SLFYBAk=;
        b=K4jlSL4V8Wfs4pUcEpPasulQNYh7v+aIS08ASz0QTWDEunS4stO13x7KDGEHvNXPLx
         Lx8k7eYqZWOcMEKLpWRNOvdt87OcELFB6x4HUgLvQBioWz7Qf7C2s6X9Fw3iXhC9/kdr
         4YsmNWINr4+5Qxz6yavjDo552e24vYq59rgvyW49vWvgINVPbVDz1kk3FYTENmPcBHbL
         rtgcAQpTP+rCDO9e1EERtgF0OKdF6MvKz75R1FMFHkSYbSb3OMlG2zuK2J8CTcdkULP0
         E2CsneMxuKY1k29NI3l5l5pyLFIAkuCDp4tC9lcb+g351jkUnX0KBmTKlKAelldg7/mk
         ZNow==
X-Gm-Message-State: AOAM5306Y30994fTkvwFE2PbtDnQyUU/RuPEDC4zJp6NZCGnb3P6x6ra
        Sw4Y+zd6GsqM8/aGLiIQjsiiC76KS17iLD10Yew=
X-Google-Smtp-Source: ABdhPJzZVVvcLcQBCrcXCpxFFRsa2x8dmRxGSnS3BFksjvKkD6gg8o/KoDb1pac+U+5DAAB7aFNOYVyrLzoz7al1YRo=
X-Received: by 2002:a17:906:37c9:: with SMTP id o9mr25241115ejc.285.1618897561979;
 Mon, 19 Apr 2021 22:46:01 -0700 (PDT)
MIME-Version: 1.0
From:   Shivank Garg <shivankgarg98@gmail.com>
Date:   Tue, 20 Apr 2021 11:15:45 +0530
Message-ID: <CAOVCmzH4XEGMGgOpvnLU7_qW93cNit4yvb6kOV2BZNZH_8POJg@mail.gmail.com>
Subject: Doubt regarding memory allocation in KVM
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
I'm learning about qemu KVM, looking into code and experimenting on
it. I have the following doubts regarding it, I would be grateful if
you help me to get some idea on them.

1. I observe that KVM allocates memory to guests when it needs it but
doesn't take it back (except for ballooning case).
Also, the Qemu/KVM process does not free the memory even when the
guest is rebooted. In this case,  Does the Guest VM get access to
memory already pre-filled with some garbage from the previous run??
(Since the host would allocate zeroed pages to guests the first time
it requests but after that it's up to guests). Can it be a security
issue?

2. How does the KVM know if GPFN (guest physical frame number) is
backed by an actual machine frame number in host? If not mapped, then
it faults in the host and allocates a physical frame for guests in the
host. (kvm_mmu_page_fault)

3. How/where can I access the GPFNs in the host? Is "gfn_t gfn = gpa
>> PAGE_SHIFT" and "gpa_t cr2_or_gpa" in the KVM page fault handler,
x86 is the same as GPFN. (that is can I use pfn_to_page in guest VM to
access the struct page in Guest)

Thank You.

Best Regards,
Shivank Garg
M.Tech Student,
IIT Kanpur
