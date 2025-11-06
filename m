Return-Path: <kvm+bounces-62221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F2FC3C6D4
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:31:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 91CA63523B5
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA161350D64;
	Thu,  6 Nov 2025 16:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eucMkQVr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7793350D4E
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 16:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762446402; cv=none; b=s/DE9G6C0iAXbJDsy4gSVJI1SSUB9NtjakiRlDcEMIkVnHeb+19zHcNVtVOUu6lmaA8/nnVoG7riQ0QHj0HE+hNODa/I3smpHDuZ98PCMQyO7kjgQO39vjLwuPwKyadOgUeD/5dEA0bsvtkEpKrKRrGkQ0wMy9HnkK9tyeen7qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762446402; c=relaxed/simple;
	bh=bII4r8AGGbtwvg7qCc/ztiXsM56g22qYrv0PaOQwk3M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ipF/DsHGl2gAO2bCukmferL64+iggyHP9gy1DgAQb0HZ+cEYSG/tO6WSRngIgMSp99byoRK+cQzrggUoPNzx9hxmZrbjK62HEIJhXtPWwxHmkQANUqv0ezZ3YSC6zf8/sskSoZb5vtyRYinsvrqiUpCCD0CewgwFnyjRI2oR7gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eucMkQVr; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ed0c8e4dbcso348741cf.0
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 08:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762446399; x=1763051199; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0q6PCg+W2iuobOkSwULGRQ7ElBYC+BvlMlpyq3y6HfY=;
        b=eucMkQVr/LoRjavSTXaGJnV9X1nlt64P1YHOXDP3xnmV9NlcVznX+TNV3rldGBnwd6
         q92mcUls6s0mFnDcNT43p/SQ5z/vnrvxpcJbaIb7bYm6axPNptpiNAsF294/Oi71Efy9
         tQ4U0bFgjodHlwSL6BTA+72lIH3TZwGLEMxuxFNuzMgzYvpG+4NkTG8Uq8V1ADA+dxoi
         jfLDQV8o0CuJu1aBJ2h1LVWN8npPHsQF3BeIKXLBVQUJ4dWDiPjQ6IsEijP09p75DDqR
         ksfq4akkSk1243KycbmZK+FGIapUj+BCu90NbhlXSsnOY+As60ZXO20d1FzlwlUNVb/1
         66eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762446399; x=1763051199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0q6PCg+W2iuobOkSwULGRQ7ElBYC+BvlMlpyq3y6HfY=;
        b=a4VQva7BSvTOGyj3K9+iKlnlouGLjt2sLV79S0ikVV1PTle175FTx24gSLgdguEYXG
         4mA2OKtBBk08h8TdKZ/U1UACewMvqAWWgDfRgVP5shasCZU+vTzFwbX/T39fEdfhVB9P
         HgrTVfCxO9Cjyql3FZmECUMsBd3oR03fZvd79n/Oa3D7pHaFX+22sDVyPl+MqVWNGbhf
         hKihyu/UbXoV0CuH7/Hrt5FXzbF1gf2TaSx2QosGQPJpm4kPMXoj507IZ126noaqqj/W
         fiArGBHuRe9hbgtfJerloHefJV2N587zt/Fk/acY7OHLXnxr7cNwCfjVzWUtZ0hvs7It
         FzDw==
X-Forwarded-Encrypted: i=1; AJvYcCVL0dMn2ztq0Xz9besWB9fUghEUdiPhaVS6hAPCVjAxxksbKOx69LsROIV8CNZucnKt6Mk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB7ZVYltYFxMaQYGXKxqaUbjBrk8EWwnPv/XnLgAKrmyxvUulr
	G7CF6Xy0FP09tModsy2zpuIkhklwYHMAUVecPsScIHLZTf/HRdLJ0pfMjh9FK3PbLqX3BwoC+fU
	oMXf5hiIfL2ZaOBt2TdEJAx9FQxRkrI3QKMvFHQMk
