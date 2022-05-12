Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53B9524E25
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 15:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354338AbiELNXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 09:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354330AbiELNXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 09:23:13 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729F73ED02;
        Thu, 12 May 2022 06:23:11 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id j6so10170269ejc.13;
        Thu, 12 May 2022 06:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e9ocOaHM7NzC9WL8c37Nt0EVrS6kz1Qeth3UE0DXESU=;
        b=fCjsNIdwutruyyknbrtXf0lmf900l6JTWX2V/5XTllWIugjWaY4PWv3tC1Py4im6ms
         ItAtTrsENesp/D6fXRLQ2/Garq2KIEx/iY7+zxUeKpipA7dEaKE8w7ulHxeJzqoHWeli
         LvLRtLYZD7bYJHeFotoBU7izdKP2hZToYP6DfqLdCJ9Xtyhdmg9hzr4UYRlDpj5E5gQc
         moDAIrGebiNQkC6GJiJFEvqcPiQgt1fykvRj8luVYIttOqT5obUjrJUqTSJYzncWrXY2
         08+F7hMSEvU1/mctyk5wOZNIhms7KvEspxgtvBUAr/iOnhheEGzAzP+CePOIB0hezDuR
         K/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e9ocOaHM7NzC9WL8c37Nt0EVrS6kz1Qeth3UE0DXESU=;
        b=BWWfKeHTZ81TCdsQjtSQ3IGz6C7JV6yaMxz05hw5eF69OxM9p69J3rgk0sT0Ot6SCc
         nJp0KoeIISvueweiAMZ7tj776P72nS4HHySiRxiPZaMN9MyX4HjDvt3E4E5Wo0zuOTNV
         QUOpBA+X9IP+VLleMuZn/UKhCXS+klOw4lQ5lGzyFBekxBeudpaOoqFVK1Oix7JFY1XO
         x7nFZVT53IcwJLEt9+HdGiKDCohD2ZvQ1K8mcC0R/E40KU62oaOZDRo97R4dEFVBR31u
         wz89+cNTNoVBpPY2Pm1+15avNUHLrFEE18ks5IbdNKvYfSzzT1QeHibwnU2oeBPYBk6J
         VRSg==
X-Gm-Message-State: AOAM532hx+Ho83CEJKxdjLsnypJkI93RULhmORDdICg5JLhU/uMiDIu+
        gLoEGLg30Odhvp+a8L3ROs4=
X-Google-Smtp-Source: ABdhPJwzpQ/WRKfZDWnhC8Gde7XZvuWi85xslBncrqbc/NjkAjzkbyTJM/KYcNQ6EgMHjesG51di3Q==
X-Received: by 2002:a17:907:728d:b0:6f4:5a83:a616 with SMTP id dt13-20020a170907728d00b006f45a83a616mr30074958ejc.297.1652361790027;
        Thu, 12 May 2022 06:23:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id rq13-20020a17090788cd00b006f3ef214e66sm1892550ejc.204.2022.05.12.06.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 06:23:09 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <347c00f0-c1b0-55fc-5a1c-53b44f018abd@redhat.com>
Date:   Thu, 12 May 2022 15:23:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2] KVM: selftests: x86: Fix test failure on arch lbr
 capable platforms
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, likexu@tencent.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220512084046.105479-1-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220512084046.105479-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/12/22 10:40, Yang Weijiang wrote:
> On Arch LBR capable platforms, LBR_FMT in perf capability msr is 0x3f,
> so the last format test will fail. Use a true invalid format(0x30) for
> the test if it's running on these platforms. Opportunistically change
> the file name to reflect the tests actually carried out.
> 
> v2:
> Select a true invalid format instead of skipping the test on arch lbr
> capable platforms.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   tools/testing/selftests/kvm/Makefile           |  2 +-
>   ...vmx_pmu_msrs_test.c => vmx_pmu_caps_test.c} | 18 ++++++++++--------
>   2 files changed, 11 insertions(+), 9 deletions(-)
>   rename tools/testing/selftests/kvm/x86_64/{vmx_pmu_msrs_test.c => vmx_pmu_caps_test.c} (83%)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 681b173aa87c..9a1a84803b01 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -81,7 +81,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
>   TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
>   TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
>   TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
> -TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_msrs_test
> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
>   TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
>   TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
>   TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> similarity index 83%
> rename from tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
> rename to tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> index 2454a1f2ca0c..97b7fd4a9a3d 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> @@ -1,15 +1,14 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - * VMX-pmu related msrs test
> + * Test for VMX-pmu perf capability msr
>    *
>    * Copyright (C) 2021 Intel Corporation
>    *
> - * Test to check the effect of various CPUID settings
> - * on the MSR_IA32_PERF_CAPABILITIES MSR, and check that
> - * whatever we write with KVM_SET_MSR is _not_ modified
> - * in the guest and test it can be retrieved with KVM_GET_MSR.
> - *
> - * Test to check that invalid LBR formats are rejected.
> + * Test to check the effect of various CPUID settings on
> + * MSR_IA32_PERF_CAPABILITIES MSR, and check that what
> + * we write with KVM_SET_MSR is _not_ modified by the guest
> + * and check it can be retrieved with KVM_GET_MSR, also test
> + * the invalid LBR formats are rejected.
>    */
>   
>   #define _GNU_SOURCE /* for program_invocation_short_name */
> @@ -107,8 +106,11 @@ int main(int argc, char *argv[])
>   	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), (u64)host_cap.lbr_format);
>   
>   	/* testcase 3, check invalid LBR format is rejected */
> -	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
> +	/* Note, on Arch LBR capable platforms, LBR_FMT in perf capability msr is 0x3f,
> +	 * to avoid the failure, use a true invalid format 0x30 for the test. */
> +	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, 0x30);
>   	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
>   
> +	printf("Completed perf capability tests.\n");
>   	kvm_vm_free(vm);
>   }
> 
> base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a

Applied, thanks.

Paolo
