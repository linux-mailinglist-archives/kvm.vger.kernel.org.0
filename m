Return-Path: <kvm+bounces-56381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 203FFB3C58A
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 01:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CD151CC1EF8
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 23:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB2D9341AD7;
	Fri, 29 Aug 2025 23:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y5EFAiXo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845B12701D1
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 23:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756509498; cv=none; b=YkUlPqUh/K8hfMxNJUKOgVCZ4fiW0Ab/Nz20/m11LLRWcFVpRPxS0pa6+rkMq/qQFz0sZNXaqN9kcOa9PWUUnE/Uydwxb6O91s3W2F0hKjS+f21lWBoBfXNcsEzluXMY7lJSoDhoD+qrAUz7FUAwEWjgbPETGjgwqqdmcL6J+RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756509498; c=relaxed/simple;
	bh=b4k5SA3vfZ4J6ItroEh7lhLBwWJ/AtyHtaEDaKZpIOs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gMw0zNUk9BpTI3xMeYyDwZxHv8lAG7R5PROYkepz9MnuC4tAkk0cJHhiFA75bWIKis8csAkG1j2vaxjj/VlhD+xVlKgbzVdRIBhvWJSCs8XLnzmaRROeSy8OlDMh6Zl5rbjSM84N4qA68nqNXfGKgofaDKZv0/VINft8KXWT3P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y5EFAiXo; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24868b07b5bso45228785ad.2
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 16:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756509496; x=1757114296; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l883seK4EjiK4aVDUcNtlslE/Fg5nekU6zN+DlU8lKo=;
        b=Y5EFAiXo4TGuQPLq9tC6/sH9HkA+n2cQw25cS3Sy8zF5ZBEUay6hhea/vDEC2F7uYZ
         A080fOt4XROw2Pb6XueUAnjN8vx4ZgalDfmb3CvshmdYcRZNgjdNDE3NNreArhxlzVSk
         XWReXLwzAc2di9Ju5y6kIzqIDZ1mgjE3DD21kLeqO7SXLxTo16SOfKxZAo0RklgVR0zw
         bdJQ4HVZ8IQSgFQ7Du4h7QjP28t0GDOGR8kUw+VlWB12dZlWasBCImpFGNpEN4c47zmy
         4HtnpMW9iFGXmo4Jno7itHW2fDRejC5SJx/owyY8dC4NwlaaxhyKSFPs31IFhBsVIDiJ
         /BGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756509496; x=1757114296;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l883seK4EjiK4aVDUcNtlslE/Fg5nekU6zN+DlU8lKo=;
        b=UMSRR4VelX+Q3ht/Qatut1xGsLKXDtapZQ9sq/KzrRDiMjx0Yujbn45O3U80aHNj1L
         b7zXBS01G8bGqrnavUo/SjDCsnXkXc43EY8NS19m+wT7pwS0q3zmhDtH9rCMQz+rz8YC
         m8RAg7kvEBHyZ2udjNd/cBeyabL8Hb3qV7rMsYuvwvD0v3ifjD+UW0z18MrevgVg5PJE
         zhSDObxOgY+tIKIIeyvoADz98lOF59v+4+cyNgc9Ue14Gs6Qh8X6D5J3Iy2ANujIspIc
         L12QMhc04lfiEX5EG+XWR76uqD2BwVaoDu3qznCIhJeNq5B0S9VfE39QI/NKedSwss/s
         fQkg==
X-Forwarded-Encrypted: i=1; AJvYcCV6qSqweInwLzmWp2gsQE395eAVOFz/VZvhS4oxOzAAOneyqUg9dG0Pp1tyyDdqbpK82WM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbgQCug647dKQ9JLg6cXMElTcA+w07Bu1k4sn0e1CY4h8meRcN
	zJloAQznuztNt999YGW1pCluu1IGFu4HsZhpDJqWalLUVYvtr4wBoA4MYJeNOqdvWDXFS4oVmU1
	1TTd6MA==
X-Google-Smtp-Source: AGHT+IF1OM0nQRYfPLCN66NMT04qXg7cQ+GJ78a8jXk9PjEi0ezBYTBW7zLm8IduaCQc03SdW3jw7oMOKJo=
X-Received: from plbmm3.prod.google.com ([2002:a17:903:a03:b0:248:847a:f298])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32c3:b0:249:c76:76db
 with SMTP id d9443c01a7336-24944a64ae0mr4589795ad.21.1756509495776; Fri, 29
 Aug 2025 16:18:15 -0700 (PDT)
Date: Fri, 29 Aug 2025 16:18:14 -0700
In-Reply-To: <b47e08bb6105a94bc88ee91aa7bdd055893eeda6.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com> <20250829000618.351013-13-seanjc@google.com>
 <aLFiPq1smdzN3Ary@yzhao56-desk.sh.intel.com> <8445ac8c96706ba1f079f4012584ef7631c60c8b.camel@intel.com>
 <aLIJd7xpNfJvdMeT@google.com> <c8352e1a76910199554bce03a541930914ff157d.camel@intel.com>
 <b47e08bb6105a94bc88ee91aa7bdd055893eeda6.camel@intel.com>
Message-ID: <aLI1NntrAXP0CxPz@google.com>
Subject: Re: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the initial
 measurement fails
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 29, 2025, Rick P Edgecombe wrote:
> On Fri, 2025-08-29 at 15:39 -0700, Rick Edgecombe wrote:
> > Ok, the direction seem clear. The patch has an issue, need to debug.
> 
> Just this:
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index c595d9cb6dcd..e99d07611393 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2809,7 +2809,7 @@ static int tdx_td_finalize(struct kvm *kvm, struct
> kvm_tdx_cmd *cmd)
>  
>  static int tdx_get_cmd(void __user *argp, struct kvm_tdx_cmd *cmd)
>  {
> -       if (copy_from_user(cmd, argp, sizeof(cmd)))
> +       if (copy_from_user(cmd, argp, sizeof(*cmd)))

LOL, it's always some mundane detail!

>                 return -EFAULT;
>  
>         if (cmd->hw_error)
> 

