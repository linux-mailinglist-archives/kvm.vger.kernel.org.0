Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09AD16C0DA
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 13:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgBYMdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 07:33:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57966 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729309AbgBYMdE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 07:33:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582633982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pyidGy6StUinM2NXhCpEOQQBNCOY61arqyiCix83SYc=;
        b=d3kVistzqISRtU0woPTs/41MhmqFByi+YM4JCQlhUyruPZS9Av9AT6+RpkGJw0ziGKse8U
        OmUW8bwUfOjMeQqMe7IqZuYrdKuw75WiEw8bcX/8u34lQYTMTWBZ5Kl35PDuT19XgRLgqW
        LTlSC9h0OFOT6xLSe+XSw+R3gww6mV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-gTd6_eekPrKJRc-E41uDkQ-1; Tue, 25 Feb 2020 07:33:00 -0500
X-MC-Unique: gTd6_eekPrKJRc-E41uDkQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D8F69B8C4;
        Tue, 25 Feb 2020 12:32:59 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 047C79079D;
        Tue, 25 Feb 2020 12:32:54 +0000 (UTC)
Date:   Tue, 25 Feb 2020 13:32:52 +0100
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
Subject: Re: [PATCH v4 24/36] KVM: s390: protvirt: Do only reset registers
 that are accessible
Message-ID: <20200225133252.479644ea.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-25-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-25-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:40:55 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> For protected VMs the hypervisor can not access guest breaking event
> address, program parameter, bpbc and todpr. Do not reset those fields
> as the control block does not provide access to these fields.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6ab4c88f2e1d..c734e89235f9 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3499,14 +3499,16 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>  	kvm_s390_set_prefix(vcpu, 0);
>  	kvm_s390_set_cpu_timer(vcpu, 0);
>  	vcpu->arch.sie_block->ckc = 0;
> -	vcpu->arch.sie_block->todpr = 0;
>  	memset(vcpu->arch.sie_block->gcr, 0, sizeof(vcpu->arch.sie_block->gcr));
>  	vcpu->arch.sie_block->gcr[0] = CR0_INITIAL_MASK;
>  	vcpu->arch.sie_block->gcr[14] = CR14_INITIAL_MASK;
>  	vcpu->run->s.regs.fpc = 0;
> -	vcpu->arch.sie_block->gbea = 1;
> -	vcpu->arch.sie_block->pp = 0;
> -	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
> +	if (!kvm_s390_pv_cpu_is_protected(vcpu)) {
> +		vcpu->arch.sie_block->gbea = 1;
> +		vcpu->arch.sie_block->pp = 0;
> +		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
> +		vcpu->arch.sie_block->todpr = 0;

What happens if we do change those values? Is it just ignored or will
we get an exception on the next SIE entry?

> +	}
>  }
>  
>  static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)

