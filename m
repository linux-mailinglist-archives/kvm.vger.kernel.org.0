Return-Path: <kvm+bounces-35496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 681D7A11791
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 03:59:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C26AD7A0FF1
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 02:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A615722E41E;
	Wed, 15 Jan 2025 02:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JvuO+vsr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EC122E3F1
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 02:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736909959; cv=none; b=ruW5NDv0Gyzf0eopgHdNh7xliR75bm1eW0spEu/xXHZvKfVxuOD9NSEyDpJzoOg6bup4L8M7kF0QQ3lRQSSklUcWrOWrzaW5FpApCvcPniOYjBB4c1eVU44y2sDBVi7EX3RsppRJhhiuJ/1WRbLK7D/NKYIomBUTgwz4UvIirvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736909959; c=relaxed/simple;
	bh=+NTwq5YHWWKj+lNPYsiG2fx/Hdkl75Y1o+UgnaGwAS4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pqh2NJePCdnE2iz37kl4QLq+slz2ptEYeMwO8wmBVGkTrg2GcaTcXzIabTBrlBe3Gt9h+U0X7QGQCknVhv1k7ltM1rzgtyrW2sCYvbag9OzgjeNelQNmhb176WLqVngD8la+2tJChglfwVCoTZFsjAE9/gsRQjhx2j3sp0j4VVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JvuO+vsr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-216387ddda8so122251955ad.3
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 18:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736909956; x=1737514756; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t7UnkG2sUZHI5sYNTsE5cdnTS0itq3U5JxBO6rBeOoo=;
        b=JvuO+vsrZyUSzt7K2Ai1VLfFvkwgF9Mv5Ne2nLebfrc5ola/4zDQ8KwArcmBOKArNB
         nPZuY7wi9Tw7r3sKM/nOcZR0VXDNP/Ay1sRqymGhVOJm8p1STQZxmtsU8gqolby8v6qT
         DlO9CEdZaN2HGsSYwDjKzQfurWAzD7Ntv4gi3aOEQLlCubELBEyf38kx2k6aGgJNNCPt
         ZOX/h9zKpc9Kw1v6VksCdOZl/rkuXfyWfZAqY67kGpTJgyr2JMmX+cTb/Ht+XqR4UfXz
         mits6urSP/aDQ5g26y7is369EWyzPCboXcBRMXAm2ENWQ+0yjXrIklrClY3pL+sbRg6Z
         yVjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736909956; x=1737514756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t7UnkG2sUZHI5sYNTsE5cdnTS0itq3U5JxBO6rBeOoo=;
        b=Vq4wRxKcS/M6b11pjruNAvfRdoCEQfP2H5W2E1PhpqFihVm0ydeMy6cKbov3XnLxn5
         LzMN53UevnC3sfh906tYCRv4+ZrGVluUGd7F/Ci9TVtDihdC9qfS5/t8efFHx+6Ul4St
         bcN38O7p8OC2EVizlBuCg7DzUI7YkEtP6bfGq+zn+56r4CvvOVk95/vu55XzNjhkrx0D
         ZVCG0tc2CqwNE78nf9B3HZcSvizPOzXgavwuvv/3YLKSJSvm+i2Z2CYlENA06qoOhAJs
         oJvNNNZm+9YWuilUS3ZXDSmhICdwbE2kw+gRTlUYz4ZX1LtEFI78vXqLhhyB0kCY/1+9
         20Ew==
X-Gm-Message-State: AOJu0Yxx1+c54DgMtlctCP+ccN+kyotovLVAqyOPRAEd/5tpKhtX2LGA
	OKu4imTWjLGjkhsiYP0FCOE9del7I/4LZiM0ouEeMxwIDBjjkvnRlK5mpDUy/ckzBwxQUHFvLle
	OHQ==
X-Google-Smtp-Source: AGHT+IHP2Vogek0dpf9znZxDhDq348SkXY0vLKAUveMc2TfPFaRAGg96yS2AtQqvLlarPDTmxEzNmSW6cZc=
X-Received: from pjbsn7.prod.google.com ([2002:a17:90b:2e87:b0:2e2:9021:cf53])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ccc8:b0:216:4883:fb43
 with SMTP id d9443c01a7336-21a83f5efdcmr469853535ad.32.1736909955954; Tue, 14
 Jan 2025 18:59:15 -0800 (PST)
Date: Tue, 14 Jan 2025 18:58:57 -0800
In-Reply-To: <20250111002022.1230573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111002022.1230573-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <173690967333.1806474.13374894408719420681.b4-ty@google.com>
Subject: Re: [PATCH v2 0/5] KVM: kvm_set_memory_region() cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tao Su <tao1.su@linux.intel.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Christian Borntraeger <borntraeger@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 10 Jan 2025 16:20:17 -0800, Sean Christopherson wrote:
> Cleanups related to kvm_set_memory_region(), salvaged from similar patches
> that were flying around when we were sorting out KVM_SET_USER_MEMORY_REGION2.
> 
> And, hopefully, the KVM-internal memslots hardening will also be useful for
> s390's ucontrol stuff (https://lore.kernel.org/all/Z4FJNJ3UND8LSJZz@google.com).
> 
> v2:
>  - Keep check_memory_region_flags() where it is. [Xiaoyao]
>  - Rework the changelog for the last patch to account for the change in
>    motiviation.
>  - Fix double spaces goofs. [Tao]
>  - Add a lockdep assertion in the x86 code, too. [Tao]
> 
> [...]

Applied to kvm-x86 memslots, and pushed

  https://github.com/kvm-x86/linux tags/kvm-memslots-6.14

as well.  Thanks much for the reviews!

[1/5] KVM: Open code kvm_set_memory_region() into its sole caller (ioctl() API)
      https://github.com/kvm-x86/linux/commit/f81a6d12bf8b
[2/5] KVM: Assert slots_lock is held when setting memory regions
      https://github.com/kvm-x86/linux/commit/d131f0042f46
[3/5] KVM: Add a dedicated API for setting KVM-internal memslots
      https://github.com/kvm-x86/linux/commit/156bffdb2b49
[4/5] KVM: x86: Drop double-underscores from __kvm_set_memory_region()
      https://github.com/kvm-x86/linux/commit/344315e93dbc
[5/5] KVM: Disallow all flags for KVM-internal memslots
      https://github.com/kvm-x86/linux/commit/0cc3cb2151f9

--
https://github.com/kvm-x86/linux/tree/next

