Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1110C455ED0
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhKRPDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:03:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55228 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230351AbhKRPDL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 10:03:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637247611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ux5SYEmig3ZooBLG3/V3y/1QUckQlA1cV2+LaHn18lA=;
        b=GKUNwFINWIDodlJ1DfSqGs4BkgdlYflZ7BxampoOlGMp0lAsvseJ4+z2hgX/LAKuB9wvBh
        0of3N7Fahkjyr1xxDIShXldp7fTdZgYDuktP41rqZt03m7r2GTMcE3IigSWqsemSMIRMQH
        30WmtSSKHbZdqwoCGps/yIctVwcxuWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-51--8Klzti1OgSQeGJSf6B3iw-1; Thu, 18 Nov 2021 10:00:08 -0500
X-MC-Unique: -8Klzti1OgSQeGJSf6B3iw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CB3D8799E0;
        Thu, 18 Nov 2021 15:00:06 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D68A5C22B;
        Thu, 18 Nov 2021 15:00:04 +0000 (UTC)
Message-ID: <85286356-8005-8a4d-927c-c3d70c723161@redhat.com>
Date:   Thu, 18 Nov 2021 16:00:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 3/4] KVM: x86/pmu: Reuse find_perf_hw_id() and drop
 find_fixed_event()
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211116122030.4698-1-likexu@tencent.com>
 <20211116122030.4698-4-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211116122030.4698-4-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 13:20, Like Xu wrote:
> +static inline unsigned int intel_find_fixed_event(int idx)
> +{
> +	u32 event;
> +	size_t size = ARRAY_SIZE(fixed_pmc_events);
> +
> +	if (idx >= size)
> +		return PERF_COUNT_HW_MAX;
> +
> +	event = fixed_pmc_events[array_index_nospec(idx, size)];
> +	return intel_arch_events[event].event_type;
> +}
> +
> +
>   static unsigned int intel_find_perf_hw_id(struct kvm_pmc *pmc)
>   {
>   	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> @@ -75,6 +88,9 @@ static unsigned int intel_find_perf_hw_id(struct kvm_pmc *pmc)
>   	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>   	int i;
>   
> +	if (pmc_is_fixed(pmc))
> +		return intel_find_fixed_event(pmc->idx - INTEL_PMC_IDX_FIXED);

Is intel_find_fixed_event needed at all?  As you point out in the commit
message, eventsel/unit_mask are valid so you can do

@@ -88,13 +75,11 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
  	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
  	int i;
  
-	if (pmc_is_fixed(pmc))
-		return intel_find_fixed_event(pmc->idx - INTEL_PMC_IDX_FIXED);
-
  	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
  		if (intel_arch_events[i].eventsel == event_select
  		    && intel_arch_events[i].unit_mask == unit_mask
-		    && (pmu->available_event_types & (1 << i)))
+		    && (pmc_is_fixed(pmc) ||
+			pmu->available_event_types & (1 << i)))
  			break;
  
  	if (i == ARRAY_SIZE(intel_arch_events))

What do you think?  It's less efficient but makes fixed/gp more similar.

Can you please resubmit the series based on the review feedback?

Thanks,

