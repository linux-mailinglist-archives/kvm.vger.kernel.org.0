Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A762E6C03
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 00:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbgL1Wzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Dec 2020 17:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729298AbgL1Tf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Dec 2020 14:35:26 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99460C0613D6
        for <kvm@vger.kernel.org>; Mon, 28 Dec 2020 11:34:46 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id x18so6075745pln.6
        for <kvm@vger.kernel.org>; Mon, 28 Dec 2020 11:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QFVvOfvGUHNbiV6wooWAQ/7/onuYmct4M9lXuufGLBo=;
        b=E9+it7y2bo0WRbsyFIfs6xJZvcL1Vg55yXMsmq5Xf1/b2Jn5yUrP5MI0tOXnHOJobS
         Y8CIDxKXozVomtbif333R5m71ZsnDeFDHyVQBRIF9tj23a3bDibq9+3Ugn32ST9eD4ZO
         d7qOqseMV0+AqopVUFFwBzaJlE6qAVmZ6tCiAkmEFbsgenoO1k1TJFoV05IIhiipgpDh
         3Hji5VW1z6/qhJqxbCMOnJh/ndWt+ItRQY/6ocSiP0rCjHjCbGKeXtswvS3Hx4CaUz8L
         YqiB+SuOpvwPE6suYgPGJvwUaQyQrtk8FSAFwXSd7PME0d9YQiNwraBLSprF0hKHG9pq
         G5Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QFVvOfvGUHNbiV6wooWAQ/7/onuYmct4M9lXuufGLBo=;
        b=oob+38KF7AlrkJepnI7DnDrVYk4M54rkM66FbBzlp5Uw1kOFF7T/qtTwJz6/i0Dh3C
         f8nLdlQsj74BP6GVi/i+INl4yCxF2Z5IbSHyW9u57cP1vhglro0v1T9YRj50YxSTiLTu
         RHh8VdWSVIjWIN0R9jUgB3jK4hR45e5mZougpRUND744Nn+jAS1+Pn6btzmEtwPkyFUT
         d+12+zTMmztHg4bT3O643krHoncyY7l1GDHBqRFZcDAfoGg/C32/eKMaZb0H93xNNpIJ
         QZxX3CACeeK3/6OH83P+kcbtxx3jJkaMIYL0/oj4CEHGvo5owrpMQSojEOXeG2iwEiId
         OiCA==
X-Gm-Message-State: AOAM531aSckJsmFkTrSwL6jV9lW914wCd/QMHiFXXbZlrVKA8BbLdKmB
        voo/OyGDGx+c3QECe+PLE2TrCQ==
X-Google-Smtp-Source: ABdhPJxdx1qxcY7vFKeqZp46XkT+ES/URNJBDKGM74GEVYtDeGeQJJbptOtKGarU16D1S4xi038eNg==
X-Received: by 2002:a17:902:8643:b029:da:d5f9:28f6 with SMTP id y3-20020a1709028643b02900dad5f928f6mr46561583plt.8.1609184085967;
        Mon, 28 Dec 2020 11:34:45 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id c14sm38288193pfp.167.2020.12.28.11.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 11:34:45 -0800 (PST)
Date:   Mon, 28 Dec 2020 11:34:38 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com, nadav.amit@gmail.com
Subject: Re: [kvm-unit-tests PATCH v1 05/12] lib/alloc_page: fix and improve
 the page allocator
Message-ID: <X+ozTlQD0wePcOXJ@google.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
 <20201216201200.255172-6-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216201200.255172-6-imbrenda@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 16, 2020, Claudio Imbrenda wrote:
>  /*
> - * Allocates and reserves the specified memory range if possible.
> - * Returns NULL in case of failure.
> + * Allocates and reserves the specified physical memory range if possible.
> + * If the specified range cannot be reserved in its entirety, no action is
> + * performed and false is returned.
> + *
> + * Returns true in case of success, false otherwise.
>   */
> -void *alloc_pages_special(uintptr_t addr, size_t npages);
> +bool alloc_pages_special(phys_addr_t addr, size_t npages);

The boolean return is a bit awkward as kernel programmers will likely expect a
non-zero return to mean failure.  But, since there are no users, can we simply
drop the entire *_pages_special() API?  Allocating a specific PFN that isn't
MMIO seems doomed to fail anyways; I'm having a hard time envisioning a test
that would be able to use such an API without being horribly fragile.

>  
>  /*
>   * Frees a reserved memory range that had been reserved with
> @@ -91,6 +110,6 @@ void *alloc_pages_special(uintptr_t addr, size_t npages);
>   * exactly, it can also be a subset, in which case only the specified
>   * pages will be freed and unreserved.
>   */
> -void free_pages_special(uintptr_t addr, size_t npages);
> +void free_pages_special(phys_addr_t addr, size_t npages);
