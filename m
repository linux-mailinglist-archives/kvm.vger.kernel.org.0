Return-Path: <kvm+bounces-41854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EBDFA6E1D7
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 18:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09800163B50
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 17:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEDD22641DC;
	Mon, 24 Mar 2025 17:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ey8acH8B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F371DC985;
	Mon, 24 Mar 2025 17:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742838977; cv=none; b=Wcv3jV7XrHF65iP/vTtmygOt6PbSpI6Hrrs4W3KQtn48ya+9qVvf0ocp778Rp0PNUvHl/TuTGMeljWvRi/2vIpKZ7fiesoaei350XXRaUPE0JqOVAScxRpgRCgXvsHp2Ie5f+aecaytCqjA0JYv0SOdDuLxq8kTAu3cZCiVoR3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742838977; c=relaxed/simple;
	bh=55aSHf+XbnaEkNNtZWAap9c2eiaxcY92LDR82+5KUkE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I1U/7IGDhHXntW0kDWRxDQ88i/NCnPBRjyIShpL68NTUsUWr4uhqecc4C0RA+v1Bj7nPe9ab88FjANvcTB0p+t8nLIMIfvdE6oA8Oz042JOuZxdnQeDkjQNRBw0hH80YzsuaVKlcEBen572yjSZXLfYdMAjqjLqLmHPIvVisDtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ey8acH8B; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52OHBZPn027062;
	Mon, 24 Mar 2025 17:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=prxcL7
	Ol0gDHWADygOhfxw4rXA3/txwyq4L2EIdtr0o=; b=ey8acH8BhQQpV7Rkkcv3qk
	iYB1qdSCJmXBJGd5tKEllxA4e4tHn0M8AaS5H/npjL1f62a34tG0sEoSVSmmvkGo
	/g+qF9pA6KqTiYYMh/8IqXXEByZvU8t6HNij+2AwOXo4fVEpKZGZyfVgYs3K5QNw
	858npq/6lkGam1ZJ8E/osa1RPW4zcKFLJ5aDph5BZzVe1oizfHkY3wS3aJUFHeik
	r8irsF+5AfGF8s0f5my4vKdFcu1HykPo+9L183UaOSMJO1fKRbhBtT7RXDng1LJD
	+SPOA7N6PkSBOGzaElIOq6FlJA5LY+06l3eHd9I/4gzGsLBdeSPRPuVV2kvU93yA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45kbjwr6v4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 17:56:06 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52OFKECV030330;
	Mon, 24 Mar 2025 17:56:06 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45j7ht7nw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 17:56:06 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52OHu4RE33292630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Mar 2025 17:56:04 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DF7220043;
	Mon, 24 Mar 2025 17:56:04 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3654120040;
	Mon, 24 Mar 2025 17:56:04 +0000 (GMT)
Received: from li-9b52914c-2c8b-11b2-a85c-a36f6d484b4a.boeblingen.de.ibm.com (unknown [9.155.199.15])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 24 Mar 2025 17:56:04 +0000 (GMT)
Message-ID: <3920c0f0da1b6e324d6367cbff22d313d6981742.camel@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio_console: fix missing byte order handling for
 cols and rows
From: Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
To: Halil Pasic <pasic@linux.ibm.com>, Amit Shah <amit@kernel.org>,
        Arnd
 Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Cc: stable@vger.kernel.org
Date: Mon, 24 Mar 2025 18:56:03 +0100
In-Reply-To: <20250322002954.3129282-1-pasic@linux.ibm.com>
References: <20250322002954.3129282-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: INZKdWk_pasSNB8PIaiuDorK7o5Zx59a
X-Proofpoint-ORIG-GUID: INZKdWk_pasSNB8PIaiuDorK7o5Zx59a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-24_06,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 spamscore=0
 clxscore=1011 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503240125

