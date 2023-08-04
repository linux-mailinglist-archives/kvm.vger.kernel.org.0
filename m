Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4297E76FE53
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 12:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjHDKVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 06:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjHDKVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 06:21:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5CF49E8
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 03:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691144410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BaAHPDkMWVyDrPlFBExy3HKgmKCp7GlqON/y4nvUJKg=;
        b=ScNsy0TfwcroX6qR+c23D2GgCyu2r4kr6/VeCPXj1Ls9Mt4HM/NTZue+7uVlNVX49ZLmzh
        tbtqjLlaxakSBzZB0GvVubzVtbWYptZ3CGb4R7QvSSHtzBijTobsmYcEBcDSJGIucvAjR1
        Q/vC+CuY9+lkgjscP6e2USM1CNcRRVo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-huXKhTkjP8e6kSQHmJsgZg-1; Fri, 04 Aug 2023 06:20:08 -0400
X-MC-Unique: huXKhTkjP8e6kSQHmJsgZg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-993d7ca4607so124957466b.1
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 03:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691144407; x=1691749207;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BaAHPDkMWVyDrPlFBExy3HKgmKCp7GlqON/y4nvUJKg=;
        b=EHOCXg7/UPp/yd65uEDbkl6N9aTk3HXZQJrp9Y8xw3DDlV+XVFAM0Piev1jFxoU4ZC
         vtxAeZ8enJEg4wkGS7pq3+QU2EOP+GcTnhq6scE0Dfgb8m0jgkmUOQTTotSmboyPpbxw
         SvME2sapoFJZn9AJWH2Pl6/PFEt0tcPHX0TcWgSfWXz2bn6TladFYUWteGLezgMGLeI4
         qXqh8hOnP4ohJ4FeTmog3/Wcp141+LpGQc1agfFmKjw6zf4vFB1jkhj1yqzyTJgcA4Ib
         cl16TygGWwF/FNYticMjmSfiYcPbfkymFmWuLPtvyoskPkIWunfmgUc9OwZQNg+EcQXX
         +9Bw==
X-Gm-Message-State: AOJu0YyMz91m+5xSZYIoeHYhPmgBOkTMBTA+fkLPsm5WL5LP+X8xLke7
        mMwoEO+hFelEkiWeOTcLm5T4fDXMGn3NI7A0YOmDufVd3SzDQTpe3vGSu+0FmkYdSyQ7Siu0KJj
        b+tR3zJhk/lNF
X-Received: by 2002:a17:907:a0c7:b0:991:b554:e64b with SMTP id hw7-20020a170907a0c700b00991b554e64bmr65056ejc.54.1691144407674;
        Fri, 04 Aug 2023 03:20:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHxG8wHc720Toq9k3coxyOoldMDy42N/zemkEPpaF0ZqtDk4gC7/dA9YMswnkQZThr80tLofQ==
X-Received: by 2002:a17:907:a0c7:b0:991:b554:e64b with SMTP id hw7-20020a170907a0c700b00991b554e64bmr65043ejc.54.1691144407357;
        Fri, 04 Aug 2023 03:20:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id bh6-20020a170906a0c600b00997c1d125fasm1094920ejb.170.2023.08.04.03.20.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 03:20:06 -0700 (PDT)
Message-ID: <7c2f6fa3-23ba-6df5-24d9-28f95f866574@redhat.com>
Date:   Fri, 4 Aug 2023 12:20:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Nikunj A Dadhania <nikunj@amd.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
References: <20230802091107.1160320-1-nikunj@amd.com>
 <20230803120637.GD214207@hirez.programming.kicks-ass.net>
 <b22761ea-cab6-0e11-cdc9-ec26c300cd3f@redhat.com>
 <20230803190728.GJ212435@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for
 kvm-amd.o
In-Reply-To: <20230803190728.GJ212435@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/23 21:07, Peter Zijlstra wrote:
>> The only weird thing that can happen is ud2 instructions that are executed
>> in case the vmload/vmrun/vmsave instructions causes a #GP, from the
>> exception handler.
> 
> This code is ran with GIF disabled, so NMIs are not in the books, right?

