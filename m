Return-Path: <kvm+bounces-23677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F64394CAF0
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 09:06:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EDEDEB21DA9
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 07:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9882816D4E1;
	Fri,  9 Aug 2024 07:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P4Bjql5Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27CF2905
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 07:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723187205; cv=none; b=gk5eDySdxplvGA6Vr97tJXFy5x3PacYK5Yi/ovGyibmpXBH+HSSWU/uV8g1VwM9ykb2NAvbEgqOyDRp+sDGtXUeTnwItMXNocNRl1pLeuVo2KffM+jLNr3U0KiOcFAdgZX/Y0lkxaqFVUohox+x034UFAsRjyLCP2pDJvjIIyEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723187205; c=relaxed/simple;
	bh=mTWT48DI98q5kicu3TbOU9OyomTTk26ny86o2OpuPL0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cUWkoZRtJLqvMX0C2wiPaCAPNyk7FrN2DoHw6Ou5HFb5mgAFzp3SLJAM3iaNbvXa2vhJlfxzCW8JlYafW3zKqtpFxnjwXh58t6oJQ1zDia9bAtXL3btUj7+5Fkpv4G7ADl/k3Fz7jzCZv8GspxBC/NI/0McpPxJ8JNHj95HU9JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P4Bjql5Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723187202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IWR5XSabljgIgY4FlRNT+4+pydzf/00CjDvJVldKvNA=;
	b=P4Bjql5Q4kc+57Dh4ZeHMJ8xZyfakSUWHLpyerUsrYUGIZgGOBvMDVG/LCnHUwRtPVxqDp
	BOwnM7UcxCHOmyy2hDDdnh068pmRWe6AXyYfPaV/vFLN+koN0XfhqaXLgBkp3inPV4as8k
	0xJKHguh1YG0IcYyFIQvRdI+cQoOj8g=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-NTxdzsYZNtisAk-YPK2B9A-1; Fri, 09 Aug 2024 03:06:41 -0400
X-MC-Unique: NTxdzsYZNtisAk-YPK2B9A-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a7aa5885be3so143403966b.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 00:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723187200; x=1723792000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IWR5XSabljgIgY4FlRNT+4+pydzf/00CjDvJVldKvNA=;
        b=euz1DzWqrZnL2MUMHDgHHgXsIH/9IcKF71PqbVNcjOKDHnlwHoprDugXwO7h4OOQI4
         WfZGQiq7qaymhE6gYPZQPFcQhBPBYJIA+WABLDbin4xjlMXRIUWHAjQfBN7s/i9Jw7oi
         kDEmomDoqMZ6nX3e5sOY5jxjGBnJxNcn8TDuZP+mFmVPP2ywtHRbNJ8RrXX+iKPgvNQ3
         LInv8HeBdAWm1uijH+dpghbo0uZvTqEPrkrNUIx3fxhNeyUPNIi6eJr5Rzxd3TJLlSwT
         UETRNCun+Z2wlCt2Pz1TaaKjttYV2LJysAXMtQLH7aZMrTw5ZshD1KfB5bakPZrCiTVK
         Q8AA==
X-Forwarded-Encrypted: i=1; AJvYcCXCYq/hlFii4MJTFU0G18Tn3IuK7ncXj8cPJjwMtdpvEL6jlrbeuarVoa6rbnmpxpN79aFMQdBIPH+s/O156q1JTBmC
X-Gm-Message-State: AOJu0Ywvp5+X/ZNeAvVoVabjBQJenfuuYAlE9WW8AhcnQKC5PlxgwNU+
	dWsSq8n8WnwkcSB5m4H/ljILLO5Fe7+Y/2MBObPGvX89SHVJad+2WLb/C0xxZpOf0AIZ6B6fAVk
	8nyKT78/jSlvau65SBLdZD2dD6nwwYzmFWCDe+luTG9LzfGpkaoNkec9kmnD+RvBioskCr2BW8T
	l7P4a4xYYSag57qFMjRLiLR5FNoBZsrup/p6g=
X-Received: by 2002:a17:907:e9f:b0:a77:eb34:3b53 with SMTP id a640c23a62f3a-a80aa54a106mr50345866b.8.1723187200223;
        Fri, 09 Aug 2024 00:06:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvS5lezVzvNSN1dUYNrZE/sRuTw78FPTUh9oAbkAfwMkDzSes8eZqi0QGbhpzCPpOLyg+cJ5EkUUX+pPGxdv4=
X-Received: by 2002:a17:907:e9f:b0:a77:eb34:3b53 with SMTP id
 a640c23a62f3a-a80aa54a106mr50344866b.8.1723187199733; Fri, 09 Aug 2024
 00:06:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809051054.1745641-1-anisinha@redhat.com> <20240809051054.1745641-2-anisinha@redhat.com>
 <ZrWziCQWgLogq+lV@intel.com>
