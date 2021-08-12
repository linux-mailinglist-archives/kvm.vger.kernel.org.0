Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBC43EA83C
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 18:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhHLQHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 12:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhHLQGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 12:06:50 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55425C0613D9
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 09:06:25 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id w14so10378514pjh.5
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 09:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TX06zsnV7acVz1z3JgDeP59aGED9UWsBVN/SvvP0XMM=;
        b=DQAzABT3sl+k3K9T3Yd7UVKtYggSobcspvGUr+9xTYq5xkUESC3/KPbaPjcTMMjcym
         dXjFryUghY2zEYL6T0jcuaSqouLKYj4aLgQgbBUHZPSvVXAFGsyupzcHfyrWPnNYILqF
         q0Rjzvepxi3jt/+EvKYdrt0jBLJhFboRueTqoLMMX0OqMx5IU5CYxDGLqd8K9Qh4qE5q
         CupeHFKopOGNrc8tDzJ/r2YduoFF1vB6bK++JSF3iJH1Slwahx8h1hk3jaEUXybZErZ9
         2ZNYDyWXBp1Rc/3zRDK2WAghvyUca7fqqLqBZ6AEocqzf+gZwfT9ttwrI8a9Rr3p6bHq
         /sMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TX06zsnV7acVz1z3JgDeP59aGED9UWsBVN/SvvP0XMM=;
        b=BxXOVibjuy5sXadpWSVdyouRjHK7DDnCs5/8VlysQMtmC+KYxVAfFVaDGoN3Swmln7
         LBAFy3MDR9zVJf04l975n8yKFyLfWaJoeDWGC2Js043V/Lad+1g+VZri1ftzduW1sBZj
         vk0bGSMd/A/FY7g8xIque9S2Gn0dpzlRL04W+h+MW+ZPkFmyA7tWbW0HPNNCo1TsZEqW
         Cg9VoT9BYgNuIuqgipq8kKJxVQKoXwglQLy5n7QojF3IVwLoswgH5p/xBbwoC1l0aIkU
         3UWrgtMdIlP62VPpfG3RjfoRn5XlDSXoQTgITpiaLmSTTN8VtzvYNSGed2+9l/hEcqLg
         Y/3A==
X-Gm-Message-State: AOAM532nvzJ/9oOJf4KGNdzns6jN98NSF5pyZ4RDi/6GNif6ijuwvSL6
        qO2uffC/hEe/1qIPhv5pEgl99g==
X-Google-Smtp-Source: ABdhPJxMIEXNHyOHxn0ix8X+qupgzFT7Jg6ck3kRYpaG9WOjI6ZdgsnMqYH5UHrFGJ8IKyI5TINIWw==
X-Received: by 2002:a63:fb16:: with SMTP id o22mr4384217pgh.309.1628784384506;
        Thu, 12 Aug 2021 09:06:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d5sm3258126pju.28.2021.08.12.09.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 09:06:23 -0700 (PDT)
Date:   Thu, 12 Aug 2021 16:06:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Protect marking SPs unsync when using
 TDP MMU with spinlock
Message-ID: <YRVG+Vtry4MG+QDw@google.com>
References: <20210810224554.2978735-1-seanjc@google.com>
 <20210810224554.2978735-2-seanjc@google.com>
 <74bb6910-4a0c-4d2f-e6b5-714a3181638e@redhat.com>
 <YRPyLagRbw5QKoNc@google.com>
 <591a0b05-da95-3782-0a71-2b9bb7875b7f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <591a0b05-da95-3782-0a71-2b9bb7875b7f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 12, 2021, Paolo Bonzini wrote:
> On 11/08/21 17:52, Sean Christopherson wrote:
> > All that said, I do not have a strong preference.  Were you thinking something
> > like this?
> 
> Yes, pretty much this.

Roger that, I'll work on a new version.  Thanks!
