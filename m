Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738CF24C956
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 02:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgHUAny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 20:43:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:22591 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgHUAnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 20:43:52 -0400
IronPort-SDR: zZc69eXsPDu1+auV9GcrajuqBRqeA8da9q4si91JxTNBTK9Kr57lsw4TCHkFSywF+Pscjyngzp
 gDHbobK/Fpuw==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="173475545"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="173475545"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 17:43:52 -0700
IronPort-SDR: CV+aD4RVikqpucere4ciRE8C/vejzgapN3ODrrIRnN9LOYhBkdBPuOorNfcXFydm5tLFtevSSG
 e7B+Vcfib0xg==
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="498345362"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 17:43:50 -0700
Date:   Thu, 20 Aug 2020 17:43:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 4/7] KVM: x86: allow kvm_x86_ops.set_efer to return a
 value
Message-ID: <20200821004350.GB13886@sjchrist-ice>
References: <20200820133339.372823-1-mlevitsk@redhat.com>
 <20200820133339.372823-5-mlevitsk@redhat.com>
 <CALMp9eRNLjj5cs1xj44WVRoKK0ZrcGXn7ffdH+bEeDHkLE9nSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRNLjj5cs1xj44WVRoKK0ZrcGXn7ffdH+bEeDHkLE9nSA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 02:43:56PM -0700, Jim Mattson wrote:
> On Thu, Aug 20, 2020 at 6:34 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> >
> > This will be used later to return an error when setting this msr fails.
> >
> > For VMX, it already has an error condition when EFER is
> > not in the shared MSR list, so return an error in this case.
> >
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> 
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1471,7 +1471,8 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >         efer &= ~EFER_LMA;
> >         efer |= vcpu->arch.efer & EFER_LMA;
> >
> > -       kvm_x86_ops.set_efer(vcpu, efer);
> > +       if (kvm_x86_ops.set_efer(vcpu, efer))
> > +               return 1;
> 
> This seems like a userspace ABI change to me. Previously, it looks
> like userspace could always use KVM_SET_MSRS to set MSR_EFER to 0 or
> EFER_SCE, and it would always succeed. Now, it looks like it will fail
> on CPUs that don't support EFER in hardware. (Perhaps it should fail,
> but it didn't before, AFAICT.)

KVM emulates SYSCALL, presumably that also works when EFER doesn't exist in
hardware.

The above also adds weirdness to nested VMX as vmx_set_efer() simply can't
fail.
