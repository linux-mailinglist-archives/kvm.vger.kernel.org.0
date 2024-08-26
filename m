Return-Path: <kvm+bounces-25061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F181F95F63A
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 18:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FDB01C2209F
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 16:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DEC194A4C;
	Mon, 26 Aug 2024 16:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="njqKU9Ws"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1030917BEC7
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 16:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724688924; cv=none; b=GFlgar24oic+wwXta/Xg+dJR4zfbqBQuum/JlrzkBbR1W6I8hetYciiI2FUFPry805Ah29xfyk+HzUnzylcQcKa8P6xCIkDvxHyOptDwqp7vuFd6SJXtxzmPLBSkLe2sgDlEa4inOxSW9dM9sBkfb22mzwQ50z+hT62ISeI/hdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724688924; c=relaxed/simple;
	bh=J+rLHBFEvNjlXz/GNKaC/2LgG4G96zcbfC+ur3gCReQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oLUa1vue4qBDzSlRCGP+/+hy5OfbdBSw93tu69pUqNNHzn6p01IRTYS7OqXHVcsTf1nqL839UDg6mZx1SxdXyXGEl0OvGDYJPY7HUV6WTV0E0WhljwAur9jRssu/pygnCPqpSgV01hVE8XrrDxqirAY1oojc1TxjyduohTPPskw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=njqKU9Ws; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7cd96715e6aso4752951a12.2
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 09:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724688922; x=1725293722; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xGt+BeqMwNAWN7+7JNWKttmg5C2YeDfYLzvHHCuit1Y=;
        b=njqKU9Wshc3wafhIjJW+yWxmELmI+hSSmBMgV1BKlQ2NmT7bUDSpu59XV/MH+Dv/W0
         2iqtck3maEDNkEnE2z7jTPfBugOPPeWnZQM+1oKSIdwwHfqNHopt4BODqR9n9jpkLiHk
         Zvm2c34BmwNnfU7TFpeFS+nR5kaK5KOdN9Sx6jr5pS+cuqUXRhu70k404LaaI7YaWsxc
         ilcPnO6dozNo5A/8yT+FgLd97ytT01JTbaoZHgoGN+RUvahb/y8zF4bSB2ELJkSBYb0t
         q72kL9KdCfTmILDkV4shikuhFaJ4pnpnwnQ3UKdPaM0PfWhdJuHqVMgtpt50PQketkcR
         aA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724688922; x=1725293722;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xGt+BeqMwNAWN7+7JNWKttmg5C2YeDfYLzvHHCuit1Y=;
        b=R7K/4LmAAMcLvACUhj6NVhHsP2TT8tjGzr/zoqbSsdSHep7Tt7aC+1xsxisdSDqDLW
         6CGxcQVYjcRl3IPXBlDuEFAafba5QF++8oGCsunHY2OTcXwDvPR+A6rdW/XcQe8lTGNw
         h/NNooXr8IcVwF0YkKhbXappv5Auo7pDUq8Y5MRyNPpE9j+fz3NsFiRx7iNRZ9+dS0wR
         esdDcBZH4f+YtBRVQXJZggjJqY5xQSYc/cnzo2rwfMdU3j16pKAX+LeUwumQWGUZbz8d
         Y0izxNjwPT6OfUot4f3tdm0ScGZcXtnA6BRY2qay09SyWt3kyZ8ozjxbNzeDrRZ+1L3D
         TrzQ==
X-Gm-Message-State: AOJu0YxH+4m4rpEnciBsOwuusjtHmnRe3cAcUfGkuKVlfsyU4GbKgOTS
	EVplCG/TRnW+oWZ14gSfVCWcgI9coqfJXhREioc9sxNMv8Y5YmReANMYkE/kAU4QmYNyGaJeKj2
	g0A==
X-Google-Smtp-Source: AGHT+IHwa8G2JBcOD9l0jxkvlBCFSvevsHpo5l0z4wmWOt9YVpl16i7NcGh2eLyPdJlR26tJR7hgbbBWEjY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2542:0:b0:718:2a63:47a1 with SMTP id
 41be03b00d2f7-7cf54d24e4cmr19230a12.3.1724688922080; Mon, 26 Aug 2024
 09:15:22 -0700 (PDT)
Date: Mon, 26 Aug 2024 09:15:20 -0700
In-Reply-To: <cf8c67de-4c23-416c-a268-56a12801a305@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240709175145.9986-1-manali.shukla@amd.com> <20240709175145.9986-3-manali.shukla@amd.com>
 <Zr-ubK_e4lAxyt_7@google.com> <cf8c67de-4c23-416c-a268-56a12801a305@amd.com>
Message-ID: <ZsyqGGspHOsuyEBY@google.com>
Subject: Re: [RFC PATCH v1 2/4] KVM: SVM: Enable Bus lock threshold exit
From: Sean Christopherson <seanjc@google.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, 
	shuah@kernel.org, nikunj@amd.com, thomas.lendacky@amd.com, 
	vkuznets@redhat.com, bp@alien8.de, babu.moger@amd.com
Content-Type: text/plain; charset="us-ascii"

On Sat, Aug 24, 2024, Manali Shukla wrote:
> > Actually, we already have a capability, which means there's zero reason for this
> > module param to exist.  Userspace already has to opt-in to turning on bus lock
> > detection, i.e. userspace already has the opportunity to provide a different
> > threshold.
> > 
> > That said, unless someone specifically needs a threshold other than '0', I vote
> > to keep the uAPI as-is and simply exit on every bus lock.
> >  
> 
> According to APM [1],
> "The VMCB provides a Bus Lock Threshold enable bit and an unsigned 16-bit Bus
> Lock Threshold count. On VMRUN, this value is loaded into an internal count
> register. Before the processor executes a bus lock in the guest, it checks
> the value of this register. If the value is greater than 0, the processor
> executes the bus lock successfully and decrements the count. If the value is
> 0, the bus lock is not executed and a #VMEXIT to the VMM is taken."
> 
> So, the bus_lock_counter value "0" always results in VMEXIT_BUSLOCK, so the
> default value of the bus_lock_counter should be greater or equal to "1".

Ugh, so AMD's bus-lock VM-Exit is fault-like.  That's annoying.

> I can remove the module parameter and initialize the value of
> bus_lock_counter as "1" ?

No, because that will have the effect of detecting every other bus lock, whereas
the intent is to detect _every_ bus lock.

I think the only sane approach is to set it to '0' when enabled, and then set it
to '1' on a bus lock exit _before_ exiting to userspace.  If userspace or the
guest mucks with RIP or the guest code stream and doesn't immediately trigger the
bus lock, then so be it.  That only defers the allowed bus lock to a later time,
so effectively such shenanigans would penalize the guest even more.

We'll need to document that KVM on AMD exits to userspace with RIP pointing at
the offending instruction, whereas KVM on Intel exits with RIP pointing at the
instruction after the guilty instruction.

