Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CDB1D2AE0
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 11:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgENJF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 05:05:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33724 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725878AbgENJF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 05:05:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589447155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AAmRZ3VCYSkYJMDdy/+51H4e39k0hxgVJmNlv2wjb8Q=;
        b=ay5gp7bzW6cNCHqTq3gj+Z84AlOis9YMVwONzsw6kNEmJbz+8rzl1A/yF27XUNESflVg3e
        j1EgsXt00y4WJEvefrvFUoNcw5q/7aujO8/gzqlw6N6BQqnVUiY3qMlyQaZbhaNUASi6W8
        thkG8jmdVVk1kkGhVLrYB0wHenvsdGs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-dWeAr_bDOr2CbrlWkNz9dg-1; Thu, 14 May 2020 05:05:54 -0400
X-MC-Unique: dWeAr_bDOr2CbrlWkNz9dg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74CF1EC1A0;
        Thu, 14 May 2020 09:05:52 +0000 (UTC)
Received: from gondolin (unknown [10.40.192.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E499579AD;
        Thu, 14 May 2020 09:05:47 +0000 (UTC)
Date:   Thu, 14 May 2020 11:05:44 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Collin Walling <walling@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v6 2/2] s390/kvm: diagnose 318 handling
Message-ID: <20200514110544.147a63f8.cohuck@redhat.com>
In-Reply-To: <20200513221557.14366-3-walling@linux.ibm.com>
References: <20200513221557.14366-1-walling@linux.ibm.com>
        <20200513221557.14366-3-walling@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 May 2020 18:15:57 -0400
Collin Walling <walling@linux.ibm.com> wrote:

> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
> be intercepted by SIE and handled via KVM. Let's introduce some
> functions to communicate between userspace and KVM via ioctls. These
> will be used to get/set the diag318 related information, as well as
> check the system if KVM supports handling this instruction.
> 
> This information can help with diagnosing the environment the VM is
> running in (Linux, z/VM, etc) if the OS calls this instruction.
> 
> By default, this feature is disabled and can only be enabled if a
> user space program (such as QEMU) explicitly requests it.
> 
> The Control Program Name Code (CPNC) is stored in the SIE block
> and a copy is retained in each VCPU. The Control Program Version
> Code (CPVC) is not designed to be stored in the SIE block, so we
> retain a copy in each VCPU next to the CPNC.
> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> ---
>  Documentation/virt/kvm/devices/vm.rst | 29 +++++++++
>  arch/s390/include/asm/kvm_host.h      |  6 +-
>  arch/s390/include/uapi/asm/kvm.h      |  5 ++
>  arch/s390/kvm/diag.c                  | 20 ++++++
>  arch/s390/kvm/kvm-s390.c              | 89 +++++++++++++++++++++++++++
>  arch/s390/kvm/kvm-s390.h              |  1 +
>  arch/s390/kvm/vsie.c                  |  2 +
>  7 files changed, 151 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
> index 0aa5b1cfd700..9344d45ace6d 100644
> --- a/Documentation/virt/kvm/devices/vm.rst
> +++ b/Documentation/virt/kvm/devices/vm.rst
> @@ -314,3 +314,32 @@ Allows userspace to query the status of migration mode.
>  	     if it is enabled
>  :Returns:   -EFAULT if the given address is not accessible from kernel space;
>  	    0 in case of success.
> +
> +6. GROUP: KVM_S390_VM_MISC

This needs to be rstyfied, matching the remainder of the file.

> +Architectures: s390
> +
> + 6.1. KVM_S390_VM_MISC_ENABLE_DIAG318
> +
> + Allows userspace to enable the DIAGNOSE 0x318 instruction call for a
> + guest OS. By default, KVM will not allow this instruction to be executed
> + by a guest, even if support is in place. Userspace must explicitly enable
> + the instruction handling for DIAGNOSE 0x318 via this call.
> +
> + Parameters: none
> + Returns:    0 after setting a flag telling KVM to enable this feature
> +
> + 6.2. KVM_S390_VM_MISC_DIAG318 (r/w)
> +
> + Allows userspace to retrieve and set the DIAGNOSE 0x318 information,
> + which consists of a 1-byte "Control Program Name Code" and a 7-byte
> + "Control Program Version Code" (a 64 bit value all in all). This
> + information is set by the guest (usually during IPL). This interface is
> + intended to allow retrieving and setting it during migration; while no
> + real harm is done if the information is changed outside of migration,
> + it is strongly discouraged.

(Sorry if we discussed that already, but that was some time ago and the
info has dropped out of my cache...)

Had we considered doing this in userspace only? If QEMU wanted to
emulate diag 318 in tcg, it would basically need to mirror what KVM
does; diag 318 does not seem like something where we want to optimize
for performance, so dropping to userspace seems feasible? We'd just
need an interface for userspace to forward anything set by the guest.

> +
> + Parameters: address of a buffer in user space (u64), where the
> +	     information is read from or stored into
> + Returns:    -EFAULT if the given address is not accessible from kernel space;
> +	     -EOPNOTSUPP if feature has not been requested to be enabled first;
> +	     0 in case of success

