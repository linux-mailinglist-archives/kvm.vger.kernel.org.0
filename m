Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1234B50C5
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 16:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfIQOwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 10:52:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727315AbfIQOwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 10:52:37 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EDC593B46C
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 14:52:36 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id f23so1351377wmh.9
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 07:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/BRtmnJaTBcY1q7Q3sXH0JTFKywo+VFEF2e2gU6YlgA=;
        b=YXxWEn4t7Z8l8Ry4zfuIYQDc/cNbTVPd9uoxIM52AUMuEDAfWbGMWBBshXgvqQFqIR
         wVOLxY1L8Qn0lfnslXwrTy+ozq7e+ii5TX2QtufCj+w/QV8vmMcQhEHEdyUEJnsHRSjX
         8wBZ/mapMB5AHmXqEJ9cUvZIJVMzU4MRKSzrGmm4X/El5FVk+LL4dvKs3ch6itl1dFso
         UgeUlSD4uJ7ry9DkQqkMi4bpuZ4tlPl44+655hvjYyJL8m/uPkEjp4MxZv44UblWPsL5
         zhuPctRM9lGxbU0ECHsEBg4J21XFgHHa9dke0/DBfmStJ2Acn52xOWUOIgfnaQS+LB4Q
         Rpyg==
X-Gm-Message-State: APjAAAUaaEze14WWSQ0sWiluVUNkueBrcULwqntDRzEDsJfNLlwtXMGS
        Ysb9RdYfV37fIOaJlbRXK1sAbSGlScsOpui6cAdWFXjEOGlSJhX0ixtAKovvk4yMfKyG3s4VFo+
        tV8L+7r7fe/If
X-Received: by 2002:a1c:a74f:: with SMTP id q76mr4142631wme.16.1568731955581;
        Tue, 17 Sep 2019 07:52:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy1moraRCyDyItbCxs9M2x3+FNzu0aonVBdoRjgHQa0s+kSEhxXexpCwA5AllwUK/rr/yI/iQ==
X-Received: by 2002:a1c:a74f:: with SMTP id q76mr4142608wme.16.1568731955291;
        Tue, 17 Sep 2019 07:52:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id f17sm2822453wru.29.2019.09.17.07.52.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 07:52:34 -0700 (PDT)
