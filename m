Return-Path: <kvm+bounces-35196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03DD8A0A013
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 02:28:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3D0916B2A4
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C2810940;
	Sat, 11 Jan 2025 01:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bYWMnMxr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC423DDD2
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 01:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736558812; cv=none; b=JCQWVzRlEG/Uh8odTurY1CumCS7Q398GwwPDVdjBNzfEqQszrgE83oNTk6hZCS3cQpJo+dQ0S9VyQvWHbqgkLUA0kY3D5EiJE6Ai2K5B7e7WCqy4hn5TSuWsqfIWozClVLWKGSTf+IRjQNBDWKJGkO246d+dRTlM4WAm0LCrbVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736558812; c=relaxed/simple;
	bh=720nGOPxo7nz4XE2TuwP4Lm1oN4no2xj0UdF8gljix8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kaq8+ZdX/zaeaHw3DgAFihA1+ZB095Fb8cMzG888vD8OgTzRQFsoUqK9iEAlhU+l93+pOrLimQRw2uB6BEuG7mKGBY9cdR12lZgku+yeo3iTQr5zEa8wHKh99MvpEV3YxcfO6eO0fMhFJxi0N1229LbOEUEV/zzro+owoeVoA5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bYWMnMxr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f550d28f7dso4638824a91.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 17:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736558810; x=1737163610; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1vTm1+x76YRanFTAiK9rqCr/la0CoprS6/3WmBR5YUY=;
        b=bYWMnMxr/V81O3bRtl+psF2v1ojWNdaDlaCy8C9LtlywNzCkm9FlfNYRTet7vgVZGL
         T8uIPXHNz6hDjF0F4m8JA+8j6fLW9eqQcP1xOduJrrshaIRG521tgQlhZTciR12+CbSM
         tDERlK0pvIka9GY6p1qlb0ddVfbFHlSuMawmRQgslktLSFytQOiSkEEkSN20wWrasfNx
         IAGJd8TOqPyvyWIa3hxmV3PxD5tbCFYVmk8x8zFtvT3nhmdycinhI1cOOo1FpXfdhHNb
         tt1WN5uY35HWPifyFE/btfHNdu19TeczCFIza5HFW3VXAacQiFY7XrZSicJ6LMiKhZoI
         /xEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736558810; x=1737163610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1vTm1+x76YRanFTAiK9rqCr/la0CoprS6/3WmBR5YUY=;
        b=iHo/wspUmbM7ypQpj/ep6oR+Xh+6/Q1nm7P5psJryqYbd3P/IlI1ZtbIm9qLjQc0Wi
         eMyx80Ds1aqmMBqWJgBDogeMbN2temDLk4v7srddjGg7TcxqWLfAI7PmEgwgi9/KzD7N
         K9g9aZEC2ZPSB6NHafwPoVMLGX3POKQv4YpkMhQopJVuJsIoahl9sTwIk+QVb5WchVMH
         wC55Dfo4Ft1DmyMO+JYa256pM1f5FzcfxtaqyqIONcokf9E4z7Skfxye2F+WX90Ke5Mw
         g1v5QqMTzpfx2FXuK3vxQHkstF9IW9Ib3Awq/fQLBP/YySMQYvgW1XiHm2nUy408d35a
         xtFw==
X-Forwarded-Encrypted: i=1; AJvYcCW1Mml2h+RlHoYOItqnnueVhIu2SNFgObtE1RleWzbmofKEjcKvk5cwPxPSd2AJm79v8Cg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7ufZM1VxrFRFKMVSUHDL+CkQCoHwEtYp4fipBfOHbbZuMkSW4
	R3+6cLL1FxEkzQjBQOT2/mjBzw9O4w3TyYZJbCRmXmVGLGYmh/1uQMobC2SnPxyXuljsRLxeMBc
	TTQ==
X-Google-Smtp-Source: AGHT+IFm3zw8nrJIzTYWJ/zc7fPgszjTZ0qchCKOjWdOdUaIyaDz4aVR53pLJHZVajufF3Iig+GRCx4ev58=
X-Received: from pjbqb8.prod.google.com ([2002:a17:90b:2808:b0:2ef:95f4:4619])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:254b:b0:2ee:74a1:fb92
 with SMTP id 98e67ed59e1d1-2f548ea5385mr17199166a91.6.1736558810199; Fri, 10
 Jan 2025 17:26:50 -0800 (PST)
Date: Fri, 10 Jan 2025 17:26:48 -0800
In-Reply-To: <Z0WitW5iFdu6L5IV@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241126101710.62492-1-chao.gao@intel.com> <Z0WitW5iFdu6L5IV@intel.com>
Message-ID: <Z4HI2EsPwezokhB0@google.com>
Subject: Re: [PATCH v2 0/6] Introduce CET supervisor state support
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: tglx@linutronix.de, dave.hansen@intel.com, x86@kernel.org, 
	pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	peterz@infradead.org, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	weijiang.yang@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 26, 2024, Chao Gao wrote:
> On Tue, Nov 26, 2024 at 06:17:04PM +0800, Chao Gao wrote:
> >This v2 is essentially a resend of the v1 series. I took over this work
> >from Weijiang, so I added my Signed-off-by and incremented the version
> >number. This repost is to seek more feedback on this work, which is a
> >dependency for CET KVM support. In turn, CET KVM support is a dependency
> >for both FRED KVM support and CET AMD support.
> 
> This series is primarily for the CET KVM series. Merging it through the tip
> tree means this code will not have an actual user until the CET KVM series
> is merged. A good proposal from Rick is that x86 maintainers can ack this
> series, and then it can be picked up by the KVM maintainers along with the
> CET KVM series. Dave, Paolo and Sean, are you okay with this approach?

Boris indicated off-list that he would prefer to take this through tip and give
KVM an immutable branch.  I'm a-ok with either approach.

