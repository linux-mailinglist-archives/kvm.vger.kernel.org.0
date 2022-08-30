Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9255A6D60
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiH3T3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiH3T3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:29:19 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37AD18F
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 12:29:17 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y29so8257961pfq.0
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 12:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=p+lkmBdpbq3WAh4jvVmTQBMTdKT2FnQcs7Xr9pvsI60=;
        b=akEYCxtSt9b3ZOoxTQ0B8rO6Fav+0KneyxKSMB7zNQyp66UA2h98ykKva6Mw6MWCOW
         /uloT2Kf97r6jH8vDwgCfzynh2aixFbidQ1mDwWsqcoh9xIrUNP7m3aevD6ajK1r0FfF
         H+v2rVN7V2JUnnSrZCByME6MrbdM4yZohTY1oEb02IqBKJ9IIbi3ZOVAHEB052+4jl1B
         PS1/SR2w4MibcmQQirJ5lXNzh7uEer5m3yK7sFuE22uSyFOL1yRo2/OObnZf9OmKgY+j
         Knq91Erbf8qIqYDZIeS0c119J6nQMdAB9ckhc8ngFWuKbOk6s3pWixAFZCVqD6YY5Q9H
         Au9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=p+lkmBdpbq3WAh4jvVmTQBMTdKT2FnQcs7Xr9pvsI60=;
        b=Fk17wG4jVl/f54Py9+TtRCTgABjLKT4u89MdzoZYvJSLGBjHL1WJQ/SIeQp9ijtzJn
         UlCRygpJTrwHaZWspsKTZ4ZqHI9sxMlEnoMXZiJoX2axd7IKRu9tSECAhFmHg6JTpU0q
         jCk/oj83UMLB/wuIWTiOQyYjpXIjsNZyNp3SsJM43R8Ity1ylPh5OhtzkUsCjgUIn4FU
         DKvZf/GO2BkJky+OzyGYVcZ5+cEo0rTFNKtsLLPv6Ed9G17sS05pzBF1nlYAkcAvU34w
         1TGZ1GxWoAdbM+nCcbzI/9ic+fyun/vhwZmsWnFz94u8xfIQo4wciwqfEhgUfv9eVLxw
         gkGA==
X-Gm-Message-State: ACgBeo2Y6ViFmTSw02CQD8ujt/hAWtwk9+ppIOyMZf104SlNelCz09zi
        ZdCmxC+FBBw+4gIzHlQxl0WOig==
X-Google-Smtp-Source: AA6agR7OoMeNnpkcsyUOySp9SJadQ8cuMnR9d1pAaLm8fRo7GWGTLR05tAwuzIc9NOUvGLV6NJ9rsw==
X-Received: by 2002:a05:6a00:4147:b0:52d:fe84:2614 with SMTP id bv7-20020a056a00414700b0052dfe842614mr23250897pfb.10.1661887757374;
        Tue, 30 Aug 2022 12:29:17 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id im23-20020a170902bb1700b00172bd84c8b4sm10053121plb.98.2022.08.30.12.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 12:29:16 -0700 (PDT)
Date:   Tue, 30 Aug 2022 19:29:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wonhyuk Yang <vvghjk1234@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Baik Song An <bsahn@etri.re.kr>,
        Hong Yeon Kim <kimhy@etri.re.kr>,
        Taeung Song <taeung@reallinux.co.kr>, linuxgeek@linuxgeek.io,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: Add extra information in kvm_page_fault trace point
Message-ID: <Yw5lCY5/SOmFGQrK@google.com>
References: <20220510071001.87169-1-vvghjk1234@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510071001.87169-1-vvghjk1234@gmail.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022, Wonhyuk Yang wrote:
> Currently, kvm_page_fault trace point provide fault_address and error
> code. However it is not enough to find which cpu and instruction
> cause kvm_page_faults. So add vcpu id and instruction pointer in
> kvm_page_fault trace point.
> 
> Cc: Baik Song An <bsahn@etri.re.kr>
> Cc: Hong Yeon Kim <kimhy@etri.re.kr>
> Cc: Taeung Song <taeung@reallinux.co.kr>
> Cc: linuxgeek@linuxgeek.io
> Signed-off-by: Wonhyuk Yang <vvghjk1234@gmail.com>
> ---

Patch is good, some tangentially related FYI comments below.

> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index e3a24b8f04be..78d20d392904 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -383,20 +383,26 @@ TRACE_EVENT(kvm_inj_exception,
>   * Tracepoint for page fault.
>   */
>  TRACE_EVENT(kvm_page_fault,
> -	TP_PROTO(unsigned long fault_address, unsigned int error_code),
> -	TP_ARGS(fault_address, error_code),
> +	TP_PROTO(struct kvm_vcpu *vcpu, unsigned long fault_address,
> +		 unsigned int error_code),
> +	TP_ARGS(vcpu, fault_address, error_code),
>  
>  	TP_STRUCT__entry(
> +		__field(	unsigned int,	vcpu_id		)
> +		__field(	unsigned long,	guest_rip	)
>  		__field(	unsigned long,	fault_address	)
>  		__field(	unsigned int,	error_code	)

This tracepoint is comically bad.  The address should be a u64 since GPAs can be
64 bits even on 32-bit hosts.  Ditto for error_code since #NPF has 64-bit error
codes.

>  	),
>  
>  	TP_fast_assign(
> +		__entry->vcpu_id	= vcpu->vcpu_id;
> +		__entry->guest_rip	= kvm_rip_read(vcpu);
>  		__entry->fault_address	= fault_address;
>  		__entry->error_code	= error_code;
>  	),
>  
> -	TP_printk("address %lx error_code %x",
> +	TP_printk("vcpu %u rip 0x%lx address 0x%lx error_code %x",

And here the error code needs a "0x" prefix, especially since the majority of error
codes end up being valid decimal values, e.g. 182, 184, 181.

I also think it makes sense to force "address" to pad to 16, but not the others.
Padding error_code is wasteful most of the time, and I actually like that user vs.
kernel addresses and up with different formatting as it makes it trivial to see
where the fault originated (when running "real" guests).

       CPU 5/KVM-4145    [002] .....    86.581928: kvm_page_fault: vcpu 5 rip 0x7f08a4602116 address 0x0000000113600002 error_code 0x181
       CPU 7/KVM-4150    [001] .....    86.581936: kvm_page_fault: vcpu 7 rip 0xffffffff81511f37 address 0x0000000113674000 error_code 0x182
       CPU 5/KVM-4145    [002] .....    86.582585: kvm_page_fault: vcpu 5 rip 0xffffffff81040f72 address 0x00000000fee000b0 error_code 0x182
       CPU 1/KVM-4136    [006] .....    86.588913: kvm_page_fault: vcpu 1 rip 0xffffffff81511ba7 address 0x0000000111400000 error_code 0x182
       CPU 6/KVM-4146    [001] .....    86.594913: kvm_page_fault: vcpu 6 rip 0xffffffff81040f72 address 0x00000000fee000b0 error_code 0x182
       CPU 5/KVM-4145    [002] .....    86.595872: kvm_page_fault: vcpu 5 rip 0x7f08a4602116 address 0x0000000113810002 error_code 0x181
       CPU 5/KVM-4145    [002] .....    86.603341: kvm_page_fault: vcpu 5 rip 0x7f08a4602116 address 0x0000000113a00002 error_code 0x181

All in all, what about me adding this on top?

---
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Aug 2022 12:26:24 -0700
Subject: [PATCH] KVM: x86: Use u64 for address and error code in page fault
 tracepoint

Track the address and error code as 64-bit values in the page fault
tracepoint.  When TDP is enabled, the address is a GPA and thus can be a
64-bit value even on 32-bit hosts.  And SVM's #NPF genereates 64-bit
error codes.

Opportunistically clean up the formatting.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/trace.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 331bdb0ae4b1..c369ebc7269c 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -394,15 +394,14 @@ TRACE_EVENT(kvm_inj_exception,
  * Tracepoint for page fault.
  */
 TRACE_EVENT(kvm_page_fault,
-	TP_PROTO(struct kvm_vcpu *vcpu, unsigned long fault_address,
-		 unsigned int error_code),
+	TP_PROTO(struct kvm_vcpu *vcpu, u64 fault_address, u64 error_code),
 	TP_ARGS(vcpu, fault_address, error_code),

 	TP_STRUCT__entry(
 		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned long,	guest_rip	)
-		__field(	unsigned long,	fault_address	)
-		__field(	unsigned int,	error_code	)
+		__field(	u64,		fault_address	)
+		__field(	u64,		error_code	)
 	),

 	TP_fast_assign(
@@ -412,7 +411,7 @@ TRACE_EVENT(kvm_page_fault,
 		__entry->error_code	= error_code;
 	),

-	TP_printk("vcpu %u rip 0x%lx address 0x%lx error_code %x",
+	TP_printk("vcpu %u rip 0x%lx address 0x%016llx error_code 0x%llx",
 		  __entry->vcpu_id, __entry->guest_rip,
 		  __entry->fault_address, __entry->error_code)
 );

base-commit: ca362851673d7c01c6624fff0f5a4ee192e6e56a
--

