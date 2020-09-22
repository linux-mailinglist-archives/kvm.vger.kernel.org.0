Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881E127382E
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 03:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgIVBsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 21:48:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:23180 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728726AbgIVBsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 21:48:40 -0400
IronPort-SDR: w0VtyY6O5VdxRNet/a3IMR7hOm+Vkw5IyHXYU/NCOSyE8EAK0zuJ1StJvx5Ce2KUbVpikVpiFo
 MjMQRkPmv8lA==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="157889550"
X-IronPort-AV: E=Sophos;i="5.77,288,1596524400"; 
   d="scan'208";a="157889550"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 18:48:40 -0700
IronPort-SDR: EKmRzOaBuIIW9inV+MyT74mc9qgnnr0UMVwHIISz1HktLahGd3wNsAXDVEIGZvfEifGjgr4AFM
 SqGdYcQR+2JQ==
X-IronPort-AV: E=Sophos;i="5.77,288,1596524400"; 
   d="scan'208";a="510967132"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 18:48:39 -0700
Date:   Mon, 21 Sep 2020 18:48:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     thomas.lendacky@amd.com, pbonzini@redhat.com, tj@kernel.org,
        lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        gingell@google.com, rientjes@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Message-ID: <20200922014836.GA26507@linux.intel.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922004024.3699923-1-vipinsh@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 21, 2020 at 05:40:22PM -0700, Vipin Sharma wrote:
> Hello,
> 
> This patch series adds a new SEV controller for tracking and limiting
> the usage of SEV ASIDs on the AMD SVM platform.
> 
> SEV ASIDs are used in creating encrypted VM and lightweight sandboxes
> but this resource is in very limited quantity on a host.
> 
> This limited quantity creates issues like SEV ASID starvation and
> unoptimized scheduling in the cloud infrastructure.
> 
> SEV controller provides SEV ASID tracking and resource control
> mechanisms.

This should be genericized to not be SEV specific.  TDX has a similar
scarcity issue in the form of key IDs, which IIUC are analogous to SEV ASIDs
(gave myself a quick crash course on SEV ASIDs).  Functionally, I doubt it
would change anything, I think it'd just be a bunch of renaming.  The hardest
part would probably be figuring out a name :-).

Another idea would be to go even more generic and implement a KVM cgroup
that accounts the number of VMs of a particular type, e.g. legacy, SEV,
SEV-ES?, and TDX.  That has potential future problems though as it falls
apart if hardware every supports 1:MANY VMs:KEYS, or if there is a need to
account keys outside of KVM, e.g. if MKTME for non-KVM cases ever sees the
light of day.
