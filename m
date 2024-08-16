Return-Path: <kvm+bounces-24453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 366B795530D
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 00:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E659428730A
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 22:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD876145A1B;
	Fri, 16 Aug 2024 22:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lBNIKBTH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931A01448E7
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 22:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845859; cv=none; b=MVSdX5Hhpc/z0dlVKw9fF49I9kpqOkVuQA87TEhmzZI/DbqMaoaAJIkh2+EPdF7FCcVyEV+nJegL2w2VtIl0DJipVjbh9yIzwwctno9ayEwUErS1PrWb/z/tSoIsbp7pc+rynplhYVxrvuYzSREiLlLC762WqGxHAMU2q8M3HQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845859; c=relaxed/simple;
	bh=KW9D5wVU77tNQ3/L82+SRnU+J+FVG21c6UL2U3LRiFQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sPpIvk4GwZy5N7mxcYmRFOfC+L/Qmoj+Ol50kZqQrZm/QnobZ2a380wZleszkC9GfCBSChNpsRH+2LVc6Pj5QmTHbeuUa+FYWuSX+FXgAnbrYwh5QJeKGtehU47jDAp2Y7Rl3Fqo2f0XDEQZiShkjB6Sdj4LMoFUYlQWRXvJzIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lBNIKBTH; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-69a0536b23aso44196447b3.3
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 15:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723845858; x=1724450658; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KW9D5wVU77tNQ3/L82+SRnU+J+FVG21c6UL2U3LRiFQ=;
        b=lBNIKBTHJ7DidOsalBFxEAycAcM7jaPXzMjoATR5hrBeGGaV9Kghuvd5FRj16yXQUz
         V9WjlUSlSxNcfjmzxT3ueZnOTuV9oZ1t8k6AonBuoQkPMyYf9T6m8sFO73mjdE8nHHUv
         EBnpw9Yk2Qxlp7euzzlT+XHPy7MwCjRLz4sztwnnjynt5GlvkUv7lHtmqXY9BwMY78CX
         HFKXu9Mmqokm1TdhAUmASowna2pec6tig0boDgz5UAbyUPAxXEjU+WvPqmufWK3FcEeX
         c+B5D1bDxQGQKl+Xhj8YrJJr7+g81BqZbsikODV4HRtMchsALvvNICUY1DdsgJjcXYgG
         BMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723845858; x=1724450658;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KW9D5wVU77tNQ3/L82+SRnU+J+FVG21c6UL2U3LRiFQ=;
        b=MKGZwEgjxN5JeNElBhChe3L+b/1csLbrpLxn/IxGZydFW+X4V98RFpg4zbqB14US/t
         OF7ugHJ1YcOaLEanhYPD0tMuQQ8EVihG2D8nkz36ude+cY5g7/HC8/09jdb9kKC3mlRV
         ulnvDeZHpm1laazlF7TDvMlGaJFGoD/OOcZSrX4IM1FivKZV0HBpl1ckVRJxIjwHht6g
         UwI4mdlb4j+3m3EcQC4ZAsmuN8NCxKOVI9aX8fYqa35EfHEW4ApzfaD/cnJS0InF1lJ2
         NIy+KHrpvggtQzAlP5891zxxfGvrOJvp828gB97m4HT+nDd3jCC6oaoW/IwGCq0J+wpO
         vOqQ==
X-Gm-Message-State: AOJu0Yya/Nhbb7E9tXMY9MGQ/d7R+vbORVtNl/VgZpq+ZPD7pAAUQAMe
	vUGK4PcsadKvbndGMkoRmiNdmr1wiyvpGf1w7s4eHV/SaJuX3Aacq+fgWKVh1NOqOJP5awrfICf
	0Jg==
X-Google-Smtp-Source: AGHT+IGiXCTmOHYZrpZ5ro3nY0FBiXL9B2iTr8Z2RNZbiKrDwiWMXpDu7b0F/AQ1zuqdMV5L0qIZpi7Rif8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3141:b0:6af:623c:7694 with SMTP id
 00721157ae682-6b1b213ae21mr1025967b3.0.1723845857802; Fri, 16 Aug 2024
 15:04:17 -0700 (PDT)
Date: Fri, 16 Aug 2024 15:04:16 -0700
In-Reply-To: <20240815123349.729017-5-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240815123349.729017-1-mlevitsk@redhat.com> <20240815123349.729017-5-mlevitsk@redhat.com>
Message-ID: <Zr_M4Gp9oEXx4hzW@google.com>
Subject: Re: [PATCH v3 4/4] KVM: SVM: fix emulation of msr reads/writes of
 MSR_FS_BASE and MSR_GS_BASE
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 15, 2024, Maxim Levitsky wrote:
> If these msrs are read by the emulator (e.g due to 'force emulation'
> prefix), SVM code currently fails to extract the corresponding segment
> bases, and return them to the emulator.

I'll apply this one for 6.11 and tag it for stable, i.e. no need to include this
patch in v4.

