Return-Path: <kvm+bounces-58609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C8EAB98505
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 07:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D6161B21F05
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 05:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AEB423D2B8;
	Wed, 24 Sep 2025 05:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SrwJWHKh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435CA23B618
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 05:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758693408; cv=none; b=j2c9Wdm3aJg5oy5xwQ64xTm+Yp/NEX80vEfMIZV2ZvGwKzzStmx+pMGAxsCCjBRRPh7dDbFHC6BA5jXGCUinehNI/ly1uzPp32XgweOo7vt5G7Jw1i6kwSeb8TryyVQ4CCGES/TpM6wKi4zT78G8qxSF27ONA/RHwCWffyGdci0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758693408; c=relaxed/simple;
	bh=RmSn9aPJWfmxxJ7HoO5YJ9yGBOH8A1BLCkZ27rLodyk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AEyxx/qTVqzvnO1Gl3ZS/syXw/ogXJRJzNYT/Veb/TWjvB7CY6pwsvtP8/aq2dF1s2f7zc3ajoyjuhvxOaNVCpyaFQf269AGUTejqyxM2xWSlmWwTDDWDOpAVTliN9q6gbT7hz1vIqE28UOsv0osLQ9CD34t0gxgFphv0BwUg7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SrwJWHKh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758693405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gQYmCuF5Yt09RVbpiNlQOZjVEvefJekzfsLEKDWoHyM=;
	b=SrwJWHKhiPR64AoYi6w8vQLtcgr+EnClrj40t2teqHKPT3X1p2oefLqpu+qjAkDfuBX4Aw
	2ZKJUt4G3Dq7beFwVUgIeY/oOaOD+qrc7yk+f26S23VfaHQlO895TLu54/0NrtTVHaoTUo
	bn48EKP8zwehLe29u1IpdJXVxhv5d6g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-iwW_neqvNHmQ5fR8nY72lQ-1; Wed, 24 Sep 2025 01:56:43 -0400
X-MC-Unique: iwW_neqvNHmQ5fR8nY72lQ-1
X-Mimecast-MFC-AGG-ID: iwW_neqvNHmQ5fR8nY72lQ_1758693402
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f384f10762so1717251f8f.3
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 22:56:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758693402; x=1759298202;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gQYmCuF5Yt09RVbpiNlQOZjVEvefJekzfsLEKDWoHyM=;
        b=Xh7mx+TwYcXJGBvKkuifEgX5JpKu9p0Zbqn9KP0O2Yg2EDF+L4ETng0pDJgInbU8Jd
         Ct2oSgtg305J90pTPf5MN3ieZt7kMokGNdt6PDmmdAOai1kQpjOTk2Pptd7Apyp0C0Iv
         12tHIqcjOAtDmSerVJViioprZXe6U2dz+uAbnmvgvBI1APSgr3OVQqKPxgPGCd6OCTbG
         n9sovYuN0lt65yVA/d4ONo/aV4O7UxK87BnqatKSY0oN27vhfK2EengCiITC4rkE5lvC
         DNdEzm7fzjDCVd3VQqkTMX/8od1iaYyDG7F0gnbNtqPmH1HZTEHzHN2298Kix5RC+P6k
         uB+A==
X-Gm-Message-State: AOJu0YxDDHnz82Qu4HaHAZtciEetr5G9LB6+ArB4kvHdqzsS3kEJ1wYs
	uNUEzFokywmxEEzWbgJ0hSPF2+jXRXzURE2HmQZJUKuGhi9CtjIkdCSJjlFVyajhDNrtMEonG/3
	6PByp7O4KKmzAMk7FEfAaCxoCRtnw/dAyICxlzIOPYM8UPWnOrS5h5Q==
X-Gm-Gg: ASbGncsh/fY7OS8EUBKoVPy+OzLE9Vi85+1M5gbEcgO6U54nrtV7Yt+jsC4Ru1Yykj3
	KBWII0y/YgBKRj4cbcf0SRhoqkSy98H7eYcV1fe1sOQBZ/zF0Q2xzzAqRrwrWgCZM4U65/S0akx
	GHe39+b/FfQ/6y6mIq/sOg04EL/X45nZBJT4QnBvKfkvOM6CB0LjBxwcY1d8T5ebTJeHzZ/UUtF
	H6kLDiu4HG9k4QCW2ooX+6NWM6daisu7uzswCQcTuVkhlkgTBYTurLYlsF3yBIExl8oaRsZ/jbi
	QxWkvPQfMp0CfyFgCjfwbKMGEoE9+LTIZ3HZwRzm7kQtan48yrTzrc3SZxm/pY54jw==
