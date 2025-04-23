Return-Path: <kvm+bounces-43939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 439B8A98C72
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 16:10:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54557188712F
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 14:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931D12797B7;
	Wed, 23 Apr 2025 14:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V8CcBw+f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D88E279788
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745417408; cv=none; b=YMt/zeL4cex1Q8GcssHJtvYB8kB86r7VbA+0kdZkvE+tLtmdPOHoS9PnQBo2ocBfXPG4u/VRMwifL+YySW4K2DFy0fYJt3AyeUgLO4hfQNI8p24DjT0CbeIzszB+u4IPeQkYQr1EMfikoiOvSjt3B7Fqd7UNvGtuO+xuXUsxPm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745417408; c=relaxed/simple;
	bh=X9801jtcGt2ADqc2ZeoS2Vo3azbHPuBMJhgk5SSuVc8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AeXxASeQp6ev9fNWo7zxEuqXVsIZVbaKXkS7MqgMCWUifU1o/aNpRQagcP4pdT7St0tpMYUtjrZbfiUnyoSMGahfjSDuRIzDpzLSLdyOkwiK2mXDu1ipPeijOs7Z21M53buVh2QA4kIWVJ9AcaSl7L26s3mzXZ7VFtEZvlTe7b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V8CcBw+f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745417405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X9801jtcGt2ADqc2ZeoS2Vo3azbHPuBMJhgk5SSuVc8=;
	b=V8CcBw+fAHCzEXT94j/t2SbZywsPcFK3HwjIBbm/NgoEBNnyT/bqm8Wo9wSKOxTsH8d3GN
	GrMacNwnjoqIzvAw+8ue7X8r4ccZjTgpiK8Yz2bS3lklCv92Jq09A+dv8rhEn1JFb8NjXx
	ORQpSoghYX0wAIhmirKve1pEFLmYzw8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-Ahgz1jJRN16V79ADycXt_A-1; Wed, 23 Apr 2025 10:10:04 -0400
X-MC-Unique: Ahgz1jJRN16V79ADycXt_A-1
X-Mimecast-MFC-AGG-ID: Ahgz1jJRN16V79ADycXt_A_1745417403
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43ceb011ea5so36660695e9.2
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 07:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745417403; x=1746022203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9801jtcGt2ADqc2ZeoS2Vo3azbHPuBMJhgk5SSuVc8=;
        b=N+Mw/zs8OSGyXKNiTTEfU8xC8cGi/cXxcO35c7M9Ekm1q/Oy0QsooqHOMHsUOVG9xi
         oyI7Hj6z4ZfLKpu/ofz7Xwu0IX+dCLGzNeV03z8PXMiq4/l8cxS+J+RA8FqLPEsKtLbY
         OgiMTVjHVnKXWHNYglMDKRELvlLxsonBXBZPxlwpNNZxyVtJB1RCdRi0iQ65Vv4XXUce
         TDOPwrOq7WTh4rW4VlwGh9/pf5nClJs7xA+YnVhl7wTPsJcosvSXaj/2oOC7BWkO4iMd
         xJ6s1IJ7wl/FXgiC8D82KRPHd1LQhpSEH12GInJzQQZ6B1HfFvjDSLcTZfp3lFNyeTgQ
         OYaQ==
X-Forwarded-Encrypted: i=1; AJvYcCW47rYrDw6ObuNn/a7p+99wgQqhYshsAKiTBRWj+8aDHnn3dfClqFQWasc43okAHQ97zE4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQJsr2AScliMNqY45JQdfj4tUx1Ye4l+bImVZjzwpgWejqKung
	MeoQmhDHAqhdVftLVpWT2AsrakBoStwFA10dg9OwmZPotv0mM77tR3XjEZm6cwcSJ/V4Q1HNKIK
	4GLlDQwA6RPXkPZDlUJ1jWvA9QKFoCDtuWUu9plZ71kEQa6Def0RJc6xWPlrBOJ+wfGo/kRpcVX
	eXUZNd4CpULHsd8LKsg13tp6rs
