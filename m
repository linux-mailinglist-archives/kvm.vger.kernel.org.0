Return-Path: <kvm+bounces-18933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 232898FD268
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25FCC1C23A42
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B984314E2CA;
	Wed,  5 Jun 2024 16:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qK33GtZ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B46D19D885
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 16:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603448; cv=none; b=PY0KZumt6YgSCQRKOBUP5PxjLYFRbX+C5VlDZMNH/cdP51h6Zp1NJbW9AqQIDWzQZqPZGfwDyh7GuV0RARnrDpwh8pV+sevNcpoFtdqu1HsAtfNVZ5PzQqYi+iTx1F0eypH+dR3PfO/VOX97qpXjB97O7WrjU/kfNT8Apr4A8XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603448; c=relaxed/simple;
	bh=rmJzrFm4SdbBbY8BjGM/GGrNJs/dT5fLnwCiWpZRogE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RSb7hmAmGrpEh4lqI1AqXeoP/dCyqaIChIuaZH5rZ3h7ZNbNKHR4NTRR6dg5k4en1kgfEjNEJALtcUOGNrgxmGEOMfGdR4EXikXFrO1Bi/02l/mHF9eVMo8rWhiuybBC5wriNjoJaZ1qv07gl7a314s+rakY6EumFh/QCIL1F9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qK33GtZ3; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-627dd6a56caso917557b3.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 09:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717603445; x=1718208245; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D2IoWH/dimEhXHy0+OwTrd/RGg1sXvg+i9JDPdG/rtM=;
        b=qK33GtZ3gjQaGxVkTAVOKApZd3smWCvA6Ftq12q46JHGUnPhO9GTVfxoCqF4cfp42L
         vH1eAqiym1tXwpGkoHUor9eZ1urQ3+st75zBzxQHlJYsCCxay8DVAyplrwyz8Cu3XmWb
         /gkUDXBgLEeXuGTjf/0TDEc3Bu1UHFwQSL4IEAfNYzLSf8DX1BHhhnwjtzUOZd3NF/Jk
         +f/tLpyh3+9wdg03gc5zPoq0zGIWIjPaaBeS4tNX8kt95c+CL3Safs0b/oBMysFZeORi
         Ldf2io0bRGyYCIs7F2MFpJONbOgYMtqjkuTNfJDHNAhCMo9vomEzf+EAlednGtVl2+d5
         kHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717603445; x=1718208245;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D2IoWH/dimEhXHy0+OwTrd/RGg1sXvg+i9JDPdG/rtM=;
        b=kUhXvRxKpG5KhP8GvnwiGtbx8IvrTlNNNOVWywfyaBZ4nibb3CL+p1pLHxfBXkUn4B
         VWs27ytDsRFilgmecrXO2t3JGZ97bupNJuefapoNIzT9k2XHUMxic7n3gL7vK5ROE/Fr
         KldtSUM3KDmUTiMVaQX2Hg37JR6q3RG7NqVF0m1sd/wgVl0t7v65WeOrwK9Bhnt+lbZ9
         0DyXEiklVg8ud4P6dO8TWljMiVTRtDUbVE3DFvNuyy3E9xPXPJ4iCGCTgHr657TdNQcp
         q/UqUWx+FBcOS6u9nclQjyrtHe2iIi+YmrWh9FWI3AzyNouxhq3xu7xhi++XRXsDOH95
         mIvw==
X-Gm-Message-State: AOJu0YzTK4VQvca4RiGZogSTbUSO1aElkSWsf8iG77eDBoinAvLH3oeP
	U+BAJhmcxrEg0fmfuTe81fxSlwrqDEpVCj+TTqXNVBxdqxg/bDMHcGIXyGq0zKYly2Xa6puujNH
	B1Q==
X-Google-Smtp-Source: AGHT+IG5uTZN57EY9zr8xo7e4XS1efoL7x7r216JOYzLmW9d3xb8dIQ+IzhJuoH+rAZ5YggTdv0r9LhygHs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100b:b0:de6:bf2:b026 with SMTP id
 3f1490d57ef6-dfacad00821mr432203276.13.1717603445591; Wed, 05 Jun 2024
 09:04:05 -0700 (PDT)
Date: Wed, 5 Jun 2024 09:04:04 -0700
In-Reply-To: <20240419161623.45842-8-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240419161623.45842-1-vsntk18@gmail.com> <20240419161623.45842-8-vsntk18@gmail.com>
Message-ID: <ZmCMdLNkhusHSS1Q@google.com>
Subject: Re: [kvm-unit-tests PATCH v7 07/11] lib/x86: Move xsave helpers to lib/
From: Sean Christopherson <seanjc@google.com>
To: vsntk18@gmail.com
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jroedel@suse.de, 
	papaluri@amd.com, andrew.jones@linux.dev, 
	Vasant Karasulli <vkarasulli@suse.de>, Varad Gautam <varad.gautam@suse.com>, 
	Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 19, 2024, vsntk18@gmail.com wrote:
> From: Vasant Karasulli <vkarasulli@suse.de>
> 
> Processing CPUID #VC for AMD SEV-ES requires copying xcr0 into GHCB.
> Move the xsave read/write helpers used by xsave testcase to lib/x86
> to share as common code.

This doesn't make any sense, processor.h _is_ common code.  And using
get_supported_xcr0(), which does CPUID, in a #VC handler is even more nonsensical.
Indeed, it's still used only by test_xsave() at the end of this series.

> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
> Reviewed-by: Marc Orr <marcorr@google.com>
> ---
>  lib/x86/processor.h | 10 ----------
>  lib/x86/xsave.c     | 26 ++++++++++++++++++++++++++
>  lib/x86/xsave.h     | 15 +++++++++++++++
>  x86/Makefile.common |  1 +
>  x86/xsave.c         | 17 +----------------
>  5 files changed, 43 insertions(+), 26 deletions(-)
>  create mode 100644 lib/x86/xsave.c
>  create mode 100644 lib/x86/xsave.h

