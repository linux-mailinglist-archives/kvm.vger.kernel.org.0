Return-Path: <kvm+bounces-20466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E0A59165E6
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C9441F21C83
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 11:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1B014AD19;
	Tue, 25 Jun 2024 11:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KnxWWpiE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E791494A8
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 11:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719313836; cv=none; b=TmewHpAXHCfV8drRBvwNutAwdM+/Y67JS1LUCyx4Ej76/M4LfVBVg8V2p3D23DV6C7nAnkA/fIBovn51L4J3sIT6qVORpsJtceqao+Qxqh4X0OEqNAc2tCS/8GGf5fp3jULtmmVbZTDet/wXKbcOvSmkM6e89ZL9nBqHsfiR0rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719313836; c=relaxed/simple;
	bh=X6FOvZlTv1RXxQy+zdor8/RssMwznj4r8mb3jcPKDww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j1k/gcqRJRIuBRroGvJSnxWxYX5H+a36XGEQ6kn0NXCe2rxE3mTYGDOwESHLyvRBM0erMiH8e4qYsqPHY+k6nlbRTA2Wmrkcm+WTBMSEXkg24cuLTi+N9zkgXvy/M8wBnpGV4VsyYWSs/10Ch5wH7bSkIeXo60yDVfCefBr6uuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KnxWWpiE; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2c8062f9097so3740213a91.3
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 04:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719313834; x=1719918634; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Dl3Tppq8VxKQXJX+jusxumOiA1H+GvmiCKLv5EKPZo=;
        b=KnxWWpiETc1peByTOmY66fdeVFZ7ZHbwVWfHEw5yd30l5sRGX8LU6HVkx6Zx8t+/Fb
         9M8BDtGsPUsc6lx0wKN3lc2vPsfCH6bfP9u2A19dM13wi5Bu9tYwWJfy0pLcg4lkoGky
         e0IMD0lCUjnISQ5IP+26FrYMrNmN9RgtRN/oSL48UBzNniKGwwHGmtazXEv+KIG10YSb
         NFvCULGQ+wRCCEnV/8bdYXfhaeerqwDa3FXv2wA1+eTej8UXSY2qJpcEdcbQPACiWhqO
         5CZErDBXQuk8+qlwab6SxYDU/6UiSK1nN6UG294BguVB4ywjqNwtwwvg0c012mD5Gy+x
         sRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719313834; x=1719918634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Dl3Tppq8VxKQXJX+jusxumOiA1H+GvmiCKLv5EKPZo=;
        b=SajYohzVf6ad9ULx+39/sfAS9mYYBNn0rjBwq9jyxeb723pT+P8obm4An+PPgKt+tA
         Dkit2LF4I4/WLGfKHNg3Pjos+bQFUqE914sDM2rnyPNp8/kPaWGxagRSnRVuBGewniRe
         10b+vIw+jsaD3oTrdLYmyrh3j76Yf/baFx8Qw5SEzjlglLCDzxdsAH/SEBT5uTDLJQZN
         E2MDeaPKJKtXdUF2PG4m76p267Yjrws/3LtCPw2tSFmLMukQc1/GH4GZGX4S2uqVsjV1
         IJocIWWl7yJrZuImA9Bp3a50Gd8bG8kv9gkhS9EIAWYR4VenLmcre0rRoZ0g5uAi4jF4
         q0Dg==
X-Forwarded-Encrypted: i=1; AJvYcCXLRTeOLGF3JlbS+LKj0B1t032u/sHKOUg30ObDk2zOBbRJMFix+8GUwL2XgJCJhEl4YKSmNSHtcnAU9/2mr1KDRhaA
X-Gm-Message-State: AOJu0YyfPPeDK/MV54PwYTcRWc9en6lcvPHqb4X8+Rc94iH7nEYOvfaO
	Je6EqmgZnKSObBUrYF1FYuzIlhFKoKZnoJThcTk3v8iF/pttSHEPEHaXazmcK5G3iR0USk+c0IV
	mywYyfrDvJcqr+Pe576LYQ8IqiOY12YzM
X-Google-Smtp-Source: AGHT+IGL1AlVa6Zaqzk5s/QVQzKhiguD8Kxt6EULmSaTUrBUOGd3wp5F6dIeHy9hFkPV0n1FKbbw9LwPJOeS38mz38w=
X-Received: by 2002:a17:90a:d498:b0:2c4:aa78:b48b with SMTP id
 98e67ed59e1d1-2c8613e7a95mr6714079a91.38.1719313834399; Tue, 25 Jun 2024
 04:10:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240620094714.871727-1-cosocaf@gmail.com> <20240620094714.871727-2-cosocaf@gmail.com>
 <ZnnEOJSSsjG0D009@x1n>
