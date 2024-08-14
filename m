Return-Path: <kvm+bounces-24082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88CA095117B
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 03:16:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40653282DF3
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5597D1DA5E;
	Wed, 14 Aug 2024 01:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AEU8blp8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281EE1CAA2
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 01:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723598174; cv=none; b=TdpysAfePMM0UNzRqBq1X8cAfJJFebTbCKe1zPxaiGGgmAFnptw58qIyJWRGBIPjT25KY2+OqdBAnknEpGSW0bcsWfl/F4MJDBgTbuKBaabg0xwCZTcrhzPNNdA7seWs8cdJS/6eUfoYEx4fzNj+cvjxiuq/b93+wBV9gqJZjCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723598174; c=relaxed/simple;
	bh=z8mgkD8Ntm2c5jgeolAGK5y9DHW18+IlDoLC9GT+UXI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZKD1yiuH5Vxy/VVxZKVsuzE1qmjY5vT9tgkYaTNWXwuCMtxbcqq0uTRx+T28kjWhkqOKaAebFEFHjbvcfupkxPGW8KXlbHKe3R/c9L8gyTUYcCwkMcAl/JoTr/4ljkp5wstTrDQT9apXUy8FOiAvLZICfVRMjxnA8cOWHOAy8cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AEU8blp8; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6886cd07673so141426957b3.3
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 18:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723598172; x=1724202972; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WOfelhe6VHyUiXe59m8bfJLZAjNt2oF1DcoEZdb66IQ=;
        b=AEU8blp86HoQWDsof8/VwfG29vCvZZKDtju4JWZ1F1nC1rfep9Am/iBoUpAkTtZ4ba
         0ZTO1iF9bN7yt1d5oNKjejm7fCH5PNXhC+32XHpm9v1TUeY5w8wefnyxnEtZtChtn95o
         no2msZSqCsTq7VtOuX/L7/iBzT1k8nbn/ACU1WoCs4lAFz78A+sRj7eLdV2IJlstXVu2
         9Det9jeAY8kXN6VGcaQQDqXjAHGZ98RUQgK1XPyDlC7tPkcwCBjFHr87bc5tsKUYUtd3
         2oyZtVw6CnlvJqFxrWDtHlALOXBc8gKxIe1x1I4ltrT3ivGqby4GquaJoX+JLX2pGADd
         hWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723598172; x=1724202972;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WOfelhe6VHyUiXe59m8bfJLZAjNt2oF1DcoEZdb66IQ=;
        b=O/FqH532p8v8to167di/vzDfpnv4RDDoBtnURhYi/26eMv4I2bFDDrsTPyiY/0tftW
         43gg3nRPu5SR4RcR/5Jvvf5GADfkbR87BCn8wUmPBPj+Xp+3M8bQTIK851IT+ZSg3dkN
         Ok4xlNx55L6FK1iDqtsGusMEUz7bryujOn0r158tP9+x80C0mOF7Aj+4WzCwR/shLxCE
         /7mcZhhb0rW8cRIaVdyQDGR8VybRCse7ctzrN9tFlrml75CNU7YztLdpdWEP1Zp0dJRz
         joylNEpg1h/wJNAkaNXyv3EWAN+ArGnjEUR2SwD0s41MFUpRWFXQeZ5mNWf0aGomL0Be
         ez4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWUC2QPRLlajx2mrH1FCcxCs3CKXIFiUsLU6KXLiCd6+xy5pCzzYoQiTd9xnXZ6T7vElAA+7hBV1O86rP6uiuiI3de5
X-Gm-Message-State: AOJu0Yw48Qj5JuBHVDFc1pH62DKJvebHWj6Mo9E29/ynROi7unocazEF
	hPqxa/NsmsOsLeUqRZjNU3dn5lc/awFIs+XSQ9BHd2ZUDOvYQtyboqYTCFTfZEPguVp25f0GTYT
	H1g==
X-Google-Smtp-Source: AGHT+IFg1GJmCT/TVBBt29V03c257EzjWXltV/51f725Bwoz9uBL95qbQ0GY+fmLEbQbOFavJPLrqh1HR6c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:f285:0:b0:62d:a29:53a0 with SMTP id
 00721157ae682-6ac99fa8c17mr259797b3.7.1723598171780; Tue, 13 Aug 2024
 18:16:11 -0700 (PDT)
Date: Tue, 13 Aug 2024 18:16:10 -0700
In-Reply-To: <Zrv+uHq2/mm4H58x@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com> <ZrtEvEh4UJ6ZbPq5@chao-email>
 <efc22d22-9cb6-41f7-a703-e96cbaf0aca7@intel.com> <Zrv+uHq2/mm4H58x@chao-email>
Message-ID: <ZrwFWiSQc6pRHrCG@google.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from KVM_GET_SUPPORTED_CPUID
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com, 
	isaku.yamahata@gmail.com, tony.lindgren@linux.intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Chao Gao wrote:
> On Tue, Aug 13, 2024 at 11:14:31PM +0800, Xiaoyao Li wrote:
> >On 8/13/2024 7:34 PM, Chao Gao wrote:
> >> I think adding new fixed-1 bits is fine as long as they don't break KVM, i.e.,
> >> KVM shouldn't need to take any action for the new fixed-1 bits, like
> >> saving/restoring more host CPU states across TD-enter/exit or emulating
> >> CPUID/MSR accesses from guests
> >
> >I disagree. Adding new fixed-1 bits in a newer TDX module can lead to a
> >different TD with same cpu model.
> 
> The new TDX module simply doesn't support old CPU models.

What happens if the new TDX module is needed to fix a security issue?  Or if a
customer wants to support a heterogenous migration pool, and older (physical)
CPUs don't support the feature?  Or if a customer wants to continue hosting
existing VM shapes on newer hardware?

> QEMU can report an error and define a new CPU model that works with the TDX
> module. Sometimes, CPUs may drop features;

Very, very rarely.  And when it does happen, there are years of warning before
the features are dropped.

> this may cause KVM to not support some features and in turn some old CPU
> models having those features cannot be supported.  is it a requirement for
> TDX modules alone that old CPU models must always be supported?

Not a hard requirement, but a pretty firm one.  There needs to be sane, reasonable
behavior, or we're going to have problems.

