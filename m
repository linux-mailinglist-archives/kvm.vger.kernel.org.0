Return-Path: <kvm+bounces-26334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16CE697410C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45EDA1C255BB
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6901A38FA;
	Tue, 10 Sep 2024 17:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WKigZ8HA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FDD18FDC5
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725990561; cv=none; b=TrrppyUVHND7FkibaCSrzSTkYkMvIytPwOFcE5dMJ2N0sOXDBuPnWu7uiEhj8zMm0LxrePRkuoFE8/DoD5J6mOtd6T6aGiRQ3+t/YXjZM1vAWI/PxyeYUhOtuaT/f8mYnyxJOPWooER0Zcbwjor2Mi+9v5c4RlqB0nB9bU1Upfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725990561; c=relaxed/simple;
	bh=qD0RMhJC1X69Bc1xPhY+pcb8oykGLcMvvnLcohOLFbo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t7kv1lV5kqq4rL64jPfew1RVcG6+vAK/xzMfPNj1hOCBLzxaYoxyUgX8FV+37a1DWKIQW+cFJXEbdD0WtaHw1yIj5T/O6Z5eu3WMjg0122HCNDHWpKkQtYWzGsQHbWPEem+nlzuSAN/w1dVWN2MjcHwT8icTU4xirX8DIwl6VOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WKigZ8HA; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7d50c3d0f1aso4871261a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725990559; x=1726595359; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5GCtRoN4l/HV1t3VyVnIOd2i48Y7q41rosWH07pYdbA=;
        b=WKigZ8HA1IoP95uiI++0Wdafq+zMuWaW5BFqbgFJMJjCJ3y3JNaUbdBI6FKR+9TpDK
         3u+uKhZO+2XgIpuPqtH1Ysqb1Ojv9GVAV6IRBHkSi00kVZvOdo/WpoDTJf0OPhfmBlcd
         nGhKeULNXE0JA+S/599JXJ8P/5qBC5QqpiMtVB+c/NTe1BHHzE2N5N1yBFzzt/+DGQ7T
         +HctoNh8mQwy9NcxsPTILV22u9ZQ5Jn/dATnMDtNq1/BorRASjDqh34LojAFMjmjJ3nY
         xeBndjY5j/BU+GIww3eSe5nN/JRfIObD0vnuFWz8Wtjpt0vXbGONLFrlhhF1EbPIvaha
         0ndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725990559; x=1726595359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5GCtRoN4l/HV1t3VyVnIOd2i48Y7q41rosWH07pYdbA=;
        b=YJL2mF5K3ymPx1vJASvsx6BjY7XqQC0BWuFE/ph61sSIS66Uz0DAvZh7yF6retLe6O
         YoiddSB8rtTkHsh2zglgt40sPjg9ylT7VItopHyVwPS98mTI4qTUvsu6nRFB4g+/xn9H
         cbtH6HNsQ0Tb6MJVUVJNCIiOFFv1+kVEDBdweamy7IB5kzzeplPEUz/MUl9CaBgYloom
         LG0YkZDo6Kdsqmr2jXpmnuhth+q/hjIBJq6c1q60xSyClzeRvO2+xv0UlO9MCqsFTyMD
         STWWxcNEdSxsDYIHJpPU5WQ0nT0e4c2B+zYelV2RP1bXzTQSJGJUzbKu6Lk1Px24Hv1v
         BJgw==
X-Forwarded-Encrypted: i=1; AJvYcCUCNC+gnQUQXxOfo1Xa5Zumw4TWPeYOtbEwodi6HOvJG//SGA1olPVPUbQqaahQU9K947E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeZK7s//BjbqBi3iKV8pI7kBEBa3/seAQLoM9cX8O2aPQ0WXeM
	H/oSGihAzaacbGu45bF4lkPEsjgZCkdg2sZDDWEMQQ4RBNnaPI2Azf4obo+WHMgmsmv8c5rGwdO
	02A==
X-Google-Smtp-Source: AGHT+IE0bC55Fj5C1M7tUMI/uFlWyflj/zZjItUmPtulbZEQ/c7Awy4AZcEA/dOkmwlRR9wGz+mi9ExaqV8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:668a:0:b0:7d8:449f:1491 with SMTP id
 41be03b00d2f7-7db083b8b78mr13737a12.0.1725990558945; Tue, 10 Sep 2024
 10:49:18 -0700 (PDT)
Date: Tue, 10 Sep 2024 10:49:17 -0700
In-Reply-To: <0b8577af-222f-4195-8d75-d8cc5fcf6cda@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-3-rick.p.edgecombe@intel.com> <4eb4a26e-ebad-478e-9635-93f7fbed103b@intel.com>
 <4de6d1fa5f72274af51d063dc17726625de535ac.camel@intel.com> <0b8577af-222f-4195-8d75-d8cc5fcf6cda@redhat.com>
Message-ID: <ZuCGnaTMPcStRMrc@google.com>
Subject: Re: [PATCH 02/25] KVM: TDX: Define TDX architectural definitions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, Kai Huang <kai.huang@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 10, 2024, Paolo Bonzini wrote:
> On 8/29/24 21:46, Edgecombe, Rick P wrote:
> > > This leads to another topic that defining all the TDX structure in this
> > > patch seems unfriendly for review. It seems better to put the
> > > introduction of definition and its user in a single patch.
> > 
> > Yea.
> 
> I don't know, it's easier to check a single patch against the manual.  I
> don't have any objection to leaving everything here instead of scattering it
> over multiple patches, in fact I think I prefer it.

+1.  There is so much to understand with TDX that trying to provide some form of
temporal locality between architectural definitions and the first code to use a
given definition seems futile/pointless.

