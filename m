Return-Path: <kvm+bounces-24553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C1CA9576B8
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 23:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A19EB236F5
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 21:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1051414B945;
	Mon, 19 Aug 2024 21:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1azhZR6y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFA415C12F
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 21:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724103622; cv=none; b=prjtD32wC3Za6I9eYAYs2gdDJUrWnNHiFdnLyuJL6mFx69l4m294qy2cidLW9nFjmNwlHE634TlD/lSGocv1gUfjO1Dg/ZaPziNcV6y6gmunkaU/JVCT/jW0Cwj+D5QIHnUhl8RM7VtLZN68AoeX65iFCQpBDn1Bf2AMFJoI50I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724103622; c=relaxed/simple;
	bh=v6heCgna4ps7xRj57FO5t2CRD6UgMmSfqbGtFS6cg8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VGMTT6wR9oNPGrlMmOkCz8ZfjWAX456wwSVedcSkkFqoX9tsgIdI/d9Gn/EPxvfGF2D4f2nGHdgbay3LwxPGIblVUKzxbFw3EBMytWfVpkI0N2W4L9FCwH99t0R4TIZVHrK4YLdw2sRLsSYcwE3qre7TTOVVCfEjzZzRuaSCLys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1azhZR6y; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7140962ac9eso160826b3a.1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 14:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724103620; x=1724708420; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5S3Kw3kYeTybE4IdqoIkPTUjwWfh+HdvssO80Qc91j8=;
        b=1azhZR6yyrCDFqcdnejxuoexhrbi7fSOFORyfEwbed5RgYyyRh2W3IOfjYN/dLmiwu
         mNaFuGXvQAxN0N4wC5yY4H3CyrZAFPErkyKaMODzsh1kEU3d8VPmFSD0gWb2Z8s4XRU9
         F7yWutwriVcBJdBkTSmuNfv7WDHTLgbmEB138wZGLqzfM590pb2068F4EaQ+jiR0yAp5
         vdS5XiFu2XAoOW7Ax5e13NzHik0M5FA+CWuCtDfv+tXzYjpqXOSsI41NFV3GaOUByuIi
         d6onvXN0vrC/Zq4eWDFbgfJWHM/udlTBH/MLRnppqKezGgKCoiDUMpatpno+w2uzk95g
         0Haw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724103620; x=1724708420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5S3Kw3kYeTybE4IdqoIkPTUjwWfh+HdvssO80Qc91j8=;
        b=rbOO8wbptgfavKCIgix0UGZhWGWm0vB8IGaFKtNEgM0TmMU3+sy40MgbYT1XO0qCmg
         35+c/WQmB3G6iVM404PT+ZrXgzoOtRRqNBKYS6gcqQRt5G36guOnd9PRBWYxWLtAz5kk
         mlSjVYanTDFLAfBxsvfOeXv74w2eUDGpnumJyGvLYHpEaC6jKdowFdlFkgXGjQhW3lY1
         51p+D6kBCxo/ccCEf4dfEVSqVrhhHVj5By0zzIT1A8fgR6D86L3ulkUlUNQn/7UVA5S4
         8k9FVui7XtsMNwSpFnxw/n8Enh3iM5/U4MDWnDj8980WXSs/6b+G2H7g65qozkgFcj53
         bTZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYUugC6Bmm9mgSDZad0RhuUU7r4xQzueWMz/1Vd3Cmd2DyxkYoh3adjrNXkH0HkWZ62R4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwemXNH4i1WQcmK579esNx/L9ykG/KdJtBYZY9av8Ui2WWkF5I5
	Vjv8SmaHFRldUqjsSWPPQQsr67SJoPELKex/Q7KZsD52A9l7/XMnJJnEititNA==
X-Google-Smtp-Source: AGHT+IG/UM9dIuqVGkTLFa2xl60pFunxB6xNERoGmgq98y6Rzpw65rjBBl6ExjH1tgKz6ay5bDIeBw==
X-Received: by 2002:aa7:8112:0:b0:706:5daf:efa5 with SMTP id d2e1a72fcca58-714081af644mr1338937b3a.9.1724103619704;
        Mon, 19 Aug 2024 14:40:19 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127af3d14asm6997736b3a.212.2024.08.19.14.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 14:40:19 -0700 (PDT)
Date: Mon, 19 Aug 2024 14:40:14 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Liang Chen <liangchen.linux@gmail.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Register MMU shrinker only when necessary
Message-ID: <20240819214014.GA2313467.vipinsh@google.com>
References: <20240814082302.50032-1-liangchen.linux@gmail.com>
 <ZrzCD-cL4N1DsRaO@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrzCD-cL4N1DsRaO@google.com>

On 2024-08-14 07:41:19, Sean Christopherson wrote:
> +Vipin and David
> 
> On Wed, Aug 14, 2024, Liang Chen wrote:
> > The shrinker is allocated with TDP MMU, which is meaningless except for
> > nested VMs, and 'count_objects' is also called each time the reclaim
> > path tries to shrink slab caches. Let's allocate the shrinker only when
> > necessary.
> 
> This is definitely not worth the complexity.  In its current form, KVM's shrinker
> is quite useless[1], and there were plans to repurpose the shrinker to free pages
> from the so called "mmu caches"[2], i.e. free pages that are guaranteed to not be
> in use.
> 
> Vipin/David, what happened to that series?  Are we still working on it?
> 
> [1] https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com
> [2] https://lore.kernel.org/all/20221222023457.1764-2-vipinsh@google.com

NUMA aware page table series got deprioritized, so, MMU shrinker changes
also moved to back burner.

I will extract the patch [2] above and send it as a separate series which
just changes the Shrinker behavior as it is independent of NUMA aware
page table effort.

