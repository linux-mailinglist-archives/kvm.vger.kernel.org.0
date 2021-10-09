Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34954277F6
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 09:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhJIHw7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 9 Oct 2021 03:52:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:64852 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhJIHw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Oct 2021 03:52:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10131"; a="213786643"
X-IronPort-AV: E=Sophos;i="5.85,360,1624345200"; 
   d="scan'208";a="213786643"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2021 00:51:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,360,1624345200"; 
   d="scan'208";a="440881816"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 09 Oct 2021 00:51:00 -0700
Received: from shsmsx602.ccr.corp.intel.com (10.109.6.142) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sat, 9 Oct 2021 00:50:59 -0700
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX602.ccr.corp.intel.com (10.109.6.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sat, 9 Oct 2021 15:50:58 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2242.012;
 Sat, 9 Oct 2021 15:50:57 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "erdemaktas@google.com" <erdemaktas@google.com>,
        "Connor Kuehl" <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>
Subject: RE: [RFC PATCH v2 07/69] KVM: TDX: define and export helper functions
 for KVM TDX support
Thread-Topic: [RFC PATCH v2 07/69] KVM: TDX: define and export helper
 functions for KVM TDX support
Thread-Index: AQHXb45gwUyUjxU7oUmevY7jRUUgu6vK2P1A
Date:   Sat, 9 Oct 2021 07:50:57 +0000
Message-ID: <bd974cdc810443748d8e4e3c7d1677a5@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <4fe4ce4faf5ad117f81d411deb00ef3b9657c842.1625186503.git.isaku.yamahata@intel.com>
In-Reply-To: <4fe4ce4faf5ad117f81d411deb00ef3b9657c842.1625186503.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Saturday, July 3, 2021 6:04 AM, Isaku Yamahata wrote:
> Subject: [RFC PATCH v2 07/69] KVM: TDX: define and export helper functions
> for KVM TDX support
> +/*
> + * Setup one-cpu-per-pkg array to do package-scoped SEAMCALLs. The
> +array is
> + * only necessary if there are multiple packages.
> + */
> +int __init init_package_masters(void)
> +{
> +	int cpu, pkg, nr_filled, nr_pkgs;
> +
> +	nr_pkgs = topology_max_packages();
> +	if (nr_pkgs == 1)
> +		return 0;
> +
> +	tdx_package_masters = kcalloc(nr_pkgs, sizeof(int), GFP_KERNEL);


Where is the corresponding kfree() invoked? (except the one invoked on error conditions below)


> +	if (!tdx_package_masters)
> +		return -ENOMEM;
> +
> +	memset(tdx_package_masters, -1, nr_pkgs * sizeof(int));
> +
> +	nr_filled = 0;
> +	for_each_online_cpu(cpu) {
> +		pkg = topology_physical_package_id(cpu);
> +		if (tdx_package_masters[pkg] >= 0)
> +			continue;
> +
> +		tdx_package_masters[pkg] = cpu;
> +		if (++nr_filled == topology_max_packages())
> +			break;
> +	}
> +
> +	if (WARN_ON(nr_filled != topology_max_packages())) {
> +		kfree(tdx_package_masters);
> +		return -EIO;
> +	}

Best,
Wei
