Return-Path: <kvm+bounces-29584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A069ADA6A
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 05:26:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 508C51C21908
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 03:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F3916190C;
	Thu, 24 Oct 2024 03:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JbPJfiAL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DDB3C47B;
	Thu, 24 Oct 2024 03:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729740369; cv=none; b=kvU3rxZVgcRqZPXmoD0IH3XPjQfsxmT+z2ZlMGfFiB17hwIGVeJ+fMYGJVqBK17wIs0cxooLRsUegYwGTR8gpRoPE/6UCb0xm39+M9M8F3yMk8oozlIEEFwYR70WNfGcA94uQUSq5IVDAj9V8wcLTmhN1K248YPbaSXZ4OHlg8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729740369; c=relaxed/simple;
	bh=hIgjqVCMxMmW5pQ2fHDbtMZuzfN+NG2dan74A5X4RNM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=aDO+Ox9nWaUmd3xM89oOV3cp/DDwCbnNReRYU/AHN0+bku95n1ePN0cHRMwo1T/xTnQzS77fk0UNgCU7KWIbqi7r8Mn4a9RcpeFoNXDXs2AYcbNewqwynjjc8CoaPOi9WTRpz9Yi328poq/E7wzFYF7jCulDc5jEUG3Bzrr7vNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JbPJfiAL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AB6C4CEC7;
	Thu, 24 Oct 2024 03:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729740368;
	bh=hIgjqVCMxMmW5pQ2fHDbtMZuzfN+NG2dan74A5X4RNM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JbPJfiALtSjoxUh1oMopuYUEQxd0YQ7QmzTS2ve7jM/1yWnOgKDn4PTJV3TTBr6Kr
	 yp7Gt60ICRIraSDImBfpvJ+FZ2qTVFspseXssZI0TxSn60HMh38eN2MxrxFsN9K6ny
	 +CYIGgAPxS/XHtlGyeGTPCF2M+9yAIWr5s2m9hi8=
Date: Wed, 23 Oct 2024 20:26:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Houghton <jthoughton@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, David Rientjes
 <rientjes@google.com>, Oliver Upton <oliver.upton@linux.dev>, David Stevens
 <stevensd@google.com>, Yu Zhao <yuzhao@google.com>, Wei Xu
 <weixugc@google.com>, Axel Rasmussen <axelrasmussen@google.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm: multi-gen LRU: remove MM_LEAF_OLD and
 MM_NONLEAF_TOTAL stats
Message-Id: <20241023202608.d4c3c8a5fef8b7e33667cf31@linux-foundation.org>
In-Reply-To: <20241019012940.3656292-2-jthoughton@google.com>
References: <20241019012940.3656292-1-jthoughton@google.com>
	<20241019012940.3656292-2-jthoughton@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 19 Oct 2024 01:29:38 +0000 James Houghton <jthoughton@google.com> wrote:

> From: Yu Zhao <yuzhao@google.com>
> 
> The removed stats, MM_LEAF_OLD and MM_NONLEAF_TOTAL, are not very
> helpful and become more complicated to properly compute when adding
> test/clear_young() notifiers in MGLRU's mm walk.
> 

Patch 2/2 has Fixes: and cc:stable.  Patch 2/2 requires patch 1/2.  So I
added the same Fixes: and cc:stable to patch 1/2.

