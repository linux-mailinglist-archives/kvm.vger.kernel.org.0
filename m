Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55CF019033F
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 02:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgCXBTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 21:19:00 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39877 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgCXBS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 21:18:59 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 48mYL81j2Qz9sSJ; Tue, 24 Mar 2020 12:18:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1585012736;
        bh=Dbf+aWMuGjcmcHFWt22HjqEXqVkkhDG/7kcezizECpU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OysnJmgMR7GAUMKlLMFOtInMaMRYysfJSZrwU1C1sOrD5vfZFxcbU2BK0H35nrn6C
         TofSRoGiYO7XcU6wz8xWqGNS816aUXliKxUfIdyjVtau8ZEPriUQeLH4eAk1COClpc
         FN+dXNe7pzi/6SCpHTApeQPL3g8OQKI3UpP1XhUc=
Date:   Tue, 24 Mar 2020 12:15:16 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: Add a capability for enabling
 secure guests
Message-ID: <20200324011516.GB36889@umbus.fritz.box>
References: <20200324005539.GB5604@blackberry>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <20200324005539.GB5604@blackberry>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2020 at 11:55:39AM +1100, Paul Mackerras wrote:
> At present, on Power systems with Protected Execution Facility
> hardware and an ultravisor, a KVM guest can transition to being a
> secure guest at will.  Userspace (QEMU) has no way of knowing
> whether a host system is capable of running secure guests.  This
> will present a problem in future when the ultravisor is capable of
> migrating secure guests from one host to another, because
> virtualization management software will have no way to ensure that
> secure guests only run in domains where all of the hosts can
> support secure guests.
>=20
> This adds a VM capability which has two functions: (a) userspace
> can query it to find out whether the host can support secure guests,
> and (b) userspace can enable it for a guest, which allows that
> guest to become a secure guest.  If userspace does not enable it,
> KVM will return an error when the ultravisor does the hypercall
> that indicates that the guest is starting to transition to a
> secure guest.  The ultravisor will then abort the transition and
> the guest will terminate.
>=20
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
> v2: Test that KVM uvmem code has initialized successfully as a
> condition of reporting that we support secure guests.
>=20
>  Documentation/virt/kvm/api.rst              | 17 +++++++++++++++++
>  arch/powerpc/include/asm/kvm_book3s_uvmem.h |  6 ++++++
>  arch/powerpc/include/asm/kvm_host.h         |  1 +
>  arch/powerpc/include/asm/kvm_ppc.h          |  1 +
>  arch/powerpc/kvm/book3s_hv.c                | 16 ++++++++++++++++
>  arch/powerpc/kvm/book3s_hv_uvmem.c          | 13 +++++++++++++
>  arch/powerpc/kvm/powerpc.c                  | 14 ++++++++++++++
>  include/uapi/linux/kvm.h                    |  1 +
>  8 files changed, 69 insertions(+)
>=20
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 158d118..a925500 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5779,6 +5779,23 @@ it hard or impossible to use it correctly.  The av=
ailability of
>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 signals that those bugs are fixed.
>  Userspace should not try to use KVM_CAP_MANUAL_DIRTY_LOG_PROTECT.
> =20
> +7.19 KVM_CAP_PPC_SECURE_GUEST
> +------------------------------
> +
> +:Architectures: ppc
> +
> +This capability indicates that KVM is running on a host that has
> +ultravisor firmware and thus can support a secure guest.  On such a
> +system, a guest can ask the ultravisor to make it a secure guest,
> +one whose memory is inaccessible to the host except for pages which
> +are explicitly requested to be shared with the host.  The ultravisor
> +notifies KVM when a guest requests to become a secure guest, and KVM
> +has the opportunity to veto the transition.
> +
> +If present, this capability can be enabled for a VM, meaning that KVM
> +will allow the transition to secure guest mode.  Otherwise KVM will
> +veto the transition.
> +
>  8. Other capabilities.
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> diff --git a/arch/powerpc/include/asm/kvm_book3s_uvmem.h b/arch/powerpc/i=
nclude/asm/kvm_book3s_uvmem.h
> index 5a9834e..9cb7d8b 100644
> --- a/arch/powerpc/include/asm/kvm_book3s_uvmem.h
> +++ b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
> @@ -5,6 +5,7 @@
>  #ifdef CONFIG_PPC_UV
>  int kvmppc_uvmem_init(void);
>  void kvmppc_uvmem_free(void);
> +bool kvmppc_uvmem_available(void);
>  int kvmppc_uvmem_slot_init(struct kvm *kvm, const struct kvm_memory_slot=
 *slot);
