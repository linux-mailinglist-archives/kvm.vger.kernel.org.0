Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3784C569D72
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 10:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbiGGI1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 04:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiGGI1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 04:27:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C4DE1A3BB
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 01:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657182421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hyQUq78HZYV0U5amrGZK5Au62aqwa+QCBY5NRkOA5vM=;
        b=Za1c3dchr9VjWfrfMwzbmap30VjOuSjq8jpKqxO9feLQkidfcNtGkfSjYRLrw51CdMSVyZ
        l44mgb8yrPR6nw82yuQHX1wVC+3EzdKglDHla7aTQdVHH5nWJLpiQjnkSR/zQ2waM5ZAk4
        fvM/tVl90P8vzI3fQNWZwyxjYvzfwjo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-VPVHcE1HOYOsyCBYrhgCRw-1; Thu, 07 Jul 2022 04:26:59 -0400
X-MC-Unique: VPVHcE1HOYOsyCBYrhgCRw-1
Received: by mail-ej1-f69.google.com with SMTP id nb10-20020a1709071c8a00b006e8f89863ceso4460408ejc.18
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 01:26:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hyQUq78HZYV0U5amrGZK5Au62aqwa+QCBY5NRkOA5vM=;
        b=nHstMgWlkoaMfNUkjrp32xUbtm9CzXlFIN12s7xS/KeHElPknkrfzFZYKKQtqB/rOn
         sAiMlfzHc6suXa7FbC2vy2hqPSvDVwLQv5oMxVsT2v8ReAOyQWS7t2MQPxeWbPW2Go+g
         q5IoMRTSJ7W/WkIUKJlFNEvXEoxJnBI0GEuKLpEUiIkCPPAzziTQNttmTz3l2J0HT2Mz
         lfU+LA+pYrP5hKE8LYkC1GoGYr1czRlsy0yrvRGubvqQWnW+ynmxPVmwfVVqf5Qq/7NB
         o7V9DOyZrMWsS0rHQ7kMQVmlflhqtc+xq0u3FuuBim+uPzyOyu+WhCFnprgZfiWVWhvR
         AE3w==
X-Gm-Message-State: AJIora8jAsOXRygjjCj0hKlEoWAbKI+eBVXT2CUOg1/zdAwHC3AJuU80
        EbSMAlXy48bL+hQJk6Og9m1gpfHPuXTFCq7KtZKAkvzFEN2dNtzYvxC9oJLnQywRrbmSkYso2QZ
        moLP/RsZl1C4cfJjkYpC8AqLHWuVfIO+ZCB46Ylf0mwp3FN/AsMjD/vtYhqvugXwm
X-Received: by 2002:a05:6402:c0b:b0:43a:25ff:ff08 with SMTP id co11-20020a0564020c0b00b0043a25ffff08mr32234935edb.148.1657182418796;
        Thu, 07 Jul 2022 01:26:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uvaDV9BbuUE121Sm+1DSqPLexh4d8iG52AgkDo+XRYCQ8whzlmbqjuBkwqDmHZx8J/VKLzYA==
X-Received: by 2002:a05:6402:c0b:b0:43a:25ff:ff08 with SMTP id co11-20020a0564020c0b00b0043a25ffff08mr32234901edb.148.1657182418538;
        Thu, 07 Jul 2022 01:26:58 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id eo7-20020a056402530700b0043a78236cd2sm5689000edb.89.2022.07.07.01.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 01:26:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wang Guangju <wangguangju@baidu.com>
Cc:     linux-kernel@vger.kernel.org, wangguangju@baidu.com,
        seanjc@google.com, pbonzini@redhat.com, jmattson@google.com,
        wanpengli@tencent.com, bp@alien8.de, joro@8bytes.org,
        suravee.suthikulpanit@amd.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Add EOI exit bitmap handlers for Hyper-V
 SynIC vectors
In-Reply-To: <20220705083732.168-1-wangguangju@baidu.com>
References: <20220705083732.168-1-wangguangju@baidu.com>
Date:   Thu, 07 Jul 2022 10:26:56 +0200
Message-ID: <87v8s9qqen.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wang Guangju <wangguangju@baidu.com> writes:

> From: wangguangju <wangguangju@baidu.com>
>
> Hyper-V SynIC vectors were added into EOI exit bitmap in func
> synic_set_sint().But when the Windows VM VMEXIT due to
> EXIT_REASON_EOI_INDUCED, there are no EOI exit bitmap handlers
> for Hyper-V SynIC vectors.

My take:

"When EOI virtualization is performed on VMX,
kvm_apic_set_eoi_accelerated() is called upon EXIT_REASON_EOI_INDUCED
but unlike its non-accelerated apic_set_eoi() sibling, Hyper-V SINT
vectors are left unhandled.
"

>
> This patch fix it.
>
> Change-Id: I2404ebf7bda60326be3f6786e0e34e63aa81bbd4

In case this is not something publicly available it doesn't belong to
kernel changelog as it doesn't bring any value.

> Signed-off-by: wangguangju <wangguangju@baidu.com>
> ---
>  arch/x86/kvm/lapic.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 0e68b4c..59096f8 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1303,6 +1303,10 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
>  
>  	trace_kvm_eoi(apic, vector);
>  
> +	if (to_hv_vcpu(apic->vcpu) &&
> +	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
> +		kvm_hv_synic_send_eoi(apic->vcpu, vector);
> +
>  	kvm_ioapic_send_eoi(apic, vector);
>  	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);


This whole part:

	if (to_hv_vcpu(apic->vcpu) &&
	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
		kvm_hv_synic_send_eoi(apic->vcpu, vector);

	kvm_ioapic_send_eoi(apic, vector);
	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);

could be split into an inline function, something like (completely
untested):

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6ff17d5a2ae3..9d19c7c738c0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1269,6 +1269,16 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
        kvm_ioapic_update_eoi(apic->vcpu, vector, trigger_mode);
 }
 
+static inline void apic_set_eoi_vector(struct kvm_lapic *apic, int vector)
+{
+       if (to_hv_vcpu(apic->vcpu) &&
+           test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
+               kvm_hv_synic_send_eoi(apic->vcpu, vector);
+
+       kvm_ioapic_send_eoi(apic, vector);
+       kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
+}
+
 static int apic_set_eoi(struct kvm_lapic *apic)
 {
        int vector = apic_find_highest_isr(apic);
@@ -1285,12 +1295,8 @@ static int apic_set_eoi(struct kvm_lapic *apic)
        apic_clear_isr(vector, apic);
        apic_update_ppr(apic);
 
-       if (to_hv_vcpu(apic->vcpu) &&
-           test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
-               kvm_hv_synic_send_eoi(apic->vcpu, vector);
+       apic_set_eoi_vector(apic, vector);
 
-       kvm_ioapic_send_eoi(apic, vector);
-       kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
        return vector;
 }
 
@@ -1304,8 +1310,7 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
 
        trace_kvm_eoi(apic, vector);
 
-       kvm_ioapic_send_eoi(apic, vector);
-       kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
+       apic_set_eoi_vector(apic, vector);
 }
 EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);


>  }

-- 
Vitaly

