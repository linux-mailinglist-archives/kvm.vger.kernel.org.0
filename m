Return-Path: <kvm+bounces-10514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D16D486CCDC
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 16:26:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DD2B1F25140
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 15:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8AEF143C48;
	Thu, 29 Feb 2024 15:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VJpUdHmF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD0113B7A0
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 15:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709220357; cv=none; b=UfU7QisIn9M0NofDbSik5J43xKb51iA+vA9fVEej3RMUjWZhGOVE2JVLFHQR7SEF7fO03fpejwJjZVN/SLMBvLnuSDUffsU3eZYGJeXws3M2zb8MAZtYFuZFwvXKV7TOPdqaLieR0I7SV6moVe/bz1soMcmkwrt2PzitSXc5Zs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709220357; c=relaxed/simple;
	bh=7HaQhAX6xe9m6UV2kdfbt42WvZeWdh2pF9QplgSu0I0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RkyiLnYV1FFkLlR9j6j7jYD7Ik5XuCDxuVVC5+PjpdcZ1gu0W9OYM2OW2sNVWt6hni0ZOU1lIoc5Zr2UaSrXS9eJ1h5MkXXMlt0jG7mwsgThS8/Xn070JoQz0XNoq+7GGBvUVqZDcTX+PmYYvMxbqdzPvvM/OPH3zPXyhCmeurE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VJpUdHmF; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5c65e666609so961959a12.1
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 07:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709220356; x=1709825156; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J/OUKQeIqZ+tPyZREllTuis7KcKSDMU8Twx5UZE09wY=;
        b=VJpUdHmFZI6P1bVHp2RR7lnAuXki0/vQUofLBZoQOBKfMt9/+ayg0UD9mCTgnb0VmN
         QRjoLV2JXVTF3lF1YC8ICjEo5JkWGX5r8gXuHjXSCrh6iVW2n91uv/Qb971fHQeqWepM
         cEGQKERG8XRTTC3nzBDxHzr6tzRyf83hz1i+VFXZWJ0EzngOuZO24kYyNJK9gJhydING
         VBIA7rGDJWMGqzABGROo0f+sqht4z9jGHmuqY2TxQBIOAUI539Up5M9ctMRwFacXubf4
         /GGOkox5snGrt3Zygojl8Fac7iuqQJfPCK1JE4MLLtlhQkEbi1fgtGxlCqu3WdDkYQLO
         BPdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709220356; x=1709825156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J/OUKQeIqZ+tPyZREllTuis7KcKSDMU8Twx5UZE09wY=;
        b=qICJs5amPqmuRFMqQdcgAxYDEZrfvVE2q6cPKwX1joENIInxTMQ0C6ypUR3/GtOZCQ
         0FTB49L+zO+U/bggYsn1Qm4nQsFMX4v231QoDAS1c4DlSkypOuKJqIjHzjK8p3WRSSoO
         1xiUiBSH5Hw7hoEQkcBWkcSYQ9vxCWxkhjYajTkKH190AV6MNHHQ1+XJDQF1M+qGFDHS
         TlLobBUzIpfBmIjMJ/MEZsxFDdPUUHN0HNF8HJgcEDpn7w0e2C4scwgSd7zOtH6apFzr
         89RZn1WjWssCkUY4tRYwlxvDEkCT6GlM9N1KIs71BD1Pgjz/RoP6Sa5MWRizx2VeI+Nt
         IuWA==
X-Forwarded-Encrypted: i=1; AJvYcCWPI3B0Sj41qXVEk7kF6y59TTFzkajXw0hgdpr/MgIR2gq6AH408Nwd/4PnV4+E8dCQcZZF9tyqRf+/14eCduA+WZjr
X-Gm-Message-State: AOJu0Ywuod5P/M0lqBHA4U6kVttuZs8EMMngBTKR1Sr5a89v2fO9jB4L
	AIED/3engn+/noAUR3bfGeI3TavSnmXzIX8tEX62DW9CfBFCQGXTrrd9MckrPqrYENWSqJKpfO9
	VPw==
X-Google-Smtp-Source: AGHT+IFcY5ykGfuU2E3p3uqw4eLL/QbuMIeXA+dQAq99sKjkzUzTj45nanFflAnsDVDAhomKo3E14yeSXZ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:a0d:b0:5cd:9ea4:c99 with SMTP id
 cm13-20020a056a020a0d00b005cd9ea40c99mr6381pgb.6.1709220355807; Thu, 29 Feb
 2024 07:25:55 -0800 (PST)
Date: Thu, 29 Feb 2024 07:25:54 -0800
In-Reply-To: <c0d80c37-ff1c-9c94-e1ac-78d26ee4da15@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-3-seanjc@google.com>
 <c0d80c37-ff1c-9c94-e1ac-78d26ee4da15@oracle.com>
Message-ID: <ZeCiAugERaMYq2Yw@google.com>
Subject: Re: [PATCH 02/16] KVM: x86: Remove separate "bit" defines for page
 fault error code masks
From: Sean Christopherson <seanjc@google.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 29, 2024, Dongli Zhang wrote:
> I remember I read somewhere suggesting not to change the headers in selftest.

The "suggestion" is to not update the headers that perf tooling copies verbatim
from the kernel, e.g. tools/include/uapi/linux/kvm.h.  The duplicates in tools/
aren't used by KVM selftests, it's purely perf that needs identical copies from
the kernel tree, so I strongly prefer to leave it to the perf folks to deal with
synchronizing the headers as needed.

> Just double-check if there is requirement to edit
> tools/testing/selftests/kvm/include/x86_64/processor.h.

This header is a KVM selftests specific header that is independent from the kernel
headers.  It does have _some_ copy+paste, mostly for architecturally defined
bits and bobs, but it's not a straight copy of any kernel header.

That said, yes, I think we should also clean up x86_64/processor.h.  That can be
done in a one-off standalone patch though.

