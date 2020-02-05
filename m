Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B0515333B
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgBEOms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:42:48 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41954 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726308AbgBEOms (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 09:42:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580913767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SjPSSuVkfj1bPqFrA3edTkwRFepWFmIr8RSbFmPzoeU=;
        b=QZoNCucjGhRpdISGos0Z8h2jcbFWP4E+CBxKnnJX7jF2lgsy3E9SPmSaFIWmq6h41EOOFJ
        VciN6Ra3oUwjY/wZbHt1JUe1GHa/u6RJOBE0O8vWhkR14BdfP+pvjJR+JXt3y7dBCZdpS3
        zMnfM63gRN1l+mP30qheSvFveZEil3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-zWZSeWJYMO26wEVCbxo5bg-1; Wed, 05 Feb 2020 09:42:43 -0500
X-MC-Unique: zWZSeWJYMO26wEVCbxo5bg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56F6F800D6C;
        Wed,  5 Feb 2020 14:42:42 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A8171001B05;
        Wed,  5 Feb 2020 14:42:38 +0000 (UTC)
Date:   Wed, 5 Feb 2020 15:42:35 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 26/37] KVM: s390: protvirt: disallow one_reg
Message-ID: <20200205154235.13255eb3.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-27-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-27-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:46 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> A lot of the registers are controlled by the Ultravisor and never
> visible to KVM. Some fields in the sie control block are overlayed,
> like gbea. As no userspace uses the ONE_REG interface on s390 it is safe
> to disable this for protected guests.

Hm, QEMU seems to fall back to ONE_REG if sync regs are not available,
doesn't it? So maybe it would be better to word this as

"As no known userspace uses the ONE_REG interface on s390 if sync regs
are available, no functionality is lost if it is disabled for protected
guests."

?

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6e74c7afae3a..b9692d722c1e 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4641,6 +4641,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	case KVM_SET_ONE_REG:
>  	case KVM_GET_ONE_REG: {
>  		struct kvm_one_reg reg;
> +		r = -EINVAL;
> +		if (kvm_s390_pv_is_protected(vcpu->kvm))
> +			break;
>  		r = -EFAULT;
>  		if (copy_from_user(&reg, argp, sizeof(reg)))
>  			break;

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

