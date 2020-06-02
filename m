Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467EB1EBD21
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 15:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgFBNdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 09:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgFBNdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 09:33:06 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2920C05BD43
        for <kvm@vger.kernel.org>; Tue,  2 Jun 2020 06:33:05 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id 9so11127530ljc.8
        for <kvm@vger.kernel.org>; Tue, 02 Jun 2020 06:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UXOP6EeQeN7QnSWXWe4xWPi5EI/vGhngXSWL67O93vc=;
        b=2EGajLxxJM6gikQYPuS1mnKu5hp46+IVBEa9BwEc3owfe/BwQA7s9KI6hUKhvXWmSt
         iMTb3bx5tEj8Sg6M7mXe5jzbS8EczhnXojEdy5kqCDqyc08i+3JK6eu5RtkCnIjm3CyY
         bI4QHBWOVI7IQ5r9m0fg4tfoYV4jyp815xZStlLvA/SPqmTHBLzf1jYYzdTl/TDY+YKZ
         tQCVWR94HSbuE4z6qpl2vcGt6s4WI7kuo1H6tSS1vr1WOEbPHcyxvV1/7QcLvUVCP2FK
         xWa+SP7Rx1sAG/Sv1pXG9062JgPV+wc117DRdA0jPIqWflhSnelmPeh3mtb45eP9BUB3
         /lxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UXOP6EeQeN7QnSWXWe4xWPi5EI/vGhngXSWL67O93vc=;
        b=Kol7JrDGc3yiWHaqLBwdNJIm35QUkmW0LhFJYzNm+PibARbESzzGzhMLhDiMQYmY8b
         6CxHZPFm3dQsuP8ZClYnJ6gzH7jRrVr7b4dTlxmPcjMGQMsxTAQzKU0DVRK2F/+A3Qbp
         cKEpu3SHB+aNy2NHx2sK8SBdKP7F7QH7+6t2n7BuWr4E+uj3+L7Pi5FrqKQyjrWvYluM
         Gt5NNsDRfOLbMLcUVOPtCUCtduvCYghN6OOWw/hXx90skObgNAo3m1fO0RSWORo1CflE
         vl6y15pGKznfJ2ZuiEzgPywJNMh8tGpjTZZ7ZD7q5LkWIK/BWHoYVcXXw9+iRZHDptLt
         CUnA==
X-Gm-Message-State: AOAM532630r16NtnXpnNVacgHbKSBeQJfKjT9vWfpFsHW+3ntAwqAczt
        UbR1yON0H0IR6lVQuSPV8R0XBg==
X-Google-Smtp-Source: ABdhPJwUKdYFxoN2BZU6Td7Fn5skrnUDC3bo7r1I44uRR7y3Vo9hSYxz7kedhP7e5lIggogsjLYjGw==
X-Received: by 2002:a2e:9859:: with SMTP id e25mr3590593ljj.243.1591104784267;
        Tue, 02 Jun 2020 06:33:04 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id y17sm696697lfa.77.2020.06.02.06.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:33:03 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 226B4102780; Tue,  2 Jun 2020 16:33:09 +0300 (+03)
Date:   Tue, 2 Jun 2020 16:33:09 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 06/16] KVM: Use GUP instead of copy_from/to_user() to
 access guest memory
Message-ID: <20200602133309.xyet6tndjadwafnb@box>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-7-kirill.shutemov@linux.intel.com>
 <87a71w832c.fsf@vitty.brq.redhat.com>
 <20200525151755.yzbmemtrii455s6k@box>
 <a5acc4c8-2ee6-9e5d-c0a5-2a6f7c54c059@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5acc4c8-2ee6-9e5d-c0a5-2a6f7c54c059@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 01, 2020 at 06:35:22PM +0200, Paolo Bonzini wrote:
> On 25/05/20 17:17, Kirill A. Shutemov wrote:
> >> Personally, I would've just added 'struct kvm' pointer to 'struct
> >> kvm_memory_slot' to be able to extract 'mem_protected' info when
> >> needed. This will make the patch much smaller.
> > Okay, can do.
> > 
> > Other thing I tried is to have per-slot flag to indicate that it's
> > protected. But Sean pointed that it's all-or-nothing feature and having
> > the flag in the slot would be misleading.
> > 
> 
> Perhaps it would be misleading, but it's an optimization.  Saving a
> pointer dereference can be worth it, also because there are some places
> where we just pass around a memslot and we don't have the struct kvm*.

Vitaly proposed to add struct kvm pointer into memslot. Do you object
against it?

-- 
 Kirill A. Shutemov
