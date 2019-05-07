Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68CF716460
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 15:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfEGNQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 09:16:26 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:42890 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfEGNQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 09:16:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1557234985; x=1588770985;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=vtM2skgsxi9Gv7Bo3dFoB+dFGHiVfYzMzSQu+Q1/iEY=;
  b=XIclaN92i4i1HYfoLPff3hCKUjN0G/sounJcyEAH/9t/5MKaEB1918F2
   H637Ky9Na3j6WCKKXBazk5FgFNDEaSd9jhj1kJmiABc7HdPOjVrbbH7DI
   6n1IAUP5h6+3j2KR+ZCAmFaHbOlsm2fyrAT458gaPJM6Q0Q/0V+ATZLwL
   A=;
X-IronPort-AV: E=Sophos;i="5.60,441,1549929600"; 
   d="scan'208";a="673044317"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 May 2019 13:16:22 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x47DGELP025809
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 7 May 2019 13:16:20 GMT
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 May 2019 13:16:19 +0000
Received: from 38f9d35ad2cf.ant.amazon.com (10.28.86.127) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 May 2019 13:16:17 +0000
Subject: Re: [PATCH] svm/avic: Do not send AVIC doorbell to self
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
References: <1556890721-9613-1-git-send-email-suravee.suthikulpanit@amd.com>
From:   "Graf, Alexander" <graf@amazon.com>
Message-ID: <ca64dd06-df77-050a-92ff-5d5448382390@amazon.com>
Date:   Tue, 7 May 2019 15:16:15 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556890721-9613-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.28.86.127]
X-ClientProxiedBy: EX13MTAUEA001.ant.amazon.com (10.43.61.82) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.05.19 15:38, Suthikulpanit, Suravee wrote:
> AVIC doorbell is used to notify a running vCPU that interrupts
> has been injected into the vCPU AVIC backing page. Current logic
> checks only if a VCPU is running before sending a doorbell.
> However, the doorbell is not necessary if the destination
> CPU is itself.
> 
> Add logic to check currently running CPU before sending doorbell.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Reviewed-by: Alexander Graf <graf@amazon.com>

> ---
>   arch/x86/kvm/svm.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 122788f..4bbf6fc 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5283,10 +5283,13 @@ static void svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
>   	kvm_lapic_set_irr(vec, vcpu->arch.apic);
>   	smp_mb__after_atomic();
>   
> -	if (avic_vcpu_is_running(vcpu))
> -		wrmsrl(SVM_AVIC_DOORBELL,
> -		       kvm_cpu_get_apicid(vcpu->cpu));
> -	else
> +	if (avic_vcpu_is_running(vcpu)) { > +		int cpuid = vcpu->cpu;
> +
> +		if (cpuid != get_cpu())

Tiny nitpick: What would keep you from checking vcpu->cpu directly here?

Alex

> +			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpuid));
> +		put_cpu();
> +	} else
>   		kvm_vcpu_wake_up(vcpu);
>   }
>   
> 