X-Received: by 2002:a05:6000:2911:b0:405:3028:1bf2 with SMTP id ffacd0b85a97d-405cb3e5f74mr4394581f8f.62.1758693402281;
        Tue, 23 Sep 2025 22:56:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnph2Ugvc4AemK1c442avKDWoVUi+e/zwbHsG5zoj8kN3rniulgg1GxR/CgZ2bAIR2ea4MGw==
X-Received: by 2002:a05:6000:2911:b0:405:3028:1bf2 with SMTP id ffacd0b85a97d-405cb3e5f74mr4394566f8f.62.1758693401761;
        Tue, 23 Sep 2025 22:56:41 -0700 (PDT)
Received: from [10.200.68.91] (nat-pool-muc-u.redhat.com. [149.14.88.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f829e01a15sm15071554f8f.57.2025.09.23.22.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 22:56:41 -0700 (PDT)
Message-ID: <6e1171d041ea07fd79da55af77172f5434cfbe2a.camel@redhat.com>
Subject: Re: [RFC PATCH v3 1/1] vfio/pci: add PCIe TPH device ioctl
From: Philipp Stanner <pstanner@redhat.com>
To: Wathsala Vithanage <wathsala.vithanage@arm.com>, jgg@ziepe.ca, 
	alex.williamson@redhat.com, jeremy.linton@arm.com
Cc: kvm@vger.kernel.org
Date: Wed, 24 Sep 2025 07:56:40 +0200
In-Reply-To: <20250916175626.698384-1-wathsala.vithanage@arm.com>
References: <20250916175626.698384-1-wathsala.vithanage@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-09-16 at 17:56 +0000, Wathsala Vithanage wrote:
> This patch introduces VFIO_DEVICE_PCI_TPH IOCTL to enable configuring of
> TPH from the user space. It provides an interface to user space drivers
> and VMMs to enable/disable TPH capability on PCIe devices and set
> steering tags in MSI-X or steering-tag table entries or read steering
> tags from the kernel to use them in device-specific mode.
>=20
> Signed-off-by: Wathsala Vithanage <wathsala.vithanage@arm.com>
> ---
> =C2=A0drivers/vfio/pci/vfio_pci_core.c | 153 ++++++++++++++++++++++++++++=
+++
> =C2=A0include/uapi/linux/vfio.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 |=C2=A0 83 +++++++++++++++++
> =C2=A02 files changed, 236 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index 7dcf5439dedc..cc9ba6760862 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -28,6 +28,7 @@
> =C2=A0#include <linux/nospec.h>
> =C2=A0#include <linux/sched/mm.h>
> =C2=A0#include <linux/iommufd.h>
> +#include <linux/pci-tph.h>
> =C2=A0#if IS_ENABLED(CONFIG_EEH)
> =C2=A0#include <asm/eeh.h>
> =C2=A0#endif
> @@ -1443,6 +1444,156 @@ static int vfio_pci_ioctl_ioeventfd(struct vfio_p=
ci_core_device *vdev,
> =C2=A0				=C2=A0 ioeventfd.fd);
> =C2=A0}
> =C2=A0
> +static struct vfio_pci_tph_entry *vfio_pci_tph_get_ents(struct vfio_pci_=
tph *tph,
> +							void __user *tph_ents,
> +							size_t *ents_size)
> +{
> +	unsigned long minsz;
> +	size_t size;
> +
> +	if (!ents_size)
> +		return ERR_PTR(-EINVAL);
> +
> +	minsz =3D offsetofend(struct vfio_pci_tph, count);
> +
> +	size =3D tph->count * sizeof(struct vfio_pci_tph_entry);
> +
> +	if (tph->argsz - minsz < size)
> +		return ERR_PTR(-EINVAL);
> +
> +	*ents_size =3D size;
> +
> +	return memdup_user(tph_ents, size);

There is memdup_user_array() nowadays. It does things like an overflow
check for you.

> +}
> +
> +static int vfio_pci_tph_set_st(struct vfio_pci_core_device *vdev,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vfio_pci_tph_entry *ents,=
 int count)
> +{
> +	int i, err =3D 0;
> +
> +	for (i =3D 0; i < count && !err; i++)
> +		err =3D pcie_tph_set_st_entry(vdev->pdev, ents[i].index,
> +					=C2=A0=C2=A0=C2=A0 ents[i].st);
> +
> +	return err;
> +}
> +
> +static int vfio_pci_tph_get_st(struct vfio_pci_core_device *vdev,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vfio_pci_tph_entry *ents,=
 int count)
> +{
> +	int i, mtype, err =3D 0;
> +	u32 cpu_uid;
> +
> +	for (i =3D 0; i < count && !err; i++) {
> +		if (ents[i].cpu_id >=3D nr_cpu_ids || !cpu_present(ents[i].cpu_id)) {
> +			err =3D -EINVAL;
> +			break;
> +		}

Just doing a return -EINVAL hear reads clearer and is just 1 line.

> +
> +		cpu_uid =3D topology_core_id(ents[i].cpu_id);
> +		mtype =3D (ents[i].flags & VFIO_TPH_MEM_TYPE_MASK) >>
> +			VFIO_TPH_MEM_TYPE_SHIFT;
> +
> +		/*
> +		 * ph_ignore is always set.
> +		 * TPH implementation of the PCI subsystem forces processing
> +		 * hint to bi-directional by setting PH bits to 0 when
> +		 * acquiring Steering Tags from the platform firmware. It also
> +		 * discards the ph_ignore bit returned by firmware.
> +		 */
> +		ents[i].ph_ignore =3D 1;
> +
> +		err =3D pcie_tph_get_cpu_st(vdev->pdev, mtype, cpu_uid,
> +					=C2=A0 &ents[i].st);
> +	}
> +
> +	return err;
> +}
> +
> +static int vfio_pci_tph_st_op(struct vfio_pci_core_device *vdev,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vfio_pci_tph *tph, void __user =
*tph_ents)
> +{
> +	int err =3D 0;
> +	struct vfio_pci_tph_entry *ents;
> +	size_t ents_size;
> +
> +	if (!tph->count || tph->count > VFIO_TPH_INFO_MAX) {
> +		err =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	ents =3D vfio_pci_tph_get_ents(tph, tph_ents, &ents_size);
> +	if (IS_ERR(ents)) {
> +		err =3D PTR_ERR(ents);
> +		goto out;

the 'out' goto label here and above doesn't actually perform any
operation except for returning anyways. So you can do a canonical
early-return here.

> +	}
> +
> +	err =3D vfio_pci_tph_get_st(vdev, ents, tph->count);
> +	if (err)
> +		goto out_free_ents;
> +
> +	/*
> +	 * Set Steering tags. TPH will be disabled on the device by the PCI
> +	 * subsystem if there is an error.
> +	 */
> +	if (tph->flags & VFIO_DEVICE_TPH_SET_ST) {
> +		err =3D vfio_pci_tph_set_st(vdev, ents, tph->count);
> +		if (err)
> +			goto out_free_ents;
> +	}
> +
> +	if (copy_to_user(tph_ents, ents, ents_size))
> +		err =3D -EFAULT;
> +
> +out_free_ents:
> +	kfree(ents);
> +out:
> +	return err;
> +}
> +
> +static int vfio_pci_tph_enable(struct vfio_pci_core_device *vdev,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vfio_pci_tph *arg)
> +{
> +	return pcie_enable_tph(vdev->pdev, arg->flags & VFIO_TPH_ST_MODE_MASK);
> +}
> +
> +static int vfio_pci_tph_disable(struct vfio_pci_core_device *vdev)
> +{
> +	pcie_disable_tph(vdev->pdev);
> +	return 0;
> +}
> +
> +static int vfio_pci_ioctl_tph(struct vfio_pci_core_device *vdev,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void __user *uarg)
> +{
> +	u32 op;
> +	struct vfio_pci_tph tph;
> +	size_t minsz =3D offsetofend(struct vfio_pci_tph, count);
> +
> +	if (copy_from_user(&tph, uarg, minsz))
> +		return -EFAULT;
> +
> +	if (tph.argsz < minsz)
> +		return -EINVAL;
> +
> +	op =3D tph.flags & VFIO_DEVICE_TPH_OP_MASK;
> +
> +	switch (op) {
> +	case VFIO_DEVICE_TPH_ENABLE:
> +		return vfio_pci_tph_enable(vdev, &tph);
> +
> +	case VFIO_DEVICE_TPH_DISABLE:
> +		return vfio_pci_tph_disable(vdev);
> +
> +	case VFIO_DEVICE_TPH_GET_ST:
> +	case VFIO_DEVICE_TPH_SET_ST:
> +		return vfio_pci_tph_st_op(vdev, &tph, (u8 *)(uarg) + minsz);

I'm not an expert on TPH; but to me it reads quite unclear why a
pointer (to the start of an array / data field?) should be turned into
another pointer, offsetting at something called "minsz". "minimu size"
after all means that the size can be larger.

Maybe a small comment could be helpful here.

> +
> +	default:
> +		return -EINVAL;
> +	}

Empty lines in switch cases are unusual in the kernel and, more
importantly, directly below you add another switch case with a
different coding style without empty line.

It should be kept consistent with the overall file.


Regards
P.

> +}
> +
> =C2=A0long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned in=
t cmd,
> =C2=A0			 unsigned long arg)
> =C2=A0{
> @@ -1467,6 +1618,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_v=
dev, unsigned int cmd,
> =C2=A0		return vfio_pci_ioctl_reset(vdev, uarg);
> =C2=A0	case VFIO_DEVICE_SET_IRQS:
> =C2=A0		return vfio_pci_ioctl_set_irqs(vdev, uarg);
> +	case VFIO_DEVICE_PCI_TPH:
> +		return vfio_pci_ioctl_tph(vdev, uarg);
> =C2=A0	default:
> =C2=A0		return -ENOTTY;
> =C2=A0	}
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 75100bf009ba..a642a2ff21a6 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -873,6 +873,88 @@ struct vfio_device_ioeventfd {
> =C2=A0
> =C2=A0#define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
> =C2=A0
> +/**
> + * VFIO_DEVICE_PCI_TPH	- _IO(VFIO_TYPE, VFIO_BASE + 22)
> + *
> + * This command is used to control PCIe TLP Processing Hints (TPH)
> + * capability in a PCIe device.
> + * It supports following operations on a PCIe device with respect to TPH
> + * capability.
> + *
> + * - Enabling/disabling TPH capability in a PCIe device.
> + *
> + *=C2=A0=C2=A0 Setting VFIO_DEVICE_TPH_ENABLE flag enables TPH in no-ste=
ering-tag,
> + *=C2=A0=C2=A0 interrupt-vector, or device-specific mode defined in the =
PCIe specficiation
> + *=C2=A0=C2=A0 when feature flags TPH_ST_NS_MODE, TPH_ST_IV_MODE, and TP=
H_ST_DS_MODE are
> + *=C2=A0=C2=A0 set respectively. TPH_ST_xx_MODE macros are defined in
> + *=C2=A0=C2=A0 uapi/linux/pci_regs.h.
> + *
> + *=C2=A0=C2=A0 VFIO_DEVICE_TPH_DISABLE disables PCIe TPH on the device.
> + *
> + * - Writing STs to MSI-X or ST table in a PCIe device.
> + *
> + *=C2=A0=C2=A0 VFIO_DEVICE_TPH_SET_ST flag set steering tags on a device=
 at an index in
> + *=C2=A0=C2=A0 MSI-X or ST-table depending on the VFIO_TPH_ST_x_MODE fla=
g used and
> + *=C2=A0=C2=A0 returns the programmed steering tag values. The caller ca=
n set one or more
> + *=C2=A0=C2=A0 steering tags by passing an array of vfio_pci_tph_entry o=
bjects containing
> + *=C2=A0=C2=A0 cpu_id, cache_level, and MSI-X/ST-table index. The caller=
 can also set the
> + *=C2=A0=C2=A0 intended memory type and the processing hint by setting V=
FIO_TPH_MEM_TYPE_x
> + *=C2=A0=C2=A0 and VFIO_TPH_HINT_x flags, respectively.
> + *
> + * - Reading Steering Tags (ST) from the host platform.
> + *
> + *=C2=A0=C2=A0 VFIO_DEVICE_TPH_GET_ST flags returns steering tags to the=
 caller. Caller
> + *=C2=A0=C2=A0 can request one or more steering tags by passing an array=
 of
> + *=C2=A0=C2=A0 vfio_pci_tph_entry objects. Steering Tag for each request=
 is returned via
> + *=C2=A0=C2=A0 the st field in vfio_pci_tph_entry.
> + */
> +struct vfio_pci_tph_entry {
> +	/* in */
> +	__u32 cpu_id;			/* CPU logical ID */
> +	__u32 cache_level;		/* Cache level. L1 D=3D 0, L2D =3D 2, ...*/
> +	__u8=C2=A0 flags;
> +#define VFIO_TPH_MEM_TYPE_MASK		0x1
> +#define VFIO_TPH_MEM_TYPE_SHIFT		0
> +#define VFIO_TPH_MEM_TYPE_VMEM		0=C2=A0=C2=A0 /* Request volatile memory=
 ST */
> +#define VFIO_TPH_MEM_TYPE_PMEM		1=C2=A0=C2=A0 /* Request persistent memo=
ry ST */
> +
> +#define VFIO_TPH_HINT_SHIFT		1
> +#define VFIO_TPH_HINT_MASK		(0x3 << VFIO_TPH_HINT_SHIFT)
> +#define VFIO_TPH_HINT_BIDIR		0
> +#define VFIO_TPH_HINT_REQSTR		(1 << VFIO_TPH_HINT_SHIFT)
> +#define VFIO_TPH_HINT_TARGET		(2 << VFIO_TPH_HINT_SHIFT)
> +#define VFIO_TPH_HINT_TARGET_PRIO	(3 << VFIO_TPH_HINT_SHIFT)
> +	__u8=C2=A0 pad0;
> +	__u16 index;			/* MSI-X/ST-table index to set ST */
> +	/* out */
> +	__u16 st;			/* Steering-Tag */
> +	__u8=C2=A0 ph_ignore;		/* Platform ignored the Processing */
> +	__u8=C2=A0 pad1;
> +};
> +
> +struct vfio_pci_tph {
> +	__u32 argsz;			/* Size of vfio_pci_tph and ents[] */
> +	__u32 flags;
> +#define VFIO_TPH_ST_MODE_MASK		0x7
> +
> +#define VFIO_DEVICE_TPH_OP_SHIFT	3
> +#define VFIO_DEVICE_TPH_OP_MASK		(0x7 << VFIO_DEVICE_TPH_OP_SHIFT)
> +/* Enable TPH on device */
> +#define VFIO_DEVICE_TPH_ENABLE		0
> +/* Disable TPH on device */
> +#define VFIO_DEVICE_TPH_DISABLE		(1 << VFIO_DEVICE_TPH_OP_SHIFT)
> +/* Get steering-tags */
> +#define VFIO_DEVICE_TPH_GET_ST		(2 << VFIO_DEVICE_TPH_OP_SHIFT)
> +/* Set steering-tags */
> +#define VFIO_DEVICE_TPH_SET_ST		(4 << VFIO_DEVICE_TPH_OP_SHIFT)
> +	__u32 count;			/* Number of entries in ents[] */
> +	struct vfio_pci_tph_entry ents[];
> +#define VFIO_TPH_INFO_MAX	2048	/* Max entries in ents[] */
> +};
> +
> +#define VFIO_DEVICE_PCI_TPH	_IO(VFIO_TYPE, VFIO_BASE + 22)
> +
> +
> =C2=A0/**
> =C2=A0 * VFIO_DEVICE_FEATURE - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
> =C2=A0 *			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vfio_device_featur=
e)
> @@ -1478,6 +1560,7 @@ struct vfio_device_feature_bus_master {
> =C2=A0};
> =C2=A0#define VFIO_DEVICE_FEATURE_BUS_MASTER 10
> =C2=A0
> +
> =C2=A0/* -------- API for Type1 VFIO IOMMU -------- */
> =C2=A0
> =C2=A0/**


