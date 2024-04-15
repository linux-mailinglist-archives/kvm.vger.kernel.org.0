Return-Path: <kvm+bounces-14634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C97CD8A4B9B
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 11:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 403901F22738
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 09:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E59947F69;
	Mon, 15 Apr 2024 09:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="io91Ie+E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CA43FB99
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 09:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713173810; cv=none; b=j62auce4D0JJxk0CeMYLf5NtNbwrrzfDnMYMvfSbPErqJoh+oIXdqVoF03fO3V0L6l1yV+Roe+33jSFR0a0tr2avNauFV7xHcVez/bHOr3nwIo1VtnyrmmVE4u1cXFLS1jL833OTYB0eCSCOKQFMkp2QPF2yMqL9SF5ufd+Z3Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713173810; c=relaxed/simple;
	bh=sYu9CYOIKB5l1TfXf/Jun3yt971AqlY1Oe53lKaH+04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AGcxPoSjAKKlJfr/ReerA5WrjdONoqsxNDTO6qLVIkU8pogwMaLVLYHJXxjf8oYn4htuWIrq2KmEBnXCRpHzrqwxZdWvQvh0z3s7mg7lF9ldvFxyrP6OEEcDNzIKAGvGJqCDFvbcKWGC90BLTzHKmZKfnjwi4yf3GfzB6tKADaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=io91Ie+E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713173807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sYu9CYOIKB5l1TfXf/Jun3yt971AqlY1Oe53lKaH+04=;
	b=io91Ie+EFnopmF7Z//gog4sF7fVPHcvQL43DvoY+xrWloQhv3mihcc44a7QRLcOCjLls9/
	cM4rODk6aUDjVErgtvcS3yVhtclv8kfCq4aGQp1YrFscSpPFCfxbQ62KgXT4TUnW0rHvmW
	ag1WSELLTkqKY91w4YYsBxyrTpbjL2Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-LMxogufrMHKKkRBrNNzaLg-1; Mon, 15 Apr 2024 05:36:46 -0400
X-MC-Unique: LMxogufrMHKKkRBrNNzaLg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-346b9be0a66so2448023f8f.0
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 02:36:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713173805; x=1713778605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sYu9CYOIKB5l1TfXf/Jun3yt971AqlY1Oe53lKaH+04=;
        b=X2DgT4ohaAUGD/8Cx44bWgOo3s9rpzGAIRdNoNarzkZseWwnd/KgAYquHOppzhYrFk
         dZDfnkVH+ulcsRxiItUSi+jsuZZwDI74Lh51ThvHSPSEOniJdfqCMPB6W9jYn/ldBquR
         PdiMUYFt20jOdteOXAWGsYpATxa1Qu6Rad3U/Mvx0lmG5Ua9jAb46vR4VCEfO4eyDWYM
         ATrf1/w1RyyrMqB7Cmxcw02bJjgwyVI9ycgKoS4HDDPrjuwwK9ShifvTn0NbUZ5c2yRn
         CBbneoyazbBjQX4sa7fjWFT4Lvc3c81hmZYJu70L7/51r4WC8qbjMEHiz9koBL4J84mN
         dt1A==
X-Forwarded-Encrypted: i=1; AJvYcCV1ZdPftQY4iiPb0Upfzz57i7/MwNMdhOFTLSBjGTVSZy4GozXR9ZNZnzNVN3nlk9XNTvYiDKu2pZUJ613bSPMJfyua
X-Gm-Message-State: AOJu0Yx1nNU90ei5xOLB9Con6vl919+O8igd1FnOSkn9cQFIHYvk01ch
	yUdZIXE/oLYMHs3pBPwEvFmtH0x3XAqvWZmp2M+PY8N8auxGZrLYO5kErXvgPsVTPo0DFlhjxF9
	3VZQEQ961KaKeiWSx3kbb/aUrqZXfkDDLuEml/1XJbJV03GvtLMy739HBo0JjBqhI9IKsr/UM9K
	B7cKeLca/C2r5KTVZG1tuu4+kK
X-Received: by 2002:adf:fecf:0:b0:343:7116:815e with SMTP id q15-20020adffecf000000b003437116815emr6536015wrs.67.1713173805485;
        Mon, 15 Apr 2024 02:36:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9VyZ4cL1gMt5C3Rm1mGMeCbp0ev+ZnK3ISZDwjaOKhsE/5f1c9W3T/BTch/CNZkcUDNliLoFPQCPyAXOe+kI=
X-Received: by 2002:adf:fecf:0:b0:343:7116:815e with SMTP id
 q15-20020adffecf000000b003437116815emr6536002wrs.67.1713173805166; Mon, 15
 Apr 2024 02:36:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <20240229025759.1187910-9-stevensd@google.com>
 <15865985-4688-4b7e-9f2d-89803adb8f5b@collabora.com> <CAD=HUj72-0hkmsyGXj4+qiGkT5QZqskkPLbmuQPqjHaZofCbJQ@mail.gmail.com>
In-Reply-To: <CAD=HUj72-0hkmsyGXj4+qiGkT5QZqskkPLbmuQPqjHaZofCbJQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 15 Apr 2024 11:36:33 +0200
Message-ID: <CABgObfbvkuCHT0sFFdJbGHBD7k=QbU9c=kA4xYE4j4S2Mu46ZA@mail.gmail.com>
Subject: Re: [PATCH v11 8/8] KVM: x86/mmu: Handle non-refcounted pages
To: David Stevens <stevensd@chromium.org>
Cc: Dmitry Osipenko <dmitry.osipenko@collabora.com>, Sean Christopherson <seanjc@google.com>, 
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 9:29=E2=80=AFAM David Stevens <stevensd@chromium.or=
g> wrote:
> Sean, is there any path towards getting this series merged, or is it
> blocked on cleaning up the issues in KVM code raised by Christoph?

I think after discussing that we can proceed. The series is making
things _more_ consistent in not using refcounts at all for the
secondary page tables, and Sean even had ideas on how to avoid the
difference between 32- and 64-bit versions.

Paolo


