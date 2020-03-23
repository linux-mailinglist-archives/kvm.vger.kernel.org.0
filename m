Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068A318EE77
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 04:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgCWDVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 23:21:22 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43715 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgCWDVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 23:21:22 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 48m05q1K8Pz9sRR; Mon, 23 Mar 2020 14:21:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1584933679;
        bh=9Fiea/K9UtfjWul8TzOuLAmDjgxng+7aywC8SOF4SvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PhHjGjeYMRqsi+TrZh7ArkX6e9Fe1pTKQVtUWZfi+Ez61Z/A/VvrbOh4hV9tGaLvJ
         4fiPrqH9Ywt8GleFLNkGXdPM8gINIwTph1w6+5lmVOUNW3Vi2CA6r8MTgMMSJlxq0x
         He8wT3veVAfgJQvofD4HU4k6E7BtThCD96sLMqk4=
Date:   Mon, 23 Mar 2020 14:18:09 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Add a capability for enabling
 secure guests
Message-ID: <20200323031809.GC2213@umbus.fritz.box>
References: <20200319043301.GA13052@blackberry>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline
In-Reply-To: <20200319043301.GA13052@blackberry>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2020 at 03:33:01PM +1100, Paul Mackerras wrote:
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
> Note, only compile-tested.  Ram, please test.
>=20
>  Documentation/virt/kvm/api.rst      | 17 +++++++++++++++++
>  arch/powerpc/include/asm/kvm_host.h |  1 +
>  arch/powerpc/include/asm/kvm_ppc.h  |  1 +
>  arch/powerpc/kvm/book3s_hv.c        | 13 +++++++++++++
>  arch/powerpc/kvm/book3s_hv_uvmem.c  |  4 ++++
>  arch/powerpc/kvm/powerpc.c          | 13 +++++++++++++
>  include/uapi/linux/kvm.h            |  1 +
>  7 files changed, 50 insertions(+)
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
> index 406ec46..0733618 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -316,6 +316,7 @@ struct kvmppc_ops {
>  			       int size);
>  	int (*store_to_eaddr)(struct kvm_vcpu *vcpu, ulong *eaddr, void *ptr,
>  			      int size);
> +	int (*enable_svm)(struct kvm *kvm);
>  	int (*svm_off)(struct kvm *kvm);
>  };
> =20
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index fbc55a1..36da720 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -5423,6 +5423,18 @@ static void unpin_vpa_reset(struct kvm *kvm, struc=
t kvmppc_vpa *vpa)
>  }
> =20
>  /*
> + * Enable a guest to become a secure VM.
> + * Called when the KVM_CAP_PPC_SECURE_GUEST capability is enabled.
> + */
> +static int kvmhv_enable_svm(struct kvm *kvm)
> +{
> +	if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> +		return -EINVAL;
> +	kvm->arch.svm_enabled =3D 1;
> +	return 0;
> +}
> +
> +/*
>   *  IOCTL handler to turn off secure mode of guest
>   *
>   * - Release all device pages
> @@ -5543,6 +5555,7 @@ static struct kvmppc_ops kvm_ops_hv =3D {
>  	.enable_nested =3D kvmhv_enable_nested,
>  	.load_from_eaddr =3D kvmhv_load_from_eaddr,
>  	.store_to_eaddr =3D kvmhv_store_to_eaddr,
> +	.enable_svm =3D kvmhv_enable_svm,
>  	.svm_off =3D kvmhv_svm_off,
>  };
> =20
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s=
_hv_uvmem.c
> index 79b1202..2ad999f 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -216,6 +216,10 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kv=
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
> index 62ee66d..c32e6cc2 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -670,6 +670,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lo=
ng ext)
>  		     (hv_enabled && cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST));
>  		break;
>  #endif
> +#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC_UV)
> +	case KVM_CAP_PPC_SECURE_GUEST:
> +		r =3D hv_enabled && !!firmware_has_feature(FW_FEATURE_ULTRAVISOR);
> +		break;
> +#endif
>  	default:
>  		r =3D 0;
>  		break;
> @@ -2170,6 +2175,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r =3D kvm->arch.kvm_ops->enable_nested(kvm);
>  		break;
>  #endif
> +#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC_UV)
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

--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl54Km4ACgkQbDjKyiDZ
s5I37A/+J6leUDMAefLybyU3lTQDUCpSVAyqITbZMz4qkDp2jQNRURAQQLRPopc0
kM/VpiUwjROECKLZ7bP6napcj8Wcsfz2GDFwIMJE3SS10Q91pJXzRzh+EUrNZ7jS
y5vfOCy6fbpe+6lC9V+wndJXSiYydVTeu+nm9cpHEvGlxDum5qkqYDkk/mZlTe82
tnDwj54TY6+Wu2A38j//4FoDUT9C0HIURoovUlPECufakPdayYB/51/oJszVU/2a
UQ2lEJdzwyHpFQRBjd8V/x87+97DWLuiekVgdVLK18u1epmedK2lNX7NSdQLM+I1
lYSJ0HA8SnKojrx7UWDFogvlCm6caSfzd6npJsh6wd8DpPOqKCszUGkYGtgmPnqA
/rCq8ukCO7XxGIRJi1mxvZfUBBMwY9z7xkQOHxWx123G2DAtyW8BESdXPInjaKLO
L6VPdDBM81jE9LQ+VuDAjEuanBr3915cg6NNYGTXuiNxVy0opePTh1d7ijn7wWbM
MVYR1OGYCSm+Oshl3xmBwAq1z0c6vpLu5KK5vZwJ7OvI3rHZqa+wonjAA8S0C9Cr
8IttewsRxQ6FgishOhP8tIlTlM7uCWSMierwtx7fu1bfzMHw4+WMsKEp3+AikEFI
HV7qkwG7RKMmia+ShQ6mq738GeDZVKNrPmZkPHHka7YIQj0AEqA=
=RvKU
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--
