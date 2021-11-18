Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5919E455EBA
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 15:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhKRO4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 09:56:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231366AbhKRO4m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 09:56:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637247222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L373jXSEIoDZsHVMU2PhLorWCXbM5HPTVlTFl6hbkas=;
        b=StB/TU+E6oa7wfOd4C65Co0LXgAeOM0eogmFhaVuPx+OCANOaz/1ppbmyJOLAgzfMJzbmQ
        pN0qJSXKu8fu+hvcK8ejk2l1mm+0koUmW4wBNEImAgVxnpwwV5N84Lgsbta0N4NzJsL3XX
        q1W8vYeHWQLTPXmdQKycvhIiwx5LqJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-aAAJpS2sPauaaYyCBJc8hQ-1; Thu, 18 Nov 2021 09:53:39 -0500
X-MC-Unique: aAAJpS2sPauaaYyCBJc8hQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24EA718D6A2A;
        Thu, 18 Nov 2021 14:53:36 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 516301037F47;
        Thu, 18 Nov 2021 14:53:31 +0000 (UTC)
Message-ID: <0008cb01-9100-6664-2cb8-e1c741f69a77@redhat.com>
Date:   Thu, 18 Nov 2021 15:53:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 4/4] KVM: x86/pmu: Refactoring kvm_perf_overflow{_intr}()
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211116122030.4698-1-likexu@tencent.com>
 <20211116122030.4698-5-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211116122030.4698-5-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 13:20, Like Xu wrote:
> -	}
> +	if (!intr)
> +		return;
> +
> +	/*
> +	 * Inject PMI. If vcpu was in a guest mode during NMI PMI
> +	 * can be ejected on a guest mode re-entry. Otherwise we can't
> +	 * be sure that vcpu wasn't executing hlt instruction at the
> +	 * time of vmexit and is not going to re-enter guest mode until
> +	 * woken up. So we should wake it, but this is impossible from
> +	 * NMI context. Do it from irq work instead.
> +	 */
> +	if (!kvm_is_in_guest())
> +		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
> +	else
> +		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
> +}
> +
> +static void kvm_perf_overflow(struct perf_event *perf_event,
> +			      struct perf_sample_data *data,
> +			      struct pt_regs *regs)
> +{
> +	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
> +	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +
> +	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
> +		kvm_pmu_counter_overflow(pmc, need_overflow_intr(pmc));
>   }

It could be even better to make a single function, but instead of 
need_overflow_intr(pmc) you should store into pmc from 
pmc_reprogram_counter.  Like this:

	/* Ignore counters that have been reported already.  */
	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
		return;

	__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);

	if (pmc->intr) {
		/*
		 * Inject PMI. If vcpu was in a guest mode during NMI PMI
		 * can be ejected on a guest mode re-entry. Otherwise we can't
		 * be sure that vcpu wasn't executing hlt instruction at the
		 * time of vmexit and is not going to re-enter guest mode until
		 * woken up. So we should wake it, but this is impossible from
		 * NMI context. Do it from irq work instead.
		 */
		if (!kvm_is_in_guest())
			irq_work_queue(pmu->irq_work);
		else
			kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
	}

Paolo

