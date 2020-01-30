Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F384214DD80
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 16:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbgA3PEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 10:04:51 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20505 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727235AbgA3PEv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 10:04:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580396689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pkKUmWSBGVMkw8A8eSlIsd2aP5R5ZuYhA/V7G0cG+Nw=;
        b=RO2vkensDjgB+ZH343D1Mm3mzMNjd7pKMKLkJFjRRQAVL3iQfu9DWo/LMOy8VgbRadQ/1C
        HFt/qhfm/e6141p+/g5yTau1HVmJnfm+3XdLAIY55MliEqBZkwuuHbhnYm5ZB9nvP2AkpF
        H3eDUjhj+x/cQ9glJIy9A4zdbjjzoQU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-qh2pb6naMdu8VDrXMC_umQ-1; Thu, 30 Jan 2020 10:04:41 -0500
X-MC-Unique: qh2pb6naMdu8VDrXMC_umQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 774FB8010CB;
        Thu, 30 Jan 2020 15:04:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9989B5C1B2;
        Thu, 30 Jan 2020 15:04:36 +0000 (UTC)
Date:   Thu, 30 Jan 2020 16:04:34 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v8 2/4] selftests: KVM: Add fpu and one reg set/get
 library functions
Message-ID: <20200130150434.6ktug57ypdutbwew@kamzik.brq.redhat.com>
References: <20200129200312.3200-1-frankja@linux.ibm.com>
 <20200129200312.3200-3-frankja@linux.ibm.com>
 <72ff36e1-9170-dfb0-4050-f398f9a467eb@redhat.com>
 <20200130135512.diyyu3wvwqlwpqlx@kamzik.brq.redhat.com>
 <9d9e0e7a-b006-98b1-6bf0-8c46006835bc@linux.ibm.com>
 <20200130143008.xy6lrnrrwer6xkdp@kamzik.brq.redhat.com>
 <8095f321-0d31-1285-7fa5-a751aeb6e56f@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8095f321-0d31-1285-7fa5-a751aeb6e56f@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 30, 2020 at 03:58:46PM +0100, Janosch Frank wrote:
> On 1/30/20 3:30 PM, Andrew Jones wrote:
> > On Thu, Jan 30, 2020 at 03:10:55PM +0100, Janosch Frank wrote:
> >> On 1/30/20 2:55 PM, Andrew Jones wrote:
> >>> On Thu, Jan 30, 2020 at 11:36:21AM +0100, Thomas Huth wrote:
> >>>> On 29/01/2020 21.03, Janosch Frank wrote:
> >>>>> Add library access to more registers.
> >>>>>
> >>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >>>>> ---
> >>>>>  .../testing/selftests/kvm/include/kvm_util.h  |  6 +++
> >>>>>  tools/testing/selftests/kvm/lib/kvm_util.c    | 48 +++++++++++++++++++
> >>>>>  2 files changed, 54 insertions(+)
> >>>>>
> >>>>> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> >>>>> index 29cccaf96baf..ae0d14c2540a 100644
> >>>>> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> >>>>> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> >>>>> @@ -125,6 +125,12 @@ void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
> >>>>>  		    struct kvm_sregs *sregs);
> >>>>>  int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
> >>>>>  		    struct kvm_sregs *sregs);
> >>>>> +void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
> >>>>> +		  struct kvm_fpu *fpu);
> >>>>> +void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
> >>>>> +		  struct kvm_fpu *fpu);
> > 
> > nit: no need for the above line breaks. We don't even get to 80 char.
> > 
> >>>>> +void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
> >>>>> +void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
> >>>>>  #ifdef __KVM_HAVE_VCPU_EVENTS
> >>>>>  void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
> >>>>>  		     struct kvm_vcpu_events *events);
> >>>>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> >>>>> index 41cf45416060..dae117728ec6 100644
> >>>>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> >>>>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> >>>>> @@ -1373,6 +1373,54 @@ int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_sregs *sregs)
> >>>>>  	return ioctl(vcpu->fd, KVM_SET_SREGS, sregs);
> >>>>>  }
> >>>>>  
> >>>>> +void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
> >>>>> +{
> >>>>> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> >>>>> +	int ret;
> >>>>> +
> >>>>> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> >>>>> +
> >>>>> +	ret = ioctl(vcpu->fd, KVM_GET_FPU, fpu);
> >>>>> +	TEST_ASSERT(ret == 0, "KVM_GET_FPU failed, rc: %i errno: %i",
> >>>>> +		    ret, errno);
> >>>>> +}
> >>>>> +
> >>>>> +void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
> >>>>> +{
> >>>>> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> >>>>> +	int ret;
> >>>>> +
> >>>>> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> >>>>> +
> >>>>> +	ret = ioctl(vcpu->fd, KVM_SET_FPU, fpu);
> >>>>> +	TEST_ASSERT(ret == 0, "KVM_SET_FPU failed, rc: %i errno: %i",
> >>>>> +		    ret, errno);
> >>>>> +}
> >>>>> +
> >>>>> +void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
> >>>>> +{
> >>>>> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> >>>>> +	int ret;
> >>>>> +
> >>>>> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> >>>>> +
> >>>>> +	ret = ioctl(vcpu->fd, KVM_GET_ONE_REG, reg);
> >>>>> +	TEST_ASSERT(ret == 0, "KVM_GET_ONE_REG failed, rc: %i errno: %i",
> >>>>> +		    ret, errno);
> >>>>> +}
> >>>>> +
> >>>>> +void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
> >>>>> +{
> >>>>> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> >>>>> +	int ret;
> >>>>> +
> >>>>> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> >>>>> +
> >>>>> +	ret = ioctl(vcpu->fd, KVM_SET_ONE_REG, reg);
> >>>>> +	TEST_ASSERT(ret == 0, "KVM_SET_ONE_REG failed, rc: %i errno: %i",
> >>>>> +		    ret, errno);
> >>>>> +}
> >>>>> +
> >>>>>  /*
> >>>>>   * VCPU Ioctl
> >>>>>   *
> >>>>>
> >>>>
> >>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
> >>>>
> >>>
> >>> How about what's below instead. It should be equivalent.
> >>
> >> With your proposed changes we loose a bit verbosity in the error
> >> messages. I need to think about which I like more.
> > 
> > Looks like both error messages are missing something. The ones above are
> > missing the string version of errno. The ones below are missing the string
> > version of cmd. It's easy to add the string version of errno, which is
> > an argument for keeping the functions above (but we could at least use
> > _vcpu_ioctl to avoid duplicating the vcpu_find and vcpu!=NULL assert).
> 
> Will do
> 
> > Or, we could consider adding a kvm_ioctl_cmd_to_string() function,
> > which might be nice for other ioctl wrappers now and in the future.
> > It shouldn't be too bad to generate a string table from kvm.h, but of
> > course we'd have to keep it maintained.
> 
> I'm currently occupied with managing a lot of patches, so something like
> that is not very high on my todo list.

Yeah, no worries. We can go with a patch like this for now. I'll
experiment with a table generator when I get a chance in order to
see how ugly it gets. If it's too ugly I'll drop it too.

Thanks,
drew

