Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB784958C9
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 05:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiAUEJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 23:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbiAUEJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 23:09:51 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D16C061574;
        Thu, 20 Jan 2022 20:09:50 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id d5so5868676pjk.5;
        Thu, 20 Jan 2022 20:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=al59piwsE1ks+8UzubOECIyodvhcUy6a89ZSPsvp/Lc=;
        b=KahKqSAdDtBmGT1VfR8CatcpvbvpyEGbBYVevgzqgrkZjCkBEd9g8/D7Ac+sdRsBxx
         tHzP1IOlYhlwSCaypGXnkXi5TG7GVixZFKX1fsSJsmhfSooiSObeQOY3rD8MsmBlY9Lp
         KpP/aC3z6fxHt4Zkfki415zLKZAaa21gOa0dDRMROi+Cf0Rw29Y0hKO2SnwEAFbbZEeK
         RngQlJPx9iLA+pyfk7F16IO1kWlP2JERQEzzCSKr+eqLs4GbJBeIiOInDE4MlXouX1mN
         F6I9Snsgv9mOG+r++gdaq5+9B5QCBLQWuPao6Q9b8dcOrHYZUF+DLjhxUFD6Ta3pqKGi
         g/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=al59piwsE1ks+8UzubOECIyodvhcUy6a89ZSPsvp/Lc=;
        b=OhLuP85EsywP4/zkKbbA7VqdDRNTdXpmw3IjdxnhIsI5B4+R1B5BK41gkrZU6R8Kpi
         ypewV47hDxpA1QWZik+YWMigTgUeURmrLtVZHhmRkPSd+WdXbMvsgrprMQYpN9juHOJ3
         ZZVZwopwpMLbTrBkaFYfWou1Pen2Sn+jkiOlm+BRhMMeF/CfN1q4gWSs0MqUaftPtyCM
         UBASnDCK1qB6PWN5QQAi8eYixKleS/kTPtg/efg1eBHwp/XrFrbxUbe0FvcCQsLJ/tBW
         KS1u1Y/ykxmlwNxu44tXLeafsqLobAychBbauH1t6OUfxDYncDl6y8TDHzU/iGqYySWT
         +HPQ==
X-Gm-Message-State: AOAM532TRZ9jOxu88A6zuECJTxg3Pl7LUgSFKQxsCGyqIMlgOfPtkvU6
        Nipg+rfiy8e4N3uPX41a24s=
X-Google-Smtp-Source: ABdhPJyrJ28yTzv8titAgdAs+b8OVMBBL0HcP6t16W3qKzNNI+Y9DqhlFGNWjvIqiLOzKT5S/5htqg==
X-Received: by 2002:a17:902:9343:b0:148:a2e7:fb5f with SMTP id g3-20020a170902934300b00148a2e7fb5fmr2472292plp.160.1642738190284;
        Thu, 20 Jan 2022 20:09:50 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a19sm4955348pfv.123.2022.01.20.20.09.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 20:09:49 -0800 (PST)
Message-ID: <eacf3f83-96f5-301e-de54-8a0f6c8f9fe5@gmail.com>
Date:   Fri, 21 Jan 2022 12:09:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: [PATCH v2] KVM: x86: Sync the states size with the XCR0/IA32_XSS at
 any time
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117082631.86143-1-likexu@tencent.com>
 <f9edf9b5-0f84-a424-f8e9-73cad901d993@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <f9edf9b5-0f84-a424-f8e9-73cad901d993@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

XCR0 is reset to 1 by RESET but not INIT and IA32_XSS is zeroed by
both RESET and INIT. The kvm_set_msr_common()'s handling of MSR_IA32_XSS
also needs to update kvm_update_cpuid_runtime(). In the above cases, the
size in bytes of the XSAVE area containing all states enabled by XCR0 or
(XCRO | IA32_XSS) needs to be updated.

For simplicity and consistency, legacy helpers are used to write values
and call kvm_update_cpuid_runtime(), and it's not exactly a fast path.

Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
Signed-off-by: Like Xu <likexu@tencent.com>
---
v1 -> v2 Changelog:
- Strongly prefer that use the helpers to write the values; (Sean)
- Postpone IA32_XSS test cases once non-zero values are supported; (Paolo)
- User space may call SET_CPUID2 after kvm_vcpu_reset(init_event=false); (Paolo)

  arch/x86/kvm/x86.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55518b7d3b96..22d4b1d15e94 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11256,7 +11256,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)

  		vcpu->arch.msr_misc_features_enables = 0;

-		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
+		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
  	}

  	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
@@ -11273,7 +11273,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
  	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
  	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);

-	vcpu->arch.ia32_xss = 0;
+	__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);

  	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);

-- 
2.33.1


