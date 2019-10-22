Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4C5E09A9
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 18:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732733AbfJVQuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 12:50:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731373AbfJVQug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 12:50:36 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 651272CAB60
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 16:50:36 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id a81so4147327wma.4
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 09:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ilUdqbrYy8ySaTQ6ZcthNEde+QTyn7VVTo6FG7DI6ho=;
        b=t4ftiEn0nfLFl12Ci74hehVQbnwEUBe+3YljuXjx6qj2eB2yXXl3odTDheSsofqAfa
         IcqG7x8YoJoHovM/YiV5BUaL0B4lq7GgF0wOMPfjX3UK5ILfDLdzpWeMMN4HTNgBxcPd
         jGzXYVjJCxYibIWTS3XOOclP6JwR4AefbVmfwKxDzusN7YpwmqjO++JvwlmAPRc7jo68
         /cKrLWytZKePXdKnixhRaYPomSKdhx2+QhPR5WTmFe+KS1Qw/lPy1/M5vNc09B9QLoT2
         UYr1+vokQ5pmh3hISj2zuHlGSfy/oV511stdsAYjPFCI7o8kNprR3UlltAFd/az5Tetr
         568A==
X-Gm-Message-State: APjAAAVksJzKxgyDMcN8/yTj4HcNHLsN4zqG32z9sCK13gWxCl3dpHLA
        6OkJvgo5rhVJYVV6BBv08ReUFZ9UkVUdKCd0x3JzwEnwoEbSw332E70TiEgMd2RdlAHOI/HDjwN
        mL9SMA/Xpub1J
X-Received: by 2002:a5d:638c:: with SMTP id p12mr3966515wru.136.1571763035010;
        Tue, 22 Oct 2019 09:50:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx4hJVmjBEEIjlMnRd/woKAUXyjdR00JU3x721XYw4PDBHU0IVP/HgLbhGW9Zh+iu6O8gJCcQ==
X-Received: by 2002:a5d:638c:: with SMTP id p12mr3966487wru.136.1571763034703;
        Tue, 22 Oct 2019 09:50:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id w18sm1678274wrl.75.2019.10.22.09.50.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 09:50:34 -0700 (PDT)
Subject: Re: [PATCH RESEND v6 0/2] x86: Enable user wait instructions
To:     Tao Xu <tao3.xu@intel.com>, rth@twiddle.net, ehabkost@redhat.com,
        mtosatti@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, jingqi.liu@intel.com
References: <20191011074103.30393-1-tao3.xu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <393ea49d-1da3-9454-eae3-f8393a6ce72b@redhat.com>
Date:   Tue, 22 Oct 2019 18:50:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191011074103.30393-1-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/19 09:41, Tao Xu wrote:
> UMONITOR, UMWAIT and TPAUSE are a set of user wait instructions.
> 
> UMONITOR arms address monitoring hardware using an address. A store
> to an address within the specified address range triggers the
> monitoring hardware to wake up the processor waiting in umwait.
> 
> UMWAIT instructs the processor to enter an implementation-dependent
> optimized state while monitoring a range of addresses. The optimized
> state may be either a light-weight power/performance optimized state
> (c0.1 state) or an improved power/performance optimized state
> (c0.2 state).
> 
> TPAUSE instructs the processor to enter an implementation-dependent
> optimized state c0.1 or c0.2 state and wake up when time-stamp counter
> reaches specified timeout.
> 
> Availability of the user wait instructions is indicated by the presence
> of the CPUID feature flag WAITPKG CPUID.0x07.0x0:ECX[5].
> 
> The patches enable the umonitor, umwait and tpause features in KVM.
> Because umwait and tpause can put a (psysical) CPU into a power saving
> state, by default we dont't expose it in kvm and provide a capability to
> enable it. Use kvm capability to enable UMONITOR, UMWAIT and TPAUSE when
> QEMU use "-overcommit cpu-pm=on, a VM can use UMONITOR, UMWAIT and TPAUSE
> instructions. If the instruction causes a delay, the amount of time
> delayed is called here the physical delay. The physical delay is first
> computed by determining the virtual delay (the time to delay relative to
> the VM’s timestamp counter). Otherwise, UMONITOR, UMWAIT and TPAUSE cause
> an invalid-opcode exception(#UD).
> 
> The release document ref below link:
> https://software.intel.com/sites/default/files/\
> managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf
> 
> Changelog:
> v6:
> 	Remove CPUID_7_0_ECX_WAITPKG if enable_cpu_pm is not set.
>         (Paolo)
> 
> Tao Xu (2):
>   x86/cpu: Add support for UMONITOR/UMWAIT/TPAUSE
>   target/i386: Add support for save/load IA32_UMWAIT_CONTROL MSR
> 
>  target/i386/cpu.c     |  2 +-
>  target/i386/cpu.h     |  3 +++
>  target/i386/kvm.c     | 19 +++++++++++++++++++
>  target/i386/machine.c | 20 ++++++++++++++++++++
>  4 files changed, 43 insertions(+), 1 deletion(-)
> 

Queued, thanks.

Paolo
