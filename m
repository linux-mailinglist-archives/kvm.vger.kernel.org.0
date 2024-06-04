Return-Path: <kvm+bounces-18716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B758FA9E7
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:19:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 706C128618D
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0617213D62F;
	Tue,  4 Jun 2024 05:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N+2wA7Uv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D617C6D5;
	Tue,  4 Jun 2024 05:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717478343; cv=none; b=SPrDmlEMQEQULRgbaxbmFyAoRmysZFF5TCO3haJxVNsTT1jKtvHoP7LpH8+3EjmCgRWbiTTuPwDPVUp4+iYtNfPYpXoOesDXcfxkQkHvpNi+dIPNE3Xja+zS8cF+cXcPzPFSc2Z2R8NfRRlPA+/zmj6n4vhOSuOiG7vkuI+r3AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717478343; c=relaxed/simple;
	bh=xeu34K5A5S0biHhmQKMzt/e1R/2zzfNr7WOs+SqkY+M=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=WGLQJ/AotEFtcSGvdm+qU7DL1gIFmOSgrYbjXeC64OuhfZ6RAVMY/HgY1RByH7/bHVamAufH2nsyOp+C/Or6G72wz55TDHW7GMLGsAUXF5Ai5srkwUlpTX2qsmkm1LGNR9AwgTVDAmd2xhoXPrZrvZuyQvLWDgVgl5q9rEVLHy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N+2wA7Uv; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2c19e6dc3dcso4184231a91.3;
        Mon, 03 Jun 2024 22:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717478341; x=1718083141; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=khY/yRLDLPiQ4jnvCprzEMeF4fDY9ZPnATCsqggrcXo=;
        b=N+2wA7UvGhwO6JDHaUg3VGJw6LlMyaqc4vOu5YCg9+4wX8jgnGSwjG97mLzaJgs4mt
         JvSmmKGsoorBobX+qQCZ7KGUxvFyIKsW+7SkTVBH0O5FXBTOtv69yDDdCkgFi0nTlXpE
         oN3LBpesFqnO9GlmcTFrASRq5LHaeSMs0/Y1zvfkbIISqnB8K8FQT8IhTect/EinJGY4
         6o22qB7Kbo98gx7IxlckUziJaqq2QTqgp/g4M6qX5lgTNoQDLlVMCZvTV30t+ePB2FxX
         2VVINhQORwRAV4B2aOOI2bMIh84/pbwgB2ASObcDrXDzlprdGY9FQ1QLUWh0GkIEvCO3
         TglA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717478341; x=1718083141;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=khY/yRLDLPiQ4jnvCprzEMeF4fDY9ZPnATCsqggrcXo=;
        b=EinlrTWcXbhU+e2wdvvSfEu6okdOg1O2DWbBgltOLoIsc19QwZIdILvGUeneHY26mH
         0PEIPNxv1WW8iKKgL9TK0ek991MNlkn5nlTzW01XSxK6COaOVEytrQWW2L3QUuVw7Wzj
         4e8NL0CzwNzT+LHicNODioPfQ8hFEhJeQL52mngslPIbEvIhujrpMqsWyM43JWH8QbXZ
         b4Y5+aO5UJJcd2fWHtopdfWNtwi0IkkJAsT0hI1AqdvnbwEMIv8CEFHtLAAUI7uc6hrx
         J8ufotYp13HcjJyvY0Tb83onTkwGvYk3apRkyiPSVqrkQPXn+Wa8ou6f7u62RrkyiUY3
         DM5g==
X-Forwarded-Encrypted: i=1; AJvYcCW8FQ6B/Hji58jTEcsR2vn7oyH0swQgyC/u0wZx5GWlfLkXWBMXGtR4ddb7AgIzdXCeJi5cV/HrIo1qAXwxApxfsPNKZEry/49rsXrNCsw5HaDdC7jvmppwEeCHClc1iQ==
X-Gm-Message-State: AOJu0YxzfhB2OUoGoNLj1xD+yGjl0rm9CMegMgr2UlC2dt1mxYoCMQ3V
	UWI//wlyd2n4Pdf9UMFNTZHYOZ7s4Xn+5AOjetkMBC66y8T7y08a5uLxAw==
X-Google-Smtp-Source: AGHT+IHpeS7f3bfu6OTpTuKjK8mrogwZyeYXdceMuYcrUq/374sujKVL7qDwZ6TT/oeKuZFAhAeHeg==
X-Received: by 2002:a17:90a:c907:b0:2bf:c92d:2948 with SMTP id 98e67ed59e1d1-2c1dc56c451mr9583521a91.3.1717478340981;
        Mon, 03 Jun 2024 22:19:00 -0700 (PDT)
Received: from localhost ([1.146.11.115])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1a776f526sm9493080a91.13.2024.06.03.22.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:19:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Jun 2024 15:18:55 +1000
Message-Id: <D1QZ9B6HBZAC.338VDWAS8FMKP@gmail.com>
To: "Janosch Frank" <frankja@linux.ibm.com>, <linux-s390@vger.kernel.org>
Cc: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Thomas Huth"
 <thuth@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 1/2] s390x: Only run genprotimg if
 necessary
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.17.0
References: <20240602130656.120866-1-npiggin@gmail.com>
 <20240602130656.120866-2-npiggin@gmail.com>
 <5b63cc59-88ec-45a6-947f-7f44e8e0bbf3@linux.ibm.com>
In-Reply-To: <5b63cc59-88ec-45a6-947f-7f44e8e0bbf3@linux.ibm.com>

On Mon Jun 3, 2024 at 9:54 PM AEST, Janosch Frank wrote:
> On 6/2/24 15:06, Nicholas Piggin wrote:
> > genprotimg is not required if the --host-key-document=3D configure opti=
on
> > is not specified, so avoid running it in that case. This prevents the
> > build message:
> >=20
> >    bash: line 1: genprotimg: command not found
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>
> This solves the immediate problem but I think we're really missing a lot=
=20
> more checks in the makefile and configure to sanitize the SE option space=
.

Agree, it would be ideal to find genprotimg at configure time
and warn or fail if other options were specified. That looked
like a bigger job and I don't have a PV environment to test with
at the moment.

> Anyway:
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Thanks,
Nick

