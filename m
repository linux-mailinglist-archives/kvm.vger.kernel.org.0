Return-Path: <kvm+bounces-11602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6AA0878B9E
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 00:44:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDF341C210F8
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 23:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C80FF5916B;
	Mon, 11 Mar 2024 23:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FnVt4pYb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF5D58AD2
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 23:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710200671; cv=none; b=YJpdRE0muslCYbhLc+NdR8AWhNiBrAKscSX41rFSfcYTwiOa9bZeLMuOrDKfaluBe83TooKzEWB/gci9lnJyf793ysr6eAiM7s8/ITLJO1fsaX2trXAUNZSNbXSt4FjE+nyZ1VQLr7vgF7obwmXBYBxbGlcT8Wu/9RDnYg9OG9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710200671; c=relaxed/simple;
	bh=/7zACagJjW7/k71pULrkC1Ljk59pppVzE1FxfoB0cVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pvayO4FAEK0gumog0152k5RkZpJr7inSUueSjpHnNxHDqX+DONs47gR7x1MuXn20bzhe+Oy+ey50cRdpa2OAoTOyOdco/TUm9KqtxzTGNxtLJ9E5nCHJWdsv+olGRUf+FnpgSD3K98w5cU38VQkZM677jVchAcE3xWCBqTPtldk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FnVt4pYb; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e657979d66so4334534b3a.2
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 16:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710200669; x=1710805469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EMI4Pmv/naxvAfPYroNwqy3j1VzI27ffy6ugcYk0ZHg=;
        b=FnVt4pYb+2ELmWlUZ2Btw+0s2z+jVvroV4la/FOeKlT3vcKGCvB8K29okF9XvJ9TrG
         DfQ1X2m/xkz4YM0RnHakZoYcTX7ifeo7N3282wLCtfNZxx1tgniZGSB3PUSx7427UmVc
         RBHDERpvfk+c/xyhXi8rPNIW1WexLujwdE548u1onHqo6KZP31wxe2V29sKY8MkCEHYG
         aYvV8Gzj3UvglQv4BNqIJJxa+oj4w5bqqNa1OrXNqTXdewWrrb6UBfHoqN0QOhW7HgZh
         e2XNze2iWRgI1K2aW6iXo4AWoTvi6ZJ89dds8eFPdaSACC35FNwJ+lN8JESP6PZEgBmk
         Zhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710200669; x=1710805469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EMI4Pmv/naxvAfPYroNwqy3j1VzI27ffy6ugcYk0ZHg=;
        b=HNG2fc8UToLjO6XIk5oY1lIE4i8z0O2d+84kz3cWC5Nx3g2o94WhjtDzie4MgqOzeh
         BwKLQU/hvd5OAZk57c6sz8Fj2UCI1b+m6+6QxNBW9nj1Px3JDv3SwGLIF04MppfZour2
         14V4mm8Jf1Y8eW0X2upFepoyisBCdJwvf8fMGRqldp88Ziwjvt144hHvAjK4dVtmiRm/
         RMHgM5jDsZFeJtewKeV7L7FUGdCApE4Ve0RyPeDuBJEwpmf1WD0jd30jj4QtaoWQOrUq
         nBDd4pxB3TM0vzMaWsthspAwBiVtLTWrvLkNCRR4QDhn69qriurVLA+1vcI6BVPu4S4D
         wy2g==
X-Forwarded-Encrypted: i=1; AJvYcCVpJzJPuQLEwEpEuUq7WPr2qsupA8lyjLYQcdJuvJMQxXU/8rHE0hfAbgatL5hVHelmBB0XNUJmAW8L53l22ZBVmlYK
X-Gm-Message-State: AOJu0Yynh/Jc/hdlMiOKHAxZ5OVZa6pp0lGGs9O1vbjqjvAmV2mIwDbN
	msECuea7IN3OIAoAocxEu554pJMz6wwROm10k+g584teKzFTf3ol9/3a9eXLYeK50zeUGspGdss
	L4g==
X-Google-Smtp-Source: AGHT+IE9YQgFrlRUqic5Eu0BhIJVUHsFx32+jIiT3xQh1aWbzRN3MucQw3uy7SAgNL6CyAqfvrWvMB5g/1M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2291:b0:6e5:94b0:68be with SMTP id
 f17-20020a056a00229100b006e594b068bemr695709pfe.2.1710200668905; Mon, 11 Mar
 2024 16:44:28 -0700 (PDT)
Date: Mon, 11 Mar 2024 16:44:27 -0700
In-Reply-To: <20240311032051.prixfnqgbsohns2e@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1709288671.git.isaku.yamahata@intel.com> <20240311032051.prixfnqgbsohns2e@amd.com>
Message-ID: <Ze-XW-EbT9vXaagC@google.com>
Subject: Re: [RFC PATCH 0/8] KVM: Prepopulate guest memory API
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, Federico Parola <federico.parola@polito.it>
Content-Type: text/plain; charset="us-ascii"

On Sun, Mar 10, 2024, Michael Roth wrote:
> On Fri, Mar 01, 2024 at 09:28:42AM -0800, isaku.yamahata@intel.com wrote:
> >   struct kvm_sev_launch_update_data {
> >         __u64 uaddr;
> >         __u32 len;
> >   };
> > 
> > - TDX and measurement
> >   The TDX correspondence is TDH.MEM.PAGE.ADD and TDH.MR.EXTEND.  TDH.MEM.EXTEND
> >   extends its measurement by the page contents.
> >   Option 1. Add an additional flag like KVM_MEMORY_MAPPING_FLAG_EXTEND to issue
> >             TDH.MEM.EXTEND
> >   Option 2. Don't handle extend. Let TDX vendor specific API
> >             KVM_EMMORY_ENCRYPT_OP to handle it with the subcommand like
> >             KVM_TDX_EXTEND_MEMORY.
> 
> For SNP this happens unconditionally via SNP_LAUNCH_UPDATE, and with some
> additional measurements via SNP_LAUNCH_FINISH, and down the road when live
> migration support is added that flow will be a bit different. So
> personally I think it's better to leave separate for now.

+1.  The only reason to do EXTEND at the same time as PAGE.ADD would be to
optimize setups that want the measurement to be extended with the contents of a
page immediately after the measurement is extended with the mapping metadata for
said page.  And AFAIK, the only reason to prefer that approach is for backwards
compatibility, which is not a concern for KVM.  I suppose maaaybe some memory
locality performance benefits, but that seems like a stretch.

<time passes>

And I think this whole conversation is moot, because I don't think there's a need
to do PAGE.ADD during KVM_MAP_MEMORY[*].  If KVM_MAP_MEMORY does only the SEPT.ADD
side of things, then both @source (PAGE.ADD) and the EXTEND flag go away.

> But I'd be hesitant to bake more requirements into this pre-mapping
> interface, it feels like we're already overloading it as is.

Agreed.  After being able to think more about this ioctl(), I think KVM_MAP_MEMORY
should be as "pure" of a mapping operation as we can make it.  It'd be a little
weird that using KVM_MAP_MEMORY is required for TDX VMs, but not other VMs.  But
that's really just a reflection of S-EPT, so it's arguably not even a bad thing.

[*] https://lore.kernel.org/all/Ze-TJh0BBOWm9spT@google.com

