Return-Path: <kvm+bounces-67479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E1FC2D065B8
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 22:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D47B73035063
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 21:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1BFD33D511;
	Thu,  8 Jan 2026 21:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C7Vfvk2b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274F533D4F7
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 21:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767908773; cv=pass; b=QJO9oEuAk0KZ7ZW5uPYbTq4YKlFQc6nT/qpEzAlRo/lK51lv/pk2O7+sX58NcrdXOKR2LjOOkxoYBFB49RmYdkDePKPhUZyLlgWJv6u9EF8MTuasePxjsnlPsOAKziZjs3t0MSKu6vAyfOASmyQSfuqyql2Bvzx+lJRObagjsX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767908773; c=relaxed/simple;
	bh=XMbP7ThfxIPtBFJFxREhOX5JfOHbKHNF/yi2dpLBj2o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QHy7nJ0d3igBVczvHnsq+SoYpxomvj9jMIbRNm7+6vFVzmmVwIhrIIhQdEHzQ3gJ+6wLDp52UJYE0dCY1lHbdmnEUJ5K9vaPPIjod3RgZx6notHQyh71Nf7QmzpT1t9DuiNryppYOS5eRyseSU45+NU3YI2BvApaikZoHSGUWhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C7Vfvk2b; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ee147baf7bso51531cf.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 13:46:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767908771; cv=none;
        d=google.com; s=arc-20240605;
        b=Lly8ltpXvczNlWbuTR7/TPe4voZMpy1Jr8zKwByMwXe2nlfBQIromAGSTeTHWNVV/V
         50+Q71oqXaQAzh50pNnnoj5PnUhC1uPPmimGU8tSa76pkFnExerQyTwqTYyYBguy/bHD
         nUC6R7NgFYKx0DI0Dc6ht9NbL7ZRaHRMSSY3w0vEHruWj9n3j6A2XiKlaZs7NwpT4fJu
         hIAiB6Ov1ndrS0TAdWArAxDVg8VX6k8atYoWE/QdcQFFqt8Pgq03EsPHgkyeLXSUuQlJ
         J1MbzLl9DFqXTPYjRraeWCUml6WfHjtQNd3PJOa6j5IeIj0mP/l4Qqm4yQ1ar9CdWVdo
         +yKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HHZ1rZPdnJnzeo4n3gCGmREH/i3FIP/5sZxCeZBEwJ0=;
        fh=4Sj4URYQ+GPHIgmdV1Ji/sUjEsMQSGRruDB7mdglh0c=;
        b=QScvo73NLBPeOmPnFlPqlpZ4Mo5C4WyBuXNY7SduI8/67MiuVIIsKbMmIUdQ6QRAji
         FtsiETfjehhCKMver6ESHt9DKKRmD23c51bg2waPZKE6UJ1Dc7ZItiIAJTLeMPj2me9C
         g+/2pc0mm8pao2YNEFYy5AtOWXnEgxlLxvJqlrAhLmSD24Ma+82RsGFoFqlEK0hzhW/j
         l0qm1ZB0vI3Li3jznPoxmYDA4qPq2SNBnz6N69vYSjOjvOCCGHpUV0C9PSCNxaByWlIM
         IIoFvNf2uvZwUKdhL9+3jHU4NF2sFjh8e9QwzOP6XhyKwqO0D1EaFrs3EdX6Ac/GGM+g
         6QCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767908771; x=1768513571; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HHZ1rZPdnJnzeo4n3gCGmREH/i3FIP/5sZxCeZBEwJ0=;
        b=C7Vfvk2bZ/ZIVw5DGkcaxx2u0kdKBBuA4Eza9GW47uSKNhHW6VXrGxDfWivxeY7eDt
         Lc1YYMbXdtDUTN4iTtfBddN5pTPed/PXkkN5Piof0x+fx9fCDYPXcp5iPN7kO9Tgmu6w
         T4RYOl7vaK0iiEHXBsPIvtZ7NR0v4Nog7gVIS/37ajNZrgmjfn9YPy1V7nTTl3vk4kIh
         3H1SDyHSVPZZ/6b4Ec9uZip+S0UPF+lHWUiAmaUH17lpWKskOoWPD5IpkFhGH97Urt2s
         8Z5NEf64gdSqzJZaxtP3IaILz5h+1hA+CXc8OUmCGuFHa//+tHvZeCrWIlgzFGc130bl
         htzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767908771; x=1768513571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HHZ1rZPdnJnzeo4n3gCGmREH/i3FIP/5sZxCeZBEwJ0=;
        b=Sbr+/77yAH+Y+hCcZAYiqs6542k1PGa8NLohEkJFwmY01N2rwdsOBZRvxTo0UqKYcp
         d8t+JuvtEMO0vidj+mir/azqzu8lI0UmEO0Boc+LxM+iVIGdTcbrmEFD5QpjRUHEGVRK
         zroEXw0pE7CsolnNjS8kufob8F3GIUPiTQ8Owe20Uyht9UJ6DOR+hWRgymBc7QG+c92/
         Z2YbbqQ2qks35d/vHD6b67K1nhXasZ79mQgKI1dP3DoCqOKrMT+CHD9LRnKYJE8SIhv5
         JV8nZQCLt3Fv6pZy5JgA4+qSCUHvxnu8jvFuYv7YqDd2VtP3nIltLO/zIeyaAU1Kd0tp
         FJQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxLnGjEv8Zx+0XhCN0SYl3uITSiOQIYAenJlRHaco7ztlJ7xu4WsgeOug7jGsKwD5Td8w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIpiGQRNwtLtsy3G5yeypRvKZcRfp3sDxzgCrEubO7dJagtgVT
	eMRVhiT9/ZGl0l+kMCZ4u0jV3IRhzeSPT+eCwLof7YBZXX+IhfNx8GCtPHGqu512EavkAE4Q/tO
	XUechM8D2/Aag+DGbo/7+nkve/E4bEJ7lyk9sYjiNJX9h6YqMdafqzQ==
