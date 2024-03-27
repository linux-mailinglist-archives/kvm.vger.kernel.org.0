Return-Path: <kvm+bounces-12865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C64F88E6D4
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:44:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35FB62E2BE3
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDE013C9AF;
	Wed, 27 Mar 2024 13:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="OVJiNbpN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BEA12D20B
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 13:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711546316; cv=none; b=G1R7YWBt6f6TM78oiMVnSGidvleswZlKh6USoojTjQnqW44xtTadDHOxSjBOe5zeMrmdJlXj79KEuF2z4G+grdNShUIaJTJbvioC/MOmjRI5LhwdVhZmx9mkAIn6O5ns93Hj68h976dnwSV6bV5C8n6dflybFQihFCeWcCC4/A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711546316; c=relaxed/simple;
	bh=TD26m/DLND//w/pHxnklGDYj+DbkjRVmlBGGnCbzHMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LuX+ECycYPyG9eA+4bygZQagk7Vb7RglqethLA287w2txLZMvxzmy6AUaApt7eZPm+211O7tiwi9uaMLQPRXlLxztzptmXHMly9PO8uQNQAoyQE0GjY03osv1UGj7LsAz9R5hxEsKHY22k09s9xQe3RNM5oMD2BDMOTh/Jq0pqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b=OVJiNbpN; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-414953ec671so3173425e9.1
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 06:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1711546313; x=1712151113; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ry50isKBz7xwB9eIS98LGGV6NnwE9fBPbss1bZmyVbc=;
        b=OVJiNbpNuXOWMLWyTULuKkLaoKiYnBUFOeB/97hvV+vtNWTuIQpuwCAhgq0NFpZvBH
         FtAChWCbzazLRf3qeEykcyDwfQ5P2sJX6ZRHuI/6tvvsls2yubXnTwYlbT/jZgbo0OeR
         XB5QRNdHwNnjCoDJ4Fem+YVt5HOCC8TvwcHXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711546313; x=1712151113;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ry50isKBz7xwB9eIS98LGGV6NnwE9fBPbss1bZmyVbc=;
        b=oy0VsqGMUPm/e2gjMvlauGUW3QbOdP4SAWRCHLYS5aFgqdeyBM8YW/geCrhscCrBbf
         AUhapw5uGXodjxBNfjnzd/FgI0keThJzKcPWAPD/K90jl6mVlhWa4lf1U2FVLGOxyIXr
         9PLD/mrczo/XLHnp982VKhK4kTUrEp7l2PSw+2BG6PduLGbVOaG/iiZIbjUWn2CRCf3E
         15qFH1ZNmnb9FNe6alRwnMFmQb/hxRxzOiKvZP/w4GK+9CVllDe2VHHj2KRgON4oiWg2
         0dshahYF6JIyZQa7JFgWO3PX48SPfgZ2UHve1wF2pL6H4A8kkRFcGqYJtOtBhrJzbyfs
         MAug==
X-Forwarded-Encrypted: i=1; AJvYcCUNV/kEK2JDQ+7aWY7rOBvx81Jkw0BlkReik3upohZRhhnQPXs1hBjOmKDIv2nxhFdb3S8a+b2un9uM8lCOHEiC07Vt
X-Gm-Message-State: AOJu0YwFZ2aOPRn5rETH+BA7aEBUvJIN+jFVqOSwGTo4hOthvfx5qYlF
	tkWQ1qNWqxso32vJYDVUSRAyvOFqhHQ4d26gcHykh9PgOFxiA6Zmq9GwN/JD5GI=
X-Google-Smtp-Source: AGHT+IFYIuYEr12t4v0Td8b3I1GnsgGQezqwN6hoZoxCPeltmyQmrmwtG5G0fLSfp8l9b6esrVdj4Q==
X-Received: by 2002:a05:600c:198a:b0:414:8d7:8292 with SMTP id t10-20020a05600c198a00b0041408d78292mr52993wmq.0.1711546313427;
        Wed, 27 Mar 2024 06:31:53 -0700 (PDT)
Received: from perard.uk.xensource.com (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id j28-20020a05600c1c1c00b00414807ef8dfsm2209230wms.5.2024.03.27.06.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 06:31:52 -0700 (PDT)
Date: Wed, 27 Mar 2024 13:31:52 +0000
From: Anthony PERARD <anthony.perard@cloud.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: David Woodhouse <dwmw@amazon.co.uk>, qemu-devel@nongnu.org,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>, qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
	kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>
Subject: Re: [RFC PATCH-for-9.0 v2 09/19] hw/block/xen_blkif: Align structs
 with QEMU_ALIGNED() instead of #pragma
Message-ID: <76ae46e6-c226-49d0-890e-c8fd64172569@perard>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-10-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231114143816.71079-10-philmd@linaro.org>

On Tue, Nov 14, 2023 at 03:38:05PM +0100, Philippe Mathieu-Daudé wrote:
> Except imported source files, QEMU code base uses
> the QEMU_ALIGNED() macro to align its structures.

This patch only convert the alignment, but discard pack. We need both or
the struct is changed.

> ---
>  hw/block/xen_blkif.h | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/hw/block/xen_blkif.h b/hw/block/xen_blkif.h
> index 99733529c1..c1d154d502 100644
> --- a/hw/block/xen_blkif.h
> +++ b/hw/block/xen_blkif.h
> @@ -18,7 +18,6 @@ struct blkif_common_response {
>  };
>  
>  /* i386 protocol version */
> -#pragma pack(push, 4)
>  struct blkif_x86_32_request {
>      uint8_t        operation;        /* BLKIF_OP_???                         */
>      uint8_t        nr_segments;      /* number of segments                   */
> @@ -26,7 +25,7 @@ struct blkif_x86_32_request {
>      uint64_t       id;               /* private guest value, echoed in resp  */
>      blkif_sector_t sector_number;    /* start sector idx on disk (r/w only)  */
>      struct blkif_request_segment seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> -};
> +} QEMU_ALIGNED(4);

E.g. for this one, I've compare the output of
`pahole --class_name=blkif_x86_32_request build/qemu-system-i386`:

--- before
+++ after
@@ -1,11 +1,15 @@
 struct blkif_x86_32_request {
 	uint8_t                    operation;            /*     0     1 */
 	uint8_t                    nr_segments;          /*     1     1 */
 	uint16_t                   handle;               /*     2     2 */
-	uint64_t                   id;                   /*     4     8 */
-	uint64_t                   sector_number;        /*    12     8 */
-	struct blkif_request_segment seg[11];            /*    20    88 */

-	/* size: 108, cachelines: 2, members: 6 */
-	/* last cacheline: 44 bytes */
-} __attribute__((__packed__));
+	/* XXX 4 bytes hole, try to pack */
+
+	uint64_t                   id;                   /*     8     8 */
+	uint64_t                   sector_number;        /*    16     8 */
+	struct blkif_request_segment seg[11];            /*    24    88 */
+
+	/* size: 112, cachelines: 2, members: 6 */
+	/* sum members: 108, holes: 1, sum holes: 4 */
+	/* last cacheline: 48 bytes */
+} __attribute__((__aligned__(8)));

Thanks,

-- 
Anthony PERARD

