Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982CF3A46F1
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 18:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhFKQtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 12:49:00 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:41519 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbhFKQse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 12:48:34 -0400
Received: by mail-pl1-f180.google.com with SMTP id e1so3111440plh.8
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 09:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pSn/3rKhZD4VQR1duMebe9NMEZp7D9aGsF3EVZJ2bZ8=;
        b=qiWmF7hOcv7uSMDmZPMC4gc/mCWZEC9RAZwYwhWYgDPoZKMmsF048KMJo8AnJxik6m
         MPu1V5/7WLOsjZ6iFIXWQwCGPM64EZOoYKVZY1HdXFtDzHJa15sq7xxbxC4uJU4JI0Lx
         GRzZE2+AyNS9DFyokMmD3oAHB99ClrsiaYDP3ZHBPhI6Wzq4wDyCkhxV8Yz9ecrjGEU/
         0Bx59WHWPVAK+KeBohoZ2MoGo0TCkUtAmy77BL9aCjvCvnAIi1eop3S9JkGIcBr7WpLq
         g0Z1dxaAL5GGLyJdD2MMdpWBykqbiCBAyyJkRiB3vDj1IOfFli/OjIzjAQn/zTBvY19n
         3t3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pSn/3rKhZD4VQR1duMebe9NMEZp7D9aGsF3EVZJ2bZ8=;
        b=l47yHDxpdMdVc2xrTkZaSbea1dIjRgRxoBdXny7QU4y9IWbqyeufmhrVtue649G6Hn
         y/fR+T1XCyUpRkD0ajQnptlhcYCfYHFcWIRz85wcGy0VteS9qS8/i36mTkf5uuIxVYYG
         ijQ1J0umW/YVFgGn5xtAnEmHniHFqbJeYOuiiAXKF9tB7Im45yoK2718IRmecQaum7qH
         UK518fEXbY9ThzcPodgYZvFMOmuWaRG4SgQqeAq+W3/XdXJB7oMXjahaFXGJt8JruZiT
         WNIUwOH3OYse9zPV3ynX6AhYhE8Dro7KoqEOLwcuFgCIm/30GVUETL9OtiRU6xYa6TTH
         +2NA==
X-Gm-Message-State: AOAM531gePdj4YuAGhEXX+AMVrLCRgnl97sdP0/8wfP7s0ZM32R3nfQT
        zxRmIRfH1S++SUwvwXxpag0tKA==
X-Google-Smtp-Source: ABdhPJxDT1f/EE5aeu5oZwt9SobQ0DVlRycA1YaWGjtp1v2fJ+NO44pxPCYQhdXfHJEeOtVKXsHfkw==
X-Received: by 2002:a17:902:eaca:b029:109:7460:cc41 with SMTP id p10-20020a170902eacab02901097460cc41mr4719564pld.4.1623429936265;
        Fri, 11 Jun 2021 09:45:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w59sm5450326pjj.13.2021.06.11.09.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 09:45:35 -0700 (PDT)
Date:   Fri, 11 Jun 2021 16:45:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Calculate and check "full" mmu_role for
 nested MMU
Message-ID: <YMOTK7eYytpw58Vc@google.com>
References: <20210610220026.1364486-1-seanjc@google.com>
 <b2084f55-3ce5-57c4-f580-d6a2de6ce612@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2084f55-3ce5-57c4-f580-d6a2de6ce612@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021, Paolo Bonzini wrote:
> On 11/06/21 00:00, Sean Christopherson wrote:
> > things like the number of levels in the guest's page tables are
> > surprisingly important when walking the guest page tables
> 
> Along which path though?  I would have naively expected those to be driven
> only by the context->root_level.

The functional code is driven by context->root_level, but if KVM doesn't include
the level in the mmu_role then it will fail to update context->root_level when
L2 changes from 32-bit PAE to 64-bit.  If all the CR0/CR4/EFER bits remain the
same, only the level will differ.  Without this patch, role.level is always '0'
for the nested MMU.
