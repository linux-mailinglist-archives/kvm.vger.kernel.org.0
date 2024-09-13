Return-Path: <kvm+bounces-26859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D49C97889E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 21:12:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27BDB1F23D15
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA2C153BF0;
	Fri, 13 Sep 2024 19:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wroRNBrX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE74F14EC4E
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 19:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726254702; cv=none; b=NJGd3vAme84THTC3yZpmagCl6/koe1Y5NWA5CsRmPwFMmEFFTi8GvBbNzSwXIdc8tVtNst/ULMrFO9uZYVEOZYs5AJOBIn0z3d78ReL4YWbTNHiujpo+9Km5qFWijmnI7j+4iKXzcD/KRLJAPa9rUaODXWrY9KQLONEb3OghvnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726254702; c=relaxed/simple;
	bh=df/OdVQzmZ9IIzivyT0nVwAaqNoCrQVBqFQJsmOtcdo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cQnsCmTmj9+6nHErXOoXFlAy5p6CjMQVHC8+Ub0SzbSCPbn+7CduxguGHuaW2qbvfiSN6wCUMCqzLHApI1X+yJV8+BblK5TJpHgaeBTaCPJROFH5vRFXHw46i8bQsgu9VyamiuBGKoBEWSTLaM0kYTad5t0xPqn0c6dRYado7ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wroRNBrX; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e165fc5d94fso4290766276.2
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 12:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726254700; x=1726859500; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=df/OdVQzmZ9IIzivyT0nVwAaqNoCrQVBqFQJsmOtcdo=;
        b=wroRNBrXifviZNzryntxniZPn+arxL0Nh4JCbHM6SqVsnPfMvchzAZ17PLO6xruIfR
         U9tl6oIAONK7yKRTz4Yufr4XW74eNNVuoMKP7wYgyOgvSEDMoShIlNGM0yjF/w4HHGCw
         BK1PYUd2/5DL4gzJ8NW1Dn3TtLMq7rXyNSKD3o3AE1U85mk661wLL6tYANSrRbvgWpH6
         uTt0ZBJBFBL0oWqayKB4Fi3h2V9atHVfw15s/zesi8mtX+h0u3LtacD4Ow2svhk+fAma
         fsDnYrRAdEwLB2U5IxpW5GRrN1Z4MhgBbpISNQ3V66RVMM+2QtKkRpOBG8A/ZUTtkOEA
         JmYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726254700; x=1726859500;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=df/OdVQzmZ9IIzivyT0nVwAaqNoCrQVBqFQJsmOtcdo=;
        b=ZsVG4QFM665hSw6hKMwx12y+D3rWdxIuMJyYGc5le5xLhekxhYSufM07E07iZWkau9
         U1IwaZxVD0v1eDYtmfWzcLlhvKUPxn7XAD6vEfIbcnP90R1ZdRNL6HgrQKiZ29g2ARRD
         ehNWcI4PFFC0no5YuCjeQ/B3rnNqhRNzBqA9JY/wiCsZd1DShWIOwE5jeLnzHAX/CLAf
         xQVV7/wrlykLaLKhIUV3nZIxMv3FcoUkzOgu95LdKVBXEYvg1I5LxGYww89vcCOooBda
         wMMk6aF7/SHMI7F0+dNkraha7P7M6ziuWPuXFgpZRFwqZexeF1g3WlBXs0mcs8/ZuPV3
         TA8A==
X-Forwarded-Encrypted: i=1; AJvYcCWBpP1zGsZ1a7QhM5y4c6xjOKW3yb2mA8OG2qI/bpX0k+R36GM5MKohKmfv0HzncCiKoX4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa8m8CZtkaBeMjd8ycRRdWFtRvwg72I2wok/39Y+qcUYpYakST
	774WpVvyZEX5tDVa5D+dWeh1TLsi5lZMQO21CVcOixQFNvvJ89m0H7TGUyh+Loi/uufgWin3gpG
	Syw==
X-Google-Smtp-Source: AGHT+IHWKdvpTgRToeIjzP7LiLbwdIQd0DfavHeMBa0nhxmMEncC0lsKplD9gP28OszQ1s0UsOTgeX3hi0E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:86c9:0:b0:e11:5a3c:26c7 with SMTP id
 3f1490d57ef6-e1d9dc4275fmr12810276.9.1726254699289; Fri, 13 Sep 2024 12:11:39
 -0700 (PDT)
Date: Fri, 13 Sep 2024 12:11:37 -0700
In-Reply-To: <20240609154945.55332-12-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240609154945.55332-1-nsaenz@amazon.com> <20240609154945.55332-12-nsaenz@amazon.com>
Message-ID: <ZuSOaTw1vgwquqTE@google.com>
Subject: Re: [PATCH 11/18] KVM: x86: Pass the instruction length on memory
 fault user-space exits
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	graf@amazon.de, dwmw2@infradead.org, paul@amazon.com, mlevitsk@redhat.com, 
	jgowans@amazon.com, corbet@lwn.net, decui@microsoft.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	amoorthy@google.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Jun 09, 2024, Nicolas Saenz Julienne wrote:
> In order to simplify Hyper-V VSM secure memory intercept generation in
> user-space (it avoids the need of implementing an x86 instruction
> decoder and the actual decoding). Pass the instruction length being run
> at the time of the guest exit as part of the memory fault exit
> information.

Why does userspace need the instruction length, but not the associated code stream?

