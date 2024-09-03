Return-Path: <kvm+bounces-25770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8D8A96A421
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 18:20:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2774E1C23FED
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 16:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A33A618BBA0;
	Tue,  3 Sep 2024 16:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YDEpuqsv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690B14CB2B
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 16:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725380433; cv=none; b=ggYmjC6Cflh9SOBUXWtdSfU+EBcqNa/3weY6XvKqib/JQuh5xSqIadnlz2eb39Nga9soYAjKPmzOHc8d9ReVKckVcGEFZLeSlxhLNvkSvsvKbWcXNMed2Xnrlc4fWT1hpnhCR6Kac69BTL9sOYEKy6uDla2eP5A+3WJnXe2A0Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725380433; c=relaxed/simple;
	bh=OAPXgA26vcCvFh11octbJS1kd1LOYAh0ZLkW8SJrsuA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Lh7JYQRMfXyI8IIb9ncgE/Kg1/is43sCFKlUEhVLj+iR017I31JRPnBZi+wRcnf7zknujpDEyIlrDOTcTubbE7UoxOA42+Gs/GGJbYP4crICz+EVxwyBl8sXHoCYSSA4uSXn6OjmNIUZOibm9SpS4SSZeebKp3QR5xoY4fXKWf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YDEpuqsv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725380431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XdmA5Tid/74wv02V6AnoSmfNmJjNITfTGTTXlL20Rx4=;
	b=YDEpuqsvhzdT1cWKo5UDkiLqKXKh22eEE9koU0zFsIY9eLjzRggk3t42tU3qYhmBK1IDu/
	0N30WyCr/Y6C3KDMr1ynI/87XEPDWnhUDszgGotqt2Y6uF9VsdAPIexroUq646dzlB8nSW
	gk+iVYRF9wPvsGNeBrUlXYhVDjbL6Cc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-BTSre7AEO8WBkr-StGqqpQ-1; Tue, 03 Sep 2024 12:20:30 -0400
X-MC-Unique: BTSre7AEO8WBkr-StGqqpQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42c7a5563cfso4282195e9.2
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 09:20:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725380429; x=1725985229;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XdmA5Tid/74wv02V6AnoSmfNmJjNITfTGTTXlL20Rx4=;
        b=aSPgbygwaoRD6GlPeXsYWKUw9IxILGkOXYzce6b9SLucwcbytUsuizpPFjPkxhY2LL
         UnbH1vUUOdUbF4PnJg125z60LfcXuuObZfk78LLH7tu1er7RR5b9J9YqKVWO/r2V01vW
         VYmBgDvXrBOWeFYQ5dO4hsAYG097Hgo/fBSW168EOmzYZ1lP3F1nhkuiYUlQDBlxZMcI
         Gzj8WLmqpIaEN+tvyV9F3pihHTClaHCP7dSZFRizq4F4gFm0lkMPnTFJYIq88D1H4AL8
         DA9cc+wyltyb6L1Ut6OtomYn9qZY2wMZf7sADkUKQ1Jm4g1CJUoQtqz0uvUwApHIQBto
         WctQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUOnlsWMaOdQM3Wsa5sKwk/rq7FnpOSWZN8IbVkS0OVjxG27nBN2KuYrQIlI4fhs9NDqA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA55wFFIz9GU6MEBcG6nM6ZocnGLvPBEejT4IpismQt4xAsNCs
	/wzpk8Ubfa1ywBqFy1+2OGHRVzLHIdn1rTm4BvOlSwmgShn6+x4f76SStJYFgZTMEftxKiX8j3J
	sfBNSa1cqPQZzqcnlb/cYs9tjwW6hG07B76OD7gkTB22tO69JPg==
X-Received: by 2002:a05:600c:154a:b0:428:1b0d:8657 with SMTP id 5b1f17b1804b1-42bb01c1136mr133191375e9.22.1725380428997;
        Tue, 03 Sep 2024 09:20:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFt969PrCDn6htrQ/H40UrhQS7X/fYPo/AjcJYavG+h5+5YVtDQLDh+BGH5pAZgb9g0m3LBUw==
X-Received: by 2002:a05:600c:154a:b0:428:1b0d:8657 with SMTP id 5b1f17b1804b1-42bb01c1136mr133191155e9.22.1725380428491;
        Tue, 03 Sep 2024 09:20:28 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bbef54b23sm141833145e9.44.2024.09.03.09.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 09:20:27 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 rcu@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian
 <kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>, Lai Jiangshan
 <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, Josh
 Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
In-Reply-To: <Ztcrs2U8RrI3PCzM@google.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com> <877cbyuzdn.fsf@redhat.com>
 <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
 <871q26unq8.fsf@redhat.com> <ZtUYZE6t3COCwvg0@yzhao56-desk.sh.intel.com>
 <87jzfutmfc.fsf@redhat.com> <Ztcrs2U8RrI3PCzM@google.com>
Date: Tue, 03 Sep 2024 18:20:27 +0200
Message-ID: <87frqgu2t0.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Sep 02, 2024, Vitaly Kuznetsov wrote:
>> FWIW, I use QEMU-9.0 from the same C10S (qemu-kvm-9.0.0-7.el10.x86_64)
>> but I don't think it matters in this case. My CPU is "Intel(R) Xeon(R)
>> Silver 4410Y".
>
> Has this been reproduced on any other hardware besides SPR?  I.e. did we stumble
> on another hardware issue?

Very possible, as according to Yan Zhao this doesn't reproduce on at
least "Coffee Lake-S". Let me try to grab some random hardware around
and I'll be back with my observations.

-- 
Vitaly


