Return-Path: <kvm+bounces-44392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50CBDA9D84E
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 08:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8642116FD15
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 06:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4001C5F05;
	Sat, 26 Apr 2025 06:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="jAkEOhQm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828DF1C5D6A
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 06:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745648437; cv=none; b=ItnlNl7p/rckDQJTO8hfhIVdUwkQd4eFzHYRguydm68MAlaP5YXICvCIBqkzAAcsiKRxjgSQDooCYS5FksC3TQIfPOdGhc8FY/D6xqxK4Q40/JvftcNM8ODXvSM2e04e0v0LPUlwwBy0gy8USeCITGSiY3jz4G4hM4SfeF5M+Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745648437; c=relaxed/simple;
	bh=W1ZfHljnCTdH7jq9OpYdT8SmgIBDgFENZtGDRLGX9c8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BCDvMOKENlTb5AinhQoaKjJ1GSceoJpUFGtwjiWF0Ytn1/bYuKCXgQRF6it4RKjdHZr/evA6+ECectwdvKJ0LG/nvg9O3BvYP+Kt+jy8zP0gR0nxo8+LXEgYcU7hUFRFZXq9sOEzUCaqQCsKMd4c0r4oIGr3wHaIa2B+UdhfA2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=jAkEOhQm; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-54b0d638e86so3407962e87.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 23:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745648433; x=1746253233; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yhIlsDoQs6LRS20p0rNxcpX7bYzDaT/ai2nTquRWNJ4=;
        b=jAkEOhQmesjTWcBXBLUzAg6q/Djqogp9bKo5MY7i+sLH/gPz5kOiby9BQLgv36G4Az
         thOxMV/+ZsBXT+JB1MS93roif2apI/RdJ1TfPgU7Chdz1XqiXDD3Xj3gDMOfgpESbSjs
         iUPv5Y1YiLAwJwN8A/bNSuN7bRfywb5xg1JnXn67oNoIYGTsu7PHh9A0/yP5P1FkmbMy
         AcRQ82yPcutZ+D5VsWAn4dymVF32fhVLh3bUEHueiJyV4S8jORLJXePHIFDac2xR8y5w
         WbwYV+ydkUNXAmpgKNtMeIXvnfRVCRa0+PhKYLGx0OQPKrAfecK3o6dpRp2U2K89SMmI
         nBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745648433; x=1746253233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yhIlsDoQs6LRS20p0rNxcpX7bYzDaT/ai2nTquRWNJ4=;
        b=dXKIthBCIkLINC/bFJULOEFhNl2gCN7SxXag8o13Yg8WVHEpYEYGFuJm7ezQyVkDhT
         Wk6PI5x2XyPRB3errfJC5pIs1NX2ru4d/Xbreg7dafxZq4TV7LIk1ZHvk9rPT10TaTfe
         Twt7TfDW671JIw05n33LTb/jAmVukqNrJu44q1EBiqp+yXGApr05ha1Yd9ifXpPOkVot
         YCAE2WGz9ceFD4ps5JKWCpOV4MgJ6QkulkmLU7oTRYnEJtK8yamvdaKWC74ujWP/C4B7
         PIUVhyi0jmDSfImrltM/TywmmFIBcRjvdRZWDC+ADaH6ye6I4fsoGDjjSEM8VGOdkjRX
         LHtw==
X-Forwarded-Encrypted: i=1; AJvYcCXzN9FsQFKjb8haMvu4lVREO4btjUg56kHofMNPAQ7tR5BQlLC5P315c/QPAi6f/sTEMEY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw8QP1puJACKMmQ3K+yfMggNrMoDCogF8Z8S849UoFekZhHEm5
	FF6OE7gaEHWMB2os0reV+piKG2AJiNfjCiDJBh2H5CblkVm/LZFfZF9GGw5vN1n0ss8KXY2cm5/
	aP9ktAjEF19jAuXqx3Cqd+ZqcbphhBuiyMuh7BfiiSw9Y+KUsVKt+OYmr
X-Gm-Gg: ASbGnctx8kGnf/nfKmxPsuGrtLthbqBCTFt9dnNQxbL5BUyKB89/iKufE2wukti8Eqx
	D1VPKxUPSbZ89hf7liZGHg9wLi2DzZBjfxTyR9qkeaObeWhz4QccR6SPLf+fnEeUXu+Oo2AmxCA
	c1mTu70q30M8qO70Hgg4Fd9Fs=
X-Google-Smtp-Source: AGHT+IHJX8kShg4vw42ljFxBtrSxnj4CRMgyhaOeQRBqP8s/W/qCbdQyZl/wjbUn9VK8/6qB/enzbHcVFG8hmTC2xR8=
X-Received: by 2002:a05:6512:1245:b0:545:6fa:bf60 with SMTP id
 2adb3069b0e04-54e8ffd16aemr400439e87.19.1745648433251; Fri, 25 Apr 2025
 23:20:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250424153159.289441-1-apatel@ventanamicro.com>
 <20250424153159.289441-11-apatel@ventanamicro.com> <20250425-c0a3a93239d39b73ff176697@orel>
