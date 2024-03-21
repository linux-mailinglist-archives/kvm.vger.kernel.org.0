Return-Path: <kvm+bounces-12442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F36B7886319
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:14:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 928C21F24109
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7BB13667D;
	Thu, 21 Mar 2024 22:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xWxsBmg1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6BE132489;
	Thu, 21 Mar 2024 22:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711059234; cv=none; b=VxYS1taw8o1TWvAPazbO8bEduIBjF8oktY9GSw7gWXVPwcbA+QIM3M4Wa5OSQ6SebqguTKy/oZu/ItHx/6NDKHqIQOREazYY8HTquZVf5OmWyWhNr4V+/uCCVqiPB8maw6Dvrn10OwMbfHZPn+XhwIEL2t/USvY7RqBMehHdoKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711059234; c=relaxed/simple;
	bh=rR/YqYWsKucunZD7vKNL136qCCKoUyH60J1FPICojI4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Q4pjqUO8n+t3m28xTDlqa7C22GniAnT1nyaCR6H0AFas5wVWbDVUFDGulBGjXDZjcVi/Xx6z/D0sskqugGZZplOdYk/67E9/OQClxIKaTlQQIE2Gys+RPSp5FDAh/wHUpBuulRt8jFb94NuThhEENCJ8GYfxJlBVc4z5QimU0iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xWxsBmg1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3005C433F1;
	Thu, 21 Mar 2024 22:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711059234;
	bh=rR/YqYWsKucunZD7vKNL136qCCKoUyH60J1FPICojI4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xWxsBmg15HNIt+L2kRVS431E1kOb56lzUVHZsCrNVICEms19Ye47UZJPK4Y6k10z/
	 3KSuLyGcOQbVxo5a7QiaT/XfrbY6TwpMut3+JOcudJ29eRXB3geK+vTaJr69cKMFSx
	 H5EcrIaHJ+q/FOezouqTd/8sifYgbjhzoUdqTkNY=
Date: Thu, 21 Mar 2024 15:13:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio
 Imbrenda <imbrenda@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Peter Xu <peterx@redhat.com>, Alexander
 Gordeev <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Andrea Arcangeli
 <aarcange@redhat.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 0/2] s390/mm: shared zeropage + KVM fix and
 optimization
Message-Id: <20240321151353.68f9a3c9c0b261887e4e5411@linux-foundation.org>
In-Reply-To: <20240321215954.177730-1-david@redhat.com>
References: <20240321215954.177730-1-david@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 21 Mar 2024 22:59:52 +0100 David Hildenbrand <david@redhat.com> wrote:

> Based on current mm-unstable. Maybe at least the second patch should
> go via the s390x tree, I think patch #1 could go that route as well.

Taking both via the s390 tree is OK by me.  I'll drop the mm.git copies
if/when these turn up in the linux-next feed.


