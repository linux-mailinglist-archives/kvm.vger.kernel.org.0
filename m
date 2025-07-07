Return-Path: <kvm+bounces-51688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B9BAFBA10
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 19:43:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E45063B7724
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 17:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13112DBF6E;
	Mon,  7 Jul 2025 17:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NCg9wNQY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173EC18A6DF
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 17:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751910228; cv=none; b=Qoho5W3psWZykS4IBhTZJZTXx0Ox/Dz3N7IA4n1+VumBeHB4Xvoi1ueKINxNWxboQY20V/lYwdBEWsB9mPdAmj/TOj14vFLSzX74B2OICuQrC1d/WwtOSZuT+/ZRGFm4nRz6qMsMfWopy6rYq1e6v1jz2oDI9T22CfaqQI1YqjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751910228; c=relaxed/simple;
	bh=6WL7P90l1zk4qe9y23uE7CFZJnUvHQ8dtMU17K5oHZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oIi2U+7H0YlRqezJizAMzlPX92izWnqfT3cBkyTClq39XxAE/IQCsY+hRKyUbUmY6PwPc9IcCrhdWJ6e9ADGu8AtEYOfLXiUSyCutF16kt2YBn9Wxg8DZZd8X/zYqYSG1I7FqMK2TPAXrG/L75WA25REfbTLcOuK1VU5TXMf1ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NCg9wNQY; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-32b7f41d3e6so41543711fa.1
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 10:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751910225; x=1752515025; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNTmsp6IOfSThnweAThs4GZywF+oxXMKH6rk4VRTRPw=;
        b=NCg9wNQYZVqjmHnqOXb1v7qp/7fqWknKJL/QRyZYovKQs/myMc4j2AUajQMrS+dP4D
         udSkhVsxUcL0ncRsQcQoUD7oxCxp4Dzj4HsCY4ie58pzH5ogyNozQbJI+P2a6zB2MMTr
         4oifuwvOvaRWJ+HPHuCPmSaX3tqn1rHvwngLP5e6vV7DsYZOtmz3UarXX8mnm2GHfXdT
         073OZK/ICwou+8FOCfyTxIT2AEkS8iViU9HmDTOaiu5IdAQK/O2Z2FazAiZZ+49vMxez
         u36b89EPWyC21KY4U5OS/o2d/wS5fIKtbzwEuDXmqG18AlurdQ0qq9sI8Zx3ifYs7uYo
         fk1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751910225; x=1752515025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNTmsp6IOfSThnweAThs4GZywF+oxXMKH6rk4VRTRPw=;
        b=g+42iaGsFIhpRJYmNDM+jheE511kFrZ96YSKKsCoKLZuTcKfKDX0IWtAbP6m8NXS0m
         y435MOhR8d4xaSlz4+lfrQaTUL00RdfunWQExMpKGjxMCYV45bg2xi+o6l1d7mDKj2CI
         XqX3rRTUa39ebhtHS6VcIrDyoids+EFunlakMwFoU4F6l8NoZ67qRNuIb1BHiaIrMpCq
         UccCsKJF9buNs4BGlt0XK1yM4dP0dMum9Y25Zp6bgoyypFYCLNfWlvN98DrHLN/4tj6D
         M6dq04ib5RLoCu2i0T312Uyaj3pdjDzDv/XY6sQ5oy0qk0wA9g3vWnM6QaUdQsn5AMgL
         tQxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWus98mRxCSHykdgmUsBLkkSeUFigazTiivLlOLbkn9IFSY/7lz49IKQZ9EslyMYO+yjaw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5JeGdPN3lsJr9mja8jv9qap5WLdSHu7LXz41e4c/TsAZkx0QI
	/8pQAdhEwRyAY8sCw2BYu5M4DeFA4fLlEOwkkDqZd9DDKZ1OzdNQOhdQIXHCJcVM4qkXftcYZa6
	5Gmq39GX8ajiOdzGsfgKqg4LhmZ2QFm/YEGwrsa3N
X-Gm-Gg: ASbGncuFx5gNbHjPznX+PxX7yJTjSvhloFIOfvvpKz9CYhCeDZl+55gkuYE1RQxPXoy
	WLEDeGS9X+ZhKSc49HJDjS4375iI+/widCzxya3JqI33IvHq/ClZ+LF21JMGOaFlBZgb4aEbC8N
	0Khaf3TxUu2P2xyJcF5Xq15dXgBvBAZHm0dWiipT6ZO/A=
