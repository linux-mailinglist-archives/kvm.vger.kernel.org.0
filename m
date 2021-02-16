Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523CC31D225
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 22:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhBPVeI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 16 Feb 2021 16:34:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:63905 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhBPVeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 16:34:02 -0500
IronPort-SDR: k1yivGRFhDmctvECuxvDPYnAwtoxkyAoL8zaITHDzxmeV8GQKR+8u2/Q/4jh6BknoBsSfFIJfu
 Nty7oDy5Ob3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="202224705"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="202224705"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 13:33:22 -0800
IronPort-SDR: Dmpo7mI9g3GoCi0BMEFOqdSiv3YQu0x+b0txT6f6WxzvZdOGKZzqoIzwcyZDYNY/fj9hG4g40x
 SwcdC+ztUKMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="399679300"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga008.jf.intel.com with ESMTP; 16 Feb 2021 13:33:21 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 13:33:21 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 13:33:20 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Tue, 16 Feb 2021 13:33:20 -0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [RFC PATCH v5 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Thread-Topic: [RFC PATCH v5 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Thread-Index: AQHXAgqDJqyGy35FR0GtJTdCjOjmr6pbp+0AgAANFgD//505gA==
Date:   Tue, 16 Feb 2021 21:33:20 +0000
Message-ID: <9edb1a1941be4449bd1c0abcfa9f17e9@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <4813545fa5765d05c2ed18f2e2c44275bd087c0a.1613221549.git.kai.huang@intel.com>
 <eafcdcae-ae66-e717-2f8b-2bdfb8e7d0d5@intel.com>
 <YCwcLIyUypf4huX1@google.com>
In-Reply-To: <YCwcLIyUypf4huX1@google.com>
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

> 
> On Tue, Feb 16, 2021, Dave Hansen wrote:
> > > Having separate device nodes for SGX driver and KVM virtual EPC also
> > > allows separate permission control for running host SGX enclaves and
> > > KVM SGX guests.
> >
> > Specifically, 'sgx_vepc' is a less restrictive interface.  It would
> > make a lot of sense to more tightly control access compared to 'sgx_enclave'.
> 
> The opposite is just as likely, i.e. exposing SGX to a guest but not allowing
> enclaves in the host.  Not from a "sgx_enclave is easier to abuse" perspective,
> but from a "enclaves should never be runnable in the host in our environment".

Agreed. CSP may want to provide SGX service in VMs, but not to run SGX app in host. 
