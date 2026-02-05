Return-Path: <kvm+bounces-70376-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QN6OJdEbhWkO8gMAu9opvQ
	(envelope-from <kvm+bounces-70376-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 23:38:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EC9DFF8262
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 23:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F1E163043002
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 22:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4F633A702;
	Thu,  5 Feb 2026 22:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cy4xPRty"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC5F339874
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 22:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770330928; cv=none; b=W66I2U6Tn9CccqdSyBVQDeAMEE1jjSnTOkVP7SdhYUqlZWTeOx/oivHElkVSWINE9xNX3Ouc0OEo3Ir32z12/N4J63u4hbZ1kwWl4XWRw3TfIdLhqHEr72ump+P/R3m8YaC22mt9FV1eNdSvRlc5dni20SP2Jiw5KTnY3iEIgvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770330928; c=relaxed/simple;
	bh=DTZoxUBHwlPOflFRXBTJQv1wRjt+JpIiExBlV0YHN2Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZazGSYwJiozFtcvfVYnYWYNpMMLEdkkIFd+zod8shGCbSuvrFy7pxqn+4qREZuhPHfqiStzQzTi1/2jU75dTouK5R4ILU4l04lvRq8bpVanZl+LcaQZ1M7bCiuqL81EgQYmZ6jvq/Jg1DVvZaPAkVX49YgbiXx+sfKlq9ll6l7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cy4xPRty; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8216fece04cso2114746b3a.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 14:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770330927; x=1770935727; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AToWCMx6AQDZQKwYN/F1QOoyLmm2g7aKLDy9Pva2rRY=;
        b=cy4xPRtyGcsXgAy6blC+tpO42pFxitsxk02YYQBHFRXxZwmw6tveik+F5xeHQ4kgVM
         Na+f+P6t1zd2X698ga9wusxL7hWejpZFRrFU3wpvP6cvQIWtRAr7+eKv64rmYrZdqX6u
         bABB+SWjkZd81rybwHfDYkw8YqWJi4syypS3QbsW+RgrmOyJE3BJSXem3Mhj0OTksh/P
         LfkQTROgxgMW8uCBdCbAnCCNkxHfs4trf83bqMkKTmoqxozk075OuV+8yQtrAhZnSCZY
         5uOGqXXAGw6n2QDSQTp240hkIQkzTX0ge24qLflhaCTikzGdZIddQp2eMCGqETxvuy/P
         KtVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770330927; x=1770935727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AToWCMx6AQDZQKwYN/F1QOoyLmm2g7aKLDy9Pva2rRY=;
        b=RSp6wX2ATU1G17+9T9MH/4tJx5W6YvSu1DoAmXRXKvU6Mw+PVHhcmimK1plP1Ybp9u
         NFIZJoIfYkO0rO9bB8haHuNX9zui+HxFOZsqraxPAiXHV+6nWFVzAlUcSh+jHFKnWGkZ
         ZdQCVD5dvIvkBd5hOMj+MgJE4V0LmDjEvMPwj8vAPcS4z7/g7gKy2rj9mm/+AaWOSd4m
         TFsnoNknzzjMnyZMALVpl9RfGu4LPPTFIU888R+yt4befkmqQ9BbLxJU8/wtDAzQHyd3
         D6qLo/BjNKPEndP5rCzd5q+hJaZFJgA0cLUbCC1vKN0R/C3SXOW/2CpVK4K0BkBJ36rV
         mIlw==
X-Forwarded-Encrypted: i=1; AJvYcCVfSlFDAErFB07R2cgcetGowPZ8g81SBm3QXhK6clT+l85UnhKKwodLCdD7TyRikbDHaXo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwHlKR8GLPKp0Ym9y4r6dHtMB0TC8sQvhDJW3yJhR2qvkUlxAh
	Tuyv0/65ObsR48miWRW9sUvNdnjtp5EsJTCKGubgV/xT5L6dncYQvUAuKoeZfY4QpU4Ze5c3VGr
	62/wq/g==
X-Received: from pgjm1.prod.google.com ([2002:a63:fd41:0:b0:c65:e57d:fb55])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c88d:b0:366:14b0:4b00
 with SMTP id adf61e73a8af0-3938fd02abbmr3806163637.39.1770330927334; Thu, 05
 Feb 2026 14:35:27 -0800 (PST)
Date: Thu, 5 Feb 2026 14:35:25 -0800
In-Reply-To: <aYQ0l+C42gssMHHV@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-17-seanjc@google.com>
 <aYQ0l+C42gssMHHV@yzhao56-desk.sh.intel.com>
Message-ID: <aYUbLVrxwDDZ2qh-@google.com>
Subject: Re: [RFC PATCH v5 16/45] x86/virt/tdx: Add tdx_alloc/free_control_page()
 helpers
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70376-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EC9DFF8262
X-Rspamd-Action: no action

On Thu, Feb 05, 2026, Yan Zhao wrote:
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index f6e80aba5895..682c8a228b53 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -1824,6 +1824,50 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
> >  }
> >  EXPORT_SYMBOL_FOR_KVM(tdh_mng_rd);
> >  
> > +/* Number PAMT pages to be provided to TDX module per 2M region of PA */
> > +static int tdx_dpamt_entry_pages(void)
> > +{
> > +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> > +		return 0;
> > +
> This function is not invoked when !tdx_supports_dynamic_pamt().
> So, probably we can just return the count below?

Or maybe WARN_ON_ONCE() and return 0?  I have no strong preference.

> > +	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
> > +}
> > +
>  

