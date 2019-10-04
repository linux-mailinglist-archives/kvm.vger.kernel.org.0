Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D4BCC697
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2019 01:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731525AbfJDXfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 19:35:54 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41018 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729714AbfJDXfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 19:35:54 -0400
Received: by mail-io1-f67.google.com with SMTP id n26so17044036ioj.8
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 16:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+T7DRRD+UBJWxQqae2a5KokUy893Q+Fh/NFyFQWVL5c=;
        b=aR+KCZ9iMZp71ShYHM33WPPJZLgnz4zsUdnjqJr8GHFuHLR7FyxN/fle/WUHQd2S1g
         OfLnAhfjfVGHzOaJK0w0TC11rXg1X4dvELPEblK609VJWdmUv3sZEwya23vmrWxc9DIG
         vIwRS1tb3jC35O1UM0jW9C+Ii5AJiQBiaQ1Ur7s/C07BnQkMOVZ4W9F3sPzf++A2KGb7
         xR6BJ5NeINKOa0O4NpITK3QSA5A4hBhi6JPVSDWobx9wowRsCSuZB6NQRnkdoOs+Z2W2
         osQu5NuuvxVuUBBBHYMDims/a/amUqM21/mCbGDA6dx/4nzkkCX+H13qHMc6NbHauO0N
         1cfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+T7DRRD+UBJWxQqae2a5KokUy893Q+Fh/NFyFQWVL5c=;
        b=Ah7IUR2FdUptt52mwd2BdcE72+yMO0m5VXEdLVVJu9t+1ToqOieb68fmoF5M3uomhg
         jt7aQTcsI0N2iDyU0cf61O+QrxqdpK4CLfft8EpODg6QYlC6pW08ksNdHP3PSk4K9/zE
         4Yjdh8x9Hv9AGTFp3cM5maKXAMoB0w518TzI2YAtl0L9LfON1tUGsv0YnG3gObWih+6v
         CO3tf6+EwmELB4+twB5Tg78LUBgr9hRpuHeDP2SLHXJArhiG6aW935p5KorBJwAM7m8S
         mU16JcJpCxW7emz+elFFqnYehBy52H2P/zVj9GyeaSNHEVfwsjEEshcJIptVogrkxfCp
         C3bg==
X-Gm-Message-State: APjAAAVOlL0x9IX0CS2k0lE4imFztF2XngRt1/S+YcUyU4LJvvxgyx99
        aU6bM0dQGdrqvgii4ECl1SqpEBgzUCJzA76lc9dh/g==
X-Google-Smtp-Source: APXvYqx43jSstCJvk+2c6AUFzK14t9HPWx/edmJdJr8SoFrOND4p+DMir84DYAG2WVlbh9N6FdgDkbxAOENqDWPCqg4=
X-Received: by 2002:a92:5a10:: with SMTP id o16mr19118181ilb.296.1570232153408;
 Fri, 04 Oct 2019 16:35:53 -0700 (PDT)
MIME-Version: 1.0
References: <20191004215615.5479-1-sean.j.christopherson@intel.com> <20191004215615.5479-9-sean.j.christopherson@intel.com>
In-Reply-To: <20191004215615.5479-9-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 4 Oct 2019 16:35:42 -0700
Message-ID: <CALMp9eSEF-MKxF1+ApTe9-2fJbRBt2svHiCdX=4jP25Ed2LqBg@mail.gmail.com>
Subject: Re: [PATCH 08/16] KVM: VMX: Check for full VMX support when verifying
 CPU compatibility
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-edac@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 4, 2019 at 2:56 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Explicitly check the current CPU's VMX feature flag when verifying
> compatibility across physical CPUs.  This effectively adds a check on
> IA32_FEATURE_CONTROL to ensure that VMX is fully enabled on all CPUs.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
