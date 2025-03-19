Return-Path: <kvm+bounces-41468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 093B0A68165
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 01:21:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F1A21893AA4
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 00:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF8222F19;
	Wed, 19 Mar 2025 00:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KEWyzw6L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483A114F70
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 00:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742343680; cv=none; b=M38ksCwkTsS9crnsZ5pIg1gcdK4o99xsvJiDUbHUXezDuE0sGUExsGo44M2QOwaCDg9tfcaEL70UEu6lqX3XoRlQuAYRQnybSabkgux6duWMkSvSprxHeq48zY7c5ua8lhipLRm8DdO/hRhhmh9GUEefBFbg1FCYY2QnMpzTZnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742343680; c=relaxed/simple;
	bh=unLay0tWJo+zIRXLvZVziyeIsjh99OV0EyMiGD0jKjs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gYHUa0nP9yfd9IDlw29n7JNgUNCHfOARXwqsFIdgGx9sfbOBvq7x7kw+qFHyBuKlijpFbTQ5p/PhbMyPMDtrnk8hQdpCcijWUhfVuksrYCPMGK6ktKqtCnjrvxaz5QqWNIy81RO6E3HjeQhHOCg/a1roVQHh0QzMrtZgfw45WmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KEWyzw6L; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2235a1f8aadso96284835ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 17:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742343677; x=1742948477; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a+yivFEh5qOf2UENHN/ua45ozb9Plfqexph5vJsDbO4=;
        b=KEWyzw6LxIgg8KJPDyjzBu+U/TxXsxCZdLy9HypPZZPPTcGjzUQgFZT9RQLUE+otII
         LAjniK5rsgraI6SreUk5zK68gzvFgUnnpwZ+L+/Jcoswp4+zSf5l2fp3qFlH8uV6QQjp
         TFw0FaLf2NENSVGESYE0vhUMCkIdEZiTmUbQLTI0+kKJha4SXj+x8dWuHBKac8PGhK5i
         KwCsLXgVTvmApgV9LY3zWZQf9yMje3k3QDmak69rVNUqPnVCMICYoLjT8U0x93Yn3IQi
         VB4ahZ4d4QOGHODIdYrUCP4eJ+hNLPZQfTQQpQSA3O/0nUwAucF6SZ6ow75B87YG9qBJ
         CHPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742343677; x=1742948477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a+yivFEh5qOf2UENHN/ua45ozb9Plfqexph5vJsDbO4=;
        b=JCYuSOm2aVh7iYyWT8Hy1iUPQx0TjGzFRkSmDOgBl+SYUKqBPM6AJ6um1SL4VVFAu8
         sXlPXi/iO2NUnA3UhCDrLqh89wvm92k+nlX+gQ9+GDrjfaojFUnQMQkTmYyWtKbvswSg
         iJOGqsyqcCNSxrlmytRmNIOwdl4qgAN/S+jSnB0sq8vB2jyHKyC3ZGpmtNoRjSXkolQI
         cZ150PQ2tov8Eloihfmqyhkfv79YpgaFjgu5V1KKANiFp/IcbaGCNDuoDmWXCdJdyut+
         LENG/Na/xSopSbmA7TUfuAqEqO5VKhW9pGi33Ao20EBxUqgd1IMsnkkkQWxniwylLc1Z
         3Pmw==
X-Gm-Message-State: AOJu0YyU7jrnvHE3z4WQ44wCHY0mDVAo7QOert2UqRtD+uyPgUHTJlyt
	elzgkOwRHFSjdXGs+2o/jkR3uD+5JHc33drGY/O7vhKtqD/NF7jGDTOpLTZtihWVF3FvxqfAs7k
	NYA==
X-Google-Smtp-Source: AGHT+IEq4/7cPjXUO+Mo2YUDd3ALnRfSq57C6kw6lpsTJfLnABMI2+T+W5EaFja4SMuqH4TlZs7PaUIJ/vQ=
X-Received: from pjbpl11.prod.google.com ([2002:a17:90b:268b:b0:301:1bf5:2efc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e748:b0:224:912:153
 with SMTP id d9443c01a7336-226499284d7mr8967045ad.5.1742343677549; Tue, 18
 Mar 2025 17:21:17 -0700 (PDT)
Date: Tue, 18 Mar 2025 17:21:16 -0700
In-Reply-To: <6c811b8cf80eebdea921db41d16419919cfa76ae.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250310161655.1072731-1-seanjc@google.com> <6c811b8cf80eebdea921db41d16419919cfa76ae.camel@intel.com>
Message-ID: <Z9oN_KShuFYnUg5_@google.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2025.03.12 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 19, 2025, Rick P Edgecombe wrote:
> On Mon, 2025-03-10 at 09:16 -0700, Sean Christopherson wrote:
> > Paolo and other folks in Europe, would you prefer to cancel PUCK for the rest
> > of March (until Europe joins the US in DST), or deal with the off-by-one error?
> 
> Did you guys decide on this?

I haven't heard a peep from anyone.  Let's cancel, I already have far too many
meetings this week.  I'll send the official notice.

Oh, and I'll cancel for next week as well, as Paolo will be travelling (and for
other reasons).

