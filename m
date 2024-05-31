Return-Path: <kvm+bounces-18540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF5A8D65F2
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 17:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3EACFB26462
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 15:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4905378C6E;
	Fri, 31 May 2024 15:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eIwPqh6o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE391C6AE
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 15:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717170120; cv=none; b=Uh8xwoUDHnvwaWESGhr+3Anfo5B7e/g/V5d7liWVaxGBYMHlvQSBrZqaO9mv9f9EQnLeX8D57OZeNLzOb5Tvls90xB4CR9h2zsC/lT7jZqJUG3Wt9GXf2eaRS2TMZVQSsT9pqegfj01Uk993lq071xXG7MwXzwfubvscBGBwz58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717170120; c=relaxed/simple;
	bh=/iI39bkQXpKGLX7Ne7drO/nR8fRHc9Hh40U8SFKJr7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dj0bH91mDW3PF6wGj8BNfVgdHeCMb4dl2w3ItPuRAbbMXhQohg9IQIuLH9gwQXKj3rWdKASeqW53xs00gxolg716ewr4tmK9tSaajJUjlYuyQ9AnNq+7PQY51c8wLxozJlj5Nlz6QwCRXcHsJGtTdXY+h0DE0BOSGPpA/I1Botc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eIwPqh6o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717170114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qC/cbC73nnhbl/cIc7rPGNWp9f24AP4IKiaTi5mFi/w=;
	b=eIwPqh6okd58mrUclZem1stBBuaKRf/W1JPTuDFLZqVk3vCpXZ8JjrIqk/7507W1mT5JTP
	xAWm58DV2CfhUfjYzVvn0oZCAMfHDNHxxBiHTXEoUq+km2OabL10jFZL3XpUB8ESP1CKaU
	3ueIveZR1+RGcpyLvGj8EHXTp+6V0yU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-7zcDH0DtOwu5M8ufgNTe8A-1; Fri, 31 May 2024 11:41:52 -0400
X-MC-Unique: 7zcDH0DtOwu5M8ufgNTe8A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4212283a4caso16663445e9.1
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 08:41:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717170111; x=1717774911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qC/cbC73nnhbl/cIc7rPGNWp9f24AP4IKiaTi5mFi/w=;
        b=sXko69yxy1lDDLuUS8d9GBwa1+yaob/aKf+7lXsu98uYyphm3pQEoNNxsKgQkUDlil
         untHQ0V819+x/pT7FL5Kzo0XLe7hanX/ZNZ1nkk8wL2qUmd3hhns6k33k9bP601HwMHP
         0e+EaSfaUrniY/XOzR3BOmk0zzfB4ojhtpfSlMWzMhFQQWs2KJwsJah1jpdS5hxhVjSo
         JLaIwwV7pYEj6t5vpflZBV6E/UJG5lYOEvF6ljrdc/AuGsL4ph1FWqnHG29HKbe2B7PJ
         kCCy3zjVaVbMi6qxGjQq2GVpjouWNeVoLJszRC51cHn/JEgwDRUBfG9lZoTAlMYw2MSZ
         K3xw==
X-Forwarded-Encrypted: i=1; AJvYcCU9OcqMvv6kiv85Zl7Wz8ZMRAJEN3oNBHx8qM/Urt2pWC3zRQUPcnoSTurP890vUNDkn8mrgb6CoEMBKiuOctchulL6
X-Gm-Message-State: AOJu0Yy0KBOi8+mtTfNICr8mvCVcKDvzGYNQhlbHhJu9XUletRdBzMIG
	MSbUZOKfNHWJU1CRh+SCUGmOnP6MFtmo5PvX5dS5vit/M7QySg3eEELQCE9vm1jmD4fF7T50JlW
	IRUETbWeOpPsdN2xKvPKCDOX0j7cS90z3xOb5YHbhYDJhkOjALGixstQeQnXuf9GzQxIaHEswSX
	CpwCrtC0vhzEBGEIH0NU+tzh1f
X-Received: by 2002:a5d:5612:0:b0:354:f38f:6e68 with SMTP id ffacd0b85a97d-35e0f25a669mr1673427f8f.13.1717170111480;
        Fri, 31 May 2024 08:41:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHknQ24Wh1IuFhonT/McTlo0E1nMXrNxyPrEBrtjYxAoupsAnVtFwjKPxe/rVPXxm/1l8CCQGALu5V3ireduR8=
X-Received: by 2002:a5d:5612:0:b0:354:f38f:6e68 with SMTP id
 ffacd0b85a97d-35e0f25a669mr1673409f8f.13.1717170111158; Fri, 31 May 2024
 08:41:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-19-pankaj.gupta@amd.com> <792b99d5-9d18-42f4-a9f4-5621e2ae6a70@oracle.com>
In-Reply-To: <792b99d5-9d18-42f4-a9f4-5621e2ae6a70@oracle.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 17:41:39 +0200
Message-ID: <CABgObfbHvj_GiX-+E3zhLfrrw7S02-VcE0sEmj_nfuXWnwmrhQ@mail.gmail.com>
Subject: Re: [PATCH v4 18/31] hw/i386/sev: Add function to get SEV metadata
 from OVMF header
To: Liam Merwick <liam.merwick@oracle.com>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"brijesh.singh@amd.com" <brijesh.singh@amd.com>, "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>, 
	"armbru@redhat.com" <armbru@redhat.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"xiaoyao.li@intel.com" <xiaoyao.li@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"isaku.yamahata@intel.com" <isaku.yamahata@intel.com>, "berrange@redhat.com" <berrange@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "anisinha@redhat.com" <anisinha@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 5:20=E2=80=AFPM Liam Merwick <liam.merwick@oracle.c=
om> wrote:
> > +    metadata =3D (OvmfSevMetadata *)(flash_ptr + flash_size - data->of=
fset);
> > +    if (memcmp(metadata->signature, "ASEV", 4) !=3D 0) {
> > +        return;
> > +    }
> > +
> > +    ovmf_sev_metadata_table =3D g_malloc(metadata->len);
>
> There should be a bounds check on metadata->len before using it.

You mean like:

    if (metadata->len <=3D flash_size - data->offset) {
        ovmf_sev_metadata_table =3D g_memdup2(metadata, metadata->len);
    }

?

Paolo


