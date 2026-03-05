Return-Path: <kvm+bounces-72860-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKq7Cjy6qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72860-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:15:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 14849215FC7
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2C5D7307E66E
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B1923B8D7C;
	Thu,  5 Mar 2026 17:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XHdG/8ac"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2763E0C72
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730723; cv=none; b=O/3maBPz0oEY9OX5xl0/gObPI/88uyXjePGDyEBXoBsY2MIvYbkUwnU+T44114NsJt29Oo/UTpC0K4bkxKDpkaUzaZ6+6sunGWMDzMpCATsUso7TWqaTvOqLrlL7SZp6KVJC+W3upRc6uDHgoqvnCQgPdmcMPs5kpHfKD0sD2/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730723; c=relaxed/simple;
	bh=VZ2VWf/U/M/pJEQVrtcf9AWPezIBBBOUZHcue8lhzas=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MrpaUaQKWVHKwOleBuOFt4Xun1u6qfZ5gt1F8A1e86nyeRBptdPnJUJtOV5LH3aAahIN/NNlKqrad5mtOcNygszcPEa3KtImiNzNuneR4WIJONFQ+tT669UoVpXsJgYingpRR4zv+EQ+TAZDSj7Dkf9ZynqdjYpjE3wKkUTgAQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XHdG/8ac; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3595485abbbso6895120a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730722; x=1773335522; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kT1V8CMuG0VK2OsUD2BgIK4Ki3XXWiDeceKTIm8bP7s=;
        b=XHdG/8acv4dknum0nOjmT3p+h39B4menY1EqLIZ3g7d/B+B6aFiRCrxZRAS/yVyN45
         +rGg/HE/D+nb5PB8X1weyet0+28YR6JOjUz4w1brr6B70ax89CKy6b4p3MTc/vkiOZ+D
         29hbRTUao1ONq00MNDaM/t+jX7RL+b7/zyMtq8nOZTbObQ4m3uyiJJzOY70pJwd/aaH+
         TLodp0IYSi0ECCRQycKzv6QJ4k4/87A/vo7f1ubistPw/3QsW6UBTuyGMICOToJnh6bb
         NWhUPEiVwewkX4NgNS7EDl7ymIXn4NTVBL7/ZQ4Cb0vAiEfKLr6hJFNGHjN7yr1GyM8w
         YM5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730722; x=1773335522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kT1V8CMuG0VK2OsUD2BgIK4Ki3XXWiDeceKTIm8bP7s=;
        b=iZXFTabQybpctk8q7nrpKmzvo/4Elwsatxx/KeDnXAMc5XyM+H5dILcihsgfieUIte
         m2+NzYCGJVq65KNUDGm/f80xX4/sam1Kppo5Xbta85k4SE/LT76g2p+mv9Gnuwt98GiG
         /3ZVM8tQsXC7ZKKJj8nbVP9TSEQV1Y0k2h0kJ4mnp/wfeAt8Le9CXoN9sUfKDnPGPQyv
         pidbp15tUULxUwJW72Xp7QHHNtv1adcXARfmzUW45TX3eqQ7j9hau5NlgwZn3dmEtPVJ
         O0DkM9VLIY1rKDascbHTO87ItpMQXeHkX6o/JgwTT3o60ZI9i3egKJjZ2U1XzTsKXeB2
         oWaQ==
X-Gm-Message-State: AOJu0Yxui4IK9ZqCpwSZ4OQL6+2MclrpOFzOwBaQzFalVqt1zPSNJaGh
	SffQM8WyP0WBA6tQIgSB8xwLO1WeyoiI6YC0uh6auSOnaSpcCXIhUNkSTK0FxKevXYVI3CVHXn+
	PhEI3XA==
X-Received: from pjng20.prod.google.com ([2002:a17:90a:8294:b0:359:8d38:cdf6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d48:b0:356:35a5:4a64
 with SMTP id 98e67ed59e1d1-359bb367d57mr237961a91.4.1772730721967; Thu, 05
 Mar 2026 09:12:01 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:09 -0800
In-Reply-To: <20260304002223.1105129-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260304002223.1105129-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272514184.1531685.16327476420305631448.b4-ty@google.com>
Subject: Re: [PATCH v5 0/2] KVM: nSVM: Fix #UD on VMMCALL issues.
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 14849215FC7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72860-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, 03 Mar 2026 16:22:21 -0800, Sean Christopherson wrote:
> The VMMCALL fixes from Kevin's broader "Align SVM with APM defined behaviors"
> series.
> 
> v5:
>  - Separate the VMMCALL fixes from everything else.
>  - Rewrite the changelog to make clear this is fixing only the Hyper-V case.
>  - Add a patch to always intercept VMMCALL, because letting it #UD natively
>    does more harm than good.
> 
> [...]

Applied to kvm-x86 nested, thanks!

[1/2] KVM: nSVM: Raise #UD if unhandled VMMCALL isn't intercepted by L1
      https://github.com/kvm-x86/linux/commit/c36991c6f8d2
[2/2] KVM: nSVM: Always intercept VMMCALL when L2 is active
      https://github.com/kvm-x86/linux/commit/33d3617a52f9

--
https://github.com/kvm-x86/linux/tree/next

