Return-Path: <kvm+bounces-9295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF96785D55E
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 11:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E2971F23789
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 10:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036323D993;
	Wed, 21 Feb 2024 10:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WQlVpaQe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861933D0DA
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 10:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708510942; cv=none; b=S2BP1Cffoah497iG0AINam7v2SOf7u2u0ZuttusWqe6p7k5EuNcujB38cU4ZsFiWaUdOx2o+9cyhVq7yWiYNryQstu39TUhjy02KRr4ta8t60YVxBAmWiFu5W2W0tf9nJLdzhah2JC3ixYLkK9a7DYqB8IUqjzlygpcrfM/5IMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708510942; c=relaxed/simple;
	bh=MBN4tZLx9uqlClY2UUZIW6lED/pYey1dCXSJvx+odk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cerK3hHww2ZeQJESt9UlxC0gfeMwqGIPw36hNkZLnvQTUuR8tZ2R9l2DKrpu1aYB+e+tq+yMcqnmScwYGJwb7BK83OR+eKN5j+jKn7QgBTJibfuiTzhUI1FBqzcnsOADCys6Pk+1uQILrGcwn6J5MY8u2Fj1sXlaf0oRsMqVB5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WQlVpaQe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708510939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MBN4tZLx9uqlClY2UUZIW6lED/pYey1dCXSJvx+odk4=;
	b=WQlVpaQeWj2rnm5yxXRM1Omy6ATS3LztonftmdqBrSc8LFvJS8HdgOTPjkHmbv0pP+ew9A
	jjNcK6yFi0lwPJgqfoVUT50Vl3s++DX+4EtV8yQn2LRe6hRBWDUeOaxnsq0HDIguG60oB5
	8g1K5ZRUWHdloKRo9O4LLPAQqQCh34c=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-yGpYb6moPl-9oGkMpMhYNg-1; Wed, 21 Feb 2024 05:22:17 -0500
X-MC-Unique: yGpYb6moPl-9oGkMpMhYNg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33d6eb5e5a9so827562f8f.3
        for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 02:22:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708510936; x=1709115736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBN4tZLx9uqlClY2UUZIW6lED/pYey1dCXSJvx+odk4=;
        b=SjkRZUKaOvYT4GJ4G3VgDWIDSIA6geb4geXvlByXKKnjaf7I1SboEjpm6NWN2QPsZU
         gokDUB/SJLOneiyh/Q9gXBfpwvNlIgSRDIDWUD8Fex7003mZUddcnqzS8I5lX4vOUzs2
         LkdMvYGfHmFWuSElJgdBkIF6Iin5pc9J+/CL8BdxESu8rycNAN0Xwv7OH/m1AYkM+g2a
         EQ5xIB53aHhQYryMNGle3Gxus0XtubDoxLTYNN+DQHju+nN1S2VS7U9K2NBlTFWZv6uo
         6oNqonVIgmTi9rzNWYXuvyajKH7WurQaSPSc+SkPfMnvzAh3dnEMkNyvxWFiPt+xj4XX
         KX/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWQ6T8mX5osEMpPoFWRCp+inB2JrFJ3YHoGqal9Njh07EPOIvS3Aex9BB38QBfNqphdOaiWvCTsg7F4MPwA1vV8a/bF
X-Gm-Message-State: AOJu0YzyvTgQHIDR5fnaFsPem11c2CYjvtT+3BXhkUjRSjPGL5/7G5er
	kOGzrk5/S97jzl52WPtmqzJBtz9ibfsJJ3iA/r00ZjTRFp6rddiD02ybSYlDtMAP5swwWfUaRu0
	IEcsM2MKMxRSEKRNL7vNp91jbo9YYlzNzs2GHSyRMc7SFjtaAQCqIUyI0+BXszpXenMNOUkdHQT
	xsdQIr7q9w5ZaPGTBKKiZZORDV
X-Received: by 2002:adf:f187:0:b0:33d:82a:14af with SMTP id h7-20020adff187000000b0033d082a14afmr10422416wro.64.1708510935908;
        Wed, 21 Feb 2024 02:22:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEvDqSnBb58aQpo8cE5SEQccLaBDo+ZMPgrcp5t1F8E/OswfeRU0UTussQ1HTHhX/5fllx61sBxucn79Zk7EyY=
X-Received: by 2002:adf:f187:0:b0:33d:82a:14af with SMTP id
 h7-20020adff187000000b0033d082a14afmr10422408wro.64.1708510935638; Wed, 21
 Feb 2024 02:22:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240221101711.2105066-1-maz@kernel.org>
In-Reply-To: <20240221101711.2105066-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 21 Feb 2024 11:22:04 +0100
Message-ID: <CABgObfYhVK+qF25h8+hhuyCvbgfpocDo0UDac3CTEHghRGww+w@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.8, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 11:17=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Hey Paolo,
>
> Another week, another couple of fixes. This time, two fixes for the
> ITS emulation that could result in non-existent LPIs being used, with
> unpredictable consequences. Thanks to Oliver for spotting those as he
> was reworking the ITS translation cache.

The consequences would really be NULL pointer dereferences, wouldn't they?

Pulled, thanks (not pushed so that I can adjust the merge commit message).

Paolo


