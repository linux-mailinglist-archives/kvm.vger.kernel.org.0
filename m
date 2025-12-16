Return-Path: <kvm+bounces-66055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD9ADCC055E
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 01:19:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A0BED3017669
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 00:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916CB20458A;
	Tue, 16 Dec 2025 00:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tMwHE8eT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD0321E0AD
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 00:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765844353; cv=pass; b=aAVT1M7/vtRmv+2HnN81gOn0+YjIFTeM4OVuR7t7Fy8AZ7ARmtaR9UKiJ8zdV3BRQkgTGVocdNLbaGLze9RpTq7dDntMPBLAeMjwM2OGLJcI4RRScYgvITfHyo33EvatEeB/5srOPtPab7QCMCYF1xiXrutIClCu75EKTEVJpFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765844353; c=relaxed/simple;
	bh=y3+CB9jJkDY/RuF5+3mG73XjTAnHhCai2n7zifE/14E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=puysKQP8nEZy6dNYTIGan1wrtbHkKWD9Ymf61+eFzrRhg2A5EYOt6be6vcwQjE0s4mdUfIk1c9ccCKyD23edmI1lT1We3/jaM6pwsKyeW9FbodCYbNZRorBdp9ixdwzDdn/dNdwTVoDfphGaD3Rlu0bf/HBXz347AdogEjoSIaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tMwHE8eT; arc=pass smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29e7ec26e3dso47075ad.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:19:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765844351; cv=none;
        d=google.com; s=arc-20240605;
        b=e/qNKkckso6YuM4bck+28o1QpAJvdkgJ1pmPGx2mSH4EF80SXD8jMiPfIAjOUmCmOA
         xtQENBawQOjrqOprqARS0t2LLPuySqClT8JxouRQ/f05K6mzHbsflVt3UgENzekYHWrF
         cRqC5zRRrxwY6oZaGTgGoyB5wgt0u9BYsIrMJ0Xe2kbEwANUEFAnLrDexjfQIElCAdnz
         ZdIj9L/+JnWX3cldZptJgkDGl3zWOc7Y3IPRvjEEM0broBgVwGkZJ6KHo6atTCQqTfGx
         2bJ7zHlkAxIIlqMzxC3Ond0jIHO4TE4E3ri61/vZOWcRgU5D9p23BXqTw5rzjsCetLhY
         9ZaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y3+CB9jJkDY/RuF5+3mG73XjTAnHhCai2n7zifE/14E=;
        fh=f0Sa/Gk6aV+Q0XgvPyFCasN4iiurT6FrEyCiHiudOJM=;
        b=NAvHFhhgtLjFcZasfiNajeli6pdOrDGKXfrBS00lx7suXg2W8O6o99pBLdSxFdpCkf
         8jqPhjMYAkgUM9OI8HQvMPSEbyBDzVwkSyJf14g0GtyILyZnUs5lTT3J4OY2MilEgBFc
         NojyT0m/2Wzwpur4viksSqysYHGyaacFxt3U+JfGyLO+vCDQ4x1aI56ajJnPfyP580gx
         dIKtUIrYn6i/fanGHTDeHOcJlkFVgK8tZa66PsLbn8zOY2aQmFxyMMow8ZAbgpNPEmMx
         7P2IQI1BVFWbpSKA02WaMI2dieFk3PfoFyk8R1bcqd6f2SqKSwJxAKKyoQLvCEe23RLF
         g+Xg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765844351; x=1766449151; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3+CB9jJkDY/RuF5+3mG73XjTAnHhCai2n7zifE/14E=;
        b=tMwHE8eThTx0Dvj1hw0avYac9Qny1tGuGFWROgN1rxNfNRuD74gO+BVzuJIyjhvfbx
         R/TCJ+HyLqDUPF3mtN6RUipffwCN5GQX3wfYdQkkXgPtIoM7cfjkHjLeuR2qGDqBdGzJ
         Y1rNXLGwMyImvKSHZrb8ESbE73PNHP6/XodL7slV5zYt3ur595zIw27B9AStj9mrkrCk
         tbtNKh5YxGMon5LvvkGD1w2J4J5Lk0nIEuWIw1v+A6o6+EP1RtOSp0yU06sg7B6cVcad
         B099dIOQXweg2Psxi5Uxzv6kHArCA9+tzIUVyNh7gyYjee9vGp7/9zNpxrdlrDxFwG8l
         lg4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765844351; x=1766449151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y3+CB9jJkDY/RuF5+3mG73XjTAnHhCai2n7zifE/14E=;
        b=XLlhwIWLu8fYUxQj9xK1ghfZZ2EXQHbcyJJFGjvEUZpiK35TFYxeycOjr9prf/ZBe0
         c8eDm92p40S9ZFjPBKlPIZrjSELxiL58O4wVIRKBxwqnvQWlnvN+8+a6Fqtji8m3GAIK
         vEeJNIikgfnFK75urHGRXIyBsXYBy8loty4v035wOqVk4pt9h2lW2lOfvPQFnKc2x2MQ
         McfjJoThAyVVI9+DO0C4Ok3a19oIOfQBY3RLdtglWF5u6ZXlKXEkFQfP09O+jeD1Olr/
         77TdZx0/2dgOSdB/HBQ15ST4czCeNY0ZH+C/qBbuBuAPabEGIpYqHseIY2M0s7hn4wxv
         LNHQ==