In-Reply-To: <ZnnEOJSSsjG0D009@x1n>
From: Shota Imamura <cosocaf@gmail.com>
Date: Tue, 25 Jun 2024 20:10:23 +0900
Message-ID: <CAJo9nWxWrWYa9fpiDSphKaErR5XPFVzuxgXQd4_CPVtXfb7=Qg@mail.gmail.com>
Subject: Re: [PATCH 1/2] migration: Implement dirty ring
To: Peter Xu <peterx@redhat.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, 
	David Hildenbrand <david@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Fabiano Rosas <farosas@suse.de>, "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Peter Xu,

Thank you for your feedback.

> It looks like this patch will introduce a ring but still it keeps the
> bitmaps around.
>
> Could you elaborate your motivation of this work? It=E2=80=99ll be intere=
sting to
> know whether you did any kind of measurement around it.

First of all, I apologize for the lack of explanation.
To provide more details, the motivation for this work stems from the
current QEMU implementation, where pages obtained from the KVM ring are set
into the KVMSlot/RAMList/RAMBlock bitmaps. Consequently, when the migration
thread sends data, it ends up scanning the bitmap (resulting in O(N) time
complexity). I aimed to improve this situation.

Here are the steps and considerations in my implementation plan:

1. Call MigrationOps::ram_save_target_page inside kvm_dirty_ring_reap_one.

The approach involves QEMU holding neither bitmaps nor rings and sending
immediately. However, this would require non-migration threads (like accel
threads) to send pages, necessitating a synchronization mechanism with the
migration thread, which I deemed would increase code complexity.
Additionally, if future non-KVM accels provided their rings, we would have
to write similar code in different places, increasing future maintenance
costs. For these reasons, I decided against an implementation where page
sending occurs within accel/kvm and opted for a separate ring within QEMU.

2. Use a ring as an alternative to bitmaps.

The approach involves implementing a ring within QEMU and inserting pages
into the ring instead of setting them into bitmaps in functions like
kvm_dirty_ring_mark_page, cpu_physical_memory_set_dirty_lebitmap, and
cpu_physical_memory_set_dirty_range. Then, pages are retrieved from the
ring in ram_find_and_save_block. However, this approach necessitates
immediate sending of pages when the ring is full, which might involve
non-migration threads sending pages, leading to the same issues as
mentioned in step 1. Given the ring has a limited capacity, if there are
enough dirty pages to fill the ring, the cost difference between operating
the ring and scanning the entire bitmap would be negligible.
Hence, I decided to fall back to bitmaps when the ring is full.

3. Use bitmaps when the ring is full.

The approach involves setting bitmaps while simultaneously inserting pages
into the ring in functions like kvm_dirty_ring_mark_page,
cpu_physical_memory_set_dirty_lebitmap, and
cpu_physical_memory_set_dirty_range. If the ring is not full, it is used in
ram_find_and_save_block; otherwise, bitmaps are used. This way, only the
migration thread sends pages. Additionally, by checking if a page is
already in the ring (O(1) complexity), redundant entries are avoided.
However, enqueuing and dequeuing are handled by different threads, which
could result in a situation where pages exist in the bitmap but not in the
ring once it is full. Identifying these pages would require locking and
scanning the entire bitmap.

4. Use two rings to revert to the ring after falling back to the bitmap
within a round.

As mentioned earlier, once the fallback to the bitmap occurs, pages that
get dirty after the ring is full cannot be captured by the ring. This would
necessitate using bitmaps until the final round or periodically locking and
scanning the entire bitmap to synchronize with the ring. To improve this, I
considered using two rings: one for enqueueing and one for dequeuing. Pages
are inserted into the enqueue ring in functions like
kvm_dirty_ring_mark_page and cpu_physical_memory_set_dirty_range, and the
rings are swapped in migration_sync_bitmap, with pages being retrieved in
ram_find_and_save_block. This way, each call to migration_sync_bitmap (or
ram_state_pending_exact) determines whether to use the ring or the bitmap
in subsequent rounds.

Based on this reasoning, I implemented a system that combines bitmaps and
rings.

Regarding performance, my local environment might be insufficient for
proper measurement, but I obtained the following results by migrating after
booting the latest Linux and Buildroot with an open login shell:

