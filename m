Return-Path: <kvm+bounces-37278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B871DA27C9E
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 21:16:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D6001885F01
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 20:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2B92185BC;
	Tue,  4 Feb 2025 20:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LJ8Tw4oz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3684F204589
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 20:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738700172; cv=none; b=uoiBq30vB9xXDGUox7ODE49Ei8Rkh+LGhj1j4c6wJriDIvORnhPlhV/binqeJh2LJdPbC8Zv83e/ccBf2PG4oGKUzyMBev74ZWmLRjyIEbMQU3yCtsgdz/GaVzUf/v5DzR3urK+d7X6vjOZYxMHHJWEIEbuCdOV1UoGuVFMmUSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738700172; c=relaxed/simple;
	bh=GzHA0oHa+D7e4Z5Mm/+5adIZNVJMjwdQnbGlQb8uqI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MbOHUSkDnx0YCYWOWsc6kZYwKBEwVRxseCLPFszuvtBBuSV4GkDwCv97ijnNncRR30OKY0Bx50Ne2CNfBM760vVm+INK4fnsiGkSy1s4/98FNDM2rmC+lKjtkLbygtfH2yXMD+ELFFOKpschrdywLThfZZm0Muy5bCkGop0VCHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LJ8Tw4oz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738700168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ky672YTQmjWMGag8fy+m246n/AOyR1jpDryCCQwPAUo=;
	b=LJ8Tw4ozFMirxMyzcJV8Quji1X4n0e2PI9H4t7iYcfFlX1pvy0EvkB3dwNI18E0oXRbAY4
	5i1onZLPspkVSPeFsAGFf+yXbMxBSfuYMx2g31XP6kWB0sry8RRgUaiw0MwJGsBtNXs7z2
	sP8O2BM9H+Pw+I8+ecjCDI/odFYDXKU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-vzHgczqlMBCC5VG-fn36TA-1; Tue, 04 Feb 2025 15:16:07 -0500
X-MC-Unique: vzHgczqlMBCC5VG-fn36TA-1
X-Mimecast-MFC-AGG-ID: vzHgczqlMBCC5VG-fn36TA
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-468f6f2f57aso68619561cf.0
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 12:16:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738700166; x=1739304966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ky672YTQmjWMGag8fy+m246n/AOyR1jpDryCCQwPAUo=;
        b=MKfmLIX9bhWROBzpaaOOwOKK5Y9uicT+uc8ATBnwJ/IQYRFGU3K2sZILMp77ics0vI
         kAzgqAi/tZEYzyaVxv76CKiJzljUHsTC1Fbu5p/IPRnqJkhgOWbpjES9v6NwwgpOrgSK
         NFw07BnvNt/v+P3ln2PX/aG4LvRZ0ONovhwIRJ7BHc+A9UoV4Yx2CEPEJmkaBvw2lSM1
         +Y8T+2O4K7auYfOPbTkfYxZW/nu/c17lzClVoj+l0A7CqWR2f5WSUs+DG2JMfOBknIpB
         44X6+57RKEEVygLFiSkOgphKJ9L9aEfRs1gtMKmyvj1swDYDlTXEy16Ri/bgLu0CRYYR
         uEfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcPhs4hI153cp4M39bWHqJ3Ie3m2APPf2RZMXQNFMqUVNUcyGriHP1rDzJUgE0aH6OUhE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+IoqMKgNPJeTq/Y4JmOgfbpwWHxsEscxX2j0yir/LGDd7ld2G
	aQDCkR04Lv2I5lw0YI4xy0TXSGrLHl4VPehaC6ARpuylWgHDJFH59sddcR7uvKGUhAcnDXk7PRE
	V8UaedfbZYLWnD3WXPd0MMbMDsNhpEnSC+CG/qImKEtyr9P+FTBkMQbz0NQ==
X-Gm-Gg: ASbGncu1wRxrN+iDxwTi66WQjiTqY1CbXqMzDF86Vaa6urNML5aGCkL1Kgj+1yG3SjL
	/OxWMcJjovpwLSPZdpthWCFyqaJzmPAwwAJ2CP0Hltb+9mVdXc5b0dnXUSocl/752uhovtaLDrD
	qON5kn3QYlEjYVTHvd9Hq9AtZwC/x7y8tZSixwqub139ndG3hdnZxFXpltObtgDU2b/an+68S7H
	9iWrb1oUIdaWj5xixzQGSkikXtFtSWR3ltig2uCxwpQkFvCU/P45bYXrf9U4GZy/HDqBpFg4tv7
	T+xYaSR/QYYAPLkLfCxhJW77uNTTKDAgxOkMK0AMIxMz5dyQ
X-Received: by 2002:a05:6214:20c6:b0:6e1:6e74:7ad3 with SMTP id 6a1803df08f44-6e42fc02175mr1754196d6.22.1738700166339;
        Tue, 04 Feb 2025 12:16:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHOlF+mI/vvTUe/iYN0gk7LNwIXaBahqPZM+/F5HxL9HHkmy4JCWyJcAFN+Od6Rxf0D90gNbQ==
X-Received: by 2002:a05:6214:20c6:b0:6e1:6e74:7ad3 with SMTP id 6a1803df08f44-6e42fc02175mr1753906d6.22.1738700166053;
        Tue, 04 Feb 2025 12:16:06 -0800 (PST)
Received: from x1.local (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e254819cf5sm65353956d6.49.2025.02.04.12.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 12:16:05 -0800 (PST)
Date: Tue, 4 Feb 2025 15:16:04 -0500
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: =?utf-8?Q?=E2=80=9CWilliam?= Roche <william.roche@oracle.com>,
	kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
	pbonzini@redhat.com, richard.henderson@linaro.org,
	philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
	imammedo@redhat.com, eduardo@habkost.net,
	marcel.apfelbaum@gmail.com, wangyanan55@huawei.com,
	zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: Re: [PATCH v7 6/6] hostmem: Handle remapping of RAM
Message-ID: <Z6J1hFuAvpA78Ram@x1.local>
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-7-william.roche@oracle.com>
 <7a899f00-833e-4472-abc5-b2b9173eb133@redhat.com>
 <Z6JVQYDXI2h8Krph@x1.local>
 <a6f08213-e4a3-41af-9625-a88417a9d527@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a6f08213-e4a3-41af-9625-a88417a9d527@redhat.com>

On Tue, Feb 04, 2025 at 07:55:52PM +0100, David Hildenbrand wrote:
> Ah, and now I remember where these 3 patches originate from: virtio-mem
> handling.
> 
> For virtio-mem I want to register also a remap handler, for example, to
> perform the custom preallocation handling.
> 
> So there will be at least two instances getting notified (memory backend,
> virtio-mem), and the per-ramblock one would have only allowed to trigger one
> (at least with a simple callback as we have today for ->resize).

I see, we can put something into commit log with such on decisions, then
we'll remember.

Said that, this still sounds like a per-ramblock thing, so instead of one
hook function we can also have per-ramblock notifier lists.

But I agree the perf issue isn't some immediate concern, so I'll leave that
to you and William.  If so I think we should discuss that in the commit log
too, so we decide to not care about perf until necessary (or we just make
it per-ramblock..).

Thanks,

-- 
Peter Xu


