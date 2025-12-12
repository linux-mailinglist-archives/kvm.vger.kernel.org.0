Return-Path: <kvm+bounces-65885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E257CB9907
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 19:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6A4C730168D4
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 18:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BDE130217D;
	Fri, 12 Dec 2025 18:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AZwcHLoo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE50730277E
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 18:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765564042; cv=pass; b=oalr9X5GHOJgbqtMjLZ72u97Bulyug8Wc7jPtHa0qaaViUrm0JwrEsSVKAAgS8zWN5JCxnxoVRFPCEqHGlnXttetIE3K9JvioAgUiy1DGaCG4vZe+U7OPWtDsy1owOJxkIH0OhbLVQC+B3/FuAp5yvY5qFW1S4LaqIjtI9P+vfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765564042; c=relaxed/simple;
	bh=ZYbD5s2BLbI8MeUy7NCfgvLkDOCx06XEvbFRg0yMOqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W+oftm5WoBQ5oBiyU6XZQS/vgsWZmL1dFCYIpuocd1+uwZ0NFfa7Jv8zQjyCwMJ1L8ECYucIKWMSO4B/cgy8ZTRegIRvbB2CwiANqXhrIgwu548+aYPJfFqILI5XwAbNC/pMuOIuJgNCVrxc+uZtE9O65sIfphmyI6CPGepy33c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AZwcHLoo; arc=pass smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29f02651fccso306975ad.0
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 10:27:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765564038; cv=none;
        d=google.com; s=arc-20240605;
        b=PDs0ZwpnOnpGPdbghcUjq4JIFsqIYs2g65+wcy4plsouvyvZXN9DvGCq7bZ0qIpD9A
         xQAuRKmrb0q4iQ/dWg60g3KBfc1ITiF+ZjIt0Fd1QhEr6qsqAk0jXlAGvyuVGaqJJHqW
         Ns2iSkogH0IzZoquB9lcpfMbFNWEhE6DAKwqN0vFUgrBU94+VbJ+slc1HFrhktj3WDy6
         m7mMEDe1nQXGtJNka1suAyY8IsF0jqs0i2Q/KKmXtfzK0Ig7zTowchAnWuBvl0bc3CrT
         ySJcsuNQs5//9enz5X/BwTFaJtTEV1MWChKvUhj1UMf6nGUMQ4wdNG/LHW2xGUw/3Z42
         niKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NkZghPK8viXbu56gCwsQwiQOoaB5CuA66D4U7p8VN5Y=;
        fh=x3x9s72TxAsbTtBFeZi4M7MdoMcwgzWJzR9tRqeOCFI=;
        b=U90AYNrqOagMRa+6ZdbAbuivUyoU3kGmY50sdGXC9qanMbGLtjfOe1KMQHOntbX8a0
         dgjghQXdgMKHVQfki36sdEGhWmWdufuGFVtVw6F5B3yYsK9+oOX9tmRDTpLnwbBYOkE+
         7z9ETqa40nB7y/l6D8OP4Rr5u7tSC+0sbX23fMDDaLNvoIqxBmNkA2zQ2ArFPQ+EOIks
         cnZXhUKMfJ9OkF1s+xcdYe56Y+1XG2o35ECQBe3pWeOv8pVQ+8djkhIpt3EkF/RmhVWa
         G4KQz1i+cDQvdbqSJOC1Pmg4JYMFwg04hSnVoHpfU/1hcUldS8z7HxYjzuS2LLrCvi+U
         0QEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765564038; x=1766168838; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NkZghPK8viXbu56gCwsQwiQOoaB5CuA66D4U7p8VN5Y=;
        b=AZwcHLooUSE4vVuk4ym1gvy52xh6jlPpEPZ+NDjQWSleeKBQBsYw3ELoIf1r95CQAW
         N/AIXfIIxEBGPutzTOSZ3qzJGi24vAH2sF0dgcJXG1V3fMhUeps7fnGF2PcU5CJEr/3+
         VJ2EfVgPF8Wk/L8K+uuuUlUjPjovL5XvKvH+FhqU5j6Wl4RZH5iDa4sXaJNTbW5NVTzM
         pwzwseHR0q2vng91N9zjjtL4iJfuASy2hBi7HNHWi1DayEVFlhhR1LZFBsWES/ZLxsMn
         dXw36gSHR0DljZzhvsE27SoaW5fDv4Rk3G8zSdtACO5uJ6b6PcgLZ58KJaEZj53Rnec5
         s6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765564038; x=1766168838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NkZghPK8viXbu56gCwsQwiQOoaB5CuA66D4U7p8VN5Y=;
        b=qfRMkPiQdEiAZE6bclvn8wFSYfK+kICmK0T3afmUqFYHc2KSuwaEVBV+nbBiegmpyX
         06cr3R46PQbHxQ9S8hh2pY8aZH7sHBWQTGG4kn6W6UAwf3uJGt9hrLaXivxqrO7iI1i6
         ytJN1hEZu3eNUsHglPfBgU9ka9X2G8jfbtSXenUAN5jCjltj8p09pMwF0lznhWLTXVdE
         Au5hW16RL2q6o1D2N36dwwQrPabxGorYczORPqceXmC3UtQR9Q1H6RlR8ClFNhCDD8Y+
         sUFO2oXZ5kJ3NXqCo0PVtOh1EKmbBB8HOlyZ6XrRegDgovMJEb1z32cw5unTE/+b9B7V
         Z8BQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAUURQZgxANGxe/w5jjd0igBmfNp5l8X7GOyN+TkQZpeiaabF+s0uAXHRb7rkM8A7LXo0=@vger.kernel.org
