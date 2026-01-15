Return-Path: <kvm+bounces-68221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F65DD275A5
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:20:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EE5223019E36
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35BF83D4119;
	Thu, 15 Jan 2026 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MzWzNBmj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4449C3D3300
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500343; cv=none; b=NsSyuMTM7qdMKxe3eNJbFU6L1IO0PuAV071AWYPIVW1nvI4sL7Ete7RTeNnmztLGvHBDOzPnNlU/fqPdBBbJD/3L3mHd/bSGF+r59cou1hQLrlTW4Sex8M2FeWofzNNdKyu64zI/JJw0RLsseAVLOdoJxc0VrCChLn7ihJHPCps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500343; c=relaxed/simple;
	bh=/Abo1nq1bguKGNik3MrHGVXr+PkEtU3mkkYJfTBpRYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B6tHIzKDXZrUk5FJBwsDY2cwgSNvhnG2bslQ2JQPjeNYrwofZQX4ymOMAkNdYvBh8X5ImlBdugCK3IkSCZHSMn89Tctcb+DXBTwH/huYMmHQ6gt20wi8zLrtRYwK1XUsIQlMY/6DCXgNduPI/DRiERKphVw7eOai7Fpq+ujdlgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MzWzNBmj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a09845b7faso8194295ad.3
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500342; x=1769105142; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sqd1PFsVUIs3F4pfhVq6qyofMpX+RLDhYeJtA2Ru3xA=;
        b=MzWzNBmjkvPYQBCEHHI3yezHTNtL+PDMTD6O5Oh+/c93OL53SpoEBj6k3KwZUBWAFc
         hSlcRWqYyDE00YcloovfjXzpRZrPkzs87T/6C1bEPbzvum7ocyGa/fz/NRfWkZUD1+cZ
         MhSzx1Lf7n9RXsb4dmluNWhUrP9+e4SWTf5tHSkw/8BozVeXQY9EO7XQeC+ZtZXPrB3O
         VIUz7CsDFJ77DL1AvLFCrRgOu1bsivFkbpCwgSYaBI/TlgXvLG+1VW/dDcmX0RIB1f+A
         zTjokXwuvUjaao47xziQ9BhyRgC0QmeolZj5xZWQAH4U0ku5tuEL3GXKyhjQ7huHncTX
         XKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500342; x=1769105142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sqd1PFsVUIs3F4pfhVq6qyofMpX+RLDhYeJtA2Ru3xA=;
        b=LdBUcnRLKaCr1T+OrADjrUX/MjsIw+lZakcBjm9bmRR6jv+dtlqZlRLkMLv3Gn4CBI
         gxQ6lpysFJGtoeIp5dHB8J1mJHDIEU+6WkCYk4zIoYWAIvYD3mzjuHs3Pe7dJPg98yHc
         ZAEjYBcOcUMv3ut9sg3Y+TfoQsgWk3MAuuM4/1su1dignuZLA53dzvRe148z7J1MuzDm
         ZN+JvI4vt3zoEliYLEEQ2VL/03Am/h/tJ75nG0ivtoHffpx4zK5Kke2qtQWWeE5H3TXw
         Kx4aiVLJIMfeT+UFL1rgzM+MsHi5rSLX1HsZGVJ8+pHekBHcdd7JN/JAoCQoGa1HbEES
         QUMQ==
X-Gm-Message-State: AOJu0YwFo0XRHrhYXVEHxv/r1HIJd2cSFqIJyNpOnviOGJBv4hSajk19
	7b8Bz800FTDW3yjyVDuYFA8bHJUEfU8MTFxfvzQNqT6w+eCnjXLwkXVxR0yoEoIK3QSalwdRmF2
	DTXXvOQ==
X-Received: from plho10.prod.google.com ([2002:a17:903:23ca:b0:29d:5afa:2d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2445:b0:294:f6b4:9a42
 with SMTP id d9443c01a7336-2a71888c47bmr798915ad.9.1768500341579; Thu, 15 Jan
 2026 10:05:41 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:21 -0800
In-Reply-To: <20260112232805.1512361-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112232805.1512361-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849720857.705106.9881442086637980436.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Check vCPU ID against max x2AVIC ID if and only
 if x2AVIC is enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 12 Jan 2026 15:28:05 -0800, Sean Christopherson wrote:
> When allocating the AVIC backing page, only check one of the max AVIC vs.
> x2AVIC ID based on whether or not x2AVIC is enabled.  Doing so fixes a bug
> where KVM incorrectly inhibits AVIC if x2AVIC is _disabled_ and any vCPU
> with a non-zero APIC ID is created, as x2avic_max_physical_id is left '0'
> when x2AVIC is disabled.
> 
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: SVM: Check vCPU ID against max x2AVIC ID if and only if x2AVIC is enabled
      https://github.com/kvm-x86/linux/commit/cfbe371194d1

--
https://github.com/kvm-x86/linux/tree/next

