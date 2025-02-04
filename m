Return-Path: <kvm+bounces-37251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EA507A2781F
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 18:17:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14EE97A2552
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338AE215F5B;
	Tue,  4 Feb 2025 17:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CWGiKwIj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E10E175A5
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 17:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738689440; cv=none; b=cTh/2Vng4Op1HBFNCtv1P1ThJEf4ev2142SsuTB010jjyFd5flLVLAYb2okXEwoSE9cBsahc6fjOLrNRtYRqNXqi3O5MBvxPeqsJh9KVkmSti/2HEH3qMGN2+YthkaGko4plDgIkUnqA2ev6mMQ+zp1O1lHmG6lgXsSrpGyJ1Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738689440; c=relaxed/simple;
	bh=YJAv8v+tnPU2AiOy7U9M+Cw5XN7fGQIqVXVhQli3vSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZdFQ3CtafDsAdi2AdfTbUzqechq0Ad0bcsRYnnaJfbQmiGQ+0vGBiE6ttdGrM9ITc/LWFtkkjVSMsMmOta6hvbLcypCGUlwRuyaztDpEt0T5wk5xj/3+8uAuXkjs2I4zTzTOB9qaIUIBit6I9+zW4zg3Un7MfUe35fp4XxNTx6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CWGiKwIj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738689437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EF1aKWjXDK0s5pYyzWzruFk/aZgJr2WHBwIj97Q+fRI=;
	b=CWGiKwIjGk2a1nZSY6qpn8OJA6cEzaNTeGvaIFbMa6Uq4OtptVcsUy58YcATyQ4N0BEFvN
	ekkprJFd+dj+/UZ6zwZzzxBljb3ffpu9QP/kzCVxPP82LYqmFbpCRlLrlnvmwkQiBIlKnm
	R+ZEmNaGaQyeUhULDdaPyCC9LrORZ6o=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-QSCAzwIhNdKqb7WGa01zjQ-1; Tue, 04 Feb 2025 12:17:15 -0500
X-MC-Unique: QSCAzwIhNdKqb7WGa01zjQ-1
X-Mimecast-MFC-AGG-ID: QSCAzwIhNdKqb7WGa01zjQ
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-467be89d064so63398921cf.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 09:17:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738689435; x=1739294235;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EF1aKWjXDK0s5pYyzWzruFk/aZgJr2WHBwIj97Q+fRI=;
        b=EOttufkfzGwEASkec2+GgUilb9cX7Jqrm9d67cYHPSF8i5yBjgwDwJeLnGyVK2f4nD
         V2pI7VY5ZNMLJ9RMt/pgIodnYukxRgSkiMKXcnlMZLKdGQXXRDCG2tLOBkMhGLilkW7F
         a9cofs5UeSf255ojgJ9UA8+IbZ4MIWWqDJ+jO94iDnF8au7JlquTxoy5g+bEo1tyuoi2
         0WFTmwBLwQZ1t49W/rlRZ1MRZL3iPyA/5eqyFqX27AMpbuE1zC6VnL4QEF6kbQffC6z8
         xE6iqK+i5pU6hHFuYqZd6grEBUujRQHbtNHvlhEJBoTLOudA3gfZDBt12VaJcmhi7oky
         /WyA==
X-Forwarded-Encrypted: i=1; AJvYcCWjN6MrsYSFIxQHaYF0PkdfbhTK1n/oI4izMcB4nNyOrtJmx8wL2Nk85hd8iHi85UIq+7g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCIieHLvY1lGB9QOHF8AFvHP/izamJRmMF3Jw6SE+tmiPMwI8c
	qXpX460b0qlW/RqZgSCXGltlZIva1D3ScP+CLJqNFenwj4oyDz9QPtDQnNNoH7Vxs4Sz/z9JadK
	9H1yMcJDF9tUvvH4ajQTy3OCDiEwwXm6Y6hLdIx5mmReezhzKkw==
X-Gm-Gg: ASbGnctgBl8RU7pZtHYYhwqr2DSsbqTtcS7dPlJqqmo5XPWNZrok76iHwajuNTdA2lJ
	8k0M51y3mSPvqUrS3VgR1eFWsFwrAA5Gtuohns54el3SCH4+OL8jVYap8BgsEE8mrTGkjHXkmX1
	g8FSIA0j+7jbPJ70iXXK8/Tr0s/i4J27fADouYMETdXCkjB9dHw2Szq/wlvMS1NUzuVWXt5hu6K
	C0NcVKo71x8YRRIJ45SD6eQS8STC+d052C6bnWNvLKcsHwslL3x5xUO+O4vfLLRtir+N+8IlD9y
	O1Hioe/gzR2fbvjHTUJNsVlwltEdkRVIm2HE7RZv+1aLRlJ0
X-Received: by 2002:a05:622a:1a0d:b0:46e:548f:ab8d with SMTP id d75a77b69052e-46fd0b68d36mr371888561cf.37.1738689435393;
        Tue, 04 Feb 2025 09:17:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMZrkvUzANp+Vtn32tNv8gwb9qdGA0LKFSlOhffU2oEyMLz/aqkDnaQy98hKUID+Nqtbqa3w==
X-Received: by 2002:a05:622a:1a0d:b0:46e:548f:ab8d with SMTP id d75a77b69052e-46fd0b68d36mr371888011cf.37.1738689434987;
        Tue, 04 Feb 2025 09:17:14 -0800 (PST)
Received: from x1.local (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46fdf0c90d2sm60982721cf.28.2025.02.04.09.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 09:17:14 -0800 (PST)
Date: Tue, 4 Feb 2025 12:17:12 -0500
From: Peter Xu <peterx@redhat.com>
To: =?utf-8?Q?=E2=80=9CWilliam?= Roche <william.roche@oracle.com>
Cc: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, pbonzini@redhat.com,
	richard.henderson@linaro.org, philmd@linaro.org,
	peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
	eduardo@habkost.net, marcel.apfelbaum@gmail.com,
	wangyanan55@huawei.com, zhao1.liu@intel.com,
	joao.m.martins@oracle.com
Subject: Re: [PATCH v7 4/6] numa: Introduce and use ram_block_notify_remap()
Message-ID: <Z6JLmG8srpk9_3Jn@x1.local>
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-5-william.roche@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250201095726.3768796-5-william.roche@oracle.com>

On Sat, Feb 01, 2025 at 09:57:24AM +0000, “William Roche wrote:
> From: David Hildenbrand <david@redhat.com>
> 
> Notify registered listeners about the remap at the end of
> qemu_ram_remap() so e.g., a memory backend can re-apply its
> settings correctly.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: William Roche <william.roche@oracle.com>

IIUC logically speaking we don't need a global remap notifier - here a
per-ramblock notifier looks more reasonable, like RAMBlock.resized().
It'll change the notify path from O(N**2) to O(N).  After all, backend1's
notifier won't care other ramblock's remap() events but only itself's.

It's not a huge deal as I expect we don't have a huge amount of ramblocks,
but looks like this series will miss the recent pull anyway..  so let me
comment as so on this one for consideration when respin.

We could also merge partial of the series to fix hugetlb poisoning first,
as this one looks like can be separately done too.

Thanks,

-- 
Peter Xu


