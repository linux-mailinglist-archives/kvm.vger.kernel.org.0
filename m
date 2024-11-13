Return-Path: <kvm+bounces-31761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BEE9C748D
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAA22B26F7F
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE2E2022F3;
	Wed, 13 Nov 2024 13:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ofd69MPg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3FF2022D4
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 13:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731506290; cv=none; b=a00IBm9t1FWJikyD/HI8MNIql5ro+/jHh0hUyDEDTs2EZAbem0zNB2rhGq1dL5xuFGFx8S2gc0PPlFUjkXJbHmnjKMFa+RRwNvGnJOqgw/4lW4XRMYJxTiGolR429Tz3lbDzTeaiztVNHxMptmNhx3Q/IVKvbTBDSWHlAntY6q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731506290; c=relaxed/simple;
	bh=JZahVK6A6WHKFKpoo3TZaAZQr852dUJgztt9vEtkMuY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c4KxaFPDTF9bw7/rE3cTm/cmzPMI9GvssPtXg823+p7cjDlW6wCcmBxx0ixTp5m7bUmLYdkp2u78505swd4RbwcfgRhbZ9FkVE0YD269iMdUyY0APJjWF8bgb6N+wNpgh/1by5ChjyoWiDMdCj85+sBrIqdsA/2upsmklOh71D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ofd69MPg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e9be85190eso4387659a91.1
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 05:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731506288; x=1732111088; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ooEYI/UnRvsG1fCOLEZCFWu+Q4mDTiOeXH7s7O918kc=;
        b=Ofd69MPglxDKQRox5oqA6BiFcfonKIkM55PQIv7TgjDgNvf0awlAIGIq9sD+CBJxJu
         Vwew+8WJyvTZ0n9H1zBrz+oz/+lUESgUOmmMAZ7Aa81z2Ox+9iS9a+Q5dHTcIpjka5s1
         ignb+rRwMNupZ2DeXHK2TNYzLFpfOq3HZwa3x9FT/Sr3WE0I+vbvH3kaRhuuLXRJPdPq
         buThZQWrvGogMPJlK+A7Ydvo6cluoem4HftiKB0/qy0kKXOawBEn+NZqF2+NT1GLsiC6
         a6ISy99+Za4Tozfnqm0ioQ6mxpqGMRtAKnvVMAgt6GquKTS0STDc3U7DQKR7QXtR0lAE
         TgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731506288; x=1732111088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ooEYI/UnRvsG1fCOLEZCFWu+Q4mDTiOeXH7s7O918kc=;
        b=dB96FXf2h7a1tO70Ov3Svsz53x+wMChB1YzLWgXpoIX+2mAAt/FrGuDpgDmDHziCE0
         bHL8ixBlgLy4W/MTwi5svHUvo1czelIlrzhLZc8+BzP6508Qa/2KSg6riOYmtXIy/tOG
         HOkGtwIWBX9qiYJQSEq28d9Wc//7wB+7cNEGvNqVxabap12887YhpqtscHl3s/CmdAxS
         rP/0HS6OCjhDf8a9Pvx8BwzSrTGy3+o+hUyZJSi2DJ9Om36Qf7FO7DCNf4NlotY1S/zA
         VNXHJbVZb4VHH0ashU6uKgZktzD04m2ClZmYBfTijcfDIBIBJCSBRC+U/d6/KP5uPNuK
         pjuw==
X-Forwarded-Encrypted: i=1; AJvYcCWr7o8vdO9H6KlBz+yoaVZguHblk+eFgPng8CWPrCfhtj114rkeQoqkIlFtZCpo+vzl6SU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrTwwPEJKEaZMXkwA5myLw+TUkyE7yH7AUSN7thDFQdyT0yU2l
	zBcEi9EoGMId8A04Qtd9FJ35M+03gSDdMex21V6a/k7zHi5izQsZR9i/xhZshPLqfvSfiNMYAzz
	9xg==
X-Google-Smtp-Source: AGHT+IEmPnp5IUczH+svioRwvPbagn/q42BMQ4u7qufOju086L/jLjTrk3EtMxS9zXMDyy0TQFnSGJo3Zek=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e149:b0:2d8:a37d:b762 with SMTP id
 98e67ed59e1d1-2e9b177a544mr88593a91.4.1731506288404; Wed, 13 Nov 2024
 05:58:08 -0800 (PST)
Date: Wed, 13 Nov 2024 05:58:07 -0800
In-Reply-To: <20241113172902.7ada7d6e@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241028192945.2f1433fc@canb.auug.org.au> <20241113172902.7ada7d6e@canb.auug.org.au>
Message-ID: <ZzSwb6TQ9fXH37f7@google.com>
Subject: Re: linux-next: build warning after merge of the kvm tree
From: Sean Christopherson <seanjc@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 13, 2024, Stephen Rothwell wrote:
> Hi all,
> 
> On Mon, 28 Oct 2024 19:29:45 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the kvm tree, today's linux-next build (htmldocs) produced
> > this warning:
> > 
> > Documentation/virt/kvm/locking.rst:157: ERROR: Malformed table.
> > 
> > +-------------------------------------------------------------------------+
> > | At the beginning::                                                      |
> > |                                                                         |
> > |       spte.W = 0                                                              |
> > |       spte.Accessed = 1                                                       |
> > +-------------------------------------+-----------------------------------+
> > | CPU 0:                              | CPU 1:                            |
> > +-------------------------------------+-----------------------------------+
> > | In mmu_spte_update()::              |                                   |
> > |                                     |                                   |
> > |  old_spte = *spte;                  |                                   |
> > |                                     |                                   |
> > |                                     |                                   |
> > |  /* 'if' condition is satisfied. */ |                                   |
> > |  if (old_spte.Accessed == 1 &&      |                                   |
> > |       old_spte.W == 0)              |                                   |
> > |     spte = new_spte;                |                                   |
> > +-------------------------------------+-----------------------------------+
> > |                                     | on fast page fault path::         |
> > |                                     |                                   |
> > |                                     |    spte.W = 1                     |
> > |                                     |                                   |
> > |                                     | memory write on the spte::        |
> > |                                     |                                   |
> > |                                     |    spte.Dirty = 1                 |
> > +-------------------------------------+-----------------------------------+
> > |  ::                                 |                                   |
> > |                                     |                                   |
> > |   else                              |                                   |
> > |     old_spte = xchg(spte, new_spte);|                                   |
> > |   if (old_spte.Accessed &&          |                                   |
> > |       !new_spte.Accessed)           |                                   |
> > |     flush = true;                   |                                   |
> > |   if (old_spte.Dirty &&             |                                   |
> > |       !new_spte.Dirty)              |                                   |
> > |     flush = true;                   |                                   |
> > |     OOPS!!!                         |                                   |
> > +-------------------------------------+-----------------------------------+
> > 
> > Introduced by commit
> > 
> >   5f6a3badbb74 ("KVM: x86/mmu: Mark page/folio accessed only when zapping leaf SPTEs")
> 
> I am still seeing this warning.

Paolo, can you grab the patch from Bagas?

https://lore.kernel.org/all/20241028125835.26714-1-bagasdotme@gmail.com