X-Google-Smtp-Source: AGHT+IFxRUUAZ3Xaq5S5eJcrS9+Mh+VeOfWYh4AgvwBPepuUuEP/LquhHfhcsDZhanLW79FGlVyFtLGTYE+GzJGoEUQ=
X-Received: by 2002:a2e:84cd:0:b0:30d:c4c3:eafa with SMTP id
 38308e7fff4ca-32f37eaca8amr1108661fa.7.1751910224859; Mon, 07 Jul 2025
 10:43:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com> <20250523233018.1702151-18-dmatlack@google.com>
 <97cb1442-97f6-4ec3-a11f-17469355a937@amd.com>
In-Reply-To: <97cb1442-97f6-4ec3-a11f-17469355a937@amd.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 7 Jul 2025 10:43:17 -0700
X-Gm-Features: Ac12FXxCEPEo11jkTQ83GJB2ghGPApHXMozxc4-Zv8TsmCBpYJBiejbyDudmz-4
Message-ID: <CALzav=f1=TvT8cS++x06mtxvrNRJWpKLdKvQ75iHVM673s2ubg@mail.gmail.com>
Subject: Re: [PATCH RFC 17/33] vfio: selftests: Enable asserting MSI eventfds
 not firing
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Vinod Koul <vkoul@kernel.org>, 
	Fenghua Yu <fenghua.yu@intel.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, Jiri Olsa <jolsa@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Takashi Iwai <tiwai@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, WangYuli <wangyuli@uniontech.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Eric Auger <eric.auger@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2025 at 5:24=E2=80=AFAM Sairaj Kodilkar <sarunkod@amd.com> =
wrote:
>
> On 5/24/2025 5:00 AM, David Matlack wrote:
> > Make it possible to assert that a given MSI eventfd did _not_ fire by
> > adding a helper to mark an eventfd non-blocking. Demonstrate this in
> > vfio_pci_device_test by asserting the MSI eventfd did not fire before
> > vfio_pci_irq_trigger().
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >   tools/testing/selftests/vfio/lib/include/vfio_util.h | 12 +++++++++++=
+
> >   tools/testing/selftests/vfio/vfio_pci_device_test.c  | 10 +++++++++-
> >   2 files changed, 21 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/too=
ls/testing/selftests/vfio/lib/include/vfio_util.h
> > index ab96a6628f0e..2b96be07f182 100644
> > --- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
> > +++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
> > @@ -2,6 +2,7 @@
> >   #ifndef SELFTESTS_VFIO_LIB_INCLUDE_VFIO_UTIL_H
> >   #define SELFTESTS_VFIO_LIB_INCLUDE_VFIO_UTIL_H
> >
> > +#include <fcntl.h>
> >   #include <string.h>
> >   #include <linux/vfio.h>
> >   #include <linux/list.h>
> > @@ -116,6 +117,17 @@ void vfio_pci_irq_enable(struct vfio_pci_device *d=
evice, u32 index,
> >   void vfio_pci_irq_disable(struct vfio_pci_device *device, u32 index);
> >   void vfio_pci_irq_trigger(struct vfio_pci_device *device, u32 index, =
u32 vector);
> >
> > +static inline void fcntl_set_nonblock(int fd)
> > +{
> > +     int r;
> > +
> > +     r =3D fcntl(fd, F_GETFL, 0);
>
> fcntl F_GETFL does not expect argument

Good point, this could simply be:

  r =3D fcntl(fd, F_GETFL);

>
> > +     VFIO_ASSERT_NE(r, -1, "F_GETFL failed for fd %d\n", fd);
>
> May be print errno as well  ?

All of the VFIO_ASSERT*() macros print errno by default [1], since
it's relevant often enough.

The idea to print errno by default came from the KVM selftests [2]. In
a future series I'd like to find a way to share the assert code
between the KVM and VFIO selftests since there's a lot of overlap and
the KVM selftests also support useful things like backtraces on
assertion failures that I'd love to have in VFIO selftests.

[1] https://github.com/dmatlack/linux/blob/44c8e1e805698286e43cf2a471f540ee=
e75e94a1/tools/testing/selftests/vfio/lib/include/vfio_util.h#L30
[2] https://github.com/dmatlack/linux/blob/44c8e1e805698286e43cf2a471f540ee=
e75e94a1/tools/testing/selftests/kvm/lib/assert.c#L79