X-Gm-Gg: ASbGnctF2UOMdMz2f0L/LQX02FwjC1JjQK9/45IBicjvJwOciXmbXK/PLN/j/zOiH0O
	AIO3fkdwNgQP54jefuCxk506vd+65wfNBtv6hRUM59Lg9s8Y0QmI7YLGFvuGvqwXNzcEkKLbFlm
	gW2eka4CUuR3efaeCbZvHR55rkLCPwnwcEHI0qoq2oAFIRResxr/rU34a7BFfDudTwvEV2u3gUg
	JUzy2a81lvGAlZTRmKYaOlhqqLKxk/RQqGnWGVGsxXIzpP5zRcncna8kgxVc9mmFAC9QTg=
X-Google-Smtp-Source: AGHT+IEKYGFOAEb95xBi/hAEe+N1Hr05URWSKgSTmNRkE1Cu0Q0CJW4cKhxufqO7fCfEUMLYoCaSMX1Vw6m5LGNYwi0=
X-Received: by 2002:a05:622a:1492:b0:4b3:8ee:521b with SMTP id
 d75a77b69052e-4ed81344ea3mr7773141cf.0.1762446399475; Thu, 06 Nov 2025
 08:26:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104003536.3601931-1-rananta@google.com> <20251104003536.3601931-2-rananta@google.com>
 <aQvjQDwU3f0crccT@google.com>
In-Reply-To: <aQvjQDwU3f0crccT@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 6 Nov 2025 21:56:27 +0530
X-Gm-Features: AWmQ_bki584d0M1XeO0TkydTENfBebX0YdN8fphcl6VQqXlJAWt2avEb5ReAohQ
Message-ID: <CAJHc60xb_=v9k46MEo=6S5QmMXKnd_1FiuWQr9dkCnE_XtTkfQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] vfio: selftests: Add support for passing vf_token in
 device init
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

On Thu, Nov 6, 2025 at 5:22=E2=80=AFAM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
>
> > -struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const ch=
ar *iommu_mode);
> > +struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
> > +                                           const char *iommu_mode,
> > +                                           const char *vf_token);
>
> Vipin is also looking at adding an optional parameter to
> vfio_pci_device_init():
> https://lore.kernel.org/kvm/20251018000713.677779-20-vipinsh@google.com/
>
> I am wondering if we should support an options struct for such
> parameters. e.g. something like this
>
> diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools=
/testing/selftests/vfio/lib/include/vfio_util.h
> index b01068d98fda..cee837fe561c 100644
> --- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
> +++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
> @@ -160,6 +160,10 @@ struct vfio_pci_driver {
>         int msi;
>  };
>
> +struct vfio_pci_device_options {
> +       const char *vf_token;
> +};
> +
>  struct vfio_pci_device {
>         int fd;
>
> @@ -202,9 +206,18 @@ const char *vfio_pci_get_cdev_path(const char *bdf);
>
>  extern const char *default_iommu_mode;
>
> -struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
> -                                             const char *iommu_mode,
> -                                             const char *vf_token);
> +struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
> +                                              const char *iommu_mode,
> +                                              const struct vfio_pci_devi=
ce_options *options);
> +
> +static inline struct vfio_pci_device *vfio_pci_device_init(const char *b=
df,
> +                                                          const char *io=
mmu_mode)
> +{
> +       static const struct vfio_pci_device_options default_options =3D {=
};
> +
> +       return __vfio_pci_device_init(bdf, iommu_mode, &default_options);
> +}
> +
>
> This will avoid you having to update every test.
>
> You can create a helper function in vfio_pci_sriov_uapi_test.c to call
> __vfio_pci_device_init() and abstract away the options stuff from your
> test.
>
I like the idea of an optional expandable struct. I'll implement this in v2=
.

> > -static void vfio_pci_container_setup(struct vfio_pci_device *device, c=
onst char *bdf)
> > +static void vfio_pci_container_get_device_fd(struct vfio_pci_device *d=
evice,
>
> Let's name this vfio_pci_group_get_device_fd() since it's getting the
> device FD from the group using ioctl(VFIO_GROUP_GET_DEVICE_FD).
>
> > +                                           const char *bdf,
> > +                                           const char *vf_token)
>
> There's an extra space before these arguments. Align them all vertically
> with the first argument.
>
> I noticed this throughout this patch, so please fix throughout the whole
> series in v2.
>
I may have to fix my editor to display this right. Thanks for catching this=
.

