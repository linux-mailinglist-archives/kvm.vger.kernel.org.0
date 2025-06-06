Return-Path: <kvm+bounces-48668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1077CAD06AD
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 18:32:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C48C7A3701
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 16:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1443C289E23;
	Fri,  6 Jun 2025 16:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D4pgGpIQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27161AF0BB
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 16:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749227565; cv=none; b=njNR1B4XFWKRXLwa2Zr5IJoQ+g0CsADsgCEMZXS1C1oj72/amOyVzBBP0Fxwr0rzB8PjOhXyrTcVqMAiOqcghvad7TM4DgssgNcF9Y6SmMKQJ9f3cGE1xIL+rJ0g4n+nGyeZfrrRFEICou9kXEE2bIVfpx6TMRTMxO+dwrLy95g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749227565; c=relaxed/simple;
	bh=NKeBdOPPz5x8d0Tafvzg7xtqJOAb8dtCj2kXRny/hkg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MasPsqPaGXrsx0I6yyzXMj5PSdUrFQMygy0Xsi6Ym1ytmYEAYPBO/FPar9nRYMwp00OMiZZk8uC1BdQ4/sbIQ47zWzJpgHqxvVs83ueVuOgwHd/t4w7weYskeDL3M3k0oRfHOfUFqNr+GIPvcNRVHDXAqxw3PLvbEiJTQKbBJGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D4pgGpIQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749227561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aL5SmkAlHa5O+le9ZpY8Lx/lKR2ji4Nnp0dTsL6WtKA=;
	b=D4pgGpIQwcn9TneVeIzcL3POsHQ8N4eo+SZAlznqtYFGOkkOHK8f8AAcoUqy/YCT3V3Nlr
	3ZqT5s8hxzO8uF/l62TpR/GS4y+4WVER63EV3HaXwaP9jFKX0tGLpq2IhpbwKegJ4OpKWd
	6C8wPtTEJ8EveRtDffX4+VkecgW6ZxU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-JHIaFHodOu6CaOLfcL_KJg-1; Fri, 06 Jun 2025 12:32:40 -0400
X-MC-Unique: JHIaFHodOu6CaOLfcL_KJg-1
X-Mimecast-MFC-AGG-ID: JHIaFHodOu6CaOLfcL_KJg_1749227559
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4f6ff23ccso1448624f8f.2
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 09:32:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749227559; x=1749832359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aL5SmkAlHa5O+le9ZpY8Lx/lKR2ji4Nnp0dTsL6WtKA=;
        b=OBOALoWSUWOUS/68eq4QIO03TL1uhzGM9EMDaRagGTKArMxBH0wfLJVnWI7M2PCOdi
         bXhbItvOXy0JJlcGyWb9pi/B8q4LliBhCnfLEDWiIzI6rFCXdhyU0z4rr5ibFHzlcuQN
         X2itRcqToFJsxNbjNGw1XCldOgIviENMc2qJvIGp6M1Apn+vUAb35c/5HGoQ1pgjZOH3
         VRM4TjQc5W0WpqR05b8iD7+8z+rhmdibuoUoM03eBMNDELDPhRFotybP8dqiNn6D8LiG
         9cYa4DQ7Jm7+YEvro1sEZAZsYdtkxWis+t83M/QEj+vjQFHtX1VwNS3bEceKgXjNjV8y
         OveA==
X-Forwarded-Encrypted: i=1; AJvYcCVTY6U2swjJNRVRiv/Ksr9xorSd3NRRlE5TuWEi+dJSKUfnCEClVoZIEvF4ICa20YcgQig=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDpqL08RrxwW2w/j5wKhbG286s+J1zE9bmYi7v/y3mQR+yk0mO
	f01zzTfBec5p+NYxoBUrDzhnn2Mw61awEcbLDDkctB99zh8CAZTQJDmnUkNiysnZHJniRHwQlWl
	sQcH5hdihRIMAG7W68WyKaHtrRVnrHJFW5br1JA2+UY9ZJFX/RkkZZXnhX33SMPk3qIh7Ddnw4K
	eajjCNTyuIIEkUKydfsc25ph2GoD5b
X-Gm-Gg: ASbGncsZHyqu3zNxyxj+IfOfm90QSPw5rXBQ3XjSIQPkeX52FkIDzYXRY1KeKLYwFtO
	CXNbk7IUIVgtGnuy4m+PG+ld7blaYWE/lJekK0VunFDyNCbjGxqyeFRb6DzJ2msp1bzE=
X-Received: by 2002:a05:6000:24c8:b0:3a4:e56a:48c1 with SMTP id ffacd0b85a97d-3a531cbe5a3mr3651911f8f.55.1749227558581;
        Fri, 06 Jun 2025 09:32:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5+TT0rhE4xmHWUYKftJs6TrAvbLLgdNyocMp+5vyk6m5JnvyuO3csBs/J8HFvSM5nMSBZxFst5jCXTAh4sdA=
X-Received: by 2002:a05:6000:24c8:b0:3a4:e56a:48c1 with SMTP id
 ffacd0b85a97d-3a531cbe5a3mr3651863f8f.55.1749227558216; Fri, 06 Jun 2025
 09:32:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250401161106.790710-1-pbonzini@redhat.com> <20250401161106.790710-11-pbonzini@redhat.com>
 <aEMV7awKTSXEkLqu@google.com>
In-Reply-To: <aEMV7awKTSXEkLqu@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 6 Jun 2025 18:32:26 +0200
X-Gm-Features: AX0GCFvRlOMty0FBBhLLtZbbqxj561-GwRRRR4haXEnWrQlxR1VDuUGXvjdiVEs
Message-ID: <CABgObfZyDaJY3EX2HaF8yZTRFQn0v+fEMe6mZNWZTvVu2tz5Ow@mail.gmail.com>
Subject: Re: [PATCH 10/29] KVM: share statistics for same vCPU id on different planes
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, roy.hopkins@suse.com, 
	thomas.lendacky@amd.com, ashish.kalra@amd.com, michael.roth@amd.com, 
	jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de, 
	James.Bottomley@hansenpartnership.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 6:23=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> Rather than special case invidiual fields, I think we should give kvm_vcp=
u the
> same treatment as "struct kvm", and have kvm_vcpu represent the overall v=
CPU,
> with an array of planes to hold the sub-vCPUs.

Yes, I agree. This is also the direction that Roy took in
https://patchew.org/linux/cover.1726506534.git.roy.hopkins@suse.com/.
I thought it wasn't necessary, but it's bad for all the reasons you
mention before.

While he kept the struct on all planes for simplicity, something which
I stole for __stat here, the idea is the same as what you mention
below.

> Having "kvm_vcpu" represent a plane, while "kvm" represents the overall V=
M, is
> conceptually messy.  And more importantly, I think the approach taken her=
e will
> be nigh impossible to maintain, and will have quite a bit of baggage.  E.=
g. planes1+
> will be filled with dead memory, and we also risk goofs where KVM could a=
ccess
> __stat in a plane1+ vCPU.

Well, that's the reason for the __ so I don't think it's too risky -
but it's not possible to add __ to all fields of course.

Besides, if you have a zillion pointers to fields you might as well
have a single pointer to the common fields.

> Extracing fields to a separate kvm_vcpu_plane will obviously require a *l=
ot* more
> churn, but I think in the long run it will be less work in total, because=
 we won't
> spend as much time chasing down bugs.
>
> Very little per-plane state is in "struct kvm_vcpu", so I think we can do=
 the big
> conversion on a per-arch basis via a small amount of #ifdefs, i.e. not be=
 force to
> immediatedly convert all architectures to a kvm_vcpu vs. kvm_vcpu_plane w=
orld.

Roy didn't even have a struct that is per-arch and common to all
planes. He did have a flag-day conversion to add "->common"
everywhere, but I agree that it's better to add something like

struct kvm_vcpu_plane {
...
#ifndef KVM_HAS_PLANES
#include "kvm_common_fields.h"
#endif
}

#ifdef KVM_HAS_PLANES
struct kvm_vcpu {
#include "kvm_common_fields.h"
}
#else
#define kvm_vcpu kvm_vcpu_plane
#endif

Paolo


