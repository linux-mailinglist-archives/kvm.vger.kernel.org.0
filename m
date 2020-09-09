Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B535A2634E3
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 19:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgIIRr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 13:47:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30034 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725826AbgIIRr5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Sep 2020 13:47:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599673674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XFCgqV2JQrbSvgP4/1gEOGiL0mmT1yXZgdeORM1MY18=;
        b=FzG8y8Sw/u7saT7SYLDY+KiJ9SuGEIUZ2YDxJQm3ruevQcedHvySZ4MQIXsSCDjGT20eRC
        YcaO1NvQjUpI1RuRZD4icINJ3IzaOwmqKM/BhYRRz45P4mOvp+Ad0Dy2m6KcKdXb0NVngX
        5/TTRjCkDCble37gZIh0vhRTLtuJ6Z4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-1jwnak-iOtSzF1yoOJUeaQ-1; Wed, 09 Sep 2020 13:47:50 -0400
X-MC-Unique: 1jwnak-iOtSzF1yoOJUeaQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21CA38015DB;
        Wed,  9 Sep 2020 17:47:49 +0000 (UTC)
Received: from [10.36.115.123] (ovpn-115-123.ams2.redhat.com [10.36.115.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 661A75C1DA;
        Wed,  9 Sep 2020 17:47:46 +0000 (UTC)
Subject: Re: [PATCH v3 5/5] KVM: arm64: Document PMU filtering API
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, graf@amazon.com,
        kernel-team@android.com
References: <20200908075830.1161921-1-maz@kernel.org>
 <20200908075830.1161921-6-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <7a90830f-fa4f-9513-e55c-b932451a033d@redhat.com>
Date:   Wed, 9 Sep 2020 19:47:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200908075830.1161921-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 9/8/20 9:58 AM, Marc Zyngier wrote:
> Add a small blurb describing how the event filtering API gets used.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 46 +++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index ca374d3fe085..203b91e93151 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -55,6 +55,52 @@ Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
>  virtual GIC implementation, this must be done after initializing the in-kernel
>  irqchip.
>  
> +1.3 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FILTER
> +---------------------------------------
> +
> +:Parameters: in kvm_device_attr.addr the address for a PMU event filter is a
> +             pointer to a struct kvm_pmu_event_filter
> +
> +:Returns:
> +
> +	 =======  ======================================================
> +	 -ENODEV: PMUv3 not supported or GIC not initialized
> +	 -ENXIO:  PMUv3 not properly configured or in-kernel irqchip not
> +	 	  configured as required prior to calling this attribute
> +	 -EBUSY:  PMUv3 already initialized
> +	 -EINVAL: Invalid filter range
> +	 =======  ======================================================
> +
> +Request the installation of a PMU event filter describe as follows:
> +
> +struct kvm_pmu_event_filter {
> +	__u16	base_event;
> +	__u16	nevents;
> +
> +#define KVM_PMU_EVENT_ALLOW	0
> +#define KVM_PMU_EVENT_DENY	1
> +
> +	__u8	action;
> +	__u8	pad[3];
> +};
> +
> +A filter range is defined as the range [@base_event, @base_event + @nevents[,
> +together with an @action (KVM_PMU_EVENT_ALLOW or KVM_PMU_EVENT_DENY). The
> +first registered range defines the global policy (global ALLOW if the first
> +@action is DENY, global DENY if the first @action is ALLOW). Multiple ranges
> +can be programmed, and must fit within the event space defined by the PMU
> +architecture (10 bits on ARMv8.0, 16 bits from ARMv8.1 onwards).
> +
> +Note: "Cancelling" a filter by registering the opposite action for the same
> +range doesn't change the default action. For example, installing an ALLOW
> +filter for event range [0:10] as the first filter and then applying a DENY
> +action for the same range will leave the whole range as disabled.
> +
> +Restrictions: Event 0 (SW_INCR) is never filtered, as it doesn't count a
> +hardware event. Filtering event 0x1E (CHAIN) has no effect either, as it
> +isn't strictly speaking an event. Filtering the cycle counter is possible
> +using event 0x11 (CPU_CYCLES).
Oh I see here you did comment it in the uapi.

Thanks

Eric
> +
>  
>  2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>  =================================
> 

