Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F7B6A6893
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 09:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjCAIIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 03:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjCAIIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 03:08:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0189E37B42
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 00:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677658062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XBUzpVsNi8uXzY6Qbe5jnFNe77NJbiWn1Iof9PhYLk4=;
        b=MQKRt14QtuTGEqbT1vIuVt1zdiJrsMNLGzgJFyUcG2k+4obAPeKLvQQ7X57JKvPyflK76S
        Q5suwzRAS8+utO/jQ8Wum2qC4E0cAKerVzT/hiRuQjmBIIdxWP9yTqJsSZXBjYBC7OmbqO
        oy+9qICjqH90EP6GlNNwyRKF6GELWe4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-246-mgQqppi_PY6hNAWezDTzVw-1; Wed, 01 Mar 2023 03:07:39 -0500
X-MC-Unique: mgQqppi_PY6hNAWezDTzVw-1
Received: by mail-pf1-f199.google.com with SMTP id p36-20020a056a000a2400b005f72df7d97bso4530173pfh.19
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 00:07:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677658058;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XBUzpVsNi8uXzY6Qbe5jnFNe77NJbiWn1Iof9PhYLk4=;
        b=ASeic1GT66IMlWStdPgGwqQ2UE0GXcAA3m3/bjaM1jTMbEIaEK52CgWwWwIg6RIb4D
         E55/S8YiFyKEx/4lv2Wkg/OwDk6tTgwFksbIvQlj+WZJZlzVDpiAl+qzicFGNPafCMg4
         QuF7Ft5VtKNCr3nYrVx1L6iRrotLmRiX5LsMuDqLHbPR6llP/Clz82zas3vvw1GWZijV
         /vWC8P5YZPDirCwfQeNxGN8Xew8JYIsQzUvOZzwXg9BOJV8kKm9uRO41wF2K2VohLmgo
         s8PNj2GN857uvdGWFc2mSA7ePo63QO2vSbp29lrc192mhFkp+VUmVDvqCIn1Sc8XaWF0
         4ZQw==
X-Gm-Message-State: AO0yUKWldVz/aB8b78V796L6SQ1e1cBThZ96cAixXBMgl4ow5MBeGqw4
        QFz3PmyT144VGKtFCYWolmI2Ribi/eZoGu5y3fAespWiQ+/3b+s87luIWviLhKcWbFDYtzPVbq6
        hwt5BhC4YEgcq
X-Received: by 2002:a05:6a20:3d01:b0:cc:bf13:7b1c with SMTP id y1-20020a056a203d0100b000ccbf137b1cmr7215915pzi.0.1677658058090;
        Wed, 01 Mar 2023 00:07:38 -0800 (PST)
X-Google-Smtp-Source: AK7set+vX3NvGRhk/NweCuurkglXA2uikVFW05SMs9lJaPMRTaGXJzrBA6sfLJKX+WcrMpIJfuYOvA==
X-Received: by 2002:a05:6a20:3d01:b0:cc:bf13:7b1c with SMTP id y1-20020a056a203d0100b000ccbf137b1cmr7215898pzi.0.1677658057767;
        Wed, 01 Mar 2023 00:07:37 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s26-20020a63af5a000000b00502fdc69b97sm6724961pgo.67.2023.03.01.00.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 00:07:37 -0800 (PST)
Message-ID: <65a7d0da-2840-58c5-db19-3e3e94c6c59c@redhat.com>
Date:   Wed, 1 Mar 2023 16:07:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 7/8] KVM: selftests: Add string formatting options to
 ucall
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
References: <20230301053425.3880773-1-aaronlewis@google.com>
 <20230301053425.3880773-8-aaronlewis@google.com>
