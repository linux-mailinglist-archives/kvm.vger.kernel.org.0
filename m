Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB0210A933
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 04:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfK0Doo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 22:44:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:55996 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbfK0Doo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 22:44:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Nov 2019 19:44:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,248,1571727600"; 
   d="scan'208";a="291935296"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Nov 2019 19:44:43 -0800
Date:   Tue, 26 Nov 2019 19:44:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: SVM: Fix "error" isn't initialized
Message-ID: <20191127034443.GF22233@linux.intel.com>
References: <3b418fab6b804c6cba48e372cce875c1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b418fab6b804c6cba48e372cce875c1@huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 27, 2019 at 03:30:06AM +0000, linmiaohe wrote:
> 
> > From: Haiwei Li <lihaiwei@tencent.com>
> > Subject: [PATCH] initialize 'error'
> >
> > There are a bunch of error paths were "error" isn't initialized.
> Hi,
> In case error case, sev_guest_df_flush() do not set the error.
> Can you set the value of error to reflect what error happened
> in sev_guest_df_flush()?
> The current fix may looks confused when print "DF_FLUSH failed" with
> error = 0.
> Thanks. 
> 
> PS: This is just my personal point.

Disclaimer: not my world at all...

Based on the prototype for __sev_do_cmd_locked(), @error is intended to be
filled only if there's an actual response from the PSP, which is a 16-bit
value.  So maybe init @psp_ret at the beginning of __sev_do_cmd_locked() to
-1 to indicate the command was never sent to the PSP?  And update the
pr_err() in sev_asid_flush() to explicitly state it's the PSP return?
