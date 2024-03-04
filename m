Return-Path: <kvm+bounces-10814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 075CE87060D
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 16:45:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39ED51C242C2
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 15:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8DD753803;
	Mon,  4 Mar 2024 15:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pjQOMd9n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD46535A5
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 15:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709566796; cv=none; b=RnN0qfGIZUcM8Tjqi7M92TnK0uNyMgh7pqEJ2zqaPr622XrvZhYX53PlDbVKFk+3tV2cmRbW8+b3/ai1QJTOiLn7ud4fEzDFZbtIKfZoX0JB+k0ljNju6gFBnZl2vJMTh9YiUBTYTwpATZslr2DB9QwlZ8vSRj8Kr0sTtzb+XDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709566796; c=relaxed/simple;
	bh=shQrjEt62qkuY/PEPStknZIEtYwjLi3R46vtgT1Gjwc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SdldsXFZrSZCIFiExWOq312LJ1BU59X7A/35Nkt25ZrqdoFQVaX247lk8vT7s0ckq28Hsixkzz4YeNbYPI+gN5YSr9tlVELUA38+E/NpaTsXS736ANGAZy/LNrfJM2afWPQK/AsZlhPbpNpe8icLfV5OK/Rsc6qu5R3qYVCenW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pjQOMd9n; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e4867c8ea5so4592973b3a.1
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 07:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709566794; x=1710171594; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vza9xWJMXOMUri344+UMmZGvA7Qs+hM6357mmEmwEZU=;
        b=pjQOMd9ntKgLhGB0Prv65OAcE80OkcwUX72BaC+ODFy3DF2VvGvs7jocIWw+2pdHGw
         0BQfUMusgpcNd4NmMwX6yF+PmFKYiiNL++7P2xo9L/xBE/9dVZ64A1QQqGeAmJEf44jn
         xOPyYxMloJKL4+CxP01+GDyhFZP8eaWkbDop04MWi0a1r4vT6zga636ubygtbLUZTk42
         ZeFbKIzByn1EYFKC8QqHC9J+F0DHwPGXSqfGV3bSvRnF3vMSpOxqqcxcjBMVm1OwfbV4
         IKlAKTfNNi5K3Vvg5+A17yKpaaSNBt4MSXxfpUN9TcESD/63fw2yMn0H8nnYGIrg9HXe
         YNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709566794; x=1710171594;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vza9xWJMXOMUri344+UMmZGvA7Qs+hM6357mmEmwEZU=;
        b=hoMtQRQ3pmBUzHVVp/lzN4+F3UQmpTNP6sQwMbDMJAaN5+ONEs9jbo2bY1FfJNiZJD
         RGOFcqgAnnne4Ijt0ElLutzBn7Af+dCIabubZyJqlg0PYWE51/7UGnlohPUBpo7ha3yr
         LKww7jk3WL7/VJ7YtBdITMg+zJZYfFFggI9AsvTZFMrZymOxx2BrmH+C+M0GzYQuKoZA
         zDRUw9lcQhXty++OeQVYPDvQWf2fpiSrfKmVuzqTZf1q1hdQeEdS+aDid5hneospEnAd
         wMuXC7UAv7sF5IKuzYihY5ZDbhTQeVvnTDDZStEgQ/8vyly7cR5QDY7vswvFrpkK4R7a
         r3Ug==
X-Forwarded-Encrypted: i=1; AJvYcCU0NyzEdz/H0QnDVoiPqWLY+WypeNT4FrP84otyXvflt6tqHP/3pDVHEXQqsZgfqNO4+gtmzs8IrW8Wp7z0G4Xswmew
X-Gm-Message-State: AOJu0YwDMO2r5Dye99op2lcT78zARKmX74EKih2f5KeY/dVMP7z6c9Ri
	ZTQN2cG8mkW4N+3lngL6ZVeeMYIiB7+upH0jNuy13qMu3H0DyW3Gy/7JZKipuRytrfmuNsSw4ps
	wbw==
X-Google-Smtp-Source: AGHT+IH+lj9uy1KSWDnGhyh8OoTAL1gU4I5lO/6UR1uXo/NLjfLp9ky0/KzkJTbFzvyLJhRWyCTcvSv2+Vk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3cca:b0:6e5:94b0:68be with SMTP id
 ln10-20020a056a003cca00b006e594b068bemr776208pfb.2.1709566793867; Mon, 04 Mar
 2024 07:39:53 -0800 (PST)
Date: Mon, 4 Mar 2024 07:39:52 -0800
In-Reply-To: <754f2fcf-fc00-4f89-a17c-a80bbec1e2ff@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <20240227232100.478238-14-pbonzini@redhat.com>
 <754f2fcf-fc00-4f89-a17c-a80bbec1e2ff@intel.com>
Message-ID: <ZeXrSECZ-CVvk32W@google.com>
Subject: Re: [PATCH 13/21] KVM: x86/mmu: Pass around full 64-bit error code
 for KVM page faults
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.roth@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 04, 2024, Xiaoyao Li wrote:
> On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> ...
> > The use of lower_32_bits() moves from kvm_mmu_page_fault() to
> > FNAME(page_fault), since walking is independent of the data in the
> > upper bits of the error code.
> 
> Is it a must? I don't see any issue if full u64 error_code is passed to
> FNAME(page_fault) as well.

Heh, my thought as well.

https://lore.kernel.org/all/20240228024147.41573-5-seanjc@google.com

