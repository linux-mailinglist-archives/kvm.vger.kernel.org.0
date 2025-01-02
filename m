Return-Path: <kvm+bounces-34504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A07D9FFF6A
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 20:29:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 816733A2A90
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 19:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C431B4255;
	Thu,  2 Jan 2025 19:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fwHl1Brz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0592187342
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 19:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735846149; cv=none; b=bfMoIVY5ygXeaDgsAtUFSKNkdz1m1HrkOS/5Shety/MnDXidkDvGiHwDUB2KWJkeroQyLLb4SQuoSDZ/XusECLiBccQ8+8t73+XVrf8fb51bBoY1hNZ8X0AyXZc403Oem/pG+m6R7nIOhgvRuSVd1KXqetO989bPWqF2NN2cLrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735846149; c=relaxed/simple;
	bh=GWdEuXg3WUDZDGjGFdNsNR/oBNnu0D17oPDtWlVfFM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ugwCIIN3aFqpZKNV1+i2eXow2afLwb2LOKin/if7ydakyyYRQc9QaNm2PEh9iomoi2Ip57kMMro1ZsUXmsqoE86DJTUcCQxgNTvrukV2juwh2z9K0L6Fass5LnVKaFFFiclVRZUL3TzEPZDSzJwi5rT3xlXc48L19umLrqP6ivM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fwHl1Brz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735846145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PqrnXD3+1RR06iBvi9uXmFy/HWAjf6sbg1PXAd5cQdI=;
	b=fwHl1BrzAaAO04umyYju+L7+TCrfOXtJB6RN1q7hhPkANI7ZgQTOVlgMkwxpsB/A1QpxTO
	BmX55VkVjGuGM0PlLkJ4H46Chwm7Qnuk580kcg0lta1mWmd6fgkD/BAKx0q5qlppxaOwZF
	FR6HvZ6ItPARuVCZKEGv4yR/g4BNmnE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-5BLO6u_dNm6-XQrhSJEIug-1; Thu, 02 Jan 2025 14:29:04 -0500
X-MC-Unique: 5BLO6u_dNm6-XQrhSJEIug-1
X-Mimecast-MFC-AGG-ID: 5BLO6u_dNm6-XQrhSJEIug
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6d87efed6c4so190945226d6.1
        for <kvm@vger.kernel.org>; Thu, 02 Jan 2025 11:29:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735846144; x=1736450944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PqrnXD3+1RR06iBvi9uXmFy/HWAjf6sbg1PXAd5cQdI=;
        b=EYWdZuR1GAqQU7GXae/55P2NjXmqDivxdox7qslUTFERmBGKZ+cP73D3JUCyMbsimI
         oNAqIo0NvAgQRS7KQfdzt66pdkeVIAsrtZVd6ZMbRPY4jKmDC/VcY5KEn0+5ZcmQQV/M
         kL5qdxliV6al/Z2V/RzOp/E8thCN5nS9lDMoBJlHhrKTHE4BgXb6+DL8yN4SJGjOP47a
         Fgl6incVFmCI96tYs6IVI5/f88ELvOTe9+xC+ypNvsuTvvuHoXU8wX/Gp06YLG+QtDq9
         yVH1tN0Gpj4j8k3k1bwIgiNbajJBSw1CpEvjt/WDSU36+78Mz1bo+Z2bYqIKWOIxNiQa
         0k0w==
X-Gm-Message-State: AOJu0YwpRGhWRaOw9Ef6HQ5YGLP+TDgG6SOSiRY4pUieMsnwqaOivbrO
	VyEX/L20f6WOiFQbEuaa7kHbeH6YnmdfPwt4Ju9bKDC6/RqrQJc7ObPG50yu8vGesCIjKpJxAu1
	d1c6V1nSxgZnblULz1hD1UTw/KhDCPNFEtyHnBn0gOpBR3JNYsA==
X-Gm-Gg: ASbGncveeN2gBnq14xy5tnER/uQ7Rtqdv+GXlnWE5YqZLKwtUvB1nyfgB1mvpMnmuTd
	D7ReH2W1jJSYlrRECWivEkurGnKOgQneAcCrZznI6RRamHPJQojvEnTHc9p4YNGxCfp/RZfRy7f
	NBkM4gudCfzTSzF0cm7aoQI8YFjOR4GF6l3UIJbyn2qIsFWSxvVxceBUrPWUws10Ckeh9xkfBZK
	//rIjEYaGOO50eaFZ5CdRenKZJ4cBD54THux+y+LgkRj96BfarKg8nT4+95J6ZN5r7RPoxjT3Qk
	EihY4d642yJFhMITeg==
X-Received: by 2002:a05:6214:dca:b0:6d8:aa04:9a5d with SMTP id 6a1803df08f44-6dd2330bad3mr754637406d6.4.1735846144015;
        Thu, 02 Jan 2025 11:29:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpdC/2YXkIAOTi4K3SggAQlhXdABeSiWVvsv/qQ0FgTGnzpIL/OI93lXM53tLkNbD4XLXwkg==
X-Received: by 2002:a05:6214:dca:b0:6d8:aa04:9a5d with SMTP id 6a1803df08f44-6dd2330bad3mr754637166d6.4.1735846143772;
        Thu, 02 Jan 2025 11:29:03 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dd4194937bsm100205756d6.95.2025.01.02.11.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 11:29:03 -0800 (PST)
Date: Thu, 2 Jan 2025 14:29:01 -0500
From: Peter Xu <peterx@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, precification@posteo.de,
	athul.krishna.kr@protonmail.com, regressions@lists.linux.dev
Subject: Re: [PATCH] vfio/pci: Fallback huge faults for unaligned pfn
Message-ID: <Z3bo_TNnwweOH5cp@x1n>
References: <20250102183416.1841878-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250102183416.1841878-1-alex.williamson@redhat.com>

On Thu, Jan 02, 2025 at 11:32:54AM -0700, Alex Williamson wrote:
> The PFN must also be aligned to the fault order to insert a huge
> pfnmap.  Test the alignment and fallback when unaligned.
> 
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=219619
> Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> Reported-by: Precific <precification@posteo.de>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


