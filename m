Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5863414DCC9
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 15:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgA3OaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 09:30:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32732 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726902AbgA3OaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 09:30:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580394618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MmFjQUn1Ue6YRCUcLyi97h4ijUQwqoRRnn2vYcYKHfA=;
        b=NklC7d3OR2ugxcbtqdnoC/foCvaxcwXofXBxqwzq2Nf7vFDkU9BZvNK06vjZNBrcNIgmLg
        4g6zS0YeMN6u1kIhPwfIhI3cK21s02e4V7OghucBtXBStL6fCDYAAfE8im8i/wHPtS5bxY
        bvBdSoRlRJ8nwIOeHCwUF95qMz4LAOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-VJsETo63MZ-6f4Qiaap_zA-1; Thu, 30 Jan 2020 09:30:16 -0500
X-MC-Unique: VJsETo63MZ-6f4Qiaap_zA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 679F1107ACC5;
        Thu, 30 Jan 2020 14:30:15 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE1051001B09;
        Thu, 30 Jan 2020 14:30:10 +0000 (UTC)
Date:   Thu, 30 Jan 2020 15:30:08 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v8 2/4] selftests: KVM: Add fpu and one reg set/get
 library functions
Message-ID: <20200130143008.xy6lrnrrwer6xkdp@kamzik.brq.redhat.com>
References: <20200129200312.3200-1-frankja@linux.ibm.com>
 <20200129200312.3200-3-frankja@linux.ibm.com>
 <72ff36e1-9170-dfb0-4050-f398f9a467eb@redhat.com>
 <20200130135512.diyyu3wvwqlwpqlx@kamzik.brq.redhat.com>
 <9d9e0e7a-b006-98b1-6bf0-8c46006835bc@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d9e0e7a-b006-98b1-6bf0-8c46006835bc@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 30, 2020 at 03:10:55PM +0100, Janosch Frank wrote:
> On 1/30/20 2:55 PM, Andrew Jones wrote:
> > On Thu, Jan 30, 2020 at 11:36:21AM +0100, Thomas Huth wrote:
> >> On 29/01/2020 21.03, Janosch Frank wrote:
> >>> Add library access to more registers.
> >>>
> >>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >>> ---
> >>>  .../testing/selftests/kvm/include/kvm_util.h  |  6 +++
> >>>  tools/testing/selftests/kvm/lib/kvm_util.c    | 48 +++++++++++++++++++
> >>>  2 files changed, 54 insertions(+)
> >>>
> >>> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> >>> index 29cccaf96baf..ae0d14c2540a 100644
> >>> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> >>> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> >>> @@ -125,6 +125,12 @@ void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
> >>>  		    struct kvm_sregs *sregs);
> >>>  int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
> >>>  		    struct kvm_sregs *sregs);
> >>> +void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
> >>> +		  struct kvm_fpu *fpu);
> >>> +void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
> >>> +		  struct kvm_fpu *fpu);

nit: no need for the above line breaks. We don't even get to 80 char.

> >>> +void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
> >>> +void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
> >>>  #ifdef __KVM_HAVE_VCPU_EVENTS
> >>>  void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
> >>>  		     struct kvm_vcpu_events *events);
> >>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> >>> index 41cf45416060..dae117728ec6 100644
> >>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> >>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> >>> @@ -1373,6 +1373,54 @@ int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_sregs *sregs)
> >>>  	return ioctl(vcpu->fd, KVM_SET_SREGS, sregs);
> >>>  }
> >>>  
> >>> +void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
> >>> +{
> >>> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> >>> +	int ret;
> >>> +
> >>> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> >>> +
> >>> +	ret = ioctl(vcpu->fd, KVM_GET_FPU, fpu);
> >>> +	TEST_ASSERT(ret == 0, "KVM_GET_FPU failed, rc: %i errno: %i",
> >>> +		    ret, errno);
> >>> +}
> >>> +
> >>> +void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
> >>> +{
> >>> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> >>> +	int ret;
> >>> +
> >>> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> >>> +
> >>> +	ret = ioctl(vcpu->fd, KVM_SET_FPU, fpu);
> >>> +	TEST_ASSERT(ret == 0, "KVM_SET_FPU failed, rc: %i errno: %i",
> >>> +		    ret, errno);
> >>> +}
> >>> +
> >>> +void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
> >>> +{
> >>> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> >>> +	int ret;
> >>> +
> >>> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> >>> +
> >>> +	ret = ioctl(vcpu->fd, KVM_GET_ONE_REG, reg);
> >>> +	TEST_ASSERT(ret == 0, "KVM_GET_ONE_REG failed, rc: %i errno: %i",
> >>> +		    ret, errno);
> >>> +}
> >>> +
> >>> +void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
> >>> +{
> >>> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> >>> +	int ret;
> >>> +
> >>> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> >>> +
> >>> +	ret = ioctl(vcpu->fd, KVM_SET_ONE_REG, reg);
> >>> +	TEST_ASSERT(ret == 0, "KVM_SET_ONE_REG failed, rc: %i errno: %i",
> >>> +		    ret, errno);
> >>> +}
> >>> +
> >>>  /*
> >>>   * VCPU Ioctl
> >>>   *
> >>>
> >>
> >> Reviewed-by: Thomas Huth <thuth@redhat.com>
> >>
> > 
> > How about what's below instead. It should be equivalent.
> 
> With your proposed changes we loose a bit verbosity in the error
> messages. I need to think about which I like more.

Looks like both error messages are missing something. The ones above are
missing the string version of errno. The ones below are missing the string
version of cmd. It's easy to add the string version of errno, which is
an argument for keeping the functions above (but we could at least use
_vcpu_ioctl to avoid duplicating the vcpu_find and vcpu!=NULL assert).
Or, we could consider adding a kvm_ioctl_cmd_to_string() function,
which might be nice for other ioctl wrappers now and in the future.
It shouldn't be too bad to generate a string table from kvm.h, but of
course we'd have to keep it maintained.

Thanks,
drew

> 
> > 
> > Thanks,
> > drew
> > 
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 29cccaf96baf..d96a072e69bf 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -125,6 +125,31 @@ void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
> >  		    struct kvm_sregs *sregs);
> >  int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
> >  		    struct kvm_sregs *sregs);
> > +
> > +static inline void
> > +vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
> > +{
> > +	vcpu_ioctl(vm, vcpuid, KVM_GET_FPU, fpu);
> > +}
> > +
> > +static inline void
> > +vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
> > +{
> > +	vcpu_ioctl(vm, vcpuid, KVM_SET_FPU, fpu);
> > +}
> > +
> > +static inline void
> > +vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
> > +{
> > +	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, reg);
> > +}
> > +
> > +static inline void
> > +vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
> > +{
> > +	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, reg);
> > +}
> > +
> >  #ifdef __KVM_HAVE_VCPU_EVENTS
> >  void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
> >  		     struct kvm_vcpu_events *events);
> > 
> 
> 



