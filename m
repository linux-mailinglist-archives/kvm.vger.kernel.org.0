Return-Path: <kvm+bounces-72618-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6ChgKkhip2lvhAAAu9opvQ
	(envelope-from <kvm+bounces-72618-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 23:35:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FB121F8094
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 23:35:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 78D6E3145F0F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 22:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF90035DA64;
	Tue,  3 Mar 2026 22:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7GOKNBZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="NcMDzphI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2FC2EE611
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 22:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772577228; cv=pass; b=bgnCgJU114nl9p8T2lTWpUc3uIJQv863amXZa/R2DLlKzLZxdlE5QbMmqlukDbJe6oEG9y+eBdOMvEv4I5lZr0RoOyRb8WxFKcHM9/du8jenchX+lBipAdkzyY4eaC8dqJSN5eLqrxedPpY49EfONF0YVO2sCV0XhYIgvetsti0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772577228; c=relaxed/simple;
	bh=hq53TF/YnQkUm5ejiaviNXbEnIhx2a+003D5aGh+ECQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=haeLnct2T4t517nTfL0dggf+EpUGhdiWs20blcsd4POyPhFrVpZ2EVtnUUQcttEwR5XiWOls+VDbwemdjrJBTR92ZoayDUjQPXZ5Adh0938C2lHTQhUTXywtdqN47P3+Pu/GQMxBiqtUGvTnns0LWaQfiH/j39Eee9qpwYrHvts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A7GOKNBZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=NcMDzphI; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772577225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NZ3iVpiETC1+FJYK8BWoumARbNmPPmCJX56dPvoZWG0=;
	b=A7GOKNBZw0oDnJD7JbmGZobGMQo2ZpdvbVPdo0MOxOvZV/qyfLsRpn6vu764wuiUdscGRV
	qauV6XyCJ06Mngsb5RKOnu6/8UIya4jQM39xODp5Kx5z+siVN/Qh2+oBU+an79kpz4nG1k
	lC5XY0ZWGE28eIxxFTyh8q/GKD8DU+Y=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-teLM0d81OVCG_TuLRZz1WA-1; Tue, 03 Mar 2026 17:33:43 -0500
X-MC-Unique: teLM0d81OVCG_TuLRZz1WA-1
X-Mimecast-MFC-AGG-ID: teLM0d81OVCG_TuLRZz1WA_1772577223
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-354490889b6so21833779a91.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 14:33:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772577223; cv=none;
        d=google.com; s=arc-20240605;
        b=hjNn6oicmTPdP8GpTC76v0Yen1zk2uwaNUjGQYVzp1GPY1v/mCwUyTe/bGAnj6QFK0
         Hjx9bImN+2J9+Hf5vIxU1dR4Ws/Adf9Mw4kjHPI58k+fMWHvH4Mnu3eLCiMhUindqgcV
         y0t3cKBh+rjVId9aHV2+xYyETsEdDE0jAbceP8q3pyGX2WNNHBaaIyiAP/7P0ZZ0UIPj
         cEgysiK4MWysJ6zgn5WtvmeIp8kLM93lLLqPnNk0qYMmpytZ12EjRvL82UAKDqsYoQSF
         aPxrYv5nict32t7Vy82kvtkANQLKcvBBvTRmMsTYNgLBbcsnOvgObuliBM5OxlhLzBzB
         sbUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NZ3iVpiETC1+FJYK8BWoumARbNmPPmCJX56dPvoZWG0=;
        fh=dDSAhm1v3MCNwXQxJH/y5rjif+DKAmCZK/HVDeHXVS0=;
        b=ZHFizdYb1QItKGY85rN6sMVmd5kID180Xb61N0UNG/aTp8AGXa5zsKmV4CIUMDGt9q
         lZDdWEH2g9+zEBTAtB2YWFhLhHEit1Elz6nqGOVMwAcjSjYCkhQI55hKB98TWJO948DB
         9mw7b3UkLgLPO5bqxKrO4exmHPi8RR61PaMnMliAGEuSrgEBgrMHS7USLx2rF/pU2bCU
         gYKRsPg9xvRZse6++EjhD/Pn//4EridWbwS5eJuPGV680cygn/NBzPtASN/bGm0MD9qE
         Wg0+qVaTcO0+RnO9r77/rrCIFtZgvrgr7nNOZJs+8lSVlA7QqqrCILyCS9ExR8NwT3XT
         mZ1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772577223; x=1773182023; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NZ3iVpiETC1+FJYK8BWoumARbNmPPmCJX56dPvoZWG0=;
        b=NcMDzphIH1oXJm3krHJE6NX482cr4pk3cI+o+lIrJvjm+BaNbCpPr71S8vIl0anbKS
         iRj2qA2rjbRDyp9mabjk++DGZh6O64aT0pJOy70yDRrQKZQvKH760V2/pi+gg4cxi4hl
         03YycUHf96L/CG4xu7Tm+bX/NWcb47T9cN9AhtUag9apn7npEThmlU7kHPYjoi1eq6Dw
         yhJm5q0sD8AbzRG6dJT1kF2DlbKKZYfci3ho8GO5h6DJAfrRxN6XUiAGefEOJGIdGsFb
         DVqJp9watMEW4uqLJfMpzWH/mqNZQN2gZULJrZPmTK96K55QUMkzhVEWV5qhT5AUXXFu
         10xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772577223; x=1773182023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NZ3iVpiETC1+FJYK8BWoumARbNmPPmCJX56dPvoZWG0=;
        b=anMaNiEsvU2+QPDiZhOIDZB/+ySBUj9BZsC8WdFyT2TrRwup6TSTymAFa5cnIMvQbO
         JLfxZnm7mxwocmt5VhTAGfIeT0WvwezBgMB5l8+7FGCjuLJJTJNNmgDpsB4fmzF5jBE1
         7Imi3+WhIYdmpQS0eylDv13d+7FznqK12LlxxwpLNkxyiaLkKH99E79xmldWwAB60ZuB
         HWwqy1fFiZ1YAqQlvDlYwZ1G1hE4aIDz/KBiCjUgmmgWWu47IMQNd7MgZgqn+h+jPYPg
         BUyTMiBX2Im5qKKqhq9ZrO9/Gi8mGYjPtURwgibrlBRlXKVlQqWOGCc/yx09Nc0ejnh/
         QlnA==
X-Forwarded-Encrypted: i=1; AJvYcCWmA2pP9WuolEjDlX+TqG42jYJHF2bqqYMnH8CPjyTHXPveSvevcGJT+4JzvoLhCf4Sjwg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf/zRCacgiLWaxTzIohAwROVjZ5Cr5T/+Emytl2goqAGKNk9A1
	oJ1TjTO9E0p5TQvOZpS1j6wOifnIc3UjABeEsQ63GQYP5ghKGFS+JFP84ObiunxrUbzfr0QjgMH
	kPwCJHc2L90tzcGcCO/O6H4I+l9lyiaek2XZ2k55H4XEEgTiaa6nQDuzXxLzCFNElfMs71ddUex
	b1YKiG7c7kEdZV1Zk3VADebKUE8b8f
X-Gm-Gg: ATEYQzz62FLQbBrONIBrJV7p3vDQKzT3uw5aK1qhKmuO9sKvjKta6sZtpXmN21NtAvs
	uaQolNzKBbBKTeOiX14H6B+puSjovJ3Z3WrF3HKp/qE8rEEpTa3cEPa5yHEBD2uATe4d3nAGqYx
	PP59n2UBT76xxT2YhUA6GkVKi4fLyg2ytsF7j9rjQpNEdvcegmphbavXejSQ0wVr+1GbTljsveP
	v0Kq68hRHn56ZVDA2p7d9IiYEO7jJQ9zyzhZ43AtP0c+FR9Y5HkfZMbqtxnXK0YAYsygy+oB2mm
	miV156LrIq51f0RA/xjl3GMi
X-Received: by 2002:a17:90b:1dcf:b0:359:87ff:f34f with SMTP id 98e67ed59e1d1-359a69c0a66mr9028a91.3.1772577222714;
        Tue, 03 Mar 2026 14:33:42 -0800 (PST)
X-Received: by 2002:a17:90b:1dcf:b0:359:87ff:f34f with SMTP id
 98e67ed59e1d1-359a69c0a66mr9015a91.3.1772577222381; Tue, 03 Mar 2026 14:33:42
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com> <aadScmxkeyWBFLeg@x1.local>
In-Reply-To: <aadScmxkeyWBFLeg@x1.local>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Date: Tue, 3 Mar 2026 23:33:31 +0100
X-Gm-Features: AaiRm52s2AB2fKLzvYjW9AoNqafX-WyW_elj4MkHBBh_m2_gOMytHrhkmxz-A30
Message-ID: <CAMxuvay7r_0Fb=MPn5ECkkeVe1sZ7FfG9r8Z=mCcaEpweqh3cQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/15] Make RamDiscardManager work with multiple sources
To: Peter Xu <peterx@redhat.com>
Cc: qemu-devel@nongnu.org, Ben Chaney <bchaney@akamai.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex@shazbot.org>, Fabiano Rosas <farosas@suse.de>, 
	David Hildenbrand <david@kernel.org>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	kvm@vger.kernel.org, Mark Kanda <mark.kanda@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0FB121F8094
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72618-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,ozlabs.org:url]
X-Rspamd-Action: no action