Commands used:
```
# src
sudo ./qemu-system-x86_64 \
-accel kvm,dirty-ring-size=3D1024 \
-m 8G \
-boot c \
-kernel ~/path/to/linux/arch/x86/boot/bzImage \
-hda ~/path/to/buildroot/output/images/rootfs.ext4 \
-append "root=3D/dev/sda rw console=3DttyS0,115200 acpi=3Doff" \
-nographic \
-migration dirty-logging=3Dring,dirty-ring-size=3D1024

# dst
sudo ./qemu-system-x86_64 \
-accel kvm,dirty-ring-size=3D1024 \
-m 8G \
-boot c \
-kernel ~/path/to/linux/arch/x86/boot/bzImage \
-hda ~/path/to/buildroot/output/images/rootfs.ext4 \
-append "root=3D/dev/sda rw console=3DttyS0,115200 acpi=3Doff" \
-nographic \
-incoming tcp:0:4444

# hmp
migrate_set_parameter max-bandwidth 1250
migrate tcp:0:4444
info migrate
```

Results for each memory size, measured 5 times:
```
# ring -m 8G
total time: 418 ms
total time: 416 ms
total time: 415 ms
total time: 416 ms
total time: 416 ms

# bitmap -m 8G
total time: 434 ms
total time: 421 ms
total time: 423 ms
total time: 430 ms
total time: 429 ms

# ring -m 16G
total time: 847 ms
total time: 852 ms
total time: 850 ms
total time: 848 ms
total time: 852 ms

# bitmap -m 16G
total time: 860 ms
total time: 862 ms
total time: 858 ms
total time: 859 ms
total time: 861 ms

# ring -m 32G
total time: 1616 ms
total time: 1625 ms
total time: 1612 ms
total time: 1612 ms
total time: 1630 ms

# bitmap -m 32G
total time: 1714 ms
total time: 1724 ms
total time: 1718 ms
total time: 1714 ms
total time: 1714 ms

# ring -m 64G
total time: 3451 ms
total time: 3452 ms
total time: 3449 ms
total time: 3451 ms
total time: 3450 ms

# bitmap -m 64G
total time: 3550 ms
total time: 3553 ms
total time: 3552 ms
total time: 3550 ms
total time: 3553 ms

# ring -m 96G
total time: 5185 ms
total time: 5186 ms
total time: 5183 ms
total time: 5191 ms
total time: 5191 ms

# bitmap -m 96G
total time: 5385 ms
total time: 5388 ms
total time: 5386 ms
total time: 5392 ms
total time: 5592 ms
```

It is natural that the implemented ring completes migration faster for all
memory sizes, given that the conditions favor the ring due to the minimal
memory workload. By the way, these are total migration times, with much of
the overhead attributed to page sending and other IO operations.

I plan to conduct more detailed measurements going forward, but if you have
any recommendations for good measurement methods, please let me know.

> I remember adding such option is not suggested. We may consider using
> either QMP to setup a migration parameter, or something else.

I apologize for implementing this without knowledge of QEMU's policy.
I will remove this option and instead implement it using
migrate_set_parameter or migrate_set_capability. Is this approach
acceptable?

This is my first time contributing to QEMU, so I appreciate your guidance.

Thank you and best regards,

--
Shota Imamura

2024=E5=B9=B46=E6=9C=8825=E6=97=A5(=E7=81=AB) 4:08 Peter Xu <peterx@redhat.=
com>:


>
> Hi, Shota,
>
> On Thu, Jun 20, 2024 at 06:47:13PM +0900, Shota Imamura wrote:
> > This commit implements the dirty ring as an alternative dirty tracking
> > method to the dirty bitmap.
> >
> > While the dirty ring has already been implemented in accel/kvm using KV=
M's
> > dirty ring, it was designed to set bits in the ramlist and ramblock bit=
map.
> > This commit introduces a new dirty ring to replace the bitmap, allowing=
 the
> > use of the dirty ring even without KVM. When using KVM's dirty ring, th=
is
> > implementation maximizes its effectiveness.
>
> It looks like this patch will introduce a ring but still it keeps the
> bitmaps around.
>
> Could you elaborate your motivation of this work?  It'll be interesting t=
o
> know whether you did any kind of measurement around it.
>
> >
> > To enable the dirty ring, specify the startup option
> > "-migration dirty-logging=3Dring,dirty-ring-size=3DN". To use the bitma=
p,
> > either specify nothing or "-migration dirty-logging=3Dbitmap". If the d=
irty
> > ring becomes full, it falls back to the bitmap for that round.
>
> I remember adding such option is not suggested.  We may consider using
> either QMP to setup a migration parameter, or something else.
>
> Thanks,
>
> --
> Peter Xu
>

