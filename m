Return-Path: <kvm+bounces-51279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB27BAF1021
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 11:39:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAE6D3B8147
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 09:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 749D8248883;
	Wed,  2 Jul 2025 09:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Cwh40Ej9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05023246BB3
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 09:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751449113; cv=none; b=O+wQPALmS7SIC9zQWhgW436T7Vp8DifeV33jUnrYq8YTpRt5LQDT60vUDhBaagfFAc9FLI58kqTSixjvE6SHkljtuvDPfNMN90ZuXrRjV6rlNIIkdnQvQ5rNcirLk7wXl7AoKjlQZyfJI49hhv9v55QsMXiNOyDDbcGQVtRQjPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751449113; c=relaxed/simple;
	bh=m2wyl7kz+6uvmmXfe8oX2ix01eADdAyzpV7Qj2FgNzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhPyEBlSajYpgmIZ2Qu5Ch1wDXAF5+PZjhJ5yJpDLiX/YQTv9Sj3HAZVTjNBZro5BEmTJuei2VSLRhjYmfIic1d4G/3Lzs+4mzZf3qZW9ZGJcrIp9PlUAATq4RpW67pK9wz76EhwVCK//Tjvj5aLX23CI3rdKfZqNs07AAubUK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Cwh40Ej9; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-74b54af901bso227566b3a.2
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 02:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751449111; x=1752053911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rTjwaEFPERHrYF9Gap7nfZ/7bPQeZGoi21gGb1ngn+I=;
        b=Cwh40Ej9k08gi71cELpAAEsOkellRirr9wJIZzKHIIc+7VVjX3TXyDqCDgsYhkGUPE
         dnsTZJ8+Hhkyd0IXdthsbIcSW3hvX6C0f7Ow4rKSaKL0YnenOHsJXGCNAKVcL4QLtX4G
         aX/G6W7iKSRjOvwlGlq3Ds16wKcerKR6TSgzSBBCdUAJqdwRM/flnEl9tdTDPMbD/IPY
         x/w9kO+XTAqp1xFDFSicgcZayrjJY5p9GnqO5wMlgYai5isSLgiVyZSHH1qbCuXbcNr/
         iPXmviFWHN4OXGC0LenyMOGPKF+fIxIa91Vb+pm3pE75YQhDlpoe+8ymHZ+o++ar0hgG
         QTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751449111; x=1752053911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rTjwaEFPERHrYF9Gap7nfZ/7bPQeZGoi21gGb1ngn+I=;
        b=ZnJA1Ue1DBv6C9+cRq5d9nolPFlztSbQUXbp9IiIABPtzYThww3yo+h4un5AdLTp2k
         5sr2KQzl55XokQAR7d8olfo8rPQipI39s/8lTCUMT5wOGAoe+UgMg+VXpY85nV3kFFX5
         2eIH+6kcWKBd5LsRS9IDx7qq3iRqBsKHn0cTEDV/oeY9JSTZIplSPmis1Qc39v3DvP8t
         oWNaQFxH2B7og9his9LT7arAxFt7Zejs9idjHAGynFINHRqdJCg3+Lm4aJk1yEWZsB8E
         hLIDSOZSjrhPFrHNaBxZpsvFCLIpxg/8JH47FfwJmEUtb9TuPa+oZUJ9gTe8R8QN/THu
         vnVg==
X-Forwarded-Encrypted: i=1; AJvYcCV3SqM0XJszMGebmNsyaLjpe+Zb8oBty3ZDB0qJwHxHCaM/EYbf6SSTtXceRt6PJTm5Zog=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEAnEqLNvTaNr5+r10cWf+Ax1oYiez1WuP/pQcGSfuURHa3OQv
	l1Spja4cHUCQsM3srejoyxX5CYhan7D3qqcIAVddzRnNoOfZ2/OSSy/zlqIwQZE16mc=
X-Gm-Gg: ASbGncuVRfjHFmX0KPn6O0HzafHSEpqL0ZBf3BmTsHpWXx6MtCbi1SBzqzr+izXtR9m
	ApP9ACaIzlf7Zq1f4R3pVmq32MUXY00Pd7KnKXOchIhouZHA7IeL9WDzIseEBe/YTIZyYkl66r6
	wrvTi/MnmE724u5ni1NblveuGR0BNLfB+ZAJBiPaYjmkGKw1H09WXG06XBRslGzcTB1mW3Lvajm
	pxIA31CiWk5U8zQQtvv1GfVfI2lTSRRtgZMwb2VYIY76/6Qh8zo/rzAcuVelmrtp42GWCZjxEn0
	bzc4G3jhwfenLsB7qY4rUhKgr3IVnkkipt6ZPOqL4eVvQKzllwWvZ6mgQZyK8dGnIOQDVz0UvpP
	gR5JpM/7A1+U/cw==
X-Google-Smtp-Source: AGHT+IGUO3B6nRDUzdmIQ2oO+7AEV740xR2OLJFkN6pT/Dska04jgo/ItMW9V4JJBw44CxgrOpO0sA==
X-Received: by 2002:a05:6a00:2eaa:b0:740:9d7c:aeb9 with SMTP id d2e1a72fcca58-74b512bf44emr3128818b3a.21.1751449111276;
        Wed, 02 Jul 2025 02:38:31 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557439csm13901447b3a.80.2025.07.02.02.38.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 02:38:30 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH 0/4] vfio/type1: optimize vfio_pin_pages_remote() and vfio_unpin_pages_remote() for large folio
Date: Wed,  2 Jul 2025 17:38:24 +0800
Message-ID: <20250702093824.78538-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <6508ccf7-5ce0-4274-9afb-a41bf192d81b@redhat.com>
References: <6508ccf7-5ce0-4274-9afb-a41bf192d81b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2 Jul 2025 10:15:29 +0200, david@redhat.com wrote:

> Jason mentioned in reply to the other series that, ideally, vfio 
> shouldn't be messing with folios at all.
>
> While we now do that on the unpin side, we still do it at the pin side.

Yes.

> Which makes me wonder if we can avoid folios in patch #1 in 
> contig_pages(), and simply collect pages that correspond to consecutive 
> PFNs.

In my opinion, comparing whether the pfns of two pages are contiguous
is relatively inefficient. Using folios might be a more efficient
solution.

Given that 'page' is already in use within vfio, it seems that adopting
'folio' wouldn't be particularly troublesome? If you have any better
suggestions, I sincerely hope you would share them with me.

> What was the reason again, that contig_pages() would not exceed a single 
> folio?

Regarding this issue, I think Alex and I are on the same page[1]. For a
folio, all of its pages have the same invalid or reserved state. In
the function vfio_pin_pages_remote(), we need to ensure that the state
is the same as the previous pfn (through variable 'rsvd' and function
is_invalid_reserved_pfn()). Therefore, we do not want the return value
of contig_pages() to exceed a single folio.

Thanks,
Zhe

[1]: https://lore.kernel.org/all/20250613081613.0bef3d39.alex.williamson@redhat.com/

