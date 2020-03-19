Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5DB718BCB8
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 17:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgCSQh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 12:37:29 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:57364 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727792AbgCSQh3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 12:37:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584635848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hR8Y6gecjZrE7xBWomQNbLoun26uhWBNW6utFZRF+ls=;
        b=HUxsV7eBjzJNqLWjDYUHVLUq3a+XnXfD3xJ/f8n5m3WP80pMPrvYNX9NmJnBSJHclTCpT+
        L652wThPHAZJ5AvKRx/S+RJWvOixXHiletNlgv5LaJqkKxKV6JA/6vh8xOUMDzGJzGIk1f
        ZEgwrBOOa9FdEcD6/92wfAtqLhppWfE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-WaXwiBA8OYiC4kt8_QEqCg-1; Thu, 19 Mar 2020 12:37:26 -0400
X-MC-Unique: WaXwiBA8OYiC4kt8_QEqCg-1
Received: by mail-wr1-f69.google.com with SMTP id u18so1269040wrn.11
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 09:37:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hR8Y6gecjZrE7xBWomQNbLoun26uhWBNW6utFZRF+ls=;
        b=milNkfS7yVGkdDCxzI5YcJHLeL1bLTcOehQ++PGRVWCRi10XRV81RAdvUg7iHIabgU
         +x86FAe47JkjkeaeXUxbU0HnH7C02RONhIOkp5hWmRMYEUX1eL2K5A23mqklK7jdezsN
         /TzTM/6fkqSWXG+SRa95rZ+eUarGk4OvBhJLs2yaOrp/hCGazBaymwMTLOPPkHRf9P/P
         hvLybBSmNAHqpVZpdFHysdHK54o0l9hCS94EuOFfD9e62q+dAByYV3DU4F795OUI9+BI
         s0eFdBdhOnzzHvhUH6E+mFE1zNuLfnEkJNpYLP8ZnwaTg3UChens46IhtG78Qtzt8faT
         lX1g==
X-Gm-Message-State: ANhLgQ1QG21U1XNiDmzxpaWN7dnmnBfvnhI5sZ04lmVHw7NLjqG3UN86
        NkhCSsS6sr00zkquv7G61bkMPlL12CdIZ+Npb34MUzrMaMz95gs2RRUYMYwZntqZRW+hIYa4TPw
        Nu/rkuNd3Vkxt
X-Received: by 2002:a1c:1d4d:: with SMTP id d74mr4601645wmd.123.1584635845600;
        Thu, 19 Mar 2020 09:37:25 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vubCFzjFjD0GRxT785xTwPdhO0M6RD6kmE9LKXB+pkLtlVm/YrjzoB6HgGKv88zSl7xxa+cUg==
X-Received: by 2002:a1c:1d4d:: with SMTP id d74mr4601627wmd.123.1584635845397;
        Thu, 19 Mar 2020 09:37:25 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id u204sm3730666wmg.40.2020.03.19.09.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 09:37:24 -0700 (PDT)
Date:   Thu, 19 Mar 2020 12:37:20 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 11/14] KVM: selftests: Introduce after_vcpu_run hook
 for dirty log test
Message-ID: <20200319163720.GB127076@xz-x1>
References: <20200318163720.93929-1-peterx@redhat.com>
 <20200318163720.93929-12-peterx@redhat.com>
 <20200319075005.hdddb4xiqzuxcqbn@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200319075005.hdddb4xiqzuxcqbn@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 08:50:05AM +0100, Andrew Jones wrote:
> >  static void generate_random_array(uint64_t *guest_array, uint64_t size)
> >  {
> >  	uint64_t i;
> > @@ -261,25 +282,23 @@ static void *vcpu_worker(void *data)
> >  	struct kvm_vm *vm = data;
> >  	uint64_t *guest_array;
> >  	uint64_t pages_count = 0;
> > -	struct kvm_run *run;
> > +	struct sigaction sigact;
> >  
> > -	run = vcpu_state(vm, VCPU_ID);
> > +	current_vm = vm;
> > +	vcpu_fd = vcpu_get_fd(vm, VCPU_ID);
> 
> You don't add this call until 13/14, which means bisection is broken.
> Please test the series with 'git rebase -i -x make'.

You're right... I do per-patch test but only for the initial version,
then I test the fixups as standalone changes for latter versions.
This must be a wrongly squashed fixup into the wrong patch.  Sorry.

I'll wait for some more time for another repost.  Thanks,

-- 
Peter Xu

