Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49ECC652B86
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 03:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiLUCiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 21:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLUCiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 21:38:20 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7242D7
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 18:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671590299; x=1703126299;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6+gJSu1Lgn8AQOP10ZX8qWjng8TlziMfZ254y8Hx6AE=;
  b=M7N4txC+TCskjsYEbnga9CATOLYcpmyKXp5qJo0hjMhx+msK1emKctvl
   zzDLkWmaaHjNJNDK7nRAhlE7Dsy94dyR8ugIANEwf4PwAr17n23RX8mFP
   N0Ns33XUHD4qA3DU+bucPJhjcCMKe2wKIkKYFek5X6KHg4szJp2QqyqRH
   d0Akef7zfFhekH8HLEs/QBYlUs7RCwi+CAZ46EnVmJxN5VUpz7y4r+Siy
   KlZk+4hi3E8Ut39U6H++PlZvOB1wvHsi/rNF2NtYXbevoTmgKilbkiloN
   w9Ky5QgmKrZfBlpTorub4S0nMA9Z1aA2TJSNu0CESOsou/5xnRXqQVyG0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="300112901"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="300112901"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 18:38:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="775527167"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="775527167"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga004.jf.intel.com with ESMTP; 20 Dec 2022 18:38:17 -0800
Date:   Wed, 21 Dec 2022 10:38:16 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <20221221023816.2hrx4p7oprx7wz6y@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
 <20221219094511.boo7iththyps565z@yy-desk-7060>
 <3e3a389cc887062a737327713a634ded80e977b2.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e3a389cc887062a737327713a634ded80e977b2.camel@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022 at 10:07:57PM +0800, Robert Hoo wrote:
> On Mon, 2022-12-19 at 17:45 +0800, Yuan Yao wrote:
> > On Fri, Dec 09, 2022 at 12:45:54PM +0800, Robert Hoo wrote:
> > > Define kvm_untagged_addr() per LAM feature spec: Address high bits
> > > are sign
> > > extended, from highest effective address bit.
> > > Note that LAM_U48 and LA57 has some effective bits overlap. This
> > > patch
> > > gives a WARN() on that case.
> > >
> > > Now the only applicable possible case that addresses passed down
> > > from VM
> > > with LAM bits is those for MPX MSRs.
> >
> > How about the instruction emulation case ? e.g. KVM on behalf of CPU
> > to do linear address accessing ? In this case the kvm_untagged_addr()
> > should also be used to mask out the linear address, otherwise
> > unexpected
> > #GP(or other exception) will be injected into guest.
> >
> > Please see all callers of __is_canonical_address()
> >
> Emm, I take a look at the callers, looks like they're segment registers
> and MSRs. Per spec (ISE 10.4): processors that support LAM continue to

__linearize() is using __is_canonical_address() for 64 bit mode, and this
is the code path for memory reading/writing emulation, what will happen
if a LAM enabled guest appiled metadata to the address and KVM emulates
the memory accessing for it ?

> require the addresses written to control registers or MSRs be legacy
> canonical. So, like the handling on your last commented point on this
> patch, such situation needs no changes, i.e. legacy canonical still
> applied.
>
