Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6745541AC9A
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 12:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240090AbhI1KGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 06:06:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:42106 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240047AbhI1KGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 06:06:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="224313861"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="224313861"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 03:05:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="707780985"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga005.fm.intel.com with ESMTP; 28 Sep 2021 03:05:07 -0700
Message-ID: <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        yu.c.zhang@linux.intel.com
Date:   Tue, 28 Sep 2021 18:05:06 +0800
In-Reply-To: <YTI7K9RozNIWXTyg@google.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
         <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
         <YRvbvqhz6sknDEWe@google.com>
         <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
         <YR2Tf9WPNEzrE7Xg@google.com>
         <3ac79d874fb32c6472151cf879edfb2f1b646abf.camel@linux.intel.com>
         <YS/lxNEKXLazkhc4@google.com>
         <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
         <YTI7K9RozNIWXTyg@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-03 at 15:11 +0000, Sean Christopherson wrote:
> ...

Hi Sean,

Sorry for so late reply. Multi-task, you know;-)

The discussion about this patch has passed so long time and has
diverged, actually. Let me summarize our previous discussions. Then we
can converge things and settle direction.


* Copy to/from shadow vmcs, no need to validate field existence or not.
-- I agree.

* Now that only VMCS-read/write need to validate field existence, can
use static check instead of bitmap.
* And borrow bit 0 in the field->offset table to denote conditional
fields.

Because:
	Shadow control can have more chances to be cache-hit than
bitmap.
	The bitmap is per-VMX, additional memory allocation is not
interesting.
	
Robert argued:
	I still prefer to use bitmap to denote conditional fields.
	If used static switchcase check rather than bitmap, the
switchcase would be very long. Till today, ~51 conditional fields.
	Though very less likely, we cannot guarantee no future use of
bit 0 of field->offset table entry.
	From perspective of runtime efficiency, read bitmap is better
to do static check every time.
	From the perspective of cache hit chance, shadow control (or
nested_vmx_msrs) and bitmap are both in nested structure, I don't think
they have essential difference.
	The bitmap is just 62 bytes long now, I think it's tolerable.:)


* Interaction with Shadow VMCS -- for those shadowed fields, we cannot
trap its read/write, therefore cannot check its existence per vmx
configuration L0 set for L1.
	
	This last point is the most messy one.

	If we would like to solve this, you proposed as a middle ground
to disable shadow VMCS totally when user space setting conflicts with
what KVM figured out.

	You also said, "This is quite the complicated mess for
something I'm guessing no one actually cares about.  At what point do
we chalk this up as a virtualization hole and sweep it under the rug?"
-- I couldn't agree more.

	We think to disable shadow VMCS totally is not good in any
circumstances, for the sake of nested performance, etc..
	We think there are 2 ways ahead:
	1) Leave it as it is nowadays, i.e. discard this patch set.
Perhaps we can add some build-check to force update that hard-coded
assignment to vmcs-enum-max when necessary.

	2) Make shadow vmcs bitmap per VM. This will have to allocate 2
(or 3?) more pages (shadow read/write bitmaps) per VM. Then we can
configure the shadow vmcs bitmap per user space configuration, i.e.
don't shadow those conditional VMCS fields, force its read/write to go
through handle_vm{read,write} gate.


So, Sean, can you help converge our discussion and settle next step?
Thanks.:-)


