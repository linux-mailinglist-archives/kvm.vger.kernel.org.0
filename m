Return-Path: <kvm+bounces-64350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E0CC80338
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:28:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B0D74341780
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998162FD1DC;
	Mon, 24 Nov 2025 11:28:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE85F242D6E;
	Mon, 24 Nov 2025 11:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763983705; cv=none; b=mnRtYav9ZRFJ/5xEGP6k572WnZyMgK7+F2DPh4CQvMCbPukM+/7d7GWYUlZbKkykC0u3ik+RsI23ymWK/I4tQTc6Ac7LHO3PzrGtxdb3pwLLaw03PhBM2Qi0ELFLDnuv893g/fZfwTPY/wPJLDIYYZqOje3axjiZ6HZVz1Yqfb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763983705; c=relaxed/simple;
	bh=bXDCqJlS8eziB5lVX8bXgEcxkKi7kcDyTmoEGp7HWuQ=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HHOCYHbFNLjox/dxSPYWUcmjnC74Y32X4pH7sq9jAx7rQGjk1bzzRYPmPlKM+g/Lfuu5MNcOtn+RmypPnd5rDdJL1xZP9uPTxMDXCBwXMjyepQ3uYb+W0P9rvPFQkpzxLr/O6QQ/YQBsZLBoQd/5XtWnO0vRaR3GQyuP0MI+HW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: "seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: use call_rcu instead of synchronize_srcu_expedited()
 for MMIO unregistration
Thread-Topic: [PATCH] KVM: use call_rcu instead of
 synchronize_srcu_expedited() for MMIO unregistration
Thread-Index: AQHcN4iyHY6h+MoBIU6WF9/WlIA9gLUB+5FQ
Date: Mon, 24 Nov 2025 11:28:01 +0000
Message-ID: <21c0d48394bb4e549a55f6eb47215881@baidu.com>
References: <20251007124829.2051-1-lirongqing@baidu.com>
In-Reply-To: <20251007124829.2051-1-lirongqing@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.3.12
X-FE-Policy-ID: 52:10:53:SYSTEM

> From: Li RongQing <lirongqing@baidu.com>
>=20
> During VM reboot/shutdown, device MMIO unregistration maybe occurs
> frequently. The current use of synchronize_srcu_expedited() introduces
> measurable latency in these operations. Replace with call_rcu to defer
> cleanup asynchronously, speed up VM reboot/shutdown.
>=20
> Add a 'dev' field to struct kvm_io_bus to hold the device being unregiste=
red
> for the RCU callback. Adjust related code to ensure proper list managemen=
t
> before unregistration.


Ping

Thanks

-Li


>=20
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  include/linux/kvm_host.h  |  1 +
>  virt/kvm/coalesced_mmio.c |  2 +-
>  virt/kvm/eventfd.c        |  2 +-
>  virt/kvm/kvm_main.c       | 13 ++++++++-----
>  4 files changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h index
> 19b8c4b..38498d9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -208,6 +208,7 @@ struct kvm_io_bus {
>  	int dev_count;
>  	int ioeventfd_count;
>  	struct rcu_head rcu;
> +	struct kvm_io_device *dev;
>  	struct kvm_io_range range[];
>  };
>=20
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c index
> 375d628..0db6af2 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -82,7 +82,6 @@ static void coalesced_mmio_destructor(struct
> kvm_io_device *this)  {
>  	struct kvm_coalesced_mmio_dev *dev =3D to_mmio(this);
>=20
> -	list_del(&dev->list);
>=20
>  	kfree(dev);
>  }
> @@ -169,6 +168,7 @@ int
> kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
>  	list_for_each_entry_safe(dev, tmp, &kvm->coalesced_zones, list) {
>  		if (zone->pio =3D=3D dev->zone.pio &&
>  		    coalesced_mmio_in_range(dev, zone->addr, zone->size)) {
> +			list_del(&dev->list);
>  			r =3D kvm_io_bus_unregister_dev(kvm,
>  				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS,
> &dev->dev);
>  			/*
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c index 6b1133a..8a2f0=
e0
> 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -750,7 +750,6 @@ static void
>  ioeventfd_release(struct _ioeventfd *p)  {
>  	eventfd_ctx_put(p->eventfd);
> -	list_del(&p->list);
>  	kfree(p);
>  }
>=20
> @@ -949,6 +948,7 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm,
> enum kvm_bus bus_idx,
>  		if (!p->wildcard && p->datamatch !=3D args->datamatch)
>  			continue;
>=20
> +		list_del(&p->list);
>  		kvm_io_bus_unregister_dev(kvm, bus_idx, &p->dev);
>  		bus =3D kvm_get_bus(kvm, bus_idx);
>  		if (bus)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c index
> f2e77eb..3ddad34 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5955,10 +5955,12 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu,
> enum kvm_bus bus_idx, gpa_t addr,  }
> EXPORT_SYMBOL_GPL(kvm_io_bus_read);
>=20
> -static void __free_bus(struct rcu_head *rcu)
> +static void __free_bus_dev(struct rcu_head *rcu)
>  {
>  	struct kvm_io_bus *bus =3D container_of(rcu, struct kvm_io_bus, rcu);
>=20
> +	if (bus->dev)
> +		kvm_iodevice_destructor(bus->dev);
>  	kfree(bus);
>  }
>=20
> @@ -6000,7 +6002,8 @@ int kvm_io_bus_register_dev(struct kvm *kvm,
> enum kvm_bus bus_idx, gpa_t addr,
>  	memcpy(new_bus->range + i + 1, bus->range + i,
>  		(bus->dev_count - i) * sizeof(struct kvm_io_range));
>  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> -	call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
> +	bus->dev =3D NULL;
> +	call_srcu(&kvm->srcu, &bus->rcu, __free_bus_dev);
>=20
>  	return 0;
>  }
> @@ -6036,20 +6039,20 @@ int kvm_io_bus_unregister_dev(struct kvm
> *kvm, enum kvm_bus bus_idx,
>  	}
>=20
>  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> -	synchronize_srcu_expedited(&kvm->srcu);
>=20
>  	/*
>  	 * If NULL bus is installed, destroy the old bus, including all the
>  	 * attached devices. Otherwise, destroy the caller's device only.
>  	 */
>  	if (!new_bus) {
> +		synchronize_srcu_expedited(&kvm->srcu);
>  		pr_err("kvm: failed to shrink bus, removing it completely\n");
>  		kvm_io_bus_destroy(bus);
>  		return -ENOMEM;
>  	}
>=20
> -	kvm_iodevice_destructor(dev);
> -	kfree(bus);
> +	bus->dev =3D dev;
> +	call_srcu(&kvm->srcu, &bus->rcu, __free_bus_dev);
>  	return 0;
>  }
>=20
> --
> 2.9.4


