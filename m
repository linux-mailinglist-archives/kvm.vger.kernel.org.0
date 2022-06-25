Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EF555ADAE
	for <lists+kvm@lfdr.de>; Sun, 26 Jun 2022 01:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiFYX7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jun 2022 19:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbiFYX7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jun 2022 19:59:09 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DBE13DF1
        for <kvm@vger.kernel.org>; Sat, 25 Jun 2022 16:59:07 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id 89so10062548qvc.0
        for <kvm@vger.kernel.org>; Sat, 25 Jun 2022 16:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OIkvZSCfU1CjrPejBudrIGntnY32egXHLdKIcmmN0pg=;
        b=duH504ulYOnzBaVTLyLo1maWRZER3UvuJOkl8g0W5A7EYWwmU7JLyVVOeVm/mzY6jz
         wEQqHqotXWBM9p2+EAvrZPlBnGf0wIXCNnyoHFxr5zjGsKVcLPXHkfQVwIGTrVZFfHJg
         E4e8lZiIn8rsAZTGPhWBTHBxWkOp5DngPB1Az8BgpizpK4wZTN68kKTCIq1n4SCn6Y5V
         56K05ugA1OyB3vJpg7045S8yLgufcX3ypvS9ZGEs793kJzwt2Pp/5EpQpLRLJ0SmkWOO
         9J5MhDH6Dt3+awMXHKsUxbuCGMHLj/OPr3AwVMHf2ZWmG4UVE5Y1CWHYNDj00yZt0DW0
         kIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OIkvZSCfU1CjrPejBudrIGntnY32egXHLdKIcmmN0pg=;
        b=WCOptaATF3hvsD9jiQphV6un2awJde9VFqztZg2G5COZ8AfNGLXksEtvoue7RbteJh
         vnsiqO4AMLtHbTHbURkeV4JmQjk+69AUrlnkfLkx6vyzLjzRoABuk3CvOwQWD8zn0jZK
         7nXeYKr1sWEolfv4vJ70jJWD6yx+8+QHS1dWqJGGh5Zz/Huqtjn1Xu0zn9oLckgqmt6B
         7NljGCTVri07b+qwESwa/WYRGBUtTkHa5X+FVhqLMUfhzM6vtF0EnC/rnB+ipkFzX4fC
         P8ejvqDd+KThBiQQK/N6ebd7vS7l5H/+i0BACDuuAh93X0ugE43o+R0lbX13JL5PC4DO
         /FzA==
X-Gm-Message-State: AJIora85I8VJNRWE9ksc4nsjmdb60flxT16sz89jafzZLk582mJv5X9L
        7xtlPEGFR1Ml56yG+Rrdpz2aWQ==
X-Google-Smtp-Source: AGRyM1vkSR+fkkuzlMpkZs/yPAV/CYQBTRY/CutcwMiNTqboWAwrJeP6fXDvYF6KEeySkwQaI+gI6w==
X-Received: by 2002:a05:622a:13c8:b0:317:7862:6b45 with SMTP id p8-20020a05622a13c800b0031778626b45mr4688676qtk.266.1656201546699;
        Sat, 25 Jun 2022 16:59:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id l2-20020a05620a28c200b006a6cadd89efsm5717888qkp.82.2022.06.25.16.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 16:59:05 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1o5Fg8-001ry7-9l; Sat, 25 Jun 2022 20:59:04 -0300
Date:   Sat, 25 Jun 2022 20:59:04 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Message-ID: <20220625235904.GK23621@ziepe.ca>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-2-peterx@redhat.com>
 <20220625003554.GJ23621@ziepe.ca>
 <YrZjeEv1Z2IDMwgy@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrZjeEv1Z2IDMwgy@xz-m1.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 09:23:04PM -0400, Peter Xu wrote:
> If to go back to the original question with a shorter answer: if the ioctl
> context that GUP upon a page that will never be with a uffd context, then
> it's probably not gonna help at all.. at least not before we use
> FAULT_FLAG_INTERRUPTIBLE outside uffd page fault handling.

I think I would be more interested in this if it could abort a swap
in, for instance. Doesn't this happen if it flows the interruptible
flag into the VMA's fault handler?

Jason