Subject: Re: [PATCH] kvm-unit-test: nVMX: Fix 95d6d2c32288 ("nVMX: Test Host
 Segment Registers and Descriptor Tables on vmentry of nested guests")
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190812211108.17186-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <48ae03df-e06e-d1f2-ccb6-a618cc2e840a@redhat.com>
Date:   Tue, 17 Sep 2019 16:52:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812211108.17186-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/19 23:11, Krish Sadhukhan wrote:
> Commit 95d6d2c32288 added a test for the Segment Selector VMCS field. That test
> sets the "host address-space size" VM-exit control to zero and as a result, on
> VM-exit the guest exits as 32-bit. Since vmx tests are 64-bit, this results in
> a hardware error.
> This patch also cleans up a few other areas in commit 95d6d2c32288, including
> replacing make_non_canonical() with NONCANONICAL.
> 
> Reported-by: Nadav Amit <nadav.amit@gmail.com>
> Signed-off-by: Krish Sadhukhan <kris.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  lib/x86/processor.h |  5 ---
>  x86/vmx_tests.c     | 76 ++++++++++++++++++++-------------------------
>  2 files changed, 33 insertions(+), 48 deletions(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 8b8bb7a..4fef0bc 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -461,11 +461,6 @@ static inline void write_pkru(u32 pkru)
>          : : "a" (eax), "c" (ecx), "d" (edx));
>  }
>  
> -static inline u64 make_non_canonical(u64 addr)
> -{
> -	return (addr | 1ull << 48);
> -}
> -
>  static inline bool is_canonical(u64 addr)
>  {
>  	return (s64)(addr << 16) >> 16 == addr;
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 8ad2674..e115e48 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -6952,15 +6952,14 @@ static void test_load_host_pat(void)
>  }
>  
>  /*
> - * Test a value for the given VMCS field.
> - *
> - *  "field" - VMCS field
> - *  "field_name" - string name of VMCS field
> - *  "bit_start" - starting bit
> - *  "bit_end" - ending bit
> - *  "val" - value that the bit range must or must not contain
> - *  "valid_val" - whether value given in 'val' must be valid or not
> - *  "error" - expected VMCS error when vmentry fails for an invalid value
> + * test_vmcs_field - test a value for the given VMCS field
> + * @field: VMCS field
> + * @field_name: string name of VMCS field
> + * @bit_start: starting bit
> + * @bit_end: ending bit
> + * @val: value that the bit range must or must not contain
> + * @valid_val: whether value given in 'val' must be valid or not
> + * @error: expected VMCS error when vmentry fails for an invalid value
>   */
>  static void test_vmcs_field(u64 field, const char *field_name, u32 bit_start,
>  			    u32 bit_end, u64 val, bool valid_val, u32 error)
> @@ -7004,16 +7003,14 @@ static void test_vmcs_field(u64 field, const char *field_name, u32 bit_start,
>  static void test_canonical(u64 field, const char * field_name)
>  {
>  	u64 addr_saved = vmcs_read(field);
> -	u64 addr = addr_saved;
>  
> -	report_prefix_pushf("%s %lx", field_name, addr);
> -	if (is_canonical(addr)) {
> +	report_prefix_pushf("%s %lx", field_name, addr_saved);
> +	if (is_canonical(addr_saved)) {
>  		test_vmx_vmlaunch(0, false);
>  		report_prefix_pop();
>  
> -		addr = make_non_canonical(addr);
> -		vmcs_write(field, addr);
> -		report_prefix_pushf("%s %lx", field_name, addr);
> +		vmcs_write(field, NONCANONICAL);
> +		report_prefix_pushf("%s %llx", field_name, NONCANONICAL);
>  		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
>  				  false);
>  
> @@ -7025,6 +7022,14 @@ static void test_canonical(u64 field, const char * field_name)
>  	report_prefix_pop();
>  }
>  
> +#define TEST_RPL_TI_FLAGS(reg, name)				\
> +	test_vmcs_field(reg, name, 0, 2, 0x0, true,		\
> +			VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> +
> +#define TEST_CS_TR_FLAGS(reg, name)				\
> +	test_vmcs_field(reg, name, 3, 15, 0x0000, false,	\
> +			VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> +
>  /*
>   * 1. In the selector field for each of CS, SS, DS, ES, FS, GS and TR, the
>   *    RPL (bits 1:0) and the TI flag (bit 2) must be 0.
> @@ -7036,34 +7041,24 @@ static void test_canonical(u64 field, const char * field_name)
>   */
>  static void test_host_segment_regs(void)
>  {
> -	u32 exit_ctrl_saved = vmcs_read(EXI_CONTROLS);
>  	u16 selector_saved;
>  
>  	/*
>  	 * Test RPL and TI flags
>  	 */
> -	test_vmcs_field(HOST_SEL_CS, "HOST_SEL_CS", 0, 2, 0x0, true,
> -		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> -	test_vmcs_field(HOST_SEL_SS, "HOST_SEL_SS", 0, 2, 0x0, true,
> -		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> -	test_vmcs_field(HOST_SEL_DS, "HOST_SEL_DS", 0, 2, 0x0, true,
> -		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> -	test_vmcs_field(HOST_SEL_ES, "HOST_SEL_ES", 0, 2, 0x0, true,
> -		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> -	test_vmcs_field(HOST_SEL_FS, "HOST_SEL_FS", 0, 2, 0x0, true,
> -		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> -	test_vmcs_field(HOST_SEL_GS, "HOST_SEL_GS", 0, 2, 0x0, true,
> -		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> -	test_vmcs_field(HOST_SEL_TR, "HOST_SEL_TR", 0, 2, 0x0, true,
> -		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> +	TEST_RPL_TI_FLAGS(HOST_SEL_CS, "HOST_SEL_CS");
> +	TEST_RPL_TI_FLAGS(HOST_SEL_SS, "HOST_SEL_SS");
> +	TEST_RPL_TI_FLAGS(HOST_SEL_DS, "HOST_SEL_DS");
> +	TEST_RPL_TI_FLAGS(HOST_SEL_ES, "HOST_SEL_ES");
> +	TEST_RPL_TI_FLAGS(HOST_SEL_FS, "HOST_SEL_FS");
> +	TEST_RPL_TI_FLAGS(HOST_SEL_GS, "HOST_SEL_GS");
> +	TEST_RPL_TI_FLAGS(HOST_SEL_TR, "HOST_SEL_TR");
>  
>  	/*
>  	 * Test that CS and TR fields can not be 0x0000
>  	 */
> -	test_vmcs_field(HOST_SEL_CS, "HOST_SEL_CS", 3, 15, 0x0000, false,
> -			     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> -	test_vmcs_field(HOST_SEL_TR, "HOST_SEL_TR", 3, 15, 0x0000, false,
> -			     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> +	TEST_CS_TR_FLAGS(HOST_SEL_CS, "HOST_SEL_CS");
> +	TEST_CS_TR_FLAGS(HOST_SEL_TR, "HOST_SEL_TR");
>  
>  	/*
>  	 * SS field can not be 0x0000 if "host address-space size" VM-exit
> @@ -7071,20 +7066,15 @@ static void test_host_segment_regs(void)
>  	 */
>  	selector_saved = vmcs_read(HOST_SEL_SS);
>  	vmcs_write(HOST_SEL_SS, 0);
> -	if (exit_ctrl_saved & EXI_HOST_64) {
> -		report_prefix_pushf("HOST_SEL_SS 0");
> +	report_prefix_pushf("HOST_SEL_SS 0");
> +	if (vmcs_read(EXI_CONTROLS) & EXI_HOST_64) {
>  		test_vmx_vmlaunch(0, false);
> -		report_prefix_pop();
> -
> -		vmcs_write(EXI_CONTROLS, exit_ctrl_saved & ~EXI_HOST_64);
> +	} else {
> +		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD, false);
>  	}
> -
> -	report_prefix_pushf("HOST_SEL_SS 0");
> -	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD, false);
>  	report_prefix_pop();
>  
>  	vmcs_write(HOST_SEL_SS, selector_saved);
> -	vmcs_write(EXI_CONTROLS, exit_ctrl_saved);
>  
>  #ifdef __x86_64__
>  	/*
> 

Queued, thanks.

Paolo
