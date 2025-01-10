Return-Path: <kvm+bounces-34990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E306A08902
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:37:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2F913A8B3D
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 07:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C173207A19;
	Fri, 10 Jan 2025 07:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CLGsOMUX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4727320764C
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 07:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736494637; cv=none; b=CFjndFz0DcGRA4XkpIom3ZeOp+wf2PUHNP+HhZUbIgeXrt9uq7NevKuwqQAgVHD2ttO2C1Ggw5+yEqrW/z9IbcortgXZbXs5t5DUIfApSFRhd53JKCf0soozNGYQDI5SNstMgAWRqmQhGDNNOPAC2faQ08lPukWdGuoe/YPupKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736494637; c=relaxed/simple;
	bh=lKkX0jSDmzCgHP0q2ZI55ieL6iTIROIb0PrZYeN893Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H4NAhYhDs7OCkFzvkdJaLTIVqSgrOJwmeivTsbnQ16S/f+P7b6458jgIXGvHYnkPc4cZk2Q/qD/Dx4h3/2fxaYnZjE2StM7sOgez/uzrxtjovutcGq851BhiknC8VmXgHJx7OJ4aiWORud9nCe/vh1FCMZ9IK8O2PWZ4aKouv7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CLGsOMUX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736494635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lKkX0jSDmzCgHP0q2ZI55ieL6iTIROIb0PrZYeN893Q=;
	b=CLGsOMUXMCWakVV+8gij1SQj66VqOE6uPHCRkeevemYJqCZNs1pDWCT3jRufLMNYElRRrg
	74kHpMqkXyXA2kX1/5H79z6yX/FR+4zJn3mUKgBMQF44at1BECR2BYwcjMMsRdDD5x5CIJ
	06f+J+cYi9D+0q6IuBGFZtTyT7k13Y8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-uovx21o-NJy4izu1PY1jBQ-1; Fri, 10 Jan 2025 02:37:11 -0500
X-MC-Unique: uovx21o-NJy4izu1PY1jBQ-1
X-Mimecast-MFC-AGG-ID: uovx21o-NJy4izu1PY1jBQ
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5d821f9730aso2701962a12.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 23:37:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736494630; x=1737099430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lKkX0jSDmzCgHP0q2ZI55ieL6iTIROIb0PrZYeN893Q=;
        b=NH0RGXWreTSqcgdR7eSV4wu0C0/AvSDo/WnNbav427KKYeJkZJSiIR6Q1gxvKzUENr
         ecOzoJSoEUY3bPKO8HH2IGsI1Kb1FLwMPuv8arV5JBj2356sQ/PWjMuQ6680Od9Jlz6l
         dffmpGHS71jY9Afz0AgJVMyRDnDM4RExz7elgOzHRXOCg1+EQGZGdh2qkR1i+UOP26Ov
         MVVeVFUKKtKqB8Vj9SCMoYt2TtCAa55h2J0wmEpBJqwsBOLTvaln4waLYgQedY7JnoBK
         ssBtNMIplF/AngCSsbtkFwWYN2iwKd+D+hz9tMzahl6nvm7SxY2tqmIhuHvcCD59TPlo
         mWxA==
X-Forwarded-Encrypted: i=1; AJvYcCWXfUnWbZZLVxu4hx0j7MSFaV9BS7qSayPELALs4gaQ2Srq44m/+uVIMsRKgtVkboWD2XI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGQSSZkjZkLlKQFCl3IV8T/6cv8F14u5g0D1RtS++NUFv0ff4z
	TOiAA15XZfmBL4ZsQNj06iplqhdGt4E6ikezaQozpNbZJ+sMVnYXceDEcpcc48jiPqPttaGKBRy
	Kx4DWkwTSm1xdE4Ai9FcgpqfR5UWAub/A7NNldL1EvRkMnElkXL6wwmrBOO5hsOSuDckulxSmwB
	tMleBawPbwdhgTpv+PV0zesQ/I
X-Gm-Gg: ASbGncuMuA9YY/dCMEQ1oWZEYPfpu3zvSsP0W3N264YCRWANoCXlQbsBdbJbFp45N91
	fJ+29GSMdikE7dNFHu5Hv7+r86G1I4fJpf5vCPm8=
X-Received: by 2002:a17:907:3d91:b0:aa6:7ff9:d248 with SMTP id a640c23a62f3a-ab2c3c452c8mr540919466b.8.1736494630060;
        Thu, 09 Jan 2025 23:37:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFM+E3EJ9VIADqft4XZeqnSe1+lGGIJwDA4N/xijHGbaNmJmQVeQUzAlHVdy720k+fmj7KB/3fUzKLdRp4U0YE=
X-Received: by 2002:a17:907:3d91:b0:aa6:7ff9:d248 with SMTP id
 a640c23a62f3a-ab2c3c452c8mr540917566b.8.1736494629743; Thu, 09 Jan 2025
 23:37:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109-rss-v6-0-b1c90ad708f6@daynix.com> <677fd829b7a84_362bc129431@willemb.c.googlers.com.notmuch>
In-Reply-To: <677fd829b7a84_362bc129431@willemb.c.googlers.com.notmuch>
From: Lei Yang <leiyang@redhat.com>
Date: Fri, 10 Jan 2025 15:36:32 +0800
X-Gm-Features: AbW1kvYh6DcaW0cgKJgVFtgsup_78mHRUFkOPq--rB-NQ70GCEus3ijRcbVoJWE
Message-ID: <CAPpAL=zta_HNWcWsbL=0ymRfd_ZKx1nZ=F+Jo4kLXaUnqFnLDA@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] tun: Introduce virtio-net hashing feature
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Jason Wang <jasowang@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I tested this series of patches v6 with virtio-net regression tests,
everything works fine.

Tested-by: Lei Yang <leiyang@redhat.com>

On Thu, Jan 9, 2025 at 10:07=E2=80=AFPM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Akihiko Odaki wrote:
> > This series depends on: "[PATCH v2 0/3] tun: Unify vnet implementation
> > and fill full vnet header"
> > https://lore.kernel.org/r/20250109-tun-v2-0-388d7d5a287a@daynix.com
>
> As mentioned elsewhere: let's first handle that patch series and
> return to this series only when that is complete.
>


