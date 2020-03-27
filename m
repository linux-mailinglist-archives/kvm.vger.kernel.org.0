Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97511195329
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 09:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgC0IpL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 27 Mar 2020 04:45:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:35630 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgC0IpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Mar 2020 04:45:11 -0400
IronPort-SDR: 908AAl8iqJUmE/KpMj1QzzqaYSRree4M9cAxNWy8r29R9Ic1gjWrhUiG77zoo6b1bq3ByYY0Js
 PUA9SD2Wcqsg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 01:45:10 -0700
IronPort-SDR: g5aJBSxuLxxptb3awRZSCaG4kfVmIEqrOTr8ut36C/e8Syz7Yn5C001z+pxFWnQ89wFudiFWXN
 jq/U0jHRofHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,311,1580803200"; 
   d="scan'208";a="239045384"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga007.fm.intel.com with ESMTP; 27 Mar 2020 01:45:09 -0700
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 27 Mar 2020 01:45:09 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX151.amr.corp.intel.com (10.18.125.4) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 27 Mar 2020 01:45:03 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.155]) with mapi id 14.03.0439.000;
 Fri, 27 Mar 2020 16:44:59 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: RE: [PATCH v2 2/2] drm/i915/gvt: mdev aggregation type
Thread-Topic: [PATCH v2 2/2] drm/i915/gvt: mdev aggregation type
Thread-Index: AQHWAzE8uZfRrqms+UGN02f5QAMK/6hah5QggAEKxoCAAI40QA==
Date:   Fri, 27 Mar 2020 08:44:59 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D7ED38D@SHSMSX104.ccr.corp.intel.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
 <20200326054136.2543-3-zhenyuw@linux.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7ED10B@SHSMSX104.ccr.corp.intel.com>
 <20200327081215.GJ8880@zhen-hp.sh.intel.com>
In-Reply-To: <20200327081215.GJ8880@zhen-hp.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Zhenyu Wang <zhenyuw@linux.intel.com>
> Sent: Friday, March 27, 2020 4:12 PM
> 
[...]
> > > +int intel_vgpu_adjust_resource_count(struct intel_vgpu *vgpu)
> > > +{
> > > +	if ((vgpu_aperture_sz(vgpu) != vgpu->param.low_gm_sz *
> > > +	     vgpu->param.aggregation) ||
> > > +	    (vgpu_hidden_sz(vgpu) != vgpu->param.high_gm_sz *
> > > +	     vgpu->param.aggregation)) {
> > > +		/* handle aggregation change */
> > > +		intel_vgpu_free_resource_count(vgpu);
> > > +		intel_vgpu_alloc_resource_count(vgpu);
> >
> > this logic sounds like different from the commit msg. Earlier you
> > said the resource is not allocated until mdev open, while the
> > aggregated_interfaces is only allowed to be written before
> > mdev open. In such case, why would it required to handle the
> > case where a vgpu already has resource allocated then coming
> > a new request to adjust the number of instances?
> 
> This is to handle resource accounting before mdev open by aggregation
> setting change. When vgpu create from mdev type, default resource
> count according to type is set for vgpu. So this function is just to
> change resource count by aggregation.

then better change the name, e.g. .xxx_adjust_resource_accounting,
otherwise it's easy to be confused.

[...]
> > >  	if (ret)
> > >  		goto out_clean_vgpu_mmio;
> > >
> > > -	populate_pvinfo_page(vgpu);
> > > +	if (!delay_res_alloc) {
> > > +		ret = intel_vgpu_res_alloc(vgpu);
> > > +		if (ret)
> > > +			goto out_clean_vgpu_mmio;
> > > +	}
> >
> > If delayed resource allocation works correctly, why do we still
> > need support non-delayed flavor? Even a type doesn't support
> > aggregation, it doesn't hurt to do allocation until mdev open...
> >
> 
> The difference is user expectation I think, if there's really
> awareness of this. As original way is to allocate at creat time, so
> once created success, resource is guaranteed. But for aggregation type
> which could be changed before open, alloc happens at that time which
> may have different scenario, e.g might fail caused by other instance
> or host. So original idea is to keep old behavior but only change for
> aggregation type.

but how could one expect any difference between instant allocation
and delayed allocation? You already update resource accounting so
the remaining instances are accurate anyway. Then the user only knows
how the vgpu looks like when it is opened...

> 
> If we think this user expectation is not important, delayed alloc
> could help to create vgpu quickly but may have more chance to fail
> later..
> 

why? If delayed allocation has more chance to fail, it means our
resource accounting has problem. Even for type w/o aggregation
capability, we should reserve one instance resource by default anyway

Thanks
Kevin
