Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBE0337D1C
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 19:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhCKS70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 13:59:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:57840 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCKS7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 13:59:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615489150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yjwoEp08KuFW/WZWpnttqf7bhHxPhXa/rNuXqsSS6BU=;
        b=A92RigJEpRKeT/CXGVq/eQfkOixlOk12+hPSHu4f2emWGx1R264aD1eZuLPcPPuWu3XcfW
        TO43QIfsJMECh8TmL6spuhxOug3k578v296drheY+6mSg1EhQHrBpIjiLk6cuzvgGNNF2m
        F14tpwUkpBCu5ziXump6bni8kzHGnf4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6B588ABD7;
        Thu, 11 Mar 2021 18:59:10 +0000 (UTC)
Date:   Thu, 11 Mar 2021 19:59:03 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     tj@kernel.org, rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Message-ID: <YEpod5X29YqMhW/g@blackbook>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <20210304231946.2766648-2-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="P59/QYeOOUiz8W8D"
Content-Disposition: inline
In-Reply-To: <20210304231946.2766648-2-vipinsh@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--P59/QYeOOUiz8W8D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vipin.

On Thu, Mar 04, 2021 at 03:19:45PM -0800, Vipin Sharma <vipinsh@google.com>=
 wrote:
>  arch/x86/kvm/svm/sev.c        |  65 +++++-
>  arch/x86/kvm/svm/svm.h        |   1 +
>  include/linux/cgroup_subsys.h |   4 +
>  include/linux/misc_cgroup.h   | 130 +++++++++++
>  init/Kconfig                  |  14 ++
>  kernel/cgroup/Makefile        |   1 +
>  kernel/cgroup/misc.c          | 402 ++++++++++++++++++++++++++++++++++
Given different two-fold nature (SEV caller vs misc controller) of some
remarks below, I think it makes sense to split this into two patches:
a) generic controller implementation,
b) hooking the controller into SEV ASIDs management.

> +#ifndef CONFIG_KVM_AMD_SEV
> +/*
> + * When this config is not defined, SEV feature is not supported and API=
s in
> + * this file are not used but this file still gets compiled into the KVM=
 AMD
> + * module.
> + *
> + * We will not have MISC_CG_RES_SEV and MISC_CG_RES_SEV_ES entries in th=
e enum
> + * misc_res_type {} defined in linux/misc_cgroup.h.
BTW, was there any progress on conditioning sev.c build on
CONFIG_KVM_AMD_SEV? (So that the defines workaround isn't needeed.)

>  static int sev_asid_new(struct kvm_sev_info *sev)
>  {
> -	int pos, min_asid, max_asid;
> +	int pos, min_asid, max_asid, ret;
>  	bool retry =3D true;
> +	enum misc_res_type type;
> +
> +	type =3D sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
> +	sev->misc_cg =3D get_current_misc_cg();
> +	ret =3D misc_cg_try_charge(type, sev->misc_cg, 1);
It may be safer to WARN_ON(sev->misc_cg) at this point (see below).


> [...]
> +e_uncharge:
> +	misc_cg_uncharge(type, sev->misc_cg, 1);
> +	put_misc_cg(sev->misc_cg);
> +	return ret;
vvv

> @@ -140,6 +171,10 @@ static void sev_asid_free(int asid)
>  	}
> =20
>  	mutex_unlock(&sev_bitmap_lock);
> +
> +	type =3D sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
> +	misc_cg_uncharge(type, sev->misc_cg, 1);
> +	put_misc_cg(sev->misc_cg);
It may be safer to set sev->misc_cg to NULL here.

(IIUC, with current asid_{new,free} calls it shouldn't matter but why to
rely on it in the future.)

> +++ b/kernel/cgroup/misc.c
> [...]
> +static void misc_cg_reduce_charge(enum misc_res_type type, struct misc_c=
g *cg,
> +				  unsigned long amount)
misc_cg_cancel_charge seems to be a name more consistent with what we
already have in pids and memory controller.


> +static ssize_t misc_cg_max_write(struct kernfs_open_file *of, char *buf,
> +				 size_t nbytes, loff_t off)
> +{
> [...]
> +
> +	if (!strcmp(MAX_STR, buf)) {
> +		max =3D ULONG_MAX;
MAX_NUM for consistency with other places.

> +	} else {
> +		ret =3D kstrtoul(buf, 0, &max);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	cg =3D css_misc(of_css(of));
> +
> +	if (misc_res_capacity[type])
> +		cg->res[type].max =3D max;
In theory, parallel writers can clash here, so having the limit atomic
type to prevent this would resolve it. See also commit a713af394cf3
("cgroup: pids: use atomic64_t for pids->limit").

> +static int misc_cg_current_show(struct seq_file *sf, void *v)
> +{
> +	int i;
> +	struct misc_cg *cg =3D css_misc(seq_css(sf));
> +
> +	for (i =3D 0; i < MISC_CG_RES_TYPES; i++) {
> +		if (misc_res_capacity[i])
Since there can be some residual charges after removing capacity (before
draining), maybe the condition along the line

if (misc_res_capacity[i] || atomic_long_read(&cg->res[i].usage))

would be more informative for debugging.

> +static int misc_cg_capacity_show(struct seq_file *sf, void *v)
> +{
> +	int i;
> +	unsigned long cap;
> +
> +	for (i =3D 0; i < MISC_CG_RES_TYPES; i++) {
> +		cap =3D READ_ONCE(misc_res_capacity[i]);
Why is READ_ONCE only here and not in other places that (actually) check
against the set capacity value? Also, there should be a paired
WRITE_ONCCE in misc_cg_set_capacity().


Thanks,
Michal

--P59/QYeOOUiz8W8D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmBKaHcACgkQia1+riC5
qSiidhAAoCX45GiD4qZe4u2WKoNPdtGoFzWSAJItAODcB/g3yxvxspelkpE9ZQ3t
Bi9w3IS0akVnhAPOkGqYbOhfogbnD2yBaHs4GuhDCnarlk+aUuqbhqhCjqhBn6KQ
vn4mVevmZAnsP3t3VcahmTG3J37iLplbx6ytEwpswlx6XmxWr2Cymlogwa33f0DE
OYF/xezDi1NzS8VaOdSsn9ueY989hYcg3eav+pw62EY9kC+oa4taIbvywjaN+aNr
HRjN6CcqTZ33VL0GfZeo3ig58oHz6D7uXlBrzYT2/ZoE//C5U6wPZ31EOY9noCqn
MGCeAxVi9Xv1/aA0GS6dw2a1hivDwRiXgLGz5Q3Sg9zVtCLbwZjTn+x5IrWtjNOe
CBRMNGf42NWi5Rgo9xYUI2A/VHxWje3bjLIHa90yKXYI4b3DTYp43SrEOu1J5BlM
xxpuvQy/VOlC7XPN6TTEegSxCzftpT3uc79Iq2ymWk5GDRgg4cxRNV9VxqluUFSw
GZLRzLYt34/jQpMzj9GJRLBN/AY/XfFiuFhyKKhEPK99WIjJIIbakZp34ajfso8J
Yrf6YSxVbTAB1lIWPGT0ku8SzgPDkMTtYYpSdWBPSqiTaczuhGiC/14t3VQfj0GH
vX4poFE3fRouhoUnmyfsLnKPJFJlp5tK9Z6m0Nmc7wL/iDsH6ik=
=pXNU
-----END PGP SIGNATURE-----

--P59/QYeOOUiz8W8D--
