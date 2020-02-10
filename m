Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE051157A6D
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 14:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgBJNWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 08:22:46 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23543 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730579AbgBJNWo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 08:22:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581340964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=urtYv4r0ez3DNqfz1hZa3OgXNg9PoeUvWLlLEPrgRcE=;
        b=hJ2bT9XXauKe1BQbpmXPD10BeovCJFGZSQTLXd/G/x7+WAXThylWf4dZOnHYDX9EGpKMT6
        pIStH4e/Kdx8HeC/33ZiII2roTx6X9AZhA5BunlBdLSG4wxCcY+Zp94BIzsl6wfoHPNyn+
        rJxUCX3fFxfxNRNSYPy9IYMdn/Iwq7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-KLj4eCPrO_q33aHYXCgAMg-1; Mon, 10 Feb 2020 08:22:39 -0500
X-MC-Unique: KLj4eCPrO_q33aHYXCgAMg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E13328018A4;
        Mon, 10 Feb 2020 13:22:37 +0000 (UTC)
Received: from gondolin (ovpn-117-244.ams2.redhat.com [10.36.117.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FBF05D9C9;
        Mon, 10 Feb 2020 13:22:32 +0000 (UTC)
Date:   Mon, 10 Feb 2020 14:22:29 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 31/35] KVM: s390: protvirt: Add UV debug trace
Message-ID: <20200210142229.41da20dd.cohuck@redhat.com>
In-Reply-To: <20200207113958.7320-32-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-32-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Feb 2020 06:39:54 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Let's have some debug traces which stay around for longer than the
> guest.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c |  9 ++++++++-
>  arch/s390/kvm/kvm-s390.h |  9 +++++++++
>  arch/s390/kvm/pv.c       | 20 +++++++++++++++++++-
>  3 files changed, 36 insertions(+), 2 deletions(-)
(...)
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index a58f5106ba5f..da281d8dcc92 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -74,6 +74,8 @@ int kvm_s390_pv_destroy_vm(struct kvm *kvm)
>  	atomic_set(&kvm->mm->context.is_protected, 0);
>  	VM_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x",
>  		 ret >> 16, ret & 0x0000ffff);
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x",
> +		 ret >> 16, ret & 0x0000ffff);
>  	return rc;
>  }
>  
> @@ -89,6 +91,8 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
>  
>  		VCPU_EVENT(vcpu, 3, "PROTVIRT DESTROY VCPU: cpu %d rc %x rrc %x",
>  			   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);

I think these should drop the vcpu_id, as VCPU_EVENT already includes
it (in the patch introducing them).

> +		KVM_UV_EVENT(vcpu->kvm, 3, "PROTVIRT DESTROY VCPU: cpu %d rc %x rrc %x",
> +			     vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
>  	}
>  
>  	free_pages(vcpu->arch.pv.stor_base,

Otherwise, looks good.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

