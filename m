Return-Path: <kvm+bounces-8240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D13584CE13
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 16:31:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F8C21C22170
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36CEA7FBB2;
	Wed,  7 Feb 2024 15:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h1JJix74"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A017FBAA
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707319863; cv=none; b=LCsOPfSSVZzStE6nYlEHGkxS4SmR13Fuihoqnng1NjN5hD4qYU1TIVe61NVvpTzAIrNzjaMzZ6Zip6jn4ykHCgKidFriz8Yd+iiLLeewUpVEGbAdSBwJ3iSQEwlZE2OzCudDNqv8st3+4ILnsXhu7kqM6OAWlgTYG6HNWFVJPxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707319863; c=relaxed/simple;
	bh=DXNk6OLCxdYLiD+nZvI2CClPGNogd6p3e1cHGrPIvlk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MTzAX8/GBxTw86Md6tSIdOrZw4Vj4rCei5Bl++VO/l7wc8UH77GdVh6DDFj2KE79GCgSzHaoQjkvq4tTNeYhOtCpZEf7938XRI19HGBPN6hPrQNnTLQxgH4bcgWJseYv4p/0b53cZ/y5eSwr52jAsTD8QeP2++P89DJZT9kqDlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h1JJix74; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf216080f5so1116259276.1
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 07:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707319861; x=1707924661; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DXNk6OLCxdYLiD+nZvI2CClPGNogd6p3e1cHGrPIvlk=;
        b=h1JJix74k4vkmFzTKykfCdULrvpPLdUC7XP49BaGbWIztnoZMv1F1c6er513gbyziL
         1FkSQIXw7oCHnjQxjrUmpQE1TpOUWIXcmuxC9C1tAmx7x+RpgZ1rVpgYR6luVX693O97
         De/i0W5YNAk5s5RLQPnXCpGmWMld1WcdNRLal7RXnt/8tpw4RqEeVIGfTDFAga/K+iJN
         gpzGr8tDYz1S6mGr4lkuoLrmzAE1ohmhJYgivGzje2b88OcFdBHohMIlnu0sejpR/ju4
         3aHBTboKg3/xJWmxYtU+vdbLfLKkVAlCV+1pIic2UYPdtGizArTKKVmp+5zK+vNxPTQB
         vf2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707319861; x=1707924661;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DXNk6OLCxdYLiD+nZvI2CClPGNogd6p3e1cHGrPIvlk=;
        b=XP/4e/4REvtw6c2n2IjolNNNiEpPrlBId3rQvH/rC2Ys6FA4e6fOMcYSuqS2n0yGdG
         N15t6fOzF6sNjjIUnRfldZ84tjag9SZHcfFdtTZoYExz4Oa3pYtDsw/iicaNp4zUiJhd
         JgrsiFBbKNITjaSVQKwQ+DESGC7VlkHRzaXZ1J68Fyjk/nng58XTHKHkAONLmWZgA+Wx
         InkwBOLnEA5jHcIX+Y9lOZz6jxcE5o9FsuNF9jUubBiJHvnZIDq/hhUO/b7w+GEy7Dkl
         AGBJ7Iy/dIaC/RngpR8G86mSJ372jV1ipH9TaasUwThBahr2VbTLQejgFi3NhablzilE
         YI5w==
X-Gm-Message-State: AOJu0Yw3eO5kxjuW2Ew222KHjIyg3LZXrveuiwNjQU0uYK0nQAxcnzwV
	3BGYQ48lPL6RR1WAgkaVchwlybeCOcM6AYU3h3Cmut0rG+FAVGD0wNVhSwx4ZB+r+kPXhUdr4V5
	4ew==
X-Google-Smtp-Source: AGHT+IF2066JJ5rdaQrPAVjhJ1FNs2puYbStDr1fK8IH8VG65KD1vwXXvlajIrtd+RG7V1si+msMj40S8IE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b04:b0:dc2:398d:a671 with SMTP id
 eh4-20020a0569021b0400b00dc2398da671mr1279778ybb.10.1707319861064; Wed, 07
 Feb 2024 07:31:01 -0800 (PST)
Date: Wed, 7 Feb 2024 07:30:59 -0800
In-Reply-To: <20231109210325.3806151-5-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-5-amoorthy@google.com>
Message-ID: <ZcOiM4O-oPcZpeac@google.com>
Subject: Re: [PATCH v6 04/14] KVM: Define and communicate KVM_EXIT_MEMORY_FAULT
 RWX flags to userspace
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 09, 2023, Anish Moorthy wrote:

Needs a changelog.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---

