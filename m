Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381DA354FBF
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 11:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbhDFJYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 05:24:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:9110 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233638AbhDFJYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 05:24:38 -0400
IronPort-SDR: x4mxE9AOvQ8V/rjoLoSZM4qypt8BF3/su4dLwfXzBfRteHlTISHBB3RRY6t8DojRgGqt97TAaZ
 SGs8SK7Y6kXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="254360297"
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="254360297"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 02:24:30 -0700
IronPort-SDR: UVbSmDRyv30Ig16YPnjSr+++mTyf3DbjHdxAPG6vlouka6O555bZrGxlM0jA4itA7LZXBhntax
 nK2U/YbPi1lg==
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="414692959"
Received: from nkanakap-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.6.197])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 02:24:27 -0700
Date:   Tue, 6 Apr 2021 21:24:24 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 13/25] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-Id: <20210406212424.86d6d4533b144d4621ecb385@intel.com>
In-Reply-To: <20210406090901.GH17806@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
        <20e09daf559aa5e9e680a0b4b5fba940f1bad86e.1616136308.git.kai.huang@intel.com>
        <20210405090759.GB19485@zn.tnic>
        <20210406094421.4fdfbb6c4c11e7ee64c3b0a3@intel.com>
        <20210406073917.GA17806@zn.tnic>
        <20210406205958.084147e365d04d066e4357c1@intel.com>
        <20210406090901.GH17806@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Apr 2021 11:09:01 +0200 Borislav Petkov wrote:
> On Tue, Apr 06, 2021 at 08:59:58PM +1200, Kai Huang wrote:
> > OK. My thinking was that, returning negative error value basically means guest
> > will be killed.
> 
> You need to define how you're going to handle invalid input from the
> guest. If that guest is considered malicious, then sure, killing it
> makes sense.

Such invalid input has already been handled in handle_encls_xx() before calling
the two helpers in this patch. KVM returns to Qemu and let it decide whether to
kill or not. The access_ok()s here are trying to catch KVM bug.

> 
> > For the case access_ok() fails for @secs or other user pointers, it
> > seems killing guest is a little it overkill,
> 
> So don't kill it then - just don't allow it to create an enclave because
> it is doing stupid crap.

If so we'd better inject an exception to guest (and return 1) in KVM so guest
can continue to run. Otherwise basically KVM will return to Qemu and let it
decide (and basically it will kill guest).

I think killing guest is also OK. KVM part patches needs to be updated, though,
anyway.
