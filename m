Return-Path: <kvm+bounces-67158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA58CF9DFD
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 18:54:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 083813166485
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 17:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AEE42F83AC;
	Tue,  6 Jan 2026 17:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vFA67m4L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42DD2F6574
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 17:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720888; cv=none; b=eP+XIfbmwbAIQNcsadsPbl2/hRtvG75lYp8zBLg5xvR52b+gX0AO7qye6wdylsD3yU40h2PpYpbV8l+4RaxbsLXvfSW40r9X2KO7TbPRRcp6GNpPEvTgMPnJsb/xE32FX/J0R22wkBHI6nhdJjsYtsGikWv2DV1h4PEc2ew3h88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720888; c=relaxed/simple;
	bh=oG+5BObDcTDi1x+Km41qa3lPinM+Zu9ZcLwgxUaBtls=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SQJA5xMbFF1OHn0sQ8+z46WmbQ1TPXZAsUhFwPeK/GZwJGU+kqSBZUsV5XyQhW138D8/M6wc+M29aC6xIdyS7R9zS8lGL5R5xrm45SBUH8LXNlafOelPMRhSanNbILAHwEDyCShksZPchOVM52iJkGoyTqspktDCQ+BIPTW4N+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vFA67m4L; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c37b8dc4fso2544673a91.2
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 09:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767720886; x=1768325686; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3u/SRXiaOkDG6uvCHXyBdLmp6hdaJa1OYUaHTRQhklQ=;
        b=vFA67m4L7AOOx9/+TL/Jx2QVjjGTI66vHJr6gjO6y16zX39ySg71db+hHqLjvAWOro
         CuEOTCX5eQXkoDxDJH7bYKr67C+eVYyMI4T5pA1GEwPe6G/fAFbDv6YEMparCYiroSis
         FzeV/6/QMRxQgx495+2NfP+DJZuU8cGkVoVolDEGylg8uIl1qvOFr8XibFR+DMGrB3u/
         C1dqyMmH0bHFwveF0obNkRkv8py2Xd/SuaJSgYOzR1ugJIpv4stucrdG8NKAT6x8U8KQ
         Z0hcJ06/x+oROCkgGzzxmYcjDAIAM1zUqCu20MpHaJ+TQZZG7C7n7DuxcHRPsNAQrQRY
         LVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767720886; x=1768325686;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3u/SRXiaOkDG6uvCHXyBdLmp6hdaJa1OYUaHTRQhklQ=;
        b=Rfo9F+vjQXmWmsw67KWq0PPqdn3S/wAdL/L0DRl2UwTn7bNsvn9rxNSy38KYT1MitQ
         imprFdXD7cTRjZ0QW4zesy3Geqnz6BSgi8LRbr72T0nb0Dtmam0dW376B3FlFPt5WY0x
         9wATN5btQ7LTZG5VlGmqt6kFZrkFQca/jLldQhWhnFxwQ+9nrLK7vgnvU0bQWpOrWgVY
         iDIsz+lQ+P3aibN8xaeFwRWLrIfhSF9sBKpankbZGx9Q8rkaDDmnZ52/XwsfDNu6AmdG
         mevJfYYh667Mggzq/GwD2NkeNE3vHMsRS5yo2F9wtAk/Z4KPUCnsRgVVdRo8jVZni5FC
         JmiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcmNq8E0ee9V6pAYStrioBj8mWrPOHki4V4FR7ymfS53F4lEtfHunqQnO5nMuSF5tc+8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2bG3LtLDQ7A/LvlvBvaS4rTub/TOjPaAR1ZjFMvCqpbK5qv8v
	mOi8bZarXnFFkzyDl5ZnKbrw8jIwG+8apSlUM7ZlrSpEy023zsDVhsibgao4GLSl+B3h8WqgWBs
	uoCrtMQ==
X-Google-Smtp-Source: AGHT+IEPNTpv7HvlOHxKD/0Uliz6EXEzXccXZp3/d4Ho/3M791oWBuctzoLTQdPVExufzvSsYW/MQKp+4uQ=
X-Received: from pjbqb12.prod.google.com ([2002:a17:90b:280c:b0:34a:4aa7:b774])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:58d0:b0:340:fb6a:cb4c
 with SMTP id 98e67ed59e1d1-34f5f2fb2camr2910890a91.30.1767720886019; Tue, 06
 Jan 2026 09:34:46 -0800 (PST)
Date: Tue, 6 Jan 2026 09:34:44 -0800
In-Reply-To: <aV1EF5DU5e66NTK0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260104093221.494510-1-alessandro@0x65c.net> <aV1EF5DU5e66NTK0@google.com>
Message-ID: <aV1HtKXlePEJ7CJd@google.com>
Subject: Re: [PATCH] KVM: x86: Retry guest entry on -EBUSY from kvm_check_nested_events()
From: Sean Christopherson <seanjc@google.com>
To: Alessandro Ratti <alessandro@0x65c.net>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 06, 2026, Sean Christopherson wrote:
> On Sun, Jan 04, 2026, Alessandro Ratti wrote:
> I'll post the below as part of a series, as there is at least one cleanup that
> can be done on top to consolidate handling of EBUSY,

Gah, I was wrong.  I was thinking that morphing EBUSY to '0' could be moved into
a common helper, but kvm_apic_accept_events() needs to bail immediately on EBUSY,
i.e. needs to see EBUSY, not '0'.

I'll post this as a standalone patch and then try to add WARNs in a separate
series.

> and I'm hopeful that the spirit of the WARN can be preserved, e.g. by
> adding/extending WARNs in paths where KVM (re)injects events.