Hi

On Tue, Mar 3, 2026 at 10:29=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Thu, Feb 26, 2026 at 02:59:45PM +0100, marcandre.lureau@redhat.com wro=
te:
> > From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
> >
> > Hi,
> >
> > This is an attempt to fix the incompatibility of virtio-mem with confid=
ential
> > VMs. The solution implements what was discussed earlier with D. Hildenb=
rand:
> > https://patchwork.ozlabs.org/project/qemu-devel/patch/20250407074939.18=
657-5-chenyi.qiang@intel.com/#3502238
> >
> > The first patches are misc cleanups. Then some code refactoring to have=
 split a
> > manager/source. And finally, the manager learns to deal with multiple s=
ources.
> >
> > I haven't done thorough testing. I only launched a SEV guest with a vir=
tio-mem
> > device. It would be nice to have more tests for those scenarios with
> > VFIO/virtio-mem/confvm.. In any case, review & testing needed!
> >
> > (should fix https://issues.redhat.com/browse/RHEL-131968)
>
> Hi, Marc-Andr=C3=A9,
>
> Just FYI that this series fails some CI tests:
>
> https://gitlab.com/peterx/qemu/-/pipelines/2361780109
>
> Frankly I don't yet know on why rust fails with this, maybe you have bett=
er
> idea..  So I'll leave that to you..
>
> =3D=3D=3D8<=3D=3D=3D
> error: unused import: `InterfaceClass`
>   --> rust/bindings/system-sys/libsystem_sys.rlib.p/structured/lib.rs:23:=
15
>    |
> 23 | use qom_sys::{InterfaceClass, Object, ObjectClass};
>    |               ^^^^^^^^^^^^^^
>    |
>    =3D note: `-D unused-imports` implied by `-D warnings`
>    =3D help: to override `-D warnings` add `#[allow(unused_imports)]`
> error: aborting due to 1 previous error
> =3D=3D=3D8<=3D=3D=3D
>

ok, this is because the RDM is no longer in memory.h, and thus objects
are no longer needed. Fixed

> The other thing is this series will generate tons of checkpatch issues,
> almost only line width issues and unmaintained files, so they're trivial.
> It seems to me it'll be nice if this series can land 11.0.  We have one
> more week.
> Please take a look when repost, thanks!

ok, thanks


