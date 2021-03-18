Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E99333FC14
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 01:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCRAFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 20:05:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:8467 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhCRAEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 20:04:42 -0400
IronPort-SDR: Sdq4axED8jAW44mjiF0G0btHCXOrfRTiP9UvxyjBxXkS6KrnJBMFXWFIGc981jf4iP+aPbU2Ni
 VDvlpF7Azalg==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="189616265"
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="189616265"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 17:04:41 -0700
IronPort-SDR: 90z7G9OzJqazdvZZK4s4do097MALZckYL92A89LgmUp8nt6fbBdXZnmAPQYuBalaJfe3z6dcJD
 hmiGamQMQkFg==
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="389029351"
Received: from salemhax-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.143.20])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 17:04:37 -0700
Date:   Thu, 18 Mar 2021 13:04:35 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-Id: <20210318130435.4cf6142368bb1837c585b447@intel.com>
In-Reply-To: <YFCojQmyM8fdGmnl@kernel.org>
References: <YE0NeChRjBlldQ8H@kernel.org>
        <YE4M8JGGl9Xyx51/@kernel.org>
        <YE4rVnfQ9y7CnVvr@kernel.org>
        <20210315161317.9c72479dfcde4e22078abcd2@intel.com>
        <YE9beKYDaG1sMWq+@kernel.org>
        <YE9mVUF0KOPNSfA9@kernel.org>
        <20210316094859.7b5947b743a81dff7434615c@intel.com>
        <YE/oHt92suFDHJ7Z@kernel.org>
        <YE/o/IGBAB8N+fnt@kernel.org>
        <YFAGUWDYacz1zroI@google.com>
        <YFCojQmyM8fdGmnl@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Mar 2021 14:46:05 +0200 Jarkko Sakkinen wrote:
> On Mon, Mar 15, 2021 at 06:13:53PM -0700, Sean Christopherson wrote:
> > On Tue, Mar 16, 2021, Jarkko Sakkinen wrote:
> > > On Tue, Mar 16, 2021 at 01:05:05AM +0200, Jarkko Sakkinen wrote:
> > > > The way I've understood it is that given that KVM can support SGX
> > > > without FLC, vEPC should be available even if driver cannot be
> > > > enabled.
> > > > 
> > > > This is also exactly what the short summary states.
> > > > 
> > > > "Initialize virtual EPC driver even when SGX driver is disabled"
> > > > 
> > > > It *does not* state:
> > > > 
> > > > "Initialize SGX driver even when vEPC driver is disabled"
> > > > 
> > > > Also, this is how I interpret the inline comment.
> > > > 
> > > > All this considered, the other direction is undocumented functionality.
> > > 
> > > Also:
> > > 
> > > 1. There is *zero* good practical reasons to support the "2nd direction".
> > 
> > Uh, yes there is.  CONFIG_KVM_INTEL=n and X86_FEATURE_VMX=n, either of which
> > will cause vEPC initialization to fail.  The former is obvious, the latter is
> > possible via BIOS configuration.
> 
> Hmm... So you make the checks as if ret != -ENODEV? That's the sane way to
> deal with that situation IMHO.
> 
> /Jarkko

OK. I actually wrote the code to show your idea:

-       ret = sgx_drv_init();
-       if (ret)
+       /*
+        * Only continue to initialize SGX driver when SGX virtualization
+        * initialization is successful, or is not supported (-ENODEV), since
+        * any other initialization failure means SGX driver is unlikely to be
+        * initialized successfully.
+        */
+       ret = sgx_vepc_init();
+       if (ret && ret != -ENODEV)
                goto err_kthread;
 
+       if (sgx_drv_init()) {
+               /*
+                * Cleanup when *both* SGX virtualization and SGX driver are
+                * not enabled, due to either not supported (-ENODEV), or
+                * somehow fail to initialize.
+                */
+               if (ret && ret != -ENODEV)
+                       goto err_kthread;
+       }
+
        return 0;
 
 err_kthread:


Is this the code you want?
