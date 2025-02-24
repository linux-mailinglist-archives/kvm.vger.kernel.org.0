Return-Path: <kvm+bounces-39007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAA4AA428FB
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:10:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84BDC3BCC84
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CA1265CAD;
	Mon, 24 Feb 2025 16:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KNbw0SYm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF54265CA3
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 16:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740416277; cv=none; b=inuBPzAwxr3F7rm5O9mzW6IgDKrBKVm9ke0oSZEEHpbkdU9xeyZQFa4nQJJJMdSubPV9k2U/qJKXL3tF5VkB1K/7NZ+KzTzkw5NVq1ErV8PNTyTHAZw4hkz0aln01jdO9KZ3DfASZUgX8xfQhd7Z+N6gIIUy7pFcPZw7UdZCUfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740416277; c=relaxed/simple;
	bh=PbfsQL2sPiow+PCIjz3+Rkn8IIDh6NjOMMFOaOgAruU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MyWOJ55AC9JNS7vNplN3ujQ2Wf5Jh7rD7/u4n86YhMJVep5Qnn8VrtTsYXEapYUuQzvlqRVsDvC4nmkRIdmPsQJGeXi662bv2WqGO2hFikznoT61JiBK0abbdvpCL9lpDLfSCJERSyVG7J5LiWM3ILyMP0occXYWAVzlB4wI5AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KNbw0SYm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740416274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Biw2WTLSjf4saKl00azgbJFpGTFLYZbTKqchEcn3wv8=;
	b=KNbw0SYmLR8l6kK3g6vNLO5Fvw40Y8YLGzIQ6OzaJ/tgh1BQ47RY7dO7tFwRpfhADmC26C
	ULlNvJ/iw6GKSyTSSgMEapX51enldW8L3UNt4lEpyHJe50si6JTGvhSIuBXXabbo85tEUI
	t7yaNlNPcJSI8QQ/SBOuHJ0TlN+d988=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-N-m1kX4OOj6woMwfCZ555A-1; Mon, 24 Feb 2025 11:57:51 -0500
X-MC-Unique: N-m1kX4OOj6woMwfCZ555A-1
X-Mimecast-MFC-AGG-ID: N-m1kX4OOj6woMwfCZ555A_1740416270
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38f443b4949so2194860f8f.3
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 08:57:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740416270; x=1741021070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Biw2WTLSjf4saKl00azgbJFpGTFLYZbTKqchEcn3wv8=;
        b=wLcgbNgBjolsrv991WulAntp59JzhCgBldA1hdpWvXJ62uPdCeT3bBoK7OUVgAw3Jr
         /6z3b3QzqQi7ucKxDthlCbA6IOD8pMZT5munCNVCB7zD4wYZ97D4j/bzgcz7TuAiIAyw
         85C0WamVrbtFy2YdVnEYKxiXsJ/fpQ46GaotFVa+L2rT/Qx2qepQHuznFOyHjH4MJn7L
         06VDzbsJm4pYicY43bDGurIr8p/vXDRjaDadTtiQ85L8O6zB6JJX0HfcBaNWHN+jNTb1
         tCUWmFCHLrdG+c/dBploz5a2UjqG9wDlaedF1h6b/cxQl0ZDF5ccdM2RDGBX6SH9aSTt
         Zq6Q==
X-Gm-Message-State: AOJu0YzaWm6hoF7ggDNNoRpsrqnRo+JYIu8SmrOyMJxNcXtN8qYaIXCP
	jLcfEVJQC1zpDnl3OdnYn69kxW+bzICwD2PNQcEOq2tNpGuvDcMM+r1lfhuIBV3unUdT+fx/DE7
	u2aAqicG/B7/371dXP+7fctLeDVxDQoqAqEzbp0KxAJSbQHtEBjXv7zeIk7H/C0xlUaANeBwbbx
	ew5pEB06haoEfX2jMWJA0PY2hzCg1rshbPTBQ=
X-Gm-Gg: ASbGnctvfD0DNQ6xwh/tPAiHWHB1PxjhMoh3rG10jZchDoEt+4D+Qyuu9qhFCYe5NF6
	kcCzvoCqHB8+zuN/BI3mFSUAuv1D5JqyHVlnFzYtTnwyWI99Swthp7hF63vlcCdgCLYoWSuubGg
	==
X-Received: by 2002:a5d:5350:0:b0:38f:2a84:7542 with SMTP id ffacd0b85a97d-38f6e97af1emr9718372f8f.28.1740416269852;
        Mon, 24 Feb 2025 08:57:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG5dNRxtSyZLnAiRMZfJOPsJBulsojl4I5P8fndIcW5Ryl+25L4glEbkJHy6mYbN+5z31Sip8Eedjc7ZaCr0pE=
X-Received: by 2002:a5d:5350:0:b0:38f:2a84:7542 with SMTP id
 ffacd0b85a97d-38f6e97af1emr9718359f8f.28.1740416269554; Mon, 24 Feb 2025
 08:57:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250222014232.2301713-1-seanjc@google.com>
In-Reply-To: <20250222014232.2301713-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 24 Feb 2025 17:57:38 +0100
X-Gm-Features: AWEUYZkqvFCDavxVA4pRYu9m38ZLfRG6NWtlLzkMwKjWG0F_dMA0RYDZW7PpZ40
Message-ID: <CABgObfaUkZxE7g8Qic3oMzHVu1PozT=XixnfNxXLrVdq_wXRww@mail.gmail.com>
Subject: Re: [kvm-unit-tests GIT PULL] x86: Fixes, new tests, and more!
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 22, 2025 at 2:42=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Please pull a pile of long-overdue changes.  Note, a few of the new tests
> fail on AMD CPUs (LAM and  bus lock #DB).  I was hoping to get the KVM
> fixes posted today, but I kept running into KUT failures (there's still
> one more failure with apic-split when running on Turin with AVIC enabled,
> but that one is pre-existing).
>
> If someone wants a project, SEV-ES, SEV-SNP, and TDX support is still
> awaiting review+merge.
>
> The following changes since commit f77fb696cfd0e4a5562cdca189be557946bf52=
2f:
>
>   arm: pmu: Actually use counter 0 in test_event_counter_config() (2025-0=
2-04 14:09:20 +0100)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/kvm-unit-tests.git tags/kvm-x86-2025.02.21
>
> for you to fetch changes up to 8d9218bb6b7ced9e8244250b8f0d8b2090c1042a:
>
>   x86/debug: Add a split-lock #AC / bus-lock #DB testcase (2025-02-21 17:=
11:29 -0800)

Pulled, thanks.

Paolo