X-Gm-Message-State: AOJu0YySBvR6aJREr9677RFjUV11YXQkdFUh3gB5NX7UPyzjyqtc0tEE
	7F1/bcbtSA093qZ+52EXgGcyWRgVGa77fhSL392qCixr5ddnhDoDqe3LEFUwdctfO/hT31n2pOa
	2D2FB+/BI9LPFaiB+dxnBNrNgTjHw0jw5eYyJC3Mf
X-Gm-Gg: AY/fxX6TBlno0pbBeYRqZoA5zLwRbCblcL8zRWo8PDre/Rv9kg6bveFMJfhm3odL2L0
	23rX8+kH8OeWB7wwPFUaQ4mldOkyVf2cFBsKlTWdHxREMa2oFcL/4CNviMz+0soND0Wgi2fa5F8
	LR+m5yYJrK/B6PYgWayLp/rsdrlL9Iil17wIMGidbWrZ5bBXwPTbOpDD7bg/Ch0PepFFb6+9Ic0
	3kZyMg+0MhbVLNnoNOcNOiMaP9Xi8KBtMb09NYgSFNZac80iaUu5IUhhcQ0WgcnttdG1dA=
X-Google-Smtp-Source: AGHT+IE8vkwPdXd5YtqFuKi6cZTlNeajvmp5hBP5RLuopyFVJ/H4cQgnuZ3env0p2MnZTOT/iM3kr99Hf37iXbds288=
X-Received: by 2002:a17:903:1b63:b0:298:45b1:6ef4 with SMTP id
 d9443c01a7336-2a09060d850mr42035ad.12.1765564037840; Fri, 12 Dec 2025
 10:27:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com> <20251210181417.3677674-3-rananta@google.com>
In-Reply-To: <20251210181417.3677674-3-rananta@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 12 Dec 2025 10:27:06 -0800
X-Gm-Features: AQt7F2paqjCW_yLgIBSgztw1AtJ7Iq40XTxchY-Yvj739u3-vqqR4aJT4su2flQ
Message-ID: <CAJHc60x0bKioh1cgE_KXWjxnDYC3H06RJ_0ZCsgd0q6SbaS3jA@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] vfio: selftests: Introduce a sysfs lib
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 10:14=E2=80=AFAM Raghavendra Rao Ananta
<rananta@google.com> wrote:
> +
> +static int sysfs_get_device_val(const char *bdf, const char *file)
> +{
> +       sysfs_get_val("devices", bdf, file);
This should be 'return sysfs_get_val("devices", bdf, file);' . I'll
fix it in v3.
> +}

