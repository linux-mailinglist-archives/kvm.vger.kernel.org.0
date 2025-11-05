Return-Path: <kvm+bounces-62117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 97017C37BB9
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 21:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A00F64E665C
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 20:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E77347BC6;
	Wed,  5 Nov 2025 20:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ehDPKZLj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MDN8oeil"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA231ACEAF
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 20:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762374594; cv=none; b=VArXl9u65bcHceBa5KZEV861VZneeY7QX/02v1CI8FxErZqvUJhv2jB2f4Yd88Fy1RUWf9XwQNfsh9UXsKUjbMbXSUHaMLPl5ruyvz3T0d/NZjjfumV2YjnZTmKLvDmHqCsoj2pNjiPbwPHP2AAbwf2vRRpL3lhzEpZhn0Odceg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762374594; c=relaxed/simple;
	bh=llzVL8WP7FtAoyI6Bw87QxdSaoX5wZyqaF/gUnGjDKs=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=sptCTBbEP1ZnB/SgihBjJgYtGKB/gRgEH3lukYCKRPGRBGW9srLuDVYZ2HDz9dXedQMmUbohucKbiMSSuvkIXKj6vk84IqzN3Kt9se3r9LCwQRSQRgmAkp3Uljjjr4GZbup7yJoamDmKuOxxX553HtyOa1krwuKsw6ohZ7wZxHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ehDPKZLj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MDN8oeil; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762374590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iIz6E0qujLA95o4Ov58/AudEd/Cd0xTuStKCJ4cr5ak=;
	b=ehDPKZLjhwkZAQFn8mfKo21vxJ6h0uYQr/ATy97aT/wpyxgw2vRMQ3CQCDEyAAC48OhbUM
	d/5LVrCSwG6D5PBC9BJhFMpCMuEe97u1iZnwnMCBNdHx16mwRMSBhKFXlF0nPx1t3EC4Nu
	mDMy0i78BXIPLsT3bMwkOSmnLJ4pD0A=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-SohFl4b6PSaWhHYYRGLraQ-1; Wed, 05 Nov 2025 15:29:49 -0500
X-MC-Unique: SohFl4b6PSaWhHYYRGLraQ-1
X-Mimecast-MFC-AGG-ID: SohFl4b6PSaWhHYYRGLraQ_1762374589
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-88046a6850bso7869706d6.0
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 12:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762374589; x=1762979389; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=iIz6E0qujLA95o4Ov58/AudEd/Cd0xTuStKCJ4cr5ak=;
        b=MDN8oeilLpKYp7T4AYTLrVY1ADB6OzsYvklX5ZnQRjE5pSOB8vmD9EfupxC8dhW3Tn
         t8g6VxEkj7hN9B/bruVmBRcuw984tyf94aZkvNRYAeOhyXHwaGZbK+FeeCkHFvfUOfZc
         pG68T5Ef+T7XjWjlPM6+d85DWRZ4T4jD8zwWkY8mYFYeAGiMJDyVID6EgrfXOICzqC2H
         cz1E76x4P0KhQ+dSDtkPwEhCGS+hGYbISm7FvUjwoO+gdFhLagdpvKDD6NoVf6p//NoT
         mGact3aUS6DqIiAhYeguOUX9riPiItdZyDs83hoIJ/TUaOiR9fUE7tgBDcvvm31d7Wxa
         0PLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762374589; x=1762979389;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iIz6E0qujLA95o4Ov58/AudEd/Cd0xTuStKCJ4cr5ak=;
        b=GA/mjllH6jW294N5sLw0zwICVUw5mBpdLC0cZHUOH5RNoTQS/B/0L2KpCL88OiMbjX
         LtXwh7sXYBMeNsf+cJzhWUTp45NIshJiQtfxSLYfTctCNoKLXNnO/xJpIy4M6SNvvkBd
         zjquElzPKv1IXYAwh2u7XJ5mrcBMmqVAqeeSJmSs5HXCHoqpOApc662DFdplW1QxR6q0
         WkIhSH2B9l8wHMloQBVKsSMxKmIZK1yvbNNFsbUNRnNYENKDONaCOY9S0JLQFv/bMd17
         nWLXXMOi5bQj7RQvpAYcsG9mlv1lkxMYGQVqtn0Wr+QMl9zhY6S6F1KECHalguBgDJBy
         9A1Q==
