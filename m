Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26BC716FB8D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 11:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgBZKB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 05:01:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34778 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726936AbgBZKB7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 05:01:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582711318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WQzA3mK4mHtYXw0jrMCpxXNAFmo6TM/Bwek6CpY7xvI=;
        b=ew7N13U/C9pfrQ4vLZWhrq9s3O01cYUHLtKA4OTYQo4SqfWoRLCZ6rhWvP+RpnacNzqsJv
        J/gSWaFNX22HOkzchHIxa8Os/Fg+HqLh/9xO2hRIjPmo95jHz2WpVFvGUWywsvtF3z9Rc8
        GvjtA0dfLKWDszOrh0M/OLTgMYzZSKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-FN-vSzuBPSmNK0WO_TV_MQ-1; Wed, 26 Feb 2020 05:01:54 -0500
X-MC-Unique: FN-vSzuBPSmNK0WO_TV_MQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A25F8107ACCA;
        Wed, 26 Feb 2020 10:01:52 +0000 (UTC)
Received: from gondolin (ovpn-117-69.ams2.redhat.com [10.36.117.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA1C35D9CD;
        Wed, 26 Feb 2020 10:01:47 +0000 (UTC)
Date:   Wed, 26 Feb 2020 11:01:44 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     david@redhat.com, Ulrich.Weigand@de.ibm.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v4.5 09/36] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
Message-ID: <20200226110144.4677ac60.cohuck@redhat.com>
In-Reply-To: <20200225214822.3611-1-borntraeger@de.ibm.com>
References: <f80a0b58-5ed2-33b7-5292-2c4899d765b7@redhat.com>
        <20200225214822.3611-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 16:48:22 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> This contains 3 main changes:
> 1. changes in SIE control block handling for secure guests
> 2. helper functions for create/destroy/unpack secure guests
> 3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
> machines
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  24 ++-
>  arch/s390/include/asm/uv.h       |  69 ++++++++
>  arch/s390/kvm/Makefile           |   2 +-
>  arch/s390/kvm/kvm-s390.c         | 209 +++++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.h         |  33 ++++
>  arch/s390/kvm/pv.c               | 269 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h         |  31 ++++
>  7 files changed, 633 insertions(+), 4 deletions(-)
>  create mode 100644 arch/s390/kvm/pv.c

(...)

> @@ -2165,6 +2168,160 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
>  	return r;
>  }
>  
> +static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
> +{
> +	struct kvm_vcpu *vcpu;
> +	u16 rc, rrc;
> +	int ret = 0;
> +	int i;
> +
> +	/*
> +	 * We ignore failures and try to destroy as many CPUs as possible.

What is this 'destroying'? Is that really the right terminology? From a
quick glance, I would expect something more in the vein of cpu
unplugging, and I don't think that's what is happening here.

(I have obviously not yet read the whole thing, please give people some
more time to review this huge patch.)

> +	 * At the same time we must not free the assigned resources when
> +	 * this fails, as the ultravisor has still access to that memory.
> +	 * So kvm_s390_pv_destroy_cpu can leave a "wanted" memory leak
> +	 * behind.
> +	 * We want to return the first failure rc and rrc, though.
> +	 */
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		mutex_lock(&vcpu->mutex);
> +		if (kvm_s390_pv_destroy_cpu(vcpu, &rc, &rrc) && !ret) {
> +			*rcp = rc;
> +			*rrcp = rrc;
> +			ret = -EIO;
> +		}
> +		mutex_unlock(&vcpu->mutex);
> +	}
> +	return ret;
> +}
> +
> +static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
> +{
> +	int i, r = 0;
> +	u16 dummy;
> +
> +	struct kvm_vcpu *vcpu;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		mutex_lock(&vcpu->mutex);
> +		r = kvm_s390_pv_create_cpu(vcpu, rc, rrc);
> +		mutex_unlock(&vcpu->mutex);
> +		if (r)
> +			break;
> +	}
> +	if (r)
> +		kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);

This is a rather unlikely case, so we don't need to optimize this,
right?

Would rc/rrc from the rollback contain anything of interest if the
create fails (that is, anything more interesting than what that
function returns?

Similar comment for the 'create' as for the 'destroy' above. (Not
trying to nitpick, just a bit confused.)

Or is that not the cpu that is created/destroyed, but something else?
Sorry, just trying to understand where this is coming from.

> +	return r;
> +}

(...)

Will look at the remainder of the patch later, maybe I understand the
stuff above better after that.

