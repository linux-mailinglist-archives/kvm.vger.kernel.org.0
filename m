Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C1A14DC5A
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgA3Nz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:55:26 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45313 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726980AbgA3Nz0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 08:55:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580392524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+EXk8OXVdMDsV+XpCPUKmuRviNu+cx7h797kYCqOnVw=;
        b=c6OwXYDVj92WXsxy0lfTDyf8a6NIz2EGIBbuJir0vIF2qAe02mikMHZ2lZcgC+3cu9ZXmz
        /eD9lQ8Zld2PJ3+S0eEDhT5zJ/kR1lD07s5G7z8QnEIspJa/1BAJpVqwtJUAkFsEwA7Y0Y
        +bkYwwNIVfN4sGfLKZ1ep6h0wn2jTpQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-i7kIqlv6PCWdd1MQC77sVw-1; Thu, 30 Jan 2020 08:55:19 -0500
X-MC-Unique: i7kIqlv6PCWdd1MQC77sVw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8198100550E;
        Thu, 30 Jan 2020 13:55:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF1471001B09;
        Thu, 30 Jan 2020 13:55:14 +0000 (UTC)
Date:   Thu, 30 Jan 2020 14:55:12 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v8 2/4] selftests: KVM: Add fpu and one reg set/get
 library functions
Message-ID: <20200130135512.diyyu3wvwqlwpqlx@kamzik.brq.redhat.com>
References: <20200129200312.3200-1-frankja@linux.ibm.com>
 <20200129200312.3200-3-frankja@linux.ibm.com>
 <72ff36e1-9170-dfb0-4050-f398f9a467eb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72ff36e1-9170-dfb0-4050-f398f9a467eb@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 30, 2020 at 11:36:21AM +0100, Thomas Huth wrote:
> On 29/01/2020 21.03, Janosch Frank wrote:
> > Add library access to more registers.
> > 
> > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> >  .../testing/selftests/kvm/include/kvm_util.h  |  6 +++
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 48 +++++++++++++++++++
> >  2 files changed, 54 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 29cccaf96baf..ae0d14c2540a 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -125,6 +125,12 @@ void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
> >  		    struct kvm_sregs *sregs);
> >  int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
> >  		    struct kvm_sregs *sregs);
> > +void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
> > +		  struct kvm_fpu *fpu);
> > +void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
> > +		  struct kvm_fpu *fpu);
> > +void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
> > +void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
> >  #ifdef __KVM_HAVE_VCPU_EVENTS
> >  void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
> >  		     struct kvm_vcpu_events *events);
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 41cf45416060..dae117728ec6 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -1373,6 +1373,54 @@ int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_sregs *sregs)
> >  	return ioctl(vcpu->fd, KVM_SET_SREGS, sregs);
> >  }
> >  
> > +void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
> > +{
> > +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> > +	int ret;
> > +
> > +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> > +
> > +	ret = ioctl(vcpu->fd, KVM_GET_FPU, fpu);
> > +	TEST_ASSERT(ret == 0, "KVM_GET_FPU failed, rc: %i errno: %i",
> > +		    ret, errno);
> > +}
> > +
> > +void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
> > +{
> > +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> > +	int ret;
> > +
> > +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> > +
> > +	ret = ioctl(vcpu->fd, KVM_SET_FPU, fpu);
> > +	TEST_ASSERT(ret == 0, "KVM_SET_FPU failed, rc: %i errno: %i",
> > +		    ret, errno);
> > +}
> > +
> > +void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
> > +{
> > +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> > +	int ret;
> > +
> > +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> > +
> > +	ret = ioctl(vcpu->fd, KVM_GET_ONE_REG, reg);
> > +	TEST_ASSERT(ret == 0, "KVM_GET_ONE_REG failed, rc: %i errno: %i",
> > +		    ret, errno);
> > +}
> > +
> > +void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
> > +{
> > +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> > +	int ret;
> > +
> > +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> > +
> > +	ret = ioctl(vcpu->fd, KVM_SET_ONE_REG, reg);
> > +	TEST_ASSERT(ret == 0, "KVM_SET_ONE_REG failed, rc: %i errno: %i",
> > +		    ret, errno);
> > +}
> > +
> >  /*
> >   * VCPU Ioctl
> >   *
> > 
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>

How about what's below instead. It should be equivalent.

Thanks,
drew

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 29cccaf96baf..d96a072e69bf 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -125,6 +125,31 @@ void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
 		    struct kvm_sregs *sregs);
 int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
 		    struct kvm_sregs *sregs);
+
+static inline void
+vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_FPU, fpu);
+}
+
+static inline void
+vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_FPU, fpu);
+}
+
+static inline void
+vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, reg);
+}
+
+static inline void
+vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, reg);
+}
+
 #ifdef __KVM_HAVE_VCPU_EVENTS
 void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
 		     struct kvm_vcpu_events *events);

