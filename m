Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1497D126DF6
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 20:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfLST2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 14:28:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48434 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727177AbfLST2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 14:28:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576783731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vAIxDhFZG4KNnWbcoM1z/eNh1hoZhidyKE5sG/UkD5w=;
        b=PFHb9ppAZSdrztzN13AkJXfJwoQ4HSUioSSeXLQYd1I6WwVi74SRjdBcWFfaprsyLpqZrx
        7fHiuZ1lBmwi7PBidNlFEv6Bg2/gXdNBvK2u2D5YtknNCz41xYPos9aReo8fAXZ7lU1BHL
        nSiqfJu8QSBS3SnXFsyFIlfUDzdDets=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-7KuzwdpAO0uhdJbA8J3gpA-1; Thu, 19 Dec 2019 14:28:48 -0500
X-MC-Unique: 7KuzwdpAO0uhdJbA8J3gpA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B2CA18FF698;
        Thu, 19 Dec 2019 19:28:45 +0000 (UTC)
Received: from gondolin (ovpn-117-134.ams2.redhat.com [10.36.117.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01C375DA70;
        Thu, 19 Dec 2019 19:28:37 +0000 (UTC)
Date:   Thu, 19 Dec 2019 20:28:35 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH v2 24/45] KVM: Add kvm_arch_vcpu_precreate() to handle
 pre-allocation issues
Message-ID: <20191219202835.06fc6f2f.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-25-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-25-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 13:55:09 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Add a pre-allocation arch hook to handle checks that are currently done
> by arch specific code prior to allocating the vCPU object.  This paves
> the way for moving the allocation to common KVM code.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/kvm/mips.c       |  5 +++++
>  arch/powerpc/kvm/powerpc.c |  5 +++++
>  arch/s390/kvm/kvm-s390.c   | 12 ++++++++----
>  arch/x86/kvm/x86.c         | 14 +++++++++-----
>  include/linux/kvm_host.h   |  1 +
>  virt/kvm/arm/arm.c         | 21 +++++++++++----------
>  virt/kvm/kvm_main.c        |  4 ++++
>  7 files changed, 43 insertions(+), 19 deletions(-)
> 

(...)

> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d9e6bf3d54f0..57c6838dff37 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3035,15 +3035,19 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
>  	return rc;
>  }
>  
> +int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
> +{
> +	if (!kvm_is_ucontrol(kvm) && !sca_can_add_vcpu(kvm, id))
> +		return -EINVAL;
> +	return 0;
> +}
> +
>  struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>  				      unsigned int id)
>  {
>  	struct kvm_vcpu *vcpu;
>  	struct sie_page *sie_page;
> -	int rc = -EINVAL;
> -
> -	if (!kvm_is_ucontrol(kvm) && !sca_can_add_vcpu(kvm, id))
> -		goto out;
> +	int rc;

You might want to make this

int rc = -ENOMEM;

instead.

>  
>  	rc = -ENOMEM;
>  

(...)

Regardless,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

