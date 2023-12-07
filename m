Return-Path: <kvm+bounces-3878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE34808D65
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 17:31:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 922EB1F2139B
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163DA481A5;
	Thu,  7 Dec 2023 16:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sMxnsD/8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271F8132
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 08:31:12 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5d3bdbf1fb5so11293987b3.2
        for <kvm@vger.kernel.org>; Thu, 07 Dec 2023 08:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701966671; x=1702571471; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5rIP8xiIeStLAZxAKenikHJEOOwixpMvqcR8yCub0Xc=;
        b=sMxnsD/8UW1venRLzWrYQDXljCWKOCPybe/VCyNmXLC+x8UoRUbe/CX+BfK2BfLY1G
         eKqP3ZyzwFKeDKLM7oZldXIAUOB/zetvlFY/tz9GT5RuRpLTLxljXxrR0vmGL+PX7uuM
         +krG91QILeNdcNNl6MQ2VC92N9PePPlnVNwV9g11dicgZb2moOh7rUedpg+qXQLkAPy1
         5Fvz+4Ug6MRqU2FDMUcf0459sQDtVJeuSDpFxHfWaYClMXAwcBxXI54u0zGubc5luK1m
         Ye9J3cRNnOhQNWSW6RY3G/aOovyumE8hmy33WY8yYfNX2gsuRrt3HrMe7PFqHmJQPlZX
         k+DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701966671; x=1702571471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5rIP8xiIeStLAZxAKenikHJEOOwixpMvqcR8yCub0Xc=;
        b=uLWzuAk0oVQnMa8oUxZGw9rxW6khrIG6Aizb/xr/0Wb0Z/3R1HLEtVBlcIylX8ke8n
         Mo84bBe6NfSoBZvr1xJpazoIuzm6usMxnUDDh9BFpSb9omrjIxrgpgtWMJYqjbr1HeRD
         YAOmBN5VdjAWm7gtZimLMjhoq6zFPTjx+5arZI+56w2mbmzC7QCWLaMvPR9o4CYcDXtk
         J3yPLeJxFhLF/ND/bu8gLfXJrCPZsWgiwPy6MZNQvhQUSP8xZWuQX2fwDu8511AnHwDH
         f8qGPE7gigu2qu3Z+R3BPckmJOstyRsKolIg/+G8DcxlOPF2P7URJEbV+KZGrZoXHcWl
         JbuA==
X-Gm-Message-State: AOJu0YzSeR3kpgZ9ePBPd8jxF43IcLCdyHb84UDoBdJwyGt7DfiSPWoL
	kfIF5rQq8RuQoDR7gogyNIMTXJVImXY=
X-Google-Smtp-Source: AGHT+IEh9Rr8D8QQlvOmctOaR9hVclvbUIw+QMeJkaeNbeH5dAiquzhAL9U2TiuYPw8pniVHDfDH/0NQKc8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cc44:0:b0:d9a:e3d9:99bd with SMTP id
 l65-20020a25cc44000000b00d9ae3d999bdmr35659ybf.5.1701966671331; Thu, 07 Dec
 2023 08:31:11 -0800 (PST)
Date: Thu, 7 Dec 2023 08:31:09 -0800
In-Reply-To: <6cd419ff-97d9-495b-bc9c-0c53c4b1e3d1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231206032054.55070-1-likexu@tencent.com> <ZXCTppx4II1sbRAl@google.com>
 <6cd419ff-97d9-495b-bc9c-0c53c4b1e3d1@gmail.com>
Message-ID: <ZXHzTaZU1TY_HEVC@google.com>
Subject: Re: [PATCH v2] KVM: x86/intr: Explicitly check NMI from guest to
 eliminate false positives
From: Sean Christopherson <seanjc@google.com>
To: Like Xu <like.xu.linux@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andi Kleen <ak@linux.intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 07, 2023, Like Xu wrote:
> On 6/12/2023 11:30 pm, Sean Christopherson wrote:
> > Please don't make up random prefixes.  This should really be "x86/pmu".
> 
> Thanks.
> 
> I'm hesitant to categorize about NMI handling into kvm/pmu scope.

Why?  Literally the only thing this can affect is PMU behavior.  Even if there's
a bug that affects the kernel's PMU, that's still x86/pmu as far as KVM is
concerned.

