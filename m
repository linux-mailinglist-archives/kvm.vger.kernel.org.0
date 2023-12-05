Return-Path: <kvm+bounces-3477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 005FC804F95
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF8342817C1
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 09:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4994F4BAA9;
	Tue,  5 Dec 2023 09:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dXBC5Xgm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F56173A
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 01:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701770257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2OrUBFUhakwtF1xCLN9g9kW7+oSzP8RjoKeN3OJBDHI=;
	b=dXBC5XgmSdkrsIOiLjwy194kP/x3j3lYBK0nabWHven2ZDOn1yQSYpXgnfb28hz4l1sBvt
	VXt8qUJA5QP5jMaPckNmKlangNQn9tiLhUUKKH3Q5Mq9nlFZasDP972hTKmYcsRy1mNZiR
	tic99nFtDsgxfx5ExEhgz/gQRgr+oO4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-GVchJWiePKysIUK8KDB0bg-1; Tue, 05 Dec 2023 04:57:35 -0500
X-MC-Unique: GVchJWiePKysIUK8KDB0bg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3334b1055fbso1429043f8f.2
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 01:57:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701770254; x=1702375054;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2OrUBFUhakwtF1xCLN9g9kW7+oSzP8RjoKeN3OJBDHI=;
        b=slNZyi0Kt8nWBgf7yzNnT6AowU4c5DGSvwTw7TjOz+q7WvYUZx/uP3MIejkaqF4lYE
         LZLA3IlccMglYwofVduV7UC6OoWK/6cRsTJcsfdh1CQRxKhfI2/cODYHNz+VyzE1FiC8
         bfqRivQovISclnpA0qWwllhuO1JOk8YUAjs05Uf1z30WG0g24eZi88vrQF9n7Pv8LDqB
         wXY1A8SRT/4Ss8Oo4If0zpEpCyLI4XWWym4I+esJ5cCBveTLURWLPGOnAJ5ESzC29NGM
         4qUc08+bm7Cxp+h0lM+fWC2qtSF7axIjvrp9iKITUjvKCoPicAwAcLAs6UAehZYo3Ujg
         Gr9Q==
X-Gm-Message-State: AOJu0YxIvNx0CoZiqK7Z7hOOVze4DMGqhWRIbIGx/1bmt4t2Nwv6X6bi
	Fns+woLl45TLHzzigxneNLUXQvLIASEtwJ/R7I55pO0a0DjNMtRm3irbB0kHiC744t3E+Kz2Ije
	QkKnp3if05hON
X-Received: by 2002:a05:600c:8a4:b0:40b:5e59:99d8 with SMTP id l36-20020a05600c08a400b0040b5e5999d8mr197461wmp.248.1701770254591;
        Tue, 05 Dec 2023 01:57:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGcGMbovZBUpY1Dnbx1AH2plPXeeYz64KJ2yt/AetdTyeHkanIxz5g43gecoJYqsrGfehOzag==
X-Received: by 2002:a05:600c:8a4:b0:40b:5e59:99d8 with SMTP id l36-20020a05600c08a400b0040b5e5999d8mr197456wmp.248.1701770254282;
        Tue, 05 Dec 2023 01:57:34 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id d17-20020adff851000000b0033335c011e0sm9599559wrq.63.2023.12.05.01.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 01:57:33 -0800 (PST)
Message-ID: <7ca548b082608862ed1c5896294b393648e40def.camel@redhat.com>
Subject: Re: [PATCH v7 06/26] x86/fpu/xstate: Create guest fpstate with
 guest specific config
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
Cc: dave.hansen@intel.com, pbonzini@redhat.com, seanjc@google.com, 
	peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Dec 2023 11:57:31 +0200
In-Reply-To: <0112b446-ee7e-4b78-b3a4-671d3ba67299@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-7-weijiang.yang@intel.com>
	 <e1469c732e179dfd7870d0f4ba69f791af0b5d57.camel@redhat.com>
	 <0112b446-ee7e-4b78-b3a4-671d3ba67299@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-12-01 at 16:36 +0800, Yang, Weijiang wrote:
