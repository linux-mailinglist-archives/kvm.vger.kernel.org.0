Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7B51528A1
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 10:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgBEJsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 04:48:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54966 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728035AbgBEJsY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 04:48:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580896103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iYOL7XjTIAxW01ootqLvfDzjCPh14aTGE/Ook11e7A0=;
        b=UNbpnarT5+A1istX5vI7opKJPcqfAMOY2sWXrJ01YiGeQFSD5vc+zwklKw6xMNMb8cqWPf
        qiNAe2CdCqbqCbKn1jdRtdeWBzcKH0KLJQqgmR/C1PZTjJUIe1O/pM4hWaEmsCRBlYSMCY
        cDi8k1laaY/Tpu4m9oKddS2qa86EBwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-APXccsL3OvOt2wEVi3WyLQ-1; Wed, 05 Feb 2020 04:48:22 -0500
X-MC-Unique: APXccsL3OvOt2wEVi3WyLQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6B2318FE860;
        Wed,  5 Feb 2020 09:48:20 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 313B51BC6D;
        Wed,  5 Feb 2020 09:48:08 +0000 (UTC)
Date:   Wed, 5 Feb 2020 10:48:06 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinechin@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jasowang@redhat.com, yan.y.zhao@intel.com,
        mst@redhat.com, kevin.tian@intel.com, alex.williamson@redhat.com,
        dgilbert@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH 13/14] KVM: selftests: Let dirty_log_test async for dirty
 ring test
Message-ID: <20200205094806.dqkzpxhrndocjl6g@kamzik.brq.redhat.com>
References: <20200205025105.367213-1-peterx@redhat.com>
 <20200205025842.367575-1-peterx@redhat.com>
 <20200205025842.367575-10-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205025842.367575-10-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 04, 2020 at 09:58:41PM -0500, Peter Xu wrote:
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 4b78a8d3e773..e64fbfe6bbd5 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -115,6 +115,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
>  struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
>  void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
>  int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
> +int __vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
>  void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
>  void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
>  		       struct kvm_mp_state *mp_state);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 25edf20d1962..5137882503bd 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1203,6 +1203,14 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
>  	return rc;
>  }
>  
> +int __vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +
> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> +	return ioctl(vcpu->fd, KVM_RUN, NULL);
> +}
> +
>  void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
>  {
>  	struct vcpu *vcpu = vcpu_find(vm, vcpuid);

I think we should add a vcpu_get_fd(vm, vcpuid) function instead, and
then call ioctl directly from the test.

Thanks,
drew

