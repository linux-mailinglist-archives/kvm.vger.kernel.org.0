Return-Path: <kvm+bounces-23239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E805F947F90
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 098F31C2276F
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 16:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF37615F3E8;
	Mon,  5 Aug 2024 16:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XdBs8+ro"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C8515EFAF
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722876355; cv=none; b=JVAxalPPOJ62nTr7mQe9SO5+zrImDbmJcZ3h5nA5T7D1UXGdCCzJLZabHf+QGme/XzxOrJbaDZ2kllLYtpx+aY+wDWCmhdaUg9C/7IiU67jkcd66eWsR1up9e1DLKI5Tt5z/lG33CG+lT5s3XpyolO3DPSFZsHMyuILpurtz2L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722876355; c=relaxed/simple;
	bh=/VBbVlmTnVxwdhVNe4IkYQj6hCVgPsTCNZKm5KommQ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hiT04gRnhyNLojcwrRGaU9pJGJLw9umIKFTkiFewUhkaQl2Bt6q8N5i3lX6LseQMecHHThbEAviY5tTZ0YRlDT0BPOI4cm3a2gUxWliGI+gR5DNf2/qOv7Bf0KIR849bYS3m5OvoRgBU8vt90I7TLd0lP0+ceEeCednFOvJxAeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XdBs8+ro; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3685a5e7d3cso6563151f8f.1
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 09:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722876352; x=1723481152; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o6yVSUrGgXw/wlz/1NwkFGiV5TPvOyi6VfHlHGsXoAI=;
        b=XdBs8+roWWoM0TE+dkYpIiy44miTOLAocD7a3cgLNlOmOp/1WnG+rJFz9y3Msybm9K
         IKMoQTMkKElGJhIgWIvPhbZNdA1dnEo46NSAAcf9W15AcoghBv0pTUJS2k8rV9oIcKJ/
         EpwE6ohamdIdU1VAmpjyzU8JRoy/zpgp3tyUqCeTgvGXhzTAzfL9BTV2KUV7kCqFfOsC
         ZajiJfAiocYpUqQH6kRS8QTayh0JvNR/JARdLff0O5O5OHAnZjZirPrk3l3+IFCQQnPg
         RvATiEKYrRgFkGkkw4NVS2y76FmvreMDru3Y023MxQcitl0bXDGhuMAc03xsbSpy7FYj
         ePfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722876352; x=1723481152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o6yVSUrGgXw/wlz/1NwkFGiV5TPvOyi6VfHlHGsXoAI=;
        b=MhaTzxxPd2pmZkznAUtDocCxPHGdG7jhDosz4LKOr7Ovq9/yoygPHi07ymfUXcs7Hb
         spp9fucV5e5Lbvf/PtZUzaCaO9X+JcCBUlHsNAFSa5VflgoZZG23GjSvEbtV0CYBBkWQ
         blHf8jfla82LoYjL3UoI5rUBb1FI4GK00kXbDF7qqa8ddcWrDanBNZ7jwYT2p0muOiPe
         IL/XBzw0g5HS+oBuYel5bLudjul1n5QgLksyqmLqpMCGRiBdmJ9Buezi+6vTXNOcGiDh
         rytIPKGMMnNjLP0F692mLnwgYOUPHOQvpWYYiT6VXLxIkfOhJLVMIsfXBRThy8VTOVYY
         3guA==
X-Forwarded-Encrypted: i=1; AJvYcCUHl1/XHKK9ATVbbzKR50AdNl8ayNCveVehTCNH3vIwSPXryUEd5W0FxQGp/600crkX1HBjsSv6X9vSKCQ4VyTetHgn
X-Gm-Message-State: AOJu0YxI3pzv6xWZgYUA3tVZKbvSKeTGgHjPapN3DMVlTX48QGe/wH/Z
	OdW/xJsLyJmGNFsHjI/oTrtedv5ChrLSmXnD2uloq5oDJXqFL8re/C3zUe2OMf6YrEH+cZ7K2zd
	kS9+XhDZtmUkleEo+Mldz5599/z152YYwTKZVoYRm9Ta5BR2kbfni
X-Google-Smtp-Source: AGHT+IHmqog28WAFrnaokq40fDy52AoR8UNilS+pnfHvTEhN2Ra32PFNq7u1rB5zCTm7gzUJ7GQSz6iT9QTw3f0IKAc=
X-Received: by 2002:a5d:54ca:0:b0:367:96d2:5756 with SMTP id
 ffacd0b85a97d-36bbc1d7a5fmr6926373f8f.62.1722876351843; Mon, 05 Aug 2024
 09:45:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801183453.57199-1-seanjc@google.com>
In-Reply-To: <20240801183453.57199-1-seanjc@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 5 Aug 2024 09:45:27 -0700
Message-ID: <CALzav=few=dq5_9QC=ivRWxEtRvQR47BWh5j5-Sgg3Zy7_Rx0Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] KVM: x86/mmu: Preserve Accessed bits on PROT changes
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 11:35=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> This applies on top of the massive "follow pfn" rework[*].  The gist is t=
o
> avoid losing accessed information, e.g. because NUMA balancing mucks with
> PTEs,

What do you mean by "NUMA balancing mucks with PTEs"?

