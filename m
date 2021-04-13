Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF5835E08C
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 15:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346123AbhDMNrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 09:47:48 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:34854 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346168AbhDMNrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 09:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1618321621; x=1649857621;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=zPB0tcxm7VsQe0IrZ2J3oFyEAOuY/wCfEhpeW5QXJ74=;
  b=UZRUI+YfbzlLhSbSasJSCIbjveL0IQAHhjTdQAAxBnjlxWEzyLr+tzjN
   OFLYiliwxgXYZYwQ9d4W+5HYzd+totio6F5z+sEQHE88qAheZNq4zn0CM
   0kXWLpptMbGb54AgP504Poh9UHnlyW/WpStb/8CZFSdri6wFzpDVQm4+H
   M=;
X-IronPort-AV: E=Sophos;i="5.82,219,1613433600"; 
   d="scan'208";a="105754919"
Subject: Re: [PATCH v2 1/4] KVM: x86: Move FPU register accessors into fpu.h
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 13 Apr 2021 13:46:54 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 58567A1CEA;
        Tue, 13 Apr 2021 13:46:47 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.162.93) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 13 Apr 2021 13:46:38 +0000
Date:   Tue, 13 Apr 2021 15:46:34 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>
Message-ID: <20210413134634.GA27585@uc8bbc9586ea454.ant.amazon.com>
References: <cover.1618244920.git.sidcha@amazon.de>
 <5d2945df9dd807dca45ab256c88aeb4430ecf508.1618244920.git.sidcha@amazon.de>
 <87y2dm5ml3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87y2dm5ml3.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.162.93]
X-ClientProxiedBy: EX13D44UWB001.ant.amazon.com (10.43.161.32) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 03:40:56PM +0200, Vitaly Kuznetsov wrote:
> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> > @@ -0,0 +1,140 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef __KVM_FPU_H_
> > +#define __KVM_FPU_H_
> > +
> > +#include <asm/fpu/api.h>
> > +
> > +typedef u32          __attribute__((vector_size(16))) sse128_t;
> 
> Post-patch we seem to have two definitions of 'sse128_t':
> 
> $ git grep sse128_t
> HEAD~3:arch/x86/kvm/fpu.h:typedef u32           __attribute__((vector_size(16))) sse128_t;
> HEAD~3:arch/x86/kvm/fpu.h:#define __sse128_u    union { sse128_t vec; u64 as_u64[2]; u32 as_u32[4]; }
> HEAD~3:arch/x86/kvm/fpu.h:static inline void _kvm_read_sse_reg(int reg, sse128_t *data)
> HEAD~3:arch/x86/kvm/fpu.h:static inline void _kvm_write_sse_reg(int reg, const sse128_t *data)
> HEAD~3:arch/x86/kvm/fpu.h:static inline void kvm_read_sse_reg(int reg, sse128_t *data)
> HEAD~3:arch/x86/kvm/fpu.h:static inline void kvm_write_sse_reg(int reg, const sse128_t *data)
> HEAD~3:arch/x86/kvm/kvm_emulate.h:typedef u32 __attribute__((vector_size(16))) sse128_t;
> HEAD~3:arch/x86/kvm/kvm_emulate.h:              char valptr[sizeof(sse128_t)];
> HEAD~3:arch/x86/kvm/kvm_emulate.h:              sse128_t vec_val;
> 
> Should the one from kvm_emulate.h go away?

Yes, removed.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



