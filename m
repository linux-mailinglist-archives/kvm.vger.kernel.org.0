Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4B435773E
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 23:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbhDGV6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 17:58:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:11859 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234564AbhDGV6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 17:58:38 -0400
IronPort-SDR: vTjbk66SCgBPC8It3c/vsImOXKPSjn9fbuO+TShLqMaA16+MOuLp4Wm7o+IbxabFZDF4BT+TKp
 C0IDy81Pac7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="190200092"
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="190200092"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 14:58:28 -0700
IronPort-SDR: BabpOlqHEseG8X7HGGhjJvf2IuJujyGAkfILHg89WU3IrkC/Gg80S7k7JO/RZ5JQuoTJoDfQkF
 YoPf0sAUvlcQ==
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="415459012"
Received: from tkokeray-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.113.100])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 14:58:25 -0700
Date:   Thu, 8 Apr 2021 09:58:22 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v4 07/11] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Message-Id: <20210408095822.24d0c709c2680bb78b689ed1@intel.com>
In-Reply-To: <YG4pslLOybyOIDTC@google.com>
References: <cover.1617825858.git.kai.huang@intel.com>
        <963a2416333290e23773260d824a9e038aed5a53.1617825858.git.kai.huang@intel.com>
        <YG4pslLOybyOIDTC@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Apr 2021 21:52:50 +0000 Sean Christopherson wrote:
> On Thu, Apr 08, 2021, Kai Huang wrote:
> > +	/*
> > +	 * Copy contents into kernel memory to prevent TOCTOU attack. E.g. the
> > +	 * guest could do ECREATE w/ SECS.SGX_ATTR_PROVISIONKEY=0, and
> > +	 * simultaneously set SGX_ATTR_PROVISIONKEY to bypass the check to
> > +	 * enforce restriction of access to the PROVISIONKEY.
> > +	 */
> > +	contents = (struct sgx_secs *)__get_free_page(GFP_KERNEL);
> 
> This should use GFP_KERNEL_ACCOUNT.

May I ask why? The page is only a temporary allocation, it will be freed before
this function returns. I guess a 4K page is OK?
