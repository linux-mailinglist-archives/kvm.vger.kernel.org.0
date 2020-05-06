Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD99B1C6660
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 05:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgEFDcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 23:32:53 -0400
Received: from mga07.intel.com ([134.134.136.100]:40353 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgEFDcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 23:32:52 -0400
IronPort-SDR: fJ+/Q/M08uUGj3XW3VdUoFAAM4zL4I/MeLNmb4gXjIVZYHdY0PXOo8zHR8z6PwQ0r9w0yxyu68
 nG3tiLIRv5yg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2020 20:32:48 -0700
IronPort-SDR: i0SZQFsQQNsDLmf/ER3DwkHH+b5tObGvFaY0MHHfkFkRX3rLDsrBiX44lKp89GaRoaaPQSNa1m
 TvYSGdqpT/eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,357,1583222400"; 
   d="scan'208";a="259972212"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 05 May 2020 20:32:48 -0700
Date:   Tue, 5 May 2020 20:32:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Qian Cai <cai@lca.pw>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Intel KVM entry failed, hardware error 0x0
Message-ID: <20200506033247.GC19271@linux.intel.com>
References: <014D7571-6281-457C-9CF3-693809E9F651@lca.pw>
 <20200506030014.GB19271@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200506030014.GB19271@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 08:00:15PM -0700, Sean Christopherson wrote:
> On Tue, May 05, 2020 at 10:32:15PM -0400, Qian Cai wrote:
> > Today’s linux-next started to fail with this config,
> > 
> > https://raw.githubusercontent.com/cailca/linux-mm/master/kcsan.config
> > 
> > qemu-kvm-2.12.0-99.module+el8.2.0+5827+8c39933c.x86_64
> > 
> > I believe it was working yesterday. Before I bury myself bisecting it, does
> > anyone have any thought?
> 
> It reproduces for me as well with my vanilla config in a VM.  I can debug
> and/or bisect, should be quite quick in a VM.
> 
> VM is bailing on the EPT Violation at the reset vector, i.e. on the very
> first exit.  Presumably KVM is incorrectly setting vmx->fail somewhere.

The __FILL_RETURN_BUFFER in the VM-Exit path was recently modified and
changed how it clobbered EFLAGS, which causes KVM to think VM-Enter failed.
Commit 089dd8e53126 ("x86/speculation: Change FILL_RETURN_BUFFER to work
with objtool") introduced the change, but this is really a bug in KVM.  The
VM-Exit path shouldn't rely on __FILL_RETURN_BUFFER to set EFLAGS to a
specific state, i.e. EFLAGS was always being clobbered, it just happened to
work before now.

I'll get a patch sent out shortly.
