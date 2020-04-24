Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163371B785B
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 16:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgDXOeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 10:34:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:31494 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgDXOeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 10:34:22 -0400
IronPort-SDR: TfnhMSsQRnEXA4CHX18RcdJn+w2aMvjpJjRLqIPW/OW4ry/0J0dp3qJ/eirmZ/SpHid1++GfFT
 2ycWcp3NxO/Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 07:34:22 -0700
IronPort-SDR: AKQx+Q6I8AhwqJWDCmQMDj9GhEBZRV/xxvWXNjhakbfnAW3QTI2R8Zolf5sh/rJxEc7haI/JyM
 Bq2EIkeywyiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="280814004"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 24 Apr 2020 07:34:19 -0700
Date:   Fri, 24 Apr 2020 22:36:21 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 4/9] KVM: VMX: Check CET dependencies on CR settings
Message-ID: <20200424143621.GI24039@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-5-weijiang.yang@intel.com>
 <20200423172032.GI17824@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423172032.GI17824@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 10:20:32AM -0700, Sean Christopherson wrote:
> On Thu, Mar 26, 2020 at 04:18:41PM +0800, Yang Weijiang wrote:
> > CR4.CET is master control bit for CET function.
> > There're mutual constrains between CR0.WP and CR4.CET, so need
> > to check the dependent bit while changing the control registers.
> > 
> > Note:
> > 1)The processor does not allow CR4.CET to be set if CR0.WP = 0,
> >   similarly, it does not allow CR0.WP to be cleared while
> >   CR4.CET = 1. In either case, KVM would inject #GP to guest.
> 
> Nit: the CET vs. WP dependency and #GP belongs in the "main" part of the
> changelog, as it's the crux of the patch.  Item (2) below is more along
> the lines of "note" material.
>
OK, will change it, thank you!
> > 
> > 2)SHSTK and IBT features share one control MSR:
> >   MSR_IA32_{U,S}_CET, which means it's difficult to hide
> >   one feature from another in the case of SHSTK != IBT,
> >   after discussed in community, it's agreed to allow guest
> >   control two features independently as it won't introduce
> >   security hole.
> > 
 > 
