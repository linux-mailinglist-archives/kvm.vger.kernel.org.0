Return-Path: <kvm+bounces-66056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 548EECC0570
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 01:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F06E301765D
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 00:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBDA23958D;
	Tue, 16 Dec 2025 00:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pn48TEFL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7001821CC55
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 00:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765844414; cv=pass; b=DAA5v+tOYjqDN5OIocAiCIzNpEOWxrimTJkviuUufT/PAikQ970vGOnG8l9ZIJ9lnYdKdacolhNBPIeEuXMV6jpI0oUI+EiJkqfDOzSmrIxGLEgIU7bexDTVa5jGO4zKrktQmm4MIUT7jJnhT5uKLo2errkIumWEZDPz2+P/FR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765844414; c=relaxed/simple;
	bh=klRRPxxRucOBsSf0NKoOGV1TNHKMWWUVg9IeOWd5Sg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hHRAwi+RHBfefoTArOroTgQEpP9Mv/d7TE20QYHS//JUAkXSQOeEBLGIOdOZu7vs3WHRDJD/yXwPrYqh+2tMkXgh1YzDJLDM3qMa0Kq+mOBXcElQPEKxJPQ4/84S6dm6lTmqz1XTffbLyOZWxDsdGLNtUeyUS2cCdJHIH3ZBndQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pn48TEFL; arc=pass smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a0d06cfa93so14055ad.1
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:20:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765844412; cv=none;
        d=google.com; s=arc-20240605;
        b=BSM+iZKYKd2B452qEyWg2UNpgg31QEsU/oP1oAOBVt5Tarpo9KVPB3C5qpelmbiD9a
         VkALRuerkHwsT1WQFuhn32IMzDxNORjTwW1Z3Q667gNRu2+j1F1ERBjupF6gYagNcPYi
         aLapm4yvPfESsNk6X7HzBX+K8nOBblUx6NJMRToU5P4Vnis4BOuWhOApitDwcy7bAJ/u
         m5l47Zj7l9jM37F6JQY9WWPrXV6RHc+KAS6uA3LT2zWSdjh3YoNI9jS9qtiYO2Fydleo
         SDOILVNrxaw65xrEs8uUqjfj+f9N5tS0JklIBa1lhxJpCQHK6Z7f33eNbYrKuBlN54PW
         2LGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I/xSO2loElEQu4qJwQAmc4hWblw65frcVfwyqUV19Yo=;
        fh=f0Sa/Gk6aV+Q0XgvPyFCasN4iiurT6FrEyCiHiudOJM=;
        b=Fbs8fwfXUbl8yrxTOzHxz/GxWhso4Bs3o74AnAYpRUWx3PrkoC5mkd6VExpujDOaqS
         Vjq9M6s5s+wj8hzRFC+9+Wx2xlCFanxLgTUCJYOgh/kPAO9bY3ISfpWy3CDFr/T0QUUv
         DrIhkuOErcbq2DEpO7/n81tcaVI4dPOBV7KMsy47n3vj1GMH5ZLyvhRq59dGJnNMTxOu
         m1VXRJZilaQXZxILklADgX4Uqamt3c3KGf4VSlYXefWtk5KA8ehO4L++DVo8enLsj/OS
         jOCjktOxgnhaEfKXJjI28v1oYx3Q9DJmM/4Jiqzgwwwbzt9HYqiAkadWltQuHG2G1skG
         Dfhg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765844412; x=1766449212; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I/xSO2loElEQu4qJwQAmc4hWblw65frcVfwyqUV19Yo=;
        b=pn48TEFLSThmF9DTzsd9Iv9MSeYklUO/W+DPNtPJLKBPP4jp63qVIT2NWydyQ/F38U
         nNpAPnLgp4Ay42qwgI55/9+gxN1rld/rsVI7XDL4x8oiWKfraqpuvBDjqhXd4kGw+9vu
         fxgwe96Fi/9sVJeSbpNXyo8bymNQnNi2E6tQAFUSrFRvu8CiXnPugXkN54bGP9X8RIva
         bqIvVJcQqAy46vzPIeniqcIob3jXW202w829ek8Ryy187n8Ffb8PoDycY7p7U0r1x/xc
         PHDIcjfNC3oaCtNrEPPYP81HWBzE3+khOA8FVpPymRM2spTNgm5jRlKdFOKheKmII1Ul
         z0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765844412; x=1766449212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I/xSO2loElEQu4qJwQAmc4hWblw65frcVfwyqUV19Yo=;
        b=mJsHaYAQAhgDiLp0UCeOUzYbIJpOKl9ikSFAD+u4ohPFZPaYM48n9OXtKIL3x1RBm5
         tqbBdjam2b6+axsvFb3AFgCekeKAXQTP9hlHzdrT6AwQCpwuAlBF1TxKC5f4n0o1Ga5R
         fW89NBAwsOzys8xnU0aArQGKvxndr0nxW7g/iLAbUdo3ToY38Nry1jv8x1wtdEdl2Xyi
         00ADhDVSssPiv7J9njYugZeWb8z4lu7X2Y/K4Ot3WeYVpj3pu9OUukm+VXNjpo3zNDah
         tInhRpqVnd6+4cLOkCq4MhzA0WldSurLO3dLxDPkyQujOjzA6ojNIaoXeuhjrAS0q2tK
         1Tbw==
