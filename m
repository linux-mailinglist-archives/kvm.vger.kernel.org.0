Return-Path: <kvm+bounces-44137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0545DA9AEA5
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:13:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28FB4160A60
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 13:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6191727F74D;
	Thu, 24 Apr 2025 13:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="33RTNsBk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6F427C877
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 13:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745500392; cv=none; b=DkUQyoMvQIBT9XK4bFAX2AaWUlbcdqvYFBqRsx0Y7IGiZa/Ag7kGBnZKajHC94oEpxE8UKhl+rHo7PTp4MjlEDFWMdp/h7/0fBrRCHwxIk37di8tzzu04QE2H/va0BDDTt8Am7ulnijYKxLoPVrPTAgqewKm+yfd25QuQgOIdrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745500392; c=relaxed/simple;
	bh=JnqcVv5ipWAX32SbJHm/iasJRV01iMKRVyjmRylLsww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LHv/giXtOu7qmQILYnvRDqj38LWcmkYz9RGIPQTl1aItxnqEOIGPbTzkwy8D5zvtSP7Sma7S+3054ls38xBHwv6Ya8e43+ytkwv1aukGZexP8dqJYhydWVzq4NfyvpFNbkjodjCUqlWEDqIJdCm0vTqerxsRdlN23HKSfrSaiG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=33RTNsBk; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22406ee0243so7415435ad.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 06:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745500390; x=1746105190; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A0c86aSm9mbGutEGyAxJG/oYRe+s25bJjg1mlIbxso8=;
        b=33RTNsBkRgxXlD/yBT8yr0JGtYSz0vqe7wCD0qlbaKLAVw7ymKX+DVCrlqZnzBvMIs
         +ztybuVF4dflmWapNahute69VHDtmaf9Kqpcdifz97BnSNx7X6K4ct+yVqHhJkhOe1QN
         cm/tW0m3HuRiI2lAQN8ThIM7RE1K1E5GjCd+TrXMjhwuTLCMosyj6tdZleA3sSZ3s/Fg
         TtqVVH+Y4td67V17JTFez6EvDmZKA0dW5bj2vMFDiu5PSbXC6YCAPIo/YhTUv5T1ECH1
         ghGMYNKtjC05lOTH7wsLT1U8WujFwXsUuJYopY9Nz/gxx6cwRWtDdNwtOXIiKrPrgCUr
         VGcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745500390; x=1746105190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A0c86aSm9mbGutEGyAxJG/oYRe+s25bJjg1mlIbxso8=;
        b=NoZGYHeLCN656CTmCm0VWl30EMKkqfi7gwuirqtsIxeM93cQA9q9K0yfzkUO2hQ94+
         PPQf/Vjq9nzcq35GWbnc6LZssn0rz0igC9w2eMKlR1j7QzlysxvRdXNu0gbOPsv6MdLB
         EABYTdfDah3YAnPdNnS7/ZzZq6CunAz1RyYwfhJTNLNs4j+qJ7NciRG9qTuhm9uhC2xm
         du4oxkbkIzDuczDxEz8Anx7ykLLVke3dRNVRPnjWIgSipGOBwGlA9+6nJw657bmRmptT
         QlIRiNWwmzmuc1MFynmaTF59fhaX/gOST6IgQ6VvO8NWagqOuOz9DFOJZ3h2UaJh7G60
         OPHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXikExlWyhUGX9Ua8SlC6T81jkDaitjwlVStFkmRuH3tSC2FclQEoqWbdl2fDZ04zVVHrY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN/Bo4tVXs/dIamuUAyEMdDDWdTBle6xopTLrGpTykryh3EeR2
	FSNvxn/aDHpAbu2/nJVDBPEdbLl8nEoz7boXmNISVsxPiBkC7qg/bkukeMJd37BY04ALwEgPQwW
	RUg==
X-Google-Smtp-Source: AGHT+IEduhjZpso9oQb6/mx71OdtoyDLBu1Elijpug3RYWmeptfZdsfoKGSddxcFcrKlVeJDGITkLofUEhA=
X-Received: from pgar18.prod.google.com ([2002:a05:6a02:2e92:b0:af9:775:2e8b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a0e:b0:21f:68ae:56e3
 with SMTP id d9443c01a7336-22db3d77dfbmr39969695ad.39.1745500390413; Thu, 24
 Apr 2025 06:13:10 -0700 (PDT)
Date: Thu, 24 Apr 2025 06:13:07 -0700
In-Reply-To: <27175b8e-144d-42cb-b149-04031e9aa698@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Z_VUswFkWiTYI0eD@do-x1carbon> <27175b8e-144d-42cb-b149-04031e9aa698@linux.intel.com>
Message-ID: <aAo445Nzi5DuAQAR@google.com>
Subject: Re: kvm guests crash when running "perf kvm top"
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Seth Forshee <sforshee@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, 
	linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 24, 2025, Dapeng Mi wrote:
> Is the command "perf kvm top" executed in host or guest when you see guest
> crash? Is it easy to be reproduced? Could you please provide the detailed
> steps to reproduce the issue with 6.15-rc1 kernel?

Host.  I already have a fix, I'll get it posted today.

https://lore.kernel.org/all/Z_aovIbwdKIIBMuq@google.com