In-Reply-To: <20250425-c0a3a93239d39b73ff176697@orel>
From: Anup Patel <apatel@ventanamicro.com>
Date: Sat, 26 Apr 2025 11:50:20 +0530
X-Gm-Features: ATxdqUG3_pY0cK5X4HGASNC9Rzb6yplJE52I4EQ3dAO9a3v1qh0QWLhZugC-APQ
Message-ID: <CAK9=C2X8ZfzACU1LB8BqSZb3nf8P3xvfAQeNznHPagUhDUnd-g@mail.gmail.com>
Subject: Re: [kvmtool PATCH v2 10/10] riscv: Allow including extensions in the
 min CPU type using command-line
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2025 at 6:13=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Thu, Apr 24, 2025 at 09:01:59PM +0530, Anup Patel wrote:
> > It is useful to allow including extensions in the min CPU type on need
> > basis via command-line. To achieve this, parse extension names as comma
> > separated values appended to the "min" CPU type using command-line.
> >
> > For example, to include Sstc and Ssaia in the min CPU type use
> > "--cpu-type min,sstc,ssaia" command-line option.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  riscv/fdt.c | 43 ++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 40 insertions(+), 3 deletions(-)
> >
> > diff --git a/riscv/fdt.c b/riscv/fdt.c
> > index 5d9b9bf..722493a 100644
> > --- a/riscv/fdt.c
> > +++ b/riscv/fdt.c
> > @@ -108,6 +108,20 @@ static bool __isa_ext_warn_disable_failure(struct =
kvm *kvm, struct isa_ext_info
> >       return true;
> >  }
> >
> > +static void __min_enable(const char *ext, size_t ext_len)
> > +{
> > +     struct isa_ext_info *info;
> > +     unsigned long i;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(isa_info_arr); i++) {
> > +             info =3D &isa_info_arr[i];
> > +             if (strlen(info->name) !=3D ext_len)
> > +                     continue;
> > +             if (!strncmp(ext, info->name, ext_len))
>
> Just strcmp since we already checked the length and wouldn't want
> something like info->name =3D mmmmnnnn to match ext =3D mmmm anyway.

(Like mentioned in my comment in the past revision ...)

The "ext" is not simply an extension name rather something
like "mmmm,xyz,abc" (suffix of comma separated string) so
a plain strcmp() will fail even if extension length is already
checked.

>
> > +                     info->min_enabled =3D true;
> > +     }
> > +}
> > +
> >  bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_=
ext_id)
> >  {
> >       struct isa_ext_info *info =3D NULL;
> > @@ -128,15 +142,38 @@ bool riscv__isa_extension_disabled(struct kvm *kv=
m, unsigned long isa_ext_id)
> >  int riscv__cpu_type_parser(const struct option *opt, const char *arg, =
int unset)
> >  {
> >       struct kvm *kvm =3D opt->ptr;
> > +     const char *str, *nstr;
> > +     int len;
> >
> > -     if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || strlen(=
arg) !=3D 3)
> > +     if ((strncmp(arg, "min", 3) || strlen(arg) < 3) &&
>
> The strlen(arg) < 3 will never be true because if strncmp(arg, "min", 3)
> returns 0 (false), then that means arg starts with 'min', and therefore
> can't have a length less than 3. And, if strncmp(arg, "min", 3) returns
> nonzero, then the '|| expression' will be short-circuited.
>
> > +         (strncmp(arg, "max", 3) || strlen(arg) !=3D 3))
>
> So
>
>  if (strncmp(arg, "min", 3) && (strncmp(arg, "max", 3) || strlen(arg) !=
=3D 3))
>
> should do it.

Okay, I will update.

>
> >               die("Invalid CPU type %s\n", arg);
> >
> > -     if (!strcmp(arg, "max"))
> > +     if (!strcmp(arg, "max")) {
> >               kvm->cfg.arch.cpu_type =3D RISCV__CPU_TYPE_MAX;
> > -     else
> > +     } else {
> >               kvm->cfg.arch.cpu_type =3D RISCV__CPU_TYPE_MIN;
> >
> > +             str =3D arg;
> > +             str +=3D 3;
> > +             while (*str) {
> > +                     if (*str =3D=3D ',') {
> > +                             str++;
> > +                             continue;
> > +                     }
> > +
> > +                     nstr =3D strchr(str, ',');
> > +                     if (!nstr)
> > +                             nstr =3D str + strlen(str);
> > +
> > +                     len =3D nstr - str;
> > +                     if (len) {
> > +                             __min_enable(str, len);
> > +                             str +=3D len;
> > +                     }
> > +             }
> > +     }
> > +
> >       return 0;
> >  }
> >
> > --
> > 2.43.0
> >
>
> Otherwise,
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Regards,
Anup

