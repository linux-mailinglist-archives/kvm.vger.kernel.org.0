Return-Path: <kvm+bounces-15209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89C5B8AA956
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 09:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 443B8283E57
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 07:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CEA46453;
	Fri, 19 Apr 2024 07:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eu9jaHFQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60D38487
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 07:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713512326; cv=none; b=eavvP5J8Gcd9xMFU9cTPGntLTHe1XZX8SI1NUGSH/QusueZDw90rFZuU3gyfndKTaSBmuUrOHElYYRMtssk3sAHBP6TcgeBT3cq3fKdjj55ncXEe0sPyH2xsoMgTXkGnWbdYUZxHrMTblOzybHxs9uTHcSndnqsmzopFbgYcLNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713512326; c=relaxed/simple;
	bh=Y/f/mgyt7bp88akdaZ9s0ZY+G+A6RHJ/76pkBzfaEgQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bVtR6iLjp0n2RxvAId5oLfELqsLSA/cFaBY+hLUrjVnOUXOGD0D/e42frr7xiQc7kto4ypjZyYKoy5QEmMq9wKNWp2Q/LtAuLWbmt/pCXSChVT4VZncCJ+bttpFBCY6ARlbDSJknoqdLqg2w79pCC2mpZtmW3nQSSE863IWJ4ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eu9jaHFQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713512323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=foFNvAIC2rOsHzxH9Cr3iI2euQ5V0PsZmOseyI5rE+s=;
	b=eu9jaHFQm/1P6i3xfpDTm6j3XMkN7q1DVbPmnb+PuARkky8KcAmCUVbOjI4mfBFNZ2GM9a
	qPPoqOQAzXy2N0F7DMWZtawNlU4EfsY99QqGkbfnWn680i2TsrJPGg/nlHjtfD4obwrW/j
	SmeLdD5IY/NdTiq+WFJruLf4M9rX8UM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-jDHlabozM8-486-W2oRMVQ-1; Fri, 19 Apr 2024 03:38:42 -0400
X-MC-Unique: jDHlabozM8-486-W2oRMVQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-343d6732721so951860f8f.2
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 00:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713512321; x=1714117121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=foFNvAIC2rOsHzxH9Cr3iI2euQ5V0PsZmOseyI5rE+s=;
        b=QOk9pkc74hcEkFAeOhNqdHc90bU75QiyspNFtrKqWNqiClu/Ej7UpBVY3H2czjL+ka
         s4MLmAFEizDVDdSiGo0gc34oBYjQPXvKS/rLYoHVXBXw6T5doHOvEKVcY5I+wFS+GdZg
         nLXhfgYQHMZtQio9vkWj1RYxlqSyyIsHtTFZ8Wg7p8wfPs4KY2/G9dKJQO/YsK2LIOXP
         MpsKiw+fre1+PYWmFxj6uaY3HWbni1fBk/fCqV2k4DFg/E/F9/whctQMB6Y7/eGQFyJG
         fYV4owq7dfAfZDO5zEBp3qJDBZcgYWKPNsCV07TTPAafuYcGqIrhn8MRMO3HcOLP41MP
         CfrA==
X-Forwarded-Encrypted: i=1; AJvYcCUqAhaGVsTu211SaX6qi1Sia3N3yqNuVN4qMw/lRdX+7/tc+B5z2opNsRI0r8IgBmHffi7r/P2W14LeawYbqrNIhekt
X-Gm-Message-State: AOJu0Yxvlg92IIBrbxnEBN6sUMlwaYp1S27nrJSlsNiic2jGYH/5vF1v
	RwvzgOm7O+5/c07tQQSnih0DcriCbuhjvz90rhHn4wVJUqMfO7D/9Vb9mv7kGfDMeLZj9NGD1AJ
	OKjOWE+747lLwgJAy4cHt5FHsvmaFrn9FJI3adnNE3v6QG0mgCa7HbNmTiusTzWDbZK3nkmGOLN
	9TR8kDnOV0/boaAp0EIiBpk2bb
X-Received: by 2002:adf:a346:0:b0:343:e152:4c43 with SMTP id d6-20020adfa346000000b00343e1524c43mr1078859wrb.2.1713512321308;
        Fri, 19 Apr 2024 00:38:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBm7gM3w4u49uGFHPoxgT4CnIjPG/kpt9B6lavOOvxtIFnr2HR6Ze5zkVnSN4GZ2f7T7KCLdmfJQEbjRPtbf4=
X-Received: by 2002:adf:a346:0:b0:343:e152:4c43 with SMTP id
 d6-20020adfa346000000b00343e1524c43mr1078843wrb.2.1713512320962; Fri, 19 Apr
 2024 00:38:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240416201935.3525739-1-pbonzini@redhat.com> <20240416201935.3525739-11-pbonzini@redhat.com>
 <9737d0db-0cce-41c5-94fa-c3d9550d7300@intel.com>
In-Reply-To: <9737d0db-0cce-41c5-94fa-c3d9550d7300@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Apr 2024 09:38:28 +0200
Message-ID: <CABgObfZv9DDkMFT0MpuxQ-U+BQqzURpAR-+mtVNU3pLBo_4XJA@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] KVM: x86/mmu: check for invalid async page
 faults involving private memory
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, binbin.wu@linux.intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 9:35=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
>
> On 4/17/2024 4:19 AM, Paolo Bonzini wrote:
> > Right now the error code is not used when an async page fault is comple=
ted.
> > This is not a problem in the current code, but it is untidy.  For prote=
cted
> > VMs, we will also need to check that the page attributes match the curr=
ent
> > state of the page, because asynchronous page faults can only occur on
> > shared pages (private pages go through kvm_faultin_pfn_private() instea=
d of
> > __gfn_to_pfn_memslot()).
> >
> > Start by piping the error code from kvm_arch_setup_async_pf() to
> > kvm_arch_async_page_ready() via the architecture-specific async page
> > fault data.
>
> It is missed in this patch ...

Ugh, thanks Xiaoyao!

Paolo


