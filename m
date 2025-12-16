Return-Path: <kvm+bounces-66053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0008CCC0536
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 01:15:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8DDFC301B82D
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 00:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37E2021D3E8;
	Tue, 16 Dec 2025 00:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q+m27LXR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3EB1E32CF
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 00:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765844122; cv=pass; b=N7+tZ3eDtgmO/AsgZX15vHkwOdhIWegUJ/H8ikbafBe8TWwajt8rNtLsllkcW73rrP29wzZHpUAm5Uvxyt8AmLTIGGS4zDkFHWMuTjQCm7pa4EGum+V6AWT//4tiqFnoPEG8sswuodYsKRp+zam4T+c4N48O85VT3byYtsDqNas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765844122; c=relaxed/simple;
	bh=fn0GwhoNH8+ZzMJCJ3+pwW254YPaPG3Wl453zVROsYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y9xqAgQHuhdOPG+fYMHOUkL37IB0bJGBGNJhD4RX36BZMv7WKALX2Tb8c+OCqzqMszawkYAHdb0SzDbQoCb7MB9eMlksYkha8ejx2lw5RmfmxZyFiTU2z4/hve6b9p2eH5GZvzoDg9JpkBN2Et7Ykhvo7lRskkKkyQIC64+ZObw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q+m27LXR; arc=pass smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-29f02651fccso39905ad.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:15:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765844120; cv=none;
        d=google.com; s=arc-20240605;
        b=akkSZPNNn1IvcF6eoQ1Ozuiei4XczxhZLBCeeODrUTDVv6gxivi0GZeWzFHZDLypf4
         W3LRxKskePm6wCooRgvKCXaggYdjp04Lf+iLlwX50Q00E5744rcvRQ5Q/sGANUYWSjtG
         sR9QXDgZyQJ9XoOj8XTVI50QqsKgjoxdieLhzNQc8fzz6bY5T03lNx2bDvfnBqmo1MIB
         /DUdufXrLCGLKGBqoAGJ1LvNPLzPxSUwt38Q3r4U35n2GTyrbxtvcQFRqghH4MoHdBGx
         0cy1Zq1n/Osd2mIRX80hNOTT0AbYsIASdqSx5Sw4fhzIhteyCBNcNmWzsChs39Txhh28
         N0rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fn0GwhoNH8+ZzMJCJ3+pwW254YPaPG3Wl453zVROsYE=;
        fh=f0Sa/Gk6aV+Q0XgvPyFCasN4iiurT6FrEyCiHiudOJM=;
        b=CLLX/SQdxSJhChiIAC+r0/FQa7KuIcxFHAiv3tV8jdzf5OERog7a6yZhd85+/lbJFs
         tBZEX6W1n6vYjxEI9Sc/U81Y3IcNGRz4P6nKQbiWn6fKRop+GYFV+J86ShSHVPjgZqWs
         /2R+yfmY7l7n3RnLNbO9KCJ3T6+oFE0W7R3exayktMNFz+Kbq+YOtLtoJqYgr+SGxa9e
         ExfH7GcA64hn7iDtmwItnO0VJsslly+Z0rsWqBgBpQcJQTLCSjul7sJO5u3pPn0Itlyu
         PbZ1gR3maCuBjAGFFvzot0hBsTlQ1+4nTWtOnNWWm6yyrS4JQBejUTqSmFfoE8ZMeQOj
         PKVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765844120; x=1766448920; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fn0GwhoNH8+ZzMJCJ3+pwW254YPaPG3Wl453zVROsYE=;
        b=Q+m27LXRO1eBWTGbGiP96BgWLQdmS/3LtacdK5YYaH7navUJl23xCCWxEYD/HP0L0h
         FbJu0lhAuU8/xgV1RDx5kXQUrdCKSUTKeZJwEoSSq3m/JpBowpned6Yg5BBROcB1k4Kz
         I8zvLukkPHgT8Xv9ArkjtLqxm8iqXUtOwBIAb8V63IZ+VP3meaiwUp9Dh0B2Z3O6wO4R
         ZbzMeHF6t3KcN37BS4AUuTZR5LP2QilVcFeGqhZgywhi4e3p/QJJCENzKaGSZrT/ArG5
         WgNh9V02brOrZvgEqHqOaYWXIfM6F7a8ZTY5nKhjxpVEb3pnc3gqAf2skM5QXlYvw5qW
         11jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765844120; x=1766448920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fn0GwhoNH8+ZzMJCJ3+pwW254YPaPG3Wl453zVROsYE=;
        b=jubYts1qFs4iehTDcw7+uFgBv2YOZSVD8jlgGBggQheKgWadsAD3i/jLFWlC8tN22y
         44xGWXhV+1wipPq6vUWwzPIJExLUs/RBPTNKNESzShmJRYFolfq37XoagjTGgXUGW4c0
         xz9lZuo2nlXdClXzrLRZ3MInguOYTJU9lzDgnme9pxzD26tRQNgeqbmfdO+uAiIU/NpZ
         tiX117Tmq5NHHTlg5zsPD+VnBdmp+BOtO3MOcFScTMRCoEinEzw0rIQYXmPPWinzZAUg
         DFkvqiKE++Ng4aFEBX9BTnCAWNS1gtMcTVSCQbA4upT/Yu/adjt6DL4AfEkatdNh+A2p
         Gymw==
