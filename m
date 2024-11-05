Return-Path: <kvm+bounces-30794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D319BD5C5
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:21:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38758B21368
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ED071EBFE4;
	Tue,  5 Nov 2024 19:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gR4d4Y7Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182261E7C27
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 19:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730834504; cv=none; b=GB8tr+qJ43Qscu9lR3SO/b+wvxyrvojTjhx+KOK73dr5QZQNta7R8UFzYKOpOqlwhH5S1hnmSu4J6zRTF27YnflnZ6iw1W7TyzFzCFWoZGntbX0G1yJFgc6ImjtX6d9BB4GJi6rS7GUSC5i3CNdgMyVu5PVKT2XLczyQXrk9xRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730834504; c=relaxed/simple;
	bh=5WjO8kooJsNK7ZBxwniHhJKcVajJEn35p+jeOFdCYDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s3KrOfGZnnylMUYaZi4bDcbRBRKD0fD/iuBtvmRiZ9bXa2cZjWbaKX1AAjrt/+2LWa4XSWoV3243OpClApcvjcqfk4ktzMBlRYOPmOavBhvVQGrRlzhV4p6BwLjRd6AQznk++zNg0Du04ibEJ0SRGQCI03LhA6Hp3mzx67y/mjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gR4d4Y7Z; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-855f2dfb682so1573585241.3
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 11:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730834502; x=1731439302; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5WjO8kooJsNK7ZBxwniHhJKcVajJEn35p+jeOFdCYDw=;
        b=gR4d4Y7ZGIwhk3TG6FM458VXATERvSxalgXXENHz8cYItp7cllUhCR6FQTz8sr4z/S
         gMIwxujvKY1QrNaviUqrtDt2dgXORk1PB8B+2nLghG1ihOAMS6jhS7Wy2px1qM3dyTcj
         cHiSD1EtFKXwv4yskydmSRL78mt8j8CanV+ah61YNYLe3Xqk/FH/Ej/cUkhjOU7XhoHn
         GaJ0CwOF8e916mRKLUbUYpFYLAShsdA2HYneZXhQxGUBTkbPOBT1JCZ+GGw11C+fVUo9
         R9W/JtmjPCay/JtN3D9t7nG8MKLSa8JE7/vigHDyseIvaAtfVOw+HnaUJPQbPNXq/ZDg
         EzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730834502; x=1731439302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5WjO8kooJsNK7ZBxwniHhJKcVajJEn35p+jeOFdCYDw=;
        b=lQgsF4DcAsjQAH6lnat26FtqhoboMnbmDFbbDZnZHL6k8SnPglBtr0lGPYioLi9vAU
         UYy2eYhHiQaKOkUTuPTDCIgSKSLOSJN7VOqRJlgoo6AEoHHJcJRIAUglVYXo/WJjQhKp
         VH+qdhFX4ap86SZ7UigfBvKhvIwZvi0y7nvgK9yG971LEwOBTRaZQp9vHMcG0KMQ8JY5
         pnJK7Zit7b2QYptCwT86h+RpXPn+n4qkrfHDgHski48KAKTwgcBK+X0NwrBuNd1yqubl
         +5TTzYfQeFtzH5nu4qEyAhGbOkbAGZXYBM7l5lZT+mUTP0Wg1axIYeqaWn+iXaxjPjVs
         gLOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUjUY5ixGSRD/xkDZM926Cnw11nLbUsHy7O3K16hpLX9f7mLF3joot1Mo9EjolqNFynGE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa84GLCa9HKqgBVZXhzSNxmIG1wc/IDFhOazw5QyYdlCz/mMGZ
	NX1+lReIT2UYm04V/F+MdoUSKDw9cDO8zndWnFjnHUOsWNEjp6BOVMCbhcbwN50Bni14G52f7da
	O8Yide5j/netSRZZDewIpa0PWgImktoX/q7Tu
X-Google-Smtp-Source: AGHT+IEo+Kzl8oq8hn5GP7PubF/mZ9ZN65TG13mkSZTKtWpHUHtBiEPxJIfZWEDkljfh9z2TeQ4oGnRnMXvz3siHkys=
X-Received: by 2002:a05:6102:6c5:b0:4a4:7257:e71e with SMTP id
 ada2fe7eead31-4a8cfb4b70emr36918399137.7.1730834501695; Tue, 05 Nov 2024
 11:21:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
In-Reply-To: <20241105184333.2305744-1-jthoughton@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Tue, 5 Nov 2024 12:21:05 -0700
Message-ID: <CAOUHufYS0XyLEf_V+q5SCW54Zy2aW5nL8CnSWreM8d1rX5NKYg@mail.gmail.com>
Subject: Re: [PATCH v8 00/11] KVM: x86/mmu: Age sptes locklessly
To: James Houghton <jthoughton@google.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 11:43=E2=80=AFAM James Houghton <jthoughton@google.c=
om> wrote:
>
> Andrew has queued patches to make MGLRU consult KVM when doing aging[8].
> Now, make aging lockless for the shadow MMU and the TDP MMU. This allows
> us to reduce the time/CPU it takes to do aging and the performance
> impact on the vCPUs while we are aging.
>
> The final patch in this series modifies access_tracking_stress_test to
> age using MGLRU. There is a mode (-p) where it will age while the vCPUs
> are faulting memory in. Here are some results with that mode:

Additional background in case I didn't provide it before:

At Google we keep track of hotness/coldness of VM memory to identify
opportunities to demote cold memory into slower tiers of storage. This
is done in a controlled manner so that while we benefit from the
improved memory efficiency through improved bin-packing, without
violating customer SLOs.

However, the monitoring/tracking introduced two major overheads [1] for us:
1. the traditional (host) PFN + rmap data structures [2] used to
locate host PTEs (containing the accessed bits).
2. the KVM MMU lock required to clear the accessed bits in
secondary/shadow PTEs.

MGLRU provides the infrastructure for us to reach out into page tables
directly from a list of mm_struct's, and therefore allows us to bypass
the first problem above and reduce the CPU overhead by ~80% for our
workloads (90%+ mmaped memory). This series solves the second problem:
by supporting locklessly clearing the accessed bits in SPTEs, it would
reduce our current KVM MMU lock contention by >80% [3]. All other
existing mechanisms, e.g., Idle Page Tracking, DAMON, etc., can also
seamlessly benefit from this series when monitoring/tracking VM
memory.

[1] https://lwn.net/Articles/787611/
[2] https://docs.kernel.org/admin-guide/mm/idle_page_tracking.html
[3] https://research.google/pubs/profiling-a-warehouse-scale-computer/

