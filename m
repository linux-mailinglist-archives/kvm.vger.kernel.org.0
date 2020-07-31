Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93812233DAB
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 05:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731315AbgGaDUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 23:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731279AbgGaDUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 23:20:18 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6833C06174A
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 20:20:18 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id j8so18045177ioe.9
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 20:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ENQWuwdn/hvmQ301dN3tmkkB+LAcEklgYZq8xuTSYw=;
        b=TIDl8Ys7hSbhzPM2mHauS/ReeI+JqpSYdopU1RM4jHqMdHyOREE8Vlve22yEcLgG1g
         507Ue8awfbRghdJ6vHS7inQajFgR44+iuLum18eYJ4hfDSN1S6KUduhnIMPL3ZmQXMEe
         bXbTAT0L5i4kFIvbXtqJChwmEeU9jKVIXrzpt1k7cmweAl/VN+NibANBQewidfEf++u7
         8dqcdFbcBpaTDSykn8SNEj0wY0IWGltFTuCoa05AD2Lo27I8s5PDEVm65Svb2mQs8Vpc
         ircCbnkbzNISgoVFgfVWIh7282qoaV0k1q6yMjGZrfK+R9xL0dFRLf9mqvTL+amTzxpe
         iRZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ENQWuwdn/hvmQ301dN3tmkkB+LAcEklgYZq8xuTSYw=;
        b=PKX7Hv3HAhlorX+qfANTOyMUtUBUEkcp74W4ORoCraArKdaAcs2Jo3WfcZzVBFiKh3
         +hDA24TvBZEJ1Vzm27frNt0At2+jR7RH1YBu8r7PUWUoCa5FwOnQlvupPqVbm/gJxoBd
         3TpIan5EntBHRdYbz7RigMrmg1wkof2FJHUhy7jmWr3rc6/pjSPVaKmSII6Tjxk24hIg
         5Xt4f9nSQZf/dmnW3osLGKQxVnbGOZvv5v5PQrsVbxM1UkFgktU+2f6yEjufvQ6M2j+M
         5vX2c1FEThILRPZNKWV32e8vBiEDdT+0ZaJLtwVqSGUgCh9LrkUbjg5oStNVdWoQnxjn
         VqWA==
X-Gm-Message-State: AOAM530ZDoT+QmK3jSAZDT9rW/oL/5NIHUjzEFslBYOomf236NyKNTi0
        PGnjTVvOfrpBhUb+/MbQAy7BG4FYIfkFVJC/Wg/sXg==
X-Google-Smtp-Source: ABdhPJz/t0Yu4F9Ndzp7QqxU21H3Aj0mRN+wMLbRFcabvVIIRE+bNPKaV47Hq6jCYL1LWhHyBhWTpfdfzh06hlBM+sI=
X-Received: by 2002:a6b:c3cf:: with SMTP id t198mr1674974iof.164.1596165617501;
 Thu, 30 Jul 2020 20:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200729235929.379-1-graf@amazon.com> <20200729235929.379-2-graf@amazon.com>
 <CALMp9eRq3QUG64BwSGLbehFr8k-OLSM3phcw7mhuZ9hVk_N2-A@mail.gmail.com>
 <e7cbf218-fb01-2f30-6c5c-a4b6e441b5e4@amazon.com> <CALMp9eRQRaw7raxeH1nOTGr0rBk5bqbmoxUo7txGyQfaBs0=4g@mail.gmail.com>
In-Reply-To: <CALMp9eRQRaw7raxeH1nOTGr0rBk5bqbmoxUo7txGyQfaBs0=4g@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 30 Jul 2020 20:20:06 -0700
Message-ID: <CALMp9eSSKra+Vic0U9kDeiT1y+Jfq6Vmrqsw+S8jqD0_oqH9zA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Deflect unknown MSR accesses to user space
To:     Alexander Graf <graf@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        kvm list <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 30, 2020 at 4:53 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Thu, Jul 30, 2020 at 4:08 PM Alexander Graf <graf@amazon.com> wrote:
> > Do you have a particular situation in mind where that would not be the
> > case and where we would still want to actually complete an MSR operation
> > after the environment changed?
>
> As far as userspace is concerned, if it has replied with error=0, the
> instruction has completed and retired. If the kernel executes a
> different instruction at CS:RIP, the state is certainly inconsistent
> for WRMSR exits. It would also be inconsistent for RDMSR exits if the
> RDMSR emulation on the userspace side had any side-effects.

Actually, I think there's a potential problem with interrupt delivery
even if the instruction bytes are the same. On the second pass, an
interrupt could be delivered on the CS:IP of a WRMSR, even though
userspace has already emulated the WRMSR instruction. This could be
particularly awkward if the WRMSR was to the x2APIC TPR register, and
in fact lowered the TPR sufficiently to allow a pending interrupt to
be delivered.
