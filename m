Return-Path: <kvm+bounces-67916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B0C4D16FBF
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 08:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4634F30407DE
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 07:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8895A36A01B;
	Tue, 13 Jan 2026 07:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g3A7PjKO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dRaPQr7e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E35336EC7
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 07:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768288906; cv=none; b=tVL9m6B4Kdb6Eqfz0NqEyuCt0Ktj2ygnb9R8fsz3kgNAehJEOXo3jZsAzJnp6Tj59uDZTF+/IPeKFTsyuveMSwfngv5WsylXym+/XC1shQq6Mcem7FO7yD6hbmx+vtOHv3YxW2JkbfmDdorVAZVMz5iZonAVXnbmVx2FGDFTRtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768288906; c=relaxed/simple;
	bh=5vER1vEtrABJujIZKDLfkqahXZnPh2GTTzVKgCeG9wU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ouLPthgKZ1n6lC9fuMhXLIB6C0MWvaAvmVvLwj5oO45fQShM1me5kJovLcIj1ZfQ3i22MAKGsh/fVBmwAIobCzJrCp8VxO22sSfE9KmmpEllzFz8Jm6f9x+/dCYDm1vGlJXgzlvmgHaSgwrCc7owOvT+rRkdvgOvyukf9BAzRp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g3A7PjKO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dRaPQr7e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768288904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DIyBP1UlbfdGj0aq90i6iUmp48Wa3gdQSlmSZC+cYDk=;
	b=g3A7PjKOAiCNK+FRP+NimMwldzmjBu4Wmsr8Axf2Dq1D5OKGOmSe69N41fI8jjkKXrhrLM
	hT2FGBipxGsfmWVjDA5LnPCIW3S7/cR9d0nU7FQpTX3kG2gw2ZjCJnxr3VIgLspS5sPhTr
	nnw9WbiZHb9KKYbgaoxSri7+MCaPDek=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-C4XnQmShOUuWzLNPCiWeZw-1; Tue, 13 Jan 2026 02:21:40 -0500
X-MC-Unique: C4XnQmShOUuWzLNPCiWeZw-1
X-Mimecast-MFC-AGG-ID: C4XnQmShOUuWzLNPCiWeZw_1768288900
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b5edecdf94eso2954646a12.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 23:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768288900; x=1768893700; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DIyBP1UlbfdGj0aq90i6iUmp48Wa3gdQSlmSZC+cYDk=;
        b=dRaPQr7ea44CN1c+tzDGnP2eODo+kS+M4HhgH+Jcdir5/LGlqSovLl7L3D0v7Q2t1y
         8IgPepFX78zBqWc4XIuxd60PwmSC0OLb1EFHGfQ0BOkF7Eojxox25Nhb87APUaKHuwGk
         XjG8g+q20KsOkYGB4IQDeISZFQwi4km0toO2urd7Gs/kg5iDQsD0Quo+uEk+9W7ZCZNq
         Dw7bckTljsbp3sH1rxPKHggvWoXx0JBDeC4Gtnr1qrGNqmw5O1hHtX5i5ymIJQz/g16u
         hcJL/NmExh8JeATYIv3hXiJEfZXBUNDyus5kBuEKOSFYcXl3dL3vb9rK4X52loF42hlC
         hC0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768288900; x=1768893700;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DIyBP1UlbfdGj0aq90i6iUmp48Wa3gdQSlmSZC+cYDk=;
        b=rBmdAqvBP/OR+FLAfIfKhKCM3/XTTUkqRwhi4qV2DWhvFUf2NWcWTqrAe0Dp9VUVHb
         LstUsAkgrWqpWjgWDgpVdsmzKauVbf9AHpiuqY4AQY1OI3k3gb+XrJ7OomJG2xgjpmqL
         mXYgKXHNI9AUr+rhDEWSYcxchwiCJUM0FA6RakXeAsiPRHGo3NgDv4B9enSPAVhL2ucg
         sUoRt4yZNsTNh2pAgmqJCJCxza5yrKvABsYVpKxPC+9n4capPD/fvkjwptUDvonQFJ5H
         t9WIWtRrIMTKgKTIiv2DPcZ4PrcAO3OfvmbJWIMtbtY+9Sb1oCG5TetksQlujCZJOqw4
         eONQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5++dopg/d/XhaDUYGAkZHU6oKuHXKn+kCBYqNXk27o50tVjcXPek0xl8VLRuyV176feU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrXWEVxoBlhowzxmJPIAab9Dpl1WbDoDTyrlhRY2lpxYxquGGt
	FZNO2+oLaupsGmXxlHn48FVm5rzDgYXJKxVqAylpUdlVkJguOURFoctIAlioQDt2T8QjpQWq+ue
	vNZ8QJWH+JkdpZvhCuMe8uyiCVJLtVSso79wpRVusF4GAf9JaD75AhQ==
