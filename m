Return-Path: <kvm+bounces-39167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D73B4A44B5E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 20:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F53A7A2F00
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 19:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1951DC9BB;
	Tue, 25 Feb 2025 19:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fr0+biTY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B9A1990AB
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 19:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740511935; cv=none; b=GyMTg5LJx014V9+Yep5Q4EYk6AlVMj4FT8eDKsylflWQPhWBMS3Au9jPWoD547mXNuv4EJIwD8H39nLvHDPIN3LC1dgiW7J69F10SQDk+L4I0r9k0g7WUec+c4WZZqEAFTLGXXC6AU16u75gdxP27+KVc3L2R/3wLzbu8Sv/MXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740511935; c=relaxed/simple;
	bh=NtVhrDUKSLxiJQh2XUciSDv4EBEq4WJgLBRzQtg0t8c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MjSAC7xu/y+UasuEDsUSXfsAO2S/Xp990phlduJ00jEGhBOhAYZb/cdtF6kLN8/8h6wONwyQ6f93HMUmB+n6jzWVKG+MUeBNvWTQ2PQQsTI8ExY1ks4KN7EMD0BHjJZTJp7PpTcgzFICaXla2p76Eer+kzFm5IlWfKm5KhOiQ3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fr0+biTY; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso19806277a91.2
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 11:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740511933; x=1741116733; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GPny4zJ5nIUziM8QqDHNaiyFl2Lw3OunvlQZunrJi/A=;
        b=fr0+biTYJuFEmdjo2kWa35iGXn9lzHWsRiOc/HnAl3mhNh5SKsBYr/0HHtKQeoutSR
         45WaNxrb3QvySl89JnBT+oXHdPMSVLiCGpEF+lFsyHsKPmrYIgtbf85gNzHII6Xj/Yyk
         IBvBjiOFI+h/l8sczDsiDYfbZmG6XHdhN9y36v9XPqYvvNR5zAYd8qXR7Phq97n3GZgk
         EkICW7csXnIjm4q8oXevc/MRcFx/NL27lLKSy0PpRdhdj7J71uuhkxExTHdNviwze7l3
         gmdV4hIqVtxGHg0kp47BOqkDcXz2kOI64GozrmeJMJmKWdSRLwBCYJR1lVkCkzAbC6Ls
         FbGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740511933; x=1741116733;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GPny4zJ5nIUziM8QqDHNaiyFl2Lw3OunvlQZunrJi/A=;
        b=T0XCupgJHSVnAk9WNiD6VKye8k3gZGp4xEDo4jUIFQEdrOMZG2WsGEL6LsZlMFUZrv
         AOZi1IRP87gwSu6YHvgquaQYkyXjuqfDBZv2eKN8R46zCkIlOl5OOIyVFHz+JzW2ILgx
         NZXWlCAmARYCRwlo9E7jdiQ/T8JsUs3w1WdZMMwtwO9Z7E6ekChM/gS4ifIJvwhlkxxs
         4FCVYXfw1F+2OCt6FKjXjdw/ABjr0w5ivmBCc2ADXQCOY7uJHLbt+HW3yizR4aapeixP
         8C9vJJgA+Tvv5RInco3Qf9zJ/M3P33wQRtyYTUd/OXZKocPlKVA8K8R0oME4UUB5ECLv
         QKyA==
X-Gm-Message-State: AOJu0YwCnaPKYzmN6xD+uZe/YsXmslXjLMcMRisOkcJMqO5vD8V5gxIQ
	UzbprMAtzju5Gbt0cNuJ5QBBZH6DcykCBeC3I/X2GwOgWhYvyU/l0nVaPum2nK/3/D9/9zkx7yN
	4Ig==
X-Google-Smtp-Source: AGHT+IHBkb5qWfWlFBCnNn8Eye1JmX+PkVUFjUoV9iqtYD4rlUWx59ajMVUBjqFU6iPKu2Be8EIWccv0DaA=
X-Received: from pjbst5.prod.google.com ([2002:a17:90b:1fc5:b0:2fb:fa85:1678])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc5:b0:2f6:be57:49d2
 with SMTP id 98e67ed59e1d1-2fe7e32b7c8mr1027303a91.17.1740511933291; Tue, 25
 Feb 2025 11:32:13 -0800 (PST)
Date: Tue, 25 Feb 2025 11:32:11 -0800
In-Reply-To: <5b63fb37-bb1a-45f9-a6f9-58f6bf5b869e@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241001050110.3643764-1-xin@zytor.com> <20241001050110.3643764-25-xin@zytor.com>
 <Z73uK5IzVoBej3mi@google.com> <5b63fb37-bb1a-45f9-a6f9-58f6bf5b869e@zytor.com>
Message-ID: <Z74au5wLvtFuJuS8@google.com>
Subject: Re: [PATCH v3 24/27] KVM: nVMX: Add a prerequisite to existence of
 VMCS fields
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 25, 2025, Xin Li wrote:
> On 2/25/2025 8:22 AM, Sean Christopherson wrote:
> > On Mon, Sep 30, 2024, Xin Li (Intel) wrote:
> > > Add a prerequisite to existence of VMCS fields as some of them exist
> > > only on processors that support certain CPU features.
> > > 
> > > This is required to fix KVM unit test VMX_VMCS_ENUM.MAX_INDEX.
> > 
> > If making the KVM-Unit-Test pass is the driving force for this code, then NAK.
> > We looked at this in detail a few years back, and came to the conclusion that
> > trying to precisely track which fields are/aren't supported would likely do more
> > harm than good.
> 
> I have to agree, it's no fun to track a VMCS field is added by which
> feature(s), and worst part is that one VMCS field could depend on 2+ totally
> irrelevant features, e.g., the secondary VM exit controls field exits on CPU
> that supports:
> 
> 1) FRED
> 2) Prematurely busy shadow stack
> 
> Thanks for making the ground rule clear.
> 
> BTW, why don't we just remove this VMX_VMCS_ENUM.MAX_INDEX test?

Because it's still a valid test, albeit with caveats.  KVM's (undocumented?) erratum
is that vmcs12 fields that are supported by KVM are always readable, but that's
mostly an orthogonal issuue to VMX_VMCS_ENUM.MAX_INDEX.  I.e. KVM can and does
report a correct VMX_VMCS_ENUM.MAX_INDEX based on which VMCS fields KVM emulates.

The big caveat is that VMX_VMCS_ENUM.MAX_INDEX will be wrong if a VM is migrated
to a newer KVM and/or to a host with a superset of functionality.  With those
caveats in mind, it's still nice to sanity check that KVM isn't advertising complete
garbage.

