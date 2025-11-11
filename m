Return-Path: <kvm+bounces-62664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C7B1C49DD8
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 01:28:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB04B3A9BCB
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1FD1E8320;
	Tue, 11 Nov 2025 00:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lTUNj1uA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7561DD889
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 00:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762820913; cv=none; b=AxHW80z+qvJk9TudHJ4VExc/DPZdV4mJdkOsu8hMHq0Cj+DHHTvZVelMZ/AkO3PioolLDtnhZpdKlWWEAnjGPQOeaUY14YgUooLCTraM4Td5w18dljxA9XOTe9cyEPUbE60TC7dNYMbgDfC7GBuNZRWVSFIT+6PwEouSrlR1HiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762820913; c=relaxed/simple;
	bh=s4QAbzqezKxpC48X2jJAmws2M/K0ewRQ0evWM/FvHM8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bJh1ZXCkRxCJnXPUz9GlGeLuw9TlPNBFvoa0dbuhHHD5hqjJwmR2SX64qTVh+cvq1F41F2FQzrjrkOYAe63mby340cfY2cdV34b4bRzvzykfUB4eJW9Z7rWuAz0XC3ilsO43UxXjj6htcBHmXfh/6ggjFPG7EQfHf5VAiWLOqv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lTUNj1uA; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-295b713530cso42704505ad.1
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 16:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762820912; x=1763425712; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s+ps9iZNMlQxigkmZVc26wKVrUeiyrptMcRHW4fOt+A=;
        b=lTUNj1uA9XEgIM5g3rzQOYHICp+Fz45ilYQQIRyFhske5mM96eKUBWxgsSVIb/GO2v
         sKJHaXGy1vPPex8cf4fm3cpoLIKcDPjWqLizM7gpj9cnzs0BAg0MtDUi0AgLmIm2KUiY
         GFBBW0QW2yXlemy4mFkJ2PE9CKiOMfmsAFyOnrcLc/P4nOod++8vxrOa/N1miZzRzRBp
         EwjocjmFOg/PAUAMlXs8rBrL6upB/b/1taJa+RWzbv/dAOVtMDQMVJDy7DWTDxbCrPyp
         p3e2Hc8stnRUX01F+wZev4vZEAmq14G44P1a+DC4glot+XLi+07n3LRjP9ETY0IKjowi
         BVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762820912; x=1763425712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s+ps9iZNMlQxigkmZVc26wKVrUeiyrptMcRHW4fOt+A=;
        b=ow4fIvceF07ufwgho7sZnICROEbuOdBCfgMftlfqVjhVjo7TqEZCvwWrq7VynXNmya
         2iMRuBkjHF7VPJ7nf8ljHTWgUON7Q/ck+pePzvvCADb03uUn+uN3fJntNhl+IJx7/JUa
         F4N8aJJVG+aY3JaICfdLwCgsNWvdYjW0v4sijWq5UoaNs4T+NsThAwzWSQqF42ivmOZb
         x9Q/izKJKePOsYFGeKdxHOM8XMTSKaU5Crj9NeeZSw/+2tfdC4I71DCZDgNTaKvkf7xi
         daPWACJqgui2yI/DN8yMDufWISmhfta9KMoQXQIzAh9/HsFiHD4EFN8nbJvBL10M83yn
         PI/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXyQ9h449g2/PUpQMzjwQ+X+CcgtzUXjrBQ9lzmQ2hsmXv19hVWUMrqueNJW19Lt3yg/hs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxH0ePMFv1goY3KWZYO6k63hzAKaEmbchuvA+2wbx4t/T13VAtD
	UcLfUTGi++uTV/6KdQBVYndDLEn9ex58hyYp2MibdUZjCfueCTT3b/FfPvvKW6vrs4tJ5PdlXBM
	O4NukCw==
X-Google-Smtp-Source: AGHT+IHAUfMmNpy6nhd6gmlvKTfMVnDRil73JRGuUHbbN42OotsFUvytc5toTQSvaIczNMpYZj9tI76zEks=
X-Received: from plzv12.prod.google.com ([2002:a17:902:b7cc:b0:297:e585:34c1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1109:b0:24c:965a:f94d
 with SMTP id d9443c01a7336-297e56df7b3mr148989735ad.46.1762820911660; Mon, 10
 Nov 2025 16:28:31 -0800 (PST)
Date: Mon, 10 Nov 2025 16:28:30 -0800
In-Reply-To: <20251107034802.39763-1-fuqiang.wng@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251107034802.39763-1-fuqiang.wng@gmail.com>
Message-ID: <aRKDLo_SFJxyQWG5@google.com>
Subject: Re: [PATCH v5 0/1] KVM: x86: fix some kvm period timer BUG
From: Sean Christopherson <seanjc@google.com>
To: fuqiang wang <fuqiang.wng@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Marcelo Tosatti <mtosatti@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yu chen <33988979@163.com>, dongxu zhang <xu910121@sina.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 07, 2025, fuqiang wang wrote:
> =================================
> Fix both issues in a single patch
> =================================
> 
> In versions v2 and v3, I split these two issues into two separate patches
> for fixing. However, this caused patch 2 to revert some of the changes made
> by patch 1.

FWIW, my initial reaction was that I liked splitting this into two patches better,
but after digging through all the angles of this for a few hours, I agree that it's
better to skip the "don't let the delta go negative" patch, because that patch
really only addresses a symptom that shouldn't happen in the first place.

> In patch 4, I attempted to merge the two patches into one and tried to
> describe both issues in the commit message, but I did not do it well. In
> this version, I have included more details in the commit message and the
> cover letter.

