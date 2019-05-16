Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C971208B3
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 15:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfEPN4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 09:56:12 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:64141 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbfEPN4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 09:56:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1558014971; x=1589550971;
  h=subject:to:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=d3tF05X6+IMz0z3pdmsgwMoJMbbYKYQyJW/W5t9SFtI=;
  b=k2B77y/v8CaQC0rGb6Xqbv96CORAbw7wm1ve0QiujIWZVQYmLpybVI5I
   Mq/5fFi63ZZIFN139tHLU3bXfgQvYLHu4CABqsoGFY4oxPEG73vNm9ZHV
   GqOTaFdTro8T1PZoiQjEcrpVjl+Qxfxo8CBZNZ5J516YOM9QYd/EeJ5nT
   o=;
X-IronPort-AV: E=Sophos;i="5.60,476,1549929600"; 
   d="scan'208";a="402404736"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 16 May 2019 13:56:04 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x4GDu3Lg022882
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 May 2019 13:56:04 GMT
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 16 May 2019 13:56:03 +0000
Received: from macbook-2.local (10.43.161.34) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 16 May
 2019 13:56:02 +0000
Subject: Re: [PATCH v2 2/2] KVM: x86: Implement the arch-specific hook to
 report the VM UUID
To:     Filippo Sironi <sironi@amazon.de>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <borntraeger@de.ibm.com>,
        <boris.ostrovsky@oracle.com>, <cohuck@redhat.com>,
        <konrad.wilk@oracle.com>, <xen-devel@lists.xenproject.org>,
        <vasu.srinivasan@oracle.com>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-3-git-send-email-sironi@amazon.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <f51a6a84-b21c-ab75-7e30-bfbe2ac6b98b@amazon.com>
Date:   Thu, 16 May 2019 06:56:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1557847002-23519-3-git-send-email-sironi@amazon.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D12UWC002.ant.amazon.com (10.43.162.253) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.05.19 08:16, Filippo Sironi wrote:
> On x86, we report the UUID in DMI System Information (i.e., DMI Type 1)
> as VM UUID.
> 
> Signed-off-by: Filippo Sironi <sironi@amazon.de>
> ---
>  arch/x86/kernel/kvm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 5c93a65ee1e5..441cab08a09d 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -25,6 +25,7 @@
>  #include <linux/kernel.h>
>  #include <linux/kvm_para.h>
>  #include <linux/cpu.h>
> +#include <linux/dmi.h>
>  #include <linux/mm.h>
>  #include <linux/highmem.h>
>  #include <linux/hardirq.h>
> @@ -694,6 +695,12 @@ bool kvm_para_available(void)
>  }
>  EXPORT_SYMBOL_GPL(kvm_para_available);
>  
> +const char *kvm_para_get_uuid(void)
> +{
> +	return dmi_get_system_info(DMI_PRODUCT_UUID);

This adds a new dependency on CONFIG_DMI. Probably best to guard it with
an #if IS_ENABLED(CONFIG_DMI).

The concept seems sound though.


Alex

> +}
> +EXPORT_SYMBOL_GPL(kvm_para_get_uuid);
> +
>  unsigned int kvm_arch_para_features(void)
>  {
>  	return cpuid_eax(kvm_cpuid_base() | KVM_CPUID_FEATURES);
> 

