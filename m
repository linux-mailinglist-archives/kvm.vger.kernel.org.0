Return-Path: <kvm+bounces-18528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE658D6058
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 13:13:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB92C1F23254
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27568156F5E;
	Fri, 31 May 2024 11:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L34Wc5f8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421E4153BC1
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 11:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717153976; cv=none; b=DF4X77af1XTpEPtbSD0DwOvelvlDaansGxLQFh4WFe8DQO5oc1BfAFywQ37OzuzEMVvKD3P8SFBIgzqSZQpLAMSYeklHDyMr4VWnsbmrfZIpWByZ7+JVwSt8bEHRrpw3j/wYv03cnfHsBAE2K3SA5m5Vxfi6xehiXTIAQAQpu30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717153976; c=relaxed/simple;
	bh=6165chaqQla40QHkFlvBoOIYkoSdrrj6X8WggzlGCCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ovQobizAmbnCiG4Q6Iu7EM+Du/cQifYYbsZbnlipbmd1wtvi7rCfmQULVkTGRA59zuBtFrQeChttSxtQ4hp6hMRrUdg0Tafz5tYGGKwg9k26GjvWI/F0q+i1qi2I2t6JcrjtpiFoWQT/S0VaHw4eXjSEKXfi3m1nzNcCdYc7+y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L34Wc5f8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717153973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJ8KNJuQJ+2POJtaJdqo9IYMUJVBojTDcmu1dLhG5/g=;
	b=L34Wc5f8bYvxEiSRjicEPVCG0lGx9VLNCM3AxV6p6HKxq0NspJ2QF5X5W4+AUK0PVIOopg
	SaLHRk9cykPut+2hMqiFIjew6deweDDZXW6vvgRTC6tesvw9mu0NnJ9CLgsUYVipgtWLhN
	CvsGqLxIXvk1pI00lUOVc7hibqjlqcI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-Es7oErduMliuA6qzaQtB4Q-1; Fri, 31 May 2024 07:12:51 -0400
X-MC-Unique: Es7oErduMliuA6qzaQtB4Q-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-35dbf83bb20so1155708f8f.2
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 04:12:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717153971; x=1717758771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJ8KNJuQJ+2POJtaJdqo9IYMUJVBojTDcmu1dLhG5/g=;
        b=K0E5fqQJf3oZllbie+hQ+Ll1i9FoYGYXD+6B3J9Mc4JajebuHSRXP2db+shaUXW+k6
         H6ZT+6cWWncyBjcY0gWz5qR3Z3j/QCYQz9tR7lfmMqbJTsDTKpNE756fHMqo6z8YhCBQ
         gaAxwIMf1fc+QJb/anW+9zrAjUflzQzMEHMVJ4cwe8hIL9j3X4lg7aNVcbD9uXN4nc18
         3xBHY5l29WpchTRBYbdHeakDUEn0KHtB6DocHGMsBpWrS4Nmhv2kw8CKswJw1eBc4Wca
         KZjBr1gcRr0i2KTc+VpXeY0zHVfHj3YVTOY2vutCTWuzHaFCPG3ZxGYIUgXxiOnBbRd9
         CaYg==
X-Forwarded-Encrypted: i=1; AJvYcCW/CdVxDHcWOQl4iaq35pfTfwLbhy0ha7JndB8aMiKstz8t8bL20cWLnF10FJkRPFzBxXeC2KsZVSt/dzWvJDZM5ITK
X-Gm-Message-State: AOJu0YyXoSamhzupKlD5cMaVFo/G9EqIywJ/23kYokSZ/WKmrnTQajUI
	sGLwDmyJ9DWB69NCEK93ptaOiYhAb7veYu3oZWds4Rg8Zqw0nu/aB2tUN7FbN48SCkw9B8GZLrc
	CsmW8lCtuSnv9cQetojt1rroMHSwC8fvXFxe61uWkDb04c8BKmydb2PANJX6LO61leQuqVE4B15
	m1dIPqaZnQke1ax4de+R8GBcyv
X-Received: by 2002:a5d:564d:0:b0:35d:bf85:6c22 with SMTP id ffacd0b85a97d-35e0f2a9c7emr1149864f8f.40.1717153970738;
        Fri, 31 May 2024 04:12:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGog+TbeCSMiKXPakxXxwYkTPqV+yPkF9xg8OZpS7HS1g3M3JCYHKIlLUmBtphO07AyegEKBb54FKFWn7U9Kmo=
X-Received: by 2002:a5d:564d:0:b0:35d:bf85:6c22 with SMTP id
 ffacd0b85a97d-35e0f2a9c7emr1149841f8f.40.1717153970338; Fri, 31 May 2024
 04:12:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com> <20240530111643.1091816-23-pankaj.gupta@amd.com>
In-Reply-To: <20240530111643.1091816-23-pankaj.gupta@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 13:12:39 +0200
Message-ID: <CABgObfbBGmZR98zDiXDDpw_K=k=4EoFhBtYT03ghDiv+HR_dwg@mail.gmail.com>
Subject: Re: [PATCH v4 22/31] i386/sev: Reorder struct declarations
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 1:17=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.com>=
 wrote:
>
> From: Dov Murik <dovmurik@linux.ibm.com>
>
> Move the declaration of PaddedSevHashTable before SevSnpGuest so
> we can add a new such field to the latter.

> No functional change intended.
>
> Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---
>  target/i386/sev.c | 56 +++++++++++++++++++++++------------------------
>  1 file changed, 28 insertions(+), 28 deletions(-)
>
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 831745c02a..1b29fdbc9a 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -45,6 +45,34 @@ OBJECT_DECLARE_TYPE(SevCommonState, SevCommonStateClas=
s, SEV_COMMON)
>  OBJECT_DECLARE_TYPE(SevGuestState, SevGuestStateClass, SEV_GUEST)
>  OBJECT_DECLARE_TYPE(SevSnpGuestState, SevSnpGuestStateClass, SEV_SNP_GUE=
ST)
>
> +/* hard code sha256 digest size */
> +#define HASH_SIZE 32
> +
> +typedef struct QEMU_PACKED SevHashTableEntry {
> +    QemuUUID guid;
> +    uint16_t len;
> +    uint8_t hash[HASH_SIZE];
> +} SevHashTableEntry;
> +
> +typedef struct QEMU_PACKED SevHashTable {
> +    QemuUUID guid;
> +    uint16_t len;
> +    SevHashTableEntry cmdline;
> +    SevHashTableEntry initrd;
> +    SevHashTableEntry kernel;
> +} SevHashTable;
> +
> +/*
> + * Data encrypted by sev_encrypt_flash() must be padded to a multiple of
> + * 16 bytes.
> + */
> +typedef struct QEMU_PACKED PaddedSevHashTable {
> +    SevHashTable ht;
> +    uint8_t padding[ROUND_UP(sizeof(SevHashTable), 16) - sizeof(SevHashT=
able)];
> +} PaddedSevHashTable;
> +
> +QEMU_BUILD_BUG_ON(sizeof(PaddedSevHashTable) % 16 !=3D 0);

Please move also the following lines (SevInfoBlock,
SevHashTableDescriptor and the GUIDs) as they are related.

Paolo


