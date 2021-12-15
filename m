Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1E64750E8
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 03:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbhLOCSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 21:18:08 -0500
Received: from mga04.intel.com ([192.55.52.120]:16233 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234936AbhLOCRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 21:17:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639534674; x=1671070674;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JCWToRuiAoNCBtbHqxe2ss4XlWHW3dfpLPhiGihc7VE=;
  b=YegU62T8h/WN/NG9yBoGH1RH/5EZ61p3Fee9va9j0RSpH6ArGZXuv/o7
   yYu7jCLxkGfM65a8RH1RfsB7Mgoy0fPZoJI5qUYOEfuPe//D4jSaTyLoK
   TZ3M85qu2669Lxlit2526l9VFLhzGddiH+SA3BWV9ASp0MGkgeLHqUik5
   /suUmxKwSIB72Hp+X6gk2xLTZOu4mc224niR/1YvrZ3SpJPHhHAQWMSVw
   x+i87vbiItSa+WXfVt6hj/6kOkCms2hzrLXwCcEIIyHh+jx9IntID0kf7
   qndEeP1dlRGax9KpxQ7F/HM52nL+SH6dz93mzaaPIN8hV3gAdx+Lf8vhJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="237865954"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="237865954"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 18:17:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="682305801"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 14 Dec 2021 18:17:48 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 18:17:47 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX601.ccr.corp.intel.com (10.109.6.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 10:17:45 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Wed, 15 Dec 2021 10:17:45 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "quintela@redhat.com" <quintela@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Sean Christoperson" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Topic: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Index: AQHX8JWhvlRQU5T/lU6dpNiL1wIQjqwxkgQAgAAIjICAAAi+gIAAH5YAgACZ4rD//45AAIAAmPBRgABJx0A=
Date:   Wed, 15 Dec 2021 02:17:45 +0000
Message-ID: <afeba57f71f742b88aac3f01800086f9@intel.com>
References: <20211214022825.563892248@linutronix.de>
        <20211214024948.048572883@linutronix.de>
        <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
        <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
        <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica>
In-Reply-To: <878rwm7tu8.fsf@secure.mitica>
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

Hi Thomas,

On Wednesday, December 15, 2021 5:36 AM, Juan Quintela wrote:
> To: Thomas Gleixner <tglx@linutronix.de>
> Cc: Wang, Wei W <wei.w.wang@intel.com>; LKML
> <linux-kernel@vger.kernel.org>; Dr. David Alan Gilbert <dgilbert@redhat.c=
om>;
> Jing Liu <jing2.liu@linux.intel.com>; Zhong, Yang <yang.zhong@intel.com>;
> Paolo Bonzini <pbonzini@redhat.com>; x86@kernel.org; kvm@vger.kernel.org;
> Sean Christoperson <seanjc@google.com>; Nakajima, Jun
> <jun.nakajima@intel.com>; Tian, Kevin <kevin.tian@intel.com>
> Subject: Re: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
>=20
> Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> Hi Thomas
>=20
> > On Tue, Dec 14 2021 at 20:07, Juan Quintela wrote:
> >> Thomas Gleixner <tglx@linutronix.de> wrote:
> >>> On Tue, Dec 14 2021 at 16:11, Wei W. Wang wrote:
> >>>> We need to check with the QEMU migration maintainer (Dave and Juan
> >>>> CC-ed) if changing that ordering would be OK.
> >>>> (In general, I think there are no hard rules documented for this
> >>>> ordering)
> >>>
> >>> There haven't been ordering requirements so far, but with dynamic
> >>> feature enablement there are.
> >>>
> >>> I really want to avoid going to the point to deduce it from the
> >>> xstate:xfeatures bitmap, which is just backwards and Qemu has all
> >>> the required information already.
> >>
> >> First of all, I claim ZERO knowledge about low level x86_64.
> >
> > Lucky you.
>=20
> Well, that is true until I have to debug some bug, at that time I miss th=
e
> knowledge O:-)
>=20
> >> Once told that, this don't matter for qemu migration, code is at
> >
> > Once, that was at the time where rubber boots were still made of wood,
> > right? :)
>=20
> I forgot to add: "famous last words".
>=20
> >> target/i386/kvm/kvm.c:kvm_arch_put_registers()
> >>
> >>
> >>     ret =3D kvm_put_xsave(x86_cpu);
> >>     if (ret < 0) {
> >>         return ret;
> >>     }
> >>     ret =3D kvm_put_xcrs(x86_cpu);
> >>     if (ret < 0) {
> >>         return ret;
> >>     }
> >>     /* must be before kvm_put_msrs */
> >>     ret =3D kvm_inject_mce_oldstyle(x86_cpu);
> >
> > So this has already ordering requirements.
> >
> >>     if (ret < 0) {
> >>         return ret;
> >>     }
> >>     ret =3D kvm_put_msrs(x86_cpu, level);
> >>     if (ret < 0) {
> >>         return ret;
> >>     }
> >>
> >> If it needs to be done in any other order, it is completely
> >> independent of whatever is inside the migration stream.
> >
> > From the migration data perspective that's correct, but I have the
> > nagging feeling that this in not that simple.
>=20
> Oh, I was not meaning that it was simple at all.

It seems to be a consensus that the ordering constraint wouldn't be that ea=
sy.
Would you think that our current solution (the 3 parts shared earlier to do=
 fpstate expansion at KVM_SET_XSAVE) is acceptable as the 1st version?

Thanks,
Wei
