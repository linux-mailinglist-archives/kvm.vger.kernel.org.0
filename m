Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230421BE4C0
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 19:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgD2RHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 13:07:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:60134 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgD2RHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 13:07:35 -0400
IronPort-SDR: kMgx6c0YEpzFsZm5ZzhOFkdWWM9cE0Uizaj60paNVtRbGV4w5+8rys/zHLj5IB7D1IImb6CA8m
 RidxYJGi6ITg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 10:07:33 -0700
IronPort-SDR: 4XpjKDssQOU52jRwGmVBekrEIif3t0LGERmfHkrJ8yTGZLP/jtaCmkj8m1D16mqwWJvAldr8j0
 AIwAx81rxcqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="276237089"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 29 Apr 2020 10:07:33 -0700
Date:   Wed, 29 Apr 2020 10:07:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 12/13] KVM: x86: Replace late check_nested_events() hack
 with more precise fix
Message-ID: <20200429170733.GG15992@linux.intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
 <20200423022550.15113-13-sean.j.christopherson@intel.com>
 <CALMp9eTiGdYPpejAOLNz7zzqP1wPXb_zSL02F27VMHeHGzANJg@mail.gmail.com>
 <20200428222010.GN12735@linux.intel.com>
 <6b35ec9b-9565-ea6c-3de5-0957a9f76257@redhat.com>
 <20200429164547.GF15992@linux.intel.com>
 <286738de-c268-f0b6-f589-6d9d9ad3dc4a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <286738de-c268-f0b6-f589-6d9d9ad3dc4a@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 29, 2020 at 06:58:45PM +0200, Paolo Bonzini wrote:
> On 29/04/20 18:45, Sean Christopherson wrote:
> > 
> > Can you just drop 9/13, "Prioritize SMI over nested IRQ/NMI" from kvm/queue?
> > It's probably best to deal with this in a new series rather than trying to
> > squeeze it in.
> 
> With AMD we just have IRQ/NMI/SMI, and it's important to handle SMI in

Ah, forgot about that angle.

> check_nested_events because you can turn SMIs into vmexit without stuff
> such as dual-monitor treatment.  On the other hand there is no MTF and
> we're not handling exceptions yet.  So, since SMIs should be pretty rare
> anyway, I'd rather just add a comment detailing the correct order and
> why we're not following it.  The minimal fix would be to move SMI above
> the preemption timer, right?

Yep, that works for now.

I'd still like to do a full fix for SMI and INIT.  Correctness aside, I
think/hope the changes I have in mind will make it easier to connect the
dots betwen KVM's event priority and the SDM's event priority.  But that
can definitely wait for 5.9.
