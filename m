Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2C02AD401
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 11:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgKJKnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 05:43:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729591AbgKJKnv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 05:43:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605005030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Srcb07t+ARpvwV5H66+PL6byfJsW4UNerf7mnUOqdY=;
        b=fBu4Q0y+OXnshv7yrYYEhUAeUjYyuXei/fYeS0bko+9lhgbQN/u8hBZ+jgwIiMNjniTgip
        ZkZHmGyyp+d9QPdlY2pc4MLytxAvmHKU0i5Cq0mrskyw5I0BKXUnXIySFifii/Wk3ttUxW
        GIFV/7fQLJRjN1Lj8bUz/9KdD+AEx3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-0LCyw6DTOi6BaX4EGHpKAw-1; Tue, 10 Nov 2020 05:43:48 -0500
X-MC-Unique: 0LCyw6DTOi6BaX4EGHpKAw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0445809DD4;
        Tue, 10 Nov 2020 10:43:46 +0000 (UTC)
Received: from gondolin (ovpn-112-243.ams2.redhat.com [10.36.112.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20BD25C1D0;
        Tue, 10 Nov 2020 10:43:41 +0000 (UTC)
Date:   Tue, 10 Nov 2020 11:43:39 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Collin Walling <walling@linux.ibm.com>
Cc:     kvm@vger.kernel.org, gor@linux.ibm.com, hca@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, frankja@linux.ibm.com,
        borntraeger@de.ibm.com
Subject: Re: [PATCH] s390/kvm: remove diag318 reset code
Message-ID: <20201110114339.3515ec7a.cohuck@redhat.com>
In-Reply-To: <20201104181032.109800-1-walling@linux.ibm.com>
References: <20201104181032.109800-1-walling@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  4 Nov 2020 13:10:32 -0500
Collin Walling <walling@linux.ibm.com> wrote:

> The diag318 data must be set to 0 by VM-wide reset events
> triggered by diag308. As such, KVM should not handle
> resetting this data via the VCPU ioctls.
> 
> Fixes: 23a60f834406 (s390/kvm: diagnose 0x318 sync and reset)

Should be

Fixes: 23a60f834406 ("s390/kvm: diagnose 0x318 sync and reset")

> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6b74b92c1a58..f9e118a0e113 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3564,7 +3564,6 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>  		vcpu->arch.sie_block->pp = 0;
>  		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
>  		vcpu->arch.sie_block->todpr = 0;
> -		vcpu->arch.sie_block->cpnc = 0;
>  	}
>  }
>  
> @@ -3582,7 +3581,6 @@ static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
>  
>  	regs->etoken = 0;
>  	regs->etoken_extension = 0;
> -	regs->diag318 = 0;
>  }
>  
>  int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)

I assume that we rely on the QEMU patch to get a completely working
setup?

