Return-Path: <kvm+bounces-36073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D151A173BF
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 21:43:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C89E188AA9D
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 20:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74DC1F03C1;
	Mon, 20 Jan 2025 20:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UNFI6zso"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F611E9900
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 20:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737405812; cv=none; b=EB0Y/cTYLKONmFkeoKqB9b6bvmjkDEfti8ui30oc2uh9kYh8iBFrrExMYLrnaYnqjS/i443JOGpCVDOTCjw0cKRJtJAuhEOTRsb7xofAcSIDpjFoezzIjXsjGI13bmsedDPer+zeiuLbhRnx+IXylpG6brBwRbKXnJI6c3hRoqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737405812; c=relaxed/simple;
	bh=U7xQL7IV7lGPBpmfaqhrfwk0fe5A+hs9Ww7eO9EoADs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d5UHRrNUj/srCmuqrNpooOLJpNgyu6DOP8AjkKDeQRUZAjD33/LW2Zt3AuBgUCQrdxvr+jTky3pyGJ5jJ5mr9zQmewa190nmu23NrDXIGbhOb0AdN/MI9x18va1MheUyHQWE5r7oLMGO9HZxh9h72KzNDKGAoN48SMaxGUk4i4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UNFI6zso; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737405808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qEJylaPC9UjGUo5+ufQ7hbk2ePW92RAHA8rV0SRsPDk=;
	b=UNFI6zsopef787loN+jgbu5RJAF38dXv+GD4XFidtxFFOaA9IpnuFK9Cj2oWbAaKp5skdF
	JedyczfxVWAoPqczcryMyiAk/BlIT2DkzUgFvWOgW31Y6X7u4J6H39lYrvdeADpP9AOzbH
	inA5YQMD4vaWVQUiuQ7ZJ8p/ttBW5uQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-Svf0WPglNgOyYQuru1_H8w-1; Mon, 20 Jan 2025 15:43:26 -0500
X-MC-Unique: Svf0WPglNgOyYQuru1_H8w-1
X-Mimecast-MFC-AGG-ID: Svf0WPglNgOyYQuru1_H8w
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-467b5861766so98253591cf.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 12:43:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737405806; x=1738010606;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qEJylaPC9UjGUo5+ufQ7hbk2ePW92RAHA8rV0SRsPDk=;
        b=u+aO+sLhv+BIgdmuL6JXxT/gY+946ZGt6EimBP3CBpY2jp5MqIdmtxRLH9g0a6Zf3g
         dMKet3IcKqXVsRnCqp3Nk0rIhjCuUbDQyCXoxhXxMp3JSNLKGDQSs6Fpo31InArcroQK
         NKeCtaU5x6SBcTkEoKJl+GJSjZ45HM+kDP8E4t+AkxRAuOe/cPXOiMY/pNCLp3jGP6dk
         lQFQeYiRG2FhonCrCZvaUsXM4G+AP//jsfxESAfcgkzcSfs09CgfpolYSpCP4BvzqI+D
         59qIMp9wp4b2hviW4X5Xv+OhN80IA3U2gQBWMxIzSYN+GvCzHqrE5WTR3gSn2tNBCqsX
         P3aA==
X-Forwarded-Encrypted: i=1; AJvYcCUHlNIxUpFF7YLrmwuPVFrUEKZ5JnpLinm35OVgzwk6rV9+skpe/pethJGlYHJ+sbOlAk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjfPehQUfTWC919TU9XaENj9RWfm81LId4h9zkhVqyocn9tMCs
	MJP7o8io20ZxK5uISCxT8asAlpfHDEPguj98uXJQwigcB3PCHXK3XwsEkqGUv2HXm+e8gIrp6yS
	RG50B+EKZBjgDJy2SuvOScDUGm+1F428JNlvv9IddU0fxuIa4ww==
X-Gm-Gg: ASbGncv+l6oIcgMqpaTuC7EbiEx1vY2R2cn6mYEqZv0Fy8ptwb+4rr8XcNhffhmsNHo
	5HP+CWLTLAePmY6ErfRuW40SecZIaobfCyyBisc9lZZmhRVAbPo9gayqGk0hWYnDKOezCR93pRv
	6HUQtCBiaADi+E9b75d5+vAQ5W6tYMAbrvLLFcrhUkvazTbR/J62MY7EVz7bUkzya0nVOyfzhlT
	n0AQGaVP972IDWdAjnMsOhCsaJGnuCM7sBx5gBr4xPuzhtZ3yVyU3GQB44PNxsOZDG8+N5bFP1W
	q69xolwYuZ7k+yR98vONnflDGbRbnUo=
X-Received: by 2002:ac8:5a55:0:b0:467:6692:c18b with SMTP id d75a77b69052e-46e12a25294mr200228091cf.5.1737405806430;
        Mon, 20 Jan 2025 12:43:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE+0kxEQTVD7cvUOES4l7LypBoFpfOst7eFJHArF7ULbk4HIdLxucWSrPdrV9Nh7ijCgKlxzA==
X-Received: by 2002:ac8:5a55:0:b0:467:6692:c18b with SMTP id d75a77b69052e-46e12a25294mr200227851cf.5.1737405806096;
        Mon, 20 Jan 2025 12:43:26 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e102ec4acsm46190671cf.13.2025.01.20.12.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 12:43:25 -0800 (PST)
Date: Mon, 20 Jan 2025 15:43:20 -0500
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z461aGgm_sOqISfE@x1n>
References: <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
 <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
 <f3aaffe7-7045-4288-8675-349115a867ce@redhat.com>
 <Z46GIsAcXJTPQ8yN@x1n>
 <7e60d2d8-9ee9-4e97-8a45-bd35a3b7b2a2@redhat.com>
 <Z46W7Ltk-CWjmCEj@x1n>
 <ba6ea305-fd04-4e88-8bdc-1d6c5dee95f8@redhat.com>
 <Z46vxmZF_aGyjkgp@x1n>
 <b812fd19-055b-4db1-bdff-9263c8b6b087@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b812fd19-055b-4db1-bdff-9263c8b6b087@redhat.com>

On Mon, Jan 20, 2025 at 09:25:51PM +0100, David Hildenbrand wrote:
> Yes, calling it "attributes" popped up during RFC discussion: in theory,
> disacard vs. populated and shared vs. private could co-exist (maybe in the
> future with virtio-mem or something similar).

Yes makes sense. The attribute then can be easily converted into something
like "user_accessible" / ...  Then that can equal to "populated (plugged)
&& shared" ultimately.

-- 
Peter Xu


