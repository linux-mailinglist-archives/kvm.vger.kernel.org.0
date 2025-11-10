Return-Path: <kvm+bounces-62582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BD76C4924A
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 20:52:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B4A024EFD9D
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE4233BBAE;
	Mon, 10 Nov 2025 19:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DevGFHpO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="l66d7Q1X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C534336EFD
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 19:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762804321; cv=none; b=Xg/ZogQp64yYuAAFKCCvu5nlDweKhKXluZMqe61LalIUXYfs/f7rTdOLLtGfe/jujoa5CevInph64Bgb6IDDYZF+BaPKAaAyHwCr07DIJOXARwiawPonxiF3lDZITIAzNlWlHe/x/VEL1W8kXyDkJOLkbaFNP3WZ1GI2zXM7Qw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762804321; c=relaxed/simple;
	bh=aoC2utTJwCUGEjJiP6CZ2j2SuRLZRy/+Uv19Xl807oM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ovsSkeMcEkoAXgaPN6BsaqEFrac8iLBpqAkzfQ9v+11uO/lCYncIupfZpSt4Y55jdzP4PMku6b2MY9SQc/9VDTys0X5n8Q8yDQh5hvpCPtm3JhUznGIuLVBnh+OPVwWF+UzpAw58zzjp73d6nvRcntNzJG/deq7RioP0WOGjPR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DevGFHpO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=l66d7Q1X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762804318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QV8pBGmF5Reuzr2/NTuA4sNiIBNilUjt+OvsGF5XnBk=;
	b=DevGFHpOW6OHvuuhhYCo5DCVjvG6KK7jAhfoBiHPFQHIPNF5yrFpI/TkZenyByNRyQPnoA
	PFXdwkn/rwjcFE/1ZgtGQnj1MGFpCXbftioA02ZIc6P9HStdMZ/6ClLXhG0PX9i2TXhSI7
	FNjKNVyWQ+vDkkZ2C2ujBh3XCH3JzmA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-ZG7-MO08MNiNufI721jgEA-1; Mon, 10 Nov 2025 14:51:55 -0500
X-MC-Unique: ZG7-MO08MNiNufI721jgEA-1
X-Mimecast-MFC-AGG-ID: ZG7-MO08MNiNufI721jgEA_1762804315
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-88050bdc2abso110795306d6.2
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 11:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762804315; x=1763409115; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QV8pBGmF5Reuzr2/NTuA4sNiIBNilUjt+OvsGF5XnBk=;
        b=l66d7Q1XWhkgmao/1wX4HLxTSy8RMelsGvylAh6qgvJh5n0nngK0j8AhxpCSzQIh5S
         krKRPiVgT48lyvWx8U8VhNlU9qLpanyJNcnMD2/spA5NCNXJhzKnjg5c0flJ1Ksgsc+O
         bXPuEdIt2U1TQ4pTIYxv2Qf72yQP5/H68n7CGHhVciuhcEZ3UhzAS8M0zmtvU6Z+GDPc
         lsZAiae3lvsMP0XipfzjFZGHTU5p/B+9DkCgkQtP5yW4uSdVjRbXkjbUQPU4cRhsJa4l
         4XK0U9sve+3RDNZKC/xMIMU/7hrenkiZJxzLSjpKBhs9jojVqxksekBIehssAGOw4kOZ
         9kkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762804315; x=1763409115;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QV8pBGmF5Reuzr2/NTuA4sNiIBNilUjt+OvsGF5XnBk=;
        b=vnUqmcx02x9r32p/nOg6asbjsGc+i+H5Abo776vB4GoW2zitO7tl3r2Nk1gIlmDzbi
         jxUR7CSfepAbvLhHB+2NQWSPj1VRMmlcJ3/U5GGWNU5Ubsx6hjm80Kj6CZw+M0guQ38t
         5Pja3iqydl/KFEDXYoVKkBSpMU2q7fwbA7A+6/GaeZIL/hQhhp+0yKoqhfQ4QzU34dKj
         EiK4lBrgosBgJFS8wBttii/sUiLGA+EjoPE39e7AzLM+X9eDJYlqNkh+vBe4LQyj01U0
         EhLu+4p5GBJi1fIPvPByoJ/zbKEDiMaQ8Ess3Jsuge4igNQ+oIiP9DnrwclhVnYX+eCd
         Ncxg==