X-Gm-Gg: AY/fxX7w42L3JQXPSEO1QxiT1pmjnqi9Bp1nXRWueLt3m75wv4QO9gvh1JSkqv2mg0a
	+xpqGqUMvrCB9cBX0SCCGj0ZT2W0oaENPKEGBVTOnLfgv3dVUwki7YlreeK1g3UoqELb+WUNAsC
	AHRWPh7WSxVhEbX5Uc4ZiTaHB6j2SGTLdxvLhF8wjzZCfC0pO9DlktVuaZvhCQe8PI/HnwkwUuI
	sMXzVlpjP98ec2DxWCjT5yDplzs+rKIUdUhYWBrREkX/w9p+6UEaulSe3lfUWeTY2xasgHE32Zj
	lLdytdwlJP+OiMV5NhSaK4IVOg==
X-Received: by 2002:ac8:58cd:0:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-4ffca4db069mr3063011cf.0.1767908770487; Thu, 08 Jan 2026
 13:46:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com> <20251210181417.3677674-6-rananta@google.com>
 <aV7kq76DYIx8aNVv@google.com>
In-Reply-To: <aV7kq76DYIx8aNVv@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 8 Jan 2026 13:45:58 -0800
X-Gm-Features: AQt7F2o5q5yGWl2zlyt3oqOUguaBj546pG9SFwUL4f3_5xpSE1UjM8HRl2WzJJg
Message-ID: <CAJHc60xMgz=JuqTesqC9h0axFMQnLX-eYbGBi=DG2_gDbdTnoQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] vfio: selftests: Add helper to set/override a vf_token
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 2:56=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:
> > Add a helper function, vfio_device_set_vf_token(), to set or override a
> > vf_token. Not only at init, but a vf_token can also be set via the
> > VFIO_DEVICE_FEATURE ioctl, by setting the
> > VFIO_DEVICE_FEATURE_PCI_VF_TOKEN flag. Hence, add an API to utilize thi=
s
> > functionality from the test code. The subsequent commit will use this t=
o
> > test the functionality of this method to set the vf_token.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../lib/include/libvfio/vfio_pci_device.h     |  2 ++
> >  .../selftests/vfio/lib/vfio_pci_device.c      | 34 +++++++++++++++++++
> >  2 files changed, 36 insertions(+)
> >
> > diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_=
device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device=
.h
> > index 6186ca463ca6e..b370aa6a74d0b 100644
> > --- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.=
h
> > +++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.=
h
> > @@ -129,4 +129,6 @@ void vfio_container_set_iommu(struct vfio_pci_devic=
e *device);
> >  void vfio_pci_iommufd_cdev_open(struct vfio_pci_device *device, const =
char *bdf);
> >  int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char =
*vf_token);
> >
> > +void vfio_device_set_vf_token(int fd, const char *vf_token);
> > +
> >  #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DEVICE_H */
> > diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools=
/testing/selftests/vfio/lib/vfio_pci_device.c
> > index 208da2704d9e2..7725ecc62b024 100644
> > --- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> > +++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> > @@ -109,6 +109,40 @@ static void vfio_pci_irq_get(struct vfio_pci_devic=
e *device, u32 index,
> >       ioctl_assert(device->fd, VFIO_DEVICE_GET_IRQ_INFO, irq_info);
> >  }
> >
> > +static int vfio_device_feature_ioctl(int fd, u32 flags, void *data,
> > +                                  size_t data_size)
> > +{
> > +     u8 buffer[sizeof(struct vfio_device_feature) + data_size] =3D {};
> > +     struct vfio_device_feature *feature =3D (void *)buffer;
> > +
> > +     memcpy(feature->data, data, data_size);
> > +
> > +     feature->argsz =3D sizeof(buffer);
> > +     feature->flags =3D flags;
> > +
> > +     return ioctl(fd, VFIO_DEVICE_FEATURE, feature);
> > +}
> > +
> > +static void vfio_device_feature_set(int fd, u16 feature, void *data, s=
ize_t data_size)
> > +{
> > +     u32 flags =3D VFIO_DEVICE_FEATURE_SET | feature;
> > +     int ret;
> > +
> > +     ret =3D vfio_device_feature_ioctl(fd, flags, data, data_size);
> > +     VFIO_ASSERT_EQ(ret, 0, "Failed to set feature %u\n", feature);
> > +}
> > +
> > +void vfio_device_set_vf_token(int fd, const char *vf_token)
> > +{
> > +     uuid_t token_uuid =3D {0};
> > +
> > +     VFIO_ASSERT_NOT_NULL(vf_token, "vf_token is NULL");
> > +     VFIO_ASSERT_EQ(uuid_parse(vf_token, token_uuid), 0);
> > +
> > +     vfio_device_feature_set(fd, VFIO_DEVICE_FEATURE_PCI_VF_TOKEN,
> > +                             token_uuid, sizeof(uuid_t));
> > +}
>
> Would it be useful to have a variant that returns an int for negative
> testing?
>
I couldn't see any interesting cases where the ioctl could fail that
would warrant a negative test.
The 'incorrect vf token set' is validated later during device init.
I've implemented a negative test for this.

However, please let me know if you can think of anything.

Thank you.
Raghavendra

