Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D139920568C
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733047AbgFWP71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:59:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:31599 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731616AbgFWP70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 11:59:26 -0400
IronPort-SDR: JLvwQvHAfJ24nOt7c4x1dL7A7H+/aMZnYu6O3btioplnOvwzRMNyz5slbB22fKC9lf/DlG0sfs
 g2GhNQv5r0Pw==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="209307529"
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="209307529"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 08:59:22 -0700
IronPort-SDR: iq26dOLKgX3H15tBFZLuja+vdDxalzbD2WF/C0QK3i/G9gmZaftr40VuZiXDtyitN0nWawvHvG
 0hDSMJ3QZjKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="301299965"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 23 Jun 2020 08:59:19 -0700
Date:   Tue, 23 Jun 2020 08:59:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Feiner <pfeiner@google.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: x86 mmu: avoid mmu_page_hash lookup for
 direct_map-only VM
Message-ID: <20200623155918.GC23842@linux.intel.com>
References: <20200508182425.69249-1-jcargill@google.com>
 <20200508201355.GS27052@linux.intel.com>
 <CAM3pwhEw+KYq9AD+z8wPGyG10Bex7xLKaPM=yVV-H+W_eHTW4w@mail.gmail.com>
 <20200623065348.GA23054@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623065348.GA23054@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 11:53:48PM -0700, Sean Christopherson wrote:
> If we do get agressive and zap all children (or if my analysis is wrong),
> and prevent the mixed level insansity, then a simpler approach would be to
> skip the lookup if the MMU is direct.  I.e. no need for the per-VM toggle.
> Direct vs. indirect MMUs are guaranteed to have different roles and so the
> direct MMU's pages can't be reused/shared.

Clarification on the above.  Direct and not-guaranteed-to-be-direct MMUs for
a given VM are guaranteed to have different roles, even for nested NPT vs.
NPT, as nested MMUs will have role.guest_mode=1.
