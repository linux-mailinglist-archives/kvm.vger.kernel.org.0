Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0168D15854D
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 22:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgBJV7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 16:59:51 -0500
Received: from mga04.intel.com ([192.55.52.120]:20034 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgBJV7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 16:59:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Feb 2020 13:59:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,426,1574150400"; 
   d="scan'208";a="433469425"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 10 Feb 2020 13:59:49 -0800
Date:   Mon, 10 Feb 2020 13:59:49 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        David Laight <David.Laight@aculab.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86: Emulate split-lock access as a write
Message-ID: <20200210215949.GD2510@linux.intel.com>
References: <db3b854fd03745738f46cfce451d9c98@AcuMS.aculab.com>
 <777C5046-B9DE-4F8C-B04F-28A546AE4A3F@amacapital.net>
 <20200131200134.GD18946@linux.intel.com>
 <87y2timmto.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2timmto.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 04, 2020 at 03:47:15PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Exiting to host userspace with "emulation failed" is the other reasonable
> > alternative, but that's basically the same as killing the guest.  We're
> > arguing that, in the extremely unlikely event that there is a workload out
> > there that hits this, it's preferable to *maybe* corrupt guest memory and
> > log the anomaly in the kernel log, as opposed to outright killing the guest
> > with a generic "emulation failed".
> >
> 
> FWIW, if I was to cast a vote I'd pick 'kill the guest' one way or
> another. "Maybe corrupt guest memory" scares me much more and in many
> cases host and guest are different responsibility domains (think
> 'cloud').

I'm ok with that route as well.  What I don't want to do is add a bunch of
logic to inject #AC at this point.
