Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B19181FCE
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 18:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbgCKRo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 13:44:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56969 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730258AbgCKRo2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 13:44:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583948667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Egr0Wvsijd8a/sAsIii/kuR4HDSloQdA1QBM06VTEsc=;
        b=OIeUlHsj5qzDAcuJIWpGxRv5AcMqbdE1+6ui2DcXYMSOXb52CEt8bBH1lSq4g98HClYttN
        6HMmwV7vlu0LT3dfAfvdgRg4btdV9K4UxcpcWhR6ds1RsJp2orRWj0+EI0g9G0/Y6t9ltB
        okLlXCHyFSYyXAZ+M//1t/5p76LmIAE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-44bOFiuVMQm974JqGGfxlQ-1; Wed, 11 Mar 2020 13:44:25 -0400
X-MC-Unique: 44bOFiuVMQm974JqGGfxlQ-1
Received: by mail-qt1-f197.google.com with SMTP id y3so1694501qti.15
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 10:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Egr0Wvsijd8a/sAsIii/kuR4HDSloQdA1QBM06VTEsc=;
        b=rsn1rWFjp3IhiTRbKyf3aZsneTm9L+kes1h7nNfBMORk1DIOIIk+l784+yKNcacUPW
         bZmof6MON3HKuP97SrrYreCRkuSf8kyVPDWICfn4PmIsCNs2L3Z2jFUE0JecJs9Em2dZ
         ri8v43d5mS22Cn8QmHMZF+F8OBy/EgjPsmvMoYVkpYXPuHW3BVBF31erkPFXeTt/Q3y0
         fuG1dw/da0vmoTeynRw89ypGD9POLyEekiiFvSmwdarFRcwoXpkhNYeFDdHKLT6R3yzn
         WHhfPh13W58l4kB8xj4h6Ch4RrMaBmhV6taNMbLgXr6O0SAdTnLKVRHSEzMKJ6h6odUC
         WEJA==
X-Gm-Message-State: ANhLgQ3IXn3KflXuGeu5gB1DvuiK7uLo//7zM4HzAWfnSYVZKmFFAUKQ
        pO5hmHhlJrJT8yacc9gRmeI665DmEAZMreazNrBJBbo8QHTGrxVyc8wXVbfpZ84l7+sLkrsEJBo
        d1tBUUIsSeYQc
X-Received: by 2002:ac8:45d6:: with SMTP id e22mr3754086qto.34.1583948665098;
        Wed, 11 Mar 2020 10:44:25 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvGjzKVXYRhk/h7ikNvjVRLCg8NW9Tm42+Z//BzMUUJ3eGevXv4paQogeanWo2CnV941bKdsg==
X-Received: by 2002:ac8:45d6:: with SMTP id e22mr3754054qto.34.1583948664740;
        Wed, 11 Mar 2020 10:44:24 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id d201sm5220436qke.59.2020.03.11.10.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 10:44:24 -0700 (PDT)
Date:   Wed, 11 Mar 2020 13:44:22 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v6 12/14] KVM: selftests: Add dirty ring buffer test
Message-ID: <20200311174422.GI479302@xz-x1>
References: <20200309214424.330363-1-peterx@redhat.com>
 <20200309222529.345699-1-peterx@redhat.com>
 <20200310081847.42sx5oc3q6m3wsdj@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200310081847.42sx5oc3q6m3wsdj@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 09:18:47AM +0100, Andrew Jones wrote:
> On Mon, Mar 09, 2020 at 06:25:29PM -0400, Peter Xu wrote:
> > +void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid)
> > +{
> > +	struct vcpu *vcpu;
> > +	uint32_t size = vm->dirty_ring_size;
> > +
> > +	TEST_ASSERT(size > 0, "Should enable dirty ring first");
> > +
> > +	vcpu = vcpu_find(vm, vcpuid);
> > +
> > +	TEST_ASSERT(vcpu, "Cannot find vcpu %u", vcpuid);
> > +
> > +	if (!vcpu->dirty_gfns) {
> > +		void *addr;
> > +
> > +		addr = mmap(NULL, size, PROT_READ,
> > +			    MAP_PRIVATE, vcpu->fd,
> > +			    vm->page_size * KVM_DIRTY_LOG_PAGE_OFFSET);
> > +		TEST_ASSERT(addr == MAP_FAILED, "Dirty ring mapped private");
> > +
> > +		addr = mmap(NULL, size, PROT_READ | PROT_EXEC,
> > +			    MAP_PRIVATE, vcpu->fd,
> > +			    vm->page_size * KVM_DIRTY_LOG_PAGE_OFFSET);
> > +		TEST_ASSERT(addr == MAP_FAILED, "Dirty ring mapped exec");
> > +
> > +		addr = mmap(NULL, size, PROT_READ | PROT_WRITE,
> > +			    MAP_SHARED, vcpu->fd,
> > +			    vm->page_size * KVM_DIRTY_LOG_PAGE_OFFSET);
> 
> No TEST_ASSERT for this mmap?

It'll be used (verified) later. :) Though never harm to add one!

Thanks,
> 
> > +
> > +		vcpu->dirty_gfns = addr;
> > +		vcpu->dirty_gfns_count = size / sizeof(struct kvm_dirty_gfn);
> > +	}
> > +
> > +	return vcpu->dirty_gfns;
> > +}
> 

-- 
Peter Xu

