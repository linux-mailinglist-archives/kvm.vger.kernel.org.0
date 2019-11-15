Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3144EFD2EF
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 03:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKOCaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 21:30:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:52067 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727075AbfKOCaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 21:30:18 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 18:30:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,306,1569308400"; 
   d="scan'208";a="199050528"
Received: from guptapadev.jf.intel.com (HELO guptapadev.amr) ([10.7.198.56])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2019 18:30:17 -0800
Date:   Thu, 14 Nov 2019 18:23:28 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        "Gupta, Pawan Kumar" <pawan.kumar.gupta@intel.com>
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
Message-ID: <20191115022328.GC18745@guptapadev.amr>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
 <23353382-53ea-8b20-7e30-763ef6df374c@siemens.com>
 <ea5a084b-e047-6677-b8fe-d7bb6f8c0ef8@redhat.com>
 <20191113232510.GB891@guptapadev.amr>
 <671b49ab-f65d-8b44-4da6-137d05cd1b9c@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <671b49ab-f65d-8b44-4da6-137d05cd1b9c@siemens.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 14, 2019 at 09:13:22AM +0100, Jan Kiszka wrote:
> On 14.11.19 00:25, Pawan Gupta wrote:
> > On Wed, Nov 13, 2019 at 09:23:30AM +0100, Paolo Bonzini wrote:
> > > On 13/11/19 07:38, Jan Kiszka wrote:
> > > > When reading MCE, error code 0150h, ie. SRAR, I was wondering if that
> > > > couldn't simply be handled by the host. But I suppose the symptom of
> > > > that erratum is not "just" regular recoverable MCE, rather
> > > > sometimes/always an unrecoverable CPU state, despite the error code, right?
> > > 
> > > The erratum documentation talks explicitly about hanging the system, but
> > > it's not clear if it's just a result of the OS mishandling the MCE, or
> > > something worse.  So I don't know. :(  Pawan, do you?
> > 
> > As Dave mentioned in the other email its "something worse".
> > 
> > Although this erratum results in a machine check with the same MCACOD
> > signature as an SRAR error (0x150) the MCi_STATUS.PCC bit will be set to
> > one. The Intel Software Developers manual says that PCC=1 errors are
> > fatal and cannot be recovered.
> > 
> > 	15.10.4.1 Machine-Check Exception Handler for Error Recovery [1]
> > 
> > 	[...]
> > 	The PCC flag in each IA32_MCi_STATUS register indicates whether recovery
> > 	from the error is possible for uncorrected errors (UC=1). If the PCC
> > 	flag is set for enabled uncorrected errors (UC=1 and EN=1), recovery is
> > 	not possible.
> > 
> 
> And, as Dave observed, even that event is not delivered to software (maybe
> just logged by firmware for post-reset analysis) but can or does cause a
> machine lock-up, right?

It can either cause a machine lock-up or a reset and the event delivery
to the software is not guaranteed.

Thanks,
Pawan
