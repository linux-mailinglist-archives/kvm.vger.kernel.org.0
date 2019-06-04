Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21CE34A81
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 16:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfFDOer convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 4 Jun 2019 10:34:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727169AbfFDOer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 10:34:47 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CAA80C05D275;
        Tue,  4 Jun 2019 14:34:36 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE82860FD5;
        Tue,  4 Jun 2019 14:34:32 +0000 (UTC)
Date:   Tue, 4 Jun 2019 16:34:30 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tao Xu <tao3.xu@intel.com>
Cc:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        mst@redhat.com, mtosatti@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, jingqi.liu@intel.com
Subject: Re: [PATCH v2 1/2] x86/cpu: Add support for UMONITOR/UMWAIT/TPAUSE
Message-ID: <20190604163430.0375fe01.cohuck@redhat.com>
In-Reply-To: <20190524081839.6228-2-tao3.xu@intel.com>
References: <20190524081839.6228-1-tao3.xu@intel.com>
        <20190524081839.6228-2-tao3.xu@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 04 Jun 2019 14:34:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 May 2019 16:18:38 +0800
Tao Xu <tao3.xu@intel.com> wrote:

> UMONITOR, UMWAIT and TPAUSE are a set of user wait instructions.
> Availability of the user wait instructions is indicated by the presence
> of the CPUID feature flag WAITPKG CPUID.0x07.0x0:ECX[5].
> 
> The patch enable the umonitor, umwait and tpause features in KVM.
> Because umwait and tpause can put a (psysical) CPU into a power saving
> state, by default we dont't expose it in kvm and provide a capability to
> enable it. Use kvm capability to enable UMONITOR, UMWAIT and TPAUSE when
> QEMU use "-overcommit cpu-pm=on, a VM can use UMONITOR, UMWAIT and TPAUSE
> instructions. If the instruction causes a delay, the amount of time
> delayed is called here the physical delay. The physical delay is first
> computed by determining the virtual delay (the time to delay relative to
> the VM’s timestamp counter). Otherwise, UMONITOR, UMWAIT and TPAUSE cause
> an invalid-opcode exception(#UD).
> 
> The release document ref below link:
> https://software.intel.com/sites/default/files/\
> managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf
> 
> Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
> Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
> Signed-off-by: Tao Xu <tao3.xu@intel.com>
> ---
>  linux-headers/linux/kvm.h |  1 +
>  target/i386/cpu.c         |  3 ++-
>  target/i386/cpu.h         |  1 +
>  target/i386/kvm.c         | 13 +++++++++++++
>  4 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index c8423e760c..86cc2dbdd0 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_SVE 170
>  #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
>  #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
> +#define KVM_CAP_ENABLE_USR_WAIT_PAUSE 173
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  

No comment on the actual change, but please split out any linux-header
changes so they can be replaced with a proper headers update when the
code is merged.
