Return-Path: <kvm+bounces-6831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D84E83A949
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 13:13:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E3901F217E2
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 12:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 366A364CC4;
	Wed, 24 Jan 2024 12:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dg6AgLYY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D706B64CC2
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 12:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706098308; cv=none; b=nt3i/zCCe02QsCTroHAfpAdY/Qxu8AlPvdpqyTtRAx4FMHoDflPozuKqdkdKE742vXnfxxgKCBSvLGmZZ2PNpSP1p2ABeEfvvz6gyRS1w4ff3vv57pIvlCXw0qRp+U1g33g3AGPoVW+iwksarQYurOxdY75DvIX5GdI7OVmcvWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706098308; c=relaxed/simple;
	bh=FeyRThOronAlYOrnGzWBi0dwkjLppglmgzxF28JQrx8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VLsuLUgfctB4LDmFNGMeE9mOQGmLJLrjcUVKZyKHXw58z7/31SNB+PxgXZwsH8+8tPs86H3mopSuMrfyCitna1GEZ9MSHruEklQenysIkInYssW5/xYpMmGt93D8kc33PoX1+3rXp2bV97Sq2NHcZjMqs8M3M3H6INaFpPOLw8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dg6AgLYY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706098305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vPYy6OgGxo1KTZycWmlXZinDwTH9UJLEcdQjGlemE08=;
	b=Dg6AgLYYjQCnBfvDy4oKMTscwYLcfkMHVPJYLJ88K76O4p4h8hNVCbDW8kvZpHKj83vhJU
	jpKLEHPXo6EetkCUJ6d7DZqo489rh50uIlnFMWYYxJiz7gcf5tMo9blrf+2XijiPtAHDft
	+w02/wsQPPxlpt/5GA8nEYVkWCQ21+o=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-q52_WQV9NeqpH7RSdwlb7Q-1; Wed, 24 Jan 2024 07:11:44 -0500
X-MC-Unique: q52_WQV9NeqpH7RSdwlb7Q-1
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-4b92015b9dcso1498434e0c.2
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 04:11:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706098304; x=1706703104;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vPYy6OgGxo1KTZycWmlXZinDwTH9UJLEcdQjGlemE08=;
        b=UOeaftOkgWNv6/hPHDMWFZUOQa1UM0YVBbazk4Xcktl9w9VFn59o6pF5pGWaVZV1tt
         0PDMhfz/EphHW2+aeqNU0vdJEeEtqJlue8eu4hjJPkCXT+sRwCU7MY+k2Q1noliWHCqV
         bzswMaQg0H/NHtqRD8iC0dk8kQOojGfdn9LlTU3hbmMqrI5F10J7mdWHydFWsdQ1Pldh
         JLjPUFfLq2sAzcCaM3rxVS9DYw4EvkYli/Bz4frzHIOScvKVOn21CQZYZ/d6bqsqjErM
         kmPOrq4UU0ORA13lOPtOYcYQ6tUZXii1aTGQBr210LZ7km4+w/CPBCKd8Hp+PDcdTbO5
         aVtA==
X-Gm-Message-State: AOJu0YwCheWyBrzsqcO/fBgDj+XWxhsq7+ofJv1S5FFHrzpFWW9KV9Sj
	2OiQV3P7dY+Aw9iknqVZWiwxv6PVmTwrAfa9Fl8JP61ktt4v1SD0znWDm2zdRG6diO5qfHRK7R+
	uyibpkWStlzygh4jarpMk+f7FNryS7NWYE3kKSPY67w1fRjazLk/rHLlpxw==
X-Received: by 2002:a05:6122:613:b0:4b6:dbad:e78f with SMTP id u19-20020a056122061300b004b6dbade78fmr3389120vkp.31.1706098303514;
        Wed, 24 Jan 2024 04:11:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFbpAaQMFM6ZMBjluXMgs5opNAOR2c3PR1nLM3duKLKamQwkakCV7yXYIHtrm68ntTwc8lqFw==
X-Received: by 2002:a05:6122:613:b0:4b6:dbad:e78f with SMTP id u19-20020a056122061300b004b6dbade78fmr3389116vkp.31.1706098303291;
        Wed, 24 Jan 2024 04:11:43 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id s8-20020ac5cb48000000b004bd771a697bsm53292vkl.44.2024.01.24.04.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 04:11:42 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Sean
 Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH kvm-unit-tests 0/4] x86: hyper-v: Add support for
 CONFIG_KVM_HYPERV
In-Reply-To: <20231025152915.1879661-1-vkuznets@redhat.com>
References: <20231025152915.1879661-1-vkuznets@redhat.com>
Date: Wed, 24 Jan 2024 13:11:40 +0100
Message-ID: <87jznz9bib.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> With the introduction of CONFIG_KVM_HYPERV:
> https://lore.kernel.org/kvm/20231025152406.1879274-1-vkuznets@redhat.com/
>
> it becomes possible to build KVM without Hyper-V emulation support. Make
> Hyper-V tests in kvm-unit-tests handle such case with dignity.
>

Ping) CONFIG_KVM_HYPERV is merged in 6.8 and kvm-unit-tests fail
miserably when !CONFIG_KVM_HYPERV without these changes. Patches still
apply cleanly.

-- 
Vitaly


