Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C154519539E
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 10:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgC0JL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 05:11:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:9210 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbgC0JL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Mar 2020 05:11:29 -0400
IronPort-SDR: jofDQX44cSJoehTXLKa20YixjbTQdF2IU2dGoO4z2ihGUQwpRG4fq1e8p5XfwymXC8+iddjkEz
 CQ2t02nhK2bg==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 02:11:28 -0700
IronPort-SDR: C/EOFXaQrjp2OBlaAuqxBO2bERxtEG/jc/NJ+MfjyL4DO8Ry82AFXpjAHT7TZkvhXA31dNzsZf
 cpdQz7yHTeNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,311,1580803200"; 
   d="asc'?scan'208";a="358431438"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.160.147])
  by fmsmga001.fm.intel.com with ESMTP; 27 Mar 2020 02:11:27 -0700
Date:   Fri, 27 Mar 2020 16:58:25 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: Re: [PATCH v2 2/2] drm/i915/gvt: mdev aggregation type
Message-ID: <20200327085825.GK8880@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
 <20200326054136.2543-3-zhenyuw@linux.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7ED10B@SHSMSX104.ccr.corp.intel.com>
 <20200327081215.GJ8880@zhen-hp.sh.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7ED38D@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="hWmTLTlw74j3oMzq"
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D7ED38D@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--hWmTLTlw74j3oMzq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020.03.27 08:44:59 +0000, Tian, Kevin wrote:
> > From: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Sent: Friday, March 27, 2020 4:12 PM
> >=20
> [...]
> > > > +int intel_vgpu_adjust_resource_count(struct intel_vgpu *vgpu)
> > > > +{
> > > > +	if ((vgpu_aperture_sz(vgpu) !=3D vgpu->param.low_gm_sz *
> > > > +	     vgpu->param.aggregation) ||
> > > > +	    (vgpu_hidden_sz(vgpu) !=3D vgpu->param.high_gm_sz *
> > > > +	     vgpu->param.aggregation)) {
> > > > +		/* handle aggregation change */
> > > > +		intel_vgpu_free_resource_count(vgpu);
> > > > +		intel_vgpu_alloc_resource_count(vgpu);
> > >
> > > this logic sounds like different from the commit msg. Earlier you
> > > said the resource is not allocated until mdev open, while the
> > > aggregated_interfaces is only allowed to be written before
> > > mdev open. In such case, why would it required to handle the
> > > case where a vgpu already has resource allocated then coming
> > > a new request to adjust the number of instances?
> >=20
> > This is to handle resource accounting before mdev open by aggregation
> > setting change. When vgpu create from mdev type, default resource
> > count according to type is set for vgpu. So this function is just to
> > change resource count by aggregation.
>=20
> then better change the name, e.g. .xxx_adjust_resource_accounting,
> otherwise it's easy to be confused.
>

ok

> [...]
> > > >  	if (ret)
> > > >  		goto out_clean_vgpu_mmio;
> > > >
> > > > -	populate_pvinfo_page(vgpu);
> > > > +	if (!delay_res_alloc) {
> > > > +		ret =3D intel_vgpu_res_alloc(vgpu);
> > > > +		if (ret)
> > > > +			goto out_clean_vgpu_mmio;
> > > > +	}
> > >
> > > If delayed resource allocation works correctly, why do we still
> > > need support non-delayed flavor? Even a type doesn't support
> > > aggregation, it doesn't hurt to do allocation until mdev open...
> > >
> >=20
> > The difference is user expectation I think, if there's really
> > awareness of this. As original way is to allocate at creat time, so
> > once created success, resource is guaranteed. But for aggregation type
> > which could be changed before open, alloc happens at that time which
> > may have different scenario, e.g might fail caused by other instance
> > or host. So original idea is to keep old behavior but only change for
> > aggregation type.
>=20
> but how could one expect any difference between instant allocation
> and delayed allocation? You already update resource accounting so
> the remaining instances are accurate anyway. Then the user only knows
> how the vgpu looks like when it is opened...
>=20
> >=20
> > If we think this user expectation is not important, delayed alloc
> > could help to create vgpu quickly but may have more chance to fail
> > later..
> >=20
>=20
> why? If delayed allocation has more chance to fail, it means our
> resource accounting has problem. Even for type w/o aggregation
> capability, we should reserve one instance resource by default anyway
>=20

If under really heavy load of host and many other vgpu running, we
might not have left continual gfx mem space..This is not new problem,
just that now we handle it at vgpu create time to reserve the
resource. Once host side could promise some limit, then our usage
will be guaranteed.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--hWmTLTlw74j3oMzq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXn3AMQAKCRCxBBozTXgY
J4KuAJ4hN+LXuQnOB0N9RVitLx2kyP4PNQCdHDV6OLJ2/556lndHOjsPUqsOoJI=
=ytmu
-----END PGP SIGNATURE-----

--hWmTLTlw74j3oMzq--
