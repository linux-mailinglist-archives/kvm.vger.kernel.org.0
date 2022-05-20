Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83D352E456
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 07:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbiETF1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 01:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbiETF1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 01:27:07 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B003C6B03F
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 22:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653024421; x=1684560421;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cI9uGBjhJtWFGhhOy8Mi22BCW4I7JOWQiAbMT6V9JNg=;
  b=fA+z3Ktsz32R8yXxF3PfEi2+H5SKH/s7UOVp7Q4BqUP4pJ3zaHwqA9SL
   S6w1788RMfzwP5LTyTyiDAAp8Wdv9S6uKjZBdQQQgf84XBB7ey2rtZMiR
   DwECOYZJQmdITmRFryX97XIq8ZOriCscmndE7282T0A66Wkt4ydQEg0X1
   iNsXNk8yfp8Q6YEgkKOkGKaPsLpmWOQxHnsTY8fnwpfHqhANgnSwpbRyA
   CNVe4bYmokG7BF7o50b/PcTsTLJ5KutNIwkbWQBSF2KX65cEuVfU88Q2k
   s2OZy0pj2bVrZLM3JFhxWmxV9R9T2SoH6upd8XgGt9s0ki+0TrzDmwlaG
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="333119772"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="333119772"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 22:27:01 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="599018451"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 22:26:58 -0700
Date:   Fri, 20 May 2022 13:26:49 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Cc:     qemu-devel@nongnu.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        mst@redhat.com, "Grimm, Jon" <jon.grimm@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Wei Huang <wei.huang2@amd.com>
Subject: Re: [RFC] KVM / QEMU: Introduce Interface for Querying APICv Info
Message-ID: <20220520052644.GA15937@gao-cwp>
References: <7e0d22fa-b9b0-ad1a-3a37-a450ec5d73e8@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e0d22fa-b9b0-ad1a-3a37-a450ec5d73e8@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 10:30:40AM +0700, Suthikulpanit, Suravee wrote:
>Hi All,
>
>Currently, we don't have a good way to check whether APICV is active on a VM.
>Normally, For AMD SVM AVIC, users either have to check for trace point, or using
>"perf kvm stat live" to catch AVIC-related #VMEXIT.
>
>For KVM, I would like to propose introducing a new IOCTL interface (i.e. KVM_GET_APICV_INFO),
>where user-space tools (e.g. QEMU monitor) can query run-time information of APICv for VM and vCPUs
>such as APICv inhibit reason flags.
>
>For QEMU, we can leverage the "info lapic" command, and append the APICV information after
>all LAPIC register information:
>
>For example:
>
>----- Begin Snippet -----
>(qemu) info lapic 0
>dumping local APIC state for CPU 0
>
>LVT0     0x00010700 active-hi edge  masked                      ExtINT (vec 0)
>LVT1     0x00000400 active-hi edge                              NMI
>LVTPC    0x00010000 active-hi edge  masked                      Fixed  (vec 0)
>LVTERR   0x000000fe active-hi edge                              Fixed  (vec 254)
>LVTTHMR  0x00010000 active-hi edge  masked                      Fixed  (vec 0)
>LVTT     0x000400ee active-hi edge                 tsc-deadline Fixed  (vec 238)
>Timer    DCR=0x0 (divide by 2) initial_count = 0 current_count = 0
>SPIV     0x000001ff APIC enabled, focus=off, spurious vec 255
>ICR      0x000000fd physical edge de-assert no-shorthand
>ICR2     0x00000005 cpu 5 (X2APIC ID)
>ESR      0x00000000
>ISR      (none)
>IRR      (none)
>
>APR 0x00 TPR 0x00 DFR 0x0f LDR 0x00PPR 0x00
>
>APICV   vm inhibit: 0x10 <-- HERE
>APICV vcpu inhibit: 0 <-- HERE
>
>------ End Snippet ------
>
>Otherwise, we can have APICv-specific info command (e.g. info apicv).

I think this information can be added to kvm per-vm/vcpu debugfs. Then no
qemu change is needed.
