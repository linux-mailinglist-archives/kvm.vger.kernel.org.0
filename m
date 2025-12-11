Return-Path: <kvm+bounces-65761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BF222CB5C45
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 13:14:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2C9963027CD7
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 12:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A302C30C631;
	Thu, 11 Dec 2025 12:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YGdQTiNM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="U627fN8R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AF626B08F
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 12:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765455235; cv=none; b=iPkhc8tD2Ql1u1o24H/ZivaFb6Q0TlovH9Osh4V4M+5UwkfWDgryPSeZM8uY+murEklT6DIe3/9nt9+TXDEQuAOmnOVTCggUJ3JZCSlCTVzulZEWG0iJAAMbIrlxicyATokTljgXAX/w3ppFKZsQMcKqIAg+eEe/88pFLYnUJII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765455235; c=relaxed/simple;
	bh=NmXsFcOAnwvAj3nF3NXaNW5KEmc2rJaXjSECcaYGufU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cOi0cds6nQdUu1QpxyvEVt/rnaavzf0oS/HX+TlOHr7Py1kr9UK+VbLoUcaD9qa4trv3dinTnd7jrU4JyaRVuzmX1boaNbddy7TlumfrizAauEg/tUfK16wnprE//K0iZvGMGiUUbIhrBwiRYJVQkUYve+VTViBPEyiBiZM1bL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YGdQTiNM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=U627fN8R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765455231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yI1OvrvfSngspZxo1DNPDpXA2hckf2JskikJ/uhiwUg=;
	b=YGdQTiNMAqF2azsd4QhNVw9KLqD9dOCXhC0gs58AM0a/s1wbfeFfdD8+5dmBPtctKHrn58
	CJKlKfR8WgnAxJxP1dI9GYBCMLWDgdDn6Pu+rf0yDFP+TQXYC97HRqMxYKh+V6hqT8vnrY
	0bAIVC8cruzXqMtKx663DNWPbgJYZeQ=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-QNeQK2MyNWSm4fe2bohTmA-1; Thu, 11 Dec 2025 07:13:50 -0500
X-MC-Unique: QNeQK2MyNWSm4fe2bohTmA-1
X-Mimecast-MFC-AGG-ID: QNeQK2MyNWSm4fe2bohTmA_1765455230
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-63e0c5c5faeso4208d50.0
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 04:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765455230; x=1766060030; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yI1OvrvfSngspZxo1DNPDpXA2hckf2JskikJ/uhiwUg=;
        b=U627fN8Rq8ss29TvTw/+YnNBfwfpHmbqPKBDotgx6yiQaF0xZFsqfNUIO6DxsJebNQ
         avnq79toQJxfcBORgg3eJtWx3do+Qb5DDDvJC2DxHljJJjP0R965A5t123YbRhx2flW6
         kEWhgWFA+FV1RuQwSi2KpN2THREq1SGnpgxkYFNniMXspqQQZHYDQja8rNnKVymMTfaT
         DIRg2H7Lt0mJJPA0wl5hXz6wCkZMk72byQKWEjUw88+tvUzHs58mVjWWPrfdaPwZxsrd
         byElqcBcQD1j9/8lBIfz2wrAMglV0IIJM9MIngvnmqiNIXgMU/QDBOGbmdi84ku8KmEh
         6npQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765455230; x=1766060030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yI1OvrvfSngspZxo1DNPDpXA2hckf2JskikJ/uhiwUg=;
        b=KbsBUEz3zGrLBRhwhxMtxMNj5y5E251TGyR1BrS+UqghxDhL61t9cPCrHr3+GzlyxH
         RAqh8zPzNSP/rlDFp34Y6TrLNeSn+vAb0cptqn56VbJL7bErRN+4UQ89ZAm9AXTNz6WX
         Q1dQeLac5loVyj8Badg4j7xgQMPhDl9W1sQgP+7IPT1gtedBdFrzow790joZhLQJrNEJ
         NhylseNWIdL8SWvDR/ObFxArDmaF5mXwHXI9l7Qn44NbsY+w9lLh+J62InbfMxixuwEP
         cMQ8c/H2H54kXLyl4H/PUd+jV19cGiACvpq6lzJuKkJEPqdTiXRu6qiGrhtiuUwgnnyO
         E7dQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbNgNg00DeoMuJBpF1KBqCDTqAKvrNrEAKxelEzgC867jI3vP+EdEUxpAeBAUdN4uvKBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YywiEyBCXgqV54kK66mFtVyjsJn6Ukejg/nWAQIcJOIblJHEs7Y
	BbsRRdQd3P8lsVkOezc33CSJjyWFC/ZMioH9lNoR3vhXi1RdlBZJ4G9qaVfYs4u/qv0LIq1uBDQ
	p3+O9R3noYhBvvmtWBru5oPZD0gJLuEWtdAG2fcBHAGD678Mc++cLLoICqosuiB0nltU2jMIwVc
	+Vc7WaqldlFUWDWZX2g3EJZpyIu0LX