X-Gm-Message-State: AOJu0Yz8isDRVC3Zb2yMqy8gm/RcuUCqsu3nn+ENY3JVPwn0VRbV28Qq
	1BXri2OYKAVcLIoT63ooYxtPeGxTtjBtG/A0StuJvuXkBX47Bf2GiB54VQlHTg41O1B2wWZHHvp
	4IxQZJNkei18Q4ojv1CpfV0DfJ8OIkE2lGH3whGJR
X-Gm-Gg: AY/fxX6dnvHiIQQGG+iNCL5xitztLbXmuCCiGfi24UAkDM6kddeYKegutFnJwZoiluU
	jUx9U+6rPaEEowbYc5CgCeotqTHSDWaxURIjChdA6cZXGeqUSlUQtqhxWx1qCyat0WIQqtH297g
	g6aGayXuskSc3M595Ik9STstEaJpN4wYc6ZfswQmDyqIRWyeoDce/4OMsi9I30VWZRBXw9RVuS0
	cATmzpceNgjByqXYYa+KuYXcJAWEohqDaYX4ywYVlu835u/D1tMYDXRxFpEIMF/kpTsNwZYMMzE
	yXEcXn+otqolyYAObmPZvtB9khP9wsfbRU74RUI=
X-Google-Smtp-Source: AGHT+IFTOP4Gaoei4VRS4FRMsmoH0dQfq8ttEHezcqkwMWBciDm3nDzocBxJhP2cIEsjUvXgKDFs3tmzZw+Z/7G1Pn0=
X-Received: by 2002:a05:7022:3a8c:b0:120:5719:1854 with SMTP id
 a92af1059eb24-12057191931mr3515c88.18.1765844119264; Mon, 15 Dec 2025
 16:15:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215153411.3613928-1-michael.roth@amd.com> <20251215153411.3613928-4-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-4-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 15 Dec 2025 16:15:06 -0800
X-Gm-Features: AQt7F2qPIdqB4YBCefT1YU3kuQHJVylNF8CoP-Km5GjS1ybCK24n-Ma9vuvP0QQ
Message-ID: <CAGtprH-_8gKzLGkU8HN=D54DDffk+mCj_7ymyexN1aDSS31fHA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 7:35=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> In the past, KVM_SEV_SNP_LAUNCH_UPDATE accepted a non-page-aligned
> 'uaddr' parameter to copy data from, but continuing to support this with
> new functionality like in-place conversion and hugepages in the pipeline
> has proven to be more trouble than it is worth, since there are no known
> users that have been identified who use a non-page-aligned 'uaddr'
> parameter.
>
> Rather than locking guest_memfd into continuing to support this, go
> ahead and document page-alignment as a requirement and begin enforcing
> this in the handling function.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-By: Vishal Annapurve <vannapurve@google.com>

