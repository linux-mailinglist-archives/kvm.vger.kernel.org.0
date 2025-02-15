Return-Path: <kvm+bounces-38209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0182EA3698B
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:12:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5830116B446
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 00:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B9A084A35;
	Sat, 15 Feb 2025 00:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h+rEuEUb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623554430
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578088; cv=none; b=f8rEL3Pfotf7ltFAZT7TPqskPRljUGVufauMei81MyXA2Codm2OdOvr/vWIROt/WIy1M+0ThWr/GxJNmu5zxuZSCyKhxlSuhf/fgEAKCvQXht2PJx+yKIX9tUSltm9SpXPIo4Bxwvaqnj9Y3+OJHaOjJ5gkZRzn0BZwsW39bbRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578088; c=relaxed/simple;
	bh=Fvdkd5oSUL8Sc4FxfhwLiEeosfdsIkh2xZkpznLTiKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lj07ALB0/OpQR+6Yx3gA3PDBic8ke+n1GbGEd2nWF3PH8uXjmy0k9pqwrPrv2DTshruNAyBSXQczJPF1zPVwkSyUpRBOYuiBRjBpNwbJposQWYN9KZJ5ynlpKBQ383rXlNRruOwwbdBGWwo5xFXNznx+gjA0IBSrBOFQKnAE9WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h+rEuEUb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739578085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dde8t2t0iRk/0B4RUYBxeInO7gUe801780SUKxb18V8=;
	b=h+rEuEUbgyTizKExOOZVqtfK3oMA725lAjctKhw7BlGNBgMgqP95OMVc5us4D16ktfceSl
	3cGKdXGtZeaiC98ZuQ6ZI1nKXzTGMmJtJd4z88vYJpIZE9wB/1YLQt+V73JXDq2w+njlJ6
	L+26hTSzHA/6x1PEjzKhk8/93a6WZRw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-4qXPWLWfMQy7QEcgRD5c6g-1; Fri, 14 Feb 2025 19:08:03 -0500
X-MC-Unique: 4qXPWLWfMQy7QEcgRD5c6g-1
X-Mimecast-MFC-AGG-ID: 4qXPWLWfMQy7QEcgRD5c6g_1739578082
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38f34b3f9f1so112891f8f.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:08:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739578082; x=1740182882;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dde8t2t0iRk/0B4RUYBxeInO7gUe801780SUKxb18V8=;
        b=pSGt0tRbfAVmWWh7eppiIDbd5DoLv+YSCudR1+fStHCAvKky2DzHzdCpXAXwWHj4WF
         Niw68IWzJSuJJ66SIehEh8YpaHOWN+h+7WncvBPvwxU70y5xOLUxrIS1CTLadOrceUGR
         vCHKoq25sO5qtxZT7Asj6dxjj5KfJUqzQemMfJRWg+3137bZD1cVrKGLmz4G1Ouu7vFO
         CfiifgwGtqIJhyacIqfcgDLHCoJoSAawRyff3TfPjvGjFO3DYfM62wcaL8K4R06wmWGh
         TNtY4UTQhByAF6/8yHNGcOty3x69LJOzell6IJdWtboUu3M/6nWtT/1mQNC+DWsgBoo/
         trsg==
X-Gm-Message-State: AOJu0YzT46Gjq04LEUDoxagKzmdqFNF7oaqjUxj3n2ZXEFXtK58w2ri0
	Y1QVrkZM/XifLVyn1Pw87F9l9MenZq8nzey37h/fdUITwtrQLvdI4hEFTWjf4oE7yqJRP7uHZCQ
	2rGwFJdBBJhiTANE+0nmoUWGLltg2KPbuWaR+6XgA67Bp7nZ4eg==
X-Gm-Gg: ASbGncvgL6Jrv41zLsifxH26p1+IBYhz1hWCBkqFnlarzMrG63HXhHGarfYF99WH81G
	WOma2uq0ODl9UP6SNZ+dVa2IsuXJSrZRv+b65MGwfP7OiFOAaW9utscAGUHyJYhtq6w/+rnzuKm
	M0vXsavEXsT5qkGleaAlp5eorsuFG2ntRoswJaYnuqsKhFCEphLb3dGFm9Haz8cW5hQ3vAmmK5L
	x8JTW/hIQ+PMukvkN8BT70zgPtJjLTEdupBZLSXYnd7KRq42wRlSWPgHRmbrBfuekbUPecjI65+
	c6m+Te/1tIg=
