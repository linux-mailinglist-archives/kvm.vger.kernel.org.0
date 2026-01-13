Return-Path: <kvm+bounces-67922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 87EBED17798
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 10:05:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A8FA130096AB
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 09:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21983806D8;
	Tue, 13 Jan 2026 09:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fwmtbW0R";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="H6HQV8lF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563A53815CD
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 09:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768295110; cv=none; b=PFsxw0k6uFqoGu9F+8/8ENf8LnQPh5FqEN5qnubBqpcfKcVoGFJOmTIy0I4nQDuCnu+0hxDHncBNsvhllGbBk674+ULvTpOOs5e8AfG4vbPxti0b7FMm1h3Rbbw2fvApK8J/QcIUeY5z2Y4tgi7ru0jSnjHEtRZDCNbIAomefrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768295110; c=relaxed/simple;
	bh=9nLLkGH4ONrOmfPJMXuwFUDKrwGVsTBLOcNW9/rA7rA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R1CgU4cCAXdZW2Wc3g7D2U0I9cRgoRPYSv5fwDf4LUlBdnaKmER8p1TolpE0Epat9tQH/XX38+NpueCAC1/J/JeKFeI49KhBDMp5dwWINfjvI4r7vQkTKplxh+c7BcdPjS5KDfIZmTsSR6JrYnTDs9H5AVyHUkVcQww0adqcyvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fwmtbW0R; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=H6HQV8lF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768295107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qajHnMGw3ZdtEuAKfx2zY/SzFAOO6RQwHn/ZFyWTsbc=;
	b=fwmtbW0Rz57E6NHAfiBXqCHeYZN6KekY+Y05tH81vKTMczPTOv8xigZj0e3C4Z7aeaekry
	f3//j5S9MugbwTlnnz0Lt6gMRd61q0dHMObLLO7yoHbjMBpPxMEx4LOj2Y0hkcmE43OCPB
	clKQ42sRREwdNsMsY3j5szlHqYefXhA=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-1U7MowJzOlaz1WjKFHjCjA-1; Tue, 13 Jan 2026 04:05:05 -0500
X-MC-Unique: 1U7MowJzOlaz1WjKFHjCjA-1
X-Mimecast-MFC-AGG-ID: 1U7MowJzOlaz1WjKFHjCjA_1768295104
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-790992524b1so118997987b3.0
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 01:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768295104; x=1768899904; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qajHnMGw3ZdtEuAKfx2zY/SzFAOO6RQwHn/ZFyWTsbc=;
        b=H6HQV8lF7qtvIIMkV4CVEs7mVlsNggTAWPNYJjIGj59cX5KGoasw5EcltbHjoQwdKv
         LrmZ0LpCfPGod4pg7eSamUdyB7LpVG2vfhfnX27D6CgpIMy9bCQXJ2gobqMYC+xiCfQ5
         wUczqdCZBo+l2cxsfafBRiLUDD59/gbvEHiHstydAKG5DZOqkPmllb40hQrBMkP4VDuc
         jYov0b7PZpUTl+nLr4PXraYoHqzCBAU+VBSFurvg5gLXZe1j4beuVp9T7TYfPiJITRnO
         gatmwuxDG8lXs9uWh/fM9CBnnDzZY+lzoibxhpAQaPxpj4w4YXcVpXKNb6U4Og7mL1lx
         THOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768295104; x=1768899904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qajHnMGw3ZdtEuAKfx2zY/SzFAOO6RQwHn/ZFyWTsbc=;
        b=sCGWmfJq7AVgVogdk1ogst/AkFdErSAxmu8dFgXChSmYVmIl3CtYiuFryU9mI64up/
         IpBz6ejr/ilyNJdU2Oz532+BBQSpzYvsjvut6xKMiIfzXgYI6BnBPjTD98aBmmQnwdVI
         NCsaHZX+sZNbSWEWxl/8gSiuGGXdBVurrbCs9z++oqGB6rZSnptpbHUgIBn3Y3yXhgKU
         4dNi5APJOVEO7MHy7JqmPxMvH3Pyi7QDP51O8iV6wIdDU76h3YJ3qJLY2lL9CtI7rwvj
         kzDW6N0MAARLQVBe21YNjtm7gRdQYc5M9Zc4f/5BfzeinHmSYoLxTFN8d8bSA1w35hIu
         MhUw==
X-Forwarded-Encrypted: i=1; AJvYcCWBzfgK7bA+jvfl35LeO/IVnveop11VRXhQIjUSGI/sj+dwZPGbMkDE1FncAtzY0/N23as=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/SAwgM5AHoraSpSGT0Hc8l6VtG0dyGBXyPm+EKn3r8lzNu+9Y
	0LpKGpBhLD9GyyBAc5CDaJwtRdW4NWw+tspcBFpvGw4BrVMAiE3fnu3FZfpdebL4eLW2avUADAk
	svexkcBBy4kIGdwZKSNhPO/vKoy2ILR32wDmQikk/9kR2/Ov1Ghz9Jz4UUTuBdoOmqb0pGcl49W
	p71UuBoXRWHCUQjiwd9+zzTLs3cpTp
