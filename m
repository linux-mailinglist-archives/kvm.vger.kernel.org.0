Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483AB6A1926
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 10:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjBXJyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 04:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjBXJyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 04:54:15 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CD61205F;
        Fri, 24 Feb 2023 01:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677232454; x=1708768454;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o+MfsIEhIYQbpZ61l/Q4RJDgRlXpr7zn7qF/0hBGrtg=;
  b=A4/XmcOZaAL37bG9v/p5cl/lMEzXWP46biOZqlmaLOiWoMY7XcAuI8rs
   6db5OL/onfyhC9uOytV7ANfDItM+UzVBNV9vDdJ5x3wKnxFhiAAzkmQFR
   qqlP6nYnB6XAgmXDnhGljUrM789C+DkPuM2yXNUY0kh5jRa/UssEkXiHO
   SXX6VNeQCm79G6bREL6CYmnId6IgWmlw28XEfIk9h7aimMXvspV5ki2xn
   ZUPbGPuKMgKsaMfzgoMY2HyiGgtZX3L+++Q805eQIaC6ZO5q2mJDvKNJM
   1rypW3CGzicGWHOOf5qvmauy8SfVzIpi5CvbOz2GZIa+j+UGlP1MM+5EA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334860081"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="334860081"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 01:54:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="736746256"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="736746256"
Received: from moqiongz-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.215.23])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 01:54:12 -0800
Date:   Fri, 24 Feb 2023 17:54:09 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] KVM: x86: Use KVM-governed feature framework to
 track "XSAVES enabled"
Message-ID: <20230224095409.bo77lwb6wbsc53hx@linux.intel.com>
References: <20230217231022.816138-1-seanjc@google.com>
 <20230217231022.816138-6-seanjc@google.com>
 <20230221145610.ytlj5nkqsscc2yxo@linux.intel.com>
 <Y/ZlRDuRivMDKGwo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/ZlRDuRivMDKGwo@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 22, 2023 at 10:56:04AM -0800, Sean Christopherson wrote:
> On Tue, Feb 21, 2023, Yu Zhang wrote:
> > On Fri, Feb 17, 2023 at 03:10:15PM -0800, Sean Christopherson wrote:
> > > Use the governed feature framework to track if XSAVES is "enabled", i.e.
> > > if XSAVES can be used by the guest.  Add a comment in the SVM code to
> > > explain the very unintuitive logic of deliberately NOT checking if XSAVES
> > > is enumerated in the guest CPUID model.
> > > 
> > > No functional change intended.
> > 
> > xsaves_enabled in struct kvm_vcpu_arch is no longer used. But instead of
> > just deleting it, maybe we could move 'bool load_eoi_exitmap_pending' to
> > its place, so 7 bytes can be saved for each struct kvm_vcpu_arch:
> 
> I prefer leaving load_eoi_exitmap_pending where it is so that it's co-located with
> ioapic_handled_vectors.  I agree wasting 7 bytes is unfortunate, but I don't want
> to take an ad hoc approach to shrinking per-vCPU structs.  See the link below for
> more discussion.
> 
> https://lore.kernel.org/all/20230213163351.30704-1-minipli@grsecurity.net

Fair enough. :)

Thanks
Yu
