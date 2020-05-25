Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D761E0E61
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 14:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390523AbgEYM0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 08:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390360AbgEYM0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 08:26:09 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BB8C061A0E
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 05:26:09 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id c12so3749034qtq.11
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 05:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v+B1785OZUouPASW2jrMekMBCWgZaLFpUTHdleb2VxA=;
        b=M8B6svJXr54wgpkQnxJoxOPnFoG3xoaPb76kANRmbKzt4nMw3qxD/q1sXASpcEEWgF
         gHuA1+7j+0GHGEQqXQhNV3CKJGJ9y8q3jm3bRbRkWZKx1ilA8ceQcZUG0kUCYhtO2MZ7
         o4kqO2LyZq2faf/NlIVIMBkKLeXoa88R/AW3tpprsWHR3SjzEi7iaSys03D2VbMtewxD
         KWhdY5a9O/4fZ5uesQirQ2lMyaFJfuB2R2HsT37n64J/gUu+48rbi4zf1W71+HPlLCgg
         RS6kJEq84BAk2ESnQHLB8txIWUSWrjJBBQcE2f/WAF2FVslapUIbMMvrwY16wMa3EvYc
         Oywg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v+B1785OZUouPASW2jrMekMBCWgZaLFpUTHdleb2VxA=;
        b=TjYesrwCM0cAWa6fDpa+CS0W4BZATTtjiYLaTR3duALWl+qYyhkVYryCxd7HkPpcFz
         5WHG79GGw4GFWz8zjczvwXgr5ob4Sji0aPvXPNE/wLJDZZ5rMzFGT/E3z+pbYPhyAssC
         bAHZV/aAp3Y5EEtDvzsMzM1TJ0Y9Gh5dO0DCpaGoFqSs3I9JgFYncxykcz7hMzztNd07
         HCN3qc3R9rV01zVZb0aYC9FwMy9EK8Z9YQPuxe8oqxzUSPEnFmY/V30u1gIqrnBWwe7y
         KJHSd2wS/sni9oWXg9YXBWZ9Ecxl8VB6flg2h5H587OphR17vlsTYVLV6xciH3Bhn7FH
         42Zw==
X-Gm-Message-State: AOAM532PrTaXM2fteg4zigmBPV4xBsth3qjcKQ/jmRnNreTVKA6QgCAp
        ghJJJOxfIZT7ukSAggx1CDJmxQ==
X-Google-Smtp-Source: ABdhPJwk7SIlqGjBIUWz/0hGbccyh9qfHeyY8qv0Rau9jFzIYCDNLUkjNci7H9c03NXVt63ilIK9QA==
X-Received: by 2002:aed:278d:: with SMTP id a13mr2961124qtd.23.1590409568569;
        Mon, 25 May 2020 05:26:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id l2sm13637889qkd.57.2020.05.25.05.26.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 May 2020 05:26:08 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jdCBD-0007ON-FH; Mon, 25 May 2020 09:26:07 -0300
Date:   Mon, 25 May 2020 09:26:07 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Peter Xu <peterx@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com, cai@lca.pw
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200525122607.GC744@ziepe.ca>
References: <159017449210.18853.15037950701494323009.stgit@gimli.home>
 <159017506369.18853.17306023099999811263.stgit@gimli.home>
 <20200523193417.GI766834@xz-x1>
 <20200523170602.5eb09a66@x1.home>
 <20200523235257.GC939059@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523235257.GC939059@xz-x1>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 23, 2020 at 07:52:57PM -0400, Peter Xu wrote:

> For what I understand now, IMHO we should still need all those handlings of
> FAULT_FLAG_RETRY_NOWAIT like in the initial version.  E.g., IIUC KVM gup will
> try with FOLL_NOWAIT when async is allowed, before the complete slow path.  I'm
> not sure what would be the side effect of that if fault() blocked it.  E.g.,
> the caller could be in an atomic context.

AFAICT FAULT_FLAG_RETRY_NOWAIT only impacts what happens when
VM_FAULT_RETRY is returned, which this doesn't do?

It is not a generic 'do not sleep'

Do you know different?

Jason
