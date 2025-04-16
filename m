Return-Path: <kvm+bounces-43488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA52A90BEE
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 21:06:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABB1E4607C8
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 19:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582AE2248A1;
	Wed, 16 Apr 2025 19:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vvDC6X4C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DBB21B905
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 19:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744830397; cv=none; b=Itnp64MVASe2w7plMdTBJRWGJ9DYGGrnayqktfZK4+6yCKqoNLz1UmD73LnsU0MD4tW5MskmYgR2Vuwlh+odnWfiVZelSlKhbrwT6RXZMaKbdLGCIDsodMI/JarsvrRbrKv5TVMECUrrm0G8aFT2DiKMIE7pokgpx/Po/ZOzXYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744830397; c=relaxed/simple;
	bh=8z47v0y/RBpvELhTNkc41DID8InWw4fwZBbvVfaGcgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eCm2ZCU2NG7Z5wwk9VjLZMaLMXAwX+SBsCXrROGn2ymvcwLkDIu9odkUIJaAKfnsGsKUN/TDd0dUO+mzEIs48ULOiqgcGxdD/WE+UJVTZXsV2usSS6izbWUPM/MMvb65yZ07NmuiVmRW6sycs9gaPCCLdTAcLq3X6qm7c0kF2Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vvDC6X4C; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2263428c8baso40895ad.1
        for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 12:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744830395; x=1745435195; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kWuAzoWjXRQKcdL3H3i479C55svElbJ5pMQd8TVZ4Ts=;
        b=vvDC6X4CppuiMiOVfBry7XxFH6TTNFzYCDH+VkUJ/I6kv3YZecU8RFUplfXdUZkUBS
         aENIWc4LGOxr9hW9qxjpQnu3ToKCf+IirJ2cITCyRYxuXWNbnLlPAadMwL/b+d1zGfW3
         3iDPhsjaIwVJe5G0Jxg+hDmckXeUFQB2zFu2Tj1paF3Ij+3nuNH0HfQU16tpMdEURYO7
         g1aBYfv/MnNtcREhcRac51iVZfD7FQ+EacEx9GM1FBhs7jfhNxGUvaxhako1MjTeJ0Z7
         QplF7gG3JJJg48Cz6FIPmBTkmqDHG25fXHGmTtVsSxl9coRD7I143V+S/W7TAtI3zlLm
         gJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744830395; x=1745435195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kWuAzoWjXRQKcdL3H3i479C55svElbJ5pMQd8TVZ4Ts=;
        b=bkgSIJzlsPa4mAnzSYT/XtO/hVC3iXpw3wgwZ5zf6n7PZh5nzDYPgYsP/Bm9Odnf9V
         r9BvNRCcDI+X7/cp3HD+q845xLQ1Oy65MU8KC3M4O2NwmYtZmZ4ID4v7vDl/A0zXr8Xs
         +P9xtQqGi683ulei1cimv3JkvrrBQO8g7OiB5G0jM+JA9bi5eRQbXCXbSbtmRjt11SBd
         1+owMYCNP9m+beb5oBfZDacQ3oGd8/9aPGLL2EVfCl2hDQjuUKfwCfupgXQEGFr6uZgw
         A25piQSM7I1Q/FjW6J9bfjfF7HqmP8B/9ubwznhyZoB9CGH+EvlAW6C6asg+n1qRLlAF
         3eMA==
X-Forwarded-Encrypted: i=1; AJvYcCXPM/B7fh9Ctnz85u98JQ+PVDwz0FWXuRnydFcnbUZq0hv3oja8NUoHfgfPFTUGzcluY9o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0oh3y/BV9JaB8iajNQHa69lxPtN9EYsT4Rv0sqZ55dCSrMMPf
	EmvxzmxDyHZPrjjsBB+5Me/2VcyZTVHypeTtFBGEhrVKRnmmPBYuGGHUpsTQBQ==
X-Gm-Gg: ASbGncsYItZ+20IRtOH/OV/nj87zNKBag9k8vNsEmzBzUtZ5gjTIBszknfaGzY15jp2
	+PzEs5rIjINj04c1/DVfs6+LQzaAlgI8INebf+J3CJNFR0uxFGe5z8Kw+ejqMdo1wYVuU130/Qv
	Kp++6bYgEV9ur9vC/lcuGzKYEPplsho0pS/llwlAsC9Pdoqo7k58Mm+RmugJ7NiAb6oay+k64l3
	2xNQQASiC58Tja80+77MmwsBUkWufOL/Ric4Y76Xqv/MNK9VnvtGF80IvqOl0Z1gUGVwtjvZFSu
	B3rFjlcOqKYq2v0bW1Z9ua/nFXxk60JZtQftIZ0nKiklK8+CYYiaNIBsEhIv7nKuAjd8Ilz7Gwv
	06w==
X-Google-Smtp-Source: AGHT+IGi66f8+mN6aN8KhzRjjcF3CHZ0D2PJue18obrWmtFxD66ZzfNgY2fZUJNbR+nxkfakJTeGhw==
X-Received: by 2002:a17:903:240d:b0:21f:3f5c:d24c with SMTP id d9443c01a7336-22c40e7ff19mr616215ad.0.1744830395119;
        Wed, 16 Apr 2025 12:06:35 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd21c65c9sm11192998b3a.61.2025.04.16.12.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 12:06:34 -0700 (PDT)
Date: Wed, 16 Apr 2025 12:06:30 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: x86: Allocate kvm_vmx/kvm_svm structures
 using kzalloc()
Message-ID: <20250416190630.GA1037529.vipinsh@google.com>
References: <20250401155714.838398-1-seanjc@google.com>
 <20250401155714.838398-3-seanjc@google.com>
 <20250416182437.GA963080.vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416182437.GA963080.vipinsh@google.com>

On 2025-04-16 11:24:37, Vipin Sharma wrote:
> On 2025-04-01 08:57:13, Sean Christopherson wrote:
> >  
> > +	BUILD_BUG_ON(get_order(sizeof(struct kvm_svm) != 0));
> 
> There is a typo here. It is checking sizeof(struct kvm_svm) != 0, instead
> of checking get_order(...) != 0.
> 
> >  	return 0;
> >  
> >  err_kvm_init:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index b70ed72c1783..01264842bf45 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -8755,6 +8755,7 @@ static int __init vmx_init(void)
> >  	if (r)
> >  		goto err_kvm_init;
> >  
> > +	BUILD_BUG_ON(get_order(sizeof(struct kvm_vmx) != 0));
> 
> Same as above.
> 

After fixing the typo build is failing.

Checked via pahole, sizes of struct have reduced but still not under 4k.
After applying the patch:

struct kvm{} - 4104
struct kvm_svm{} - 4320
struct kvm_vmx{} - 4128

Also, this BUILD_BUG_ON() might not be reliable unless all of the ifdefs
under kvm_[vmx|svm] and its children are enabled. Won't that be an
issue?

