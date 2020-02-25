Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7665316EC5C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 18:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730911AbgBYRTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 12:19:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54051 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727983AbgBYRTv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 12:19:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582651190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SAH6kqY9E7mYFK8aweImVPbLbdNjGVvlC9LwooZVP+U=;
        b=eGZ31Tgl6HaoGHTICsjc77CuhROcF81EPTuz324hVEq1zG1ZAs0TFUmhs+E5htNkBh5YOe
        /HyxPVnKoagAscbNPGWe4xWRM5vsOXo7ZzW1WrDuLVFZWkmCSt4Y/5zZR0ptlh+Vr61qvn
        F3p0TmW+Dc4sgKQlhlUCVakmYBZBmPA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-cYvbKaVnO9OF50JTWbcGSQ-1; Tue, 25 Feb 2020 12:19:45 -0500
X-MC-Unique: cYvbKaVnO9OF50JTWbcGSQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13B758010EF;
        Tue, 25 Feb 2020 17:19:44 +0000 (UTC)
Received: from gondolin (ovpn-116-60.ams2.redhat.com [10.36.116.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2813160BF7;
        Tue, 25 Feb 2020 17:19:38 +0000 (UTC)
Date:   Tue, 25 Feb 2020 18:19:36 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 18/36] KVM: S390: protvirt: Introduce instruction
 data area bounce buffer
Message-ID: <20200225181936.7f975394.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-19-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-19-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:40:49 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Now that we can't access guest memory anymore, we have a dedicated
> satellite block that's a bounce buffer for instruction data.
> 
> We re-use the memop interface to copy the instruction data to / from
> userspace. This lets us re-use a lot of QEMU code which used that
> interface to make logical guest memory accesses which are not possible
> anymore in protected mode anyway.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 11 +++++-
>  arch/s390/kvm/kvm-s390.c         | 65 ++++++++++++++++++++++++++++----
>  arch/s390/kvm/pv.c               | 11 ++++++
>  include/uapi/linux/kvm.h         |  9 ++++-
>  4 files changed, 85 insertions(+), 11 deletions(-)
> 

(...)

> @@ -4512,8 +4540,8 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>  		if (!tmpbuf)
>  			return -ENOMEM;
>  	}
> -
> -	srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> +	if (kvm_s390_pv_cpu_is_protected(vcpu))
> +		return -EINVAL;

Doesn't that leak tmpbuf (allocated right above)? Maybe just move that
check up?

>  
>  	switch (mop->op) {
>  	case KVM_S390_MEMOP_LOGICAL_READ:

(...)

