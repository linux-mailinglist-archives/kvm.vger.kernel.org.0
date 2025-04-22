Return-Path: <kvm+bounces-43824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E5CA96DB4
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 16:00:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26BC31635FC
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 14:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47D68284697;
	Tue, 22 Apr 2025 13:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PV2tlWQD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0699E283CB2
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 13:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745330261; cv=none; b=aZ/K+wYmVHP8dg09DjiVTsz9a99VIrw1uVLXXWZ62GNcqrUA0fp66H3Z5gkNBEr1MDFHElwJMu0Y+zyJPfwN7biGJ2tXdqfznn2bNvQQgGcQt6sh3Ulrukc2jF9vaBpHcKZz0icb1wOLsdibU9XZ4ThFVdKfDVS5XYpxv4A7WOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745330261; c=relaxed/simple;
	bh=x+TWjouQyZAx318alqhMo3y5M6AfxpKu1PzJnrVNUcE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k2dt/BK4WlMQ5EytHtn5RQk9EbUGR4+H5Tt31usF5fi5esK5hK2VeLwYVa2K52xlqJAeeiK7WcGS5U6pfTNMM+VBflKGSfhiZAaRAqIpEWzSOOD5jO4k0nHlWwVVxgVSxhLp2cN7f9LMbbK6fJ9YdihN9KeEaSPQPh6WU7K4VXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PV2tlWQD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff58318acaso7172226a91.0
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 06:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745330259; x=1745935059; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=At7FpAnc2QuGMGzIg88gls4pcYMh8bLp4YSlQH6jFlk=;
        b=PV2tlWQD779aDFZtzfqXiavZyRGsSeqSbbAnKiDvhXAj1sxvxzFkI4MEbRnFAIFMGZ
         le1AROg6bJJM0CXimeE+AA6Q4mEtNYNFEhZfM3parSXVeNBYbRxYwxGJq3GsZKFLTP1T
         e7s1tl4XovOr2gD70NthFu49rdf4EETg+ASZvfdVkQ95UIFYS2koI6bHgsrWlfBdMMF/
         8pHYoC3PyVvDafE05yBmUJ1WjpI2BDKHtt9tRg/BTEBsBbH4KaX7ztXGNRQ6Z9v0Shlm
         DeZ3h9xd7kcI260Ks4BgRrTqke6+4xc1/FFXtWJ3nUcgt6IrjtgpAjmbXyChWZC7V7VJ
         maEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745330259; x=1745935059;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=At7FpAnc2QuGMGzIg88gls4pcYMh8bLp4YSlQH6jFlk=;
        b=wLGWrDJ3idC2nXMni7BMpM93xtW8kDSDPnitRASe83NJL3XGbBd7Q2JHMRECJcFCAL
         99F4JNsOIy8G3za2Dik1spS9U4dRv9vEy/By0OiIuoeccK0EjEGPKrM5bibFRKaUvLNv
         1qg/SPgTuooT8ZUGpttzgFJ6Bs4MnQ4ACpJqbli8DB4r6DzRpeKvWYA46lBglpAWNccz
         Ysca129Y99blfXNEPVZ1cFgREMRRbXyBIAxRX8fkzADIRTQxBA8bRR/YrnpnbssPXocZ
         iU8jspEEGHWg09eYshvAMqnw4Fu/GjYNpVxcJQMsXrFI0LxeBXDDTca/HkBlUgXUuDV6
         zhuw==
X-Forwarded-Encrypted: i=1; AJvYcCXHnQgdy8sU3YA6cUb5xhi+p+vtomjSmlmeaZ/pz20bFkNw340Kr5wLBWwpNyYqlX6rl84=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyJVJ+JygX+chagGpLKwUbsG/agfjQR59xa6JCBhYK0qK1t+Iu
	uBQ7Y1kWBxROgoytAvFM5CtzQHyqh60bTvimz1G99nttXwTtf5SuZvJO83E42jcmwX3A6hSjTxd
	6TA==
X-Google-Smtp-Source: AGHT+IFyQ1fM9qkz115+YvF3/0NpbVqrifPPF3birR34urT3Cxs2+QXSQh1T/IBkVKuWnS9vUJB8VUt/gdE=
X-Received: from pjqq4.prod.google.com ([2002:a17:90b:5844:b0:2ee:4a90:3d06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2703:b0:2ee:aed6:9ec2
 with SMTP id 98e67ed59e1d1-3087bb53257mr26062686a91.14.1745330259348; Tue, 22
 Apr 2025 06:57:39 -0700 (PDT)
Date: Tue, 22 Apr 2025 06:57:37 -0700
In-Reply-To: <20250422120811.3477-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250422120811.3477-1-lirongqing@baidu.com>
Message-ID: <aAegUc5HVOjivAjL@google.com>
Subject: Re: [PATCH] KVM: SVM: move kfree() out of critical zone protected by spin_lock_irqsave
From: Sean Christopherson <seanjc@google.com>
To: lirongqing <lirongqing@baidu.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, xuwenjie <xuwenjie04@baidu.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 22, 2025, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> Although kfree is a non-sleep function, it is possible to enter a long
> chain of calls probabilistically, so it looks better to move kfree out
> of the critical zone.

Even better, drop the the dynamic allocation entirely :-)

Any testing you can provide on this series would be much appreciated:

https://lore.kernel.org/all/20250404193923.1413163-10-seanjc@google.com

