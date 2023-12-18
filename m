Return-Path: <kvm+bounces-4749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 062C7817A77
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 20:01:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DABAA1C22EE9
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 19:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503A41DDFC;
	Mon, 18 Dec 2023 19:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WbWXJNho"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38731EB3F
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3366af69d4bso1046991f8f.0
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 11:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702926039; x=1703530839; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c+Edgev1I87JalzSn854oenOWC9y7aW6kdAK/idyvHg=;
        b=WbWXJNhoePROeJTf/4sSWyGOp5Utd7BzsvKh0CHyDrIjwkGy1Yd8C+mQUXTGAMiKAT
         BnHJ6sMbnMTChxfYp5n90rAJEwlafDmgkRpruZKrStSGPHiKMVVFi/0hlp9TEjPUHd/0
         AjonF4K/uVtSuHpqYKimrQ0iU2HZ+Y5dJYbzIT8sgrQCrF3yDRmVTGZRM2qEb3jNxmDU
         xnf17AeUJW5c3dEF+TpPE3uj+/v59BHl9aMZMewnZs7Lwa6AF/ff3Py6c0xzVTt5pgVA
         5yn6kOJTpGsNOkCDeK3b+1h2bXen+BJ3BhlM9ohOMNAcEaA35BYg5ggSX/tsQfncvR+F
         X9Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702926039; x=1703530839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c+Edgev1I87JalzSn854oenOWC9y7aW6kdAK/idyvHg=;
        b=ufbcju4eLxSvSqkmJA2LtdW4L4p4j73U9fbyfO1/EXCjgm6sIb572E1CVffQNSA5+a
         sWHsauWDVHryaPfjBxDVn3/ebLUVG5rRsH3SUcc7acGkDKVqHKbXQebe1k5toTBpJZdA
         8k8U0UGyEBhHXxmFwvvSsK5ThcVBaOxLatRr9Z4BcaV9I8WXf5zb/IAXXjFL3fXvBVNS
         8BiVHQqPlrZPCTixbrsaMAxrVmb56MV67vLCX6LINAUgdA5+S8sxyIlbnyiRoR6pa50A
         I1iiFN32YaqUb0yUnTygAl19Gt7HXurPyr1jk9ZzbnfMUndvThz9hGmC+FgthxFQJ8du
         qmAw==
X-Gm-Message-State: AOJu0YzvMWZoqynpdNlExLJlr4ZPTOKWgOJLh6C8gCqKbZyMyxFWw3G1
	IUntCCRWvZSMd1KM4nFjKu30siE8Apd3dAWYlnrpj1BTDQ/uPU6GeFQ=
X-Google-Smtp-Source: AGHT+IHEEMCktVnjwAlyXA+x+CJM0FQsbADkB6K7dT7/2bi3rlNUq8JuGatgaO8nsXjTv+jyu0cNKJGt1xFtd3iapto=
X-Received: by 2002:a05:6000:124c:b0:336:5e98:84c2 with SMTP id
 j12-20020a056000124c00b003365e9884c2mr2258829wrx.68.1702926038821; Mon, 18
 Dec 2023 11:00:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231218185850.1659570-1-dmatlack@google.com>
In-Reply-To: <20231218185850.1659570-1-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 18 Dec 2023 11:00:09 -0800
Message-ID: <CALzav=es5MKYFCQe2rRhWghFOa-KtxJZ0NCdOzZRMpf=XFq39g@mail.gmail.com>
Subject: Re: [PATCH] PRODKERNEL: KVM: Mark a vCPU as preempted/ready iff it's
 scheduled out while running
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2023 at 10:58=E2=80=AFAM David Matlack <dmatlack@google.com=
> wrote:
>
> Mark a vCPU as preempted/ready if-and-only-if it's scheduled out while
> running. i.e. Do not mark a vCPU preempted/ready if it's scheduled out
> during a non-KVM_RUN ioctl() or when userspace is doing KVM_RUN with
> immediate_exit.

Sigh. I forgot to drop PRODKERNEL: from the subject line. My apologies.

