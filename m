Return-Path: <kvm+bounces-41652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 772BAA6BA1F
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 12:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F9D848310D
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 11:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 915612236F6;
	Fri, 21 Mar 2025 11:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h2F0pVmG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503BF1F1527
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 11:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742557800; cv=none; b=YhqDUKmgpqcHaYcGcf0tlqOpNTg9rTkAMqRXoAzcbMCIy85B0oTHXwZyAjxQSXsshJ2O/59n4vZNQkVRCAXc/qNmr67T2nkbWSaY/XmC1R9BN+mnhMlxgPh+7Q/nRa4zf0Os5NfVb0Fl9TDKv84cmm2JH0riRBXgYahy+pTebTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742557800; c=relaxed/simple;
	bh=qa1pULEViJpZCrEX7jstluPXowLxDjXAaXD2cx0gXCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O6oJpCFP9WbUQH/aeMYNLKXpSzhpRZE0vSypSkuMGVHR4hkgXS0x3BJUAt91tDdKA48hNaM3XCo7o6+F5EceL2QYr+Y7hUCHkmYkD+lP/HEtpmehW/dsSPQmv3EEA0ODltUXQC2gfmBZnhDuqWmUsiRQGlXp1aqJRitXk2DuuTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h2F0pVmG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742557797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1U9d1S34dJA/yYSBtaTmCkKeKqx6OuwipBYsRctHH18=;
	b=h2F0pVmGytSeN1O4bBCKoalV4EKdNqZktUltLQI4HxQHoahlg1QZF8SnuAK+c/5NJbbmTS
	2Z3bDSrQR6x+PGyKq0CjGWqHdPUYoc12fEi8iwHRnXxpfj0c7UHAyhI4En79lMTIzFkVot
	hPA5424TiArQ/CcJeu3QX7/KPcQOb+0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-QJCgmOdKOo6JbZ5adMtbog-1; Fri, 21 Mar 2025 07:49:56 -0400
X-MC-Unique: QJCgmOdKOo6JbZ5adMtbog-1
X-Mimecast-MFC-AGG-ID: QJCgmOdKOo6JbZ5adMtbog_1742557795
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39142ce2151so812337f8f.1
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 04:49:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742557794; x=1743162594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1U9d1S34dJA/yYSBtaTmCkKeKqx6OuwipBYsRctHH18=;
        b=rGX9xJfgXPBc5S6spPaAEAoQ0GeXt2jpZv0++1xuNCzBeYuccg1LE/o1NXgr66QTkO
         9uYwdf1M128Orz9+Rc/0FUw0TsDSzxl4vdxoafushXUrtasy7Id6QbKaHcSQa1y2UcCb
         iftlqzFuAXZNp7qr8eLLVEQec+vwvEYvo4imdmxCTLQC440orb+Njvwz1ztAy4bPUwM7
         Ap7r3fLX8Ae9GqNHGvvitZDLtwBMXKmKN82rJmPVx4JLGSNv2a5v9zYcopm2lceyWj+G
         ns2KBBLCH4M6ygZH0wJ+sXSfHKIjwSCpGL5KfOwieuf4zfbZUhdhAjKngxQyVIntKjjT
         lTnw==
X-Forwarded-Encrypted: i=1; AJvYcCUKLSFfSW3tCqUpAWV14xxD4DI8Huf/Uty+sZliUvxEgpVkMJxohR0Lii/dnoRP+0QHY7U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGki40DKnMRP95u/LViK6BKyHpDhD1xdTsdmaG1kk7U9dFiFLZ
	65nF01MZnyu5swcXuL5mH4UVetdWvHU7gJDOKH9gLx9W4sb5tYngVDBIeD9SCGlSO68ZRrqfoZb
	AYDwNEJUJwjisxhD/+yZeAvZebdsolE16Ep9BVoftHbqUoRPtAxh2u3N1SiGyoOgRGJpPj/z+1l
	EblyssD3QAXdSG7CnvBJPjtMPOz+F4aGZorLo=
X-Gm-Gg: ASbGncu/tZ6nxTWD9Qu60NOu8X7wjGTBsRAAl/SAGWAYz182kEMTmqKz/s96CQQ7XRV
	s+xKtGRWdGbAB723VqvZmkDyTaK3VYFJt16MYFWbsM7aOiP0ivwivcbh9bizQxlkVCEoEyzKhMw
	==
X-Received: by 2002:a05:6000:2cd:b0:390:eacd:7009 with SMTP id ffacd0b85a97d-3997f92d09bmr3058090f8f.42.1742557794237;
        Fri, 21 Mar 2025 04:49:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNUFCv0i56r7CJ8VGtM5M48sVRuttBFnEKe3e3lhtMlyZTFQc3EnUKgwS93nkXZtN1GSB0GosWtSsc4sxvw6o=
X-Received: by 2002:a05:6000:2cd:b0:390:eacd:7009 with SMTP id
 ffacd0b85a97d-3997f92d09bmr3058075f8f.42.1742557793891; Fri, 21 Mar 2025
 04:49:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e61d23ddc87cb45063637e0e5375cc4e09db18cd.camel@redhat.com> <Z9ruIETbibTgPvue@google.com>
In-Reply-To: <Z9ruIETbibTgPvue@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 21 Mar 2025 12:49:42 +0100
X-Gm-Features: AQ5f1JoYTlPe6JAy0NvJAqvSCjTLVyZUzSbA7EqUgIebFZzwtfOE1aR1uOhKJe4
Message-ID: <CABgObfa1ApR6Pgk8UaxvU0giNeEfZ_u9o56Gx2Y2vSJPL-KwAQ@mail.gmail.com>
Subject: Re: Lockdep failure due to 'wierd' per-cpu wakeup_vcpus_on_cpu_lock lock
To: Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2025 at 5:17=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> Yan posted a patch to fudge around the issue[*], I strongly objected (and=
 still
> object) to making a functional and confusing code change to fudge around =
a lockdep
> false positive.

In that thread I had made another suggestion, which Yan also tried,
which was to use subclasses:

- in the sched_out path, which cannot race with the others:
  raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu), 1);

- in the irq and sched_in paths, which can race with each other:
  raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));

Paolo


