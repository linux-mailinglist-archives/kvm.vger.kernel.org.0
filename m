Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D783519F9
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbhDAR5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:57:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235716AbhDARxW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86yUsgQjiqkoygVn0PivbCanpSWHlnKkBTF8/03d7ag=;
        b=bhWHhzEh92iDHf7xKSyeuvqO6lmUJZT6+idwQGg+bcOAx859geOyxP6cqfat+2CmuNlW19
        sHQNVMtEKxJ0V9P0Zl3p+4lG6Z9RlqSWdY+CFpljeqBPAxTgFvDE8oElfiwIVeyB6L0Vyo
        5GpuikO8GbGOSDzgz2AfZFaOjcA8L3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-eA3kwBiuNSm9oH95AoFUYg-1; Thu, 01 Apr 2021 07:20:34 -0400
X-MC-Unique: eA3kwBiuNSm9oH95AoFUYg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED2F0800D53;
        Thu,  1 Apr 2021 11:20:32 +0000 (UTC)
Received: from starship (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF65A6F44D;
        Thu,  1 Apr 2021 11:20:29 +0000 (UTC)
Message-ID: <526d400a09fea6037e9903c67fc4eaec18c04d24.camel@redhat.com>
Subject: Re: [PATCH 0/2] KVM: x86: nSVM: fixes for SYSENTER emulation
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>
Date:   Thu, 01 Apr 2021 14:20:28 +0300
In-Reply-To: <20210401111614.996018-1-mlevitsk@redhat.com>
References: <20210401111614.996018-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-04-01 at 14:16 +0300, Maxim Levitsky wrote:
> This is a result of a deep rabbit hole dive in regard to why
> currently the nested migration of 32 bit guests
> is totally broken on AMD.

Please ignore this patch series, I didn't update the patch version.

Best regards,
	Maxim Levitsky

> 
> It turns out that due to slight differences between the original AMD64
> implementation and the Intel's remake, SYSENTER instruction behaves a
> bit differently on Intel, and to support migration from Intel to AMD we
> try to emulate those differences away.
> 
> Sadly that collides with virtual vmload/vmsave feature that is used in nesting.
> The problem was that when it is enabled,
> on migration (and otherwise when userspace reads MSR_IA32_SYSENTER_{EIP|ESP},
> wrong value were returned, which leads to #DF in the
> nested guest when the wrong value is loaded back.
> 
> The patch I prepared carefully fixes this, by mostly disabling that
> SYSCALL emulation when we don't spoof the Intel's vendor ID, and if we do,
> and yet somehow SVM is enabled (this is a very rare edge case), then
> virtual vmload/save is force disabled.
> 
> V2: incorporated review feedback from Paulo.
> 
> Best regards,
>         Maxim Levitsky
> 
> Maxim Levitsky (2):
>   KVM: x86: add guest_cpuid_is_intel
>   KVM: nSVM: improve SYSENTER emulation on AMD
> 
>  arch/x86/kvm/cpuid.h   |  8 ++++
>  arch/x86/kvm/svm/svm.c | 99 +++++++++++++++++++++++++++---------------
>  arch/x86/kvm/svm/svm.h |  6 +--
>  3 files changed, 76 insertions(+), 37 deletions(-)
> 
> -- 
> 2.26.2
> 


