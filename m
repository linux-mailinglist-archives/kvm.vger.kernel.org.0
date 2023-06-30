Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491757438D0
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 12:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbjF3KAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 06:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbjF3KAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 06:00:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73BE2728;
        Fri, 30 Jun 2023 02:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688119196; x=1719655196;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QGADKNyESx2s/DzdJordA2PV6zGAyu24ihv4MNiI0Vs=;
  b=Pd0PzPUEU7EGMIKp8IalOcPSqz1xYyBnrpJncjoNUTdaeY5IrxNhHsXo
   P1nHOt3gampB2ezXifRQQXf1G6fiO74TlnHMUpbKxA05rgBS6+AN2fK03
   WTcXflu5B+yqSTG58H6OLMnnSyDRQZlbMkKeM1I6sCZI+WMXZlMJnHnUZ
   af/nv2W0LifLPhmO/WHM6/qg82aXZvI6N3+QRb7ewepZFBJPW1PINEmR3
   bD+Jc+T9ZpF2uKi90D2JONF4fRRc61JL10vuz8G/U0l2z2HIGdRzp2PPo
   rhlMwMniVcHDZB8ffK9mP/cPZI+I+jul1+T51C0l+xOCMTH8ClD1uP4qT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="393086724"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="393086724"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 02:59:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="787670161"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="787670161"
Received: from yijiang-mobl1.ccr.corp.intel.com (HELO localhost) ([10.254.212.46])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 02:59:53 -0700
Date:   Fri, 30 Jun 2023 18:00:01 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 08/12] KVM: nSVM: Use KVM-governed feature framework to
 track "vVM{SAVE,LOAD} enabled"
Message-ID: <20230630100001.vmzlrtaw5fq5pisn@linux.intel.com>
References: <20230217231022.816138-1-seanjc@google.com>
 <20230217231022.816138-9-seanjc@google.com>
 <20230221152349.ulcjtbnvziair7ff@linux.intel.com>
 <20230221153306.qubx7tfmasnvodeu@linux.intel.com>
 <Y/VYN3n/lHePiDxM@google.com>
 <20230222064931.ppz6berhfr4edewf@linux.intel.com>
 <Y/ZFJfspU6L2RmQS@google.com>
 <ZJ22Wts4WKKD19bN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJ22Wts4WKKD19bN@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023 at 09:50:34AM -0700, Sean Christopherson wrote:
> On Wed, Feb 22, 2023, Sean Christopherson wrote:
> > +Maxim
> > 
> > On Wed, Feb 22, 2023, Yu Zhang wrote:
> > I'll opportunistically massage the comment to make it more explicit about why
> > VMLOAD needs to be intercepted.
> >  
> > That said, clearing the bits for this seems wrong.  That would corrupt the MSRs
> > for 64-bit Intel guests.  The "target" of the fix was 32-bit L2s, i.e. I doubt
> > anything would notice.
> > 
> >     This patch fixes nested migration of 32 bit nested guests, that was
> >     broken because incorrect cached values of SYSENTER msrs were stored in
> >     the migration stream if L1 changed these msrs with
> >     vmload prior to L2 entry.
> 
> Aha!  Finally figured out what this code is doing.  KVM intercepts VMLOAD so that
> KVM can correctly model the VMLOAD behavior of dropping bits 63:32, i.e. to clear
> svm->sysenter_eip_hi and svm->sysenter_esp_hi.
> 
> So the code is correct.  I'll add this comment:
> 
> 	/*
> 	 * Intercept VMLOAD if the vCPU mode is Intel in order to emulate that
> 	 * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that exposing
> 	 * SVM on Intel is bonkers and extremely unlikely to work).
> 	 */
> 
Oh.. Because L2 will never be a 64-bit Intel guest, and the emulation of vmload
shall follow APM's requirement(to clear the upper 32 bits)?

Thanks a lot for bring me back to this discussion... I totally forgot it. :)

B.R.
Yu
 
Thanks a lot for this explanation, Sean! 
