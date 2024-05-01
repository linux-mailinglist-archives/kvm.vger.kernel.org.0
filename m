Return-Path: <kvm+bounces-16382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3688B922A
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 01:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5EF8BB21650
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 23:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D65168AEE;
	Wed,  1 May 2024 23:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JZPfk5M/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D41B168AE2
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 23:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714605545; cv=none; b=o3j561eqjeeSe/lDwDHygc6aZpIb88O6COtbN1N5HRQEARIWz5SkrvgPFgECVAQ9P2R340wUQggafSrs7tkL4zxZnS3YlmKEvTpK6ByVoovZTLErNN3/rmIkGDP4oX6KFH77YIU8SskEGt8D7FuLpi9y8f7oX80aslQaO3B+amY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714605545; c=relaxed/simple;
	bh=gYC/W2xaDFXJYpjFLqNWMFw+2VXkrn96q+xybr/GbjY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nLCxdLkEIF3F6zcXL/3PunA0A45vfRHnpMtUoOm/qMKHuKWMD8w1nNt5VRDAEz/DlltOCAkzZs8zFqIyE4cESmIY1T+8V1cEV1g1D/UUNYXRxrYZkS0w970qlboyKymN08SISnUjNgwFSFdqa7TVya+hwYnincW5VY+57gneyY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JZPfk5M/; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ed58ef3e3dso5761008b3a.3
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 16:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714605544; x=1715210344; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8I49xdD+d9776Vt2j9z1NeaJ1EuBZRI/KuJy9t3rDCU=;
        b=JZPfk5M/Qmk7FhXmvLH8JdHQzpXDe/XqwwJzd+RCN0cq0RTw2YF0/wyLZ3Mps3uD9O
         23W3ZaQKi5VPzO0B2iiVj3ySDelBpMWSE2jc0F0nmy0vOKRg+P36X5Eu78ocqJgKDkPM
         avaNGkNyw9RpqK3mzsEGPRI7Zq71C/dsTVC/y1yLAm30E13qvLFc+t9UHT7928oktLOC
         WapFIL/SzOuDk4LOgWY/qfBOF9aI1FbQgIB6USBCyBri2gZf/ukCUxCv1jSVMf6Ol09m
         McE3ZSrAw7t8/ogY0ef0U7Z4npojFrB8FslzMv3p4Fv6mrqcKVtR1aiqJe/lATQUJmRP
         AHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714605544; x=1715210344;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8I49xdD+d9776Vt2j9z1NeaJ1EuBZRI/KuJy9t3rDCU=;
        b=ZyQLALBOCAEeB4vdMKM/B2vozSK9XBFgQt5BgDyPJzU+32Wy2o0EGFua5jy4Gx+dLl
         rHzAXgAJHmlgXa31T9VKIWy7MW+wRyNXb0W+gB1o5wSuVqhJ9KTsAF3eJcctlR2/tNtj
         eNpZVznZzAltmsXk1GPCXpjcZewJe+casJ+zgQ+PfQLo+ly9OyWVGLjif+5f9JkPb8hV
         azCkBGbDVpznvOGNdrMsw/g+OU+E5DI2UT2Mr3fgwUvqh1BVEGhIIjsNi13o2zJyA2XG
         b7zjs2KxCkEUFGnsKtONZ84fBCXm3eVb1omLdM5rSWLiYdrNKcsi4G4NrPMZaAgDbZNq
         BQIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXB0Nolt12IX4hQsjeDKjAKYfvQmehRfTAyZjOgQ49TnjnBQMjDqqt3jdK93jU5tX5/Pro0VrdxTJkh8pstTYI/fon0
X-Gm-Message-State: AOJu0Yw1bfkyoKIcTo6jXeHIVo+i3Nf76BYOMwoqKAGXtTQaRqMt5PlB
	esZr7xwGyTrB+n8/tXU+mwZklaAjywhRX7KHMZZqhAcZyYaUl+ecB03yoZR/1Hyb9nVZztr7EV7
	KUQ==
X-Google-Smtp-Source: AGHT+IHGioM5y7DlQhAaE5h84bb61oIJh9p3OQBuHDNj7qkZt5fkzHadbnSfgpeEs/q9h0bU0gSGOvD+1Dk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:ac5:b0:6ec:ceb4:d9e2 with SMTP id
 c5-20020a056a000ac500b006ecceb4d9e2mr336913pfl.0.1714605543866; Wed, 01 May
 2024 16:19:03 -0700 (PDT)
Date: Wed, 1 May 2024 16:19:02 -0700
In-Reply-To: <20240219074733.122080-26-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com> <20240219074733.122080-26-weijiang.yang@intel.com>
Message-ID: <ZjLN5iGKE6DgEyVa@google.com>
Subject: Re: [PATCH v10 25/27] KVM: nVMX: Introduce new VMX_BASIC bit for
 event error_code delivery to L1
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

The shortlog is wrong, or perhaps just misleading.  This isn't "for event error_code
delivery to L1", it's for event inject error code deliver for _L2_, i.e. from L1
to L2.

The shortlog should be something more like:

 KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for L1 event injection to L2

