Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA72669BE5
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 16:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjAMPYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 10:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjAMPYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 10:24:23 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7086A4C57
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 07:16:18 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id w3so23737142ply.3
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 07:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ov0kEaQNguNvqY5BkFVlQt5XzWOzffj5cGq6JbJigsY=;
        b=EkQbiCciY7CEom4dx4NCNEUrD4IZHnF+SodCk3McvKZYAE9h+jcKa0fHA8u9P6DIM6
         XQb2NpbYUs0RPLteQBO+HTjLyeUcWUCCsAAiUeCVKmUmBi6IXcPUBXrD8CZzW+MLev63
         vrgueCTaLoLFAm1c/Z6aU9pANWPchjLC+sa+/yRaROfFLZ9GK4UCBMj+iXooj/lXhcSY
         lOlZgoxlBVPH3OExJJ5j9KUoTtDnbn0vA8+TKELgS5ezfSpagwq0qKoafNiecAArV97E
         +Akzf1uMbo6o63ksGCLoMMlcEWgovvvjJBeskRUrcxZxaLWttsNuH0A0UO7nQsxbrjGb
         F/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ov0kEaQNguNvqY5BkFVlQt5XzWOzffj5cGq6JbJigsY=;
        b=v7Dxj1DEJLcXNTSlhKUmGg3TASxyBJo1t/g3nT/WA3h/rJtdyrGzZ4yMh3zkhmH86b
         U8SbLf7LoADyO/fDhhTHDmRyuFQMIxYKHYlULG6u5OUoqah3m6l7r8BwhRlOUCm6CkSB
         IGoe0a3fE5y8iz0bmnC/W9ALFbiwEOQYFfNO+TQsbKXvtWQ0tJt83IKKByc+xvktdLiS
         CH8O3f7JggcCB1oMxEK2+8hGXoJifhEHITprG3OZwP+NyeuiE/J6MhXMk5cvSSC8mWgx
         TaN42CqAnImqYBokEy5sL916+tUvtHeKLthf9F5E2m20Ar9SqK3oER1zwaQBFeUvWUYX
         YaaQ==
X-Gm-Message-State: AFqh2kpYrJRGyPsCgLI6Qk5nL+HDpq7gcZuv+vjgLxR7XmJmHe6Jbzuj
        9Iwh2fZu4pEL8qE64Wvr/U5Wdg==
X-Google-Smtp-Source: AMrXdXsBFPCbqRyGPf0+Mba/4CiLcRkqUldtijkhu4uthoaKZXRE9c6KenZasCYhDsC8a+DERPCCzQ==
X-Received: by 2002:a17:902:e808:b0:189:b910:c6d2 with SMTP id u8-20020a170902e80800b00189b910c6d2mr1519514plg.1.1673622972593;
        Fri, 13 Jan 2023 07:16:12 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b00188f6cbd950sm14265615plh.226.2023.01.13.07.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 07:16:11 -0800 (PST)
Date:   Fri, 13 Jan 2023 15:16:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <Y8F1uPsW56fVdhmC@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
 <20230113151258.00006a6d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113151258.00006a6d@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023, Zhi Wang wrote:
> On Thu, 12 Jan 2023 08:31:26 -0800 isaku.yamahata@intel.com wrote:
> > +static void tdx_reclaim_td_page(unsigned long td_page_pa)
> > +{
> > +	if (!td_page_pa)
> > +		return;
> > +	/*
> > +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> > +	 * assigned to the TD.  Here the cache associated to the TD
> > +	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
> > +	 * cache doesn't need to be flushed again.
> > +	 */
> > +	if (WARN_ON(tdx_reclaim_page(td_page_pa, false, 0)))

The WARN_ON() can go, tdx_reclaim_page() has WARN_ON_ONCE() + pr_tdx_error() in
all error paths.

> > +		/* If reclaim failed, leak the page. */
> 
> Better add a FIXME: here as this has to be fixed later.

No, leaking the page is all KVM can reasonably do here.  An improved comment would
be helpful, but no code change is required.  tdx_reclaim_page() returns an error
if and only if there's an unexpected, fatal error, e.g. a SEAMCALL with bad params,
incorrect concurrency in KVM, a TDX Module bug, etc.  Retrying at a later point is
highly unlikely to be successful.