X-Gm-Message-State: AOJu0YzE1+lIlODj7VneS/aJ2xN/+lbjT1nqZAGOEzznj28a2TFZ9z6Z
	671/RmolQinY9VubUUiALAMjdmBw+5JLTrStcG08fgr7Pzd1CQBOWomOiU9FOacAQr4JvsfeQVS
	EWQA6cHClkXvRdRWyBQOEDvi6hZE060+sOdofVpmPz6ikirGv68wiIwk/A+I=
X-Gm-Gg: AY/fxX5c7bRixjk4mCz/Ags6iGBvYLAT0iN9s6Eq0Os1UU5uYxvd2acK+uYGBytssWT
	+Li7iHKr5KReSgrF+4UV5VNXdyWM+qxSg27Dz7owNKTC/JgTUOGZmWsnW0t4MI9nVllHh3sv+OO
	nTgx2LtWLfl4UYbWfSfXrNJdppJ0+2gTd4FtKTj1Z6w8Tdelxx9EssAB6Jfk1rRYp7b3P6YLpsO
	lZLILUr8M2ssUSIQjnNtka3e4epgl7RoeU7wT9y9+EIGeiGr33bgWHqAu8l7XqwEevRHC4O7VTV
	vqW0mJMTCWRlNPxl2x/j8U44BT+e
X-Google-Smtp-Source: AGHT+IExDYh7puOwTqAoucyAbhg/dhJj/UlPMmB4InOhmz+VivF2pgRZLSSnb0+pKynoL6YupSskmHHY1LN9azC6BtE=
X-Received: by 2002:a05:7022:4406:b0:11b:3bc:9ea0 with SMTP id
 a92af1059eb24-1205727676cmr408c88.6.1765844411980; Mon, 15 Dec 2025 16:20:11
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215153411.3613928-1-michael.roth@amd.com> <20251215153411.3613928-5-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-5-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 15 Dec 2025 16:19:58 -0800
X-Gm-Features: AQt7F2pam8UulXqTs359SLpQ8QESA_W2EL2-JVHHwFHsPgJIIvSeUBgNcYPP6kk
Message-ID: <CAGtprH-te9xrmVgUteAaW17BLuxfZWfu32G4Q+AdP4=DDrm27g@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
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
> Since it was never possible to use a non-PAGE_SIZE-aligned @source_addr,
> go ahead and document this as a requirement. This is in preparation for
> enforcing page-aligned @source_addr for all architectures in
> guest_memfd.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/vir=
t/kvm/x86/intel-tdx.rst
> index 5efac62c92c7..6a222e9d0954 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -156,7 +156,7 @@ KVM_TDX_INIT_MEM_REGION
>  :Returns: 0 on success, <0 on error
>
>  Initialize @nr_pages TDX guest private memory starting from @gpa with us=
erspace
> -provided data from @source_addr.
> +provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.

Reviewed-By: Vishal Annapurve <vannapurve@google.com>

