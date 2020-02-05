Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97DCC153231
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 14:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgBENrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 08:47:18 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47777 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726308AbgBENrS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 08:47:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580910436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p6+zuwnDDKlwjzzbch5kbBJKPudTcjp9Dn0+m6WO8Xk=;
        b=Mu/zsAv6IwNLogH2CoOm91L9nDI7dFIUTtG8e4URG7Y9yHx+cpkIbq7roOWRXJVLxvPLvq
        6BITc4t1phA7pbR4g737XPR9LaV6eq5kcaMXfD2jT4L7bEKoXpH0yAC66jotdQN+6a/wth
        L5UzVcfrq4sQ2f4juK+AkDa49bXW1M4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-Jf8p76_xOiugrqSRTXRrvA-1; Wed, 05 Feb 2020 08:47:13 -0500
X-MC-Unique: Jf8p76_xOiugrqSRTXRrvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0AFBDBC4;
        Wed,  5 Feb 2020 13:47:11 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E8FA5DA7B;
        Wed,  5 Feb 2020 13:47:06 +0000 (UTC)
Date:   Wed, 5 Feb 2020 14:47:04 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 18/37] KVM: s390: protvirt: Implement machine-check
 interruption injection
Message-ID: <20200205144704.58b2c327.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-19-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-19-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:38 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Michael Mueller <mimu@linux.ibm.com>
> 
> Similar to external interrupts, the hypervisor can inject machine
> checks by providing the right data in the interrupt injection controls.

Maybe we should either merge this with the patch introducing the other
interrupt injections, or split that up into io/external/restart. It
seems slightly odd to single out machine checks here.

> 
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> ---
>  arch/s390/kvm/interrupt.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index c707725e618b..a98f1dfde8de 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -571,6 +571,14 @@ static int __write_machine_check(struct kvm_vcpu *vcpu,
>  	union mci mci;
>  	int rc;
>  
> +	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +		vcpu->arch.sie_block->iictl = IICTL_CODE_MCHK;
> +		vcpu->arch.sie_block->mcic = mchk->mcic;
> +		vcpu->arch.sie_block->faddr = mchk->failing_storage_address;
> +		vcpu->arch.sie_block->edc = mchk->ext_damage_code;

Maybe add a comment that we don't need with other machine-check related data?

> +		return 0;
> +	}
> +
>  	mci.val = mchk->mcic;
>  	/* take care of lazy register loading */
>  	save_fpu_regs();

Anyway,
Reviewed-by: Cornelia Huck <cohuck@redhat.com>