> Also please run checkpatch.pl. It will catch things like this for you.
>
>   CHECK:PARENTHESIS_ALIGNMENT: Alignment should match open parenthesis
>   #78: FILE: tools/testing/selftests/vfio/lib/vfio_pci_device.c:335:
>   +static void vfio_pci_container_get_device_fd(struct vfio_pci_device *d=
evice,
>   +                                             const char *bdf,
>
> > +{
> > +     char *arg =3D (char *) bdf;
>
> No space necessary after a cast. This is another one checkpatch.pl will
> catch for you.
>
>   CHECK:SPACING: No space is necessary after a cast
>   #81: FILE: tools/testing/selftests/vfio/lib/vfio_pci_device.c:338:
>   +       char *arg =3D (char *) bdf;
>
Actually, I did run checkpatch.pl on the entire series as:
.$ ./scripts/checkpatch.pl *.patch

I didn't see any of these warnings. Are there any other options to consider=
?

> > +
> > +     /*
> > +      * If a vf_token exists, argument to VFIO_GROUP_GET_DEVICE_FD
> > +      * will be in the form of the following example:
> > +      * "0000:04:10.0 vf_token=3Dbd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
> > +      */
> > +     if (vf_token) {
> > +             size_t sz =3D strlen(bdf) + strlen(" "VF_TOKEN_ARG) +
> > +                         strlen(vf_token) + 1;
> > +
> > +             arg =3D calloc(1, sz);
> > +             VFIO_ASSERT_NOT_NULL(arg);
> > +
> > +             snprintf(arg, sz, "%s %s%s", bdf, VF_TOKEN_ARG, vf_token)=
;
> > +     }
>
> UUIDs are 16 bytes so I think we could create a pretty reasonably fixed
> size array to hold the argument and simplify this code, make it more
> self-documenting, and eliminate VF_TOKEN_ARG. This is test code, so we
> can make the array bigger in the future if we need to.  Keeping the code
> simple is more important IMO.
>
> static void vfio_pci_container_get_device_fd(struct vfio_pci_device *devi=
ce,
>                                              const char *bdf,
>                                              const char *vf_token)
> {
>         char arg[64];
>
>         if (vf_token)
>                 snprintf(arg, ARRAY_SIZE(arg), "%s vf_token=3D%s", bdf, v=
f_token);
>         else
>                 snprintf(arg, ARRAY_SIZE(arg), "%s", bdf);
>
>         device->fd =3D ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, =
arg);
>         VFIO_ASSERT_GE(device->fd, 0);
> }
>
Yeah, this is a good idea! I'll implement it in v2.

> And to protect against writing off the end of arg, we can introduce a
> snprintf_assert() in a separate commit. There are actually a few
> snprintf() calls in vfio_pci_device.c that would be nice to convert to
> snprintf_assert().
>
> #define snprintf_assert(_s, _size, _fmt, ...) do {                      \
>         int __ret =3D snprintf(_s, _size, _fmt, ##__VA_ARGS__);          =
 \
>         VFIO_ASSERT_LT(__ret, _size);                                   \
> } while (0)
>
> snprintf_assert() could be added in a precursor commit to this one.
>
Sounds good. I'll add a commit for this and convert all the
snprintf()s to snprintf_assert()s.

> > +static void vfio_device_bind_iommufd(int device_fd, int iommufd, const=
 char *vf_token)
> >  {
> >       struct vfio_device_bind_iommufd args =3D {
> >               .argsz =3D sizeof(args),
> >               .iommufd =3D iommufd,
> >       };
> > +     uuid_t token_uuid =3D {0};
> > +
> > +     if (vf_token) {
> > +             VFIO_ASSERT_EQ(uuid_parse(vf_token, token_uuid), 0);
> > +             args.flags =3D VFIO_DEVICE_BIND_FLAG_TOKEN;
>
> Maybe make this |=3D instead of =3D ? I had to double-check that this was=
n't
> overwriting any flags set above this. Obviously it's not since this is a
> small function, but |=3D would make that super obvious.
Oh yes, absolutely!

Thank you.
Raghavendra