>  void kvmppc_uvmem_slot_free(struct kvm *kvm,
>  			    const struct kvm_memory_slot *slot);
> @@ -30,6 +31,11 @@ static inline int kvmppc_uvmem_init(void)
> =20
>  static inline void kvmppc_uvmem_free(void) { }
> =20
> +static inline bool kvmppc_uvmem_available(void)
> +{
> +	return false;
> +}
> +
>  static inline int
>  kvmppc_uvmem_slot_init(struct kvm *kvm, const struct kvm_memory_slot *sl=
ot)
>  {
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/a=
sm/kvm_host.h
> index 6e8b8ff..f99b433 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -303,6 +303,7 @@ struct kvm_arch {
>  	u8 radix;
>  	u8 fwnmi_enabled;
>  	u8 secure_guest;
> +	u8 svm_enabled;
>  	bool threads_indep;
>  	bool nested_enable;
>  	pgd_t *pgtable;
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/as=
m/kvm_ppc.h
> index e716862..94f5a32 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -313,6 +313,7 @@ struct kvmppc_ops {
>  			       int size);
>  	int (*store_to_eaddr)(struct kvm_vcpu *vcpu, ulong *eaddr, void *ptr,
>  			      int size);
> +	int (*enable_svm)(struct kvm *kvm);
>  	int (*svm_off)(struct kvm *kvm);
>  };
> =20
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 85e75b1..8b8e1ed 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -5419,6 +5419,21 @@ static void unpin_vpa_reset(struct kvm *kvm, struc=
t kvmppc_vpa *vpa)
>  }
> =20
>  /*
> + * Enable a guest to become a secure VM, or test whether
> + * that could be enabled.
> + * Called when the KVM_CAP_PPC_SECURE_GUEST capability is
> + * tested (kvm =3D=3D NULL) or enabled (kvm !=3D NULL).
> + */
> +static int kvmhv_enable_svm(struct kvm *kvm)
> +{
> +	if (!kvmppc_uvmem_available())
> +		return -EINVAL;
> +	if (kvm)
> +		kvm->arch.svm_enabled =3D 1;
> +	return 0;
> +}
> +
> +/*
>   *  IOCTL handler to turn off secure mode of guest
>   *
>   * - Release all device pages
> @@ -5538,6 +5553,7 @@ static struct kvmppc_ops kvm_ops_hv =3D {
>  	.enable_nested =3D kvmhv_enable_nested,
>  	.load_from_eaddr =3D kvmhv_load_from_eaddr,
>  	.store_to_eaddr =3D kvmhv_store_to_eaddr,
> +	.enable_svm =3D kvmhv_enable_svm,
>  	.svm_off =3D kvmhv_svm_off,
>  };
> =20
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s=
_hv_uvmem.c
> index 79b1202..da454e2 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -113,6 +113,15 @@ struct kvmppc_uvmem_page_pvt {
>  	bool skip_page_out;
>  };
> =20
> +bool kvmppc_uvmem_available(void)
> +{
> +	/*
> +	 * If kvmppc_uvmem_bitmap !=3D NULL, then there is an ultravisor
> +	 * and our data structures have been initialized successfully.
> +	 */
> +	return !!kvmppc_uvmem_bitmap;
> +}
> +
>  int kvmppc_uvmem_slot_init(struct kvm *kvm, const struct kvm_memory_slot=
 *slot)
