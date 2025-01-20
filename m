Return-Path: <kvm+bounces-36072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15315A173A0
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 21:34:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D62916B06F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 20:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54CD01EF0B8;
	Mon, 20 Jan 2025 20:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IbqWVoJE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF4F1E9900
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 20:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737405279; cv=none; b=toV0kCI6gtmoIUjXh/nxU7S21YvE8egp6OVfu1vPRCfRG0dMQEvBqcHVdmeegJEMof0u76uxkxDbWCB5FmCj8Iu4gDGWQCJKZSNYK+Z/wLGU7FSC/085kEKVukElUKy4cg+qgEqRAqyGqmgRt4uotMKPKNSe+N3Cj0TetqOJF+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737405279; c=relaxed/simple;
	bh=OFOJaoOKsrGz3gOvyi1JobwerKEkpS1+UhE+6XDb1NQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DgVN1CSoQU8QXIVk+HCsYwsGqhpZHe0eGN09LF1qufo1ZsH7jdCxK4QV9esatKnxyrETPXeUS+P3csxiB/IcxJ+ombtTvisx9C7Oq0CfuWVdgZxNeT4MsO7ibI0sv06xB6egrVJNY/dAxGh5xfrSNaafMVnLNkv/wKN8jYH0+sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IbqWVoJE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737405276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/RHjUfwmCvBKXS2UvOCBF3DKXMyuVzwXscGRbef9ILg=;
	b=IbqWVoJEWQGD1SoT+5/9w2EHQDZKm/HTgK+hRvo6ccqxOnD2aohVinxusvRkLmSHRawh/3
	R5uY3rPuXEeFqZUsD9MyEhFs1V5nZU5WQAB0Juy9QGOdVGBjvDrRyHQyqkWr8+7DqrpD0/
	1kyTy5MAnB1Ys8ll1pnnkVE2lnoX43g=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-HlsGVvJ8OmCdHbItmbyiug-1; Mon, 20 Jan 2025 15:34:35 -0500
X-MC-Unique: HlsGVvJ8OmCdHbItmbyiug-1
X-Mimecast-MFC-AGG-ID: HlsGVvJ8OmCdHbItmbyiug
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7b7477f005eso1135273985a.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 12:34:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737405275; x=1738010075;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/RHjUfwmCvBKXS2UvOCBF3DKXMyuVzwXscGRbef9ILg=;
        b=A8leDbbfy7OMRKETPI1VgDI4YTcdKlDmfCNMSoMxR81TY3bw7KV8jXlEh8wy+rNU+S
         N50EEw6xsY6QHAjiKHW7GKFXJgtxTAFcsLbEXb8STxzGHb5epGyBf100lPF/xqviYP9F
         qMqYPtGwdM/2nhr2O5Jv9Ur7r0DJYIyjl1OGph1di90ltrfjGo4uCbGByys/Yzst0Ix4
         iExKfXlRSE0cw4nEae1FKychIOrz0kmofI1i3YNY72P1z4s6QF3oKlAPb6TViymN1BaG
         NZwYuosh3HP+vWYlornvpEffRozNQ5f/ROZ3HNPNYFTIe7dAIryyeP4Fzh/KPunl/Fik
         fxzQ==
X-Gm-Message-State: AOJu0Yzf4kxOXr2MXds2zfJe0Kb/hHiwfIMWsY014VJ14UUjgq9A6NJc
	vBCp/wJmYi4raxZtsQWONoRGfgia5hBh33ywc7TSGaW4ABdzdYVqVK/yhKpMaSan/1P5dl0KmBu
	OQKJemFTnIbl9GtLqEFVCeQSc+ejEhY6ZSIuVLMpEd2ZNmExR+Q==
X-Gm-Gg: ASbGncvNcF9bNVOGYucb8koHerDNXIzSL2JcZ5De+gig8YEffHrE8WQoGAqPy/unZDY
	gx2lc3y89q9w0anEX1NwduT60z6uPQEJaRq2pzwURk9D95k5eHm6dqi/1iL3YppgZ8RAlvHVGuM
	W7ahjf6AxQ+rZkFwZlZI0G6x1AsUi6XpBAzDVcw3Ta533hXp9gIuZz0feyaUhxUsFfFJr2PYe2t
	QIB6eck0uF8RYCCnJOY1miCtKJ444MfSgx6biATTsV1BjH0SLJs4PdnAaKMs88dn2SHcg==
