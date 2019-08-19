Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07518921C8
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 13:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfHSLAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 07:00:18 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:9741 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfHSLAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 07:00:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566212417; x=1597748417;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=aS7WQr72arlTdqWhjKdkAN3a3DGB4dE30x9TuOF7K6g=;
  b=u9nnLq4y5kVMtb9Im7K81tKgLhh9QYQ61NiHDxodG2tpPTn8jUAd662m
   cmpjdKZqjAlkDfOs7D8YTC1xRzl1MShmRC8C3yXHV0vPlK2+il/vUx5f6
   ShscTPwU2ZH9U4aPU7Cl3SkjTYxoul1OOxMpVR1h0KW9zOxL1HJNiQVVQ
   I=;
X-IronPort-AV: E=Sophos;i="5.64,403,1559520000"; 
   d="scan'208";a="821177471"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 19 Aug 2019 11:00:13 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 84FD8A20AA;
        Mon, 19 Aug 2019 11:00:13 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 11:00:13 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.214) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 11:00:09 +0000
Subject: Re: [PATCH v2 14/15] kvm: ioapic: Delay update IOAPIC EOI for RTC
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-15-git-send-email-suravee.suthikulpanit@amd.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <e5556778-105a-bdb3-f118-84fe729d042b@amazon.com>
Date:   Mon, 19 Aug 2019 13:00:07 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565886293-115836-15-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.214]
X-ClientProxiedBy: EX13D08UWB003.ant.amazon.com (10.43.161.186) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.08.19 18:25, Suthikulpanit, Suravee wrote:
> In-kernel IOAPIC does not update RTC pending EOI info with AMD SVM /w AVIC
> when interrupt is delivered as edge-triggered since AMD processors
> cannot exit on EOI for these interrupts.
> 
> Add code to also check LAPIC pending EOI before injecting any new RTC
> interrupts on AMD SVM when AVIC is activated.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/kvm/ioapic.c | 36 ++++++++++++++++++++++++++++++++----
>   1 file changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 1add1bc..45e7bb0 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -39,6 +39,7 @@
>   #include <asm/processor.h>
>   #include <asm/page.h>
>   #include <asm/current.h>
> +#include <asm/virtext.h>
>   #include <trace/events/kvm.h>
>   
>   #include "ioapic.h"
> @@ -173,6 +174,7 @@ static bool rtc_irq_check_coalesced(struct kvm_ioapic *ioapic)
>   	return false;
>   }
>   
> +#define APIC_DEST_NOSHORT		0x0
>   static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
>   		int irq_level, bool line_status)
>   {
> @@ -201,10 +203,36 @@ static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
>   	 * interrupts lead to time drift in Windows guests.  So we track
>   	 * EOI manually for the RTC interrupt.
>   	 */
> -	if (irq == RTC_GSI && line_status &&
> -		rtc_irq_check_coalesced(ioapic)) {
> -		ret = 0;
> -		goto out;
> +	if (irq == RTC_GSI && line_status) {
> +		struct kvm *kvm = ioapic->kvm;
> +		union kvm_ioapic_redirect_entry *entry = &ioapic->redirtbl[irq];
> +
> +		/*
> +		 * Since, AMD SVM AVIC accelerates write access to APIC EOI
> +		 * register for edge-trigger interrupts, IOAPIC will not be
> +		 * able to receive the EOI. In this case, we do lazy update
> +		 * of the pending EOI when trying to set IOAPIC irq for RTC.
> +		 */
> +		if (cpu_has_svm(NULL) &&
> +		    (kvm->arch.apicv_state == APICV_ACTIVATED) &&
> +		    (entry->fields.trig_mode == IOAPIC_EDGE_TRIG)) {
> +			int i;
> +			struct kvm_vcpu *vcpu;
> +
> +			kvm_for_each_vcpu(i, vcpu, kvm)
> +				if (kvm_apic_match_dest(vcpu, NULL,
> +							KVM_APIC_DEST_NOSHORT,
> +							entry->fields.dest_id,
> +							entry->fields.dest_mode)) {
> +					__rtc_irq_eoi_tracking_restore_one(vcpu);

I don't understand why this works. This code just means we're injecting 
an EOI on the first CPU that has the vector mapped, right when we're 
setting it to trigger, no?


Alex


> +					break;
> +				}
> +		}
> +
> +		if (rtc_irq_check_coalesced(ioapic)) {
> +			ret = 0;
> +			goto out;
> +		}
>   	}
>   
>   	old_irr = ioapic->irr;
> 