>  {
>  	struct kvmppc_uvmem_slot *p;
> @@ -216,6 +225,10 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kv=
m)
>  	if (!kvm_is_radix(kvm))
>  		return H_UNSUPPORTED;
> =20
> +	/* NAK the transition to secure if not enabled */
> +	if (!kvm->arch.svm_enabled)
> +		return H_AUTHORITY;
> +
>  	srcu_idx =3D srcu_read_lock(&kvm->srcu);
>  	slots =3D kvm_memslots(kvm);
>  	kvm_for_each_memslot(memslot, slots) {
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index e229a81..c48862d 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -669,6 +669,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lo=
ng ext)
>  		     (hv_enabled && cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST));
>  		break;
>  #endif
> +#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE)
> +	case KVM_CAP_PPC_SECURE_GUEST:
> +		r =3D hv_enabled && kvmppc_hv_ops->enable_svm &&
> +			!kvmppc_hv_ops->enable_svm(NULL);
> +		break;
> +#endif
>  	default:
>  		r =3D 0;
>  		break;
> @@ -2167,6 +2173,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r =3D kvm->arch.kvm_ops->enable_nested(kvm);
>  		break;
>  #endif
> +#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE)
> +	case KVM_CAP_PPC_SECURE_GUEST:
> +		r =3D -EINVAL;
> +		if (!is_kvmppc_hv_enabled(kvm) || !kvm->arch.kvm_ops->enable_svm)
> +			break;
> +		r =3D kvm->arch.kvm_ops->enable_svm(kvm);
> +		break;
> +#endif
>  	default:
>  		r =3D -EINVAL;
>  		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5e6234c..428c7dd 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1016,6 +1016,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_INJECT_EXT_DABT 178
>  #define KVM_CAP_S390_VCPU_RESETS 179
>  #define KVM_CAP_S390_PROTECTED 180
> +#define KVM_CAP_PPC_SECURE_GUEST 181
> =20
>  #ifdef KVM_CAP_IRQ_ROUTING
> =20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl55XyQACgkQbDjKyiDZ
s5J/YBAAotSAbqjmoaG4SUydVzXz50XsuGcdzTCD4YFRtwawEbbvOB1yuc67hUZh
zp2pyZQSxdwRq+bJXRRz/8ZKeWEZUMoQA4uTrtPdg8XFP6eqxdz55vyeduBYXIWH
CTGIDgHzoL2jw0mpn0fKlT3ujY9rrpIbXaP6fhhQLPJmmUaNg5TlcdXe7TJUe9dQ
88EYc7+MUeu/uNPPnZ/nkYdSHGMwRImKwcQMKt+jX1R+1agPU4OMyVe5nkKXj+tT
otdWwRai7Z4e9dchZW8kU61ZE/T47BQtCmdn6qSVbmdU3A3ds7axTE8fd37jTKrc
du+3Waf3bHUTQejYMHbI8QqtFRfv7e/3f5aD8zmH+zV33t8+I0FS/9NL+4BfYR4v
a4BDQoND44ywQ10oz8u0uzZk7Ycz2raow+MjnQXZvM7cnsF0Tcrp6LFAEAg0/o/o
8uUcDuj69xjB63Zzrn942HA4o0oIbWAJ53A2uEIBL/a7KMIfx3/g53XLiX5EdEq9
9ORlvFPNNcCC0NFDFuyoxv207LbN//YoLNXXrYpOkoQGSch3RWlJJ/1pfkK3gQNW
/wAWAU+tJVyRF6kp0u9bhW3lFBSlOQDVq0/j5oaSkVFhnECf80nc19a9/jQSm9p3
HKcypIwfaGIIDYAQ7pwwC7KkRiMi7oGQIYC0bGn/bbGD0Y8QELM=
=quok
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
