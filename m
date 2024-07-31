Return-Path: <kvm+bounces-22717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 698AA942446
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 03:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 250E9285B67
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 01:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D6C6D2FF;
	Wed, 31 Jul 2024 01:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="37gUwIbT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5038F54
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 01:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722390477; cv=none; b=K5AJlHfibFWSq+2+lAP7b3hsA8GmvoSaN/Xm5lMCC/JZlsmVxgBNuFSP8JnFxIfkMk0ECLIzQhhzKYI0Xw2BbkdOjC3kWOdP+qDoc6hj2b+yMOr97vNK/Cnkj1OThze5H5SrRFHRniORhLf9MxY4GWO9FvKrpCBbLVidjJJbbis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722390477; c=relaxed/simple;
	bh=+iQcFbOlJRCczQhEreQjP3SmlMi8onqZha00zOrWo2I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KO3Awp26AaTsu+8uJM/bAfVA28Ux8iI47pCiT/DQSV0DJpCBFTBH0ZFfNv0wAoEvCejVVfDKa2gKMkoPyz1JYPqEsGfcESBZyHwTbDYlCEnz6PZ6XzUtyqPkQ50RJnArnTCVGlNijmBm+wejecnXiiBiHJfER+Z51WlURKN3L28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=37gUwIbT; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-650b621f4cdso92069167b3.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 18:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722390475; x=1722995275; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=06jsxyZajztd/RQqbC2iLXGbn23JnW5HDcAP1024SBE=;
        b=37gUwIbTnysuXb/5zKjl31cM5CUPWVjfFkTkWmwHc7Ask+/dX/sH4MnKFs+XYTSsI3
         76IyqLhryVVfRXHKCBmPdnUMS7N8oTPOzzXiTT5bGSz4xgUMbFJnFf0fSiym0UEl+Gfp
         PLwZEXUbAomKqJ6JrxwCEEd5qlWEkZZ9yCac2qsctXjcDkmFm+p7cFhAs17gk644ohBj
         fNDso4Em4BWdY2pjWP0yLL/ka9RewlwHaiMWZJJxfhfX3jZlwFeVmwNEhC6xod5qVCXH
         hieHbxCfVYZ/dt5P/56Y/oZxdrCRfSBMOWrLfroPOKPu++ejLSSQcdt8Zi6nWmOLHtvt
         P8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722390475; x=1722995275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=06jsxyZajztd/RQqbC2iLXGbn23JnW5HDcAP1024SBE=;
        b=v0bxHv2CGR5LFO4JMSbHVc7kcsce4JZNp+ZH7OG1DGuOWVfOTnZFmCZqJ9WLst0MPa
         tvETw1Ckfokcjl6n2Y12D4qn2oWsfRVRyh5jybQDcY+YvdzjOpOlK+QpvfeuPxEBeKYV
         jV4/+mYloTwYVR6j8qS7LEQTdheA6DganZJ8wNNJwKQ6j3ZyDHPHMqiLagb7VBcmLfIM
         /JWc7F/K6KXbN+U9ZdMQsvenm4Mw5su8VT0yd5ITa2ev3HbHtPBoC2QjZU5RESRq1VgR
         SDP5JI/LYuCMRuaVlrRsOU0K0cU3CjqNnQkjEbqs/+Gik9lQS675RCse5gElAUdehG9l
         hx0A==
X-Gm-Message-State: AOJu0YzOouJNX4dKMRCxKKubaKr+zb92f68vCvJAXqhE5QXOkAwaScGu
	1/tlWd4JUQEGcX5TKbDxe1viOgcjOuKVrq1N7SroSIIdCCXi0OMjjW+aYBkY1+CG5ERYDW2Ju4K
	hQg==
X-Google-Smtp-Source: AGHT+IEJLbTouvKnJNNZVYCvhBgXkeDYZebfKAGOEUFTkWxUInfL4M0WNEe5CAMP9A9TGlacxBeP2VT0CLE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1144:b0:e0b:958a:3344 with SMTP id
 3f1490d57ef6-e0b958a374emr327790276.10.1722390475095; Tue, 30 Jul 2024
 18:47:55 -0700 (PDT)
Date: Tue, 30 Jul 2024 18:47:53 -0700
In-Reply-To: <bug-219112-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-219112-28872@https.bugzilla.kernel.org/>
Message-ID: <ZqmXydOVr-LV-5mZ@google.com>
Subject: Re: [Bug 219112] New: Machine will not wake from suspend if KVM VM is running
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=219112
> 
>             Bug ID: 219112
>            Summary: Machine will not wake from suspend if KVM VM is
>                     running
>            Product: Virtualization
>            Version: unspecified
>           Hardware: AMD
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: alex.delorenzo@gmail.com
>         Regression: No
> 
> Steps to reproduce:
> 
> 1) Start a KVM virtual machine with QEMU. I used Quickemu to build and start a
> VM. 
> 
> 2) Suspend to RAM
> 
> 3) Wake from suspend
> 
> Expected outcome: Machine should resume from suspend when a KVM VM is running
> 
> Observed outcome: Machine will not resume from suspend

As in, suspend/resume the host, and the host never resumes?

> I tried this on 6.6.42 LTS, 6.9.x, and 6.10-rc1 through 6.10.2, and ran into

Have you tried older kernels?  If so, is bisecting possible?  E.g. there was a
somewhat related rework in 6.1 (IIRC).

> the same problem. Unfortunately, I can't find a kernel version where this
> problem isn't present. Nothing gets printed to the system or kernel logs.
> 
> This is on an AMD Ryzen 7 5850U laptop.
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.

