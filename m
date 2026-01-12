Return-Path: <kvm+bounces-67792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id ED9D9D1446C
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:13:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EE82A3029C3F
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA012ED175;
	Mon, 12 Jan 2026 17:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LqSsD2Ja";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XFeJAaF4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B3417B505
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237973; cv=none; b=DlfbjZdwFUDlybaZCJISM4Rw5ymVokjKueNQlkgWU8b1QX5Jws3PHVyPnEbXHcq/P63zCYx3MAsQF/q/bs7gbXx/ZpHXJCm/TQszU4y9gNGKu1yKkYC/bdChuVuO3xM5aJu/aUj2Usqh2VzqsDeOW/nj34JwUjHpYPl2NeNrUr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237973; c=relaxed/simple;
	bh=LcWOT9Ptm6c/PohY1mUMZhqzpHNKKBUMOdW4Dy0BdbU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lRkV7mhbYTdjf7lfUcu4GyktbfCKcOKAlT0poYu6SDNtyA6bS2u3bd+Oh1VP0jfMA2p3gO7mXCCEWbKBIzSWtALnBU8zp+/0kt6Nha3zULRnvg6ei0H52lPo+9QpAYpcC9VEtSYfTvs5/2c5elC2OEApcBMrG+Lt9ZAxnLSqvY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LqSsD2Ja; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XFeJAaF4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768237971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n4FjcWu0LDKcBLtXzBHQQcI0QgAYGSeNNtKSt3IpPOU=;
	b=LqSsD2JaM6oBk36kGmxjX0Daj1D//cHCmRqPfDgjjMgCOt/c8MrHOEKOjhsvE8Nygo0/lB
	/eirfDzyYqGhafIInhkZvXeMuq5yQHvHArOYm4dBfSW82Z1UeSEk4tUqkm6AKPh9Scduov
	t+DAIXyGX5WNCW1xDM0P1wJhFzjXNWw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-B4rzRru3OoGbdaJhPiWWpA-1; Mon, 12 Jan 2026 12:12:30 -0500
X-MC-Unique: B4rzRru3OoGbdaJhPiWWpA-1
X-Mimecast-MFC-AGG-ID: B4rzRru3OoGbdaJhPiWWpA_1768237949
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477a11d9e67so44538305e9.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768237949; x=1768842749; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n4FjcWu0LDKcBLtXzBHQQcI0QgAYGSeNNtKSt3IpPOU=;
        b=XFeJAaF4HmLsHFF8ZggYJ2qAWHhjjWcoGe1QmGkIwkMrwVlk0ftuodpCc5OufDlhFG
         i6BA6Lb8RJ3ziv+Lc4htf9ZbQIHNPBd4LKHG+hNcR4qN6LZIB9rS0uO4Lx0W+VhryTTu
         f8mrqTAgx7FXRlTweJqpnr8KKJjfw4SbA48DcTuyH0ym8JGjAK33YKqzyAAdeDBiv4ZR
         Y154kcLJhc/7wTg44wG/Sye3HbKseE+DwtCCd2LYgixDbFP9z9SoSnaCpwNXXEdyWHgX
         xRw1VxRXWHJGikycxT0rhyDVHVRCmuUKL0xTdjR70moqm6bUMSPTJrWpyPMI1vuhoPgS
         j0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768237949; x=1768842749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n4FjcWu0LDKcBLtXzBHQQcI0QgAYGSeNNtKSt3IpPOU=;
        b=DmdKo/o7WDiTJLgNeI3xo6m9XObvqLKKDDvsxWJe15KbFr+EPFMcAbK2OzuoaOssIw
         rdOH+b14UFc52CPASHSLaegOg56Nok44iKeKByFcaEzEEwkCvGOK4jP/N9R3yTMIcsGE
         zVs8Q1R1wRz6WblsQs/ifHtC2njjPVRjqVqBif7Tfgcy41fkZt3DR8Fp+4bi6WtIgM0+
         464eup9bOrtJKViaUdfcVEI2TaUuHJG/8Ig/TfsKFUNjwiTy1o2zXsLM136+MnPMCM0A
         P8DwckMc6PRny+AGcmfM4SJKLQsLvRbM/M4LTdrd26vLFfL2dNBTmoWwTwH6iWD4LKAT
         7KQw==
X-Forwarded-Encrypted: i=1; AJvYcCUUiGUXycdBKb6nKcrmrgTNX9y2XosjQta94l10ReNbUpACKzrw+PsgfQhkTvbSM2eBF4M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5jTtPmnkBcy5dl5wM6qOM8cg6lIO0GryT0LiEayUVSpC+nqfm
	Yabl2jmV45p+O9SHULULq3coAwhHtYDMFt++1wIXwef9P3NqFn9/Y6JsKLMwqgBdKgmh97YdruE
	k7k0K+ZzjhbxXZPhfG3wus0q+4T14Yh01ilory2o+O2OWMybI9fS7TJuHAqNOBw/56Eqb68oMmA
	kYTe6/xuPaImmTPGARsX0No/yULh3f
X-Gm-Gg: AY/fxX71SU5bLqe4WXm2NALEBBXA98AIUFs6KRqalejJpdg6mHB4hO6eJ8s2QdH5XNM
	DTUFaDqEQGTnE5vszMUI8sIrfcIOwTArvqztkihewlIfwFvzG/YtfPCnNLl7aofHI193ngbFVtM
	pbD5yyCD+C7WCT1wwTeUshD1YL/ZKP+PbIjjCIUVxBff0462EpBo5o8Ft2Tz0ZMhbw+C7BopRS4
	ydMwwEFZTBcpfi6fuu0q8iNn068xGXFNlO8onHRT2D2HkSEdBykwdCw93kEVYZ8HW91hg==
X-Received: by 2002:a05:600c:3e8f:b0:477:5897:a0c4 with SMTP id 5b1f17b1804b1-47d84b0b315mr198969985e9.4.1768237949085;
        Mon, 12 Jan 2026 09:12:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF+VhlfxTBklsMUvnB2bwD9d0SVSG9i3WldYSftXmzGMnTRQo6eoyUW1AqgCgPVrhVKsoZhsI9d3anZTvrNxc8=
X-Received: by 2002:a05:600c:3e8f:b0:477:5897:a0c4 with SMTP id
 5b1f17b1804b1-47d84b0b315mr198969675e9.4.1768237948726; Mon, 12 Jan 2026
 09:12:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112132259.76855-1-anisinha@redhat.com> <20260112132259.76855-20-anisinha@redhat.com>
In-Reply-To: <20260112132259.76855-20-anisinha@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Jan 2026 18:12:16 +0100
X-Gm-Features: AZwV_QjXKzvoLIMEpw40RsKeIM2DnH2rFQQH12t1B2CQDOBP8aJHQrSn88CGaco
Message-ID: <CABgObfYgKFuBJRAR-t+gU2cUu3nVjy3++3R-k4_E+dti4E5XLg@mail.gmail.com>
Subject: Re: [PATCH v2 19/32] i386/sev: add support for confidential guest reset
To: Ani Sinha <anisinha@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, kvm@vger.kernel.org, 
	qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 2:24=E2=80=AFPM Ani Sinha <anisinha@redhat.com> wro=
te:
> @@ -2758,6 +2807,8 @@ sev_common_instance_init(Object *obj)
>      cgs->get_mem_map_entry =3D cgs_get_mem_map_entry;
>      cgs->set_guest_policy =3D cgs_set_guest_policy;
>
> +    qemu_register_resettable(OBJECT(sev_common));

Same issue as previous patch.

Paolo