In-Reply-To: <ZrWziCQWgLogq+lV@intel.com>
From: Ani Sinha <anisinha@redhat.com>
Date: Fri, 9 Aug 2024 12:36:28 +0530
Message-ID: <CAK3XEhPioDt8HsaZXSChPZG=xR7ahjZJbp3COG0K+JhcTftPkg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kvm: replace fprintf with error_report() in
 kvm_init() for error conditions
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org, kvm@vger.kernel.org, 
	qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 11:27=E2=80=AFAM Zhao Liu <zhao1.liu@intel.com> wrot=
e:
>
> On Fri, Aug 09, 2024 at 10:40:53AM +0530, Ani Sinha wrote:
> > Date: Fri,  9 Aug 2024 10:40:53 +0530
> > From: Ani Sinha <anisinha@redhat.com>
> > Subject: [PATCH v2 1/2] kvm: replace fprintf with error_report() in
> >  kvm_init() for error conditions
> > X-Mailer: git-send-email 2.45.2
> >
> > error_report() is more appropriate for error situations. Replace fprint=
f with
> > error_report. Cosmetic. No functional change.
> >
> > CC: qemu-trivial@nongnu.org
> > CC: zhao1.liu@intel.com
> > Signed-off-by: Ani Sinha <anisinha@redhat.com>
> > ---
> >  accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
> >  1 file changed, 18 insertions(+), 22 deletions(-)
> >
> > changelog:
> > v2: fix a bug.
>
> Generally good to me. Only some nits below, otherwise,
>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
>
> >  #ifdef TARGET_S390X
> >          if (ret =3D=3D -EINVAL) {
> > -            fprintf(stderr,
> > -                    "Host kernel setup problem detected. Please verify=
:\n");
> > -            fprintf(stderr, "- for kernels supporting the switch_amode=
 or"
> > -                    " user_mode parameters, whether\n");
> > -            fprintf(stderr,
> > -                    "  user space is running in primary address space\=
n");
> > -            fprintf(stderr,
> > -                    "- for kernels supporting the vm.allocate_pgste sy=
sctl, "
> > -                    "whether it is enabled\n");
> > +            error_report("Host kernel setup problem detected. Please v=
erify:");
>
> The doc of error_report() said it doesn't want multiple sentences or trai=
ling
> punctuation:
>
> "The resulting message should be a single phrase, with no newline or trai=
ling
> punctuation."
>
> So I think these extra messages (with complex formatting & content) are
> better printed with error_printf() as I suggested in [1].
>
> [1]: https://lore.kernel.org/qemu-devel/ZrWP0fWPNzeAvjja@intel.com/T/#m95=
3afd879eb6279fcdf03cda594c43f1829bdffe
>
> > +            error_report("- for kernels supporting the switch_amode or=
"
> > +                        " user_mode parameters, whether");
> > +            error_report("  user space is running in primary address s=
pace");
> > +            error_report("- for kernels supporting the vm.allocate_pgs=
te "
> > +                        "sysctl, whether it is enabled");
> >          }
> >  #elif defined(TARGET_PPC)
> >          if (ret =3D=3D -EINVAL) {
> > -            fprintf(stderr,
> > -                    "PPC KVM module is not loaded. Try modprobe kvm_%s=
.\n",
> > -                    (type =3D=3D 2) ? "pr" : "hv");
> > +            error_report("PPC KVM module is not loaded. Try modprobe k=
vm_%s.",
> > +                        (type =3D=3D 2) ? "pr" : "hv");
>
> Same here. A trailing punctuation. If possible, feel free to refer to
> the comment in [1].

vreport() adds a training newline, so I think its ok to remove the
training newline and replace with error_report().

>
> >          }
> >  #endif
>
> [snip]
>
> > @@ -2542,8 +2538,8 @@ static int kvm_init(MachineState *ms)
> >      }
> >      if (missing_cap) {
> >          ret =3D -EINVAL;
> > -        fprintf(stderr, "kvm does not support %s\n%s",
> > -                missing_cap->name, upgrade_note);
> > +        error_report("kvm does not support %s", missing_cap->name);
> > +        error_report("%s", upgrade_note);
>
> "upgrade_note" string also has the trailing punctuation, and it's
> also better to use error_printf() to replace the 2nd error_report().

Yes this looks ugly and I will replace this one with error_printf()

>
> For this patch, error_report() is already a big step forward, so I think
> these few nits doesn't block this patch.

Thanks but I will send another version with your tag added.

>
> Thank you for your patience.
> Zhao
>


