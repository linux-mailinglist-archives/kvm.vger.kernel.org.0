Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0D5354F50
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 11:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244740AbhDFJAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 05:00:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:12380 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236350AbhDFJAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 05:00:13 -0400
IronPort-SDR: 2yxX6Kol9iL2mSO23+n5yZjaFER7GMvLux6jVKhbNKKRAtIS4d/ygFUjTnGcvQ/YiydCaK/SuD
 OwnqpS2P8kXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="172496451"
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="172496451"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 02:00:06 -0700
IronPort-SDR: pn5etexb1j4E7df9iILkhD2RWzcg23cPh6Ym4GzOZLNpZlQJAsYDNH0wudBWJYQTwY+qVMsBI/
 a0pC6j0rOAXw==
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="421126351"
Received: from nkanakap-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.6.197])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 02:00:01 -0700
Date:   Tue, 6 Apr 2021 20:59:58 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 13/25] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-Id: <20210406205958.084147e365d04d066e4357c1@intel.com>
In-Reply-To: <20210406073917.GA17806@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
        <20e09daf559aa5e9e680a0b4b5fba940f1bad86e.1616136308.git.kai.huang@intel.com>
        <20210405090759.GB19485@zn.tnic>
        <20210406094421.4fdfbb6c4c11e7ee64c3b0a3@intel.com>
        <20210406073917.GA17806@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Apr 2021 09:40:38 +0200 Borislav Petkov wrote:
> On Tue, Apr 06, 2021 at 09:44:21AM +1200, Kai Huang wrote:
> > The intention was to catch KVM bug, since KVM is the only caller, and in current
> > implementation KVM won't call this function if @secs is not a valid userspace
> > pointer. But yes we can also return here, but in this case an exception number
> > must also be specified to *trapnr so that KVM can inject to guest. It's not that
> > straightforward to decide which exception should we inject, but I think #GP
> > should be OK. Please see below.
> 
> Why should you inject anything in that case?
> 
> AFAICT, you can handle the return value in __handle_encls_ecreate() and
> inject only when the return value is EFAULT. If it is another negative
> error value, you pass it back up to its caller, handle_encls_ecreate()
> which returns other error values like -ENOMEM too. Which means, its
> callchain can stomach negative values just fine.
> 

OK. My thinking was that, returning negative error value basically means guest
will be killed.  For the case access_ok() fails for @secs or other user
pointers, it seems killing guest is a little it overkill, but since this code's
purpose is to catch KVM bug, I think killing guest is also OK from this
perspective (like -ENOMEM case, it is kernel/kvm internal error). So yes I
guess we can make handle_encls_xx() to stomach negative values, and only inject
upon -EFAULT.
