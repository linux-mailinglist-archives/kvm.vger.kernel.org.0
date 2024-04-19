Return-Path: <kvm+bounces-15258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8BFA8AADEA
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76D1F1F21C13
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 11:52:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D9EA84A30;
	Fri, 19 Apr 2024 11:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QvHM1QVx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49961839E6
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 11:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713527561; cv=none; b=DPfTgK5xFvi7yvfAuPE9sbSIivJ3IMdYUDEOD6v0CoC9RrakfhN3qolhlf+B568eGV5Kq5smACBEViiJFRSJVOVFgnzVsKPz9KhaiBIfs/zKYE9taQRJlPGWUXpb2RthWbJ9oaABkCJCKWNXReda6vgJRtckVPHYa85iHip9Jak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713527561; c=relaxed/simple;
	bh=+HnpYIljW903ODlD5/xLD4aOITxYFLDumzggzFZ3LXU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e5gFN6YbBTK0SnTmj3UjB/IsYd1ib3FDCGAEsZLYdNMYx3I9AXbNDCRUYzZS7yPuHtuDAY33Q5+w1euyM5VGaVrN5kSTOHEWl7csoXszEh1RbWnnEHzBjxStvafw4RLMvRWnh0nQlebBumn6SfAr9RyWar+J3yDn/w98JUvPhJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QvHM1QVx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713527559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+9gAW74TdLSgAKKdOeHRcIuNI+2QlXI+dYyfePDOsqM=;
	b=QvHM1QVxXd24ATflP4j3EP3JLsgHH5oOiuRX4z2SfJmPwCr+muAzsDosE8SrJGYIY7Jhc9
	inL0nS2Te9StRN2JXrNa7BuxSxoI4el830nrv7l6tByDJrXGMh0N0Msr5f4+Ke4wlFuhnr
	Yg8V0jb5hVKk0kuRJ51c8ZDua88CKOM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-N3uDS7A0Oi-7sxuInGrc6g-1; Fri, 19 Apr 2024 07:52:38 -0400
X-MC-Unique: N3uDS7A0Oi-7sxuInGrc6g-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-34a49f5a6baso586849f8f.3
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 04:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713527557; x=1714132357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+9gAW74TdLSgAKKdOeHRcIuNI+2QlXI+dYyfePDOsqM=;
        b=MHW5+TI6YeybGZEW0EAJOoKoijoQP90bCs4hoD7re7sN56gLVBxluktTsZPzE6Znx6
         4QRtB6uXnrLV8sLRb2kGjP2jbkfbfyJXCI2E0doJ3BfbhGTQieXZbrdMZT6H25zXeQRH
         8f4lf/kM7h2gpaS/LwOl1WSdSfCFCAn4KoTZRRcADNAXZs/acNg/xllsfTFwaHDprHMj
         GYR5L+qmNtBbw+2l1R8MV+XNuIscGkUpCPtUVH6yHtLQ+C8vBtWrKYfuf8GdjAEGJIyF
         cZovZ5dPM76Db/XNSKrZ2qbR5mQlDvLyLw6eByZaZj/8BGBlgF99zxIO1C5AzYllilyl
         Rryw==
X-Gm-Message-State: AOJu0YwxXttaM4jVJ5UvznsiVSmEa3Rjvj+fkjZI/lJHjWatjdRFvrao
	YNMjIuGoV0nkho4yu2EOxEKj+Rj1kfB/nSXvH6xx1SVa7UjqBaWYeSxoNlu6cP6hj/HZqGG0nlO
	X0Jb507BLcsXTGnQgwL9kdvFyLWpdNJRY8uazr8Sau9lyb5lmW5rTeVh3Xppb3lIS077yjyHAbt
	+LyYy2LudwiUsjBFYfKWzo1u8U
X-Received: by 2002:adf:e683:0:b0:345:605e:fa38 with SMTP id r3-20020adfe683000000b00345605efa38mr1433598wrm.60.1713527556824;
        Fri, 19 Apr 2024 04:52:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfUJrGef9Pu8qycGP8hLzLT/FO8q371w7fw92YbXK5+2PaDsTI6UQGUVVeBTULcSVYlzzGDl9d79lt6LyM70w=
X-Received: by 2002:adf:e683:0:b0:345:605e:fa38 with SMTP id
 r3-20020adfe683000000b00345605efa38mr1433571wrm.60.1713527556446; Fri, 19 Apr
 2024 04:52:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418194133.1452059-1-michael.roth@amd.com> <20240418194133.1452059-10-michael.roth@amd.com>
In-Reply-To: <20240418194133.1452059-10-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Apr 2024 13:52:24 +0200
Message-ID: <CABgObfYztTP+qoTa-tuPC8Au-aKhwiBkcvHni4T+n6MCD-P9Dw@mail.gmail.com>
Subject: Re: [PATCH v13 09/26] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
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

On Thu, Apr 18, 2024 at 9:42=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> +/* As defined by SEV-SNP Firmware ABI, under "Guest Policy". */
> +#define SNP_POLICY_MASK_API_MAJOR      GENMASK_ULL(15, 8)
> +#define SNP_POLICY_MASK_API_MINOR      GENMASK_ULL(7, 0)
> +
> +#define SNP_POLICY_MASK_VALID          (SNP_POLICY_MASK_SMT            |=
 \
> +                                        SNP_POLICY_MASK_RSVD_MBO       |=
 \
> +                                        SNP_POLICY_MASK_DEBUG          |=
 \
> +                                        SNP_POLICY_MASK_SINGLE_SOCKET  |=
 \
> +                                        SNP_POLICY_MASK_API_MAJOR      |=
 \
> +                                        SNP_POLICY_MASK_API_MINOR)
> +
> +/* KVM's SNP support is compatible with 1.51 of the SEV-SNP Firmware ABI=
. */
> +#define SNP_POLICY_API_MAJOR           1
> +#define SNP_POLICY_API_MINOR           51

> +static inline bool sev_version_greater_or_equal(u8 major, u8 minor)
> +{
> +       if (major < SNP_POLICY_API_MAJOR)
> +               return true;

Should it perhaps refuse version 0.x? With something like a

#define SNP_POLICY_API_MAJOR_MIN    1

to make it a bit more future proof (and testable).

> +       major =3D (params.policy & SNP_POLICY_MASK_API_MAJOR);

This should be >> 8. Do the QEMU patches not set the API version? :)

Paolo


