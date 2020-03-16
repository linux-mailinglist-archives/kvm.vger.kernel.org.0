Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35BF61863B7
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 04:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbgCPDgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Mar 2020 23:36:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:55731 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729383AbgCPDgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Mar 2020 23:36:01 -0400
IronPort-SDR: xU3ZIztkK6t3VMvN1Q3Qa8HCD3yE+sLILPDshDPSql33ee8EcSgjFvDCKw8m3/x71xgriykF7k
 WoXll6p9vQPA==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2020 20:36:00 -0700
IronPort-SDR: mB+RTW+ZqJr4/6KL+ucJSlcrBFCq1ymFY1yB5YazrH2ecQL2osA16bsNoUVkU+7V7Kb1ha3bRC
 L4+geyBBOTyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,558,1574150400"; 
   d="asc'?scan'208";a="247330073"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.160.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Mar 2020 20:35:57 -0700
Date:   Mon, 16 Mar 2020 11:23:20 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        zhenyuw@linux.intel.com, pbonzini@redhat.com, kevin.tian@intel.com,
        peterx@redhat.com
Subject: Re: [PATCH v4 7/7] drm/i915/gvt: rw more pages a time for shadow
 context
Message-ID: <20200316032320.GA20491@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20200313030548.7705-1-yan.y.zhao@intel.com>
 <20200313031233.8094-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20200313031233.8094-1-yan.y.zhao@intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020.03.12 23:12:33 -0400, Yan Zhao wrote:
> 1. as shadow context is pinned in intel_vgpu_setup_submission() and
> unpinned in intel_vgpu_clean_submission(), its base virtual address of
> is safely obtained from lrc_reg_state. no need to call kmap()/kunmap()
> repeatedly.
>=20
> 2. IOVA(GPA)s of context pages are checked in this patch and if they are
> consecutive, read/write them together in one
> intel_gvt_hypervisor_read_gpa() / intel_gvt_hypervisor_write_gpa().
>=20
> after the two changes in this patch,

Better split the kmap remove and consecutive copy one for bisect.

