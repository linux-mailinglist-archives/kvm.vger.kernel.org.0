Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5281E381DC2
	for <lists+kvm@lfdr.de>; Sun, 16 May 2021 11:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhEPJwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 May 2021 05:52:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230233AbhEPJwP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 16 May 2021 05:52:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621158660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oRO/yJaNjM6VZvBpBMjV2hPGrzuDge/66QAkCSH3I5s=;
        b=i/fzqz5SlktnNb6/UBe6M3ZnUepgXhShAdW0mn1w6hrmSlvM4+n38EfrEpXtiu7qYZ5d18
        ok14JJ6qCJOj23sOos4xqIGZX4+lyQNG2KgLMabTayJYOBN/lUAXZNjEhwYANQXEnuOpII
        lkGWJwP1DFEGlSnF1MbbRTUoI3JbasM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-k_zAiPHOPuGDguKcyaQ_OA-1; Sun, 16 May 2021 05:50:57 -0400
X-MC-Unique: k_zAiPHOPuGDguKcyaQ_OA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46B99100747C;
        Sun, 16 May 2021 09:50:56 +0000 (UTC)
Received: from [10.36.112.87] (ovpn-112-87.ams2.redhat.com [10.36.112.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 75ADC6EF48;
        Sun, 16 May 2021 09:50:54 +0000 (UTC)
Subject: Re: [PATCH v3 3/5] KVM: selftests: Move GUEST_ASSERT_EQ to utils
 header
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
References: <20210513002802.3671838-1-ricarkol@google.com>
 <20210513002802.3671838-4-ricarkol@google.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b8e63f39-9545-4a43-362f-75e0489ae715@redhat.com>
Date:   Sun, 16 May 2021 11:50:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210513002802.3671838-4-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 5/13/21 2:28 AM, Ricardo Koller wrote:
> Move GUEST_ASSERT_EQ to a common header, kvm_util.h, for other
> architectures and tests to use. Also modify __GUEST_ASSERT so it can be
> reused to implement GUEST_ASSERT_EQ.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 22 ++++++++++---------
>  .../selftests/kvm/x86_64/tsc_msrs_test.c      |  9 --------
>  2 files changed, 12 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 7880929ea548..fb2b8964f2ca 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -366,26 +366,28 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
>  				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
>  #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
>  #define GUEST_DONE()		ucall(UCALL_DONE, 0)
> -#define __GUEST_ASSERT(_condition, _nargs, _args...) do {	\
> -	if (!(_condition))					\
> -		ucall(UCALL_ABORT, 2 + _nargs,			\
> -			"Failed guest assert: "			\
> -			#_condition, __LINE__, _args);		\
> +#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {    \
> +	if (!(_condition))                                              \
> +		ucall(UCALL_ABORT, 2 + _nargs,                          \
> +			"Failed guest assert: "                         \
> +			_condstr, __LINE__, _args);                     \
>  } while (0)
>  
>  #define GUEST_ASSERT(_condition) \
> -	__GUEST_ASSERT((_condition), 0, 0)
> +	__GUEST_ASSERT(_condition, #_condition, 0, 0)
>  
>  #define GUEST_ASSERT_1(_condition, arg1) \
> -	__GUEST_ASSERT((_condition), 1, (arg1))
> +	__GUEST_ASSERT(_condition, #_condition, 1, (arg1))
>  
>  #define GUEST_ASSERT_2(_condition, arg1, arg2) \
> -	__GUEST_ASSERT((_condition), 2, (arg1), (arg2))
> +	__GUEST_ASSERT(_condition, #_condition, 2, (arg1), (arg2))
>  
>  #define GUEST_ASSERT_3(_condition, arg1, arg2, arg3) \
> -	__GUEST_ASSERT((_condition), 3, (arg1), (arg2), (arg3))
> +	__GUEST_ASSERT(_condition, #_condition, 3, (arg1), (arg2), (arg3))
>  
>  #define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
> -	__GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
> +	__GUEST_ASSERT(_condition, #_condition, 4, (arg1), (arg2), (arg3), (arg4))
> +
> +#define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
>  
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
> index e357d8e222d4..5a6a662f2e59 100644
> --- a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
> @@ -18,15 +18,6 @@
>  #define rounded_rdmsr(x)       ROUND(rdmsr(x))
>  #define rounded_host_rdmsr(x)  ROUND(vcpu_get_msr(vm, 0, x))
>  
> -#define GUEST_ASSERT_EQ(a, b) do {				\
> -	__typeof(a) _a = (a);					\
> -	__typeof(b) _b = (b);					\
> -	if (_a != _b)						\
> -                ucall(UCALL_ABORT, 4,				\
> -                        "Failed guest assert: "			\
> -                        #a " == " #b, __LINE__, _a, _b);	\
> -  } while(0)
> -
>  static void guest_code(void)
>  {
>  	u64 val = 0;
> 