X-Gm-Message-State: AOJu0YwqIAn4ItIcJUVO42Q63EZXTQJZ52wJC2HfSg3QPlqdqX9rZwge
	Di7PSdT9TnKlQjnMEV6g6WF8HBH9j7XvGrWgMe147HWB1UYwdIOKLNaz3nJljJh8JLFZye4i+8n
	UfVE4buY+8AgTXQljcHo6VTDEm3mpOUgEGWGhJp5H5r3/66aTE96De8kCdnzvsDhe6NY2XkhuH2
	9Y77w+ApXo6qzzQfJ7+P3L22ILEr3fAvVl8LnvWQ==
X-Gm-Gg: ASbGncvtI8hkK9g3gmsSVp8lH8568vqGkfkyZt97sTQY4YbANItAHeYdAKSZCl3IUGF
	ODGe2iNFxJYwQVmhByOSAmzbGCFsSSP0SGHaCuNz8ldy2nSD1bvv3jf+eGi3ocVy4zKQUjeEXzt
	vy9UuQSxtzaMOEWC7j4xJ9IzI89Gzl6CU9Cg1bzthxG8nGOG7WLLhkcc0MHmXjSUHy3lU+cejQQ
	+2P8EQHcGg7Dh9U7ccQmzBi+ABVBVZUDRViatOlXeIxgCzAknMTuDttamJsvqnNSQgDL/bITB2m
	HVxsm2t9keTnkYdrfJLAFcGNcsLGldCrfv0iTrsNCZBw+4I7cdhmtsWPalDCmHklxZXbYVQtXQi
	DR4yCCtMBUUdwPN3cqMLCl1vHG7p/Lwk2E/0fX0RY2Lteug==
X-Received: by 2002:ad4:5ecb:0:b0:880:51b1:398e with SMTP id 6a1803df08f44-882385dd970mr124039816d6.15.1762804314814;
        Mon, 10 Nov 2025 11:51:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFrXHCXEXvbmNM94Vg1gk183ZYWbHHs6Is3l2SHW63rEef8WO8g6B8KUQukeI7YKkJk3wXeSg==
X-Received: by 2002:ad4:5ecb:0:b0:880:51b1:398e with SMTP id 6a1803df08f44-882385dd970mr124039396d6.15.1762804314343;
        Mon, 10 Nov 2025 11:51:54 -0800 (PST)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88238b4c3c0sm57039506d6.33.2025.11.10.11.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 11:51:54 -0800 (PST)
Message-ID: <2eae45e037c938785b9e36d0f5265becca953d9f.camel@redhat.com>
Subject: Re: Question: 'pmu' kvm unit test fails when run nested with NMI
 watchdog on the host
From: mlevitsk@redhat.com
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
Date: Mon, 10 Nov 2025 14:51:53 -0500
In-Reply-To: <10d3f95717b7072e30576b7e3931ea277399fdf8.camel@redhat.com>
References: <10d3f95717b7072e30576b7e3931ea277399fdf8.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-11-05 at 15:29 -0500, mlevitsk@redhat.com wrote:
> Hi,
>=20
> I have a small, a bit philosophical question about the pmu kvm unit test:
>=20
> One of the subtests of this test, tests all GP counters at once, and it d=
epends on the NMI watchdog being disabled,
> because it occupies one GP counter.
>=20
> This works fine, except when this test is run nested. In this case, assum=
ing that the host has the NMI watchdog enabled,
> the L1 still can=E2=80=99t use all counters and has no way of working thi=
s around.
>=20
> Since AFAIK the current long term direction is vPMU, which is especially =
designed to address those kinds of issues,
> I am not sure it is worthy to attempt to fix this at L0 level (by reducin=
g the number of counters that the guest can see for example,
> which also won=E2=80=99t always fix the issue, since there could be more =
perf users on the host, and NMI watchdog can also
> get dynamically enabled and disabled).
>=20
> My question is: Since the test fails and since it interferes with CI, doe=
s it make sense to add a workaround to the test,
> by making it use 1 counter less if run nested?=20
>=20
> As a bonus the test can also check the NMI watchdog state and also reduce=
 the number of tested counters instead of being skipped,
> improving coverage.
>=20
> Does all this make sense? If not, what about making the =E2=80=98all_coun=
ters=E2=80=99 testcase optional (only print a warning) in case the test is =
run nested?
>=20
> Best regards,
> 	Maxim Levitsky
>=20

Kind ping on this question.

Best regards,
	Maxim Levitsky