> average cycles for populate_shadow_context() and update_guest_context()
> are reduced by ~10000-20000 cycles, depending on the average number of
> consecutive pages in each read/write.
>=20
> (1) comparison of cycles of
> populate_shadow_context() + update_guest_context() when executing
> different benchmarks
>  -------------------------------------------------------------
> |       cycles      | glmark2     | lightsmark  | openarena   |
> |-------------------------------------------------------------|
> | before this patch | 65968       | 97852       | 61373       |
> |  after this patch | 56017 (85%) | 73862 (75%) | 47463 (77%) |
>  -------------------------------------------------------------
>=20
> (2) average count of pages read/written a time in
> populate_shadow_context() and update_guest_context()
> for each benchmark
>=20
>  -----------------------------------------------------------
> |     page cnt      | glmark2     | lightsmark  | openarena |
> |-----------------------------------------------------------|
> | before this patch |    1        |      1      |    1      |
> |  after this patch |    5.25     |     19.99   |   20      |
>  ------------------------------------------------------------
>=20
> (3) comparison of benchmarks scores
>  ---------------------------------------------------------------------
> |      score        | glmark2       | lightsmark     | openarena      |
> |---------------------------------------------------------------------|
> | before this patch | 1244          | 222.18         | 114.4          |
> |  after this patch | 1248 (100.3%) | 225.8 (101.6%) | 115.0 (100.9%) |
>  ---------------------------------------------------------------------
>=20
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/scheduler.c | 95 ++++++++++++++++++++--------
>  1 file changed, 67 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/=
gvt/scheduler.c
> index 1c95bf8cbed0..852d924f6abc 100644
> --- a/drivers/gpu/drm/i915/gvt/scheduler.c
> +++ b/drivers/gpu/drm/i915/gvt/scheduler.c
> @@ -128,16 +128,21 @@ static int populate_shadow_context(struct intel_vgp=
u_workload *workload)
>  {
>  	struct intel_vgpu *vgpu =3D workload->vgpu;
>  	struct intel_gvt *gvt =3D vgpu->gvt;
> -	struct drm_i915_gem_object *ctx_obj =3D
> -		workload->req->context->state->obj;
> +	struct intel_context *ctx =3D workload->req->context;
>  	struct execlist_ring_context *shadow_ring_context;
> -	struct page *page;
>  	void *dst;
> +	void *context_base;
>  	unsigned long context_gpa, context_page_num;
> +	unsigned long gpa_base; /* first gpa of consecutive GPAs */
> +	unsigned long gpa_size; /* size of consecutive GPAs */
>  	int i;
> =20
> -	page =3D i915_gem_object_get_page(ctx_obj, LRC_STATE_PN);
> -	shadow_ring_context =3D kmap(page);
> +	GEM_BUG_ON(!intel_context_is_pinned(ctx));
> +
> +	context_base =3D (void *) ctx->lrc_reg_state -
> +				(LRC_STATE_PN << I915_GTT_PAGE_SHIFT);
> +
> +	shadow_ring_context =3D (void *) ctx->lrc_reg_state;
> =20
>  	sr_oa_regs(workload, (u32 *)shadow_ring_context, true);
>  #define COPY_REG(name) \
> @@ -169,7 +174,6 @@ static int populate_shadow_context(struct intel_vgpu_=
workload *workload)
>  			I915_GTT_PAGE_SIZE - sizeof(*shadow_ring_context));
> =20
>  	sr_oa_regs(workload, (u32 *)shadow_ring_context, false);
> -	kunmap(page);
> =20
>  	if (IS_RESTORE_INHIBIT(shadow_ring_context->ctx_ctrl.val))
>  		return 0;
> @@ -184,8 +188,12 @@ static int populate_shadow_context(struct intel_vgpu=
_workload *workload)
>  	if (IS_BROADWELL(gvt->gt->i915) && workload->engine->id =3D=3D RCS0)
>  		context_page_num =3D 19;
> =20
> -	i =3D 2;
> -	while (i < context_page_num) {
> +
> +	/* find consecutive GPAs from gma until the first inconsecutive GPA.
> +	 * read from the continuous GPAs into dst virtual address
> +	 */
> +	gpa_size =3D 0;
> +	for (i =3D 2; i < context_page_num; i++) {
>  		context_gpa =3D intel_vgpu_gma_to_gpa(vgpu->gtt.ggtt_mm,
>  				(u32)((workload->ctx_desc.lrca + i) <<
>  				I915_GTT_PAGE_SHIFT));
> @@ -194,12 +202,24 @@ static int populate_shadow_context(struct intel_vgp=
u_workload *workload)
>  			return -EFAULT;
>  		}
> =20
> -		page =3D i915_gem_object_get_page(ctx_obj, i);
> -		dst =3D kmap(page);
> -		intel_gvt_hypervisor_read_gpa(vgpu, context_gpa, dst,
> -				I915_GTT_PAGE_SIZE);
> -		kunmap(page);
> -		i++;
> +		if (gpa_size =3D=3D 0) {
> +			gpa_base =3D context_gpa;
> +			dst =3D context_base + (i << I915_GTT_PAGE_SHIFT);
> +		} else if (context_gpa !=3D gpa_base + gpa_size)
> +			goto read;
> +
> +		gpa_size +=3D I915_GTT_PAGE_SIZE;
> +
> +		if (i =3D=3D context_page_num - 1)
> +			goto read;
> +
> +		continue;
> +
> +read:
> +		intel_gvt_hypervisor_read_gpa(vgpu, gpa_base, dst, gpa_size);
> +		gpa_base =3D context_gpa;
> +		gpa_size =3D I915_GTT_PAGE_SIZE;
> +		dst =3D context_base + (i << I915_GTT_PAGE_SHIFT);
>  	}
>  	return 0;
>  }
> @@ -784,19 +804,23 @@ static void update_guest_context(struct intel_vgpu_=
workload *workload)
>  {
>  	struct i915_request *rq =3D workload->req;
>  	struct intel_vgpu *vgpu =3D workload->vgpu;
> -	struct drm_i915_gem_object *ctx_obj =3D rq->context->state->obj;
> +	struct intel_context *ctx =3D workload->req->context;
>  	struct execlist_ring_context *shadow_ring_context;
> -	struct page *page;
> -	void *src;
>  	unsigned long context_gpa, context_page_num;
> +	unsigned long gpa_base; /* first gpa of consecutive GPAs */
> +	unsigned long gpa_size; /* size of consecutive GPAs*/
>  	int i;
>  	u32 ring_base;
>  	u32 head, tail;
>  	u16 wrap_count;
> +	void *src;
> +	void *context_base;
> =20
>  	gvt_dbg_sched("ring id %d workload lrca %x\n", rq->engine->id,
>  		      workload->ctx_desc.lrca);
> =20
> +	GEM_BUG_ON(!intel_context_is_pinned(ctx));
> +
>  	head =3D workload->rb_head;
>  	tail =3D workload->rb_tail;
>  	wrap_count =3D workload->guest_rb_head >> RB_HEAD_WRAP_CNT_OFF;
> @@ -820,9 +844,14 @@ static void update_guest_context(struct intel_vgpu_w=
orkload *workload)
>  	if (IS_BROADWELL(rq->i915) && rq->engine->id =3D=3D RCS0)
>  		context_page_num =3D 19;
> =20
> -	i =3D 2;
> +	context_base =3D (void *) ctx->lrc_reg_state -
> +			(LRC_STATE_PN << I915_GTT_PAGE_SHIFT);
> =20
> -	while (i < context_page_num) {
> +	/* find consecutive GPAs from gma until the first inconsecutive GPA.
> +	 * write to the consecutive GPAs from src virtual address
> +	 */
> +	gpa_size =3D 0;
> +	for (i =3D 2; i < context_page_num; i++) {
>  		context_gpa =3D intel_vgpu_gma_to_gpa(vgpu->gtt.ggtt_mm,
>  				(u32)((workload->ctx_desc.lrca + i) <<
>  					I915_GTT_PAGE_SHIFT));
> @@ -831,19 +860,30 @@ static void update_guest_context(struct intel_vgpu_=
workload *workload)
>  			return;
>  		}
> =20
> -		page =3D i915_gem_object_get_page(ctx_obj, i);
> -		src =3D kmap(page);
> -		intel_gvt_hypervisor_write_gpa(vgpu, context_gpa, src,
> -				I915_GTT_PAGE_SIZE);
> -		kunmap(page);
> -		i++;
> +		if (gpa_size =3D=3D 0) {
> +			gpa_base =3D context_gpa;
> +			src =3D context_base + (i << I915_GTT_PAGE_SHIFT);
> +		} else if (context_gpa !=3D gpa_base + gpa_size)
> +			goto write;
> +
> +		gpa_size +=3D I915_GTT_PAGE_SIZE;
> +
> +		if (i =3D=3D context_page_num - 1)
> +			goto write;
> +
> +		continue;
> +
> +write:
> +		intel_gvt_hypervisor_write_gpa(vgpu, gpa_base, src, gpa_size);
> +		gpa_base =3D context_gpa;
> +		gpa_size =3D I915_GTT_PAGE_SIZE;
> +		src =3D context_base + (i << I915_GTT_PAGE_SHIFT);
>  	}
> =20
>  	intel_gvt_hypervisor_write_gpa(vgpu, workload->ring_context_gpa +
>  		RING_CTX_OFF(ring_header.val), &workload->rb_tail, 4);
> =20
> -	page =3D i915_gem_object_get_page(ctx_obj, LRC_STATE_PN);
> -	shadow_ring_context =3D kmap(page);
> +	shadow_ring_context =3D (void *) ctx->lrc_reg_state;
> =20
>  #define COPY_REG(name) \
>  	intel_gvt_hypervisor_write_gpa(vgpu, workload->ring_context_gpa + \
> @@ -861,7 +901,6 @@ static void update_guest_context(struct intel_vgpu_wo=
rkload *workload)
>  			sizeof(*shadow_ring_context),
>  			I915_GTT_PAGE_SIZE - sizeof(*shadow_ring_context));
> =20
> -	kunmap(page);
>  }
> =20
>  void intel_vgpu_clean_workloads(struct intel_vgpu *vgpu,
> --=20
> 2.17.1
>=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXm7xJwAKCRCxBBozTXgY
J0LsAJ97ALlQDqrvk1Vd38V6BqYW6b1nLQCfaHcRjSvPEtCtl6vUIJFX4wVVmiU=
=vFZs
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
