Return-Path: <kvm+bounces-30033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D08639B6669
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 15:49:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94EBE281547
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 14:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D97C1F472B;
	Wed, 30 Oct 2024 14:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cFHTr7G8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18B41F12FA
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 14:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730299722; cv=none; b=XvEUf80+zptsm42fvJJsA8B1CYM27T7gmCDHnCUprBZDbxU110QRDUYC1SgP/or0fxZ88Bb25/o919EaiSj8R5ckEmApmIDA0/abx2C12Wlpw5Mkl+/Ok3veCdXPIa5pSHLXmCGLWUPx16G5HYU/XhmL/GyOUy68/wEH/btF5Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730299722; c=relaxed/simple;
	bh=LpMMu2tW+v0eK2jTek+FUNY5ghd010WyUddw61A5pxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N3IxezfkfcrSDn/bbyFQkUzujWrEmiUd8o2cQtiM1oLJSzOzApWQLLcCqh2MYwU1k4rOP04cTdVD32fza/Jv/dHAwuttFTOWI23Kzgnj9jejDMHRCKAuURuSBj2/fOBxE6O9/05EOuug0APDlX5nfb8+we33DPfx0nEQlu4i4Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cFHTr7G8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730299719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vIiqNGj0/lEgFzl4Mf1L3cqOhzMe2y2T4h2UU2CLbw4=;
	b=cFHTr7G8GhyzzJt0RUFdfbnRtA/jf20Pi2zI1gL9gwxbNYU59KXhGCeq0XrTZAV1rS3Lll
	ffMJR43vukclUnZyq5INre0VpRzi0JXM/RmKPY/xN4YHbpZslZo7OxEEn7nsq1LsizZ/q9
	Xc9k7Sh8C1eu1otMF2L8I8qThAtU4yo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-1xLA-Y2eN5-ffQ_wt5La0A-1; Wed, 30 Oct 2024 10:48:22 -0400
X-MC-Unique: 1xLA-Y2eN5-ffQ_wt5La0A-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d458087c0so667119f8f.1
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 07:48:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730299701; x=1730904501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vIiqNGj0/lEgFzl4Mf1L3cqOhzMe2y2T4h2UU2CLbw4=;
        b=eOdFQFFEkqyZrHxncBaRGrKcr+raVnFB4CX06Ehz8QeQ1/VwZXeLu0YsQF5y632hTV
         6/ln503YXDBLo6Hv0yQfw+1fGZ8OnBsSnIjojZ++IiYeki6RjrMfmq/t/EElKvKKXHfO
         Lya76VQOjJHrKrdWMTWTok82Z7fgxmISVWfGIK3k8jMGlJvZikx9oKjSuM+quYokoXVr
         3GvbnkVvoop4tXj2/XM/dn5v+VTVsUQph69PSpcH+adFipLeztp5J2qGFgmQzLeWADF+
         XU65sxiKRVHnLxhY26PbetTR8vNJdSCmwcCV0rEXT7aJ8ygMb6ImLnPCR8610iFhtKEE
         2cGw==
X-Forwarded-Encrypted: i=1; AJvYcCV+wpk4egJU0Fy75f2OLj4oTxV/hEvxvupE4GkWn98hkp0Q089PudXPJencrbPeCuFc9S8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+U5RMUq8TrRe+dSwWFz1VBQGpnmTV6seGVaRXNncEfCkYSK9T
	RtOilTmhCKKXnYOAuhSsHjC7uDVWmzf7frh71H4HJfq693eHzUvfIGOQQoPBJOtSd87X//NGORU
	mcSR+vgdxB8IUa41n6RxYj9NXDhqx/+fv2c2q5PB26/1dGx/m9q2Z6LMaT2MP4SSQfMdvFVht0X
	kNDqWk8icQ545alI9sClpWQg+K
X-Received: by 2002:adf:ec92:0:b0:374:c21a:9dd4 with SMTP id ffacd0b85a97d-3817d636ca4mr5614300f8f.20.1730299700597;
        Wed, 30 Oct 2024 07:48:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMIDA8EBgIVSRmKzeTJu8F00z1MEyGrcfLHRjfhN6WRVRP4EeuJk9Z2vLE/2TS04vqzHZtnvBUPW0FcKjQimY=
X-Received: by 2002:adf:ec92:0:b0:374:c21a:9dd4 with SMTP id
 ffacd0b85a97d-3817d636ca4mr5614274f8f.20.1730299700297; Wed, 30 Oct 2024
 07:48:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1730118186.git.kai.huang@intel.com> <0b1f3c07-a1e9-4008-8de5-52b1fea7ad7b@redhat.com>
 <08c6bb42-c068-4dc1-8b97-0c53fb896a58@intel.com> <6c8bff1a-876f-47b7-a80c-3f3a825ddbc0@intel.com>
In-Reply-To: <6c8bff1a-876f-47b7-a80c-3f3a825ddbc0@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 30 Oct 2024 15:48:08 +0100
Message-ID: <CABgObfZWjGc0FT2My_oEd6V8ZxYHD-RejndbU_FipuADgJkFbw@mail.gmail.com>
Subject: Re: [PATCH v6 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
To: "Huang, Kai" <kai.huang@intel.com>
Cc: dave.hansen@intel.com, kirill.shutemov@linux.intel.com, tglx@linutronix.de, 
	bp@alien8.de, peterz@infradead.org, mingo@redhat.com, hpa@zytor.com, 
	dan.j.williams@intel.com, seanjc@google.com, x86@kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, adrian.hunter@intel.com, nik.borisov@suse.com, 
	Klaus Kiwi <kkiwi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 1:24=E2=80=AFAM Huang, Kai <kai.huang@intel.com> wr=
ote:
> >> Are you able to send quickly a v7 that includes these fields, and that
> >> also checks in the script that generates the files?
> >
> > Yeah I can do.  But for KVM to use those fields, we will also need
> > export those metadata.  Do you want me to just include all the 3 patche=
s
> > that are mentioned in the above item 3) to v7?
>
> for kvm-coco-queue purpose as mentioned in the previous reply I have
> rebased those patches and pushed to github.  So perhaps we can leave
> them to the future patchset for the sake of keeping this series simple?

Yes, I have now pushed a new kvm-coco-queue.

> Adding the patch which adds the script to this series is another topic.
> I can certainly do if Dave is fine.

It's better since future patches will almost certainly regenerate the file.

Can you post a followup patch to this thread,, like "9/8", that adds
the script? Then maintainers can decide whether to pick it.

Thanks,

Paolo


