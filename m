Return-Path: <kvm+bounces-66100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EEE2DCC5B04
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 02:22:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A3AD1302A972
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 01:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4DA923ED5B;
	Wed, 17 Dec 2025 01:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OjrCHJKd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fO0GU2oV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D7723EA9B
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 01:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765934538; cv=none; b=Pw5JhUTLdu1v+0sivBFb0k6zQzlCMppIukq0pzJo+Krl9Zvmgsax5+I3vQDMvu7r/0NDa9mx7f5BeBn9nn5GDIWgjitCjUjG54WxM2+m8eoKu5+PPLOW+QBIWTZRhXG2OVouY3OVsI0kj7gzluKMWncmxIboXIXRF/KrpmbUoiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765934538; c=relaxed/simple;
	bh=9boVk68kYNusC+MXtLi8MSVwKnke4dYwoVkCzCoc7c0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PPs4ioSbjZs2I+Zh4WtQ6NtaORtuEBSaVMAKXcJuQD0shxV4QSRjZPlrAXXHuTOVlmdifVEUoUpr3PsQ235nPQUXACiZpRQ/Rm7x8/LrHapJb58fHzuBrFJWO8IYgn9sklGva/f0w3sdGbNBSCBljDwbV6WGlnYYjQZp8TkzVLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OjrCHJKd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fO0GU2oV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765934535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9boVk68kYNusC+MXtLi8MSVwKnke4dYwoVkCzCoc7c0=;
	b=OjrCHJKdYA6NbXXnUnnDaqkFSp/b2rDfl0LAVlpxUmnKsgiJen2WtV1W0PXRSd8KoVVYiE
	fD24n0T7jWKZ/loTdQz/EXMjG7sfrVfCk6QhUotOR8HO5FgklZlLm94RO4Fwqtdsm+RZN6
	MVMAQo+AH5M2oGayu4V/wGO6Twba9/o=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-GuI_XjmHPci2nbxx3eAhqQ-1; Tue, 16 Dec 2025 20:22:13 -0500
X-MC-Unique: GuI_XjmHPci2nbxx3eAhqQ-1
X-Mimecast-MFC-AGG-ID: GuI_XjmHPci2nbxx3eAhqQ_1765934532
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-34abec8855aso9636198a91.0
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 17:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765934532; x=1766539332; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9boVk68kYNusC+MXtLi8MSVwKnke4dYwoVkCzCoc7c0=;
        b=fO0GU2oVZ6FKjAkZU4V6va5pvqEWW9thNqJn8WH6C5UCjKAiapP9v+8j4pbYnqQpnN
         vP/vsCYmLxpFjBh89w3QdEv/Vt1fzQgsTiyL/Bii/ZXAQ/mDhz1RLs8ld4X9rQqk+gPY
         pYYf+5AzHoPWFgng9SFYjHQ7LEFfzf2yv9fok10G/6k4Gm8zHWkfJvyyHLdwROzKxQiS
         AQX/CRVORfrxBErAhf5WFFwLHCj7G1Da3nJ0H+wa8HRkxp3mrr/IOuFyauZboEDUnVbl
         jJ6C10DfFZkNk+5MGcm3zn2QuxbsFcp8KpwXpmyyqWtfUhqjpU3o98ZIb6QKJrSsZelU
         oOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765934532; x=1766539332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9boVk68kYNusC+MXtLi8MSVwKnke4dYwoVkCzCoc7c0=;
        b=XmmmtduFxqiqHW1Ze2g+VPoXgwnxIDVSZO+a1A0CQ7SGVvHZCPeMzfByVe80sLYMHl
         am2jtTYUKKBjQNu/ObLpOKg6r5v05fVwbtc6fjqGHfCRX/88w0hEkcO34I09Ww4Lfepf
         ug7zmFJsgU+W2L9E3VQjJBdTJOSXzfrU9ccgMLK1rka8UeBnx7q0aEDrp07sn6LNNQVj
         ZjeEUfXmHLAYnmGUsPp2WncVW5nFZAqHU8QTak5VU6VtDtlMbpCnzHyPUyj5WNoRvDHG
         /MGPm8Zv46ykx0yKEXnmoQZKjMxGNqqz+WCstJUyNes/tnJEjyw8KgbEoj0NBlo/qAYE
         c6Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXEAMcuh23t2uNyfkksNBCH2SkEeThC2sEMFXvtBtzs+YY5YK/XJqpMTtQiIyzICr2fMzs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVBemvtqleH6xJiMvsHyCY88GNmhqsn04zund6TY8B9Y0QRfs3
	VPybu4KfqwvpM7Cy8JLEj0i7Art29O29iBRqFAtORcpziuJRMGkAdZt46exe+2ln12KpKfI0NOE
	gBb7BpM5u1beSHdNb8xR8ZrnN5yU64BIcE3WQkXD93VcClnt09iFzq4nwJuxMSCkSUQe7I/6xo5
	b2pb4ftwdAqrYroY5Jgb3vlVoYmECq
X-Gm-Gg: AY/fxX6ArKt2e7TU1ial39jWpiIYqXMD3ntTZnVUaY4iIMRmc/Q7tkcAvPbZ7zDEMjS
	LlKf9Qd19ElEC/eLSZA8dJQURcDUS+cMhj77uNsbaq4GC3hQlEH6g45Fy2iSYV392rWrazKygFL
	f+LzoYy0PzDVyzHsZSaiEJZEjIHcGLpIxjl+cae7w/R9f6cMzxJjY6mdYLlpFAUTsnWQ==
X-Received: by 2002:a17:90b:1345:b0:34c:fe57:278c with SMTP id 98e67ed59e1d1-34cfe5731d8mr891202a91.34.1765934532502;
        Tue, 16 Dec 2025 17:22:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH2Qj1MjAZsaJatY38cVNtUzo65vJvXXqfgYjDc1M1txBuTCxEU1f06oaF/Mba6iW1H5lOe2BX+sqswTaGgyuE=
X-Received: by 2002:a17:90b:1345:b0:34c:fe57:278c with SMTP id
 98e67ed59e1d1-34cfe5731d8mr891185a91.34.1765934532113; Tue, 16 Dec 2025
 17:22:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251216175918.544641-1-kshankar@marvell.com>
In-Reply-To: <20251216175918.544641-1-kshankar@marvell.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 17 Dec 2025 09:22:00 +0800
X-Gm-Features: AQt7F2p59SvA8jqbLDZpsRBclL2mVEfHsYjkaUO7M68_TRk-7vqIcAO9BWf3AVs
Message-ID: <CACGkMEvgA-A=aZc06kc1o68Em8AeXmWPeRa-S=ziqWencpSk3Q@mail.gmail.com>
Subject: Re: [PATCH net-next ] vdpa: fix caching attributes of MMIO regions by
 setting them explicitly
To: Kommula Shiva Shankar <kshankar@marvell.com>
Cc: netdev@vger.kernel.org, mst@redhat.com, virtualization@lists.linux.dev, 
	eperezma@redhat.com, kvm@vger.kernel.org, jerinj@marvell.com, 
	ndabilpuram@marvell.com, schalla@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 1:59=E2=80=AFAM Kommula Shiva Shankar
<kshankar@marvell.com> wrote:
>
> Explicitly set non-cached caching attributes for MMIO regions.
> Default write-back mode can cause CPU to cache device memory,
> causing invalid reads and unpredictable behavior.
>
> Invalid read and write issues were observed on ARM64 when mapping the
> notification area to userspace via mmap.
>
> Signed-off-by: Kommula Shiva Shankar <kshankar@marvell.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Btw, I think this should go with Michael's vhost tree.

Thanks


