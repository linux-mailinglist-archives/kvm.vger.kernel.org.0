Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA8EF487DA
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 17:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbfFQPup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 11:50:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbfFQPup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 11:50:45 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C2A3930BC56A;
        Mon, 17 Jun 2019 15:50:44 +0000 (UTC)
Received: from flask (unknown [10.43.2.199])
        by smtp.corp.redhat.com (Postfix) with SMTP id E49F2783BF;
        Mon, 17 Jun 2019 15:50:38 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Mon, 17 Jun 2019 17:50:38 +0200
Date:   Mon, 17 Jun 2019 17:50:38 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@linux.intel.com>
Cc:     Tao Xu <tao3.xu@intel.com>, pbonzini@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, fenghua.yu@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jingqi.liu@intel.com
Subject: Re: [PATCH RESEND v3 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
Message-ID: <20190617155038.GA13955@flask>
References: <20190616095555.20978-1-tao3.xu@intel.com>
 <20190616095555.20978-3-tao3.xu@intel.com>
 <d99b2ae1-38fc-0b71-2613-8131decc923a@intel.com>
 <ea1fc40b-8f80-d5f0-6c97-adb245599e07@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea1fc40b-8f80-d5f0-6c97-adb245599e07@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 17 Jun 2019 15:50:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-06-17 14:31+0800, Xiaoyao Li:
> On 6/17/2019 11:32 AM, Xiaoyao Li wrote:
> > On 6/16/2019 5:55 PM, Tao Xu wrote:
> > > +    if (vmx->msr_ia32_umwait_control != host_umwait_control)
> > > +        add_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL,
> > > +                      vmx->msr_ia32_umwait_control,
> > > +                      host_umwait_control, false);
> > 
> > The bit 1 is reserved, at least, we need to do below to ensure not
> > modifying the reserved bit:
> > 
> >      guest_val = (vmx->msr_ia32_umwait_control & ~BIT_ULL(1)) |
> >              (host_val & BIT_ULL(1))
> > 
> 
> I find a better solution to ensure reserved bit 1 not being modified in
> vmx_set_msr() as below:
> 
> 	if((data ^ umwait_control_cached) & BIT_ULL(1))
> 		return 1;

We could just be checking

	if (data & BIT_ULL(1))

because the guest cannot change its visible reserved value and KVM
currently initializes the value to 0.

The arch/x86/kernel/cpu/umwait.c series assumes that the reserved bit
is 0 (hopefully deliberately) and I would do the same in KVM as it
simplifies the logic.  (We don't have to even think about migrations
between machines with a different reserved value and making it play
nicely with possible future implementations of that bit.)

Thanks.
