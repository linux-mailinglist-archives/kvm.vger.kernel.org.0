Return-Path: <kvm+bounces-47731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB07AC4460
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 22:21:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE81F179523
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 20:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864EE24166D;
	Mon, 26 May 2025 20:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FEHdm/O+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB381A254C
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 20:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748290886; cv=none; b=WIcX90/ARbxS0KG+XwordjG8LOlRmk1QWMqXNEf4nB04Sd1+FvQOedsTappycLu7Butddb/0g0J+IjX0zACB7EyzmhhvjGmzHqZrLOiE7DIr+jMZ75Eiv9KNaSuKWLdv7BTUKfJpxK3Kdioci8AD9vis0DRZY00vASXOJe01dTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748290886; c=relaxed/simple;
	bh=6O+HULtQ2zQfibnl8FSMfuNYNOIwOeOtgHCiLFy2uks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aanP2YTkZpoORh0+JJ6buykwXvXqzghxOXGPF7PgDHC4jwYSr34DVVpQAOcGe/REvOKHZ7DAhbDj1rF8s+3Y7k0I/rzmQgxRlsJC1PV3U+MwUNAIOUpanWXqY/BEMpuUPzx33OtzcVI0yBPhAitBe9vy1pq5LVqok7zX64Y8o1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FEHdm/O+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748290884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6O+HULtQ2zQfibnl8FSMfuNYNOIwOeOtgHCiLFy2uks=;
	b=FEHdm/O+qBe9auS6E2hiZuKm3uEJvsWK6q2zvB01uuyNPYPdjmmUilwui+g8MMBhmg9MiE
	ibXThrOWH6wVxeDMXYSBl2lLI39mUu5Nqpt8DwgoRkipXAa43PrQJ7Ohu2PxdzjAoVcOh8
	ImwXYR6nB16ZaHCUu/9v67DyV7oMCJU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-zEo9tRM9P8Sq2gAS4egr-g-1; Mon, 26 May 2025 16:21:22 -0400
X-MC-Unique: zEo9tRM9P8Sq2gAS4egr-g-1
X-Mimecast-MFC-AGG-ID: zEo9tRM9P8Sq2gAS4egr-g_1748290882
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a3561206b3so1067249f8f.2
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 13:21:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748290881; x=1748895681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6O+HULtQ2zQfibnl8FSMfuNYNOIwOeOtgHCiLFy2uks=;
        b=A5VyOG7vQpXDGaG7DzH3Cbwfx+GJg0XTXt74tNxnzhRwB6XwGlfoJCZQCSBZ2hjziV
         v3BSP6yT6cSARjB3nmbb0RtUebz8q/yykPMmcXQm08Z4sG2inMmbLRDh5knwweAZSFxZ
         /WT5gXsQc9zrCpKfFbt3TBj9j2HU78WjGI57Z1A8sJuN0MKD8xG7VHpRHDBpkyZR1Zmb
         JBxOCHlXfDA0ngkrBUmhP5h7irMg6RxFYLtvGriaNaEUgBQtu6dTXgDYfik3nc94fh/l
         ZD+cl2SURTS0QOd3NcByItnGw/LWyRWb+Jtb4+GpOICXMAnHnqMvB+qjqyBuSatoCUg4
         aDyg==
X-Forwarded-Encrypted: i=1; AJvYcCXBS3SozDnt+QopUXXQ7+gyYOzr9FkbKBZpYhPBOXJcSWTEIJtCn/ha3IYGXLmV5v4snLI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwII7h0L56q8PJT6Qo5r6dTrxU0NJXQu3G3L9Eq9UzvkEQl23PM
	llqRZKmTNcRSCiYI03LTODvO5bITbogcUWNwntUF2E9UXajNAYIYc3yqBFb2ZAJ/bqpol1q4tMA
	WV2oZNlMz2+d91iRl4+S27Q09PYzfonxnJO9lwSh3BsF7FkFw+xlq8NKcD5tBioXKsEKo2u1diQ
	PPy0F5TinorhYnGBdgaU1XD/mTz1Rx
X-Gm-Gg: ASbGncsc12HkQplQQirUW7JI+DEt6Xa1K2innj2J1DsxmyYRJ/2BEx/ruNosGUle+iv
	pFZ7DMtVO9Kbw0++EEk6ELV+ulbDMue2/lAYJh+F7BrDCieoOxt7jYYROdxe4jjlC+Sk=
X-Received: by 2002:a05:6000:188e:b0:3a4:d4e5:498a with SMTP id ffacd0b85a97d-3a4d4e549f4mr4549107f8f.42.1748290881571;
        Mon, 26 May 2025 13:21:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPfGkLNrDWsuMBcvBhphCxIvU3GI8PzuGzZDpGUJKW1wSG80qF2SscvPTAo9oEnA5hoBADF7+zA/YXDDS9O04=
X-Received: by 2002:a05:6000:188e:b0:3a4:d4e5:498a with SMTP id
 ffacd0b85a97d-3a4d4e549f4mr4549074f8f.42.1748290881218; Mon, 26 May 2025
 13:21:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523112015.146300-1-maz@kernel.org>
In-Reply-To: <20250523112015.146300-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 26 May 2025 22:21:09 +0200
X-Gm-Features: AX0GCFszvJZwa7StoX7JqXeC8eM3B-BChUPaDxpaOnMqsQR84k4snxyVAo-DiDU
Message-ID: <CABgObfbAD9W8dFzAPhyayBwohNW+9MpBnHfT5A-KVs+7RDQ9ew@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.16
To: Marc Zyngier <maz@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, D Scott Phillips <scott@os.amperecomputing.com>, 
	Fuad Tabba <tabba@google.com>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Gavin Shan <gshan@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>, Mark Brown <broonie@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mostafa Saleh <smostafa@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Quentin Perret <qperret@google.com>, 
	Seongsu Park <sgsu.park@samsung.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Will Deacon <will@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2025 at 1:20=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's the initial set of updates for 6.16.
>
> The largest change is actually not a functional one, as it "only"
> reworks the way the guest feature set applies to trap bits and
> register sanitising. This translates into another (generated) set of
> large tables describing the architecture, which is I hope easier to
> deal with than ad-hoc code trying to do the same thing.
>
> On the functional front, pKVM gains THP and UBSAN support as well as
> some page ownership optimisations, we workaround a couple of really
> bad issues on the AmpereOne hardware, and we finally switch on nested
> virtualisation support.
>
> This last bit has been a long time coming, and I would like to express
> my thanks to Christoffer, Jintack, Oliver, Eric and everyone else who
> helped me getting this monstrosity across the finishing line. Except
> it's never really finished!
>
> As usual, details in the tag below.

Pulled, thanks!

Paolo


