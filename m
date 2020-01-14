Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F005213B21B
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 19:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgANS2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 13:28:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:1435 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgANS2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 13:28:44 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 10:28:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,319,1574150400"; 
   d="scan'208";a="372660529"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 14 Jan 2020 10:28:44 -0800
Date:   Tue, 14 Jan 2020 10:28:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Emulate MTF when performing instruction
 emulation
Message-ID: <20200114182843.GG16784@linux.intel.com>
References: <20200113221053.22053-1-oupton@google.com>
 <20200113221053.22053-3-oupton@google.com>
 <20200114000517.GC14928@linux.intel.com>
 <CALMp9eR0444XUptR6a57JVZwrCSks9dndeDZcQBZ-v0NRctcZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eR0444XUptR6a57JVZwrCSks9dndeDZcQBZ-v0NRctcZg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 14, 2020 at 09:58:22AM -0800, Jim Mattson wrote:
> On Mon, Jan 13, 2020 at 4:05 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> 
> > Another case, which may or may not be possible, is if INIT is recognized
> > on the same instruction, in which case it takes priority over MTF.  SMI
> > might also be an issue.
> 
> Don't we already have a priority inversion today when INIT or SMI are
> coincident with a debug trap on the previous instruction (e.g.
> single-step trap on an emulated instruction)?

Liran fixed the INIT issue in commit 4b9852f4f389 ("KVM: x86: Fix INIT
signal handling in various CPU states").

SMI still appears to be inverted.
