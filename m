Return-Path: <kvm+bounces-59595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7472DBC2BA9
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 23:16:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 058B834EEB2
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 21:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453E1246783;
	Tue,  7 Oct 2025 21:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ykhMHFil"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125FE241691
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 21:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759871802; cv=none; b=PK/H/ICSqW8J8ayfBCLg1cSexQbNqY5LWNUvpap8THwcfyJgcfRj2jyiq+bi1Vx3NylCXKm3K2QU/L6b2q2W2eUY6gqZ4b1Mm84HFsw8DDSFSI0fJLw+Vrlz2GKHmgJONZlTPqmzx4tIfR7vvZHecjRzfqJQd3rtBwYoS3N57Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759871802; c=relaxed/simple;
	bh=BHCkvXNoKTk8jmKhOfycZLfdR0v9T37k4whB97KDImc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qp46873vEBfKvJVVTLnMKFbiBoUbX9QawuO7SmEQwfojCyDB9D/cr5XI6LY83xydULT+leDu2GiBFTaQu+yghNNzKllaSEpPMrBE5DVn23OczkI44iIJjgMxTeUGvEhSE9F0dDffIDPmfH382wH7XhMYiGvY/m47LfT6ZXGPXbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ykhMHFil; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-27eeafd4882so81655ad.0
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 14:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759871800; x=1760476600; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p2QqANFX2LPHkZhXD0HBeGVr/gP/YomGFWGJkcvYX2k=;
        b=ykhMHFilbT69YPsJzTk6gcMPiar5ZDCg4tftAzIs+dz8U5cvA/ZWuqOyNZ/3oBjfGc
         HaEMDwrsgoTCwbZwwUogcAeFb7GikFn3x93HwqV4aRAB+/4/NyuLPVGZwmLqIBecNg1E
         35IDUINavQdZDd/p1hvix6bwLBquofxLLfLF792RsH6b95T7VceAjPAWOEWlmZ3Hrh3W
         HgyE7hK6vPBIFMOzlNjyZq+OiZ8y1fMO7InchXcuGr24deAn0+oiDF1i6F+vwTWTtQy9
         aVz1hamkBlmN6/u6+HqbNLsx8n92OETIJsL162IE0TTr4ZJDvJNEg5oOA+d0ZqlS+VWR
         kBSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759871800; x=1760476600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p2QqANFX2LPHkZhXD0HBeGVr/gP/YomGFWGJkcvYX2k=;
        b=Q9X7ox6E5Pi7PA4Vt/uKOg48XOiRt4d3qHY7rOp3SsY1jrKpupXIxR05ZVuk25LkV4
         JxO0Tku+cRxu+lL6FV34umXlIcAVlWFMlaiZOxVk8n306zTb8RYIyKyAXvIAnjm3MbJH
         /WM1k/Ggp3dWuQPJCqalKEnFEc83iNMmeQmkjI9lW89pkK6fP7kVMmDCAJBso6+chW9D
         +kgk+8JqHZl1i2v6x0Oqd+2D9LP/dxFNPx7FoSWQFenA4u2538K6yAz0HIBn/Wrusmsr
         IaW7H7SPZOE0o2ywguGSVvWUroF90H8OWewDm/yhpiOwRKzbU4WQD8G550N3J/TBo5a9
         u5KA==
X-Forwarded-Encrypted: i=1; AJvYcCVa260TuEt6mrw3fpdO/qqS40NADBl81BRgTFrnWuLLCXgRNkZuuJWTd3O0AiXTIvdl83U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZEVKIPOE98Td1dXRwoPzkfPU6NNPbOOIxWuN2ZOANU1LLwfwf
	pZh05kxuQ0C8BaWAsOVxtxtBAERK8fIdsB47INkam4MIfr6V0rtgiRAGLwi3Uh76TQ==
X-Gm-Gg: ASbGnctgqsquVRNntwgKz5NY9YAkTL8YbhacJmX5rqnnpYWghWX0Cf6z9sGz5LsiMK2
	C1o/ftRqACdjoI49chn6ye8k4aacU6L5TPrFtxoTGoADtGdx20OwC8xCWMysn8eXmuMnZSbx5oQ
	7nKOoulFRVdQNcA/x8OTh+jijSNRqLN8CfvrXcDLr61X+jN5WI/9usUajUUPamIUDRfLK2/b/Vh
	tVwRiER8gX19VAFXAVmdInX1AwY8S7v5R+btyvrDInyiiTwJ2tQuJ7hntU5n9++g6aBMDvtXzo7
	71hGvFORO+x/YBnflvQbzlGTiZacXnpDGUAskVnAQXuZv4RB1kAXWMu5+x4k0viDnQXFMir0LL4
	5+7zLhz+35SJZn8JTRj5irjen1khkOwSHREFHLTBLhaGLRAANxAP2H2zCSMJ/oFJYq7pupUZCbs
	iit4NzfZCRAikyhezMRRYvOgIBZIUQ
X-Google-Smtp-Source: AGHT+IFBVfvcoKubDQzM9ayca7g+2ZobIcYGeDEcwf0nhxbMMwylROUpa0JJFpvYgiSjZLfY0V4/yQ==
X-Received: by 2002:a17:902:ceca:b0:266:b8a2:f605 with SMTP id d9443c01a7336-29027600f6cmr2020635ad.3.1759871799868;
        Tue, 07 Oct 2025 14:16:39 -0700 (PDT)
Received: from google.com (115.112.199.104.bc.googleusercontent.com. [104.199.112.115])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1280a1sm176064595ad.51.2025.10.07.14.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 14:16:39 -0700 (PDT)
Date: Tue, 7 Oct 2025 21:16:35 +0000
From: Lisa Wang <wyihan@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
	Fuad Tabba <tabba@google.com>,
	Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH v2 11/13] KVM: selftests: Add wrapper macro to handle and
 assert on expected SIGBUS
Message-ID: <aOWDM_7gYNwUZFgz@google.com>
References: <20251003232606.4070510-1-seanjc@google.com>
 <20251003232606.4070510-12-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003232606.4070510-12-seanjc@google.com>

Fri, Oct 03, 2025 at 04:26:04PM -0700, Sean Christopherson wrote:
> Extract the guest_memfd test's SIGBUS handling functionality into a common
> TEST_EXPECT_SIGBUS() macro in anticipation of adding more SIGBUS testcases.
> Eating a SIGBUS isn't terrible difficult, but it requires a non-trivial
> amount of boilerplate code, and using a macro allows selftests to print
> out the exact action that failed to generate a SIGBUS without the developer
> needing to remember to add a useful error message.
> 
> Explicitly mark the SIGBUS handler as "used", as gcc-14 at least likes to
> discard the function before linking.
> 
> Suggested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>


Reviewed-by: Lisa Wang <wyihan@google.com>
Tested-by: Lisa Wang <wyihan@google.com>

> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 18 +-----------------
>  .../testing/selftests/kvm/include/test_util.h | 19 +++++++++++++++++++
>  tools/testing/selftests/kvm/lib/test_util.c   |  7 +++++++
>  3 files changed, 27 insertions(+), 17 deletions(-)
>
>
> [...snip...] 
> 
> 

