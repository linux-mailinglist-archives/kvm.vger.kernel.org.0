Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7323B1657E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 16:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfEGOQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 10:16:28 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:53062 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfEGOQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 10:16:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1557238587; x=1588774587;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Vo1VSCRyKTg9cfYNPO1nz0gtpqGkbp+mZ2rF1BBRI8k=;
  b=IxJ7peElO1kPIttQCCEt5KJga3tSJLHV6IIOlDA6g2XckcYQWFmmVrju
   V2whX5vOrpa8T0I2dK/4afpYXYLiydxYaRJHpO7Cx6mohgAS6RnZfRcjD
   EeS/AU0r8A9kgvxgHMVDhuKJcSoPE33ch67gUh/+9j+hrNktQeYR6YpiF
   k=;
X-IronPort-AV: E=Sophos;i="5.60,441,1549929600"; 
   d="scan'208";a="798327030"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 May 2019 14:16:25 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x47EGNMf029527
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 7 May 2019 14:16:24 GMT
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 May 2019 14:16:23 +0000
Received: from 38f9d35ad2cf.ant.amazon.com (10.28.86.127) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 May 2019 14:16:21 +0000
Subject: Re: [PATCH] svm/avic: Allow avic_vcpu_load logic to support host APIC
 ID 255
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
References: <1556890631-9561-1-git-send-email-suravee.suthikulpanit@amd.com>
From:   "Graf, Alexander" <graf@amazon.com>
Message-ID: <49a27e83-a83e-5d2d-9b11-bb09c15776d2@amazon.com>
Date:   Tue, 7 May 2019 16:16:19 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556890631-9561-1-git-send-email-suravee.suthikulpanit@amd.com>
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

On 03.05.19 15:37, Suthikulpanit, Suravee wrote:
> Current logic does not allow VCPU to be loaded onto CPU with
> APIC ID 255. This should be allowed since the host physical APIC ID
> field in the AVIC Physical APIC table entry is an 8-bit value,
> and APIC ID 255 is valid in system with x2APIC enabled.
> 
> Instead, do not allow VCPU load if the host APIC ID cannot be
> represented by an 8-bit value.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Your comment for AVIC_MAX_PHYSICAL_ID_COUNT says that 0xff (255) is 
broadcast hence you disallow that value. In fact, even the comment a few 
lines above the patch hunk does say that. Why the change of mind?

Alex

> ---
>   arch/x86/kvm/svm.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 294448e..122788f 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2071,7 +2071,11 @@ static void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	if (!kvm_vcpu_apicv_active(vcpu))
>   		return;
>   
> -	if (WARN_ON(h_physical_id >= AVIC_MAX_PHYSICAL_ID_COUNT))
> +	/*
> +	 * Since the host physical APIC id is 8 bits,
> +	 * we can support host APIC ID upto 255.
> +	 */
> +	if (WARN_ON(h_physical_id > AVIC_MAX_PHYSICAL_ID_COUNT))
>   		return;
>   
>   	entry = READ_ONCE(*(svm->avic_physical_id_cache));
> 

