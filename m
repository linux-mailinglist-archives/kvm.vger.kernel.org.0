Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20B41804D
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 21:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfEHTOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 15:14:52 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:44158 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbfEHTOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 15:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1557342890; x=1588878890;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Pj0HWixZ6+yIXE3o4SR/2SPNG+WUOrfPGAwhPHfn3cs=;
  b=KDSw0uk0sMAnboYsrWkGMW3LgNxjK/+4e1FJAlENF0tLUeQmYroq5x1i
   D9yiALAcMi2m0zXQiq/DGjucu6G6AO1IGPcYL8K/kdZuz//z78YNQ04ho
   uS1EoEJG4oFHIm64CEi5kEau8JRsr0Ol/AuZwNdExQo9jx4imttYkYeLx
   4=;
X-IronPort-AV: E=Sophos;i="5.60,447,1549929600"; 
   d="scan'208";a="401369792"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 May 2019 19:14:47 +0000
Received: from u7588a65da6b65f.ant.amazon.com (pdx2-ws-svc-lb17-vlan2.amazon.com [10.247.140.66])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x48JEi2a082802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Wed, 8 May 2019 19:14:46 GMT
Received: from u7588a65da6b65f.ant.amazon.com (localhost [127.0.0.1])
        by u7588a65da6b65f.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x48JEh44024546;
        Wed, 8 May 2019 21:14:43 +0200
Subject: Re: [PATCH 3/6] svm: Add support for APIC_ACCESS_PAGE_PRIVATE_MEMSLOT
 setup/destroy
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "joro@8bytes.org" <joro@8bytes.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
References: <20190322115702.10166-1-suravee.suthikulpanit@amd.com>
 <20190322115702.10166-4-suravee.suthikulpanit@amd.com>
From:   =?UTF-8?Q?Jan_H=2e_Sch=c3=b6nherr?= <jschoenh@amazon.de>
Openpgp: preference=signencrypt
Message-ID: <5b786dde-1fc4-9abc-ae95-8360e033fb97@amazon.de>
Date:   Wed, 8 May 2019 21:14:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190322115702.10166-4-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/2019 12.57, Suthikulpanit, Suravee wrote:
> Activate/deactivate AVIC requires setting/unsetting the memory region used
> for APIC_ACCESS_PAGE_PRIVATE_MEMSLOT. So, re-factor avic_init_access_page()
> to avic_setup_access_page() and add srcu_read_lock/unlock, which are needed
> to allow this function to be called during run-time.
> 
> Also, introduce avic_destroy_access_page() to unset the page when
> deactivate AVIC.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 4cf93a729ad8..f41f34f70dde 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1666,7 +1666,7 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>   * field of the VMCB. Therefore, we set up the
>   * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT (4KB) here.
>   */
> -static int avic_init_access_page(struct kvm_vcpu *vcpu)
> +static int avic_setup_access_page(struct kvm_vcpu *vcpu, bool init)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	int ret = 0;
> @@ -1675,10 +1675,14 @@ static int avic_init_access_page(struct kvm_vcpu *vcpu)
>  	if (kvm->arch.apic_access_page_done)
>  		goto out;
>  
> +	if (!init)
> +		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>  	ret = __x86_set_memory_region(kvm,
>  				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
>  				      APIC_DEFAULT_PHYS_BASE,
>  				      PAGE_SIZE);
> +	if (!init)
> +		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>  	if (ret)
>  		goto out;
>  
> @@ -1688,6 +1692,26 @@ static int avic_init_access_page(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +static void avic_destroy_access_page(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	if (!kvm->arch.apic_access_page_done)
> +		goto out;
> +
> +	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> +	__x86_set_memory_region(kvm,
> +				APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
> +				APIC_DEFAULT_PHYS_BASE,
> +				0);
> +	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);

This pattern of "unlock, do something, re-lock" strikes me as odd --
here and in the setup function.

There seem to be a few assumptions for this to work:
a) SRCU read-side critical sections must not be nested.
b) We must not keep any pointer to a SRCU protected structure
   across a call to this function.

Can we guarantee these assumptions? Now and in the future (given that this is already
a bit hidden in the call stack)?

(And if we can guarantee them, why are we holding the SRCU lock in the first place?)

Or is there maybe a nicer way to do this?

Regards
Jan

> +	kvm->arch.apic_access_page_done = false;
> +out:
> +	mutex_unlock(&kvm->slots_lock);
> +}
> +
>  static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  {
>  	int ret;
> @@ -1695,7 +1719,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	int id = vcpu->vcpu_id;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	ret = avic_init_access_page(vcpu);
> +	ret = avic_setup_access_page(vcpu, true);
>  	if (ret)
>  		return ret;
>  
> 