X-Gm-Gg: ASbGncthL0SIETieu0VlpFVUi9YA/3ZVZ38alXOtwku0/9m6oyztjwzRnIf1XA0cvYz
	+oT/qBfP9mJ6Qyq5OGqGtkVyC0EgQfAdMU5AiDPuGKghzzogXYl/dES0t1NOG7xQslodmBA==
X-Received: by 2002:a05:6000:18af:b0:38f:3a89:fdb5 with SMTP id ffacd0b85a97d-39efba39855mr15995167f8f.11.1745417403440;
        Wed, 23 Apr 2025 07:10:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgaKf98YsLH0iaaJkC0aj3Aj/TgBF3/HR1AIV48cEH/gLicMvJX/jsuTJnYZtNegLwl9+iUrnZ/R42BybYCxU=
X-Received: by 2002:a05:6000:18af:b0:38f:3a89:fdb5 with SMTP id
 ffacd0b85a97d-39efba39855mr15995117f8f.11.1745417402926; Wed, 23 Apr 2025
 07:10:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <da3e2f6bdc67b1b02d99a6b57ffc9df48a0f4743.camel@intel.com>
 <5e7e8cb7-27b2-416d-9262-e585034327be@redhat.com> <86730ddd2e0cd8d3a901ffbb8117d897211a9cd4.camel@intel.com>
In-Reply-To: <86730ddd2e0cd8d3a901ffbb8117d897211a9cd4.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 23 Apr 2025 16:09:50 +0200
X-Gm-Features: ATxdqUFMMhPKvZrNqSWJCYegxp5nIsjuowdqQ51rVDGVN0iEChNq7O-QjHWqW8c
Message-ID: <CABgObfaMRjeyhnP+QvTcZ+jKb6q-opCQ_a_MBFbj3AYF0ZDewg@mail.gmail.com>
Subject: Re: Drop "KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall"
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Shutemov, Kirill" <kirill.shutemov@intel.com>, 
	"Wu, Binbin" <binbin.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 19, 2025 at 12:16=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> TDG.VP.VMCALL<INSTRUCTION.WBINVD> - Missing
> TDG.VP.VMCALL<INSTRUCTION.PCONFIG> - Missing

WBINVD and PCONFIG need to be implemented (PCONFIG can be a stub).

> TDG.VP.VMCALL<Service.Query> - Missing
> TDG.VP.VMCALL<Service.MigTD> - Missing

Service needs to be implemented and return Unsupported (0xFFFFFFFE)
for all services.

> TDG.VP.VMCALL<GETQUOTE> - Have patches, but missing
> TDG.VP.VMCALL<SETUPEVENTNOTIFYINTERRUPT> - Have patches, but missing

These two need to be supported by userspace and one could say that
(therefore) GetTdVmCallInfo would also have to be implemented by
userspace. This probably is a good idea in general to leave the door
open to more GetTdVmCallInfo leaves.

In order to make it easy for userspace to implement GetQuote, it would
be nice to have a status for Unsupported
listed for GetQuote, because they need to add it anyway for future tdvcalls

SetupEventNotifyInterrupt can be a stub if GetQuote is unsupported;
therefore it's also trivial for userspace to implement it if the specs
adds the "unsupported" return code for GetQuote.

> Xiaoyao was tossing around the idea of adding a dedicated "not implemente=
d"
> return code too. It could make it simpler to evolve the GHCI spec vs the =
all or
> nothing approach. To me, the main finding here is that we need to have mo=
re
> clarity on how the GHCI will evolve going forward.

I agree that both of these are independently useful, the main action
item for KVM being to move TdVmCallInfo to userspace and add support
for the other two userspace TDCALLs.

Adding WBINVD/PCONFIG/Service is also something that has to be done,
but less urgent since nobody is using them.


Paolo


