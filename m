Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAF91785CA
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 23:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgCCWlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 17:41:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:50140 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgCCWlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 17:41:52 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 14:41:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="229102698"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2020 14:41:51 -0800
Date:   Tue, 3 Mar 2020 14:41:51 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/61] KVM: VMX: Add helpers to query Intel PT mode
Message-ID: <20200303224150.GA17816@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-20-sean.j.christopherson@intel.com>
 <87pne8q8c0.fsf@vitty.brq.redhat.com>
 <20200224221807.GM29865@linux.intel.com>
 <33a4d99d-98da-0bd8-0f9c-fc04bef54350@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33a4d99d-98da-0bd8-0f9c-fc04bef54350@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disclaimer: I'm going off a few lines in the SDM and the original patches,
everything I say could be completely wrong :-)

On Tue, Feb 25, 2020 at 03:54:21PM +0100, Paolo Bonzini wrote:
> On 24/02/20 23:18, Sean Christopherson wrote:
> >>>  {
> >>>  	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
> >>> -	if (pt_mode == PT_MODE_SYSTEM)
> >>> +	if (vmx_pt_mode_is_system())
> >> ... and here? I.e. to cover the currently unsupported 'host-only' mode.
> > Hmm, good question.  I don't think so?  On VM-Enter, RTIT_CTL would need to
> > be loaded to disable PT.  Clearing RTIT_CTL on VM-Exit would be redundant
> > at that point[1].  And AIUI, the PIP for VM-Enter/VM-Exit isn't needed
> > because there is no context switch from the decoder's perspective.
> 
> How does host-only mode differ from "host-guest but don't expose PT to
> the guest"?  So I would say that host-only mode is a special case of
> host-guest, not of system mode.

AIUI, host-guest needs a special packet for VM-Enter/VM-Exit so that the
trace analyzer understands there was a context switch.  With host-only, the
packet isn't needed because tracing stops entirely.  So it's not that
host-only is a special case of system mode, but rather it doesn't need the
VM-Exit control enabled to generate the special packet.