X-Received: by 2002:a05:620a:44c4:b0:7b1:52a9:ae1d with SMTP id af79cd13be357-7be631e5789mr2639891585a.6.1737405274897;
        Mon, 20 Jan 2025 12:34:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGS8PsgoXeVcEsGYNIKKCi8ACTs7vnBJLtP7ao6C9/luJJa01LBg2l1wcdbDBKQZ4HIL/WcaQ==
X-Received: by 2002:a05:620a:44c4:b0:7b1:52a9:ae1d with SMTP id af79cd13be357-7be631e5789mr2639888685a.6.1737405274598;
        Mon, 20 Jan 2025 12:34:34 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be614d9949sm484869985a.71.2025.01.20.12.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 12:34:34 -0800 (PST)
Message-ID: <82c011752e777eb77b1c988a5bf1114bc991fc44.camel@redhat.com>
Subject: Re: [PATCH v2 00/20] KVM: selftests: Fixes and cleanups for
 dirty_log_test
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Mon, 20 Jan 2025 15:34:33 -0500
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
References: <20250111003004.1235645-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2025-01-10 at 16:29 -0800, Sean Christopherson wrote:
> Fix a variety of flaws and false failures/passes in dirty_log_test, and
> drop code/behavior that adds complexity while adding little-to-no benefit.
> 
> Lots of details in the changelogs, and a partial list of complaints[1] in
> Maxim's original thread[2].
> 
> [1] https://lore.kernel.org/all/Z1vR25ylN5m_DRSy@google.com
> [2] https://lore.kernel.org/all/20241211193706.469817-1-mlevitsk@redhat.com
> 
> v2:
>  - Collect reviews. [Maxim]
>  - Expand a few changelogs to be more explicit about the effects. [Maxim]
>  - Print the number of writes from each iteration. [Maxim]
>  - Fix goofs in the last patch (stale message and changelog). [Maxim]
> 
> v1: https://lore.kernel.org/all/20241214010721.2356923-1-seanjc@google.com
> 
> Maxim Levitsky (2):
>   KVM: selftests: Support multiple write retires in dirty_log_test
>   KVM: selftests: Limit dirty_log_test's s390x workaround to s390x
> 
> Sean Christopherson (18):
>   KVM: selftests: Sync dirty_log_test iteration to guest *before*
>     resuming
>   KVM: selftests: Drop signal/kick from dirty ring testcase
>   KVM: selftests: Drop stale srandom() initialization from
>     dirty_log_test
>   KVM: selftests: Precisely track number of dirty/clear pages for each
>     iteration
>   KVM: selftests: Read per-page value into local var when verifying
>     dirty_log_test
>   KVM: selftests: Continuously reap dirty ring while vCPU is running
>   KVM: selftests: Honor "stop" request in dirty ring test
>   KVM: selftests: Keep dirty_log_test vCPU in guest until it needs to
>     stop
>   KVM: selftests: Post to sem_vcpu_stop if and only if vcpu_stop is true
>   KVM: selftests: Use continue to handle all "pass" scenarios in
>     dirty_log_test
>   KVM: selftests: Print (previous) last_page on dirty page value
>     mismatch
>   KVM: selftests: Collect *all* dirty entries in each dirty_log_test
>     iteration
>   KVM: sefltests: Verify value of dirty_log_test last page isn't bogus
>   KVM: selftests: Ensure guest writes min number of pages in
>     dirty_log_test
>   KVM: selftests: Tighten checks around prev iter's last dirty page in
>     ring
>   KVM: selftests: Set per-iteration variables at the start of each
>     iteration
>   KVM: selftests: Fix an off-by-one in the number of dirty_log_test
>     iterations
>   KVM: selftests: Allow running a single iteration of dirty_log_test
> 
>  tools/testing/selftests/kvm/dirty_log_test.c | 521 +++++++++----------
>  1 file changed, 246 insertions(+), 275 deletions(-)
> 
> 
> base-commit: 10485c4bc3caad3e93a6a4e99003e8ffffcd826a

I don't think I have any major objections to this patch series.

Best regards,
	Maxim Levitsky


