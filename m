Return-Path: <kvm+bounces-16555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB618BB853
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 01:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC3C91C22A9A
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 23:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B36C784A52;
	Fri,  3 May 2024 23:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EEqK/emM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A55290F
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 23:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714779328; cv=none; b=P23/If4XuausveWTnff8EWD5VC8Vj+tFGgB4HqSSrLAFitQ8d+7/pcbS+SRbXV058pHzEGkOGOCvkzSyuX4/fu18zqubvp6Bet3Ts9DLOcEkwo5WYGfP7dz4w0gKi48HkXgXrfvbxuTKQFpdZmtraE1ZNgX2k41+u3QwphnNmxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714779328; c=relaxed/simple;
	bh=W7JKygYl8eskl3dz8qGjVaCSjrp4hDQ9YlUE3FFemx8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sTwSxoSGI4oK/UR+gtFG52CKtsXQb89iYyOG+xZOjtuw4qlhks434ZDYMalvYdz97khCRNc1PcdqyCtOthO2nk57LIS9XdoWKNsUidS04c6Ox7mpU1kwKWBnOKPBQYCrQZ4kb384h3VKPF1HX6S13OR+16ikNoB0Z+jUeN25Lt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EEqK/emM; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ec3c838579so2156725ad.1
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 16:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714779327; x=1715384127; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=91IIiR1XQRkAX8A7XAuqrLbcyfhRni6O+FhCcC8s91M=;
        b=EEqK/emMg6ASkTA8kE3ROQWNGbm/PGNWB/wXMUzfg06h5ztEkG2vDk5BtoxJKM5wiw
         dwdp571n14k5ELAesxf9sGv+CTU7OoJ4ktDYDFVolX5pDVj20jFoYj/H+rklnSE7TXjl
         CMj+V0+cz3+LiyvYtGz99M3aFqaLtzzEIr7I6kgz4gOeLOUvJGM5Yhh6pMY650t0KZsb
         rKGr/8cVkQM0DqFhwR+/ywsmIDa1y7Q1ZJS/wEuh5WH04lNWIoPMTu/mh8m6gUZajo+p
         YdXhpvrOQt3IagIxMiwVFqVA1s+8Ii9ieOQH6CIDrmkM2PNL6+rG9GktXLaxMd/XWeRE
         xh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714779327; x=1715384127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=91IIiR1XQRkAX8A7XAuqrLbcyfhRni6O+FhCcC8s91M=;
        b=ZK/arOAPFOlHRqmx1idx4ewB3nvHfLUrihLv2PYvq27p+ZhI0gbB4pncK8TGwuV3Bw
         pEAzMZET5lZXDlVHHK7oaW/iRsBIvZjkRLaaT9Gc25pDrLM3vdmyp09NyD7KlynzGbCa
         MEe2EQ6fssu9PdI+INrfTNAI8pw2NIeSs0Q2Zr7J7VJYVMwr8qItloJz7PrWSx2b8jLA
         WGSlZ8SmcGrlnQB/f4W5oQdt6zbzQrypnIU6Orc16ZVF+v6S85ccvQa0TxOjs5M+krMZ
         rd1m5YWdmhsQzLSXAJ84NUj7ixcFwrbXglVj7UOA9SWZTwtWmm72deUI0o6d08ROCx9S
         Be1g==
X-Gm-Message-State: AOJu0YzAzSinchfpfp79b+HD6vLwr1tQi71STA+zQuu36Ug29XiH8czD
	Z+16kiT9+PYyq0B9BOQSQ5pgC57avtz6vlqYCf15//iYyJnqxSs0gg/rq0XXeECYLaxdILS/V51
	prw==
X-Google-Smtp-Source: AGHT+IGMZ6cJ8Sf0nPDYlfXNRVfuXhFTulcBRkWYvM8jh0I9vjK6QgBjaF13tfu4xUCF1sdWePuJQ01lQsU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce81:b0:1eb:50eb:81bc with SMTP id
 f1-20020a170902ce8100b001eb50eb81bcmr195845plg.13.1714779326723; Fri, 03 May
 2024 16:35:26 -0700 (PDT)
Date: Fri, 3 May 2024 16:35:25 -0700
In-Reply-To: <3564836-aa87-76d5-88d5-50269137f1@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <3564836-aa87-76d5-88d5-50269137f1@linux.microsoft.com>
Message-ID: <ZjV0vXZJJ2_2p8gz@google.com>
Subject: Re: 2024 HEKI discussion: LPC microconf / KVM Forum?
From: Sean Christopherson <seanjc@google.com>
To: James Morris <jamorris@linux.microsoft.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, 
	Thara Gopinath <tgopinath@linux.microsoft.com>, mic@digikod.net
Content-Type: text/plain; charset="us-ascii"

On Wed, May 01, 2024, James Morris wrote:
> Hi Folks,
> 
> We are planning our travel & conference submissions and I'm wondering if 
> there is likely to be an LPC KVM microconf again this year.

There is, thanks for the reminder to send out an announcement[1]!  :-)

> And if so, what would be the best option for proposing an update on the HEKI
> (hypervisor enforced kernel integrity) project?
> 
> We'd like to demonstrate where we're at with the project and discuss next 
> steps with the community, in terms of both core kernel changes and the 
> KVM-specific project work.

Proposals/abstracts can be submitted via the web portal.  Though to be perfectly
honest, for where HEKI is at from an upstream KVM perspective, and especially if
you want to provide an update, then I think KVM Forum[2] would be a better fit.
(I haven't seen an official announcment/CFP for KVM Forum, but the web site is
live, so I assume it's a done deal).

The most contentious aspects of HEKI are the guest changes, not the KVM changes.
The KVM uAPI and guest ABI will require some discussion, but I don't anticipate
those being truly hard problems to solve.  And if you really want to get HEKI
moving, I would advise you not wait until September to hash out the KVM side of
things, e.g. I'd be more than happy to talk about HEKI in a PUCK[3] session.

[1] https://lore.kernel.org/all/20240503231845.1287764-1-seanjc@google.com
[2] https://kvm-forum.qemu.org
[3] https://lore.kernel.org/all/20230512231026.799267-1-seanjc@google.com

