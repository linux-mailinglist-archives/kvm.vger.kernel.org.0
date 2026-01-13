Return-Path: <kvm+bounces-67909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 20AC5D16B10
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 06:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3AA0B302BF65
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 05:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8967A2F6907;
	Tue, 13 Jan 2026 05:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eTHLnmOY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kx1tfGOi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A257258EF3
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 05:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768281774; cv=none; b=ONxE8+Ryf8294X7oK1of/CDHOTINl0RkOKwMg4kHA5XOTx29fNCk1t4RaPJudk6+zpCr4Ntr1ZD12y2Us9+ZSB4ElRlH7yhuQXiTvVQLtjBnsUIS+ZsJZHxTQyCuvvKbvX4iQBJJfBTWLSC/rsqIkKdqsj7xsWoLfmCy+cLH6Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768281774; c=relaxed/simple;
	bh=hfMpwklsdJx+F4HuiixWGqgkzZ3BgwsMWDCF57OKCks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jYusAJuDhyw1Z/vLns7atQOZK61tKiPB09SR5jEYOQwJ/ja+dmLGvgnNI+n2Qpz0FhpTRKpS9IDgsYtLGXLWc8TQeMMgCUOK7OcY+6Om8v6iTk8jqVk2GPF1WQ0ZnpZVTSj7eicV4v8oimn7IYUT2DAich8F413JZ/K3diXSObI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eTHLnmOY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kx1tfGOi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768281772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UuSFWBRTF/a4F2rYUMOuTIPAqFb+YSyzOAe/OHdCM6Q=;
	b=eTHLnmOYxVufziRZc0mOuJGBaOBrs0FgCJz6o/6WElKbwPfVWdlRJIvGksCxy1klPgT8R3
	ltVqGvAmj02sxBmgWb8QwCWxmJbFMl4ITP64tbmeqniyOfQZPrx4mrMTe3OQwHtYljXE4X
	KrqVC+eB5iwa+EZsQ4FCCsAsJ8EBxSs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-9BLcImoENaG6cGaaGcB4iw-1; Tue, 13 Jan 2026 00:22:50 -0500
X-MC-Unique: 9BLcImoENaG6cGaaGcB4iw-1
X-Mimecast-MFC-AGG-ID: 9BLcImoENaG6cGaaGcB4iw_1768281770
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b6963d163eso1838177585a.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 21:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768281770; x=1768886570; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UuSFWBRTF/a4F2rYUMOuTIPAqFb+YSyzOAe/OHdCM6Q=;
        b=Kx1tfGOiEpdW735wFYyN8Ku+ft/uUaQW+lfLe0NbNhkh70Vs8MFGI2zsofsMcMIlcB
         yUbdVGG0je2L9pMl/UjG4YGaw9yKU+/GwfOVuysynzIqga0kRy3pFO2fdiPAzigjn3lC
         5JQZnhK3v/d/wkfhhP379aSBtxYCT+PV8mSE8mD/RhFNxaT12P48YsKH1c6EX0eSV8/1
         d9ju4q1hg9bY2S2zDZdcaW62dGafPJN1L3+46lYbW2ZPaOu0261zhwvSxlrCXUWEeA03
         vWS/35EpQVHgwEOs+TMrtbm4J7PDughco+MpbxVUm1rXGsWPDZe3ua5KbasjRYywm5Pa
         qQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768281770; x=1768886570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UuSFWBRTF/a4F2rYUMOuTIPAqFb+YSyzOAe/OHdCM6Q=;
        b=woxCUDlWBUPGiaGI5+ZJDMEnNqfBgW+iYauuZdLLQRo2XjAa6ColYoNfvsdXMOs+4M
         bYO09r1RvPNQe3FvIEPctCxFvFWA2ZascQi5nbgUKGesm8cYUTKXjZFaNVdWypyjHOrv
         waYiF2FVfGRY7BCXhJg8xR5mP2nOkjlrjht8DSWeVt4b7ubzygqH/CHT2pydfG0nWSOS
         lUfCMSz9dmXJjMuws5zO9GNccCtQYO1uG34xjEavzyfN5TR4OggUEbiaApkhs4z2Grp/
         LZ9rHMFv7seAUrthXyf4llmiDlrpSfz+Ni9UA6G/cb3TJpg3yM9ndrxFG9Jsrtnlfa42
         hdWw==
