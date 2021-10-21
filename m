Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDCB4361FA
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 14:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhJUMoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 08:44:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:28790 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230347AbhJUMoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 08:44:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10143"; a="227790672"
X-IronPort-AV: E=Sophos;i="5.87,169,1631602800"; 
   d="scan'208";a="227790672"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 05:41:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,169,1631602800"; 
   d="scan'208";a="495132614"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga008.jf.intel.com with ESMTP; 21 Oct 2021 05:41:52 -0700
Message-ID: <96f45d36b774bedfc854b58a5c8eb1536d08c0c9.camel@linux.intel.com>
Subject: Re: [PATCH v1 1/5] KVM: x86: nVMX: Add vmcs12 field existence
 bitmap in nested_vmx
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     kvm@vger.kernel.org, yu.c.zhang@linux.intel.com
Date:   Thu, 21 Oct 2021 20:41:51 +0800
In-Reply-To: <b2aebaba-92bc-865d-5d52-6810ba08ceaa@redhat.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
         <1629192673-9911-2-git-send-email-robert.hu@linux.intel.com>
         <b2aebaba-92bc-865d-5d52-6810ba08ceaa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-10-20 at 17:10 +0200, Paolo Bonzini wrote:
> > +#define FIELD_BIT_CHANGE(name, bitmap) change_bit(f_pos(name),
> > bitmap)
> > +#define FIELD64_BIT_CHANGE(name, bitmap)	\
> > +	do {change_bit(f_pos(name), bitmap);	\
> > +	    change_bit(f_pos(name) + (sizeof(u32) / sizeof(u16)),
> > bitmap);\
> > +	} while (0)
> > +
> > +/*
> 
> Hi Robert,
> 
> I'd rather not have FIELD_BIT_CHANGE, and instead have something like
> 
> #define FIELD_BIT_ASSIGN(name, bitmap, value) \
> 	if (value) \
> 		FIELD_BIT_SET(name, bitmap); \
> 	else
> 		FIELD_BIT_CLEAR(name, bitmap);
> 
Sure. I had also hesitated if it could be assert that no
accident/unknown flipping on those bits by some other routine.

> Also, these set_bit/clear_bit can use the non-atomic variants
> __set_bit 
> and __clear_bit, because the bitmaps are protected by the vCPU mutex.

OK, thanks.

> 
> > +		FIELD64_BIT_CHANGE(posted_intr_desc_addr, bitmap);
> 
> Many of the fields you mark as 64-bit are actually natural sized.

Could you point me some example? I just compared with those natural
width fields in struct vmcs12{}, I don't find mistakes.

e.g. above line, "posted_intr_desc_addr" is indeed 64 bit field per SDM
vol.3 appendix B.
 
> 
> > +	if ((old_val ^ new_val) &
> > +	    CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
> > +		FIELD_BIT_CHANGE(secondary_vm_exec_control, bitmap);
> > +	}
> > +}
> 
> If secondary controls are not available, you should treat the 
> corresponding MSR as if it was all zeroes.  Likewise if VMFUNC is
> disabled.

OK. So you mean, if secondary_vm_exec_control bit cleared, I shall set
vmx->nested.msrs.secondary_ctls_{low,high} = 0, right?

> 
> > +	if ((old_val ^ new_val) & SECONDARY_EXEC_PAUSE_LOOP_EXITING) {
> > +		FIELD64_BIT_CHANGE(vmread_bitmap, bitmap);
> > +		FIELD64_BIT_CHANGE(vmwrite_bitmap, bitmap);
> 
> This seems wrong.

You're right. Here shall be bit changes of PLE_{GAP,WINDOW}, but since
they're not defined in vmcs12{} yet, I'm going to remove these lines.
> 
> Paolo
> 