X-Gm-Gg: AY/fxX4AvjYlmPiQeURZWfJ8FN6XG6ShtZU6qNrP8U8m3t2jt0R/sd/aW1JIfG+aNEh
	E3Q/HjEH3N2aqRj3TtNLr2IsqGssZqaGDoIvcbFs84G/8ztGMmCnlaptjNORGMTScee4cj1yiU7
	+TraS+wLh8hTsmuVS8J+XSVzPkwkNwgp1o9+rytHs3HqItWAf4i6JUqaST0PVK7QCwVfZyiEUtV
	C+dNkeUFCjiUgZonK90Hc/41Q==
X-Received: by 2002:a53:accc:0:10b0:642:11db:f5f9 with SMTP id 956f58d0204a3-6446eb00d22mr4040238d50.55.1765455230058;
        Thu, 11 Dec 2025 04:13:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHROJjsbzOIVv+kYTD9ro8JG+iZdkU/42JNWuiGSczA/9oE2vX2Q9tF+kKEIbWEYXmMVuuS5GDxWugGb4B3XmQ=
X-Received: by 2002:a53:accc:0:10b0:642:11db:f5f9 with SMTP id
 956f58d0204a3-6446eb00d22mr4040218d50.55.1765455229744; Thu, 11 Dec 2025
 04:13:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251211103136.1578463-1-osteffen@redhat.com> <20251211103136.1578463-4-osteffen@redhat.com>
 <h4256m67shwdq4aouxpqadb2zozhq2f5dfeo74c5jnet5f26kz@a3av5xjfyfow> <wcqcwrshe6nmz3lb5bz2ucdydwgsfxlxbua5jfaly677zsgy4h@dy3nypkedwhi>
In-Reply-To: <wcqcwrshe6nmz3lb5bz2ucdydwgsfxlxbua5jfaly677zsgy4h@dy3nypkedwhi>
From: Oliver Steffen <osteffen@redhat.com>
Date: Thu, 11 Dec 2025 13:13:38 +0100
X-Gm-Features: AQt7F2qze9RyAeRjOZHPPw_9vU0S84kiY_7xf7UE5IW_lvYtbV8Jd7QVLXvgO0M
Message-ID: <CA+bRGFo=bxbKPCkG6cWY9RH501F8NF4yxZk_hu6Vqi6NkFLK_Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] igvm: Fill MADT IGVM parameter field
To: Luigi Leonardi <leonardi@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Igor Mammedov <imammedo@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Ani Sinha <anisinha@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2025 at 12:30=E2=80=AFPM Luigi Leonardi <leonardi@redhat.co=
m> wrote:
>
> Hi,
>
> On Thu, Dec 11, 2025 at 12:15:59PM +0100, Gerd Hoffmann wrote:
> >  Hi,
> >
> >> +static int qigvm_initialization_madt(QIgvm *ctx,
> >> +                                     const uint8_t *header_data, Erro=
r **errp)
> >> +{
> >> +    const IGVM_VHS_PARAMETER *param =3D (const IGVM_VHS_PARAMETER *)h=
eader_data;
> >> +    QIgvmParameterData *param_entry;
> >> +
> >> +    if (ctx->madt =3D=3D NULL) {
> >> +        return 0;
> >> +    }
> >> +
> >> +    /* Find the parameter area that should hold the device tree */
> >
> >cut+paste error in the comment.

Will do.

> >
> >> +    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
> >> +    {
> >> +        if (param_entry->index =3D=3D param->parameter_area_index) {
> >
> >Hmm, that is a pattern repeated a number of times already in the igvm
> >code.  Should we factor that out into a helper function?
>
> +1

Will do.

>
> >
> >>  static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **e=
rrp)
> >>  {
> >>      int32_t header_count;
> >> @@ -892,7 +925,7 @@ IgvmHandle qigvm_file_init(char *filename, Error *=
*errp)
> >>  }
> >>
> >>  int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
> >> -                       bool onlyVpContext, Error **errp)
> >> +                       bool onlyVpContext, GArray *madt, Error **errp=
)
> >
> >I'd like to see less parameters for this function, not more.
> >
> >I think sensible options here are:
> >
> >  (a) store the madt pointer in IgvmCfg, or
> >  (b) pass MachineState instead of ConfidentialGuestSupport, so
> >      we can use the MachineState here to generate the madt.
> >
> >Luigi, any opinion?  I think device tree support will need access to
> >MachineState too, and I think both madt and dt should take the same
> >approach here.
>
> I have a slight preference over MachineState as it's more generic and we
> don't need to add more fields in IgvmCfg for new features.
>
Passing in MachineState would be easy, but do we really want to add machine
related logic (building of ACPI tables, and later maybe device trees)
into the igvm backend?

> Luigi
>


