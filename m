Return-Path: <kvm+bounces-18524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8350A8D603C
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 13:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 378081F24CB7
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39212156F5B;
	Fri, 31 May 2024 11:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cvdBpv7K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E146B156F46
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 11:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717153582; cv=none; b=rqmQKonsbFg+Vx2lJxayu+tCAc0/LqZKdioXoLqj9LJVGTr9dtjXKtwPCCrcL4+o26rZAPlpclsgHOY8wnECPhugDcDANRRDuvQ+7fO4YAY101e7FWypIQbYaGmlH8MXnxp2EkX1dvnfpdkduIfgB/J7xQ7l7KDzderIRT3TFAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717153582; c=relaxed/simple;
	bh=YBf0IapRAGeH4U9EkZTRJyClYUbpIhn1WOO52mODM0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rsxVcyLBK7hlDWIh/aHysawCPMIkPcngxe7S+h+hE3+UVYwykwxZYEsxgH3CSnHV1zijTGH+nVYa1sw8+ltb/OyIlRborgemUmTSe8ibCJaqSdYYNOqew9X5s+ExQn9RfANnA38W/UuugE7fBgStXxYHbHN65oQamknIsPm1e5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cvdBpv7K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717153579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vRRVsxgJ+xlaVE1gMPFs21sTlE+PJ7PzZr1qcVkiRno=;
	b=cvdBpv7Ku90jRfFbzFaY3mRYDjTJv08qcErS52XU+ddGBBEDkW8B0z6qQRM8bPDQOZ8uoi
	2Y/dknm4dSEYDETy8uQnN3ECpbvXDdupuc5V41BUh/v45PCzGv6GCPcthyt4qtet5AVFU+
	LOt2f9P9lUSkDzFkeOBlqOIhJyoClis=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-TU34xe4jPAOOHcXavXiXWA-1; Fri, 31 May 2024 07:06:18 -0400
X-MC-Unique: TU34xe4jPAOOHcXavXiXWA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3580f213373so1315949f8f.3
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 04:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717153577; x=1717758377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vRRVsxgJ+xlaVE1gMPFs21sTlE+PJ7PzZr1qcVkiRno=;
        b=IBCVDqFzzlzGnY5nE5PfXFp5VxiEkLPoDHuJNjey49ObIZGGnimm+fEbmXCsl6psRu
         FAUmzz0t5agBwhPa5cnFIUnvO/6gVG4V6+UWvU9sBkww28EaO0yqU1+P+6xJlazfUgv7
         MIxD2XTRYnbq73OCr0cqbPXPcm7EQpIeQJZJru8Txt4pilIrmjlIT77/NwAF/RPJkC/D
         deQAmOeWYhb9BYaI1EEvI77AVVOdaPeJSpJVq0aT8z1OVtWPdqeAkN6OH4QU8f2bCpcv
         3K+tWhyZhgnzmR+/Ij8BFWWtBl+ELK4XuFqZSTMUVUrxM3vD5QC8vOctBtPzzBXQBy2s
         l/OA==
X-Forwarded-Encrypted: i=1; AJvYcCXH8K1VRYSTMKJuQWoyl/5pjev+4SWfTXSkcU7qLcWzPn5ubyIuR4xhC7AIW1xg/+6XBcjfbFiGI8nob/yNHxGOc+4/
X-Gm-Message-State: AOJu0YxWUHkCzZeKke008bpwDVDF5MuPfNhedEtLyn5/dHV8lCz3Z3p2
	729HhcyASGfr7y10MrsIHKxe014CaJkm1Zs95ZI7GtyicXvATLTDK9yssHhaWxpCoMQj3NNIJ0/
	kfQWxCQX0CzzXWEtFRUJwCaq/8uH6dOxwFpCpEK/JpqyRJWTyfQni1iZ6GLnYKV/uNLAJKgwiMt
	og5TGdDORdcaACnEEjnz6EVpJm
X-Received: by 2002:a05:6000:4598:b0:351:c2c1:3682 with SMTP id ffacd0b85a97d-35e0f333d40mr885470f8f.62.1717153577366;
        Fri, 31 May 2024 04:06:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9LhlxVxdWcPVZ7UT4uT/GzA+K2roO4rSI5/qG3wo0fDKKrOV8w5n7Xh5wepQ95vSEE0IxZBrPYOCvWtrXD18=
X-Received: by 2002:a05:6000:4598:b0:351:c2c1:3682 with SMTP id
 ffacd0b85a97d-35e0f333d40mr885454f8f.62.1717153577024; Fri, 31 May 2024
 04:06:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com> <20240530111643.1091816-8-pankaj.gupta@amd.com>
In-Reply-To: <20240530111643.1091816-8-pankaj.gupta@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 13:06:05 +0200
Message-ID: <CABgObfZQHq0NOs1BV60-hV=9SLBu+ZfBKTnH4WVg5Vk5LcSxpw@mail.gmail.com>
Subject: Re: [PATCH v4 07/31] i386/sev: Introduce 'sev-snp-guest' object
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 1:17=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.com>=
 wrote:
> +++ b/qapi/qom.json
> @@ -928,6 +928,61 @@
>              '*policy': 'uint32',
>              '*handle': 'uint32',
>              '*legacy-vm-type': 'bool' } }

Nit, missing empty line here.

> +##
> +# @SevSnpGuestProperties:
> +#


[...]

> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index c141f4fed4..841b45f59b 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -42,6 +42,7 @@
>
>  OBJECT_DECLARE_TYPE(SevCommonState, SevCommonStateClass, SEV_COMMON)
>  OBJECT_DECLARE_TYPE(SevGuestState, SevGuestStateClass, SEV_GUEST)
> +OBJECT_DECLARE_TYPE(SevSnpGuestState, SevSnpGuestStateClass, SEV_SNP_GUE=
ST)

This separate struct is also unnecessary.

Paolo


