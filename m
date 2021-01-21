Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14962FE036
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 04:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbhAUDxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 22:53:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:39997 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732473AbhAUBpP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 20:45:15 -0500
IronPort-SDR: SAC7j8mChwJMjaxyVZ1tX95BmsahxFArI6+xmX4c12kC3ZMe2zoVQlUr9jMQhZAfnRkAmasihy
 STjtg93K50NA==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="178425497"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="178425497"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 17:44:32 -0800
IronPort-SDR: 71MoYarqPlNlHqdH10cCam8FE9cqEV0ZKjgj71R7KdoPDbSdspRSunlTUK3H5yv6mSHuNieDiO
 rx9KIZGJABXQ==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="467280376"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 17:44:28 -0800
Date:   Thu, 21 Jan 2021 14:44:26 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>,
        <kvm@vger.kernel.org>, <x86@kernel.org>, <seanjc@google.com>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH v2 12/26] x86/sgx: Add helper to update
 SGX_LEPUBKEYHASHn MSRs
Message-Id: <20210121144426.361258fb52a4934c0ab92f8c@intel.com>
In-Reply-To: <db1c3826-8299-d83e-95f5-e25ee593b646@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
        <5116fdc732e8e14b3378c44e3b461a43f330ed0c.1610935432.git.kai.huang@intel.com>
        <YAgcIhkmw0lllD3G@kernel.org>
        <8613b3f1-c4f6-3e5d-4406-9476727666a7@intel.com>
        <20210121123625.c45deeccc690138f2417bd41@intel.com>
        <982ddc27-27ec-2d03-54a4-1c0b07e8a3c9@intel.com>
        <20210121140638.b9bac5af44fc0f33996a2853@intel.com>
        <db1c3826-8299-d83e-95f5-e25ee593b646@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Jan 2021 17:15:35 -0800 Dave Hansen wrote:
> On 1/20/21 5:06 PM, Kai Huang wrote:
> > 
> > /*
> >  * Update the SGX_LEPUBKEYHASH MSRs to the values specified by caller.
> >  *
> >  * EINITTOKEN is not used in enclave initialization, which requires
> >  * hash of enclave's signer must match values in SGX_LEPUBKEYHASH MSRs
> >  * to make EINIT be successful.
> >  */
> 
> I'm grumpy, but I hate it.
> 
> I'll stop the bike shedding for now, though.

Jarkko and Dave,

I'll change to use below:

 /*
  * Update the SGX_LEPUBKEYHASH MSRs to the values specified by caller.
  * Bare-metal driver requires to update them to hash of enclave's signer
  * before EINIT. KVM needs to update them to guest's virtual MSR values
  * before doing EINIT from guest.
  */

Please let me know if are not OK with this.
