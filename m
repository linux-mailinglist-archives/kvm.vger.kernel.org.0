Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60630203C22
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbgFVQF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:05:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45340 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726328AbgFVQF2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 12:05:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592841927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+LWhQvFZH5QUNjqmg5RzjUHWIyDzre30bGopCB8nnuI=;
        b=W5GKtUAClkdOPPT50f3FwjIISa6eqnWLcYnLVQXOGkharqmwY1uJ4qBVdHjWtH4Oc9jGUv
        vpSLdG0to635FRW8ALorj6c8CXagbMJMeIkMbCJucdCmC3cBe3Iy4vRAzXzSvswAn36TlO
        T7goZCwBRRKGTVpNEBhTdzVdxHULiso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-ITukRVdPMaSndkBpuQ0Ndw-1; Mon, 22 Jun 2020 12:05:25 -0400
X-MC-Unique: ITukRVdPMaSndkBpuQ0Ndw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC6D6192B9D6;
        Mon, 22 Jun 2020 16:05:09 +0000 (UTC)
Received: from gondolin (ovpn-113-56.ams2.redhat.com [10.36.113.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBA937166A;
        Mon, 22 Jun 2020 16:05:02 +0000 (UTC)
Date:   Mon, 22 Jun 2020 18:04:59 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Collin Walling <walling@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v9 2/2] s390/kvm: diagnose 0x318 sync and reset
Message-ID: <20200622180459.4cf7cbf4.cohuck@redhat.com>
In-Reply-To: <20200622154636.5499-3-walling@linux.ibm.com>
References: <20200622154636.5499-1-walling@linux.ibm.com>
        <20200622154636.5499-3-walling@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Jun 2020 11:46:36 -0400
Collin Walling <walling@linux.ibm.com> wrote:

> DIAGNOSE 0x318 (diag318) sets information regarding the environment
> the VM is running in (Linux, z/VM, etc) and is observed via
> firmware/service events.
> 
> This is a privileged s390x instruction that must be intercepted by
> SIE. Userspace handles the instruction as well as migration. Data
> is communicated via VCPU register synchronization.
> 
> The Control Program Name Code (CPNC) is stored in the SIE block. The
> CPNC along with the Control Program Version Code (CPVC) are stored
> in the kvm_vcpu_arch struct.
> 
> This data is reset on load normal and clear resets.

Looks good to me AFAICS without access to the architecture.

Acked-by: Cornelia Huck <cohuck@redhat.com>

One small thing below.

> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  4 +++-
>  arch/s390/include/uapi/asm/kvm.h |  5 ++++-
>  arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
>  arch/s390/kvm/vsie.c             |  1 +
>  include/uapi/linux/kvm.h         |  1 +
>  5 files changed, 19 insertions(+), 3 deletions(-)

(...)

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4fdf30316582..35cdb4307904 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_SECURE_GUEST 181
>  #define KVM_CAP_HALT_POLL 182
>  #define KVM_CAP_ASYNC_PF_INT 183
> +#define KVM_CAP_S390_DIAG318 184

Should we document this in Documentation/virt/kvm/api.rst?

(Documentation of KVM caps generally seems to be a bit of a
hit-and-miss, though. But we could at least document the s390 ones :)

I also noticed that the new entries for the vcpu resets and pv do not
seem to be in proper rst format. Maybe fix that and add the new doc in
an add-on series?

>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  

