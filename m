Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEB6413961
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 20:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhIUSBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 14:01:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49530 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232101AbhIUSBf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 14:01:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632247206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7JfYcZW2NbckggyMTPgWKycE7DRVJIAvYonCutHYoos=;
        b=QibDx4taHQKt5Yq5k2qILpdNAHAvXNK0fV1k+mB0l3OYIHx5uTz8E/OzCt+KRaxdlJxOvA
        D9hytIJB6hl8YyDLVoqAT1UsKAFLky5Rh3nnn3WhOvghseu5m2Id+tF6S+hvLndXeudE5h
        3jhcuvIGSeTe9LXGAwojnC9PTQrcRng=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-8AqWeryFNb6wvhI5taQK3Q-1; Tue, 21 Sep 2021 14:00:05 -0400
X-MC-Unique: 8AqWeryFNb6wvhI5taQK3Q-1
Received: by mail-wr1-f69.google.com with SMTP id r7-20020a5d6947000000b0015e0f68a63bso9548513wrw.22
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 11:00:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7JfYcZW2NbckggyMTPgWKycE7DRVJIAvYonCutHYoos=;
        b=ZJJbdSZK24jf2BjzO7V4K9gNoy/bsPuEIPQ8lvwN9udyLm2AU84UAA3L+xgK8GG0Dc
         LTD6DhQ8vf8B7+EpmmQHoFCXZzcpp7QXeit3JIfbJS6tRKKeL7wQnS5STGwXOqXjAtkg
         awtspeDdG2eWbFfB3L9lHrbbUe7e6X50gRsGwRfLx0mxCwsV4+04VI+tmW9KaKUG7cg9
         sKn/OCFaUoQv3/EIZzNH6kLNdA7TYKY/t4fvoxDKbuZMQwM9n3stYP1OlL2DuyMwpddT
         waDZvbRZ7qvWKj1E0zouy3AUjKJKm9yLVGzw5UtRmIGrfUN5PsHNYp+eXXtTstVLFEBH
         37vw==
X-Gm-Message-State: AOAM530ZMKEZmCOTTE9iy6ps8INY5S2PrnSGibfa8ijMm6FbR++9OpYS
        hFjqclKB97qbZM9fPGk6Ldtf45VJ6WFMH9ZP575SQcP6KSnp+tudeA95pJbbNtJAoIuTUiAHKWs
        1hqnkzjPvw5Zk
X-Received: by 2002:a5d:64a7:: with SMTP id m7mr36596958wrp.171.1632247204355;
        Tue, 21 Sep 2021 11:00:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRzE0XDhDN+YzVRHql1Lso3OsD+/0fE4vZgdDKs5KMBqTMa32DRdaFtYAvn1nk3N1rLTZCjQ==
X-Received: by 2002:a5d:64a7:: with SMTP id m7mr36596927wrp.171.1632247204162;
        Tue, 21 Sep 2021 11:00:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g131sm3526365wme.22.2021.09.21.11.00.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 11:00:03 -0700 (PDT)
Subject: Re: [PATCH] selftests: KVM: Gracefully handle missing vCPU features
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210818212940.1382549-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bd8abbac-925b-ff1e-f494-8f1c21fe7bd1@redhat.com>
Date:   Tue, 21 Sep 2021 20:00:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210818212940.1382549-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/08/21 23:29, Oliver Upton wrote:
> An error of ENOENT for the KVM_ARM_VCPU_INIT ioctl indicates that one of
> the requested feature flags is not supported by the kernel/hardware.
> Detect the case when KVM doesn't support the requested features and skip
> the test rather than failing it.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
> Applies to 5.14-rc6. Tested by running all selftests on an Ampere Mt.
> Jade system.
> 
>   .../testing/selftests/kvm/lib/aarch64/processor.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 632b74d6b3ca..b1064a0c5e62 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -216,6 +216,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>   {
>   	struct kvm_vcpu_init default_init = { .target = -1, };
>   	uint64_t sctlr_el1, tcr_el1;
> +	int ret;
>   
>   	if (!init)
>   		init = &default_init;
> @@ -226,7 +227,19 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>   		init->target = preferred.target;
>   	}
>   
> -	vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
> +	ret = _vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
> +
> +	/*
> +	 * Missing kernel feature support should result in skipping the test,
> +	 * not failing it.
> +	 */
> +	if (ret && errno == ENOENT) {
> +		print_skip("requested vCPU features not supported; skipping test.");
> +		exit(KSFT_SKIP);
> +	}
> +
> +	TEST_ASSERT(!ret, "KVM_ARM_VCPU_INIT failed, rc: %i errno: %i (%s)",
> +		    ret, errno, strerror(errno));
>   
>   	/*
>   	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
> 

Queued, thanks.

Paolo

