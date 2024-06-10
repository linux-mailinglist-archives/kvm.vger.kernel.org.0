Return-Path: <kvm+bounces-19163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F1D901CDA
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 10:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5CEAFB21C63
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 08:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD136F2E7;
	Mon, 10 Jun 2024 08:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FyOi6n7q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BD84D8BC;
	Mon, 10 Jun 2024 08:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718007705; cv=none; b=sNUDLFbacqTvES4i6s+RYUU/bHINp/FQ2EurzgdmE5ofb+2gsiyd24QM050hQQA9312GNy9vKpDJKTBxDRxEIfZcuGvlrNc0pr0TjyURlkDzFTNtIHy01opDQkriJySIYvVwVthHJHF5JZK/3sxU/KTtZrCTIi9IV+4zQT4uoTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718007705; c=relaxed/simple;
	bh=68qVpkivRPu/UqBy8a5aM/GcH3KxSp5sMnJQNIuc4FU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aAnVIOkLeTdxTC9XrNjddvIfr/5z7VXTFSUWEEF80VZkf7BV1+mHKLEMXMvfwLAwUbDSQsZqIutR0TFnX0hJX233xfqeJ0pwSV+Q/LnuEdl/+4k9X37P6mh2D/S9RGC6QzhaYePhSgZ8pm7YH5NcazxetC+z0XAlpB+1Qssz8Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FyOi6n7q; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-57a4d7ba501so5286457a12.2;
        Mon, 10 Jun 2024 01:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718007702; x=1718612502; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JwKWNr3+SkhJYsnRjSQdpuuiDdqh1Y+N1jlC0TkNGnY=;
        b=FyOi6n7qTs2M1acOLHUKYVCxHR4o/phgVvtAmExnQSPtNfhK6kJipVRXWs7uYAYteT
         CVvmCviyBqjz8rgbyJ43MIMeJST0eP1GQB1NBMYzrhYvB1fS1cQ/NfPRz5eAKj7MTCPa
         ZNskFw+WKm3Mf0LG16W+RlgpkFBfbY+t+wwMX2i0OF4MfOCyZ1KO/LrF5IPD85TZ4oeK
         YczC3QsT/kBynFGYHS7cfjJ+f72TPPOZFxO34QtJBIx605DmNvB1ZzXWcSbnXiwP8yNH
         TA5ttEolrGdUeEdD/kS+QJZm2q0XEVeTUlo7mwhLyMa8K98cMbPep5UrxfAqheu+d+eF
         7WLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718007702; x=1718612502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JwKWNr3+SkhJYsnRjSQdpuuiDdqh1Y+N1jlC0TkNGnY=;
        b=oCMGVxxCVlZAVWA367MBqRGyxPBxP31f7dLGx6lbpVyI/abARJs7WYiIDctUr5D4tY
         raHDS296glKkFW7vEuq2b6nbHjkeVutj5/ngHktv/wP/rBKNKbMLryg3iAbD2J1effts
         GCLSNwdweJ/GVu55haMXUvHp+RCHIRqRJHFqFmSD3Ae6nlJ3xkq2lDFlZ6nWVCFoONBC
         Rq7ahI0jl9pSPjmZmKrtJ9HkEPvYlbPX7d+k1GY4Xbz95l1CD6GlMuh8z1vRIoyxqp13
         C7kNeWCiju27IkigLQfM3hBnyqi2SD915RxBDVFlZkFrlbwkYU99BoLAv27LqH0z6FPS
         bFtg==
X-Forwarded-Encrypted: i=1; AJvYcCUAXChbb5P/x5zrg6qe7Fzag7uuYJLPrmfkHfN+FISRqWiY6tKDszVRzJHMhjMVBeOtV5rqon7AK7nsmasn5ulPflv4Y7y1NJNPIanp7ZW3LhzaAf51LxRPezzYZzk66bilU5CQi/YfIYG6OuGmS3sJhKEu7Y1YUPUwiw==
X-Gm-Message-State: AOJu0YyJaTJ5fjxAe656RU6SwuZ7Ou6uSrpCqqsoVdF8FZYkbw3aFAVn
	IiD+d+HCIwOxtDKxmp5MsVly+qIYQlgRoJpKcVv+uKDc+acJ6fx4xb65MVPjDkOhsH5+2C1dGpP
	L0JfEsi+Or2bV7eHq0arnLZ4OBl8=
X-Google-Smtp-Source: AGHT+IFoeL0ZvocmrGv43whyPh4WdDBovgyiR6rzdf6LIdVEfBJkv89u568WYmQekhY/GtCxdAuSJSZUaxZnt6i/1Cc=
X-Received: by 2002:a17:907:174d:b0:a6e:f8d6:f61d with SMTP id
 a640c23a62f3a-a6ef8d6f7e5mr399407866b.50.1718007701813; Mon, 10 Jun 2024
 01:21:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240607190955.15376-3-fgriffo@amazon.co.uk> <714268da-d199-4371-8360-500e7165119c@moroto.mountain>
In-Reply-To: <714268da-d199-4371-8360-500e7165119c@moroto.mountain>
From: Frederic Griffoul <griffoul@gmail.com>
Date: Mon, 10 Jun 2024 09:21:31 +0100
Message-ID: <CAF2vKzPWANE8DBcN8mvpk2fwRRL2kF0-VXP5EygY2tBGJgDjrA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] vfio/pci: add msi interrupt affinity support
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, Fred Griffoul <fgriffo@amazon.co.uk>, lkp@intel.com, 
	oe-kbuild-all@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Waiman Long <longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mark Brown <broonie@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Ye Bin <yebin10@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Pff. Thanks Dan,

