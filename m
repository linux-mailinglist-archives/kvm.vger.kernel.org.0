Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5993D1534D1
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 16:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgBEP4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 10:56:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21142 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727524AbgBEP4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 10:56:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580918159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=efV8S+DLqDmq+X1JgLrPt59ALotCaXcv3mMze6v9B9g=;
        b=ZqwV4/YrSSF7ATAfgTL8UyulatRbD3CzP+IDuVLw4V+vuq5XC55IDZDrwFsOaDANBhkYNq
        NOZen5rVrkQJMJNtmBn3Hehd0E6bwomeG2DDj5miJBMvYEN4eq6BF+i2rW7PceDgLj2e1D
        z23FIPMVLe/gAxUuWKMdgO2cgt4Dh4o=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-loPZl7wtP2qJf6_XKA1YNQ-1; Wed, 05 Feb 2020 10:55:57 -0500
X-MC-Unique: loPZl7wtP2qJf6_XKA1YNQ-1
Received: by mail-qt1-f200.google.com with SMTP id x8so1611923qtq.14
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 07:55:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=efV8S+DLqDmq+X1JgLrPt59ALotCaXcv3mMze6v9B9g=;
        b=c2bbBpU5hsNYeIZU4wotwP/yBZfBfhPQoNNk2SDfwTuzEXvyNhT/ROdfk6PfmYIfAd
         b4p2VFTedwrFs4eiTjbRLPVMpRBEUy0ADK8Nq/HUqKuwjZ9Vh+fM2LATKMWYA9mjAf+J
         6LbPmqsTKuRsIlCpjg8Jxu+jMJUONXNFIhJgCAuIE6tKZCdHd5BsMHdT2UJo6CMuyoV5
         xcpasF5St8x0XsskbKIPmKQg0YDL5fcQzChZ1yu1zz64WU6Io7chpGIa/MjRqkz+mfLL
         DttezOgz4QGAAKau4e00XY4bZsKjr9O9f9HanhU8r5VLfXkB9vQvrefmG19W0Lu8PX6w
         R0Bw==
X-Gm-Message-State: APjAAAXW2MvgE9Q/Y7rjTStmfWODYNmxldgMBoeTMqkM5dZeMype/1gq
        cmZ75jKyKU1rnuPgyPOqR1Ew/XfcpuM0jv9wPiar2z61Lkfa8Zk3I2uJYPKr2G14hUMKccqy+Cq
        rmR8ZvUgJSOM0
X-Received: by 2002:a05:620a:662:: with SMTP id a2mr35406429qkh.329.1580918155061;
        Wed, 05 Feb 2020 07:55:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqwFOamF0fw44YxctBelueuIit+7na62ANL6TulX8nNY0doj5ywuQ2bYPN4enBP7XgojeUNorQ==
X-Received: by 2002:a05:620a:662:: with SMTP id a2mr35406398qkh.329.1580918154828;
        Wed, 05 Feb 2020 07:55:54 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id w26sm14948qkj.46.2020.02.05.07.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 07:55:54 -0800 (PST)
Date:   Wed, 5 Feb 2020 10:55:51 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinechin@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jasowang@redhat.com, yan.y.zhao@intel.com,
        mst@redhat.com, kevin.tian@intel.com, alex.williamson@redhat.com,
        dgilbert@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH 13/14] KVM: selftests: Let dirty_log_test async for dirty
 ring test
Message-ID: <20200205155551.GB378317@xz-x1>
References: <20200205025105.367213-1-peterx@redhat.com>
 <20200205025842.367575-1-peterx@redhat.com>
 <20200205025842.367575-10-peterx@redhat.com>
 <20200205094806.dqkzpxhrndocjl6g@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205094806.dqkzpxhrndocjl6g@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 10:48:06AM +0100, Andrew Jones wrote:
> On Tue, Feb 04, 2020 at 09:58:41PM -0500, Peter Xu wrote:
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 4b78a8d3e773..e64fbfe6bbd5 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -115,6 +115,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
> >  struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
> >  void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
> >  int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
> > +int __vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
> >  void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
> >  void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
> >  		       struct kvm_mp_state *mp_state);
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 25edf20d1962..5137882503bd 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -1203,6 +1203,14 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
> >  	return rc;
> >  }
> >  
> > +int __vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
> > +{
> > +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> > +
> > +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> > +	return ioctl(vcpu->fd, KVM_RUN, NULL);
> > +}
> > +
> >  void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
> >  {
> >  	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> 
> I think we should add a vcpu_get_fd(vm, vcpuid) function instead, and
> then call ioctl directly from the test.

Currently the vcpu struct is still internal to the lib/ directory (as
defined in lib/kvm_util_internal.h).  Wit that, it seems the vcpu fd
should also be limited to the lib/ as well?

But I feel like I got your point, because when I worked on the
selftests I did notice that in many places it's easier to expose all
these things for test cases (e.g., the struct vcpu).  For me, it's not
only for the vcpu fd, but also for the rest of internal structures to
be able to be accessed from tests directly.  Not sure whether that's
what you thought too.  It's just a separate topic of what this series
was trying to do.

Thanks,

-- 
Peter Xu

