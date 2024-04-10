Return-Path: <kvm+bounces-14151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F4C89FF6A
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 20:08:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A385DB276C5
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 18:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF5317F39E;
	Wed, 10 Apr 2024 18:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gDJFOgFu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D14017BB39
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712772497; cv=none; b=pQMmzGfujZdCylk5TwL9RfIWtGVTGq1Prq+/PlmVFzT+ppdYSV5I30u1GrPZqNPXqh+Xkj8mc4w/CdRuU1cSsDcHlWAvvYppViF4UTZuGnme0oxkm8ckWqBNVAzvLeMqk2CJNEL2InOcpxWK29Dijc10q+5O0NSlBfOxDqKCHWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712772497; c=relaxed/simple;
	bh=tlQOUyqwZCCGO+a0LSWUCAzWINcC2ww3/hTkEPpmXDw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qnqTVm/nabDNhuGWG+7K0pLtuqRtIGkG6suDKDfyFV5/5QGK5z09xXqaPrpJARAX/FfvksgBo7lwBr7oW6TZkAmjlgsDvd829uDnTuD9/6mt4dXa/3BwXttEyeVQfzTI4toG6CFykajHQtf3aIeELVO/fqsxPdKzJfiuV9Bus3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gDJFOgFu; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-617fffab703so59103007b3.0
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 11:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712772495; x=1713377295; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xZflpisHc+9oeh7nBvZbuK3Tx2t0csxEA3Vaxd3rpg8=;
        b=gDJFOgFusBDMiA1Juc/151fTp4sFT1YWV7JGKwC7zKmzlPMAuCGVC0Rnydux/66hzQ
         URP1hA7C4828z1qAIXClSfq6XwMAnkvDMavbvQmf0CiVYPrffZBSHM5Qw4kDJXcCVrR8
         19gg51z071Nt6j2e0H5O8MmLS3nFOzsBjt1c4cNITR4ckofiUBTZVC6KSaFyMRPBeljR
         MAAIninMOWGfvCyRs99N5Xnj7mJc0p7SEvwIqyUC+lwqZXezeoVnCIHCAPZ+5Etfwvsp
         ZfVcCEns/vMzeDaJ0B7XehHVGaODZ2dxUJxeRx4cg3afSQ1LnqQsv6gVk8Ft3PupZcOp
         c6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712772495; x=1713377295;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZflpisHc+9oeh7nBvZbuK3Tx2t0csxEA3Vaxd3rpg8=;
        b=RNeCJtpgvkZgDnFwCEv8OslpNpFR8aG0BwJicv870XsyMkSeCUOEE3TN6lJcBsm0tX
         y+qK+Of2Eyg25dUgtdGbP2vPlf3o8vtp5aAma9WdlMcT3f9CB9obV91S3YQ03ZxVO4/W
         S2Bx+CqHFA2X3qSLk7xweNbNB1nDx82MnSR/pdL9zzmiY0u1t1a6yFXnKRu/vkakQHNh
         TVTkecvCnS1GKFTxdXOJDmDsAGsS+tfnC9iMXtrZ+K68aOCDqlrf4pUnLYmkr/MK7NtZ
         J0uhMAjnYw3Vs6UmhuGShekZEYpIIzJZX+IsippM1DTXvlDhXaiE+UOqmWEmTSGE9mRP
         2mRA==
X-Forwarded-Encrypted: i=1; AJvYcCUP7trPPQwejsZEtV74HocO9VqYnSj4Cmrc6+3JU7B6nRSg93Wqn7NsOT5J8Ej9SPTxpq4ACaIkC9x1nBAzCmzdVLEM
X-Gm-Message-State: AOJu0YztDGHMSa2srh6GBg9djTiAnSNNNB1oLdfO1DuOJYI1PQ2meG6l
	DpI2eKAT93b+hxHN0G+DAnO33MgsLpirMQaO8LcZLWnUbBnOHNl0mPpnmxDFhZVAthsFrypIIEi
	l0g==
X-Google-Smtp-Source: AGHT+IFhos74HCvbkwq8iBv8vYHsZl4wRFyLhDRmwIqukp0Eu+fKSsgjADRfj3OZlGVnDlRBwuYnPN82INw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c3:b0:de1:21b4:76a5 with SMTP id
 w3-20020a05690210c300b00de121b476a5mr290201ybu.13.1712772495155; Wed, 10 Apr
 2024 11:08:15 -0700 (PDT)
Date: Wed, 10 Apr 2024 11:08:13 -0700
In-Reply-To: <20240410155527.474777-3-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240410155527.474777-1-david@redhat.com> <20240410155527.474777-3-david@redhat.com>
Message-ID: <ZhbVjVRoa70IwgfA@google.com>
Subject: Re: [PATCH v1 2/3] mm: pass VMA instead of MM to follow_pte()
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-s390@vger.kernel.org, kvm@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Yonghua Huang <yonghua.huang@intel.com>, 
	Fei Li <fei1.li@intel.com>, Christoph Hellwig <hch@lst.de>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Ingo Molnar <mingo@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 10, 2024, David Hildenbrand wrote:
> ... and centralize the VM_IO/VM_PFNMAP sanity check in there. We'll
> now also perform these sanity checks for direct follow_pte()
> invocations.

Nice!

> For generic_access_phys(), we might now check multiple times: nothing to
> worry about, really.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---

For KVM, a very hearty

Acked-by: Sean Christopherson <seanjc@google.com>

