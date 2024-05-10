Return-Path: <kvm+bounces-17184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 721568C2665
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 16:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2DD91C21EEF
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 14:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA3B172BB1;
	Fri, 10 May 2024 14:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gOcPuPlZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E78172790
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 14:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715350035; cv=none; b=O+YU2j63oIS138juMY+p7jzmP46URg7Kan6wTKgmiMDzxzYxNZdzeCZ6DRERjVQWrwx04e3ty0mudq+oNhrYpD0VSgYMnjugoqsjdZZf2zQTFOnsZY85IlPZ/AE4rCC2geyLfs2PcOZh0ayZoW91rq+kdJZVOyokF4EYYwcCfxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715350035; c=relaxed/simple;
	bh=CIb9re05hOwtASAGaBhr5D9oxM0cSwxJ6I2jaSlRch8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jel3lWqrKD5ovYI0HoIHoXrrD4azguZ+hskegirLTcXB/4u8dwZxlaTwwMsUzTOhd8b9G9IV6v/9NI1ZtDVZIi3fwsRZoI08BuSntAbyxqSKlSZkbtDniaAC5zRe+vPBXNtXz2Aa8QbC1xqSo8WOoOYpiuyzIvWKDO/sWzpMgo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gOcPuPlZ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1eea09ec7ecso20153755ad.2
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 07:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715350033; x=1715954833; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GkZxGT0ZfdKB+GEeESf4UtQYxmmTquZLaDxSfhLR3LM=;
        b=gOcPuPlZPoc1rISquCUDrqpuaujYZPHdQ7/E0qPWTtVmRJwwFLK7wEAgIf9ogBlsYL
         yrDg9iQ89Zlibg88MjGc8uSaqdjXhjz3tfNnhIaPSD+p7qB/VmRaOf7ZoI5DDLpRcTAw
         sSWEIqlKnFrf3v89ihFOGbs6n8HdanK7qG4sZiYmfPBTz6Il1sDt7hJrb+oAGWGCh9wJ
         PdHKBrU7EHYw0c07GUsA7x1rFZv/7GDTR+lYUCAPoti2iE9U5o1Vxv3m0M4UaGlKlWmz
         sNvwhHxZlpM9lBcgLrgeXfWyVuO0pHWJ0JW47wnSBI3X5tZpLKPTEoUtQHV62U1wPeey
         tl0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715350033; x=1715954833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GkZxGT0ZfdKB+GEeESf4UtQYxmmTquZLaDxSfhLR3LM=;
        b=GtNNk5DUUzDdloLiQetiG4jVt6aXONJ39+OzpM5qXZevhmlCdXzwHXOmq5EoxuXNj/
         U367pIegjP/VQ2t3dcS7Vr8lLHMY/8VTOEyvivFQKr9aoV0L/P9qR6OtfnfBYJiCFV3a
         DFNAZ6oghPmB6zHHxgK+szbv1XeUp/GzO9fIJidcKooLHbKX0TDVlrY5amWExIET7CAx
         Jt428GGyOHqASHPGEVLpvSHkCKjiPCRd0Gy49nAppXOcnKc2pRiq6Ooh/ur6i6beaq6X
         OUcULTRGaw9zjbu8t0nbm4KvOE/uqUnPpbnGrdO5g3cjKhS9CDv47vYye2A8DRjcJFa+
         RQLA==
X-Forwarded-Encrypted: i=1; AJvYcCXJfmQk3nD/mlHKkBeaEmQQuXCG8q76QE8+JyNUB/saQGo0F5Tv5qeiI8UCQTH3y4uOWIALvZIytxrOsPunyoE/IXGa
X-Gm-Message-State: AOJu0YyQheN+WNTIp+ucukjh9f2Czj2exQBu5mGxQH/dQ1c4PRER3ao0
	vrfdiLYrVRfp3j/Zoj9+/6BHL/Bvitt1+ijiWLOP/Vc703xhTni9GSWgu2pqGezlakrDIaeCvjY
	Ncw==
X-Google-Smtp-Source: AGHT+IH4Q71+QxPOqLwbE6nijnCgcIFRpwsBtSv+JFROxUNDyXFy49HhYX44+CC8Z7tY2rLekiRM4+Mqsuo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce90:b0:1e8:d157:2329 with SMTP id
 d9443c01a7336-1ef43f4e4b7mr78265ad.9.1715350033435; Fri, 10 May 2024 07:07:13
 -0700 (PDT)
Date: Fri, 10 May 2024 07:07:12 -0700
In-Reply-To: <20240510111822405PCAy6fW8F_-AfMPoCfT8u@zte.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Zjzkzu3gVUQt8gJG@google.com> <20240510111822405PCAy6fW8F_-AfMPoCfT8u@zte.com.cn>
Message-ID: <Zj4qEG5QfbX4mo48@google.com>
Subject: Re: [PATCH] KVM: introduce vm's max_halt_poll_ns to debugfs
From: Sean Christopherson <seanjc@google.com>
To: cheng.lin130@zte.com.cn
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jiang.yong5@zte.com.cn, wang.liang82@zte.com.cn, jiang.xuexin@zte.com.cn
Content-Type: text/plain; charset="us-ascii"

On Fri, May 10, 2024, cheng.lin130@zte.com.cn wrote:
> > > > From: seanjc <seanjc@google.com>
> > > > > From: Cheng Lin <cheng.lin130@zte.com.cn>
> > > > >
> > > > > Introduce vm's max_halt_poll_ns and override_halt_poll_ns to
> > > > > debugfs. Provide a way to check and modify them.
> > > > Why?
> > > If a vm's max_halt_poll_ns has been set using KVM_CAP_HALT_POLL,
> > > the module parameter kvm.halt_poll.ns will no longer indicate the maximum
> > > halt pooling interval for that vm. After introducing these two attributes into
> > > debugfs, it can be used to check whether the individual configuration of the
> > > vm is enabled and the working value.
> > But why is max_halt_poll_ns special enough to warrant debugfs entries?  There is
> > a _lot_ of state in KVM that is configurable per-VM, it simply isn't feasible to
> > dump everything into debugfs.
> If we want to provide a directly modification interface under /sys for per-vm
> max_halt_poll_ns, like module parameter /sys/module/kvm/parameters/halt_poll_ns,
> using debugfs may be worth.

Yes, but _why_?  I know _what_ a debugs knob allows, but you have yet to explain
why this

General speaking, functionality of any kind should not be routed through debugfs,
it really is meant for debug.  E.g. it's typically root-only, is not guaranteed
to exist, its population is best-effort, etc.

> Further, if the override_halt_poll_ns under debugfs is set to be writable, it can even
> achieve the setting of per-vm max_halt_poll_ns, as the KVM_CAP_HALL_POLL interface
> does.
> > I do think it would be reasonable to capture the max allowed polling time in
> > the existing tracepoint though, e.g.
> Yes, I agree it. 
> It is sufficient to get per-vm max_halt_poll_ns through tracepoint if KVP_CAP_HALL_POLL
> is used as the unique setting interface.
> 
> Do you consider it is worth to provide a setting interface other than KVP_CAP_HALL_POLL?

