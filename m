Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7730D70FB
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 10:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfJOI2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 04:28:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbfJOI2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 04:28:41 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 28BD44FCC9
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 08:28:41 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id f3so9727219wrr.23
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 01:28:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pb5c9lwLTcI2EdDTvk1a+i+Hv8sTLnOmEVzrLcGSMOs=;
        b=o0qQupplTaW2NYp86xkKDcMHxApd3430RPZxDQDfzt4nS8YG3IjHh1g8Y7bT9eOqyF
         SPU2bbLf/OWBRoFWACSayJNBrnHJpfc+gB3SxLuIqraE4m2f84c851AMNEaGQQXjNqN5
         WN6p2b+wm+PkeCYDX/RRv/diMNZHNv3mKHSUP+2gU2OHvokGqlcMttvqeCLnFHRE8prC
         ScX984Ejf/Upa8EBn7GS2IVMiqgGfnBIhcrFEft181Ywkd0io8UvA0p2VJt78CTbTmHq
         O+3eUILy+2qlDgP9W3JMq2FEWC/f+xITeBlvPRVScMZuWEbsZXmZCCgIf4946JeiaRCs
         5zNg==
X-Gm-Message-State: APjAAAWLKncd+d+zA2arBEJ6j8gPSYXpwxE47nzED5HEz90N7R/Ba5q4
        7OMSePortVGdIucIcYXnew26TU2j5Om3WxNJJPX4qEdVjlYIO2vejnUlOAaNbas/PZYuY7Y40y8
        arZPiJwP6CVPM
X-Received: by 2002:adf:f64f:: with SMTP id x15mr8751669wrp.381.1571128119764;
        Tue, 15 Oct 2019 01:28:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqydeaTS8NVPSDeM3SIMjYGP5LXxc6Bs4/otlg35Zr761dlYB9jclfIYgdQG3CIX1gNG955ISQ==
X-Received: by 2002:adf:f64f:: with SMTP id x15mr8751651wrp.381.1571128119461;
        Tue, 15 Oct 2019 01:28:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id o22sm49779359wra.96.2019.10.15.01.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 01:28:38 -0700 (PDT)
Subject: Re: [PATCH 12/14] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
To:     Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
 <20190928172323.14663-13-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <933ca564-973d-645e-fe9c-9afb64edba5b@redhat.com>
Date:   Tue, 15 Oct 2019 10:28:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190928172323.14663-13-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/09/19 19:23, Andrea Arcangeli wrote:
> Reducing this list to only EXIT_REASON_MSR_WRITE,
> EXIT_REASON_PREEMPTION_TIMER, EXIT_REASON_EPT_MISCONFIG,
> EXIT_REASON_IO_INSTRUCTION increases the computation time of the
> hrtimer guest testcase on Haswell i5-4670T CPU @ 2.30GHz by 7% with
> the default spectre v2 mitigation enabled in the host and guest. On
> skylake as opposed there's no measurable difference with the short
> list. To put things in prospective on Haswell the same hrtimer
> workload (note: it never calls cpuid and it never attempts to trigger
> more vmexit on purpose) in guest takes 16.3% longer to compute on
> upstream KVM running in the host than with the KVM mono v1 patchset
> applied to the host kernel, while on skylake the same takes only 5.4%
> more time (both with the default mitigations enabled in guest and
> host).
> 
> It's also unclear why EXIT_REASON_IO_INSTRUCTION should be included.

If you're including EXIT_REASON_EPT_MISCONFIG (MMIO access) then you
should include EXIT_REASON_IO_INSTRUCTION too.  Depending on the devices
that are in the guest, the doorbell register might be MMIO or PIO.

> +		if (exit_reason == EXIT_REASON_MSR_WRITE)
> +			return kvm_emulate_wrmsr(vcpu);
> +		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
> +			return handle_preemption_timer(vcpu);
> +		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
> +			return handle_interrupt_window(vcpu);
> +		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> +			return handle_external_interrupt(vcpu);
> +		else if (exit_reason == EXIT_REASON_HLT)
> +			return kvm_emulate_halt(vcpu);
> +		else if (exit_reason == EXIT_REASON_PAUSE_INSTRUCTION)
> +			return handle_pause(vcpu);
> +		else if (exit_reason == EXIT_REASON_MSR_READ)
> +			return kvm_emulate_rdmsr(vcpu);
> +		else if (exit_reason == EXIT_REASON_CPUID)
> +			return kvm_emulate_cpuid(vcpu);
> +		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
> +			return handle_ept_misconfig(vcpu);

So, the difference between my suggested list (which I admit is just
based on conjecture, not benchmarking) is that you add
EXIT_REASON_PAUSE_INSTRUCTION, EXIT_REASON_PENDING_INTERRUPT,
EXIT_REASON_EXTERNAL_INTERRUPT, EXIT_REASON_HLT, EXIT_REASON_MSR_READ,
EXIT_REASON_CPUID.

Which of these make a difference for the hrtimer testcase?  It's of
course totally fine to use benchmarks to prove that my intuition was
bad---but you must also use them to show why your intuition is right. :)

Paolo
