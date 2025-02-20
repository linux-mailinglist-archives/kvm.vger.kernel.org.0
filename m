Return-Path: <kvm+bounces-38771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19DC7A3E40F
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 19:36:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C2461895B1D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0BF32135B2;
	Thu, 20 Feb 2025 18:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qzaldBYj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E22204864
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 18:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740076605; cv=none; b=LddVtMnqhg62raH+7NFjOncyC00xAE1apOmN/onr/s+d4gTJOVSfTA6k+b0ILfO1tPup5+OlqpoqhosMWUC8lxJH3amlkA0R3UaU5h4/XY1yIXbeOLww0nYK1QN4Hf0RhU+0K+iwclrbDSCrixOquWxqHz4l9EbTHqMn1dQBtFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740076605; c=relaxed/simple;
	bh=KlLfu1MkFZm5HEQhrB3pQU86Of3CyX4PnSBkP+c7phk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gMIdvTQnTpvGBCz++lkijzOB6QRxcSQrnNDjZurkpBpKvAFFFlXYIVbk6DBGhq8OrXMNoQDKhTLBHzEyMcJiwPJq24vEwiG1eg3V0ke8hURONdy1QmnMZ+0AxjOOzjeGIj4dbqOKtlm/sgC5vKk64eBMfUNUtx7B08caiBYe4e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qzaldBYj; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-221063a808dso24935045ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 10:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740076603; x=1740681403; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UDNUvxXFmySrAvdSQJQ7oCShATU6CPkIP5Amx5DX2gM=;
        b=qzaldBYju7YKzjPMKoymufxXkvBPr898YFr8OTVCCbKQeAYu6M1wG82mWyh3yAeEcD
         /oEtLexkyXIhJ2pf5O8+QJ1yOmAI8TPWBsU0xAl1lYa3KcTdx2b8VJYpBibVB/BuKgva
         ht0HDLb8f61a7zSXzHVWpPaqrIffWFS6FwKBZYqWk5wsCGp3elbzIE7QHvZM33WZHXet
         G5LWREAXiqoMZUBIAvmlJKzey4ccpfhBpJqcxLkCqFkelM/Paz/QR4wW4UO4wt/7tOsN
         RgHJKQ3zvBzgZULV/14NEQG/i+IIF6EcO71C3LDhEj0h3DAvvKWdGrLXx5eP7Mg+MQT5
         cAUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740076603; x=1740681403;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UDNUvxXFmySrAvdSQJQ7oCShATU6CPkIP5Amx5DX2gM=;
        b=XkJYwL2eD09r+10Bd+QkXqqkaY0wYfELOSypMIrhxKJ0GboZltJcFKSk7lMZzurlsQ
         i1ane00dnmZVyr8AQA1k4gSHZ5Q2B+mdlTCMqkBWv344HscX4ncHJlKLMLZJa6Vuzd3P
         GKtc/8HMHQY9Hf5ENuNvMHkOy/YKux9aJ468ATMe6gQv0GjBI/3qTKct1uFP/INyFGQq
         k08Jj8XX/DbW3E7y7hpB2un1lUVzL996AVRoS6dbDQ1M+UnHbx9eR808LsWWYvWZ3xD5
         c8tVRYDZ1C0aYTdKlRxQeqpppkrWeOGVu/NxRPA+2VrLbXkPvKOVBjiQT6CwLUnkijpw
         8kAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwfhBSB5DBbzSkzQPBC+dGeLQHWJ9cMd8nfFZ5hzn06wys40mGvBRqE6hetJ+8M0djaxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmlL2glw4eA9KUp/rSOYVisSTHOu9P1JHToS5DAwk5aHk6Tj0T
	U3Kki5XuLcVPvyiffC8OYODMvObB97L2tBNgyTref4/+se6CZQ1wdz4gp4AEhlo2setCqlLJ/4F
	oAw==
X-Google-Smtp-Source: AGHT+IEJil2ZW7pHAGLzwraa/fR/QRtEg4mHPzfjLeTf/sMrCYQHYA2Opge3qlpebbm4GGfgfIrW2itPA/c=
X-Received: from pjbsy7.prod.google.com ([2002:a17:90b:2d07:b0:2ea:4a74:ac2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32c5:b0:220:e63c:5b10
 with SMTP id d9443c01a7336-221a0015676mr2719115ad.34.1740076602974; Thu, 20
 Feb 2025 10:36:42 -0800 (PST)
Date: Thu, 20 Feb 2025 10:36:41 -0800
In-Reply-To: <DC438DC0-CC4B-4EE2-ABA8-8E0F9D15DD46@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215011437.1203084-1-seanjc@google.com> <20250215011437.1203084-2-seanjc@google.com>
 <DC438DC0-CC4B-4EE2-ABA8-8E0F9D15DD46@infradead.org>
Message-ID: <Z7d2OSNSXIi5PAiR@google.com>
Subject: Re: [PATCH v2 1/5] KVM: x86/xen: Restrict hypercall MSR to unofficial
 synthetic range
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Paul Durrant <paul@xen.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>, 
	David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="us-ascii"

On Sat, Feb 15, 2025, David Woodhouse wrote:
> On 15 February 2025 02:14:33 CET, Sean Christopherson <seanjc@google.com> wrote:
> >Reject userspace attempts to set the Xen hypercall page MSR to an index
> >outside of the "standard" virtualization range [0x40000000, 0x4fffffff],
> >as KVM is not equipped to handle collisions with real MSRs, e.g. KVM
> >doesn't update MSR interception, conflicts with VMCS/VMCB fields, special
> >case writes in KVM, etc.
> >
> >While the MSR index isn't strictly ABI, i.e. can theoretically float to
> >any value, in practice no known VMM sets the MSR index to anything other
> >than 0x40000000 or 0x40000200.

...

> This patch should probably have a docs update too.

To avoid sending an entirely new version only to discover I suck at writing docs,
how does this look?

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2b52eb77e29c..5fe84f2427b5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1000,6 +1000,10 @@ blobs in userspace.  When the guest writes the MSR, kvm copies one
 page of a blob (32- or 64-bit, depending on the vcpu mode) to guest
 memory.
 
+The MSR index must be in the range [0x40000000, 0x4fffffff], i.e. must reside
+in the range that is unofficially reserved for use by hypervisors.  The min/max
+values are enumerated via KVM_XEN_MSR_MIN_INDEX and KVM_XEN_MSR_MAX_INDEX.
+
 ::
 
   struct kvm_xen_hvm_config {

