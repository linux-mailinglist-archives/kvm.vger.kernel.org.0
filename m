Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7998EFBCA0
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 00:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfKMXb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 18:31:59 -0500
Received: from mga18.intel.com ([134.134.136.126]:1666 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfKMXb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 18:31:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 15:31:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,302,1569308400"; 
   d="scan'208";a="207609765"
Received: from guptapadev.jf.intel.com (HELO guptapadev.amr) ([10.7.198.56])
  by orsmga003.jf.intel.com with ESMTP; 13 Nov 2019 15:31:57 -0800
Date:   Wed, 13 Nov 2019 15:25:10 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        "Gupta, Pawan Kumar" <pawan.kumar.gupta@intel.com>
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
Message-ID: <20191113232510.GB891@guptapadev.amr>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
 <23353382-53ea-8b20-7e30-763ef6df374c@siemens.com>
 <ea5a084b-e047-6677-b8fe-d7bb6f8c0ef8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea5a084b-e047-6677-b8fe-d7bb6f8c0ef8@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 13, 2019 at 09:23:30AM +0100, Paolo Bonzini wrote:
> On 13/11/19 07:38, Jan Kiszka wrote:
> > When reading MCE, error code 0150h, ie. SRAR, I was wondering if that
> > couldn't simply be handled by the host. But I suppose the symptom of
> > that erratum is not "just" regular recoverable MCE, rather
> > sometimes/always an unrecoverable CPU state, despite the error code, right?
> 
> The erratum documentation talks explicitly about hanging the system, but
> it's not clear if it's just a result of the OS mishandling the MCE, or
> something worse.  So I don't know. :(  Pawan, do you?

As Dave mentioned in the other email its "something worse".

Although this erratum results in a machine check with the same MCACOD
signature as an SRAR error (0x150) the MCi_STATUS.PCC bit will be set to
one. The Intel Software Developers manual says that PCC=1 errors are
fatal and cannot be recovered.

	15.10.4.1 Machine-Check Exception Handler for Error Recovery [1]

	[...]
	The PCC flag in each IA32_MCi_STATUS register indicates whether recovery
	from the error is possible for uncorrected errors (UC=1). If the PCC
	flag is set for enabled uncorrected errors (UC=1 and EN=1), recovery is
	not possible.

Thanks,
Pawan

[1]
https://www.intel.com/content/www/us/en/architecture-and-technology/64-ia-32-architectures-software-developer-vol-3b-part-2-manual.html
