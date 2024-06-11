Return-Path: <kvm+bounces-19282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A11BC902DD4
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 03:04:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B19C1F238C0
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 01:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E167B749C;
	Tue, 11 Jun 2024 01:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0ytLnxIH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C075CAD2D
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 01:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718067858; cv=none; b=R6b8u4JEKGfOyMM40i6zfhqo0e8a3NEDNNuycFWTkiQA1DMX5mKQSmiY4sXHt2R6zxfyojmLtytM0d1TqnzvgMxaZ969PgQknIeH01KhfjWCID+LrbwGp51YAff9WnsQgMl5z9kNj53xVFFiOm7jrQUujLSoOmGLE+affL5Mpxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718067858; c=relaxed/simple;
	bh=D2+4ZRld+LsfdHH5oCEX/3EUmguv5mjwKhehKsHkJh8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XeHiqxVq+SmKbGi48zLI5svzvup4iRdnRqJEVxJkpcksmhICldtVwUMlRnEx2MQN+lAoaBTqjcUPxzgYxvH3heYNmMNYoYDLLBqK5fRsCpT597bvJXJnXi7XvqLaKYmwy9oPb2PSK/Tyea8RTODYHnWtSHLM2CEADoIi/SzX+RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0ytLnxIH; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a088faef7so67151717b3.0
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 18:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718067856; x=1718672656; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WaCxstfADOBw8wNVrRw4wVAYw0tVDjv3GN2v+YDuDTI=;
        b=0ytLnxIHF/N9Dw083KuxQSWGWrGYZF6Q1HkSP03Zx4zcWAIV1I55YrB2lpz4h+ovxa
         ftusB98vsVc+9LmHz2dhRzswiLJ6nMrH6X4OjM/K+aeQc98TYugYHsdOklpI5bGTfpeH
         BtXa9ayxihKXbi5FYQ2uVHyhAmdXNk9i23HDCvJzbzcMG/cNMJ0xWrEL/uFxJ2YL2rcF
         5/HjyJEDqjqIPIOSfWi0xz5iMWjkyDgnj2cel59lsRK/+gKDItQju2kvglvoavfBd4HC
         CGaiNhLMenWCE1ip43TlOCQIO9Ab274aAoa/OpFw0ldR0nFW80BhSKH51qzh+0i90C5N
         RHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718067856; x=1718672656;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WaCxstfADOBw8wNVrRw4wVAYw0tVDjv3GN2v+YDuDTI=;
        b=I64F46MQXBHP8daE8BRxEIH/42ZT1Z7ytFybf/euVbFJj9qccU0O02WcTXQrzK0N0h
         aOwa3FNM42AySmE07V7+i6yy1a8ZVy8sxp36M21da/YZbRCXcgjg2FNPpMQiDuhuUE46
         Q5uwI+LtGWrFJxjNanss0HjPqtf/x2/YSZcg9y7AHozLwg41IBwaZHIqwVm+eRnpuFNM
         3RR6hw3k9rfZ9VCUQN8P4YUAY7ymRtFL2KD0UOaGJdGQKAflNO2azlbu8TVuv9k7AtBA
         FAytrxXeaPnjRtrfbdO8bSm9O0ZvwEs0198uNifV4GFfdelEpivlZPPXuFUKvNYHYfJL
         oOTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtqsC95U4BSGgavZgHlhenwLrJyUcBbrvkLEwLzhALsU984yNEd2NR4JQ4FISYbj6K9selOBw3Ynm2lFTPxEg3outV
X-Gm-Message-State: AOJu0YyZqL4EDUD6LESuu1Ge8SrSyBnDb0cja48BLQ0jtfdLYvtZLAvo
	7vtpDN3AMyzEQo23mNMCN5y1wP2pRn2KXcJ0RYhSPVWP4dFiaPUzqQRnxkH4LwWsEbe2itHfV1x
	bBQ==
X-Google-Smtp-Source: AGHT+IGvBLWBjAlpWDo3F4MrMaWCiT5ovZHraTyxq1RuGeccOfGQ1Zsc/yTzZhOgVxEqKzdr0icpIDmQzrA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1547:b0:dfb:5bd:178a with SMTP id
 3f1490d57ef6-dfd9fc66fa9mr357303276.1.1718067855765; Mon, 10 Jun 2024
 18:04:15 -0700 (PDT)
Date: Mon, 10 Jun 2024 18:04:14 -0700
In-Reply-To: <20240509075423.156858-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240509075423.156858-1-weijiang.yang@intel.com>
Message-ID: <ZmeijsBo4UluT-7M@google.com>
Subject: Re: [RFC PATCH 1/2] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, mlevitsk@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, May 09, 2024, Yang Weijiang wrote:
> @@ -5859,6 +5884,11 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +static int kvm_translate_synthetic_msr(u32 *index)
> +{
> +	return 0;

This needs to be -EINVAL.

> +}
> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>  			 unsigned int ioctl, unsigned long arg)
>  {

