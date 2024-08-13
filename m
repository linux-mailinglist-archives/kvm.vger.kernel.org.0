Return-Path: <kvm+bounces-23925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CF3C94FBD2
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 04:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB0BC1F22446
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 02:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766FB182AE;
	Tue, 13 Aug 2024 02:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AD0RZ9kV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A22717C91
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 02:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723516293; cv=none; b=lFSS1iIEl/wyefhby+d2tC+wLV0YpaJ6uGR58e+6HPviI6JUubDZz6khBl3OzLg4lu+0gn9jmiFfC6dotspVDAQ1FeTYCsPfUQn7djdd04dSZ63N0cZRIFlg+5zDv0cAZAWwYJ7cw79rVx3i0LXdqMW2stGC/LRBlw1CzHaQoXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723516293; c=relaxed/simple;
	bh=woBsSHTh9Hl0wFxsTB2KJshf6tc0VPqVZMVsMpmNtFc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FiveULO/mipmRDbSo9Ie7WMczuUGT9ii9z6xTcQrsZYQn/uwvkQzkahJLgLSM25J3txs0XoDfx0PRwGxHpWQEuvp7Iafr6Pw9un18Hr4QANgSs22bmbF6QfgwHx3s6PaqcnDPD3AUdxPzfmhPDAsQSlG2DNHlR0ppQFtnq3fsj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AD0RZ9kV; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-68f95e37bbfso123263607b3.0
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 19:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723516290; x=1724121090; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gh58GEXK4hRTddIxJHKVaYTC/XHH8mXuxYPgd5eCDUg=;
        b=AD0RZ9kVCIEfJtPz7TNLumt8r7C1yZ63cxc7VKxF0ixnePDFU/SDKD2QBEqmxleSg3
         JbsztjMR7tnXZn/qCz3eG5KjIFFNYMZMaEpCvHUhBnG3qSdP5p6KfUvn1aA4fcqnJJ30
         U0QNZxE7wosxk83KWFlQlt6primFq03in0mARDBaJVEqJkPwC8zmLn3VXLQuC71/nXWu
         TxbWHKrvp8zmtW6JRJ1arQzkQD+4HOodDln1Q6kGPhF86pvabioApuRes6jfrVjqK43/
         cmZmHqitl50k9kX83xnTPNoa40rOT3jsyGZ1B9y7WD6FexmJutxgP9zszK2WqNvIyVy2
         3Nlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723516290; x=1724121090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gh58GEXK4hRTddIxJHKVaYTC/XHH8mXuxYPgd5eCDUg=;
        b=qNpUigkDlkSuMWdwbVwnj3/yr31jBChwu7C8warUm+dhFsOZZnbYJhXN2km0YApu9I
         vDw1B0ZZgSOhyWEMR5vh7KaqpMVjABrA/lOycexsBhG5AqAOXE/9rVxEX2dMQxZMUGMn
         GvJbmaqr0dDnfcEr9iLt2vTaguJTrUx1jahADwpBVxTV8sPl7DnirgpMKgZUHYlFLl7U
         xNBhkEjgLwfDhWYUXRIcriolBTnI/lIxezETwx0x2LHPICObn9ZbUP5Gqr82RJZWqvQ2
         S1UvOQYgaJWfmjYJM91v2EaP/p8FFh14GtgMWaK/j/yK6n+OZR8P2MkjhCbwtp4kyk5M
         gqBg==
X-Forwarded-Encrypted: i=1; AJvYcCWpDNjtzmUSa+xlUVCNVBLsHLiDmAA8b7AWUfp55IVhp5bIRwqmBQpV8QLzEkvM+tFFjT9XJF3UKzln76RL2rqg5VZi
X-Gm-Message-State: AOJu0Yx5EjXTRShsVrH6t/1Jf4chkTGTOoMyXBHH7s0tF3sXymIHum9a
	/S8bkJyTxBelQml7FxP8pPDv8C6sKzfPYnU5vGWkBsHd+sB0S/5Av0gaeglumPZG322CTJ14ebD
	zaQ==
X-Google-Smtp-Source: AGHT+IFB9EyuunWncRf+jD9j5VeUzAj+xYlxXqt55B0enzPEOPthPCthil/po3BowNfAJFJntJispzxFAPQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d84d:0:b0:622:cd7d:fec4 with SMTP id
 00721157ae682-6a97695ee2amr784907b3.9.1723516289965; Mon, 12 Aug 2024
 19:31:29 -0700 (PDT)
Date: Mon, 12 Aug 2024 19:31:28 -0700
In-Reply-To: <7e12a22947bdaf7fb4693000c5dbcf24a20e6326.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com> <20240608000639.3295768-5-seanjc@google.com>
 <7e12a22947bdaf7fb4693000c5dbcf24a20e6326.camel@intel.com>
Message-ID: <ZrrFgBmoywk7eZYC@google.com>
Subject: Re: [PATCH v3 4/8] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 02, 2024, Kai Huang wrote:
> 
> > +static void kvm_uninit_virtualization(void)
> > +{
> > +	if (enable_virt_at_load)
> > +		kvm_disable_virtualization();
> > +
> > +	WARN_ON(kvm_usage_count);
> > +}
> > 
> 
> Hi Sean,
> 
> The above "WARN_ON(kvm_usage_count);" assumes the
> kvm_uninit_virtualization() is the last call of
> kvm_disable_virtualization(), and it is called ...
> 
> > @@ -6433,6 +6468,8 @@ void kvm_exit(void)
> >  	 */
> >  	misc_deregister(&kvm_dev);
> >  
> > +	kvm_uninit_virtualization();
> > +
> > 
> 
> ... from kvm_exit().
> 
> Accordingly, kvm_init_virtualization() is called in kvm_init().
> 
> For TDX, we want to "explicitly call kvm_enable_virtualization() +
> initializing TDX module" before kvm_init() in vt_init(), since kvm_init()
> is supposed to be the last step after initializing TDX.
> 
> In the exit path, accordingly, for TDX we want to call kvm_exit() first,
> and then "do TDX cleanup staff + explicitly call
> kvm_disable_virtualizaation()".
> 
> This will trigger the above "WARN_ON(kvm_usage_count);" when
> enable_virt_at_load is true, because kvm_uninit_virtualization() isn't
> the last call of kvm_disable_virtualization().
> 
> To resolve, I think one way is we can move kvm_init_virtualization() out
> of kvm_init(), but I am not sure whether there's another common place
> that kvm_init_virtualization() can be called for all ARCHs.
> 
> Do you have any comments?

Drat.  That's my main coment, though not the exact word I used :-)

I managed to completely forget about TDX needing to enable virtualization to do
its setup before creating /dev/kvm.  A few options jump to mind:

 1. Expose kvm_enable_virtualization() to arch code and delete the WARN_ON().

 2. Move kvm_init_virtualization() as you suggested.

 3. Move the call to misc_register() out of kvm_init(), so that arch code can
    do additional setup between kvm_init() and kvm_register_dev_kvm() or whatever.

I'm leaning towards #1.  IIRC, that was my original intent before going down the
"enable virtualization at module load" path.  And it's not mutually exclusive
with allowing virtualization to be forced on at module load.

If #1 isn't a good option for whatever reason, I'd lean slightly for #3 over #2,
purely because it's less arbitrary (registering /dev/kvm is the only thing that
has strict ordering requirements).  But I don't know that having a separate
registration API would be a net positive, e.g. it's kinda nice that kvm_init()
needs to be last, because it helps ensure some amount of guaranteed ordering
between common KVM and arch code.

