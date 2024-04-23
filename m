Return-Path: <kvm+bounces-15582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E2FA8ADB06
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 02:26:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AB1A2856E6
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 00:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D2A18E28;
	Tue, 23 Apr 2024 00:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ynv7kj91"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9761823B1
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 00:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713831361; cv=none; b=NcYLUrDMwcMq3Po3NS8D/xWpWfZduf75TCCmv6/zthbj9YVIptwqpxqjEXbYtNlAiyvP40o+iSX1t2bLEP5lMIqNjZc31oEawtBP88gQDNWcjS7NydIpy9DziOmHowVPckoRzaFkDa/zsOn//DknwBod3jwNypG08nTbHbZoKeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713831361; c=relaxed/simple;
	bh=6R2GXPZ8MNR9mzZ3mCyCouRoIEDw0zcCo16JjOYAUNU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iXzquN9AUie8inMqRFsQXVxRz03DvdwVZGGWhF20mrAc3ZvPKnJkFmXQzSnf3NxuEzzp47ZedmbGhPwoW9WKpMpr9wVbsCqAyZ2Bj+lpLvyidQ9UifLQRrvOjQdkHUvHlkpcUpgdbTsisy2Zue8pqMg5QY7e24ArotnIkscEG4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ynv7kj91; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ae0abc0b41so1408847a91.2
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 17:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713831360; x=1714436160; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8H1kEVLpGrJ5ZWFkENA9219fhA8vfTYgGM3sZ6TDcgI=;
        b=Ynv7kj91D6Auva6eOlUk+j23ucxRayP4Tpm2HeLafKzh39dAabTYW+A0amFBD48M00
         BZhxSfnZDFv+EBa0FuUlYuucz2OIBRsXNwcD13T3xkNQj8EA9nJkgzZZIYT7OVkXe51b
         M21UxhDwMlyzAW7qcVUzZ4bnP2mnGotcSMFQlSlQlz1qmL6VwN0GzMA80qKgkSwpC0SW
         1UjGmq5728wtgXPuIQrj4mCL62bAwAv9EKycgH/vaUtKoFZDsKpSBgHR6vWq/eh4sJl8
         WRRWTuVlHCS6LJWAAbKh3ayyLrf5k5IZ+8R+OeF+A9yZ/eaGSQOWkmmQNHJ6Jt4s4VnF
         6yqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713831360; x=1714436160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8H1kEVLpGrJ5ZWFkENA9219fhA8vfTYgGM3sZ6TDcgI=;
        b=jV77Smr8f9uYlEEFBG8lpr0sPcedOm+RrdE9MtDrg8RM36l3NbmsavkX8CNJsQwils
         Ud9+gtiKD0hwwoe3241rNyQ68VXACLR9FyZGty36Itg1N9EYBI+S4Z46jHocC0cgfx4/
         7E4yLofP93rqy/tEeMxo5Eoj34fY7Tzz1BhUSaEKFbYcI45UbEMh0544shS5NcOdK40Y
         ktx8UzGkVCb9BYKCmi374ktxiCzd0Pw+lNy+WqrtVq06mLoCaccy+xvl2Dkj5FYze1HY
         To9WA3ir8lXrywQU8AkP+A5M3G7P31YPhe3eZPf9ZzsIUL4V9+wLCOArRk/L86JGopsb
         cElQ==
X-Forwarded-Encrypted: i=1; AJvYcCUn14/2eHY2TE3XUCc2XXq2PkEydilz20PO0N9KvkOrGkyIcnyBTpET/vSYctRrw1CeHHYMwFHxRiSQ8Q3xTpFBpOap
X-Gm-Message-State: AOJu0Yx+iPAsr5KmHcoCQnjK2T5/F+MM4KJmaTt0Tl8EHGieYN1hhyFj
	g0WgnBrN8PmSlf5L9kZnt+89kOFNV2WWh5A1uyMvaaoHeij1Ey6tLVDQ9dLT23m3y8Yg1TlvGE7
	dmA==
X-Google-Smtp-Source: AGHT+IG/qs/+QwIoau+irouJ8WnFn/4gnZ82DbdmH2gIfH86uzFQlhjZer6qP3BdeeJABXE5gW74XoOxbZI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3145:b0:2ae:6e94:b02b with SMTP id
 ip5-20020a17090b314500b002ae6e94b02bmr5770pjb.4.1713831359878; Mon, 22 Apr
 2024 17:15:59 -0700 (PDT)
Date: Mon, 22 Apr 2024 17:15:58 -0700
In-Reply-To: <20240422200158.2606761-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240422200158.2606761-1-oliver.upton@linux.dev> <20240422200158.2606761-2-oliver.upton@linux.dev>
Message-ID: <Zib9vslQW1iLrBAn@google.com>
Subject: Re: [PATCH v3 01/19] KVM: Treat the device list as an rculist
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 22, 2024, Oliver Upton wrote:
> A subsequent change to KVM/arm64 will necessitate walking the device
> list outside of the kvm->lock. Prepare by converting to an rculist. This
> has zero effect on the VM destruction path, as it is expected every
> reader is backed by a reference on the kvm struct.
> 
> On the other hand, ensure a given device is completely destroyed before
> dropping the kvm->lock in the release() path, as certain devices expect
> to be a singleton (e.g. the vfio-kvm device).
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

