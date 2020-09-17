Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AFF26DF06
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 17:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgIQPEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 11:04:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:21122 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727645AbgIQPDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 11:03:46 -0400
IronPort-SDR: vav8u7jJXxw84y6ucG/yMkLBEltA5CV/+CRcKVCw3tyl3sf5n57GvUAWb0f20CntIbvDyjpjQT
 pbAJPU54HE6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="159767847"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="159767847"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 08:02:19 -0700
IronPort-SDR: tI9dnOdhvLCaT336I7nLJO3Fqbl9ocOeZW/pRCpowbMi80TL9gSrUYngI/wjMbis2FDxePfeQK
 3rJx7Sf5gFnA==
X-IronPort-AV: E=Sophos;i="5.77,437,1596524400"; 
   d="scan'208";a="302968062"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 08:02:18 -0700
Date:   Thu, 17 Sep 2020 08:02:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     yadong.qi@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        liran.alon@oracle.com, nikita.leshchenko@oracle.com,
        chao.gao@intel.com, kevin.tian@intel.com, luhai.chen@intel.com,
        bing.zhu@intel.com, kai.z.wang@intel.com
Subject: Re: [PATCH RFC] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Message-ID: <20200917150217.GA13522@sjchrist-ice>
References: <20200917022501.369121-1-yadong.qi@intel.com>
 <c3eaf796-67f1-9224-3e16-72d93501b6cf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3eaf796-67f1-9224-3e16-72d93501b6cf@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 10:56:18AM +0200, Paolo Bonzini wrote:
> On 17/09/20 04:25, yadong.qi@intel.com wrote:
> > From: Yadong Qi <yadong.qi@intel.com>
> > 
> > Background: We have a lightweight HV, it needs INIT-VMExit and
> > SIPI-VMExit to wake-up APs for guests since it do not monitoring
> > the Local APIC. But currently virtual wait-for-SIPI(WFS) state
> > is not supported in KVM, so when running on top of KVM, the L1
> > HV cannot receive the INIT-VMExit and SIPI-VMExit which cause
> > the L2 guest cannot wake up the APs.
> > 
> > This patch is incomplete, it emulated wait-for-SIPI state by halt
> > the vCPU and emulated SIPI-VMExit to L1 when trapped SIPI signal
> > from L2. I am posting it RFC to gauge whether or not upstream
> > KVM is interested in emulating wait-for-SIPI state before
> > investing the time to finish the full support.
> 
> Yes, the patch makes sense and is a good addition.  What exactly is
> missing?  (Apart from test cases in kvm-unit-tests!)

nested_vmx_run() puts the vCPU into KVM_MP_STATE_HALTED instead of properly
transitioning to INIT_RECEIVED, e.g. events that arrive while the vCPU is
supposed to be in WFS will be incorrectly recognized.  I suspect there are
other gotchas lurking, but that's the big one.