X-Gm-Gg: AY/fxX587BalAgu0S6yxX0Nlj3zUCKzSufyYc8TddIZQYa+s9dv8JaUDYbQ+fx0lX27
	jvYxwFj1DlPifzBLX056KfzzbRHCMqxi5BVPKZCqp0ZC8h22XCoPaWKAROruQKphvaWiDv8Gn+x
	EH39MBLLyp8zVdPvhJ0FoGSGuB5Vt1uoK3H63810GxahZzJrel8pTmf8GNmdjqnMjvWJz0ZGXhc
	c4DCbc9pJ5rBmhUC3f5J3DSHUD84w+H9qWvVAdmVHJLkBzPysG6DuElyFNgf3azmbp1G2id4OO8
	375DXsxZf1MkcDCipfBihepQT9VaPZORwCpzeXapWZnr4gUQxldZaSJp5NMFdjGSzDWcjQjURMu
	dxgBXbbXwuQTUcgUfxXnv698oW7uFqJy52Zr+fZ8xmW7jF02RBB9PRvA2Iw==
X-Received: by 2002:a05:6300:218a:b0:363:e391:38a2 with SMTP id adf61e73a8af0-3898f992b67mr20813670637.46.1768288899855;
        Mon, 12 Jan 2026 23:21:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEnXXHOaNZdnaiFJjLFVPw/Sw4deHVWC+/H1ql2dN49b4/t9y4V96E08v4qiFAQ/eHCtN/hlQ==
X-Received: by 2002:a05:6300:218a:b0:363:e391:38a2 with SMTP id adf61e73a8af0-3898f992b67mr20813646637.46.1768288899479;
        Mon, 12 Jan 2026 23:21:39 -0800 (PST)
Received: from smtpclient.apple ([110.227.88.119])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5f8c45b6sm19101810a91.17.2026.01.12.23.21.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jan 2026 23:21:39 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: [PATCH v3 3/6] igvm: Add missing NULL check
From: Ani Sinha <anisinha@redhat.com>
In-Reply-To: <20260109143413.293593-4-osteffen@redhat.com>
Date: Tue, 13 Jan 2026 12:51:23 +0530
Cc: qemu-devel <qemu-devel@nongnu.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 Luigi Leonardi <leonardi@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>,
 Gerd Hoffmann <kraxel@redhat.com>,
 kvm@vger.kernel.org,
 Eduardo Habkost <eduardo@habkost.net>,
 Michael Tsirkin <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F2E4DEF4-3E69-47E4-946F-8795FD6CF77B@redhat.com>
References: <20260109143413.293593-1-osteffen@redhat.com>
 <20260109143413.293593-4-osteffen@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
X-Mailer: Apple Mail (2.3826.700.81.1.4)



> On 9 Jan 2026, at 8:04=E2=80=AFPM, Oliver Steffen =
<osteffen@redhat.com> wrote:
>=20
> Check for NULL pointer returned from igvm_get_buffer().
> Documentation for that function calls for that unconditionally.
>=20
> Signed-off-by: Oliver Steffen <osteffen@redhat.com>
> ---
> backends/igvm.c | 13 ++++++++++---
> 1 file changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/backends/igvm.c b/backends/igvm.c
> index a350c890cc..dc1fd026cb 100644
> --- a/backends/igvm.c
> +++ b/backends/igvm.c
> @@ -170,9 +170,16 @@ static int qigvm_handler(QIgvm *ctx, uint32_t =
type, Error **errp)
>                 (int)header_handle);
>             return -1;
>         }
> -        header_data =3D igvm_get_buffer(ctx->file, header_handle) +
> -                      sizeof(IGVM_VHS_VARIABLE_HEADER);
> -        result =3D handlers[handler].handler(ctx, header_data, errp);
> +        header_data =3D igvm_get_buffer(ctx->file, header_handle);
> +        if (header_data =3D=3D NULL) {
> +            error_setg(
> +                errp,
> +                "IGVM: Failed to get directive header data (code: =
%d)",
> +                (int)header_handle);
> +            result =3D -1;

I would just return -1 here and remove the else {} clause below. It =
makes it slightly easier to follow the code.

> +        } else {
> +            result =3D handlers[handler].handler(ctx, header_data + =
sizeof(IGVM_VHS_VARIABLE_HEADER), errp);
> +        }
>         igvm_free_buffer(ctx->file, header_handle);
>         return result;
>     }
> --=20
> 2.52.0
>=20