Yep.

> Does GIF block #MC ?

No, #MC is an exception not an interrupt.

>> So if frame pointer unwinding can be used in the absence of ORC, Nikunj
>> patch should not break anything.
>
> But framepointer unwinds rely on BP, and that is clobbered per the
> objtool complaint.

It's not clobbered in a part that will cause unwinding; we can further
restrict the part to a handful of instructions (and add a mov %rsp, %rbp
at the top, see untested patch after signature).

I think the chance of this failure is similar or lower to the chance of
a memory failure that hits the exception handler code itself.

Paolo

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 8e8295e774f0..58fab5e0f7ae 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -99,6 +99,8 @@
   */
  SYM_FUNC_START(__svm_vcpu_run)
  	push %_ASM_BP
+	mov %_ASM_SP, %_ASM_BP
+
  #ifdef CONFIG_X86_64
  	push %r15
  	push %r14
@@ -121,7 +123,8 @@ SYM_FUNC_START(__svm_vcpu_run)
  	/* Needed to restore access to percpu variables.  */
  	__ASM_SIZE(push) PER_CPU_VAR(svm_data + SD_save_area_pa)
  
-	/* Finally save @svm. */
+	/* Finally save frame pointer and @svm. */
+	push %_ASM_BP
  	push %_ASM_ARG1
  
  .ifnc _ASM_ARG1, _ASM_DI
@@ -153,7 +156,6 @@ SYM_FUNC_START(__svm_vcpu_run)
  	mov VCPU_RCX(%_ASM_DI), %_ASM_CX
  	mov VCPU_RDX(%_ASM_DI), %_ASM_DX
  	mov VCPU_RBX(%_ASM_DI), %_ASM_BX
-	mov VCPU_RBP(%_ASM_DI), %_ASM_BP
  	mov VCPU_RSI(%_ASM_DI), %_ASM_SI
  #ifdef CONFIG_X86_64
  	mov VCPU_R8 (%_ASM_DI),  %r8
@@ -165,6 +167,7 @@ SYM_FUNC_START(__svm_vcpu_run)
  	mov VCPU_R14(%_ASM_DI), %r14
  	mov VCPU_R15(%_ASM_DI), %r15
  #endif
+	mov VCPU_RBP(%_ASM_DI), %_ASM_BP
  	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
  
  	/* Enter guest mode */
@@ -177,11 +180,15 @@ SYM_FUNC_START(__svm_vcpu_run)
  	/* Pop @svm to RAX while it's the only available register. */
  	pop %_ASM_AX
  
-	/* Save all guest registers.  */
+	/*
+	 * Save all guest registers. Pop the frame pointer as soon as possible
+	 * to enable unwinding.
+	 */
+	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
+	pop %_ASM_BP
  	mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
  	mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
  	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
-	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
  	mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
  	mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
  #ifdef CONFIG_X86_64
@@ -297,6 +304,7 @@ SYM_FUNC_END(__svm_vcpu_run)
   */
  SYM_FUNC_START(__svm_sev_es_vcpu_run)
  	push %_ASM_BP
+	mov %_ASM_SP, %_ASM_BP
  #ifdef CONFIG_X86_64
  	push %r15
  	push %r14
@@ -316,7 +324,8 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
  	/* Accessed directly from the stack in RESTORE_HOST_SPEC_CTRL.  */
  	push %_ASM_ARG2
  
-	/* Save @svm. */
+	/* Save frame pointer and @svm. */
+	push %_ASM_BP
  	push %_ASM_ARG1
  
  .ifnc _ASM_ARG1, _ASM_DI
@@ -341,8 +350,12 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
  
  2:	cli
  
-	/* Pop @svm to RDI, guest registers have been saved already. */
+	/*
+	 * Guest registers have been saved already.
+	 * Pop @svm to RDI and restore the frame pointer to allow unwinding.
+	 */
  	pop %_ASM_DI
+	pop %_ASM_BP
  
  #ifdef CONFIG_RETPOLINE
  	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */

