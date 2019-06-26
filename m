Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2823A56856
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 14:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfFZMLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 08:11:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbfFZMLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 08:11:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3791230860A3;
        Wed, 26 Jun 2019 12:11:39 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC26660BE1;
        Wed, 26 Jun 2019 12:11:35 +0000 (UTC)
Date:   Wed, 26 Jun 2019 14:11:33 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Collin Walling <walling@linux.ibm.com>
Cc:     david@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v5 2/2] s390/kvm: diagnose 318 handling
Message-ID: <20190626141133.340127d7.cohuck@redhat.com>
In-Reply-To: <1561475022-18348-3-git-send-email-walling@linux.ibm.com>
References: <1561475022-18348-1-git-send-email-walling@linux.ibm.com>
        <1561475022-18348-3-git-send-email-walling@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 26 Jun 2019 12:11:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Jun 2019 11:03:42 -0400
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
> The get/set functions are introduced primarily for VM migration and
> reset, though no harm could be done to the system if a userspace
> program decides to alter this data (this is highly discouraged).
> 
> The Control Program Name Code (CPNC) is stored in the SIE block (if
> host hardware supports it) and a copy is retained in each VCPU. The
> Control Program Version Code (CPVC) is not designed to be stored in
> the SIE block, so we retain a copy in each VCPU next to the CPNC.
> 
> At this time, the CPVC is not reported during a VM_EVENT as its
> format is yet to be properly defined.
> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> ---
>  Documentation/virtual/kvm/devices/vm.txt | 14 ++++++
>  arch/s390/include/asm/kvm_host.h         |  5 +-
>  arch/s390/include/uapi/asm/kvm.h         |  4 ++
>  arch/s390/kvm/diag.c                     | 17 +++++++
>  arch/s390/kvm/kvm-s390.c                 | 81 ++++++++++++++++++++++++++++++++
>  arch/s390/kvm/kvm-s390.h                 |  1 +
>  arch/s390/kvm/vsie.c                     |  2 +
>  7 files changed, 123 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virtual/kvm/devices/vm.txt b/Documentation/virtual/kvm/devices/vm.txt
> index 4ffb82b..56f7d9c 100644
> --- a/Documentation/virtual/kvm/devices/vm.txt
> +++ b/Documentation/virtual/kvm/devices/vm.txt
> @@ -268,3 +268,17 @@ Parameters: address of a buffer in user space to store the data (u64) to;
>  	    if it is enabled
>  Returns:    -EFAULT if the given address is not accessible from kernel space
>  	    0 in case of success.
> +
> +6. GROUP: KVM_S390_VM_MISC
> +Architectures: s390
> +
> +6.1. KVM_S390_VM_MISC_DIAG318 (r/w)
> +
> +Allows userspace to access the DIAGNOSE 0x318 information which consists of a
> +1-byte "Control Program Name Code" and a 7-byte "Control Program Version Code".
> +This information is initialized during IPL and must be preserved during
> +migration.
> +
> +Parameters: address of a buffer in user space to store the data (u64) to
> +Returns:    -EFAULT if the given address is not accessible from kernel space
> +	     0 in case of success.

Hm, this looks a bit incomplete to me. IIUC, the guest will set this
via diag 318, and this interface is intended to be used by user space
for retrieving/setting this during migration. What about the following:


Allows userspace to retrieve and set the DIAGNOSE 0x318 information,
which consists of a 1-byte "Control Program Name Code" and a 7-byte
"Control Program Version Code" (a 64 bit value all in all). This
information is set by the guest (usually during IPL). This interface is
intended to allow retrieving and setting it during migration; while no
real harm is done if the information is changed outside of migration,
it is strongly discouraged.

Parameters: address of a buffer in user space (u64), where the
            information is read from or stored into
Returns:    -EFAULT if the given address is not accessible from kernel space
	     0 in case of success

Otherwise, no further comments from me.
