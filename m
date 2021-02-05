Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE91331024F
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbhBEBjv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 4 Feb 2021 20:39:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:11975 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232564AbhBEBjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 20:39:51 -0500
IronPort-SDR: Z+N5xRZNxsjAJdjlOKALHa5KW7UCghFrKuR1HNI0kOsr6ijYiE5lSRnRghebkfRoWG1HaZ5Q9Y
 eXI6AhoD3Gaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="200359585"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="200359585"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 17:39:09 -0800
IronPort-SDR: FjHVrpzrp7zccIxnohK9Kl9KEtvylbhCchj9YnstXYLeiUrocnZS0JQ0oXqf88Ooi2S79q6Yjb
 qtijJ9b3ZzRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="397286018"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 04 Feb 2021 17:39:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Feb 2021 17:39:09 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Feb 2021 17:39:08 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Thu, 4 Feb 2021 17:39:08 -0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [RFC PATCH v3 14/27] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Thread-Topic: [RFC PATCH v3 14/27] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Thread-Index: AQHW88S+HOr/M4R7L0Whqz/gwg1xJKpIywcAgACAXoD//4xggA==
Date:   Fri, 5 Feb 2021 01:39:08 +0000
Message-ID: <c4a8e70f49b54889b0bd54cb810e5939@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <e807033e3d56ede1177d7a1af34477678bfbfff9.1611634586.git.kai.huang@intel.com>
 <d20976b25943c34ecfc970ebcb6f282c69a3dd43.camel@intel.com>
 <YBySKakwHCgOSQow@google.com>
In-Reply-To: <YBySKakwHCgOSQow@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Thu, Feb 04, 2021, Kai Huang wrote:
> > Hi Sean,
> >
> > Do you think is it reasonable to move this patch to KVM?
> > sgx_virt_ecreate() can be merged to handle ECREATE patch, and
> > sgx_virt_einit() can be merged to handle EINIT patch. W/o the context
> > of that two patches, it doesn't makes too much sense to have them
> standalone under x86 here I think. And nobody except KVM will use them.
> 
> Short answer, no.  To do that, nearly all of arch/x86/kernel/cpu/sgx/encls.h
> would need to be exposed via asm/sgx.h.  The macro insanity and fault/error
> code shenanigans really should be kept as private crud in SGX.  That's the
> primary motivation for putting these in sgx/virt.c instead of KVM, my changelog
> just did a really poor job of explaining that.

OK.
