Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4258C6637F3
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 04:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjAJD43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 22:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjAJD42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 22:56:28 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE5465AD
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 19:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673322986; x=1704858986;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8ajCkSHry4NIrwT7/4XludrLIcCGvRD3NpKMW4naOgU=;
  b=mUlZswwkTBHoOUKMWmFVQaTWoi9PTlp11/lF+kt5h8+aGIfg7ly2W4WP
   H7tAhQtODtZWaVl+4ghLSC7ZewkBvnDoi0I3ZfEHoU49rw0YcNHgBHNGf
   FEwH2qY4O472lQpAzX+b8S373BpAYpw9Xt3y+uqyWJxzbHF97KAxr7xuv
   ad8INwg7gHuHjDrmXBAAL/NiFiMh7eDczwo4s09uBuJfXFZc5PISva97g
   dCe+fdb8MKWa8mVuxjKDEgXCygrH5KW+tTg8OrcNekCFXtmEMyTUd7cHv
   5mi+/j5zQBlHkL8lxQuXXXmHDON4o59lWrA3npAA5iPYGwkhLGcf4R2hv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="321752218"
X-IronPort-AV: E=Sophos;i="5.96,314,1665471600"; 
   d="scan'208";a="321752218"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 19:56:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="764570598"
X-IronPort-AV: E=Sophos;i="5.96,314,1665471600"; 
   d="scan'208";a="764570598"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jan 2023 19:56:25 -0800
Message-ID: <46da749bab77d680c37c9e4fcce34073a466923e.camel@linux.intel.com>
Subject: Re: [PATCH v3 2/9] KVM: x86: Add CR4.LAM_SUP in guest owned bits
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Date:   Tue, 10 Jan 2023 11:56:24 +0800
In-Reply-To: <Y7xA53sLxCwzfvgD@google.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-3-robert.hu@linux.intel.com>
         <Y7i+/3KbqUto76AR@google.com>
         <5f2f0a44fbb1a2eab36183dfc2fcaf53e1109793.camel@linux.intel.com>
         <Y7xA53sLxCwzfvgD@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-01-09 at 16:29 +0000, Sean Christopherson wrote:
> On Sat, Jan 07, 2023, Robert Hoo wrote:
> > On Sat, 2023-01-07 at 00:38 +0000, Sean Christopherson wrote:
> > > On Fri, Dec 09, 2022, Robert Hoo wrote:
> > > > If LAM enabled, CR4.LAM_SUP is owned by guest; otherwise,
> > > > reserved.
> > > 
> > > Why is it passed through to the guest?
> > 
> > I think no need to intercept guest's control over CR4.LAM_SUP,
> > which
> > controls LAM appliance to supervisor mode address.
> 
> That's not a sufficient justification.  KVM doesn't strictly need to
> intercept
> most CR4 bits, 

Yeah, that's also my experiential understanding.

> but not intercepting has performance implications, e.g. KVM needs
> to do a VMREAD(GUEST_CR4) to get LAM_SUP if the bit is pass
> through.  

Right. On the other hand, intercepting has performance penalty by vm-
exit, and much heavier. So, trade-off, right?

> As a base
> rule, KVM intercepts CR4 bits unless there's a reason not to, e.g. if
> the CR4 bit
> in question is written frequently by real guests and/or never
> consumed by KVM.

From these 2 points to judge:
CR4.LAM_SUP is written frequently by guest? I'm not sure, as native
kernel enabling patch has LAM_U57 only yet, not sure its control will
be per-process/thread or whole kernel-level. If it its use case is
kasan kind of, would you expect it will be frequently guest written?

Never consumed by KVM? false, e.g. kvm_untagged_addr() will read this
bit. But not frequently, I think, at least by this patch set.

So in general, you suggestion/preference? I'm all right on both
choices.



