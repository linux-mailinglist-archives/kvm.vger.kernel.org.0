Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E1E356AB0
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 13:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245250AbhDGK64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 06:58:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235067AbhDGK6z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 06:58:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617793125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/ectKhnKcoDaO3UDJhZ3amlFZtQ86PgM9l1u4tO96Zw=;
        b=Rd0zFJaJmxXepgPdkkW5jTsKzSbif1ZLEvobQmhZDYDMrU+1KIkGq+cULF/eTZI48ZwfTz
        j4tVWuYbhUW9MNKUfbYOkmeu9YHnII2S/vUvC3Ncumo7U3tBRg3sTbLsbYGRb1uJyf+wVD
        Lutb28mNlhM4AFyXAb/NsNfwsYjtfow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-w4DSsssAOOqklvgNCW5_mg-1; Wed, 07 Apr 2021 06:58:44 -0400
X-MC-Unique: w4DSsssAOOqklvgNCW5_mg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 981FA107ACF2;
        Wed,  7 Apr 2021 10:58:42 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CF8319D61;
        Wed,  7 Apr 2021 10:58:36 +0000 (UTC)
Date:   Wed, 7 Apr 2021 12:58:33 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        alexandru.elisei@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v6 9/9] KVM: selftests: aarch64/vgic-v3 init sequence
 tests
Message-ID: <20210407105833.mrs5yk4prkopqp6p@kamzik.brq.redhat.com>
References: <20210405163941.510258-1-eric.auger@redhat.com>
 <20210405163941.510258-10-eric.auger@redhat.com>
 <20210406150916.aym4eohr2mawfdkm@kamzik.brq.redhat.com>
 <3baf455d-c771-b2b7-a7ba-1cc4687054c8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3baf455d-c771-b2b7-a7ba-1cc4687054c8@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021 at 12:14:29PM +0200, Auger Eric wrote:
> >> +int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
> >> +{
> >> +	struct kvm_create_device create_dev;
> >> +	int ret;
> >> +
> >> +	create_dev.type = type;
> >> +	create_dev.fd = -1;
> >> +	create_dev.flags = test ? KVM_CREATE_DEVICE_TEST : 0;
> >> +	ret = ioctl(vm_get_fd(vm), KVM_CREATE_DEVICE, &create_dev);
> >> +	if (ret == -1)
> >> +		return -errno;
> >> +	return test ? 0 : create_dev.fd;
> > 
> > Something like this belongs in the non underscore prefixed wrappers.
> I need at least to return the create_dev.fd or do you want me to add an
> extra int *fd parameter?
> What about:
> 
>         if (ret < 0)
>                 return ret;
>         return test ? 0 : create_dev.fd;

Maybe the underscore version of kvm_create_device isn't necessary. If
the non-underscore version isn't flexible enough, then just use the
ioctl directly from the test code with its own struct kvm_create_device
Being able to call ioctls directly from test code is what vm_get_fd()
is for, otherwise you could just use vm->fd.

Thanks,
drew

