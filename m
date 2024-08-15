Return-Path: <kvm+bounces-24292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C035953761
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:35:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8107FB26D35
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 196561AD9FB;
	Thu, 15 Aug 2024 15:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cuu5YhcL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF02F1AD3F5
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723736106; cv=none; b=JYaeRLot7FdW/Hv+IJLtCPVO184Ohi/Yet9EYE+CZVRmN0kY5oL4PvEiRo5HcPDrUVBxVKOoRtxoKu8VPVoYdNBQW/XKCCDZuDJNQA8PKMZWW89JRMtg4OncTa3Cscw+7DPfBxsYnfCxCGUjt2AjiwEl3dx9saweQ2OtEEt65mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723736106; c=relaxed/simple;
	bh=DlgIgxiBhFo+jkPhNWroCaQoTF2NUFeY46QgxhB4eIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PiEna+ng5yzDSujXMjnzu0L15Cb4FfDr7A6/g2YQ4+51a8+4wRLWilhzXZuZt0TbuBs5AFPR1h3wdHah2cd3zYBki7qwJ+Ih49eBxmWGbgJl1YtCUnopuz9xfMBqDygRxlfEpJs80P0aXxcosjcPJkWE2BmnLFwsFprWbHErnS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cuu5YhcL; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02b5792baaso1539866276.2
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 08:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723736104; x=1724340904; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a+itA/Bc7wc2NOvtIx4hiwBZycvBwEsvrVCKhgDY/aE=;
        b=cuu5YhcL39vJK1m6fp0YVlXIdoi1Dqs+LcCP4KTVu3LhRA1UPxqCnI/XNjM1o1QLPa
         mnZDA9QTH4T/0WPAPVQaVH8sCuDp/8bvEetFZEpFi5iV3HqSXGl1C7/fq49FUyzQ70lX
         SwGOt4WIRHQvmPPWvVIWufU61nqyKuZs7YUa1liH1bUSVdZ1ZSwA0TVdDViD+kAEv5Bx
         t4e706PSsAGnCfblFkA10m4OxI3CUuuwOemUW0NUa8LP0Lh3RTyhClmCi38FRprbPqeI
         LiYDjxVdA7RH2QXyvYiz6vxE+w0TDy5TUrOQnboPDAkoRMCA1dFbAfRXw6fvDKzmL2mG
         RwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723736104; x=1724340904;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a+itA/Bc7wc2NOvtIx4hiwBZycvBwEsvrVCKhgDY/aE=;
        b=DYu63JFRZQNXn3nGmk+TqfpD+uZO/6iltRi3+jxuwzSMsfL2jm0MEBxgyMkGWNwKdR
         iUATJQ63czyVfW95sGdl0uV3p2Xf6KnVef7A79PmNqmUgvaM33g0ZaFDl99uWEzNaR+O
         x8GVz6v6KdWBbBIKUSayjcFPQgrJFLnFCyiDFfY6AhtfainL0hLqoFSCHB2oJpclhIXF
         3tJStI3uBr8TdiQvTfclhaeFK942EwnE+3x0mFIENklHbaouOXyiJl5818UNp6q4UFm8
         Vsmw0bgXevnxMaiJuZRjeho7BVPeIoAheLFnsrXocyjhDui0BSJUVbEhdCs3OvSZ7SGf
         tE3w==
X-Gm-Message-State: AOJu0YwuZVvyAx8jjva/cW5i1clNHTrKzGaVO+4r810KsBmZrQSAD8FY
	DPEHnaBLPCuSulsn7xRerEDPBRq+0DekctX/u6OQwwJg4HF1xs9zQG9U7Jqab4CJt1K9Kz7u7I7
	hTw==
X-Google-Smtp-Source: AGHT+IGhR1zH4j6I9fAAa31KTuPNhDg/X4A7emGYjLgG9jRUqpbUY6N3z5f2ToBOisNvkawZeUggGOyAZRI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9b09:0:b0:e0e:87f7:f6d3 with SMTP id
 3f1490d57ef6-e1180fb1623mr90276.11.1723736103780; Thu, 15 Aug 2024 08:35:03
 -0700 (PDT)
Date: Thu, 15 Aug 2024 08:35:02 -0700
In-Reply-To: <bug-219161-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-219161-28872@https.bugzilla.kernel.org/>
Message-ID: <Zr4gJtOFtiQF2Y_Z@google.com>
Subject: Re: [Bug 219161] New: VM with virtio-net doesn't receive large UDP
 packets (e.g 65507 bytes) from host
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 15, 2024, bugzilla-daemon@kernel.org wrote:
> Large UDP packets (e.g 65507 bytes) are not received in VM using virtio-net
> when sent from host to VM, while smaller packets are received successfully. 
> 
> The issue occurs with or without vhost enabled, and can be reproduce with
> 6.5.0-rc5+

Is this 100% reproducible?  And did it first show up in 6.5-rc5, i.e. does
everything work as expected in 6.5-rc4?  If so, bisecting will likely get you a
fast root cause and fix, unless someone happens to know a likely suspect.