X-Forwarded-Encrypted: i=1; AJvYcCUpcIzFUdyFy6wyHmNn4PmuLmzjZWJdI2Nz7cBO9C5UJ2PdU2NjhjK3EAGaT3RgfcYxdz8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSdGIhX1wWNDLHsZ18pfD4ZUSnF7Ib6zlJGaclE8fFP/tkaf5g
	wv2+vt/MHiFkF+z0eNRk7ILP9P600lmGaPVKoIR6YFg3pX1OQr8HcbKsQ9CXwJlIUicS0ayHbuz
	lv7fbLAcTwVp7Vgw1jVTLCH+U7VRg6VHWegt8O1W2oNcfqs59pEPglydv7kBdW5jdoIxTFetslt
	iYbCYJ7jJZGnQMH7JBVrQv2NRt3P9R
X-Gm-Gg: AY/fxX49fdLSTBJbeJj9J7T/BzbEVra01SssdYSZrABW/2fB6Zbc6ad5RBxwu+nJy33
	U85i58c4OXX4axoA6gBSGLLMRcfy5Iz6Y+tPAGvY1GanQOFi8UK/6FB29UcITA54Y5a9O/yjGCt
	5+XBhdMWNSDQTu6652CjaSlM5pSqNHyKJraPhfQlkdFyTKhHHBnb0RKH8cUvI67U+LmuPgZVqIa
	18psGenml7/r/5lZ8eX+w2jzUU=
X-Received: by 2002:a05:620a:708e:b0:88f:ee0a:3d66 with SMTP id af79cd13be357-8c389414f29mr2813736485a.80.1768281770007;
        Mon, 12 Jan 2026 21:22:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHiH8WsY7O+xC9FcuVzBoC//WNKiyql+/5CHoVxcW31leO6vvM+yMfQ0AGwfBR8EBJ7MkShs5cyX1cMDyDXACE=
X-Received: by 2002:a05:620a:708e:b0:88f:ee0a:3d66 with SMTP id
 af79cd13be357-8c389414f29mr2813734385a.80.1768281769619; Mon, 12 Jan 2026
 21:22:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112132259.76855-1-anisinha@redhat.com> <20260112132259.76855-5-anisinha@redhat.com>
 <CABgObfbDTAvm6E0imC=HSm2=BAC4rzUDmuHcoUbVjJ-YeXFw-w@mail.gmail.com>
In-Reply-To: <CABgObfbDTAvm6E0imC=HSm2=BAC4rzUDmuHcoUbVjJ-YeXFw-w@mail.gmail.com>
From: Ani Sinha <anisinha@redhat.com>
Date: Tue, 13 Jan 2026 10:52:38 +0530
X-Gm-Features: AZwV_Qh-HDldufjqbgWd4d5gXuNVRPG-KFr5tvZM8MpWL8MTjAupkr2EFt14Opo
Message-ID: <CAK3XEhOWn_zecQjvFvzsRu_dmHBAjJ4gaSfKKp6BHviQmz2D2g@mail.gmail.com>
Subject: Re: [PATCH v2 04/32] accel/kvm: add changes required to support KVM
 VM file descriptor change
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Song Gao <gaosong@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Aurelien Jarno <aurelien@aurel32.net>, Jiaxun Yang <jiaxun.yang@flygoat.com>, 
	Aleksandar Rikalo <arikalo@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Harsh Prateek Bora <harshpb@linux.ibm.com>, Chinmay Rath <rathc@linux.ibm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alistair Francis <alistair.francis@wdc.com>, 
	Weiwei Li <liwei1518@gmail.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Ilya Leoshkevich <iii@linux.ibm.com>, 
	David Hildenbrand <david@kernel.org>, kvm@vger.kernel.org, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, 
	qemu-s390x@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 10:32=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> On Mon, Jan 12, 2026 at 2:23=E2=80=AFPM Ani Sinha <anisinha@redhat.com>:
>  > +int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
>
> Weird name since there are no "operations". Maybe kvm_arch_on_vmfd_change=
?

I meant the operations the arch wants to do on vmfd change.


