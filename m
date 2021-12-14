Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FCD473CF3
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 07:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhLNGG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 01:06:58 -0500
Received: from mga04.intel.com ([192.55.52.120]:44656 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229766AbhLNGG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 01:06:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639462017; x=1670998017;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KYM4tJorgOFuEGhs8LKAkno69WwgdojnQ33GO7vJocg=;
  b=UEOzPkhgKXi8bd5XoI1SJdzq68sRdMXHnjO4nv/J+7J7Kt7G2506mOtZ
   lAR4APlfQWoTaMKWY64TG/7fWHKqUkeN6oi2GrDq/bZQW5s/ayZCDZ0Hq
   uHu1gGZOFk0Ll5ozQAJiTMoV090YTFoszjk5Y0FJqZs4oheQK7CQrd5b0
   EuA6f92NbSrigcaV0LklDJyUlZQoLFh0Q+RQyo8D3yjIlF0DVXG5Dwd3C
   5v/mjW6FLloH/8YLWO225sYueqPDz+pTBfKNAMUn6uYa2iwKtNtGxQm1n
   vntUo/L6iwnefaliwrwpoehPFm1KJl9bJdOiWUeDtjqqKyEfb9yieXEtd
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="237643210"
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="237643210"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 22:06:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="681926788"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 13 Dec 2021 22:06:56 -0800
Received: from shsmsx606.ccr.corp.intel.com (10.109.6.216) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 22:06:55 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX606.ccr.corp.intel.com (10.109.6.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 14:06:54 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Tue, 14 Dec 2021 14:06:53 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Thread-Topic: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Thread-Index: AQHX63yobhR7xaimuUSU4jknnLqQN6wraUsAgABf8YCABEZs0P//mZ4AgAHaVHA=
Date:   Tue, 14 Dec 2021 06:06:53 +0000
Message-ID: <3ec6019a551249d6994063e56a448625@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
 <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
 <86d3c3a5d61649079800a2038370365b@intel.com>
 <bdda79b5-79e4-22fd-9af8-ec6e87a412ab@redhat.com>
In-Reply-To: <bdda79b5-79e4-22fd-9af8-ec6e87a412ab@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uZGF5LCBEZWNlbWJlciAxMywgMjAyMSA1OjI0IFBNLCBQYW9sbyBCb256aW5pIHdyb3Rl
Og0KPiBUaGVyZSBpcyBubyBuZWVkIGZvciBzdHJ1Y3Qga3ZtX3hzYXZlMiwgYmVjYXVzZSB0aGVy
ZSBpcyBubyBuZWVkIGZvciBhICJzaXplIg0KPiBhcmd1bWVudC4NCj4gDQo+IC0gS1ZNX0dFVF9Y
U0FWRTIgKmlzKiBuZWVkZWQsIGFuZCBpdCBjYW4gZXhwZWN0IGEgYnVmZmVyIGFzIGJpZyBhcyB0
aGUgcmV0dXJuDQo+IHZhbHVlIG9mIEtWTV9DSEVDS19FWFRFTlNJT04oS1ZNX0NBUF9YU0FWRTIp
DQoNCldoeSB3b3VsZCBLVk1fR0VUX1hTQVZFMiBzdGlsbCBiZSBuZWVkZWQgaW4gdGhpcyBjYXNl
Pw0KDQpJJ20gdGhpbmtpbmcgaXQgd291bGQgYWxzbyBiZSBwb3NzaWJsZSB0byByZXVzZSBLVk1f
R0VUX1hTQVZFOg0KDQotIElmIHVzZXJzcGFjZSBjYWxscyB0byBLVk1fQ0hFQ0tfRVhURU5TSU9O
KEtWTV9DQVBfWFNBVkUyKSwNCiB0aGVuIEtWTSBrbm93cyB0aGF0IHRoZSB1c2Vyc3BhY2UgaXMg
YSBuZXcgdmVyc2lvbiBhbmQgaXQgd29ya3Mgd2l0aCBsYXJnZXIgeHNhdmUgYnVmZmVyIHVzaW5n
IHRoZSAic2l6ZSIgdGhhdCBpdCByZXR1cm5zIHZpYSBLVk1fQ0FQX1hTQVZFMi4NCiBTbyB3ZSBj
YW4gYWRkIGEgZmxhZyAia3ZtLT54c2F2ZTJfZW5hYmxlZCIsIHdoaWNoIGdldHMgc2V0IHVwb24g
dXNlcnNwYWNlIGNoZWNrcyBLVk1fQ0FQX1hTQVZFMi4NCg0KLSBPbiBLVk1fR0VUX1hTQVZFLCBp
ZiAia3ZtLT54c2F2ZTJfZW5hYmxlZCIgaXMgc2V0LA0KIHRoZW4gS1ZNIGFsbG9jYXRlcyBidWZm
ZXIgdG8gbG9hZCB4c3RhdGVzIGFuZCBjb3BpZXMgdGhlIGxvYWRlZCB4c3RhdGVzIGRhdGEgdG8g
dGhlIHVzZXJzcGFjZSBidWZmZXINCiB1c2luZyB0aGUgInNpemUiIHRoYXQgd2FzIHJldHVybmVk
IHRvIHVzZXJzcGFjZSBvbiBLVk1fQ0FQX1hTQVZFMi4NCiBJZiAia3ZtLT54c2F2ZTJfZW5hYmxl
ZCIgaXNuJ3Qgc2V0LCB1c2luZyB0aGUgbGVnYWN5ICI0S0IiIHNpemUuDQoNClRoYW5rcywNCldl
aQ0K