> On 12/1/2023 1:36 AM, Maxim Levitsky wrote:
> 
> [...]
> 
> > > +	fpstate->user_size	= fpu_user_cfg.default_size;
> > > +	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
> > The whole thing makes my head spin like the good old CD/DVD writers used to ....
> > 
> > So just to summarize this is what we have:
> > 
> > 
> > KERNEL FPU CONFIG
> > 
> > /*
> >     all known and CPU supported user and supervisor features except
> >     - "dynamic" kernel features" (CET_S)
> >     - "independent" kernel features (XFEATURE_LBR)
> > */
> > fpu_kernel_cfg.max_features;
> > 
> > /*
> >     all known and CPU supported user and supervisor features except
> >      - "dynamic" kernel features" (CET_S)
> >      - "independent" kernel features (arch LBRs)
> >      - "dynamic" userspace features (AMX state)
> > */
> > fpu_kernel_cfg.default_features;
> > 
> > 
> > // size of compacted buffer with 'fpu_kernel_cfg.max_features'
> > fpu_kernel_cfg.max_size;
> > 
> > 
> > // size of compacted buffer with 'fpu_kernel_cfg.default_features'
> > fpu_kernel_cfg.default_size;
> > 
> > 
> > USER FPU CONFIG
> > 
> > /*
> >     all known and CPU supported user features
> > */
> > fpu_user_cfg.max_features;
> > 
> > /*
> >     all known and CPU supported user features except
> >     - "dynamic" userspace features (AMX state)
> > */
> > fpu_user_cfg.default_features;
> > 
> > // size of non compacted buffer with 'fpu_user_cfg.max_features'
> > fpu_user_cfg.max_size;
> > 
> > // size of non compacted buffer with 'fpu_user_cfg.default_features'
> > fpu_user_cfg.default_size;
> > 
> > 
> > GUEST FPU CONFIG
> > /*
> >     all known and CPU supported user and supervisor features except
> >     - "independent" kernel features (XFEATURE_LBR)
> > */
> > fpu_guest_cfg.max_features;
> > 
> > /*
> >     all known and CPU supported user and supervisor features except
> >      - "independent" kernel features (arch LBRs)
> >      - "dynamic" userspace features (AMX state)
> > */
> > fpu_guest_cfg.default_features;
> > 
> > // size of compacted buffer with 'fpu_guest_cfg.max_features'
> > fpu_guest_cfg.max_size;
> > 
> > // size of compacted buffer with 'fpu_guest_cfg.default_features'
> > fpu_guest_cfg.default_size;
> 
> Good suggestion! Thanks!
> how about adding them in patch 5 to make the summaries manifested?

I don't know if we want to add these comments to the source - I made them
up for myself/you to understand the subtle differences between each of these variables.

There is some documentation on the struct fields, it is reasonable, but
I do think that it will help a lot to add documentation to each of
fpu_kernel_cfg, fpu_user_cfg and fpu_guest_cfg.


> 
> > ---
> > 
> > 
> > So in essence, guest FPU config is guest kernel fpu config and that is why
> > 'fpu_user_cfg.default_size' had to be used above.
> > 
> > How about that we have fpu_guest_kernel_config and fpu_guest_user_config instead
> > to make the whole horrible thing maybe even more complicated but at least a bit more orthogonal?
> 
> I think it becomes necessary when there were more guest user/kernel xfeaures requiring
> special handling like CET-S MSRs, then it looks much reasonable to split guest config into two,
> but now we only have one single outstanding xfeature for guest. IMHO, existing definitions still
> work with a few comments.

It's all up to you to decide. The thing is one big mess, IMHO no comment can really make it understandable
without hours of research.

However as usual, the more comments the better, comments do help.

Best regards,
	Maxim Levitsky


> 
> But I really like your ideas of making things clean and tidy :-)
> 
> 





