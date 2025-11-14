Return-Path: <kvm+bounces-63233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC3DC5E4F2
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 17:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBF243AD54F
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 16:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA9B335547;
	Fri, 14 Nov 2025 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BMUsF75Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E5E334C01
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763138381; cv=none; b=iHyVcyyE1sFWbA64gbgM9b1vcs8JX5vnWE7Rg3ZgT3gQRehAR+6hGGbOwUURWIqfZzDuinHUKFvERpCHSe5+7Cu/RDJ5xOCg1vjr7tVYEPffBJteHy75xibTaCxIkFdgeHMXwMqxdRygusTDryx8d0fjCgOzFWMxlgUTsziWIBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763138381; c=relaxed/simple;
	bh=0ZCVUMLgfmd6DiDcctwRiIjcoGRN52H8jYjLBR1MlwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WWA3uNaQdBZzqV1c4SFrtKe5udSFziqyaO+j7X8PLOKnprf3wSPPsOTl2OLi8dIv99bYv7s39tk/FCCAyy3kLE21/LRVdIlBB3mD01ZMUQPwrVxeLHnVMvr/1eHc+NlTL7n36ggRT0BI6AYXNKUmDfLVDsx7tubC/2lCv4IXTGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BMUsF75Y; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2954d676f9dso18229945ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 08:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763138379; x=1763743179; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vvKuuE+PjYCzOAb47tSaH9inRUN7g6VhaZRxkzeJxLY=;
        b=BMUsF75Y2Iw9/WpDbzO8Fae/0KTfHf7d+pYEukQERFe8829aBRl7ooaWAYy/02FCWQ
         uuz7uGjloNnSdgWjANSrCCOnksftndWzRKqrhqyCtbYcQa4+ZicUFxVJrtiBAaIZrOX6
         t96MP3ZdB+U/RMj54yuQsemECVMlau4byZ/BIvywjD05w1TW698KOJtc8u1eczvA1HqE
         vXMSxfyMAyhQVE4FEBevlIhCy21Pb7firtQ+xhOmU17eDWLW73hb6StVWq2pCaO+LgtB
         W1Bmct7lhdRh3QlK6Y5C7VgngHqnXj64WyHc34ijV+HI7+NC0OaLiINgN0TfMoCajxlK
         53fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763138379; x=1763743179;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vvKuuE+PjYCzOAb47tSaH9inRUN7g6VhaZRxkzeJxLY=;
        b=gpwP2KIoBaD0UrrkMojkIvtLtarQprzu4pF4qZccYJFjc8lrUvcIB96FxxTZ1uEyXF
         vqbDkJmgRj2jxT3wlHcftCvF/q62HWzOGIxfuBgbm19yKQZixcM+Gx614VA0ilgZozC0
         I9JcQq6+/e3FzD+EwHYyuLi2EIWtz4SLWrj4sv5NXtHmaLo2R1wWFhsD8xQO17wCgdOo
         3Xg2hOT8FHP6X66p6pFFuKlnKkHsYRUnzZUiz/6eFNqIwE0er/3ccfgO+5JchJogIglA
         9hPLcEchFGNNEsPBY1XKNsjH3P6lxAOI1siX86V3a5NmOD8eM3G2QZl6A6gsCtkLyhnI
         THEw==
X-Gm-Message-State: AOJu0YzXPzJh+oBsHWwM70WnvurUOdg0Rw3NwUI8/300M+epHzZzYAtc
	n7SjC2+P6g26L6KzjcQOcO6IzsVK//D7bIpoIocsOW3beY3P1TMKnBCMPFAbUsAckxBEqszSZri
	SWm+r9w==
X-Google-Smtp-Source: AGHT+IHWarhq/WnVBj+1YjmYIbOlKqVYywIAwj5fgd2lO10HbZm9MsXu/DDihp156NA7glJkGLvQ6yfhWGs=
X-Received: from pge4.prod.google.com ([2002:a05:6a02:2d04:b0:bc3:1d96:1f54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b07:b0:295:9627:8cbd
 with SMTP id d9443c01a7336-2986a73b6bamr37888775ad.33.1763138378950; Fri, 14
 Nov 2025 08:39:38 -0800 (PST)
Date: Fri, 14 Nov 2025 08:39:37 -0800
In-Reply-To: <9b2d7e48-a847-4c84-89cc-b8d3962f4498@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250915215432.362444-1-minipli@grsecurity.net> <9b2d7e48-a847-4c84-89cc-b8d3962f4498@grsecurity.net>
Message-ID: <aRdbSYrkSOpUJKAT@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf functions
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Eric Auger <eric.auger@redhat.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Thomas Huth <thuth@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 14, 2025, Mathias Krause wrote:
> +Sean
> 
> Sean, while you're currently in KUT maintainer mode, can you please take
> a look at this? The ARM bits have already been ack'ed by Andrew and
> Paolo, apparently, has little time for KUT as well. But as you currently
> seem to be looking through the pending KUT patches, maybe this one can
> get some attention as well?

Got 'em.  Thanks for the heads up, this wasn't on my radar (I saw that Drew had
responded to v1 and assumed he had taken them).

