Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849D518BD5E
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 18:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgCSRCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 13:02:12 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:28240 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727235AbgCSRCL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 13:02:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584637330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IcptVRAiRJzuVIh/GlEcDrXPm4fcrg5LC9wzz8mwMkA=;
        b=geEl7xuIRAbmZtfJQ5c/8+WklyZnkCS2BnaRMvexHhulJ8PZjt70gnPsUJu+hg6cZFXRUq
        iHKDU0s1yp3C+9Q9rJ3BKKSSd4MyE65a12sVrH9p37+TcY1YRUVTv0WwD3/yTpXTjTXxQr
        hL02sxwOEHnwxFZnsB22Qu+h4TrXjDo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-KIOvhoQNM1e3Qu63dWykMQ-1; Thu, 19 Mar 2020 13:02:09 -0400
X-MC-Unique: KIOvhoQNM1e3Qu63dWykMQ-1
Received: by mail-wr1-f70.google.com with SMTP id b12so1327720wro.4
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 10:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IcptVRAiRJzuVIh/GlEcDrXPm4fcrg5LC9wzz8mwMkA=;
        b=LE+u4QEgz5WXM8rg6ZOfQ80k9uQ9cxvPPPVEpgqq+XZUlOc95dKggN+4L6re36F9u9
         Q4JFqD9JJRnVJpZ2H75ipbnO/idZD9KhnUKEfJDj3d57bEQZhB40ZTO+BEae0qFwlxFP
         RgPmgb1uyl7zsi4FCWMqbgGuLaO65nYQNn0qKvG5pG6pLfNzLhySVuAORJA3AIlZ55Nj
         GtmjURSWPm2zZoZP5cTVuFvmVzO/q8ZmFDZBZmo/la9wafIYBC1ssZGO9z1Kl9tXNZs9
         kbf2QXpEnW6s6ITmvtwndam5hi9pe6A8cVN2PnDLia4I/Ypnnoh7Lz9OzvSilxql83NV
         Na7A==
X-Gm-Message-State: ANhLgQ3D1FVXCISbWffsU2CwCciGU0zVy8mHBj+GJxjm1eFirobUCI0X
        5YFn96M0OEylxRVsXPuclIvwI/jDSahYvEn07lkZzrN+52CYW+04HaKrV2U1JvZsb+KYs1bHUQ5
        mnwvFQChtosKP
X-Received: by 2002:a1c:41d6:: with SMTP id o205mr4782576wma.122.1584637327684;
        Thu, 19 Mar 2020 10:02:07 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsi9VPiZWxLt0oHTo1rX4JelGxRAWlaC5KYb5zXFBMD8y3tgBSoJTkpKrPnAHuKniGG0Q9H/w==
X-Received: by 2002:a1c:41d6:: with SMTP id o205mr4782450wma.122.1584637326515;
        Thu, 19 Mar 2020 10:02:06 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id e9sm4186074wrw.30.2020.03.19.10.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 10:02:05 -0700 (PDT)
Date:   Thu, 19 Mar 2020 13:02:01 -0400
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 12/14] KVM: selftests: Add dirty ring buffer test
Message-ID: <20200319170201.GC127076@xz-x1>
References: <20200318163720.93929-1-peterx@redhat.com>
 <20200318163720.93929-13-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200318163720.93929-13-peterx@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 18, 2020 at 12:37:18PM -0400, Peter Xu wrote:
> +static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
> +					   void *bitmap, uint32_t num_pages)
> +{
> +	/* We only have one vcpu */
> +	static uint32_t fetch_index = 0;
> +	uint32_t count = 0, cleared;
> +
> +	/*
> +	 * Before fetching the dirty pages, we need a vmexit of the
> +	 * worker vcpu to make sure the hardware dirty buffers were
> +	 * flushed.  This is not needed for dirty-log/clear-log tests
> +	 * because get dirty log will natually do so.
> +	 *
> +	 * For now we do it in the simple way - we simply wait until
> +	 * the vcpu uses up the soft dirty ring, then it'll always
> +	 * do a vmexit to make sure that PML buffers will be flushed.
> +	 * In real hypervisors, we probably need a vcpu kick or to
> +	 * stop the vcpus (before the final sync) to make sure we'll
> +	 * get all the existing dirty PFNs even cached in hardware.
> +	 */
> +	sem_wait(&dirty_ring_vcpu_stop);
> +
> +	/* Only have one vcpu */
> +	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vm, VCPU_ID),
> +				       slot, bitmap, num_pages, &fetch_index);
> +
> +	cleared = kvm_vm_reset_dirty_ring(vm);
> +
> +	/* Cleared pages should be the same as collected */
> +	TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
> +		    "with collected (%u)", cleared, count);
> +
> +	DEBUG("Notifying vcpu to continue\n");

This line is removed later so hidden from my eyes too... but it'll
also break the bisection.  Fixed now.

> +	sem_post(&dirty_ring_vcpu_cont);
> +
> +	pr_info("Iteration %ld collected %u pages\n", iteration, count);
> +}

-- 
Peter Xu