Content-Language: en-US
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301053425.3880773-8-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/1/23 13:34, Aaron Lewis wrote:
> Add more flexibility to guest debugging and testing by adding
> GUEST_PRINTF() and GUEST_ASSERT_FMT() to the ucall framework.
> 
> A buffer to hold the formatted string was added to the ucall struct.
> That allows the guest/host to avoid the problem of passing an
> arbitrary number of parameters between themselves when resolving the
> string.  Instead, the string is resolved in the guest then passed
> back to the host to be logged.
> 
> The formatted buffer is set to 1024 bytes which increases the size
> of the ucall struct.  As a result, this will increase the number of
> pages requested for the guest.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>   .../selftests/kvm/include/ucall_common.h      | 19 +++++++++++++++++++
>   .../testing/selftests/kvm/lib/ucall_common.c  | 19 +++++++++++++++++++
>   2 files changed, 38 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 0b1fde23729b..2a4400b6761a 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -13,15 +13,18 @@ enum {
>   	UCALL_NONE,
>   	UCALL_SYNC,
>   	UCALL_ABORT,
> +	UCALL_PRINTF,
>   	UCALL_DONE,
>   	UCALL_UNHANDLED,
>   };
>   
>   #define UCALL_MAX_ARGS 7
> +#define UCALL_BUFFER_LEN 1024
>   
>   struct ucall {
>   	uint64_t cmd;
>   	uint64_t args[UCALL_MAX_ARGS];
> +	char buffer[UCALL_BUFFER_LEN];
Hi Aaron,

A simple question, what if someone print too long in guest which exceed 
the UCALL_BUFFER_LEN, it seems buffer overflow will happen since 
vsprintf will not check the buffer length.

Just in case, someone may don't know the limit and print too long.

Thanks,
Shaoqin
>   
>   	/* Host virtual address of this struct. */
>   	struct ucall *hva;
> @@ -32,6 +35,7 @@ void ucall_arch_do_ucall(vm_vaddr_t uc);
>   void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
>   
>   void ucall(uint64_t cmd, int nargs, ...);
> +void ucall_fmt(uint64_t cmd, const char *fmt, ...);
>   uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
>   void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
>   int ucall_header_size(void);
> @@ -47,6 +51,7 @@ int ucall_header_size(void);
>   #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
>   				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
>   #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
> +#define GUEST_PRINTF(fmt, _args...) ucall_fmt(UCALL_PRINTF, fmt, ##_args)
>   #define GUEST_DONE()		ucall(UCALL_DONE, 0)
>   
>   enum guest_assert_builtin_args {
> @@ -56,6 +61,18 @@ enum guest_assert_builtin_args {
>   	GUEST_ASSERT_BUILTIN_NARGS
>   };
>   
> +#define __GUEST_ASSERT_FMT(_condition, _condstr, format, _args...)	\
> +do {									\
> +	if (!(_condition))						\
> +		ucall_fmt(UCALL_ABORT,					\
> +		          "Failed guest assert: " _condstr		\
> +		          " at %s:%ld\n  " format, 			\
> +			  __FILE__, __LINE__, ##_args);			\
> +} while (0)
> +
> +#define GUEST_ASSERT_FMT(_condition, format, _args...)	\
> +	__GUEST_ASSERT_FMT(_condition, #_condition, format, ##_args)
> +
>   #define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...)		\
>   do {									\
>   	if (!(_condition))						\
> @@ -81,6 +98,8 @@ do {									\
>   
>   #define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
>   
> +#define REPORT_GUEST_ASSERT_FMT(_ucall) TEST_FAIL("%s", _ucall.buffer)
> +
>   #define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)			\
>   	TEST_FAIL("%s at %s:%ld\n" fmt,					\
>   		  (const char *)(_ucall).args[GUEST_ERROR_STRING],	\
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index b6a75858fe0d..92ebc5db1c41 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -54,7 +54,9 @@ static struct ucall *ucall_alloc(void)
>   	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>   		if (!test_and_set_bit(i, ucall_pool->in_use)) {
>   			uc = &ucall_pool->ucalls[i];
> +			uc->cmd = UCALL_NONE;
>   			memset(uc->args, 0, sizeof(uc->args));
> +			memset(uc->buffer, 0, sizeof(uc->buffer));
>   			return uc;
>   		}
>   	}
> @@ -75,6 +77,23 @@ static void ucall_free(struct ucall *uc)
>   	clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
>   }
>   
> +void ucall_fmt(uint64_t cmd, const char *fmt, ...)
> +{
> +	struct ucall *uc;
> +	va_list va;
> +
> +	uc = ucall_alloc();
> +	uc->cmd = cmd;
> +
> +	va_start(va, fmt);
> +	vsprintf(uc->buffer, fmt, va);
> +	va_end(va);
> +
> +	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
> +
> +	ucall_free(uc);
> +}
> +
>   void ucall(uint64_t cmd, int nargs, ...)
>   {
>   	struct ucall *uc;