X-Gm-Gg: AY/fxX7iWdeuQbjuAUqEtuoxEb9kmgbeqnHGLTpO+B0nwI5N3QK2SPEFVrKFwG1dh2V
	B6lKUKicJonlEozC708v6wozdy2xBdq48z9dabbQs1KM5S18mSWNz73sWmIcjhEH3UqbKXq9gBG
	/UVQ+mHhInbm4cNHdl0C1w9ikFVZaaBs7hOATpYxjWK8uy4zlZOo4XLukhheBZfzkx2JHcyFY/o
	7HMKWEKCQhf1kzYTPqVCa1RAw==
X-Received: by 2002:a05:690e:1407:b0:645:52ab:8101 with SMTP id 956f58d0204a3-648f62b7babmr1967414d50.33.1768295104530;
        Tue, 13 Jan 2026 01:05:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF9hDVcta2sm1Dxk1EZJEMaNuPNZlLYI8i4dtYynMlPY7XTJuYxfeRoBdVnl9c5rGQjUSisOkYeC2cxY/vAvUI=
X-Received: by 2002:a05:690e:1407:b0:645:52ab:8101 with SMTP id
 956f58d0204a3-648f62b7babmr1967391d50.33.1768295104191; Tue, 13 Jan 2026
 01:05:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260109143413.293593-1-osteffen@redhat.com> <20260109143413.293593-4-osteffen@redhat.com>
 <F2E4DEF4-3E69-47E4-946F-8795FD6CF77B@redhat.com>
In-Reply-To: <F2E4DEF4-3E69-47E4-946F-8795FD6CF77B@redhat.com>
From: Oliver Steffen <osteffen@redhat.com>
Date: Tue, 13 Jan 2026 10:04:52 +0100
X-Gm-Features: AZwV_QgUwF8qACGwNJN7vmv95RmAWL6ETL_v2kwRNY9Rhxnmlv7uFfct8yEs6mA
Message-ID: <CA+bRGFrdeWpZFwRsLVOGDfw_Wb5622f6GafiJVE0dY1tU8yq1w@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] igvm: Add missing NULL check
To: Ani Sinha <anisinha@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, Richard Henderson <richard.henderson@linaro.org>, 
	Igor Mammedov <imammedo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Luigi Leonardi <leonardi@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org, 
	Eduardo Habkost <eduardo@habkost.net>, Michael Tsirkin <mst@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 8:21=E2=80=AFAM Ani Sinha <anisinha@redhat.com> wro=
te:
>
>
>
> > On 9 Jan 2026, at 8:04=E2=80=AFPM, Oliver Steffen <osteffen@redhat.com>=
 wrote:
> >
> > Check for NULL pointer returned from igvm_get_buffer().
> > Documentation for that function calls for that unconditionally.
> >
> > Signed-off-by: Oliver Steffen <osteffen@redhat.com>
> > ---
> > backends/igvm.c | 13 ++++++++++---
> > 1 file changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/backends/igvm.c b/backends/igvm.c
> > index a350c890cc..dc1fd026cb 100644
> > --- a/backends/igvm.c
> > +++ b/backends/igvm.c
> > @@ -170,9 +170,16 @@ static int qigvm_handler(QIgvm *ctx, uint32_t type=
, Error **errp)
> >                 (int)header_handle);
> >             return -1;
> >         }
> > -        header_data =3D igvm_get_buffer(ctx->file, header_handle) +
> > -                      sizeof(IGVM_VHS_VARIABLE_HEADER);
> > -        result =3D handlers[handler].handler(ctx, header_data, errp);
> > +        header_data =3D igvm_get_buffer(ctx->file, header_handle);
> > +        if (header_data =3D=3D NULL) {
> > +            error_setg(
> > +                errp,
> > +                "IGVM: Failed to get directive header data (code: %d)"=
,
> > +                (int)header_handle);
> > +            result =3D -1;
>
> I would just return -1 here and remove the else {} clause below. It makes=
 it slightly easier to follow the code.

Sure, can do.
But are we ok with publicating
      igvm_free_buffer(ctx->file, header_handle);
which we need before returning?

>
> > +        } else {
> > +            result =3D handlers[handler].handler(ctx, header_data + si=
zeof(IGVM_VHS_VARIABLE_HEADER), errp);
> > +        }
> >         igvm_free_buffer(ctx->file, header_handle);
> >         return result;
> >     }
> > --
> > 2.52.0
> >
>


