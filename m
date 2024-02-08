Return-Path: <kvm+bounces-8345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D5F5984E218
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 14:39:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77AF8B22427
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 13:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E07F76418;
	Thu,  8 Feb 2024 13:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dPJnLIs6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EFA763ED
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 13:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707399559; cv=none; b=f8yG87bmrvuakQACBEje32ZIOkcisTk3CDh8GlA//qb6te+UcKhNtMV05walXz/wbzBfnZE6lOWAaYoBKEeZr7KpAaph2VFHf3kxM2SwNZSHfs4ATw+na911muEAUTw5oK/kapStCSOB4vAnHeRCnB9xSrGSkz3Yrjt9fkUkfB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707399559; c=relaxed/simple;
	bh=SBhV77nizQ8APQmEssjZYbIeubtS8uMS5FsbXrHmzjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KE6WrUQ27utXvGnXMcTYWoZ6T8ejiDSuUYsF6zfiEfyav/p+MMmgEgEQg/J8PTbMSe/91CMKKVnQMgCilotPMi4QD9QOAYUo/k6qcpuGHnS/eX+i3voxqpldEPWokyQsM1ydjirrH21fN4vX1TbVTs02Kvf+LzZOk4QJPO6s6hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dPJnLIs6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707399557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KXrfhhpcInwvwI4FrjbsTHUOux7lst37uiaeU7LGWF0=;
	b=dPJnLIs6EdjMKibP3nBTxBybGXwqHFJesvTukMBcJ5uf7AUFl7u7bJbS4XTITZxt4ztuHg
	/fhpInlVf7l8NJxNn5K8Zt3pNK53AN9amw2YF0dBUJ9ClB58wqmVInNgb/dMMtUpcm5w82
	vN4FwDLx2PZwuCvA8ue9tqKdxGQRwtY=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-lm-Ub7SMMtqfJv8bqD8gTA-1; Thu, 08 Feb 2024 08:39:15 -0500
X-MC-Unique: lm-Ub7SMMtqfJv8bqD8gTA-1
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-4c017c025dbso728018e0c.2
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 05:39:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707399555; x=1708004355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KXrfhhpcInwvwI4FrjbsTHUOux7lst37uiaeU7LGWF0=;
        b=c7xNLQiMGR+/jPoYKqrdLBCpo/uFgXdVRfd+YnkFk9I3gcqODJl/5MV4pSuSnfAi7Z
         JTezgnGP8AlVQ5cAyCI2lfuWWSM1NUdAKykibygtn2dzYThIgK3JnkMqjiAhiDG6MA2U
         XQzdxc7UqIFJslA/PCcFIWtRuqk3Tf0DF4N9bGxTy2j74tHrk04IOeu7pyxHkHXNOOeZ
         nroG2/cUfeX7cj/QemoNw0q7T+03U/QGp2dmHCqh1m1ps2XnLYTphABSh9e+Kaa7bGT7
         eQxRcsU5r/LDiHpTnKBTObIf6S5gOicj7Y6rKEZzg+DjZVzh2y8yTa/nbUdESIFbioD3
         7lVw==
X-Gm-Message-State: AOJu0Yw0mpdz/2jNcLoLu19DiIzdznv5+EYKPBz3Y3jurUzVRzt+f1Za
	Tblapo6iElG72LnCT3bKsvWZzuFCLglK52xx1I68Y9LCTdH91/6VN5DnVtTx8/lUloBPHzXU4QR
	R4i6Dw8fwoGQPVdQ0sJcxQdX39666YgjmNaFEE+lNDIsl9Xr/vJEqcvFHi9wPb32Hc/SDHAvAV0
	08EXgeLHj2GS0o3atdVCWoCsr3
X-Received: by 2002:a05:6102:55a0:b0:46d:3b56:efe4 with SMTP id dc32-20020a05610255a000b0046d3b56efe4mr6384859vsb.32.1707399555019;
        Thu, 08 Feb 2024 05:39:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHgRzHqQS39WbRm1wyA7DiuERX8kT576hNccxzT2Z21q2BolwCPEcvWjxv44tJRSxLvO1ePXU4CyIYtI7cA5cU=
X-Received: by 2002:a05:6102:55a0:b0:46d:3b56:efe4 with SMTP id
 dc32-20020a05610255a000b0046d3b56efe4mr6384848vsb.32.1707399554687; Thu, 08
 Feb 2024 05:39:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240131233056.10845-1-pbonzini@redhat.com> <ZcOWwYRUxZmpH304@google.com>
In-Reply-To: <ZcOWwYRUxZmpH304@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 8 Feb 2024 14:39:03 +0100
Message-ID: <CABgObfa1SmH0HDq5B5OQxpueej=bdivMTkVrO=cXNfOi09HhUw@mail.gmail.com>
Subject: Re: [PATCH 0/8] KVM: cleanup linux/kvm.h
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 3:43=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Jan 31, 2024, Paolo Bonzini wrote:
> > More cleanups of KVM's main header:
> >
> > * remove thoroughly obsolete APIs
> >
> > * move architecture-dependent stuff to uapi/asm/kvm.h
> >
> > * small cleanups to __KVM_HAVE_* symbols
>
> Do you have any thoughts on how/when you're going to apply this?  The kvm=
.h code
> movement is likely going to generate conflicts for any new uAPI, e.g. I k=
now Paul's
> Xen series at least conflicts.

It also conflicts (and was partly motivated by) the SEV API cleanups
that I am going to post soon.

> A topic branch is probably overkill.  Maybe getting this into kvm/next so=
oner
> than later so that kvm/next can be used as a base will suffice?

I can do both, a topic branch is free. But if you think this is in the
"if it compiles, apply it", then I can take that as Acked-by and apply
it today or tomorrow.

Paolo


