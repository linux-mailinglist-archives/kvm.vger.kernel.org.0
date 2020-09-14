Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D562697CA
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 23:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgINVhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 17:37:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:65304 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgINVhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 17:37:12 -0400
IronPort-SDR: M1rvg5w6s6IWdEDKkfXhNQ7SjWUY05USmYB1fanmF54ptbFfDEfZJo7Q2vlslWLkevsAxbT610
 LaQly1E9a7Xw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="139175439"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="139175439"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:37:10 -0700
IronPort-SDR: 1qipLXuLehnUbJKq9UzwT7QTjP6+RAK1R5zgEyJ/aLk/KMGY7LnGD83MNiUBXPz7U9DQG9V43J
 KTK3QppWsmmw==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="507297459"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:37:10 -0700
Date:   Mon, 14 Sep 2020 14:37:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH 25/35] KVM: x86: Update __get_sregs() / __set_sregs()
 to support SEV-ES
Message-ID: <20200914213708.GC7192@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <e08f56496a52a3a974310fbe05bb19100fd6c1d8.1600114548.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e08f56496a52a3a974310fbe05bb19100fd6c1d8.1600114548.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:15:39PM -0500, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Since many of the registers used by the SEV-ES are encrypted and cannot
> be read or written, adjust the __get_sregs() / __set_sregs() to only get
> or set the registers being tracked (efer, cr0, cr4 and cr8) once the VMSA
> is encrypted.

Is there an actual use case for writing said registers after the VMSA is
encrypted?  Assuming there's a separate "debug mode" and live migration has
special logic, can KVM simply reject the ioctl() if guest state is protected?
