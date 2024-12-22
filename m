Return-Path: <kvm+bounces-34299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F058F9FA7AA
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 20:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68AF61660CD
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 19:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE87C18E04D;
	Sun, 22 Dec 2024 19:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VQve5l77"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F22815F41F
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734895755; cv=none; b=Xk6n/liX5o/fNbqb3BJMe5qODO/XWG/mezXcHO9tLMm4VqAa+YVklxXC/RdDQVORtjzWlkjTCNpQgP05CrFyaC7s8033bKPG8gVgMko3VaFqZdJp/exOleFX7sWrBKcoXQ+BsKzUMW/UWnAK555xKa/x3ad9lmiQp1q/3fLK2KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734895755; c=relaxed/simple;
	bh=w/SlzIUUEqvbGdGUk9Zy5j3Ok0BQCucctNQtxDhoxtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JCIMYMa6zgBlxO6dy0VThDMcIP0CN+Mnm7P66izBBi61w70EY5/tOiDrHWZKvDh7laeWyxhvagCPcrHwwxQCcOFxqidqNvtu3fGKV8hfDPSIxiFGk9qV0GxEA3AzqXFMfK50SaAkfn+t+NUNvO9urrrzH6WVU8Ql1U+CR4jvHis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VQve5l77; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734895752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VOiXsmeuyp1k6cpdRU36lSvFVEVFmaixza3gPZnoJME=;
	b=VQve5l777iO7fAfBHRMYOyyVBT6qso7zRnYE/rJ9dE4ySrIemvN+1mdBCyUzu8S1QC5haK
	oAcb74exaivJBNfhfKFVEXFXUqH5Q6cklygv/vfEyv8/ILLwgewKJAm1PotN9Mk+1g6jMb
	2YGtYkdlXCvq4YczXh7/IURuCvxIfng=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-CFGgZXqxPzigaux4d78v0g-1; Sun, 22 Dec 2024 14:29:10 -0500
X-MC-Unique: CFGgZXqxPzigaux4d78v0g-1
X-Mimecast-MFC-AGG-ID: CFGgZXqxPzigaux4d78v0g
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43646b453bcso20241455e9.3
        for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 11:29:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734895749; x=1735500549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VOiXsmeuyp1k6cpdRU36lSvFVEVFmaixza3gPZnoJME=;
        b=vqBqUq4aIscuszYxjvOAKty7+K01imsxvBv3Rs3bvbQ6KCwANnwVSb5AD2/4xBbtfv
         IlDru4xtUxaGr6Y8dTEHQwtUEfCdNZq6tcE/8o5u+W0Jj+i+oc9fZc2vCH06fxssKpy/
         QvfIcGUmgf0sRC0MYiukXK+NI9gShoaXI8WKpc3Z7SGQ3d+WFSWELMXi3s5Qq8DnafsX
         jHIBvkk4TzMAr7+txn/iR9BYzMIUcg/ckkcoQG/BbBgbr3GGYha+BMrTk8VMWKNnf3dx
         gFfmBDUQpTd/bFYDd5cqkguJDhkmS9jSb9qAFApQSAhXsV+ZxUfYmxLvceP94Bd7pC4X
         CvLA==
X-Forwarded-Encrypted: i=1; AJvYcCVh7uHSeI9nP/z9796Lo6VwaEXgXeRtM8HSxrGinANYBIkW4QhtSUIkxa/WrspwVpeevWs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx95dJLX2+zuQ6tEV1YSoxD2533oKl0jxtC7ytDoLzwGgvhYkx
	1TF5zb2w/CjSjk7c+BsKZd9y5hnnKqIW4YaF5runclWAQi3CAU+aTD5AWKRsUfXz0OyQVWiUdQk
	RHdN7b//zVvBJ1kdrP5l8FTFujNtuTfF6dIiH8AIhdrr/vtMAEnYh0kZ7NcVkJdlCQst3tdqE7f
	7S2R7GBS2x2aZ1HfAyfsuosWWa
X-Gm-Gg: ASbGncuvPmFXotmsxh1PxQk4IlKBQ/wOuVG0k68i9AwCXtAEDCRLkL+tpUyd/iJAHPV
	bQ2elpc8YHmtfDkmeDhtmAe2t7sKfrP+PsibTWA==
X-Received: by 2002:a05:6000:2c3:b0:385:df73:2f3a with SMTP id ffacd0b85a97d-38a221fa8eemr8547121f8f.14.1734895749524;
        Sun, 22 Dec 2024 11:29:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHF92lRMgNz1ZVYqbiyMi9kN7bJE8xiFNqpdbzMLQ+v9kDIasIe/9wlGFHds/gRg2zLXVO1G1cN6xCho/inoOw=
X-Received: by 2002:a05:6000:2c3:b0:385:df73:2f3a with SMTP id
 ffacd0b85a97d-38a221fa8eemr8547115f8f.14.1734895749188; Sun, 22 Dec 2024
 11:29:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241115084600.12174-1-yan.y.zhao@intel.com>
In-Reply-To: <20241115084600.12174-1-yan.y.zhao@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 22 Dec 2024 20:28:56 +0100
Message-ID: <CABgObfbukWu5srwDGA-orsd35VRk-ZGmqbMzoCfwQvN-HMHDnw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Only zap valid non-mirror roots in kvm_zap_gfn_range()
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: seanjc@google.com, rick.p.edgecombe@intel.com, binbin.wu@linux.intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2024 at 9:50=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
> Sean also suggested making the self-snoop feature a hard dependency for
> enabling TDX [2].
>
> That is because
> - TDX shared EPT is able to reuse the memory type specified in VMX's code
>   as long as guest MTRRs are not referenced.
> - KVM does not call kvm_zap_gfn_range() when attaching/detaching
>   non-coherent DMA devices when the CPU have feature self-snoop. [3]
>
> However, [3] cannot be guaranteed after commit 9d70f3fec144 ("Revert "KVM=
:
> VMX: Always honor guest PAT on CPUs that support self-snoop"), which was
> due to a regression with the bochsdrm driver.

I think we should treat honoring of guest PAT like zap-memslot-only,
and make it a quirk that TDX disables. Making it a quirk adds a bit of
complexity, but it documents why the code exists and it makes it easy
for TDX to disable it.

Paolo


