Return-Path: <kvm+bounces-19263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34B63902AD8
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 23:48:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2202284EAA
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 21:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A030212F5B6;
	Mon, 10 Jun 2024 21:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ke1eUZk1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B974D8C4
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 21:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718056111; cv=none; b=p9ViFAjAUVI+rVRdd8vN+0k89GxhlJ2C8n+MOCUJeEK2JO3dulVwCUob5TJ5M6Rsd5d92Cq1GAkG/GRNFJV/eePA6T80V6HKJ51i6qjgWMnOjO7x/2u0DBb92bPh93pZNTCHT5t0xTKQ4xjtgiX9rfaG7gaNL1sDlbM38wTCGQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718056111; c=relaxed/simple;
	bh=4DNhk0tBbhRDsReREFDU18jwJpkA17AW9GL7HzjSt/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l9BVlnWH8mCKdzXPAyHFQiy8WueV1yF+uem3T4nwO5g1qtW6/8/dc7x7fKz4RYanZaORJV5JhXd9wrj8ZkHJIwWc8p4IJq+gzl4vzpi4AqpaJbR3xYMt2KjePgV6YcQV/kqhPxx8zapLyCZ+OmrapGteqnQ6vGmf/TF6muNGh58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ke1eUZk1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718056109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dff2CxPF2YjERdeED1HYWtqzTOJbvY8otFDm3MW5gbY=;
	b=Ke1eUZk1BOKdFD+Rr+RdN5bTOsa7oXogOADJoKBrG+pKXRATokJJj4bkYYutCB0xy1I0Ud
	mhXbZJZwcj3+ZaFcuFJP8CmRUrUnQw3YHFrY9a4TSVvUhLvqcDAT1WH0alo6nTVlbRt1lF
	x7sG6qCOj4gPwCRQK3tiuHT1MkwtVeQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-33jbki1wN0K0H5QyM-1G-w-1; Mon, 10 Jun 2024 17:48:27 -0400
X-MC-Unique: 33jbki1wN0K0H5QyM-1G-w-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-35f2760ab86so873908f8f.0
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 14:48:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718056106; x=1718660906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dff2CxPF2YjERdeED1HYWtqzTOJbvY8otFDm3MW5gbY=;
        b=bdYuJGkmFL2H3L2GJl7YWjxLQF72XE5wD8q+q/DQmGImEB+tAoku9kqjfmwRfqp95O
         pg9nmvB9cyrT3fu/guDIhHXWxZ+w9rYIsM0EEovjyD3aHrG7vgrRA5BCWR9YJqE8qsht
         2PEHYDjUPIEEQmPBBrIDasKIfKG5FYw/iGmiEH60cKAF8X6cgd2OY2Sv1C0roBn42nuT
         DA/D7K09gzreldQS91DZ/kpAZF2HIT6UDNgY0odNvVPLJJ/4FSdPJ5EpththWToTKARX
         xZ2lf/G9krwVqOpmRQxVjpTTRUFKZW8+g9oqtY1HfdPfhhLoX99tB89IMF9Tkc2viwyk
         GEYw==
X-Forwarded-Encrypted: i=1; AJvYcCWctTtJxPDlfUPQBuz4bKdZwBlhBiQ44qDrYju2nouTgv8bRIWDy07fQZZzAelhfTcHy/hTSuPJoOcu+DN9Ta018wEm
X-Gm-Message-State: AOJu0YxxmMzhMCwVp73ovIEV1/UrshUtb13bUHEmoerTZyEduvxQv8OV
	dL1lMF3sJ3VnvgcRkdF0CTI73G6IiBwnXJvxdzjQCxtPGjakf/nqBsSYHma9texO5Cynnpuyy4x
	Jt8W3CIq/u+olKA//EfPZSdGsRoXdqrXMJAeZUJNRccz3N4LAd+QqwdS1t2TjdwJQRbHGSjyA6x
	tqypWLISyVtQrETPoVurp0Ojaa
X-Received: by 2002:a05:6000:1e81:b0:35f:650:e8ff with SMTP id ffacd0b85a97d-35f0650ebb8mr7288501f8f.28.1718056106567;
        Mon, 10 Jun 2024 14:48:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4+dWVR40t7y9KNU5SdSVMucVyRUgfScrkFSHU1CNZNGuIOpNcZAVG3XxWKDye8L/uW1VpphBzrVra4HZAC18=
X-Received: by 2002:a05:6000:1e81:b0:35f:650:e8ff with SMTP id
 ffacd0b85a97d-35f0650ebb8mr7288495f8f.28.1718056106189; Mon, 10 Jun 2024
 14:48:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404185034.3184582-1-pbonzini@redhat.com> <20240404185034.3184582-10-pbonzini@redhat.com>
 <20240423235013.GO3596705@ls.amr.corp.intel.com> <ZimGulY6qyxt6ylO@google.com>
 <20240425011248.GP3596705@ls.amr.corp.intel.com> <CABgObfY2TOb6cJnFkpxWjkAmbYSRGkXGx=+-241tRx=OG-yAZQ@mail.gmail.com>
 <Zip-JsAB5TIRDJVl@google.com> <CABgObfaxAd_J5ufr+rOcND=-NWrOzVsvavoaXuFw_cwDd+e9aA@mail.gmail.com>
 <ZivFbu0WI4qx8zre@google.com> <ZmORqYFhE73AdQB6@google.com>
In-Reply-To: <ZmORqYFhE73AdQB6@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 10 Jun 2024 23:48:14 +0200
Message-ID: <CABgObfYD+RaLwGgC_nhkP81OMy3-NvLVqu9MKFM3LcNzc7MCow@mail.gmail.com>
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating gmem
 pages with user data
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, michael.roth@amd.com, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 8, 2024 at 1:03=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
> SNP folks and/or Paolo, what's the plan for this?  I don't see how what's=
 sitting
> in kvm/next can possibly be correct without conditioning population on th=
e folio
> being !uptodate.

I don't think I have time to look at it closely until Friday; but
thanks for reminding me.

Paolo


