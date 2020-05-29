Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634F61E7B3A
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 13:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgE2LHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 07:07:21 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40475 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725863AbgE2LHU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 07:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590750438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hM1Op1XDd7DYog5hMh0DJuc21bHqau9Ixx3YDEOEqEc=;
        b=XAOphrcANf+uJs+1vDryVUZZIc+SG4QEv0dgSCulD8J//+5FuxUtQdUWqpk/63VCSY3Cqb
        bxSspe5TDEjKKMGorrh0wgfxObSA6xZ0CI9zYEipR3ed7nseV2h04pJoYAF3XIdz13uFYQ
        WAit9NcOIOjIWgRFWa6p7WA1I6Chel8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-RRDTMNecMQa-hzEo29YF9g-1; Fri, 29 May 2020 07:07:15 -0400
X-MC-Unique: RRDTMNecMQa-hzEo29YF9g-1
Received: by mail-wr1-f72.google.com with SMTP id t5so886337wro.20
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 04:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hM1Op1XDd7DYog5hMh0DJuc21bHqau9Ixx3YDEOEqEc=;
        b=Usfnucmf3yFSb4O1xLJcgl1hSskOGenncHEAB4yGDhNi9b1GbCKfW5dZ3I3K2XGVab
         /hE9noqVWtz5ndEySgh8IhG11DaRm2LAio9KHn9/s21BpVuRXnBL6oqLmjxUjEpOsRmT
         9Wld3DhGujOxf+CZufnShNWRwSENUItpd4QkVtYuGhACke9Q0FRrNCgL1I1XW5HiFqGH
         H1/nqsK7Up/v/yDhWhIHB2cG2359ssnwx+qgxntwXCySakxfmZPFLO90FHXYoa/cHhYT
         MhEBcHoogWX/DDBx/RLFQNd0HiIxaLJtDX+h8IRvGzVWS42LzpvIUAuH6Y90F4rF1gND
         VxrA==
X-Gm-Message-State: AOAM531EThlJopLxYFDVW8rsJ9AMK5OgLZHPLRBYkaWiG/eVHrIWe1UM
        HxPPr7U7IQt0yOzVO1XpIJALYKuuFxHGIUtmai8G40r6NsYpxMi5pJUjrgIc1EVxV+MhvHh2JIk
        d8sDe4kvqJekQ
X-Received: by 2002:a5d:6305:: with SMTP id i5mr1118895wru.268.1590750433788;
        Fri, 29 May 2020 04:07:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwGIYaSh6ai3Uz6+EY5hqwk1mvg3eH4JfTHK2KTnwPOOUCIlXhPQrsqgduq5idk8Xfz/HZiQ==
X-Received: by 2002:a5d:6305:: with SMTP id i5mr1118872wru.268.1590750433537;
        Fri, 29 May 2020 04:07:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b096:1b7:7695:e4f7? ([2001:b07:6468:f312:b096:1b7:7695:e4f7])
        by smtp.gmail.com with ESMTPSA id e5sm9543214wrw.19.2020.05.29.04.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 04:07:12 -0700 (PDT)
Subject: Re: [PATCH 1/2 v5] KVM: nVMX: Fix VMX preemption timer migration
To:     Makarand Sonare <makarandsonare@google.com>, kvm@vger.kernel.org,
        pshier@google.com, jmattson@google.com
References: <20200526215107.205814-1-makarandsonare@google.com>
 <20200526215107.205814-2-makarandsonare@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <236e518b-78d1-0c8b-f100-53f851e114c8@redhat.com>
Date:   Fri, 29 May 2020 13:07:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200526215107.205814-2-makarandsonare@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/20 23:51, Makarand Sonare wrote:
> +
> +	u64 l1_scaled_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) >>
> +			    VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE;
> +
> +	if (!vmx->nested.has_preemption_timer_deadline) {
> +		timer_value = vmcs12->vmx_preemption_timer_value;
> +		vmx->nested.preemption_timer_deadline = timer_value +
> +							l1_scaled_tsc;
> +		vmx->nested.has_preemption_timer_deadline = true;
> +	} else if (l1_scaled_tsc < vmx->nested.preemption_timer_deadline)
> +		timer_value = vmx->nested.preemption_timer_deadline -
> +			      l1_scaled_tsc;
> +	return timer_value;

Queued, thanks!  Just a tiny change that I squashed here:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index da87bb8670bb..9c74a732b08d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2091,20 +2091,16 @@ static u64 vmx_calc_preemption_timer_value(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	u64 timer_value = 0;
 
 	u64 l1_scaled_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) >>
 			    VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE;
 
 	if (!vmx->nested.has_preemption_timer_deadline) {
-		timer_value = vmcs12->vmx_preemption_timer_value;
-		vmx->nested.preemption_timer_deadline = timer_value +
-							l1_scaled_tsc;
+		vmx->nested.preemption_timer_deadline =
+			vmcs12->vmx_preemption_timer_value + l1_scaled_tsc;
 		vmx->nested.has_preemption_timer_deadline = true;
-	} else if (l1_scaled_tsc < vmx->nested.preemption_timer_deadline)
-		timer_value = vmx->nested.preemption_timer_deadline -
-			      l1_scaled_tsc;
-	return timer_value;
+	}
+	return vmx->nested.preemption_timer_deadline - l1_scaled_tsc;
 }
 
 static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,


Thanks,

Paolo

