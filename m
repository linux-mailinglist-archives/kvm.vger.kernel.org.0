Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB6514D91C
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 11:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgA3Kgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 05:36:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32658 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726902AbgA3Kgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 05:36:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580380594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=kqpfWHH6cs7r1URnnLrdKX7MJrDrbvYi5ON1uCiC0II=;
        b=aRCFpEl2glcSGVqeyk0YQWA4sM8vvzaHHyFAg0hCZDIN9S4io457TmDe9+5x/jTL5UlvD9
        PDmwHRLxahdlyxATsst2Trl9kuTODIedZAWSok3fbuqKamrfpibgVqfNiYQfp0CNdGkkQ5
        lxeHuGrNubSnsYWXgbiKgsUsFKaLXNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-vBa5KoQXN6CYCeJ0gmIWDw-1; Thu, 30 Jan 2020 05:36:30 -0500
X-MC-Unique: vBa5KoQXN6CYCeJ0gmIWDw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EE5618CA240;
        Thu, 30 Jan 2020 10:36:29 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-117.ams2.redhat.com [10.36.117.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E54B25DA75;
        Thu, 30 Jan 2020 10:36:22 +0000 (UTC)
Subject: Re: [PATCH v8 2/4] selftests: KVM: Add fpu and one reg set/get
 library functions
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, Andrew Jones <drjones@redhat.com>
References: <20200129200312.3200-1-frankja@linux.ibm.com>
 <20200129200312.3200-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <72ff36e1-9170-dfb0-4050-f398f9a467eb@redhat.com>
Date:   Thu, 30 Jan 2020 11:36:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200129200312.3200-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/01/2020 21.03, Janosch Frank wrote:
> Add library access to more registers.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  6 +++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 48 +++++++++++++++++++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 29cccaf96baf..ae0d14c2540a 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -125,6 +125,12 @@ void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
>  		    struct kvm_sregs *sregs);
>  int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
>  		    struct kvm_sregs *sregs);
> +void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
> +		  struct kvm_fpu *fpu);
> +void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
> +		  struct kvm_fpu *fpu);
> +void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
> +void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
>  #ifdef __KVM_HAVE_VCPU_EVENTS
>  void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
>  		     struct kvm_vcpu_events *events);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 41cf45416060..dae117728ec6 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1373,6 +1373,54 @@ int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_sregs *sregs)
>  	return ioctl(vcpu->fd, KVM_SET_SREGS, sregs);
>  }
>  
> +void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +	int ret;
> +
> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> +
> +	ret = ioctl(vcpu->fd, KVM_GET_FPU, fpu);
> +	TEST_ASSERT(ret == 0, "KVM_GET_FPU failed, rc: %i errno: %i",
> +		    ret, errno);
> +}
> +
> +void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +	int ret;
> +
> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> +
> +	ret = ioctl(vcpu->fd, KVM_SET_FPU, fpu);
> +	TEST_ASSERT(ret == 0, "KVM_SET_FPU failed, rc: %i errno: %i",
> +		    ret, errno);
> +}
> +
> +void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +	int ret;
> +
> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> +
> +	ret = ioctl(vcpu->fd, KVM_GET_ONE_REG, reg);
> +	TEST_ASSERT(ret == 0, "KVM_GET_ONE_REG failed, rc: %i errno: %i",
> +		    ret, errno);
> +}
> +
> +void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +	int ret;
> +
> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> +
> +	ret = ioctl(vcpu->fd, KVM_SET_ONE_REG, reg);
> +	TEST_ASSERT(ret == 0, "KVM_SET_ONE_REG failed, rc: %i errno: %i",
> +		    ret, errno);
> +}
> +
>  /*
>   * VCPU Ioctl
>   *
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

