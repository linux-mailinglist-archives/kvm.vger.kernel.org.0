Return-Path: <kvm+bounces-22271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9209D93CA62
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 23:56:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B595A1C21E61
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 21:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D61331448D2;
	Thu, 25 Jul 2024 21:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uqmAgIJK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845AC14389F
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 21:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721944570; cv=none; b=ke39Z2ExW2TTjeg1zzEhO1jfYZVQzlle1U2EXj3myNvDo4ZsMPUCGZpn3Y/pOXUH88Wp2YR666L2cciFzHQXPSVhvZ6i/BWa6hdpSanN7z7UUhCywq36JRjFYrTyXEIeEdb3Xb1cN1qadNF3E8jyWUacOeWW1KKu9GZYsALGapM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721944570; c=relaxed/simple;
	bh=G0SV+4c0df7kDP/HmTtBo/ahkooNcX5psIcCqUvYfMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mrC0tpxBavwQwrtnc1rk68zt8I5QG+a5qoZoj9JVs+bqPiFQHbDH/c6RTLeANIfFj4rPDN9sZdZex2S6HzHu7DIkKisFRt+0z9z19V/0VkKvyf9jrCNdttQv/yDNHmPm+SoDWANS5xJQJowaCpo4HZpzthMDmSS5lweFoRce2z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uqmAgIJK; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-44fee2bfd28so15591cf.1
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 14:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721944567; x=1722549367; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5zN0Ee2V5PvZ/loIwKVW1h0fdtsfazaCJoYyQYKYrE=;
        b=uqmAgIJKpg5s7UutiKdKoBc9GtLlyX1yNbNEaw8svVLCSmzlfvDmhVQKD3jyO8T28p
         qwUfXTbkWV4qB8LSsr6W/kjt9wk9NOOKzoxLDJTbdVSPKzq3tQCpq5OKaAwg8de2cOf9
         V6nB+jT48JhIG+YAhOKN9dlfvY3XBkLnQqTLyI0OeoapAIH+iP/w+Imqubb4BLnmrpTe
         Xyw23lWIAGiE64UG8GHlMN9fcaxF2BvMLPV4XZcShEuzE2iJ/HXmD34kaDIQdHktGFvA
         9fjq8hFEZSzhg9P89ZWDC+kP6aZm1sRJB/2xvArd9cDszcbN4oglmC6GNxXMvic5mEpd
         GmGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721944567; x=1722549367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o5zN0Ee2V5PvZ/loIwKVW1h0fdtsfazaCJoYyQYKYrE=;
        b=CPFy0Q3XP34rl68UDlqOBamTT135Gf384GnKjCyQfR9m+YRfv5tmvYtxMkDwLOk3vV
         52ZCPmEi1Uy7zo4WQF4JT2/MhNJ9R9PYJdT+CY0lnP70YD7qgQr2f7uMswScy5bQOVIz
         jzoBns5Bz6WrjBgenKIyFyKqud+p7n0YB6y+Tu2uMNgvM2jRauXnHwUdmhLGEd5q05EB
         2susZgi1oQaLXauv76xQy04KS5yrKH7MTo/tRfxVfUP20Ij0G+1rkdWLyZ/BU9nSOZHK
         2TfHnVvO5xn+yJmced7xYORnZj64kwbAA3J9stulJzbyhN3lgmioPsUUFZsxGVV/TAeT
         yp1A==
X-Forwarded-Encrypted: i=1; AJvYcCWTm5mcQo9bu8Qas9Q496HqU95cigQ0gvL06JnzPAhgU7nufDONT6G6fOGW5/35VLndn233hqV+ZkaoXl623+idluav
X-Gm-Message-State: AOJu0Ywj0oJw2Z+iiGd7CjpaB6AHXiBUeHQiD3J36UPdfs35kH94Ukkr
	Didxx6aNf2xSZromUSEWo4785pM/47QDxukSF/2dwYtRQQU7WzPA2jqIZhTYjR1lSMHwyirg2ga
	nbiOPKiFOLZFzG9KBZiJQyJUvzKW1ujxqM9iN
X-Google-Smtp-Source: AGHT+IFhP5/yTm7ISgwUHXy+IaF0SeriofzfJKq8H3XwJMAsEhtvrR3NBZlrFcMQ5LfszxCadNdzcI48wvWetEqqHuE=
X-Received: by 2002:a05:622a:134b:b0:447:e76a:c04b with SMTP id
 d75a77b69052e-44ff3a6ea56mr930791cf.10.1721944567177; Thu, 25 Jul 2024
 14:56:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com> <20240724011037.3671523-4-jthoughton@google.com>
In-Reply-To: <20240724011037.3671523-4-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 25 Jul 2024 14:55:30 -0700
Message-ID: <CADrL8HV5M-n72KDseDKWpGrUVMjC147Jqz98PxyG2ZeRVbFu8g@mail.gmail.com>
Subject: Re: [PATCH v6 03/11] KVM: arm64: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2024 at 6:11=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Replace the MMU write locks (taken in the memslot iteration loop) for
> read locks.
>
> Grabbing the read lock instead of the write lock is safe because the
> only requirement we have is that the stage-2 page tables do not get
> deallocated while we are walking them. The stage2_age_walker() callback
> is safe to race with itself; update the comment to reflect the
> synchronization change.
>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---

Here is some data to show that this patch at least *can* be helpful:

# arm64 patched to do aging (i.e., set HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONL=
Y)
# The test is faulting memory in while doing aging as fast as possible.
# taskset -c 0-32 ./access_tracking_perf_test -l -r /dev/cgroup/memory
-p -v 32 -m 3

# Write lock
vcpu wall time                : 3.039207157s
lru_gen avg pass duration     : 1.660541541s, (passes:2, total:3.321083083s=
)

# Read lock
vcpu wall time                : 3.010848445s
lru_gen avg pass duration     : 0.306623698s, (passes:11, total:3.372860688=
s)

Aging is able to run significantly faster, but vCPU runtime isn't
affected much (in this test).

It would be really nice to motivate this patch with a test that didn't
require patching the kernel... Oliver and Marc, please let me know if
you'd like to see more data. I'm also happy to simply drop this patch.

