Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0BB44D727
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 14:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhKKN0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 08:26:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231380AbhKKN0O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 08:26:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636637004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2d1AOX9BF7Ab22e6a+P4VCFkUC1sqx1Ef017ZVlrdd0=;
        b=LBE7bWhWEMm/yoq68SoD7i4MliAyq6eD+/k2cUCnR9OwSkNbfw7lLmrH0h+qzzLx1nBI/G
        PS2vCwVC4uNTPW2nfTIde3RujEF5/MwAf+LQfkE6/i96dmlwTSLoTiHTDWkw3bp4vtNPbg
        /iNgvWPZ3ghJD5ZBv/6gFBTQZIS1QYY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-51-xdfW3MEme0-gl1hXRRQ-1; Thu, 11 Nov 2021 08:23:23 -0500
X-MC-Unique: 51-xdfW3MEme0-gl1hXRRQ-1
Received: by mail-ed1-f70.google.com with SMTP id t20-20020a056402525400b003e2ad6b5ee7so5392994edd.8
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 05:23:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2d1AOX9BF7Ab22e6a+P4VCFkUC1sqx1Ef017ZVlrdd0=;
        b=zSngyYlTVf9CSWMnUZJNSKau5UW0qp3WxDqyvcm5zbNqKS7HGNQ32Cm/90tPinXyqR
         naKzHzkCnxlCEYPx+wD0OAXMKf5S80nids/Krffqq/QCZ/RAgUyze1C+P9wk4TO1pDPN
         UCmxqmtNdXQtqs0jQ2FfYqffYud8+Fou5EXnJmIgBQQOm4q166QHsiXfQjGG883cQd9X
         YyCBB+bWMGl1dEuaCqlKL7baqWTD7dGguICplyZeAaEPEvtl0bTZGcLXdo8upsu0/dgQ
         htkV1xGGSL5hRlDEuRW0C3sa3d5mMDT+Mf5i4CaI2CAKOsGyaEykjegH/s1OdO7+AKbB
         XvXA==
X-Gm-Message-State: AOAM531FflEWY9JzJ7Cet9XOBzvu+9PLZvBmsrL0yydZb8zGhfwvGLbf
        9kReAM3G4L35YtcVbYdtSrnK4HA32tXbqcw5PD/eGbrSDnXBVxLVpjfHXZabEKMRrbG0wS69v7H
        SRt3OwKecTjSB
X-Received: by 2002:a17:906:64a:: with SMTP id t10mr9543391ejb.5.1636637002019;
        Thu, 11 Nov 2021 05:23:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfn4PNoZyWu/ndZ8qjd92igJVajcz6MTs5ST/g/kSh88E6/x2hmpkBjihhvb7yJbAqgnpd5g==
X-Received: by 2002:a17:906:64a:: with SMTP id t10mr9543359ejb.5.1636637001815;
        Thu, 11 Nov 2021 05:23:21 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id l3sm904178edq.19.2021.11.11.05.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 05:23:21 -0800 (PST)
Message-ID: <309f61f7-72fd-06a2-84b4-97dfc3fab587@redhat.com>
Date:   Thu, 11 Nov 2021 14:23:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3] KVM: x86: Fix recording of guest steal time /
 preempted status
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org>
 <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org>
 <624bc910-1bec-e6dd-b09a-f86dc6cdbef0@redhat.com>
 <0372987a52b5f43963721b517664830e7e6f1818.camel@infradead.org>
 <1f326c33-3acf-911a-d1ef-c72f0a570761@redhat.com>
 <3645b9b889dac6438394194bb5586a46b68d581f.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <3645b9b889dac6438394194bb5586a46b68d581f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/2/21 18:36, David Woodhouse wrote:

> +		asm volatile("1:\t" LOCK_PREFIX "xchgb %0, %2\n"
> +			     "\txor %1, %1\n"
> +			     "2:\n"
> +			     "\t.section .fixup,\"ax\"\n"
> +			     "3:\tmovl %3, %1\n"
> +			     "\tjmp\t2b\n"
> +			     "\t.previous\n"
> +			     _ASM_EXTABLE_UA(1b, 3b)
> +			     : "=r" (st_preempted),
> +			       "=r" (err)
> +			     : "m" (st->preempted),
> +			       "i" (-EFAULT),
> +			       "0" (st_preempted));

Since Peter is removing custom fixups, I'm going for code that is
slightly suboptimal (though just by one extra instruction) but doesn't
interfere with him.

Also, xchg doesn't need a lock prefix.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3301,21 +3301,15 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
  	 */
  	if (guest_pv_has(vcpu, KVM_FEATURE_PV_TLB_FLUSH)) {
  		u8 st_preempted = 0;
-		int err;
+		int err = -EFAULT;
  
-		asm volatile("1:\t" LOCK_PREFIX "xchgb %0, %2\n"
-			     "\txor %1, %1\n"
+		asm volatile("1: xchgb %0, %2\n"
+			     "xor %1, %1\n"
  			     "2:\n"
-			     "\t.section .fixup,\"ax\"\n"
-			     "3:\tmovl %3, %1\n"
-			     "\tjmp\t2b\n"
-			     "\t.previous\n"
-			     _ASM_EXTABLE_UA(1b, 3b)
-			     : "=r" (st_preempted),
-			       "=r" (err)
-			     : "m" (st->preempted),
-			       "i" (-EFAULT),
-			       "0" (st_preempted));
+			     _ASM_EXTABLE_UA(1b, 2b)
+			     : "+r" (st_preempted),
+			       "+&r" (err)
+			     : "m" (st->preempted));
  		if (err)
  			goto out;
  

Queued with these changes.

Paolo

