Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2A57AD528
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 10:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389558AbfIIIyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 04:54:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60798 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfIIIyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 04:54:23 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 81EC7769E1
        for <kvm@vger.kernel.org>; Mon,  9 Sep 2019 08:54:23 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id s5so7016165wrv.23
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 01:54:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RePJXkxFWsRm8ZBNxAsls0ibNpYmNrySaNHjogGCgcU=;
        b=GNL23g+3MBoENUyFmO19J8bGzG/IjZZVyiJ2JuBM2/JVVwoguVS9CMB2dasnm0S0bT
         YRp3Cni2K8EKtoCe+r0jqfMsFU795Kd+VQGPmlQoTCY9V6yfMv5bdqLmGAHVCDD2BWaq
         AVThBgHuFwtawFSX+Y2R4jfQrhT0ea1uTgmB0tzNTTCHaRhOTqjMqF+kjjxSwnOha66J
         xjY0Pn/SWSkcLABhXBRPv4MovOU6e0f+Vz2sx5RuyUR7GMnF7fKww4C1V/H1G0JpHtE/
         oTW9S3xCauY0TT+ttQtop1xx/wQA/7oAjRZbJwiiCr2amG1G9zNMDqMn01wsvF59rBey
         W0/A==
X-Gm-Message-State: APjAAAWB25bt8D+T4DZL1F/bJTkEkzVzFZV6nbOuhCqvFaqKvjQ/LVfE
        60dbcCJJJdjUiHT6jNK7PC6UseTBfoWfI4Gj23I6/PBqq5P4D436FIkLPeFL40yULbKTHtcqOnP
        MR0KJwX0RaMoM
X-Received: by 2002:a5d:6846:: with SMTP id o6mr12341999wrw.73.1568019262274;
        Mon, 09 Sep 2019 01:54:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwE7DCMLoxJqXLWyKN/mzVo5CUQwrL1UAIDVWPKe9ax1HilV5hrutX4SfcLPOnrhTyLexI6Dw==
X-Received: by 2002:a5d:6846:: with SMTP id o6mr12341977wrw.73.1568019261950;
        Mon, 09 Sep 2019 01:54:21 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o193sm16282043wme.39.2019.09.09.01.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 01:54:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Subject: Re: [Patch] KVM: SVM: Fix svm_xsaves_supported
In-Reply-To: <CALMp9eRbDAB0NF=WVjHJWJNPgsTfE_s+4CeGMkpJpXSGP9zOyg@mail.gmail.com>
References: <20190904001422.11809-1-aaronlewis@google.com> <87o900j98f.fsf@vitty.brq.redhat.com> <CALMp9eRbDAB0NF=WVjHJWJNPgsTfE_s+4CeGMkpJpXSGP9zOyg@mail.gmail.com>
Date:   Mon, 09 Sep 2019 10:54:20 +0200
Message-ID: <87sgp5g88z.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Wed, Sep 4, 2019 at 9:51 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
>> Currently, VMX code only supports writing '0' to MSR_IA32_XSS:
>>
>>         case MSR_IA32_XSS:
>>                 if (!vmx_xsaves_supported() ||
>>                     (!msr_info->host_initiated &&
>>                      !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
>>                        guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
>>                         return 1;
>>                 /*
>>                  * The only supported bit as of Skylake is bit 8, but
>>                  * it is not supported on KVM.
>>                  */
>>                 if (data != 0)
>>                         return 1;
>>
>>
>> we will probably need the same limitation for SVM, however, I'd vote for
>> creating separate kvm_x86_ops->set_xss() implementations.
>
> I hope separate implementations are unnecessary. The allowed IA32_XSS
> bits should be derivable from guest_cpuid_has() in a
> vendor-independent way. Otherwise, the CPU vendors have messed up. :-)
>
> At present, we use the MSR-load area to swap guest/host values of
> IA32_XSS on Intel (when the host and guest values differ), but it
> seems to me that IA32_XSS and %xcr0 should be swapped at the same
> time, in kvm_load_guest_xcr0/kvm_put_guest_xcr0. This potentially adds
> an additional L1 WRMSR VM-exit to every emulated VM-entry or VM-exit
> for nVMX, but since the host currently sets IA32_XSS to 0 and we only
> allow the guest to set IA32_XSS to 0, we can probably worry about this
> later.

Yea, I was suggesting to split implementations as a future proof but a
comment like "This ought to be 0 for now" would also do)

>
> I have to say, this is an awful lot of effort for an MSR that's never used!

Agreed :-)

-- 
Vitaly
