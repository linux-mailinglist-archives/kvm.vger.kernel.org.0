Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5802347473E
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 17:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbhLNQMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 11:12:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:1123 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231215AbhLNQMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 11:12:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639498372; x=1671034372;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x1BztRLHTFRFEg8Z0YOuA4q7ZTHvBkBUxlUcWZdiZHE=;
  b=gnnqlx8NQ2F0L8mB1yQalZc8Gip42ClvA85PBWefbT4hqANAs5p5CHRp
   AOgMNNXNzPO3vNu4ODgIvqdjhMycH3P5WFcAroCg+Drpzn+QNOaAC4aJw
   bKrmfAy6+VHcRogFsfczG8lerzDJs8g0/KQvBkKL9utsaYyb+6awMmN/Y
   sS/266ZhbNEE5UX8O2Z5+3sFmXC0hAdp1AmfQSiny0mjJei+TmfDUmmRI
   lR1F0klG1dEq8fmOPuXYDEhIIgZ7ix+zahPLddIUqOG66wHmiDTpTZAcj
   M5OGCmtroXtBtpetc+8+pf/eBSbhbKoH3BZQbB2Esj34cRFmASRnLfSuU
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="302388382"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="302388382"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 08:11:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="545217825"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 14 Dec 2021 08:11:50 -0800
Received: from shsmsx602.ccr.corp.intel.com (10.109.6.142) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 08:11:49 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX602.ccr.corp.intel.com (10.109.6.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 00:11:47 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Wed, 15 Dec 2021 00:11:47 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>
CC:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Sean Christoperson" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Topic: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Index: AQHX8JWhvlRQU5T/lU6dpNiL1wIQjqwyEDNg//+KXYCAAIkxEA==
Date:   Tue, 14 Dec 2021 16:11:47 +0000
Message-ID: <b3ac7ba45c984cf39783e33e0c25274d@intel.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
In-Reply-To: <87zgp3ry8i.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, December 14, 2021 11:40 PM, Thomas Gleixner wrote:
> On Tue, Dec 14 2021 at 15:09, Wei W. Wang wrote:
> > On Tuesday, December 14, 2021 10:50 AM, Thomas Gleixner wrote:
> >> + * Return: 0 on success, error code otherwise  */ int
> >> +__fpu_update_guest_features(struct fpu_guest *guest_fpu, u64 xcr0,
> >> +u64
> >> +xfd) {
> >
> > I think there would be one issue for the "host write on restore" case.
> > The current QEMU based host restore uses the following sequence:
> > 1) restore xsave
> > 2) restore xcr0
> > 3) restore XFD MSR
>=20
> This needs to be fixed. Ordering clearly needs to be:
>=20
>   XFD, XCR0, XSTATE

Sorry, just to clarify that the ordering in QEMU isn't made by us for this =
specific XFD enabling.
It has been there for long time for the general restoring of all the XCRs a=
nd MSRs.
(if you are interested..FYI: https://github.com/qemu/qemu/blob/master/targe=
t/i386/kvm/kvm.c#L4168).
- kvm_put_xsave()
- kvm_put_xcrs()
- kvm_put_msrs()

We need to check with the QEMU migration maintainer (Dave and Juan CC-ed)
if changing that ordering would be OK.
(In general, I think there are no hard rules documented for this ordering)

Thanks,
Wei