On Sat, 2025-03-22 at 01:29 +0100, Halil Pasic wrote:
> As per virtio spec the fields cols and rows are specified as little
> endian. Although there is no legacy interface requirement that would
> state that cols and rows need to be handled as native endian when
> legacy
> interface is used, unlike for the fields of the adjacent struct
> virtio_console_control, I decided to err on the side of caution based
> on some non-conclusive virtio spec repo archaeology and opt for using
> virtio16_to_cpu() much like for virtio_console_control.event.
> Strictly
> by the letter of the spec virtio_le_to_cpu() would have been
> sufficient.
> But when the legacy interface is not used, it boils down to the same.
>=20
> And when using the legacy interface, the device formatting these as
> little endian when the guest is big endian would surprise me more
> than
> it using guest native byte order (which would make it compatible with
> the current implementation). Nevertheless somebody trying to
> implement
> the spec following it to the letter could end up forcing little
> endian
> byte order when the legacy interface is in use. So IMHO this
> ultimately
> needs a judgement call by the maintainers.
>=20
> Fixes: 8345adbf96fc1 ("virtio: console: Accept console size along
> with resize control message")
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Cc: stable@vger.kernel.org=C2=A0# v2.6.35+
> ---
>=20
> @Michael: I think it would be nice to add a clarification on the byte
> order to be used for cols and rows when the legacy interface is used
> to
> the spec, regardless of what we decide the right byte order is. If
> it is native endian that shall be stated much like it is stated for
> virtio_console_control. If it is little endian, I would like to add
> a sentence that states that unlike for the fields of
> virtio_console_control
> the byte order of the fields of struct virtio_console_resize is
> little
> endian also when the legacy interface is used.
>=20
> @Maximilian: Would you mind giving this a spin with your
> implementation
> on the device side of things in QEMU?
> ---
> =C2=A0drivers/char/virtio_console.c | 7 ++++---
> =C2=A01 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/char/virtio_console.c
> b/drivers/char/virtio_console.c
> index 18f92dd44d45..fc698e2b1da1 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -1579,8 +1579,8 @@ static void handle_control_message(struct
> virtio_device *vdev,
> =C2=A0		break;
> =C2=A0	case VIRTIO_CONSOLE_RESIZE: {
> =C2=A0		struct {
> -			__u16 rows;
> -			__u16 cols;
> +			__virtio16 rows;
> +			__virtio16 cols;
> =C2=A0		} size;
> =C2=A0
> =C2=A0		if (!is_console_port(port))
> @@ -1588,7 +1588,8 @@ static void handle_control_message(struct
> virtio_device *vdev,
> =C2=A0
> =C2=A0		memcpy(&size, buf->buf + buf->offset +
> sizeof(*cpkt),
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(size));
> -		set_console_size(port, size.rows, size.cols);
> +		set_console_size(port, virtio16_to_cpu(vdev,
> size.rows),
> +				 virtio16_to_cpu(vdev, size.cols));
> =C2=A0
> =C2=A0		port->cons.hvc->irq_requested =3D 1;
> =C2=A0		resize_console(port);
>=20
> base-commit: b3ee1e4609512dfff642a96b34d7e5dfcdc92d05

It took me a while to recompile the kernel, but now that it has
compiled it works! Unfortunately, images don't lend themselves well to
mailing lists, but here is tmux running at 18x55(you'll just have to
trust me that it's over a virtio serial console)

                           =E2=94=82top - 12:54:04 up 4 min,  1
~                          =E2=94=82Tasks: 222 total,   1 runni
~                          =E2=94=82%Cpu(s):  0.0 us,  0.0 sy,=20
~                          =E2=94=82MiB Mem :  15987.2 total, =20
~                          =E2=94=82MiB Swap:   8192.0 total, =20
~                          =E2=94=82
~                          =E2=94=82    PID USER      PR  NI=20
~                          =E2=94=82      1 root      20   0=20
~                          =E2=94=82      2 root      20   0=20
~                          =E2=94=82      3 root      20   0=20
~                          =E2=94=82      4 root       0 -20=20
~                          =E2=94=82      5 root       0 -20=20
~                          =E2=94=82      6 root       0 -20=20
~                          =E2=94=82      7 root       0 -20=20
~                          =E2=94=82      8 root       0 -20=20
[No Name]     0,0-1     All=E2=94=82      9 root      20   0=20
                           =E2=94=82     10 root       0 -20=20
[0] 0:zsh*                     "fedora" 12:53 24-Mar-25

Cheers,
Max


