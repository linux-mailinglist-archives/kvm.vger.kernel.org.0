Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAF71526AE
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 08:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgBEHKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 02:10:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53601 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726386AbgBEHKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 02:10:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580886617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=2uXW0cOQrFrkpDRh1/5JMKx1PlGoDqI5oIr9W2mq/rM=;
        b=ZgsQ88YT3GODKdqG8TyFDHvoIZFVuNIJRgRmom+TUBWf+tmfQBo6R70SdqWRCkuDQQnKoV
        mL0fQrjvUVr6I24o9ieYqdIx5t1jwDNmuVNGjhH/4fmT0cqj7IKiH3xivQw2tfqejnf/Ps
        JYD9fpvLXHTJujqe8Xd+MaRE6kKvPAk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-7DfN-iTzON-C7mjB2RiAdg-1; Wed, 05 Feb 2020 02:10:13 -0500
X-MC-Unique: 7DfN-iTzON-C7mjB2RiAdg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 179908010F1;
        Wed,  5 Feb 2020 07:10:12 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F48A7794F;
        Wed,  5 Feb 2020 07:10:07 +0000 (UTC)
Subject: Re: [RFCv2 18/37] KVM: s390: protvirt: Implement machine-check
 interruption injection
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-19-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5f6aa608-0b02-fce6-c869-f78a81847db7@redhat.com>
Date:   Wed, 5 Feb 2020 08:10:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-19-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Michael Mueller <mimu@linux.ibm.com>
> 
> Similar to external interrupts, the hypervisor can inject machine
> checks by providing the right data in the interrupt injection controls.
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
> +		return 0;
> +	}
> +
>  	mci.val = mchk->mcic;
>  	/* take care of lazy register loading */
>  	save_fpu_regs();
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

