Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA4952EDBF
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350100AbiETOFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbiETOFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:05:35 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7133D7A466;
        Fri, 20 May 2022 07:05:34 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id fd25so10952273edb.3;
        Fri, 20 May 2022 07:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xqRSEjWYdwzjgqqrBK7n3d3BWHqbAI1WmVJdVsPHdzY=;
        b=hpGgi2DP4fY8eeSk24xHGBwf9dXFz1DoUMuVMAluPutpfuFAXNt++YnDEiwAuSlvi1
         wKAcl24hRdyYDaPD0gJsd7N+PM9JgAEXoquw+nBjomwECoZLbY+sPa5aN5Q5E3JUmZ8U
         XwiPTQbC0f+uv0w4mUg9sqh43c1Dr48+FAWZItaEYlOXziO5ZA7xGsS3hP5mEz2vQo9e
         O1fTAGQPoMYa8USQgvDMzJchxgsZ/+MjE0KvDfTaAXDUaWUv/Eg/7PyW4poncMbuquaM
         xegD+lRkF2CX2DZ+vcznpTHM/blCQA4pak9bzDzhw3pHi8YZc9jQCsdFKpP1LkdX7tJP
         D7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xqRSEjWYdwzjgqqrBK7n3d3BWHqbAI1WmVJdVsPHdzY=;
        b=CxSagnwAdAE+lcy45qkevdJFXgCGmKu73UiPyo9xFKOCgNLJ4q8YGNiktUZXiX+hD6
         CoK1Kg86Rk+Z1OOL1za78MZjKOjLbdTcL7/EYjNaEBkWzzzmf4DciBp55wfNZeKdo9nx
         88TSkmRU98fpUukuhdSESGwVoFCitm4iGQtoY0JbmQhrocMqrbj8hwyAyZbxNepqFkTZ
         IJfmRzpdGv0qW0CoxaR764/Z5kSokll9BMyzccf1BQ0XgoJhW8WwRlFPFegU8QUBa292
         SO/PMj7qflGpoAZchXZIE5CJ8O2zMo3OW1mDcUtkIjeZBSpQ9AanOHs3+1reR+r97POY
         UMfQ==
X-Gm-Message-State: AOAM533TXN71iUzLnupTdJeqoa3rSkr9ZMDPIpecPgjFRwM7vMzdNzwg
        /9LycdWwYzCTq7ooiKCpsdE=
X-Google-Smtp-Source: ABdhPJwtHhtrpMri3jGlX7fK78xgzfY2QhnH38KjZRTtrP0mHRhd7OyS6HTAeg76jINoaFzpQdIWJQ==
X-Received: by 2002:a05:6402:1612:b0:42a:be18:8c8 with SMTP id f18-20020a056402161200b0042abe1808c8mr11160802edv.223.1653055532922;
        Fri, 20 May 2022 07:05:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 26-20020a170906225a00b006f3ef214db9sm3214636ejr.31.2022.05.20.07.05.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 07:05:32 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <fb4a9151-e56c-d16c-f09c-ac098e41a791@redhat.com>
Date:   Fri, 20 May 2022 16:05:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: x86: SVM: fix nested PAUSE filtering
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <20220518072709.730031-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220518072709.730031-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/22 09:27, Maxim Levitsky wrote:
> To fix this, change the fallback strategy - ignore the guest threshold
> values, but use/update the host threshold values, instead of using zeros.

Hmm, now I remember why it was using the guest values.  It's because, if
the L1 hypervisor specifies COUNT=0 or does not have filtering enabled,
we need to obey and inject a vmexit on every PAUSE.  So something like this:

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f209c1ca540c..e6153fd3ae47 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -616,6 +616,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
  	struct kvm_vcpu *vcpu = &svm->vcpu;
  	struct vmcb *vmcb01 = svm->vmcb01.ptr;
  	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
+	u32 pause_count12;
+	u32 pause_thresh12;
  
  	/*
  	 * Filled at exit: exit_code, exit_code_hi, exit_info_1, exit_info_2,
@@ -671,20 +673,25 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
  	if (!nested_vmcb_needs_vls_intercept(svm))
  		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
  
+	pause_count12 = svm->pause_filter_enabled ? svm->nested.ctl.pause_filter_count : 0;
+	pause_thresh12 = svm->pause_threshold_enabled ? svm->nested.ctl.pause_filter_thresh : 0;
  	if (kvm_pause_in_guest(svm->vcpu.kvm)) {
-		/* use guest values since host doesn't use them */
-		vmcb02->control.pause_filter_count =
-				svm->pause_filter_enabled ?
-				svm->nested.ctl.pause_filter_count : 0;
-
-		vmcb02->control.pause_filter_thresh =
-				svm->pause_threshold_enabled ?
-				svm->nested.ctl.pause_filter_thresh : 0;
+		/* use guest values since host doesn't intercept PAUSE */
+		vmcb02->control.pause_filter_count = pause_count12;
+		vmcb02->control.pause_filter_thresh = pause_thresh12;
  
  	} else {
-		/* use host values otherwise */
+		/* start from host values otherwise */
  		vmcb02->control.pause_filter_count = vmcb01->control.pause_filter_count;
  		vmcb02->control.pause_filter_thresh = vmcb01->control.pause_filter_thresh;
+
+		/* ... but ensure filtering is disabled if so requested.  */
+		if (vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_PAUSE)) {
+			if (!pause_count12)
+				vmcb02->control.pause_filter_count = 0;
+			if (!pause_thresh12)
+				vmcb02->control.pause_filter_thresh = 0;
+		}
  	}
  
  	nested_svm_transition_tlb_flush(vcpu);


What do you think?
