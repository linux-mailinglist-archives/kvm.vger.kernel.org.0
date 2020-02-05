Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F2F15361B
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 18:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgBERPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 12:15:44 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51876 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726957AbgBERPn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 12:15:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580922942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i/fvcosY8fRo4ERPbKWIeYDN1mwqZhnrYMnwOUyDV6k=;
        b=jItTeeqZ/MhF3GtkpjFBafoKEIF7vnfhWwf+c7Mju1VP9AUojQupnWWT4DvGBvz5JcBg36
        6ewVOa3BPU0kpv2fiUQ+/QsM8LwBlAVMGoTD49RFDpVcG8wPPSdKHiDQglZvkJYb2RAu5w
        XT0Bw4YsoCyoti+gCtCtjkH/K5eplTA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-LaOJTlB0PmeDY5VEkGCHRw-1; Wed, 05 Feb 2020 12:15:39 -0500
X-MC-Unique: LaOJTlB0PmeDY5VEkGCHRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC9D610CE789;
        Wed,  5 Feb 2020 17:15:36 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFA66213F;
        Wed,  5 Feb 2020 17:15:24 +0000 (UTC)
Date:   Wed, 5 Feb 2020 18:15:21 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinechin@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jasowang@redhat.com, yan.y.zhao@intel.com,
        mst@redhat.com, kevin.tian@intel.com, alex.williamson@redhat.com,
        dgilbert@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH 13/14] KVM: selftests: Let dirty_log_test async for dirty
 ring test
Message-ID: <20200205171521.nh2yz7lal7pmcpai@kamzik.brq.redhat.com>
References: <20200205025105.367213-1-peterx@redhat.com>
 <20200205025842.367575-1-peterx@redhat.com>
 <20200205025842.367575-10-peterx@redhat.com>
 <20200205094806.dqkzpxhrndocjl6g@kamzik.brq.redhat.com>
 <20200205155551.GB378317@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205155551.GB378317@xz-x1>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 10:55:51AM -0500, Peter Xu wrote:
> On Wed, Feb 05, 2020 at 10:48:06AM +0100, Andrew Jones wrote:
> > On Tue, Feb 04, 2020 at 09:58:41PM -0500, Peter Xu wrote:
> > > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > > index 4b78a8d3e773..e64fbfe6bbd5 100644
> > > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > > @@ -115,6 +115,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
> > >  struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
> > >  void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
> > >  int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
> > > +int __vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
> > >  void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
> > >  void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
> > >  		       struct kvm_mp_state *mp_state);
> > > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > index 25edf20d1962..5137882503bd 100644
> > > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > @@ -1203,6 +1203,14 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
> > >  	return rc;
> > >  }
> > >  
> > > +int __vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
> > > +{
> > > +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> > > +
> > > +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> > > +	return ioctl(vcpu->fd, KVM_RUN, NULL);
> > > +}
> > > +
> > >  void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
> > >  {
> > >  	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> > 
> > I think we should add a vcpu_get_fd(vm, vcpuid) function instead, and
> > then call ioctl directly from the test.
> 
> Currently the vcpu struct is still internal to the lib/ directory (as
> defined in lib/kvm_util_internal.h).  Wit that, it seems the vcpu fd
> should also be limited to the lib/ as well?
> 
> But I feel like I got your point, because when I worked on the
> selftests I did notice that in many places it's easier to expose all
> these things for test cases (e.g., the struct vcpu).  For me, it's not
> only for the vcpu fd, but also for the rest of internal structures to
> be able to be accessed from tests directly.  Not sure whether that's
> what you thought too.  It's just a separate topic of what this series
> was trying to do.

So far I've just wished I could get to the fd, which seems reasonable
since it's an fd. I agree the whole internal thing is probably
unnecessary, but nobody (including me) has complained enough yet to
undo it. For this patch series I'd prefer we start heading in the
expose more direction, than in the yet another variant of vcpu_run
direction though.

Thanks,
drew

