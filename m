Return-Path: <kvm+bounces-13575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED3B9898BC1
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C4AC1C21AC2
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 16:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BA5512BF01;
	Thu,  4 Apr 2024 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dcnpwa/B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A15A12AAE7
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 16:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712246655; cv=none; b=GDAkIEdU6dOPZ/mdKAsPkB7wJvFgMpO7tl3894wXEqfVkWiast2hpGC5SpFpIiv2Obu7q/ruUrwzcch4vHUfDw3m92LhJ8aNU0E/YSEvnhMHd8w2ooXc0wkl3RPe6ro2XRx3ukcJP6CdcdY561lo4DN33pyb7viFGdXcUzzsJnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712246655; c=relaxed/simple;
	bh=AYKWp+p64k+3RQGIf/6q/yPwgymf6ydLwHfuSidhdYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H8udO5TK/H9xc1Mr++2TPgbLC6OIkx8GELqvQevkioleHN9kZJSYLYxrM0DLYBI2+rQajs5fXswJgXBnQ0DBf8b5fboTbYy6w2NgXKZMwtDXTxBFse61Pw60JcEpicwthHmQZMpk4oPaBj4vtAiHU2shdHfaiYDzoh8S4fd6oIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dcnpwa/B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712246653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hvQMa3e6aa+6chnorpY7KHYDJwijcL8jvc2jYGypk/c=;
	b=Dcnpwa/Bbxm5FsaLuZOAR0eF1dmOwHgqNyn7q8ZY7ku9xdRvesE8iZmZfW7gHRnl9c8Y4/
	xc6hZYV/h8RgJVUZoLAskMSNLZYX12YlQJN8PV0k/RwPiFcXearHCq3Ej5MfSLW0+mwLSz
	6J3uJrJQ6t1nzwnHD3zaB31XZgmXR3o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-rUkZETiZPPOHNUYkSyEQmQ-1; Thu, 04 Apr 2024 12:04:09 -0400
X-MC-Unique: rUkZETiZPPOHNUYkSyEQmQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-41489c04f8cso5720035e9.3
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 09:04:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712246648; x=1712851448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hvQMa3e6aa+6chnorpY7KHYDJwijcL8jvc2jYGypk/c=;
        b=TsXvxJbbAUMdNqPz1bjNNuifeTcPFbIYE687KnjqAVJE5yAqdaamN8eZE9M7EbUqE8
         SIMShBpyHGXAxUkbLZ+VI3IQuKrH01sDkNSUrbzRvdyB6YM3kfKnsI2NgyOjRxPjCi6k
         e9SXplzdI5C0zACapMQf8t90Dd1z4lxFIEy0O5H4ubSp+sfKpZRTTAcktaFnvVSWjl01
         ddQjTb9lNKzBVsYWPyRYCVyl0K7HxJly/vPnTeCRGMq5gFUZQiuKXSJj7un9xQJqaNxV
         2BXVBvRDB3PPRCNEbiGh0UdnJMxC/coJBQ2t5m1PT1FkeOlCrMG74lr+fzCEscybC97z
         YBsA==
X-Gm-Message-State: AOJu0YxZlcbt7VQ9btEFbFCsOIXvIPAqG0ysmc7wTwXTyq9c3Yb6RmAu
	9f+gHvkVRojRxJMKxqke7gHmfr98lfvuNXBEboKyThKnC0kaRrIbBNwh7gt4J/IdY0m4cIH3wGA
	M+mb6sKMXKikDFxKkSCeAcbSGWE2V5MA889iOHYV/JRy0HnhmWN8/oLlnFZbOCqNPVGXVAGY84Q
	Hi4maZywH5WXjUisA+tY8rvxDL
X-Received: by 2002:adf:fe0a:0:b0:343:b0b8:d68f with SMTP id n10-20020adffe0a000000b00343b0b8d68fmr18340wrr.25.1712246648580;
        Thu, 04 Apr 2024 09:04:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9lMpRrvRHs7aq9HiR8B7m2xP5O9kx9uCjd68Psn0mas4tU/87cr01m6gWW8MfdNwKQqtC9KSc5JGf2m+NNJ0=
X-Received: by 2002:adf:fe0a:0:b0:343:b0b8:d68f with SMTP id
 n10-20020adffe0a000000b00343b0b8d68fmr18315wrr.25.1712246648224; Thu, 04 Apr
 2024 09:04:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240329225835.400662-1-michael.roth@amd.com> <20240329225835.400662-12-michael.roth@amd.com>
In-Reply-To: <20240329225835.400662-12-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 4 Apr 2024 18:03:56 +0200
Message-ID: <CABgObfaGNsAva0t0_gm8m0QANaOU7d-EeHvcShJSpCozoJwDnw@mail.gmail.com>
Subject: Re: [PATCH v12 11/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 30, 2024 at 12:00=E2=80=AFAM Michael Roth <michael.roth@amd.com=
> wrote:

> +static int snp_page_reclaim(u64 pfn)
> +{
> +       struct sev_data_snp_page_reclaim data =3D {0};
> +       int err, rc;
> +
> +       data.paddr =3D __sme_set(pfn << PAGE_SHIFT);
> +       rc =3D sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +       if (WARN_ON_ONCE(rc)) {
> +               /*
> +                * This shouldn't happen under normal circumstances, but =
if the
> +                * reclaim failed, then the page is no longer safe to use=
.
> +                */
> +               snp_leak_pages(pfn, 1);
> +       }
> +
> +       return rc;
> +}
> +
> +static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak)
> +{
> +       int rc;
> +
> +       rc =3D rmp_make_shared(pfn, level);
> +       if (rc && leak)
> +               snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT)=
;

leak is always true, so I think you can remove the argument.

Paolo


