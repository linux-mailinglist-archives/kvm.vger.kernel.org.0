Return-Path: <kvm+bounces-19058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A89E8FFDB8
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 10:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAA13B23DB2
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 08:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F1E15AD9A;
	Fri,  7 Jun 2024 08:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LTtYZ1vQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A54F153819
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 08:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717747237; cv=none; b=ZA8pbPeh4u94ZVoal8DzLwgnD29yGkRCISJT8xVe+ACbrKu/OZaZck03WxL7U+32m8eXeWT35bGnRQRi2bP25Fwwl2aZZJiW3MrzIS77DGvh+G00t40UcHFaIKtRunfXUWcQDNJ0rW2mAT1ajc8ERaahDK3Fxwdo0bTwZSLKJDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717747237; c=relaxed/simple;
	bh=oNxSAuBoC9Rq3RAiBfP7Pj7KC2X0qYrJRitwV4RgUGQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KjaDxCt269lo0jaCKmY6nLH2aCzklTC6DGT94B+lbvrxtqrptMHK4HS9YVLo1qGcthj65Px/ZknjTrvtDzZPdNIt9s5zxBDoXbwCEXJrHdDWFlvQTY/hob8m5jE8C/NzRnGilBW51RuZDxDH9grI+pvW5WRDXG0pKhjbo+njdBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LTtYZ1vQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717747235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LIC5ST502mWLGRzx98Wcntt/WKTFrMsaguUwt9JTDVk=;
	b=LTtYZ1vQpCkoTgPkAihoAYPQNwUd1hz86UJjJ+54dSiGyfXI4ZE5RBwqE/R1ORCnncOgLM
	F3NF51lb7yXrBjE+5YxGPgg2VPc1JIbq91OVlk7TuUTeAonwzCgG1sre6VJhtLrGItgsFP
	mVm3rxcwBAb3Wf8s0wgxEwqP6PDLCNw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-6NDzmgW-OLqNMV3yTy19EQ-1; Fri, 07 Jun 2024 04:00:32 -0400
X-MC-Unique: 6NDzmgW-OLqNMV3yTy19EQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42108822a8eso15039205e9.0
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 01:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717747231; x=1718352031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LIC5ST502mWLGRzx98Wcntt/WKTFrMsaguUwt9JTDVk=;
        b=pEy8b08T2RV9aFqE8Ek9ppKX4p4PU+7q9y+SXfSQPbn2nJ99ne9O47EQOCHVXtLsst
         RD99+jbPwbbdFC04PhmpVGgpoF75d2/7KwQbNV/YQQMHUlYfX+tsBZjwQ6mGJLsC92aW
         2M7rZ4WYpaUsnBw1E7HVv6GUdJt4cZ8cmkypP03I83qouyQv6zrMuyYSw4nN2ItNo5w/
         Ruq8jtX0hr617StiiP4JCzEAsJ1y0eBqYmssT9Xx5GClhj/LesNys8BdBJOmeLgX1zb4
         RWVwjbsj5sGr0LEs1BnOKY0frtSSRUIoWf3vjni4/pyD6JznbZohj7QRxYnKGban+N9J
         7w0w==
X-Forwarded-Encrypted: i=1; AJvYcCWHzPIz77whgjuVSpyFbPGeTZJmJGPDrbyYSDIvUv4wPe0nsXfdKGJO0nDmfZlOySdkFgt0aDGFuEvHJU+UUcNJKcHi
X-Gm-Message-State: AOJu0YxZ0FKQVorlEn5aXSAgj+YZVa2NRLFUS3WpI4FHWKrL5aDa9WUf
	mgg8mByETnz2bVOwmhV/UzfERwLkGi1aeS4Eh4EUITLtW/6MxL7rPLE5S7u89FCM/HFqMQLNt1B
	SBRcojkjGXqNZfy78mdS7Rn/JHTGaKq+GvXABCZEBfPCRHG6/iTCDNqB59cGqKmUpLsfe0W1YhT
	oXmbee35UOahjatzp7J7UV8Lsx
X-Received: by 2002:a05:600c:3503:b0:420:29dd:84d4 with SMTP id 5b1f17b1804b1-42164a32b3dmr16587045e9.13.1717747231629;
        Fri, 07 Jun 2024 01:00:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFf8VmunjtYddmqCV8lUMRd+Fgeu8b3V0xVIaYgKZvZ18JU7CTxTwELQm/gwU1s+OkgoEJs3FeenAgsaKrKZSk=
X-Received: by 2002:a05:600c:3503:b0:420:29dd:84d4 with SMTP id
 5b1f17b1804b1-42164a32b3dmr16586865e9.13.1717747231288; Fri, 07 Jun 2024
 01:00:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com> <20240530210714.364118-7-rick.p.edgecombe@intel.com>
In-Reply-To: <20240530210714.364118-7-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 7 Jun 2024 10:00:20 +0200
Message-ID: <CABgObfY5HhB_3f=+51CRNpx0LEbEVqGTnpfX5GFTDwHtCfq6-Q@mail.gmail.com>
Subject: Re: [PATCH v2 06/15] KVM: x86/mmu: Support GFN direct mask
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kai.huang@intel.com, 
	dmatlack@google.com, erdemaktas@google.com, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, sagis@google.com, yan.y.zhao@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 11:07=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
> -                                                  u64 nr_pages)
> -{
> -       if (!kvm_x86_ops.flush_remote_tlbs_range)
> -               return -EOPNOTSUPP;
> -
> -       return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_=
pages);
> -}
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_=
pages);
>  #endif /* CONFIG_HYPERV */

Ah, since you are at it please move the prototype out of the #ifdef
CONFIG_HYPERV.

Paolo


