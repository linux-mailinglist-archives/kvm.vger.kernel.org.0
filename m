Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F4D473529
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 20:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242460AbhLMToP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 14:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242424AbhLMToP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 14:44:15 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33819C06173F
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 11:44:14 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id p13so15886772pfw.2
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 11:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ME1prsBK5y2s/TuairpTrn8GnmoJtUSZrFIhH9W9WcY=;
        b=ZwYwi5inxpKI9iCEmuqii70nhXQojehT5dYm1r5u45whCEe/NINA/vD/UlTFswkrb+
         CSkBmBYfTYIApQiMVbj/mt3LalQyfjKaS0iShIU3Y8oDw+v39B1emW3y5PgKLiiWE0qA
         b6STiQ5k/8u8BsEDngpBFTAoJAbNf9mmSuS43t52JwbWr9p7RLwo8zV20VHMqJv3WPXN
         a4Xq95b3/UMg8qq4xfeGx3vrgGOaftNUKR8XirunkQBhO61dC0UGO0hGC4UuLvQYiNus
         iqvk0gp7KYNJQ8Z2JjKJf3URZcUfWI+qpWFboi7c0SrCu5DxaKvqZuTT+rUMztgZbVa6
         WCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ME1prsBK5y2s/TuairpTrn8GnmoJtUSZrFIhH9W9WcY=;
        b=TQY8CjzfRl5FGWPH9LZnjbufKFmCkHxHdVYAnuZm/unKVzoufmzUWT+Rzp8f8v3MXg
         wgDM+3AVm/HlVs6sDy926zPOu+r66qPq4NNuniwl43El3lkWQfGRbyOHXLHexrtSVYVd
         WGPWfXkPeNAxSfM6RSeXGDLFTNlaer48kTNPl+5aZWdUgCnJ0M96IXkYWmGfdSCrUgaX
         KGHXiC0xyZqIRgdyWWbxi7qRRpQWEusp+8XLxSxZYl8h3qczcTsppujz6Alh5UMGfoHp
         uTDKA9NVts8woaYuS0RabkVorarlHbWQLUOjTfKFxolAHCmNRBuRNriNSGY1Wzc3IZ/3
         5Nnw==
X-Gm-Message-State: AOAM53379wrSUl0CQDE83zeoE6cy+9rJ0BtZTq1A8iVc8callzhlsT0D
        pPxI+USgnG2fSIQR1BadqspTHZNkepWG5w==
X-Google-Smtp-Source: ABdhPJwnvqQ5c+YJfxrtRKuAgKIkvVSjuHwzczHzds1rPinaQwQcQyOgwZj0zbP55rAiNB5wrGmfnw==
X-Received: by 2002:a63:d103:: with SMTP id k3mr512140pgg.6.1639424653551;
        Mon, 13 Dec 2021 11:44:13 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a18sm12477587pfn.185.2021.12.13.11.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 11:44:12 -0800 (PST)
Date:   Mon, 13 Dec 2021 19:44:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        bgardon@google.com, dmatlack@google.com, stevensd@chromium.org,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix dangling page reference in TDP MMU
Message-ID: <YbeiiT9b350lYBiR@google.com>
References: <20211213112514.78552-1-pbonzini@redhat.com>
 <CALrw=nEM6LEAD8LA1Bd15=8BK=TFwwwAMKy_DWRrDkD=r+1Tqg@mail.gmail.com>
 <Ybd5JJ/IZvcW/b2Y@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybd5JJ/IZvcW/b2Y@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, Sean Christopherson wrote:
> On Mon, Dec 13, 2021, Ignat Korchagin wrote:
> > Unfortunately, this patchset does not fix the original issue reported in [1].
> 
> Can you provide your kernel config?  And any other version/config info that might
> be relevant, e.g. anything in gvisor or runsc?

Scratch that, I've reproduced this, with luck I'll have a root cause by end of day.
