Return-Path: <kvm+bounces-55764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E52E9B36FA2
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 18:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D27817B4962
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 16:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 820B32798EC;
	Tue, 26 Aug 2025 16:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NbbVULl4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C43B2773F6
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 16:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756224771; cv=none; b=PcNz8vvwbLu1GfHf2gFlu0YQkt/DD0XIxdPQMVaoL8AT8pL9Wj/hVoVR0VKZLIuUeOIxRe6nC25Lqlvl44wBEWB/v/mb8QzyVp6iJ6Eh7fTOPh3dXQxyRP5uReCCyQn+kr/vFt3eapdK9X3aCHVBSbH0X8taIcGfwbfujymBwKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756224771; c=relaxed/simple;
	bh=lpNJxIxdAxwJxU4ad3K/8xf8SB/3leQSRQ6Ul6aUQa4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CulAtCbpSCyDzW/xxK8HNY0rrY1ETPI9+BSz5WIumNldKPt43LiskhipGafESt2dEAJj8uOvkznY+3rqhXUWT3qTTRXwBVV0kDkS9rdQijSDGl0vpxDPo+kM6jE0pLUhH5PCZ6x1omcQLUyNEQnFQ6JbHeeFTFGXOUZQ+YXz6rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NbbVULl4; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b29b714f8cso442611cf.1
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 09:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756224769; x=1756829569; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+yShLrZrJiMcpakMkFlTcuZUxFmYo1J+gWIqNEy87nw=;
        b=NbbVULl4/+iaIrPor7/AVhOtfejsNPjYsQgEN4j4GermWgplRx9htSXk252RL5/QBE
         PzgvQvNPSkgJeM3jIZziSFRaD6LoVKiq/WCzYk8+0vd58EQ1KocNcfXTd3qxdAt7aOoy
         /kzE+3pWkErAsluyw13CHNV6XwhZCPuE6TsuGTQXFpYvixE/9HJmKlGnYiD2uvCZ4pU3
         eMHY3Zf/+aAuof8rfC3zraOgm9B4WCGBnuWGxV0TyMvHOodWl7eVuNFbk3Gzt/Ym/wsT
         hZEfvmyruvSOHbIPmMa0t9UTFwspWtRFOGtovRb2aHPMEXOjBz9YxWA8LWKMB4LXMZdp
         M1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756224769; x=1756829569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+yShLrZrJiMcpakMkFlTcuZUxFmYo1J+gWIqNEy87nw=;
        b=S8/VRGNyIBMp3fRqC28pGaAZNYkJFGMqbdcvhOMSbetwJuQaT7G157VET4IMYRHscs
         twhYvfGe9BWaxLrZwR7IlN3TFeHjlk6/5+usPwqTInwIhQclxl0nI5vAj7TmOKNHdkXL
         G//gVSR8n84nuEPJnr+UHTX5AzSYNgbE8vGgExxkA7mh3Q6pFdap//M587OkQm4oXv/Q
         P6JlKppDwkMPYmVS1WkUjmUlc8LgZBl+qiXLQ/Dft0H1k6pcV2aLZdycd58WOhl43p95
         mljTMREgazold0Tvxs5W7eenIbb865bDkcTkREsl5c8OaLDzEbtjkDFICw2mpUPhyBq6
         NxwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbC+6Yqo3np1arfnMApjleQ71mhlNU2cfI1sUVJ/GMRBAyB8Z2ww9h33tpoMYaWn1ESOw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzgg+z6AFqSBVOiAmE63yuo9WjnN+AH4pd5mIOJAeuFyO/lFOXX
	NfT2p9fD39+Om7sDCzixpU+YHMqR4Z+XJWnQT91YecPzyn+iN2yE8w3yV4MGKuabs3e3gMKyCxK
	pZQG0V6aVqEC4fTOK8xFEIiUBpS2ZwhJzTCS1sVIs
X-Gm-Gg: ASbGncu8b5dkQUPRJBFEH3cJhgajbBbv00/AKMCvnIkJQuRb+nDXqgAfwJxvlhrJlBH
	CO7RyX3p2bz2uMDFQhJyZaK7cr9wJurlSm33pNbbPTsWlv+M5ePMdiHWoGlqygg+dlJGbsg6GM1
	u5jeUzny2HPC13y+gAUFY9I80h9burSuZwecSfp45JNSAu1dx6lodhfBmqih4DUyy+kPHKoibOL
	+7R8VzUnp9hvALTk21jvA2vCZqflpmOZY3kzcQuXRfScO7FpDzW9m7H
X-Google-Smtp-Source: AGHT+IFVvO6S+pHDrFpICQlKDSU8oqWS2opzl47Wp6F8/5x5K3WItU0qoTqh+FfZuB0xx7wpKAFANxB1M2Uef/LWkQA=
X-Received: by 2002:ac8:570b:0:b0:4a5:a83d:f50d with SMTP id
 d75a77b69052e-4b2e2c1da97mr5618951cf.11.1756224768436; Tue, 26 Aug 2025
 09:12:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com> <20250821042915.3712925-16-sagis@google.com>
 <94f1eeb5-35c2-4edf-ace7-6917b06bb4bc@intel.com>
In-Reply-To: <94f1eeb5-35c2-4edf-ace7-6917b06bb4bc@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Tue, 26 Aug 2025 11:12:37 -0500
X-Gm-Features: Ac12FXxRdiH0_Etf0N3MHyniMjmTUDp8DCEiBrUG4BKEG3ue3GXyQJLjbFSxojw
Message-ID: <CAAhR5DGC77bo427gQkvEq_BaJYaYXMgrw9ESq2xp=ER7pQPCLQ@mail.gmail.com>
Subject: Re: [PATCH v9 15/19] KVM: selftests: Hook TDX support to vm and vcpu creation
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2025 at 3:28=E2=80=AFAM Chenyi Qiang <chenyi.qiang@intel.co=
m> wrote:
>
>
>
> On 8/21/2025 12:29 PM, Sagi Shahar wrote:
> > TDX require special handling for VM and VCPU initialization for various
>
> s/require/requires
>
> > reasons:
> > - Special ioctlss for creating VM and VCPU.
>
> s/ioctlss/ioctls
>
> > - TDX registers are inaccessible to KVM.
> > - TDX require special boot code trampoline for loading parameters.
>
> s/require/requires
>

ACK

> > - TDX only supports KVM_CAP_SPLIT_IRQCHIP.
> >
> > Hook this special handling into __vm_create() and vm_arch_vcpu_add()
> > using the utility functions added in previous patches.
> >
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > ---
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 24 ++++++++-
> >  .../testing/selftests/kvm/lib/x86/processor.c | 49 ++++++++++++++-----
> >  2 files changed, 61 insertions(+), 12 deletions(-)
> >
>

