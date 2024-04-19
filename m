Return-Path: <kvm+bounces-15329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3868AB30F
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:13:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 965CA2844C0
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E317130E4F;
	Fri, 19 Apr 2024 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HIZVcVIu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768CA12F376
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543226; cv=none; b=oMBaNRdh/FlEmrM+QDQLrWKoLHgGcYnS3DRXzebk8wjARHAgjuCP52RBZLMkrGzecQHUDmYCHhyUVh/i3DLMaJqmct6EU4IaIGUpiHw+ICNkjZhz2dJ90Yw6zzM4XAjq9VVFXhMMx6jGBrEB768tMLX/WIENIjqcqUmGj4Am83o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543226; c=relaxed/simple;
	bh=nLxECB9bMpQI6z8V9G04dNBlY46x4K0VVLSohnbBzYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EYFzRtdjPF5qSCUvkoLPDDe7Es3jtuF7XhNuQK/0oi1M2pz7pahpLTTCFdg4tYKCfJ+jRvJmknOKGRqG7fHvGYLoYX2M6VUOs2BXRAQufcaW0tb1SYxETHBDt3t9grP+nlg9ZlknZPR0VlQNIZSxJQbn1BEo7al69cT/U1IrffI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HIZVcVIu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713543224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nLxECB9bMpQI6z8V9G04dNBlY46x4K0VVLSohnbBzYs=;
	b=HIZVcVIu5JU7nFfDo41kCjTnm+RMgxeVliRcaRd/FHxUsqySdBFjsazv93AKd2dyKUQzCF
	Arbfbhudwhq6HnC0OoX0Y9vT3x2OlDjW/dbJYJRPAp93LRxgfDj6DtACBbmZK6yPzzJTrt
	k03tIz8HxfSLX6T3jnboMr9pXrM7uwc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-4Hr_V32fNhm0PZpMPiUD2w-1; Fri, 19 Apr 2024 12:13:42 -0400
X-MC-Unique: 4Hr_V32fNhm0PZpMPiUD2w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-418a673c191so11420655e9.0
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:13:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543221; x=1714148021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nLxECB9bMpQI6z8V9G04dNBlY46x4K0VVLSohnbBzYs=;
        b=CiSbs09gz9/plC/qc9tuXR0lr6jkwm5+o+FubUazwDBRd1LsgtrlvbH0rkqGNsiTc1
         SQhzB0XVyZng16m3oJu41NiDR8FQ4llu9HlycfYqZ0e9vtfNCFklqA1xq1xmhoRmK7T6
         8LOV9rCJWYXFZfoHw09wInPwMFD5djmCNQhJTiYyc85v5LqUAR0IofbW0R4K0WxbZ6KV
         rTqIA898z3C8B76KcFfiaeXjRGDXtBtbpI5w/qQ82UdKSmVtXvybaVPZ4TUAHlq2d2kc
         zAFJ9QV34mv8wTmXWIdzNRbd/EOEer7UyYaP7cMlwJwK+wke+qS9r8ag9aRrdYBJTaVW
         S38A==
X-Gm-Message-State: AOJu0YyWorIfQjyCsdwhLbCgnFKd1E5vnD+1yj90ZVhlrUuVJE2nNFYo
	w/XYIGcbowo+6ltC5nzXoIheIN2dphfl8JSdJZFVyK14PaUBH2UdO6RAxat2S6FeRvq7krMbJ3k
	k7qCKvDXkVUOQ1pJuDYgcPyYxnbL6oT+HJOpYtERfAslZr516nUMVzevKpXkaNaPXGuZ6ibYQ/a
	ZZYRCRXcCfM1Rxq7KG4HT/Azlt
X-Received: by 2002:a5d:5265:0:b0:345:66a1:d949 with SMTP id l5-20020a5d5265000000b0034566a1d949mr1596277wrc.0.1713543221703;
        Fri, 19 Apr 2024 09:13:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnajPMHcMdpRY04h+TNXdbRj7g/tI02Iw0JIqVHCpyfHEB4naUbmsOShyxFazrDJ7rYEXw5oIH9VgniqhruMA=
X-Received: by 2002:a5d:5265:0:b0:345:66a1:d949 with SMTP id
 l5-20020a5d5265000000b0034566a1d949mr1596246wrc.0.1713543221365; Fri, 19 Apr
 2024 09:13:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418194133.1452059-1-michael.roth@amd.com>
 <20240418194133.1452059-10-michael.roth@amd.com> <CABgObfYztTP+qoTa-tuPC8Au-aKhwiBkcvHni4T+n6MCD-P9Dw@mail.gmail.com>
 <20240419141920.2djcy6ag3peiiufn@amd.com>
In-Reply-To: <20240419141920.2djcy6ag3peiiufn@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Apr 2024 18:13:30 +0200
Message-ID: <CABgObfapuKAVHwMpQbAxMu5WJCz19twSpzRGbPannQ68-vPU6A@mail.gmail.com>
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

On Fri, Apr 19, 2024 at 4:19=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> So my current leaning is to send a v14 that backs out the major/minor
> policy enforcement and let firmware handle that aspect. (and also
> address your other comments).

Sounds good to me!

In the meanwhile I guess you can also update to have PFERR_PRIVATE_ACCESS.

Paolo


