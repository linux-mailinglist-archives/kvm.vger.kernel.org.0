Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AA492191
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 12:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfHSKmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 06:42:42 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:29417 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHSKml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 06:42:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566211360; x=1597747360;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=KIcNfCXO8azwMTSRhRB2ZV3cspYnwdK7rin6MX7vsTA=;
  b=oD+UvkgpspMCe2gWQbhfUVeN1Wr5QX07id92DqIOpIU3NGNXGYx1xYre
   w2gJTKufK/XfwIGqXhfViSCAVlpexvuC4YgV3tTKBQ4MCbdlYYuz4JYIL
   1vLmrcGEtFHTbl5mYLRxIvLATjwSf8ryCbAjiMlDk/AgcnA1gbCCdJ5qZ
   8=;
X-IronPort-AV: E=Sophos;i="5.64,403,1559520000"; 
   d="scan'208";a="416067907"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Aug 2019 10:42:39 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 5AEC4A1E11;
        Mon, 19 Aug 2019 10:42:36 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 10:42:36 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.191) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 10:42:33 +0000
Subject: Re: [PATCH v2 12/15] kvm: i8254: Check LAPIC EOI pending when
 injecting irq on SVM AVIC
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
 <1565886293-115836-13-git-send-email-suravee.suthikulpanit@amd.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <ac9fa8d4-2c25-52a5-3938-3ce373b3c3e0@amazon.com>
Date:   Mon, 19 Aug 2019 12:42:31 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565886293-115836-13-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.191]
X-ClientProxiedBy: EX13D25UWC004.ant.amazon.com (10.43.162.201) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.08.19 18:25, Suthikulpanit, Suravee wrote:
> ACK notifiers don't work with AMD SVM w/ AVIC when the PIT interrupt
> is delivered as edge-triggered fixed interrupt since AMD processors
> cannot exit on EOI for these interrupts.
> 
> Add code to check LAPIC pending EOI before injecting any pending PIT
> interrupt on AMD SVM when AVIC is activated.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/kvm/i8254.c | 31 +++++++++++++++++++++++++------
>   1 file changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index 4a6dc54..31c4a9b 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -34,10 +34,12 @@
>   
>   #include <linux/kvm_host.h>
>   #include <linux/slab.h>
> +#include <asm/virtext.h>
>   
>   #include "ioapic.h"
>   #include "irq.h"
>   #include "i8254.h"
> +#include "lapic.h"
>   #include "x86.h"
>   
>   #ifndef CONFIG_X86_64
> @@ -236,6 +238,12 @@ static void destroy_pit_timer(struct kvm_pit *pit)
>   	kthread_flush_work(&pit->expired);
>   }
>   
> +static inline void kvm_pit_reset_reinject(struct kvm_pit *pit)
> +{
> +	atomic_set(&pit->pit_state.pending, 0);
> +	atomic_set(&pit->pit_state.irq_ack, 1);
> +}
> +
>   static void pit_do_work(struct kthread_work *work)
>   {
>   	struct kvm_pit *pit = container_of(work, struct kvm_pit, expired);
> @@ -244,6 +252,23 @@ static void pit_do_work(struct kthread_work *work)
>   	int i;
>   	struct kvm_kpit_state *ps = &pit->pit_state;
>   
> +	/*
> +	 * Since, AMD SVM AVIC accelerates write access to APIC EOI
> +	 * register for edge-trigger interrupts. PIT will not be able
> +	 * to receive the IRQ ACK notifier and will always be zero.
> +	 * Therefore, we check if any LAPIC EOI pending for vector 0
> +	 * and reset irq_ack if no pending.
> +	 */
> +	if (cpu_has_svm(NULL) && kvm->arch.apicv_state == APICV_ACTIVATED) {
> +		int eoi = 0;
> +
> +		kvm_for_each_vcpu(i, vcpu, kvm)
> +			if (kvm_apic_pending_eoi(vcpu, 0))
> +				eoi++;
> +		if (!eoi)
> +			kvm_pit_reset_reinject(pit);

In which case would eoi be != 0 when APIC-V is active?


Alex
