Return-Path: <kvm+bounces-59734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9448BCB0D8
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:17:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37E4D3A91FD
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 22:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB4A273FD;
	Thu,  9 Oct 2025 22:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XbsO3nQM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879FB25B1FF
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 22:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760048221; cv=none; b=Aysu89A2J4O5b2Bb4FhWZfCy0XtmAvLUnpEFLOaw0oZLCh0OQ6vfE8KOlfl0kbz0DTdT6t8QvAGnYMuwGGf670MoyoP6V0I3jREU3mkk3sQB9EmU6BAbkgiaPXDEyqG9yqA8YPYJbTxVEbgGMbYl89SQGyaUPRhvnZoHG0Xx9Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760048221; c=relaxed/simple;
	bh=krBRRfDdwyas1WntIR8CFkZ9BCSn/cu8ny6/qRRn7Ro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mVgMTQcQWd69JV/zFiZdnwohameOlNBMWbMIuLNYtr7uKLRelmwMmn6mBZ75AW84jZ3GtuWznBcnWLLi99y+HI7OACTH6i7o3Ef6eqdEc1PME8SvIIO4D+w2SDJRtyYk/zI55xXtvHdcJQakAiWIEmESuLr3I4VtDuFvcs3geFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XbsO3nQM; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62b7af4fddso1983535a12.2
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 15:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760048216; x=1760653016; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ouGIZ18YYsl/9GqodU9OqB8J+uPEhuPrGCcLgx0Wyc=;
        b=XbsO3nQM1Mna5qRzBqZPyS7euFEdUWtNBUjmI7Jzm3hAKkEV72wr01CuidMVGG0wHL
         Coz0NhdysKd22yc5UwJOqTGd6qcyR4ECDuikArNHinC+7CPu6trrEiz84rxSEHmxkod0
         Vi6Ym0ncdzRg8r4o5dPmviFVWxnMShlt2KCzOIlHkunhKOuGWS1q4Vu9jqwCdNkMnS5X
         TEReXEHilsll65a1V+0NmwITJKLBORZjy0kUtnI8HK7ncZMVpYY5cO70/g0biQIRcHpq
         lFouhkq/8ZWKj+DQDOqMdpfcUxc5ChG/0tqeu2+lYocW9xiylVd3S5/0foQumLQccjDA
         Hz0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760048216; x=1760653016;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ouGIZ18YYsl/9GqodU9OqB8J+uPEhuPrGCcLgx0Wyc=;
        b=gzohhW7MpXL96hoU4hR79Ahff6qIyxKGf31Pa5cdYQpdX8+m03ntcDTr2gF1r2HjyI
         49bcyBCb3x06tNF/mFRoxwSyVmSd88YGDMQYdlWxxxrMLTF7GmSKsA0i2cli1JbOiyOP
         C35PG7apuwSWOrj77Iv8R7wtaVacJiDvNVam4hhRTl94e4JgXVeRMOz6mfKnAiBiDWL/
         2QR7w8Gkn/RboDNrYo1JhaEkWqgIp4znFTKH1c8IRHbFQVZntiaIwyKdeX7jFrkE8JQV
         x0/u8PIVwvl0rYRl1FFkxwbSUi7x+45AKNmBS1ptRZwUbTH4X/dMbdp+SzGX+Rn4J1DT
         mg7A==
X-Forwarded-Encrypted: i=1; AJvYcCUCFBickD13gfOIDowgF/gVKeDdqtbxzgolj3QBgm95k+3ZqSpNvx5mH8NnTIc8iLQVEjQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8IJZKvQdPOyA38+H/PIRjqdfyqKcI8rKfKhMNLKjaHTIukrCI
	fpBVVRkuO+oiR7QvHmmy2QfE8p/c4Zde3EMIspt+jEDKaRSfvt9PdmW01q8IyA4otFwMpZ3QaA2
	YVaaxQqR5buHUT/UsrUGTddGQnw==
X-Google-Smtp-Source: AGHT+IEwKuAuCigrDNWiN+req1c5yFRzIFngZTOobnjj5hIhTotLZtUDLz/dT57kmfJHlodJGDgMWM9ut0fHatowOQ==
X-Received: from pjwd3.prod.google.com ([2002:a17:90a:d3c3:b0:327:c20a:364])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1e0d:b0:32e:a4d:41cb with SMTP id 98e67ed59e1d1-33b511174afmr11693801a91.1.1760048215831;
 Thu, 09 Oct 2025 15:16:55 -0700 (PDT)
Date: Thu, 09 Oct 2025 15:16:54 -0700
In-Reply-To: <20251007221420.344669-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-5-seanjc@google.com>
Message-ID: <diqzldljhga1.fsf@google.com>
Subject: Re: [PATCH v12 04/12] KVM: guest_memfd: Add slab-allocated inode cache
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> From: Shivank Garg <shivankg@amd.com>
>
> Add a dedicated gmem_inode structure and a slab-allocateda inode cache for

Stray 'a' in slab-allocateda here!

> guest memory backing, similar to how shmem handles inodes.
>
> This adds the necessary allocation/destruction functions and prepares
> for upcoming guest_memfd NUMA policy support changes.  Using a dedicated
> structure will also allow for additional cleanups, e.g. to track flags in
> gmem_inode instead of i_private.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> Tested-by: Ashish Kalra <ashish.kalra@amd.com>
> [sean: s/kvm_gmem_inode_info/gmem_inode, name init_once()]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> [...snip...]
> 

