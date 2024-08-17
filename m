Return-Path: <kvm+bounces-24467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7BE95545A
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 02:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70B7EB20981
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 00:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386EF20ED;
	Sat, 17 Aug 2024 00:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lLoUfNOf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DEE621
	for <kvm@vger.kernel.org>; Sat, 17 Aug 2024 00:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723855245; cv=none; b=qJWDMleggzjV5NgsYLEKn6HkEVV1cBVqfMYeR9zbmvjrasbhier+ZP7O/+/mozzla5vopPJs8O9w17F7CdN7fm11uT/EYm0Rk+7Z6Tle1ntH72pHKpo9+p419OkwcDFe0q9USn9UCR1o3WRHwBuF06/02nWwhli39ZWhc7PMk0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723855245; c=relaxed/simple;
	bh=5VRbUIMpchvDQt4KhW0558XeOQRRz4HAgkvmVGfCB78=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TGaWdrRtq5dibIH1wKp0xgKHlrQFsPgE/Xb5RDTHYFFBx4I4Vj61c+eY7WEzLjKMhcyFLrZIC13EpKuY3BLeDUcfU1ePR3MGj20Q/aXxDS4AXgSwhYW/nPXEmzF2bEh6XQXdJjxoFuL1F2q5CGiafpFp2VZ3lERfpu3eyIt1+nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lLoUfNOf; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a1914d0936so2324752a12.3
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 17:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723855243; x=1724460043; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g90YGEbvx3ee/NSOJQagIa2JJvYmc0kVghouDWR8+R0=;
        b=lLoUfNOfPWOMMwHw4QdGe4rSmQLA0D55wVxZKRjFWYeNj8rvce3426W4Ik7UCjFpE9
         ClwW33Rvn7/yOeTTzBE/PGzL3nzvV/sQVqyhBaaeCrsOoBJv7/OtauCkVmj5wXXclsTu
         ifcCkFciRFJxoEj7OE2SuVcCTc6tqMsm4tweUp78VSMJo0CFU1TwTJcb3RrQLypKGYTL
         w3XYo5nlfncUvPI5ZUjB5+OqWZxkFk9WtdD8zsUrBMIqz7XtnfOkA8AiTLt+ur4gkijO
         JPeCMRdqDHGAzCzwO3Hf1iqtaIfKz+gaCC7pNQJbI6OmzZvsW1iXAyr8ltWubL6IMNdr
         ekGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723855243; x=1724460043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g90YGEbvx3ee/NSOJQagIa2JJvYmc0kVghouDWR8+R0=;
        b=L/gAqen9xBqcFcEickbtrlzFkrC/CjtGKOrWdbeCxusUiAi/3mv8DwxHDLlLb/Yttq
         MVVNJt3H/RA1Lq+Tj7bWw9X/yUppxMgAr/PxxGYWV+34b2yvujrOZTGCiP/JbQrx9yef
         WQA3WliOFig/lqVwxsHK+AxvMoJdgwa+IOPQlc8FDJnSxRP/7xcxKl5U5HK2ljCBpwEn
         YVuQf7gdMQJUfejV+i9NFbmcXN1X6n79RpJeUqkPB1TEbkJvxccB7EnaXf0l/me0jA5r
         ssjhM5sskbb+ptsV5BVmMwrwKt/ZNpPc6ITAVSdBZ7VswLHFf0iwKj/ZewPKgL1rpHJJ
         iUhg==
X-Gm-Message-State: AOJu0YyonlZGAYtMC1zLzoEmTHN3mJnv5I/KeGrxGgrNe30TlbUWvw4q
	lW1LXAQYuLSoBUXhuIZmIE7ueVjtxG3HbzMGELs+4hylHB5LOk5u+W2tdk142DKvB2/lrlcC/Rq
	O8g==
X-Google-Smtp-Source: AGHT+IEKIYPimzbiLhs+d5DVUf2fa080Jw+m/+1LkWUIk7aWg/PXD1bJoqQO1qEUZYeOUwrRSD/EJDSvkrE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1c1e:0:b0:7c9:58ed:7139 with SMTP id
 41be03b00d2f7-7c9791eaf27mr8140a12.2.1723855243255; Fri, 16 Aug 2024 17:40:43
 -0700 (PDT)
Date: Fri, 16 Aug 2024 17:40:41 -0700
In-Reply-To: <20240718193543.624039-1-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240718193543.624039-1-ilstam@amazon.com>
Message-ID: <Zr_xiTiDksyKUG7J@google.com>
Subject: Re: [PATCH v2 0/6] KVM: Improve MMIO Coalescing API
From: Sean Christopherson <seanjc@google.com>
To: Ilias Stamatis <ilstam@amazon.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	dwmw@amazon.co.uk, nh-open-source@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 18, 2024, Ilias Stamatis wrote:
> The current MMIO coalescing design has a few drawbacks which limit its
> usefulness. Currently all coalesced MMIO zones use the same ring buffer.
> That means that upon a userspace exit we have to handle potentially
> unrelated MMIO writes synchronously. And a VM-wide lock needs to be
> taken in the kernel when an MMIO exit occurs.
> 
> Additionally, there is no direct way for userspace to be notified about
> coalesced MMIO writes. If the next MMIO exit to userspace is when the
> ring buffer has filled then a substantial (and unbounded) amount of time
> may have passed since the first coalesced MMIO.
> 
> This series adds new ioctls to KVM that allow for greater control by
> making it possible to associate different MMIO zones with different ring
> buffers. It also allows userspace to use poll() to check for coalesced
> writes in order to avoid userspace exits in vCPU threads (see patch 3
> for why this can be useful).
> 
> The idea of improving the API in this way originally came from Paul
> Durrant (pdurrant@amazon.co.uk) but the implementation is mine.
> 
> The first patch in the series is a bug in the existing code that I
> discovered while writing a selftest and can be merged independently.

Ya, I'll grab it, maybe for 6.11?  Doesn't seem urgent though.

Anyways, I gave this a *very* cursory review.  I'd go ahead and send v3 though,
you're going to need Paolo's eyeballs on this, and he's offline until September.