I will post a v5 to address the two issues you mentioned.

Br,

Fred

On Sun, Jun 9, 2024 at 4:29=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro.=
org> wrote:
>
> Hi Fred,
>
> kernel test robot noticed the following build warnings:
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Fred-Griffoul/cgro=
up-cpuset-export-cpuset_cpus_allowed/20240608-031332
> base:   cbb325e77fbe62a06184175aa98c9eb98736c3e8
> patch link:    https://lore.kernel.org/r/20240607190955.15376-3-fgriffo%4=
0amazon.co.uk
> patch subject: [PATCH v4 2/2] vfio/pci: add msi interrupt affinity suppor=
t
> config: mips-randconfig-r081-20240609 (https://download.01.org/0day-ci/ar=
chive/20240609/202406092245.Hgx6MqK9-lkp@intel.com/config)
> compiler: mips-linux-gcc (GCC) 13.2.0
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202406092245.Hgx6MqK9-lkp@intel.com/
>
> New smatch warnings:
> drivers/vfio/pci/vfio_pci_core.c:1241 vfio_pci_ioctl_set_irqs() warn: may=
be return -EFAULT instead of the bytes remaining?
>
> vim +1241 drivers/vfio/pci/vfio_pci_core.c
>
> 2ecf3b58ed7bc5 drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-=
31  1190  static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *v=
dev,
> 663eab456e072b drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-=
31  1191                                  struct vfio_irq_set __user *arg)
> 2ecf3b58ed7bc5 drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-=
31  1192  {
> 2ecf3b58ed7bc5 drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-=
31  1193       unsigned long minsz =3D offsetofend(struct vfio_irq_set, cou=
nt);
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1194       struct vfio_irq_set hdr;
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1195       cpumask_var_t mask;
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1196       u8 *data =3D NULL;
> 05692d7005a364 drivers/vfio/pci/vfio_pci.c      Vlad Tsyrklevich 2016-10-=
12  1197       int max, ret =3D 0;
> ef198aaa169c61 drivers/vfio/pci/vfio_pci.c      Kirti Wankhede   2016-11-=
17  1198       size_t data_size =3D 0;
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1199
> 663eab456e072b drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-=
31  1200       if (copy_from_user(&hdr, arg, minsz))
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1201               return -EFAULT;
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1202
> 05692d7005a364 drivers/vfio/pci/vfio_pci.c      Vlad Tsyrklevich 2016-10-=
12  1203       max =3D vfio_pci_get_irq_count(vdev, hdr.index);
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1204
> ea3fc04d4fad2d drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-=
31  1205       ret =3D vfio_set_irqs_validate_and_prepare(&hdr, max, VFIO_P=
CI_NUM_IRQS,
> ea3fc04d4fad2d drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-=
31  1206                                                &data_size);
> ef198aaa169c61 drivers/vfio/pci/vfio_pci.c      Kirti Wankhede   2016-11-=
17  1207       if (ret)
> ef198aaa169c61 drivers/vfio/pci/vfio_pci.c      Kirti Wankhede   2016-11-=
17  1208               return ret;
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1209
> ef198aaa169c61 drivers/vfio/pci/vfio_pci.c      Kirti Wankhede   2016-11-=
17  1210       if (data_size) {
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1211               if (hdr.flags & VFIO_IRQ_SET_DATA_AFFINITY) {
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1212                       if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1213                               return -ENOMEM;
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1214
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1215                       ret =3D copy_from_user(mask, &arg->data, dat=
a_size);
>
> copy_from_user() returns the number of bytes remaining to be copied.
> This should be:
>
>         if (copy_from_user(mask, &arg->data, data_size)) {
>                 ret =3D -EFAULT;
>                 goto out;
>         }
>
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1216                       if (ret)
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1217                               goto out;
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1218
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1219                       data =3D (u8 *)mask;
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1220
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1221               } else {
> 663eab456e072b drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-=
31  1222                       data =3D memdup_user(&arg->data, data_size);
> 3a1f7041ddd59e drivers/vfio/pci/vfio_pci.c      Fengguang Wu     2012-12-=
07  1223                       if (IS_ERR(data))
> 3a1f7041ddd59e drivers/vfio/pci/vfio_pci.c      Fengguang Wu     2012-12-=
07  1224                               return PTR_ERR(data);
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1225               }
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1226       }
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1227
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1228       mutex_lock(&vdev->igate);
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1229
> ea3fc04d4fad2d drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-=
31  1230       ret =3D vfio_pci_set_irqs_ioctl(vdev, hdr.flags, hdr.index, =
hdr.start,
> ea3fc04d4fad2d drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-=
31  1231                                     hdr.count, data);
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1232
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1233       mutex_unlock(&vdev->igate);
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1234
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1235  out:
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1236       if (hdr.flags & VFIO_IRQ_SET_DATA_AFFINITY && data_size)
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1237               free_cpumask_var(mask);
> 66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-=
07  1238       else
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1239               kfree(data);
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31  1240
> 89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-=
31 @1241       return ret;
> 2ecf3b58ed7bc5 drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-=
31  1242  }
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>

