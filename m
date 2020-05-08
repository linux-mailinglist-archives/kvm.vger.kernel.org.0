Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E9D1CB775
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 20:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgEHSjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 14:39:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30742 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726817AbgEHSjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 14:39:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588963146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QXBRgjOwY+dvVSQ4b8KNQAdFl7K/2dDkBF+n7DPUAd0=;
        b=WiGbvW0TvJ6dluOdscrBrtG2f3+Riy0AQPpI/7iX8F16sItwh2aGu9eeZKCQSEv0R8jz7P
        347IpP9eKcj2Bo3sBlJbnd87H47p/tQx7wdQKe2ec+BGA4zHAGJzMgdb21A2VNFRDqcZyX
        RUs8kXC+2oWv5mFWDJJWO8aJ3m3fP7I=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428--H3pFKI0OWCEvifpbpwV-A-1; Fri, 08 May 2020 14:39:04 -0400
X-MC-Unique: -H3pFKI0OWCEvifpbpwV-A-1
Received: by mail-qk1-f200.google.com with SMTP id v6so1909742qkh.7
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 11:39:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QXBRgjOwY+dvVSQ4b8KNQAdFl7K/2dDkBF+n7DPUAd0=;
        b=QXSXOrBbh8UIWCpdA0My0zvKPiPCTLwEqk2iIrlq54/FSkgbHk9yE6LwQ46evbK0d2
         2swLyJCQN7LmtAVq97OSQgblpOazYvrOi/FNwCxhB8rv/KUE0HKrnhg7OKT5FhSOa0VK
         qshOY9R6rgHwmWcBxiMw0fzQO8XSAuXO8hziTHiYWXiB/pV9eLWbmpoQHGlCBGEY2RmW
         nDeOzAF2zt8r+/OU46o34wqxridK2I8xV9tvRPVSB+mdJvv386SAL2IMdRQw6P61kjWp
         YeiB5JFo4MuR7GKD7nfY++CeYvrSjBH0JWkdBoIwoUs3TlnHegakLp46Oud61SMqnr8F
         85hg==
X-Gm-Message-State: AGi0PuZXx+9oa3Ma3XnGaPfjCfFdV6abWZip6sazbmRq5TFbFK4+3m/s
        gFpKcCQ4o9ISqxlLWd8CasiJYJIOBNvzYkR0BeHM4h87++cpHP0F0q11yyZRsmYliSZB6RiqhB1
        jtR+LQHYBnETe
X-Received: by 2002:a37:8186:: with SMTP id c128mr4175551qkd.455.1588963143839;
        Fri, 08 May 2020 11:39:03 -0700 (PDT)
X-Google-Smtp-Source: APiQypLAr9Bm1koeUWkBXdivXMQD24n6jI17gBz0LpLaBEJYM0Mlc3/QNdh4XtLoIYudJtbnYdNUSQ==
X-Received: by 2002:a37:8186:: with SMTP id c128mr4175527qkd.455.1588963143546;
        Fri, 08 May 2020 11:39:03 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id i4sm1719360qkh.66.2020.05.08.11.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 11:39:02 -0700 (PDT)
Date:   Fri, 8 May 2020 14:39:01 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH v2 1/3] vfio/type1: Support faulting PFNMAP vmas
Message-ID: <20200508183901.GC228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871568480.15589.17339878308143043906.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <158871568480.15589.17339878308143043906.stgit@gimli.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 03:54:44PM -0600, Alex Williamson wrote:
> With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
> the range being faulted into the vma.  Add support to manually provide
> that, in the same way as done on KVM with hva_to_pfn_remapped().
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

And since after the discussion...

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