X-Gm-Message-State: AOJu0YwlQ4+ztSwu5+VYjKurB4uXxSm2NhXRtCqCorPEt3j0OIczb9Rv
	0+sEthvdiagq1/XvF0XiZVK+bTMK8OgkJXW/l60fn/gQAgUVJH5ib4kLyAcOB0kRPI7B1k6PmuR
	wxBE0L0nKR6rK9HjTEJaSQXvi+MXNf+/sB9SmNjxBGCgdljk2oSvtAM/5kG9dRGxm+ITBjLhuPN
	1+5HycOFEs9bHyMFmqqwfDn9L5g4EgyQ0R0wA7Mw==
X-Gm-Gg: ASbGncv7qP5zkAFW30JHRXQSSaAwYB6EOuKllsS8DUT4R4p4djAYudrujBGdC/khOuT
	D84SLUYiQV3GWgOTpHySkkdt/u6wHhy9SzEcYCIRBcrTaYKg0rjXrex6JvRjy1lC3INImHZoRs5
	UjbK56Z2b6VHAeL+gMfF0R9lo0zbRdihpd4fNit+wiTb1hGiFPxMOHnT1446MqUI/T+GZZZh8D8
	Q4Mmmos9FUexA/ZrGyR5niEkGXVZXzMl3/APzvBjPPQN9p2IdclBV7Jt8wlSCP6AMvB8PLIfndO
	RnWlygebhil8hObYsGFi8Ihdln4FeB+RSQhf0bNP4lq4gQgbQvXPTZ66aZU1YyVNYPCdJovlKgt
	YqDn2qMvGhFng9DQPm4KyxwRlYMvGhbTu+KwhF5mYnUlLQQ==
X-Received: by 2002:a05:6214:c43:b0:880:58ac:be6f with SMTP id 6a1803df08f44-8807117423amr74732056d6.35.1762374588737;
        Wed, 05 Nov 2025 12:29:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGJHALWnxulypv5MObSyEwe+zzVwHGJzCcGgDZYZ2XHhgu3+VKH/42YtWVZvSP7w7E4zN8OtQ==
X-Received: by 2002:a05:6214:c43:b0:880:58ac:be6f with SMTP id 6a1803df08f44-8807117423amr74731516d6.35.1762374588266;
        Wed, 05 Nov 2025 12:29:48 -0800 (PST)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-880829f4dd5sm3987896d6.45.2025.11.05.12.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 12:29:48 -0800 (PST)
Message-ID: <10d3f95717b7072e30576b7e3931ea277399fdf8.camel@redhat.com>
Subject: Question: 'pmu' kvm unit test fails when run nested with NMI
 watchdog on the host
From: mlevitsk@redhat.com
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
Date: Wed, 05 Nov 2025 15:29:47 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi,

I have a small, a bit philosophical question about the pmu kvm unit test:

One of the subtests of this test, tests all GP counters at once, and it dep=
ends on the NMI watchdog being disabled,
because it occupies one GP counter.

This works fine, except when this test is run nested. In this case, assumin=
g that the host has the NMI watchdog enabled,
the L1 still can=E2=80=99t use all counters and has no way of working this =
around.

Since AFAIK the current long term direction is vPMU, which is especially de=
signed to address those kinds of issues,
I am not sure it is worthy to attempt to fix this at L0 level (by reducing =
the number of counters that the guest can see for example,
which also won=E2=80=99t always fix the issue, since there could be more pe=
rf users on the host, and NMI watchdog can also
get dynamically enabled and disabled).

My question is: Since the test fails and since it interferes with CI, does =
it make sense to add a workaround to the test,
by making it use 1 counter less if run nested?=20

As a bonus the test can also check the NMI watchdog state and also reduce t=
he number of tested counters instead of being skipped,
improving coverage.

Does all this make sense? If not, what about making the =E2=80=98all_counte=
rs=E2=80=99 testcase optional (only print a warning) in case the test is ru=
n nested?

Best regards,
	Maxim Levitsky


