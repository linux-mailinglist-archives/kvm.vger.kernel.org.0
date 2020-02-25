Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8C016EC67
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 18:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbgBYRWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 12:22:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52264 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728051AbgBYRWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 12:22:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582651365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LdIdbs5RGN81tmoFvGJ30een57JB76QTG84W/9WBmJc=;
        b=Lq9Tr0JnO+LogahGU2iZqkPUniOB//GFjZEf/adAY9oaScXnhvCjkmA0EZ+VMXKAOWllsj
        15OHi7DltbN7C2zI1jRRu9frOi0WKwHpjD/HCVvkQ10kEaoT3MmA+U//DdqBiho2WkLeYy
        A3hglrJIeXho41s2bw3SsG3COJTWHYU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-M10v5gmUPjCCNNCQysKOlA-1; Tue, 25 Feb 2020 12:22:06 -0500
X-MC-Unique: M10v5gmUPjCCNNCQysKOlA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA21E1005514;
        Tue, 25 Feb 2020 17:22:04 +0000 (UTC)
Received: from gondolin (ovpn-116-60.ams2.redhat.com [10.36.116.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 061DB60BF7;
        Tue, 25 Feb 2020 17:21:59 +0000 (UTC)
Date:   Tue, 25 Feb 2020 18:21:42 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 18/36] KVM: S390: protvirt: Introduce instruction
 data area bounce buffer
Message-ID: <20200225182142.37fbf6c3.cohuck@redhat.com>
In-Reply-To: <f8d7321e-400e-ed82-471e-166a2d18ede6@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-19-borntraeger@de.ibm.com>
        <3db82b2d-ad79-8178-e027-c19889d96558@redhat.com>
        <f8d7321e-400e-ed82-471e-166a2d18ede6@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 08:50:47 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> This is the guest breaking event address. So a guest (and QEMU) can read it.
> It is kind of overlaid sida and gbea. Something like this:
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index cd81a58349a9..055bf0ec8fbb 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -39,6 +39,11 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>         vcpu->arch.sie_block->pv_handle_config = 0;
>         memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
>         vcpu->arch.sie_block->sdf = 0;
> +       /*
> +        * the sidad field (for sdf == 2) is now the gbea field (for sdf == 0).

s/the sidad/The sidad/

> +        * Use the reset value of gbea to not leak the kernel pointer of the

s/to not leak/to avoid leaking/

> +        * just free sida

s/free sida/freed sida./

> +        */
>         vcpu->arch.sie_block->gbea = 1;
>         kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>  

