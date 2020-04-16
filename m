Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CAE1ABAE7
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 10:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441236AbgDPIPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 04:15:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23471 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441164AbgDPILL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 04:11:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587024669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wFZ203bZj9/d1HrtvH0p9KqRawPq4JxwlKVrmFjPcis=;
        b=bEDaLlNrtGwOSc7TADrkOK/PBCVfIv/cMTuZUFZjlQ/OMrsLOJKdah+F8fSxhRpMXhfrqw
        CO0Xu3tbS9mGA3/y8nvZ+V8fPby+vaEn3OBuZ+p5n98fn/5gNF+nV5v8n+Z8Jc6RwYhtle
        ETQ3gQ21dStAvFjc1rvQ4kRrPFsDX2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-tZrY3pJgMBy2TZZWxU1zqg-1; Thu, 16 Apr 2020 04:11:08 -0400
X-MC-Unique: tZrY3pJgMBy2TZZWxU1zqg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93AD81005509;
        Thu, 16 Apr 2020 08:11:03 +0000 (UTC)
Received: from gondolin (ovpn-112-234.ams2.redhat.com [10.36.112.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 734275DA7B;
        Thu, 16 Apr 2020 08:10:49 +0000 (UTC)
Date:   Thu, 16 Apr 2020 10:10:47 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: Optimize kvm_arch_vcpu_ioctl_run function
Message-ID: <20200416101047.1cb9693c.cohuck@redhat.com>
In-Reply-To: <20200416051057.26526-1-tianjia.zhang@linux.alibaba.com>
References: <20200416051057.26526-1-tianjia.zhang@linux.alibaba.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Apr 2020 13:10:57 +0800
Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:

> In earlier versions of kvm, 'kvm_run' is an independent structure
> and is not included in the vcpu structure. At present, 'kvm_run'
> is already included in the vcpu structure, so the parameter
> 'kvm_run' is redundant.
> 
> This patch simplify the function definition, removes the extra

s/simplify/simplifies/

> 'kvm_run' parameter, and extract it from the 'kvm_vcpu' structure

s/extract/extracts/

> if necessary.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
> 
> v2 change:
>   remove 'kvm_run' parameter and extract it from 'kvm_vcpu'
> 
>  arch/mips/kvm/mips.c       |  3 ++-
>  arch/powerpc/kvm/powerpc.c |  3 ++-
>  arch/s390/kvm/kvm-s390.c   |  3 ++-
>  arch/x86/kvm/x86.c         | 11 ++++++-----
>  include/linux/kvm_host.h   |  2 +-
>  virt/kvm/arm/arm.c         |  6 +++---
>  virt/kvm/kvm_main.c        |  2 +-
>  7 files changed, 17 insertions(+), 13 deletions(-)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

