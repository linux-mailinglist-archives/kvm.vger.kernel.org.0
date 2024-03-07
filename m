Return-Path: <kvm+bounces-11308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A480B8751F8
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 15:36:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A9D11F26985
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 14:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A74C1EB2F;
	Thu,  7 Mar 2024 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KOwv1gkT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE881C68F
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709822171; cv=none; b=KUtLUGPO7oPtIScDi9sxy4Wu1EE+W2KmOUsHzTaBJ3+z4L5gnHOxtDd+HdRgsO6Ii6Xk4NxO/eeTTHGlJ0Q9EYjckAdv1NPq77NDpEohLERSDBPcNZmiDDz4E72Em7dyY1WhVH2YscX1ccJ/FkXe6HNv+mrumyD0FDR9GvOLdpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709822171; c=relaxed/simple;
	bh=5c2pdnlbWCYsX5AL6tAQ6PuzfWITspmp5cYuOF4KTUg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uTwbH2IGw69lnMRgpTGXCiyseiqqOs/mn+zO+2Kdq25Kx8UsPCOjOZ8MNDJ8D5PDjiXtyRztfuMDQrBy6OwNcftvoCiX8SmTWskU3M/mqumIpbRPZEsg997FJ6Dn7xA8kMjq7XTseuV5J53jOO477cnOW+lKcb7aMw+RVEWipZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KOwv1gkT; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-608ad239f8fso17132177b3.0
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 06:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709822169; x=1710426969; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uQkndU5MaQMQimAlXbJ2bKIU8av7qyfvd42xkrItWQQ=;
        b=KOwv1gkT34HkiFNiGgwW3I7Siwb8jdEV/eEP/tTXJP9R1EhMpAAa5x24qFnk+joyOQ
         NM7Nc68HZRj6f6PTA2ZE6/M5qQ+2/6r4ULBsTxfVopx/xTGl3L1Os4DXY3S1atmlVWyP
         2A5X+iYOW4dtgH7TtSnb6cImEhYr9X4abrFmVzITP6O3Pw+h320s8jJa2qs0JakH1tqU
         qd/DW9Y26PEts76gL5pwfYC21frDGxffWYqvE4jQ6JgVvC76SRBh2mNGqgXGkpfLbC8J
         xaeMCJcEUyxGuZtwnsm4OAO7ejY+jlAjUiTauthyEVzmirSCVKlXF3c+p1Pl8nIOocnC
         2LtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709822169; x=1710426969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uQkndU5MaQMQimAlXbJ2bKIU8av7qyfvd42xkrItWQQ=;
        b=fWPeU/5vp3LFsLtSKPBwl3V8rtQId8M5j+HepCK1XEAL8303xGYHvghL+GB+tBsyW6
         NpzX2JBBjWE9sJc48qqJUmMoMn0+Fr1th0XrMQvXOYjMlhPjbjSgH0JC8d+JPEXDzVu/
         j8V8+Lq+uOtgtiTu+hYwrSupFeX++dCsnhOxRpagwtnBtPdGEgEMhcZLEd2XEa3FIbzD
         6XljMWP1SMDWzYkO4KiOfdS2JSn5U4ZwJkoDwjighH7aLjmFWDhpwJD5LnDwIXHYrWeO
         4ie32Ei4AW9PsoY1hQ+qAoI6bGfLPFvzGrogAuwC8f2ZB8DuARn7hWA1tRvGU48tRbWL
         OzZg==
X-Forwarded-Encrypted: i=1; AJvYcCX5o5ETQs3eLOiZuYxb/P5ImPizDKUVKlDKoSTjfR8y/dQS+sbD2m+PDOORDWk9dPxFwkb4spLBzSD5T5MjGIC1G4wI
X-Gm-Message-State: AOJu0YzerxcAzCwz6kZImi8FEjMRkp7V3GDpOnE8yFBu/OAn2eCZUpLL
	WDcJJuinqAiAze9PtseKOSRHlr6fuKNq62POK+WfBm6HTt9UDMcYDccDi9DiP/fPLqJcztlq2SM
	YQg==
X-Google-Smtp-Source: AGHT+IFES2CcpL5jNV0bCQu5D8bKAvGmHTylSGvybuc45Nl4UwGQmVKoE4uXkDOBCpzqshSi3hTNjQCdGGY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18c7:b0:dcc:6065:2b3d with SMTP id
 ck7-20020a05690218c700b00dcc60652b3dmr4413088ybb.8.1709822168860; Thu, 07 Mar
 2024 06:36:08 -0800 (PST)
Date: Thu, 7 Mar 2024 06:36:07 -0800
In-Reply-To: <ZemDaWzRCzV4Q5ni@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-6-seanjc@google.com>
 <Zeg6tKA0zNQ+dUpn@yilunxu-OptiPlex-7050> <ZeiBLjzDsEN0UsaW@google.com> <ZemDaWzRCzV4Q5ni@yilunxu-OptiPlex-7050>
Message-ID: <ZenQ15upgjUGD5tY@google.com>
Subject: Re: [PATCH 05/16] KVM: x86/mmu: Use synthetic page fault error code
 to indicate private faults
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 07, 2024, Xu Yilun wrote:
> On Wed, Mar 06, 2024 at 06:45:30AM -0800, Sean Christopherson wrote:
> > can be switched between private and shared, e.g. will return false for
> > kvm_arch_has_private_mem().
> > 
> > And KVM _can't_ sanely use private/shared memslots for SEV(-ES), because it's
> > impossible to intercept implicit conversions by the guest, i.e. KVM can't prevent
> > the guest from encrypting a page that KVM thinks is private, and vice versa.
> 
> Is it because there is no #NPF for RMP violation?

Yep, there is no RMP, thus no way for the host to express its view of shared vs.
private to hardware.  As a result, KVM can't block conversions, and the given
state of a page is completely unkown at any given time.  E.g. when memory is
reclaimed from an SEV(-ES) guest, KVM has to assume that the page is encrypted
and thus needs to be flushed (see sev_guest_memory_reclaimed()).

