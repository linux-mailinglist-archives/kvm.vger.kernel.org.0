Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DBF777A50
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 16:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbjHJOTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 10:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbjHJOTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 10:19:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C974120
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 07:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691677108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QV3kzAdfq67rkXfk0U1UD+5I2KtPvhdGYoE+7E14Z2o=;
        b=byMLbuaJGaBaXNenQQj5hQTTQTFppWQu3AciK81le1CrewLLRhNM9vxRvJzR+g4dXtF1f2
        KGCgprV1rei5b1sAMAfR4JbdiEg9XxnLLZzYjNyTKeG/0OgQ7R7Wn9dyzbN86OjlWKOukW
        fMpy2Ef9f0XHkz/NKwS6KPeDLL34aTw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-dEGBridTM0yLxdlQvSP5Qg-1; Thu, 10 Aug 2023 10:18:02 -0400
X-MC-Unique: dEGBridTM0yLxdlQvSP5Qg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-31955c0e2adso90616f8f.2
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 07:17:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691677064; x=1692281864;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QV3kzAdfq67rkXfk0U1UD+5I2KtPvhdGYoE+7E14Z2o=;
        b=jQXganlXF/iosV6SDWpsr29CbR6kHTo4S+eEmC++9VUPVL+bGR1op9ffEKhxuX6YB+
         7Zry+i4qTeBgfWY+p4dEu1hFnWUGMAcxy6H1CvHvqgvdDCc2TEFC7eAz9ubeMB9liNyU
         HecfNjTTYFdtuJbV5lBVChdKsMu34AAN9NpRyl4gFfSHty6wIau1k67OyiipSmbcRB7B
         OPH1WEnDJ+AgNxHuvduPnEbU8p/89GVu45Z5q+RA6HFFCgKtlhp/n/iBvRmnwbcM/pm4
         dq7N1qqkGUM+qNiXykzKiPffcMqFU/gSpEnB1ply8vs+eCwOWCgx5OaYrGT2EkBK8a8x
         QaJg==
X-Gm-Message-State: AOJu0YwTQYAH5/OuPe4myOG4XAEP/Q105pkYD0h0AUR/WdMX9sOSgb05
        dL9zE4DjWTRvq4XVh+dXbPqFIDtOxw0/UVaOssU9OTbRq3pCsRPzF3ltcTShgZsSlwt0nWm1hYO
        LhV/nibL2+ZbI
X-Received: by 2002:a5d:5112:0:b0:317:6639:852d with SMTP id s18-20020a5d5112000000b003176639852dmr2031041wrt.43.1691677064016;
        Thu, 10 Aug 2023 07:17:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJIOuPdixKCMGjR2K5ty0NoV/em7DnAVHvF/nALkqMPVXfK3+ZQaaJOePrHhmDeP9THFd+eg==
X-Received: by 2002:a5d:5112:0:b0:317:6639:852d with SMTP id s18-20020a5d5112000000b003176639852dmr2031019wrt.43.1691677063673;
        Thu, 10 Aug 2023 07:17:43 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id e1-20020adfe381000000b003140f47224csm2357247wrm.15.2023.08.10.07.17.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 07:17:42 -0700 (PDT)
Message-ID: <fdf4d17a-e134-6e03-87d0-2c018c13a891@redhat.com>
Date:   Thu, 10 Aug 2023 16:17:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>
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
 <7c2f6fa3-23ba-6df5-24d9-28f95f866574@redhat.com>
 <20230804204840.GR212435@hirez.programming.kicks-ass.net>
 <20230804231954.swdjx6lxkccxals6@treble>
 <20230805005551.GT212435@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for
 kvm-amd.o
In-Reply-To: <20230805005551.GT212435@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/23 02:55, Peter Zijlstra wrote:
>> +	 * Clobbering BP here is mostly ok since GIF will block NMIs and with
>> +	 * the exception of #MC and the kvm_rebooting _ASM_EXTABLE()s below
>> +	 * nothing untoward will happen until BP is restored.
>> +	 *
>> +	 * The kvm_rebooting exceptions should not want to unwind stack, and
>> +	 * while #MV might want to unwind stack, it is ultimately fatal.
>> +	 */
> Aside from me not being able to type #MC, I did realize that the
> kvm_reboot exception will go outside noinstr code and can hit
> tracing/instrumentation and do unwinds from there.

Asynchronously disabling SVM requires an IPI, so kvm_rebooting cannot 
change within CLGI/STGI.   We can check it after CLGI instead of waiting 
for a #GP:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 956726d867aa..e3755f5eaf81 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4074,7 +4074,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct 
kvm_vcpu *vcpu)
  	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
  		x86_spec_ctrl_set_guest(svm->virt_spec_ctrl);

-	svm_vcpu_enter_exit(vcpu, spec_ctrl_intercepted);
+	if (unlikely(kvm_rebooting))
+		svm->vmcb->control.exit_code = SVM_EXIT_PAUSE;
+	else
+		svm_vcpu_enter_exit(vcpu, spec_ctrl_intercepted);

  	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
  		x86_spec_ctrl_restore_host(svm->virt_spec_ctrl);
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 8e8295e774f0..34641b3a6823 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -270,23 +270,12 @@ SYM_FUNC_START(__svm_vcpu_run)
  	RESTORE_GUEST_SPEC_CTRL_BODY
  	RESTORE_HOST_SPEC_CTRL_BODY

-10:	cmpb $0, kvm_rebooting
-	jne 2b
-	ud2
-30:	cmpb $0, kvm_rebooting
-	jne 4b
-	ud2
-50:	cmpb $0, kvm_rebooting
-	jne 6b
-	ud2
-70:	cmpb $0, kvm_rebooting
-	jne 8b
-	ud2
+10:	ud2

  	_ASM_EXTABLE(1b, 10b)
-	_ASM_EXTABLE(3b, 30b)
-	_ASM_EXTABLE(5b, 50b)
-	_ASM_EXTABLE(7b, 70b)
+	_ASM_EXTABLE(3b, 10b)
+	_ASM_EXTABLE(5b, 10b)
+	_ASM_EXTABLE(7b, 10b)

  SYM_FUNC_END(__svm_vcpu_run)


Paolo

