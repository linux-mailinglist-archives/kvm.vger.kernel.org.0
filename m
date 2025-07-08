Return-Path: <kvm+bounces-51782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4AAFAFCE82
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 17:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36B79562880
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 15:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9378A2E0929;
	Tue,  8 Jul 2025 15:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LTXX1Z4E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540C81A288
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751987074; cv=none; b=p3QaCPn8hhYFrxukur+dOL/MbfUYhaPT/bxApNTRKhjl1V6VgIRn34p4bOcdhtKfnTwdNYZ8sOuqFkKErJa1FMloQABUDnDaUCe9PKboBO7hrbSSlAtxw3oHsYDLu0pskXvt4DE4TMqOuJ4UHMSEqSPQS5Gyo2mY4bn9DRkxuZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751987074; c=relaxed/simple;
	bh=pDH2XFHl/iv3yIYHUvYceoo2XrEbUJyxj+Z370eNWa0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EkKva0uR7Yu3pg64BMVdAJnNstEL3MK+wVvDPyb2hK05TNrh3gC4SyLqW+AX5/4DLba0l0KLT8jCZs/ZFPVZSmbUOBdLncfLyS8AbfBTOfXwf5lUL300gK6Nt4yyoeBJOLMw21f2FvYHpWA+2/B1iH/veUusZ+OxHXeBCp3ngrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LTXX1Z4E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751987072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tl43DWhHwsKq17d5JHNS8cD2rQiVgiSwSkjGnb/5syA=;
	b=LTXX1Z4E6vGeokL1E4fAyEUXNZ49k/xT1m76tyMpdvTuEouQwfFCQL20O9Ik6B2NblmaAq
	uKXjRGTGKSBZtLSEhi+MCcQZHxajrm5E/yR9WhtcqK4luF8ATrnxRLHuNB5WanJhzphT8i
	HLiv7PuOA856P4OSMqc4jxHjr44Imtk=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-BsLKvoUBOX60NXoyhAzhEw-1; Tue, 08 Jul 2025 11:04:30 -0400
X-MC-Unique: BsLKvoUBOX60NXoyhAzhEw-1
X-Mimecast-MFC-AGG-ID: BsLKvoUBOX60NXoyhAzhEw_1751987070
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-74913385dd8so6128462b3a.0
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 08:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751987068; x=1752591868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tl43DWhHwsKq17d5JHNS8cD2rQiVgiSwSkjGnb/5syA=;
        b=GgS/TXmU0X6KCZKuAfzBHg2UMDKYxJoaWWt7J0TD3V1ziffpGcnJdOnm+1RcfzJzaf
         mXENZW3OTyD1YLU6K3dtIKLgAu4WkGD8iVgGGvr6epIUnpyqmjyJ3KgHt14sqhktKbca
         +kcHUbRx0LDZWRPkDvGYYt4YRyywR3iTuYedDbhINaZedd6HyW35v0n+Ijr6cxVZlIPQ
         Oj5IQVFtHYUiPTGuCG16byDK3UcoHfKg4r9LUks1yskP9sFfDWal6Sszq9ncEB/Gv7JC
         Xk3966wG1Qr+u4VZKwjaCcsYK4oz2ndxHhYJXBYqzoQe+jOWjIlUDUq6uVt6JkLhsb8K
         xsqQ==
X-Gm-Message-State: AOJu0Ywcb5uQ8ri0rqr/36nW0Xvj+ppgy3VnfdHV0iRNdCXj0EdQ4q1z
	zJUbOInqJg7d9Vwyz3B6AvD3Y76DTcy4gLDr9uhPgra9kJ9LSnZWGqBZBFKcWTCL3iX1/mNPHJE
	hHwoGQ+h9PIBfzzdD82QO8FKBKOGAYLO45L34GY5HtwnAqRfETw+BoHvZMJU4ziElatQt8LhRle
	CIkj4kGWyWHjtWCCH9Lx4mMzmsbsa9aHXUuvEi
X-Gm-Gg: ASbGncvK6r/MKrMxaFPFEqqSVG7fOY5MJVIuVpaw3dYtNkWIcsBkMf1Aunx2VohLAvT
	LsH5fVX4cKL4gFf1NS/RvLWWzr7XF3zkLy6YI8NOMQ6dw/aNydB/EPkAss1Hgg/Tqed3txb//yj
	mrQA==
X-Received: by 2002:a05:6a00:1ac7:b0:736:3d7c:236c with SMTP id d2e1a72fcca58-74ce6669a73mr22213600b3a.14.1751987068060;
        Tue, 08 Jul 2025 08:04:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2ejvW3YmvccpHRprgPMxap6Mer3Z8N0cp8nCP+Ldw5z9vAhxZz6fSn4zsrkaqz4eR37sKS5kCEKtiNL+HIT4=
X-Received: by 2002:a05:6a00:1ac7:b0:736:3d7c:236c with SMTP id
 d2e1a72fcca58-74ce6669a73mr22213546b3a.14.1751987067575; Tue, 08 Jul 2025
 08:04:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250626224336.867412-1-seanjc@google.com>
In-Reply-To: <20250626224336.867412-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 8 Jul 2025 17:04:07 +0200
X-Gm-Features: Ac12FXyJCla8Zq0EueybAUCeQZdUT7OiUHbkPJGhCeECDpLsEK99IMU2xCp9p5Q
Message-ID: <CABgObfbpf58Nhc75TfmFCK+jLbTZ_DkuEZCHFjDAwKabieFugg@mail.gmail.com>
Subject: Re: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups, and new testcases
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2025 at 12:43=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>  - Play nice with QEMU builds that disable VNX support.

This mysterious VNX caught my attention. :)

This could be fixed in QEMU to accept "-vnc none", or could be changed
to "-display none" (-display being the newer and nicer option that
sums up -vnc, -sdl, -gtk and so on).

I'll send the patch and have pushed the rest in the meanwhile.

Paolo


