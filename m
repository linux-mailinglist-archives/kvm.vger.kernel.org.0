Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A24C0E5E
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2019 01:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbfI0Xhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 19:37:38 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44607 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbfI0Xhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 19:37:38 -0400
Received: by mail-io1-f65.google.com with SMTP id j4so20890130iog.11
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 16:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YMZ9O3eRKTf/NLdRiOsF+GXcxfQDV+iSyTOvLX/Wcb4=;
        b=XdPoEdvmSx4tupszIBhFg85LfTAkMRmdColwUTP6ZGjQr5jXWAEu5cEjRP6GgJRhPK
         jaW4M5ooyQVUsgrUHx113bWTVwe9Bp0nMv0G3/rzSt8S4RS1/vyLcDClPdniU3MF2D6h
         +POumf7BolXC/HfldPWR2lG0lJ0he8/qtTsaAEUKWmyKyS3bIB83Nq9nLZt/7MArL3Jv
         vYoORvX4de//CAND1ZtsqNWPR5q77Nr2chGOGyAlLJFnlRi/4zi5oPQfqF/Yks4RjWyQ
         6zSldVpTpuCLBWQIZ24uW2a6HI7i109I+x2nRWL8+bmKstC4eKh/JUHDLSMX6BcLq9EX
         BIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YMZ9O3eRKTf/NLdRiOsF+GXcxfQDV+iSyTOvLX/Wcb4=;
        b=t3Lx/nl5Fxs2Gw3Gbd+TtukFhtZPX2mTPCSRXspLJ1h7xvK549B2mNPUOF3FdDvE2m
         IwYAu/V8zsjoNErHgf4hYD7xtJaSugoXSSf5FD7f880sNzj+SGpDVnfk359us9ppZpdq
         T2hwvTcEkvHzK1oJVbBWAtAYTYoaXkx4nIvbcFpuuB2zPxURBAEiwPnEVnJJlSZtQhQI
         Z9BX5e62yH6VtSE/Vee91z4oukLJP7xtRwLeuFAuPzZ+uSVD3PtEYiQD3vLkDJd+sQJI
         5UkxFAm0BhTVoIP2mekceaDt/lSWw7JFBSUsbLu7nz5A/tUXrKZRHDotzNzoabW3RSOH
         108A==
X-Gm-Message-State: APjAAAXmmKW42Gh0tE2NeokqKmpAOafn8WN/w0Y18ALfvAccEiRrsVXZ
        lD5HL3Il+pUv7NQBrAMdbhm+udkVi1oO0YZeuNh6Jg==
X-Google-Smtp-Source: APXvYqyAyqC145r4XgUlwodux+mPVgQ0s2/9frCnPDDLj+MzliGsh5edbzXHF81C1keruGiQ9tDmyXrLOnwP3G+pJUg=
X-Received: by 2002:a6b:1606:: with SMTP id 6mr11821118iow.108.1569627456831;
 Fri, 27 Sep 2019 16:37:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190927214523.3376-1-sean.j.christopherson@intel.com> <20190927214523.3376-2-sean.j.christopherson@intel.com>
In-Reply-To: <20190927214523.3376-2-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 27 Sep 2019 16:37:25 -0700
Message-ID: <CALMp9eQ5M+GPyxo_9aNdaUZfwZLZcxdtmQKCo1JjnAL-Jdh4-w@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] KVM: nVMX: Always write vmcs02.GUEST_CR3 during
 nested VM-Enter
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 2:45 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Write the desired L2 CR3 into vmcs02.GUEST_CR3 during nested VM-Enter
> instead of deferring the VMWRITE until vmx_set_cr3().  If the VMWRITE
> is deferred, then KVM can consume a stale vmcs02.GUEST_CR3 when it
> refreshes vmcs12->guest_cr3 during nested_vmx_vmexit() if the emulated
> VM-Exit occurs without actually entering L2, e.g. if the nested run
> is squashed because nested VM-Enter (from L1) is putting L2 into HLT.
>
> Note, the above scenario can occur regardless of whether L1 is
> intercepting HLT, e.g. L1 can intercept HLT and then re-enter L2 with
> vmcs.GUEST_ACTIVITY_STATE=HALTED.  But practically speaking, a VMM will
> likely put a guest into HALTED if and only if it's not intercepting HLT.
>
> In an ideal world where EPT *requires* unrestricted guest (and vice
> versa), VMX could handle CR3 similar to how it handles RSP and RIP,
> e.g. mark CR3 dirty and conditionally load it at vmx_vcpu_run().  But
> the unrestricted guest silliness complicates the dirty tracking logic
> to the point that explicitly handling vmcs02.GUEST_CR3 during nested
> VM-Enter is a simpler overall implementation.
>
> Cc: stable@vger.kernel.org
> Reported-and-tested-by: Reto Buerki <reet@codelabs.ch>
> Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
