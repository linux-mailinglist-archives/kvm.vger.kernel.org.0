Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1582228D32
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 02:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbgGVAs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 20:48:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40059 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731448AbgGVAs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 20:48:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595378936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RWGSZm0mD0Hsn964zAHjsyYpgFxMJEkHeUi58lCG8KY=;
        b=NgRWNg2cY954VBDR5yx7sHw7ouqzSp4Q8n5V3t9nrvaNd519pR3n5afL6ER6RmAMJBgmn3
        Ef2BenjuYL9WKA+5vJzWdxjY/7/dgIwEA9lWgpcLybMzfBpnq9s8pyfO1YbvMqmTSv17Z7
        m600azGlfjMHyuZ2uE+T+zEv9YCkg00=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-MZkjq8sLOaql1wMgXTdbOg-1; Tue, 21 Jul 2020 20:48:54 -0400
X-MC-Unique: MZkjq8sLOaql1wMgXTdbOg-1
Received: by mail-qk1-f197.google.com with SMTP id 3so299805qkv.13
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 17:48:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RWGSZm0mD0Hsn964zAHjsyYpgFxMJEkHeUi58lCG8KY=;
        b=dGGerswAp+G19W6FGg1kZM3O4pVtZBv6axa6GuJJjnj0qVhPfRoFqxsW0e7k7PAFZZ
         /Za1Hoi6K1O4jgtb6OixfuEuzmjpf24hlbORZyqxnjhu+lcTAoBKSQUMStyfvWSEXNkJ
         SeD0qfiwvDIP42a5w1+G13rjvcqA5LZqnyNJyqWGRORCZlsPZ5i1iXPFYGQ2gQlHC5kn
         o9hc4OiiEtGekwN0BAbKC63/45AU1AIUeVRv/rDU1hKxIbdVaTmov2/JIKUEGjY+GX1H
         dPVnpRzfdtzG/N+y7TPSCyzml0DjeVultPk7Hj+utiDNSx68HfF8fR//LHNv8c6QMIDk
         trTA==
X-Gm-Message-State: AOAM530XDaMUyWblkG3DJRm8dIFvnqPgHSqyCqflHcjvnu3T+KbOKHDU
        eqxJajAqVIB0XWEhAMMJbQIRbarFDNs6TatVMIuLbfqbQMtq5K0/DvwvR9gsvQ+shyqAa0Edv4w
        om3rvOD+OPN6o
X-Received: by 2002:a37:4711:: with SMTP id u17mr23575351qka.54.1595378934454;
        Tue, 21 Jul 2020 17:48:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWo0UiizA03wUsCSxpLxCUuVi6CjaeEv2A/IRRJwpXQsph164b5zXlWqHCZZwzWoCTBmIt5g==
X-Received: by 2002:a37:4711:: with SMTP id u17mr23575333qka.54.1595378934196;
        Tue, 21 Jul 2020 17:48:54 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c8:6f::1f4f])
        by smtp.gmail.com with ESMTPSA id q126sm3509556qke.34.2020.07.21.17.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 17:48:53 -0700 (PDT)
Date:   Tue, 21 Jul 2020 20:48:51 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jay Zhou <jianjay.zhou@huawei.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, cohuck@redhat.com, maoming.maoming@huawei.com,
        weidong.huang@huawei.com, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] vfio dma_map/unmap: optimized for hugetlbfs pages
Message-ID: <20200722004851.GV535743@xz-x1>
References: <20200720082947.1770-1-jianjay.zhou@huawei.com>
 <20200720164603.3a622548@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720164603.3a622548@x1.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 20, 2020 at 04:46:03PM -0600, Alex Williamson wrote:
> > +		/*
> > +		 * We got a hugetlbfs page using vaddr_get_pfn alreadly.
> > +		 * In this case,we do not need to alloc pages and we can finish all
> > +		 * work by a single operation to the head page.
> > +		 */
> > +		lock_acct += contiguous_npage;
> > +		head = compound_head(pfn_to_page(*pfn_base));
> > +		atomic_add(contiguous_npage, compound_pincount_ptr(head));
> > +		page_ref_add(head, contiguous_npage);
> > +		mod_node_page_state(page_pgdat(head), NR_FOLL_PIN_ACQUIRED, contiguous_npage);
> > +		pinned += contiguous_npage;
> > +		goto out;
> 
> I'm hoping Peter or Andrea understand this, but I think we still have
> pfn_base pinned separately and I don't see that we've done an unpin
> anywhere, so are we leaking the pin of the first page??

I'm not very familiar with that either, however it seems to me most of above
chunk was already done in the gup core.  For hugetlbfs, imho it should be where
follow_hugetlb_page() calls try_grab_page().  Thanks,

-- 
Peter Xu

