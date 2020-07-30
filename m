Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51B3233256
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 14:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgG3Mi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 08:38:56 -0400
Received: from 8bytes.org ([81.169.241.247]:34032 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgG3Miz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 08:38:55 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 1D1C53C8; Thu, 30 Jul 2020 14:38:54 +0200 (CEST)
Date:   Thu, 30 Jul 2020 14:38:52 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 1/4] KVM: SVM: nested: Don't allocate VMCB structures on
 stack
Message-ID: <20200730123852.GB3257@8bytes.org>
References: <20200729132234.2346-1-joro@8bytes.org>
 <20200729132234.2346-2-joro@8bytes.org>
 <20200729151454.GB27751@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729151454.GB27751@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

thanks for your review!

On Wed, Jul 29, 2020 at 08:14:55AM -0700, Sean Christopherson wrote:
> On Wed, Jul 29, 2020 at 03:22:31PM +0200, Joerg Roedel wrote:
> Speaking of too large, would it be overly paranoid to add:
> 
>   BUILD_BUG_ON(sizeof(struct vmcb_control_area) + sizeof(struct vmcb_save_area) <
> 	       KVM_STATE_NESTED_SVM_VMCB_SIZE)
> 
> More so for documentation than for any real concern that the SVM architecture
> will do something silly, e.g. to make it obvious that patch 2 in this series
> won't break backwards compatibility.

The check should actually be '>', but then it makes sense. The control-
and save-area together are still way smaller than 4k. I will add the
check for '>' to this patch.

> > +	ret = -EFAULT;
> > +	if (copy_from_user(ctl, &user_vmcb->control, sizeof(ctl)))
> 
> The sizeof() calc is wrong, this is now calculating the size of the pointer,
> not the size of the struct.  It'd need to be sizeof(*ctl).
> 
> > +		goto out_free;
> > +	if (copy_from_user(save, &user_vmcb->save, sizeof(save)))
> 
> Same bug here.

Thanks, fixed that.

Regards,

	Joerg
