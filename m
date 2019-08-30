Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1618A2B5F
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 02:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfH3AWM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 29 Aug 2019 20:22:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:22601 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbfH3AWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 20:22:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 17:22:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="332694186"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga004.jf.intel.com with ESMTP; 29 Aug 2019 17:22:11 -0700
Received: from fmsmsx126.amr.corp.intel.com (10.18.125.43) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 29 Aug 2019 17:22:11 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 FMSMSX126.amr.corp.intel.com (10.18.125.43) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 29 Aug 2019 17:22:10 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.112]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.139]) with mapi id 14.03.0439.000;
 Fri, 30 Aug 2019 08:22:09 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Andi Kleen <ak@linux.intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC v1 3/9] KVM: x86: Implement MSR_IA32_PEBS_ENABLE
 read/write emulation
Thread-Topic: [RFC v1 3/9] KVM: x86: Implement MSR_IA32_PEBS_ENABLE
 read/write emulation
Thread-Index: AQHVXiwscwhutE1kJU23+jUvuPvAQqcSHKUAgAC3tRA=
Date:   Fri, 30 Aug 2019 00:22:08 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E1737F78B3@SHSMSX104.ccr.corp.intel.com>
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
 <1567056849-14608-4-git-send-email-luwei.kang@intel.com>
 <20190829212016.GV5447@tassilo.jf.intel.com>
In-Reply-To: <20190829212016.GV5447@tassilo.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +	case MSR_IA32_PEBS_ENABLE:
> > +		if (pmu->pebs_enable == data)
> > +			return 0;
> > +		if (!(data & pmu->pebs_enable_mask) &&
> > +		     (data & MSR_IA32_PEBS_OUTPUT_MASK) ==
> > +						MSR_IA32_PEBS_OUTPUT_PT)
> {
> > +			pebs_enable_changed(pmu, data);
> > +			return 0;
> > +		}
> 
> Need #GP for bad values

Yes, this function will return 1 if neither of above two conditions check are not true. And will inject a #GP to guest.

Thanks,
Luwei Kang