X-Gm-Message-State: AOJu0YzZyDRrUiNfJ74HlOWbhPLyVduKKk0M/7R6Kaj+dpJAjQ2jwbf+
	ogNlZZ1zvlSaJcS9llCCfM+7W+/g0JFMq9E7fCWQKxVonrWlRX+JHS8LD99wCYh9nAqpz/KJdJz
	TuhLOQvR8p8JX5yMQuywfiBFUc89m/4urTsahrAdy
X-Gm-Gg: AY/fxX52zYUzvULxleRbbHQ5Zu2Nm9FWHed0uvFgx5sXPJBSZirInf0YY+OUFP1vmiv
	T6kV+iNnPkHc6WL/eAxdgknM77IWLUUuuqL0fR2Hou/o526Lwjojx6NZHtbO3Sjn9D6156MX/6/
	qLw3F+K86E0FHAwME/R2ciAhdB44orVxr5mJ2MSSKxBYz/AzsGurH2RWqOpszp0hhBK1SasPKj8
	5DivgisIeO7ylRWOibSTCGqh7zmGaCmCdox6FBTuoyhQsgr9s84Igh5/F9zCnFOYWSONWxm0oMR
	eiv+Y5sVEry48Bduhyt5QttQztJ5
X-Google-Smtp-Source: AGHT+IGBM7VWEq8LinkBSYV8x5ESzAOrR3yJML1qZ6fwh89ve8A15rNzyiEn6zhpcZCGpp2XSo8wGtGea9cBBpvSm0U=
X-Received: by 2002:a05:7022:988:b0:119:e56b:c1de with SMTP id
 a92af1059eb24-1205724808fmr225c88.9.1765844350465; Mon, 15 Dec 2025 16:19:10
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215153411.3613928-1-michael.roth@amd.com> <20251215153411.3613928-6-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-6-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 15 Dec 2025 16:18:57 -0800
X-Gm-Features: AQt7F2pmUo8h-ojZ6qUQhapMaawZOTdDVwOKAdoTYFJZ9Oc6NFfbzoMtVRYUIYE
Message-ID: <CAGtprH983huiuu9w9JG8nL3cf5sa_FpJjEt2gOvVUKgGUxtdGg@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 7:36=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> Currently the post-populate callbacks handle copying source pages into
> private GPA ranges backed by guest_memfd, where kvm_gmem_populate()
> acquires the filemap invalidate lock, then calls a post-populate
> callback which may issue a get_user_pages() on the source pages prior to
> copying them into the private GPA (e.g. TDX).
>
> This will not be compatible with in-place conversion, where the
> userspace page fault path will attempt to acquire filemap invalidate
> lock while holding the mm->mmap_lock, leading to a potential ABBA
> deadlock[1].
>
> Address this by hoisting the GUP above the filemap invalidate lock so
> that these page faults path can be taken early, prior to acquiring the
> filemap invalidate lock.
>
> It's not currently clear whether this issue is reachable with the
> current implementation of guest_memfd, which doesn't support in-place
> conversion, however it does provide a consistent mechanism to provide
> stable source/target PFNs to callbacks rather than punting to
> vendor-specific code, which allows for more commonality across
> architectures, which may be worthwhile even without in-place conversion.
>
> As part of this change, also begin enforcing that the 'src' argument to
> kvm_gmem_populate() must be page-aligned, as this greatly reduces the
> complexity around how the post-populate callbacks are implemented, and
> since no current in-tree users support using a non-page-aligned 'src'
> argument.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Tested-By: Vishal Annapurve <vannapurve@google.com>