X-Received: by 2002:a5d:5850:0:b0:38f:31b6:4f30 with SMTP id ffacd0b85a97d-38f33f4a8c6mr1261803f8f.35.1739578082505;
        Fri, 14 Feb 2025 16:08:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHjg1xvjCQd4TrCjV6sMCBq5+kC10xDRLuwFyQIXZtPyJBIJeUWsXqQgGAKLPfsCZx/sYHMkw==
X-Received: by 2002:a5d:5850:0:b0:38f:31b6:4f30 with SMTP id ffacd0b85a97d-38f33f4a8c6mr1261774f8f.35.1739578082120;
        Fri, 14 Feb 2025 16:08:02 -0800 (PST)
Received: from [192.168.10.48] ([176.206.122.109])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38f259f85c2sm6050514f8f.91.2025.02.14.16.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 16:08:01 -0800 (PST)
Message-ID: <1db73488-4095-4ac1-ad10-139615981de2@redhat.com>
Date: Sat, 15 Feb 2025 01:08:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Load DR6 with guest value only before entering
 .vcpu_run() loop
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 John Stultz <jstultz@google.com>, Jim Mattson <jmattson@google.com>
References: <20250125011833.3644371-1-seanjc@google.com>
 <20250214234058.2074135-1-pbonzini@redhat.com> <Z6_ai1HdLWiTJ2Pf@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z6_ai1HdLWiTJ2Pf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/15/25 01:06, Sean Christopherson wrote:
> On Fri, Feb 14, 2025, Paolo Bonzini wrote:
>> Queued, thanks.
> 
> Drat, I was too slow today.  I applied and pushed this to "kvm-x86 fixes" and
> linux-next (as of yesterday), along with a few other things, I just haven't sent
> out the "thanks" yet (got sidetracked).
> 
> If you want to grab those, here's a semi-impromptu pull request.  Otherwise I'll
> just drop this particular commit.

I had "KVM: nSVM: Enter guest mode before initializing nested NPT MMU" 
on my list, but not the others.

I'll just pull these, thanks.

Paolo

> --
> 
> The following changes since commit a64dcfb451e254085a7daee5fe51bf22959d52d3:
> 
>    Linux 6.14-rc2 (2025-02-09 12:45:03 -0800)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.14-rcN
> 
> for you to fetch changes up to c2fee09fc167c74a64adb08656cb993ea475197e:
> 
>    KVM: x86: Load DR6 with guest value only before entering .vcpu_run() loop (2025-02-12 08:59:38 -0800)
> 
> ----------------------------------------------------------------
> KVM fixes for 6.14 part 1
> 
>   - Reject Hyper-V SEND_IPI hypercalls if the local APIC isn't being emulated
>     by KVM to fix a NULL pointer dereference.
> 
>   - Enter guest mode (L2) from KVM's perspective before initializing the vCPU's
>     nested NPT MMU so that the MMU is properly tagged for L2, not L1.
> 
>   - Load the guest's DR6 outside of the innermost .vcpu_run() loop, as the
>     guest's value may be stale if a VM-Exit is handled in the fastpath.
> 
> ----------------------------------------------------------------
> Sean Christopherson (6):
>        KVM: x86: Reject Hyper-V's SEND_IPI hypercalls if local APIC isn't in-kernel
>        KVM: selftests: Mark test_hv_cpuid_e2big() static in Hyper-V CPUID test
>        KVM: selftests: Manage CPUID array in Hyper-V CPUID test's core helper
>        KVM: selftests: Add CPUID tests for Hyper-V features that need in-kernel APIC
>        KVM: nSVM: Enter guest mode before initializing nested NPT MMU
>        KVM: x86: Load DR6 with guest value only before entering .vcpu_run() loop
> 
>   arch/x86/include/asm/kvm-x86-ops.h             |  1 +
>   arch/x86/include/asm/kvm_host.h                |  1 +
>   arch/x86/kvm/hyperv.c                          |  6 +++++-
>   arch/x86/kvm/mmu/mmu.c                         |  2 +-
>   arch/x86/kvm/svm/nested.c                      | 10 +++++-----
>   arch/x86/kvm/svm/svm.c                         | 13 ++++++-------
>   arch/x86/kvm/vmx/main.c                        |  1 +
>   arch/x86/kvm/vmx/vmx.c                         | 10 ++++++----
>   arch/x86/kvm/vmx/x86_ops.h                     |  1 +
>   arch/x86/kvm/x86.c                             |  3 +++
>   tools/testing/selftests/kvm/x86/hyperv_cpuid.c | 47 ++++++++++++++++++++++++++++++++---------------
>   11 files changed, 62 insertions(+), 33 deletions(-)
> 


