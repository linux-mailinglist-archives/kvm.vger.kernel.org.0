Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BF62034C2
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 12:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgFVKZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 06:25:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56100 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726841AbgFVKZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 06:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592821512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jxlew434ZREQ+yaO+wj/+fLKjUJf2xES+lf3Lg2HMoA=;
        b=YNi0dKtcgxZ/N5AHbLrJjyY6oK/MeFWxcruZ5RCnRn3hndE7ItuLQMU/8AQ/zyfPUj5W4n
        Bsyt6QCZWh03vfOtEekKinrRfBPxueDl5HcQ8+gUJrWeJTprhVn7TuvXzQY0G/T3CGHJf/
        tTPUXuO8a+HLyfvhahTY4l1ul81gOic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-ue5_nad-MOSQtgb8DlVwhQ-1; Mon, 22 Jun 2020 06:25:11 -0400
X-MC-Unique: ue5_nad-MOSQtgb8DlVwhQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 072BE106B209;
        Mon, 22 Jun 2020 10:25:05 +0000 (UTC)
Received: from gondolin (ovpn-113-56.ams2.redhat.com [10.36.113.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CD865BAF4;
        Mon, 22 Jun 2020 10:24:59 +0000 (UTC)
Date:   Mon, 22 Jun 2020 12:24:56 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Collin Walling <walling@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v8 2/2] s390/kvm: diagnose 0x318 sync and reset
Message-ID: <20200622122456.781492a8.cohuck@redhat.com>
In-Reply-To: <20200618222222.23175-3-walling@linux.ibm.com>
References: <20200618222222.23175-1-walling@linux.ibm.com>
        <20200618222222.23175-3-walling@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Jun 2020 18:22:22 -0400
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
> The CPNC is shadowed/unshadowed in VSIE.
> 
> This data is reset on load normal and clear resets.
> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  4 +++-
>  arch/s390/include/uapi/asm/kvm.h |  5 ++++-
>  arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
>  arch/s390/kvm/vsie.c             |  3 +++
>  include/uapi/linux/kvm.h         |  1 +
>  5 files changed, 21 insertions(+), 3 deletions(-)
> 

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

Do we strictly need this new cap, or would checking against the sync
regs capabilities be enough?

>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  

