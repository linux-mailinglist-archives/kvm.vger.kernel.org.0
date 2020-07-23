Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCA922AD16
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 12:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgGWK6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 06:58:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27374 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727828AbgGWK6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 06:58:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595501917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PfG3ve6iRrlNztYi1/RA/UBDyRPWHXgvKQCPFhLt5hk=;
        b=CTAUMbkvf2GBwXgq8eW+2uWok5jdEaOaztE1ExRaPXFZXm/ognsrrnPZcTdZXGQu5lKheF
        K0btpu9pyYLX0U+EZMeeD+4ZSZ/uGCc7MTuDBIxVVqg8b93D4B1/hHjLWtxF/GbCJ2C7mP
        LjJlwcfzY43FKZS5VlBai4RMSO91V5g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-dL7rJIpKOHiZGAeuUBAbpg-1; Thu, 23 Jul 2020 06:58:35 -0400
X-MC-Unique: dL7rJIpKOHiZGAeuUBAbpg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42F481005510;
        Thu, 23 Jul 2020 10:58:33 +0000 (UTC)
Received: from gondolin (ovpn-112-228.ams2.redhat.com [10.36.112.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9268A69320;
        Thu, 23 Jul 2020 10:58:26 +0000 (UTC)
Date:   Thu, 23 Jul 2020 12:58:24 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc:     mpe@ellerman.id.au, paulus@samba.org, david@gibson.dropbear.id.au,
        mikey@neuling.org, npiggin@gmail.com, pbonzini@redhat.com,
        christophe.leroy@c-s.fr, jniethe5@gmail.com, pedromfc@br.ibm.com,
        rogealve@br.ibm.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] ppc: Enable 2nd DAWR support on p10
Message-ID: <20200723125824.52383e32.cohuck@redhat.com>
In-Reply-To: <20200723104220.314671-3-ravi.bangoria@linux.ibm.com>
References: <20200723104220.314671-1-ravi.bangoria@linux.ibm.com>
        <20200723104220.314671-3-ravi.bangoria@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jul 2020 16:12:20 +0530
Ravi Bangoria <ravi.bangoria@linux.ibm.com> wrote:

> As per the PAPR, bit 0 of byte 64 in pa-features property indicates
> availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
> DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to
> find whether kvm supports 2nd DAWR or nor. If it's supported, set
> the pa-feature bit in guest DT so the guest kernel can support 2nd
> DAWR.
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> ---
>  hw/ppc/spapr.c                  | 33 +++++++++++++++++++++++++++++++++
>  include/hw/ppc/spapr.h          |  1 +
>  linux-headers/asm-powerpc/kvm.h |  4 ++++
>  linux-headers/linux/kvm.h       |  1 +
>  target/ppc/cpu.h                |  2 ++
>  target/ppc/kvm.c                |  7 +++++++
>  target/ppc/kvm_ppc.h            |  6 ++++++
>  target/ppc/translate_init.inc.c | 17 ++++++++++++++++-
>  8 files changed, 70 insertions(+), 1 deletion(-)
> 

(...)

> diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
> index 38d61b73f5..c5c0f128b4 100644
> --- a/linux-headers/asm-powerpc/kvm.h
> +++ b/linux-headers/asm-powerpc/kvm.h
> @@ -640,6 +640,10 @@ struct kvm_ppc_cpu_char {
>  #define KVM_REG_PPC_ONLINE	(KVM_REG_PPC | KVM_REG_SIZE_U32 | 0xbf)
>  #define KVM_REG_PPC_PTCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc0)
>  
> +/* POWER10 registers. */
> +#define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc1)
> +#define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc2)
> +
>  /* Transactional Memory checkpointed state:
>   * This is all GPRs, all VSX regs and a subset of SPRs
>   */
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index a28c366737..015fa4b44b 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_SECURE_GUEST 181
>  #define KVM_CAP_HALT_POLL 182
>  #define KVM_CAP_ASYNC_PF_INT 183
> +#define KVM_CAP_PPC_DAWR1 184
>  
>  #ifdef KVM_CAP_IRQ_ROUTING

Same here, this should go together with the headers changes from the
first patch.

