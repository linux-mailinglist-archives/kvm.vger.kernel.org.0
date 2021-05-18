Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D88138805C
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 21:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351683AbhERTPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241036AbhERTPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 15:15:21 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C48C06175F
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 12:14:02 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g24so6032323pji.4
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 12:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WnK4uajSuBCF+iu/8FjWrAQzpSy036uu06aeXXfdggs=;
        b=Fj+N4PhfIl7jv6LOEmmuwwPamlR3Z2YzG/LLmlR0QybVOTTn2vyDdSUMTTagMgBNV+
         Zm30YA60fRu72DnMhpG6DVO6vbcxSzXEKSqFTSCPWR7hHWEyjiY15OtF153VplUIesO6
         4Fy4Qz7mrNf0qBDERWZUVjI78VZXfShNl3AAM5g0mnwkbSYtSLOPwyxwkC9PEkw8OA2P
         r5e7R56Yvpg8VN6/VlNGT+jeCxaFQy5h0jr6jrIc0KL8+9iUmn3Cypq2hgfbc+lGxRxH
         hgfzqm08H00oNE9YvPk0mP/SnPNZJbzWFSrCpIAt3L+C3BV2PVVi8Xm2tHbFZMadNSN1
         cGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WnK4uajSuBCF+iu/8FjWrAQzpSy036uu06aeXXfdggs=;
        b=f5lOEMUtiuiuJFEmc+eGobiSAK03WUY5Go+IeGn4gfM/DC0uckn4Oid6m1jHCK23Z1
         xQXzixi3c4E9OxH0EF3X5/ozJ0n4mMeVA+saxRlmg3dRQOzM1qVYo9OD+XemAaCLyZsO
         an0D/MgdshDIjQ7hOH4Vb+srw/LQdRDNo+89HXqE69spQAA0GLIxRqHt0dKuIzTCVSZM
         94H540vUHJsVNS/zu+PUlK2SbnRJ6clUrR+1J+lrGgY1DOqVkQH8GZT+sUIDbQEvOI8P
         WQOxY4wghxXLk9LB5Q+8LJnJgVSvVPZTRPophS2jETUzy3p3iykmma+t5ZKj5WCRUQZE
         AXXg==
X-Gm-Message-State: AOAM530ErEMHVSF3or4jM/DQfv0Z2n9MoSlQC7D4RIkcG+tEL7qOb269
        YYf5tVtQJWPiMvElk1rZkEVSSg==
X-Google-Smtp-Source: ABdhPJzlwjf30kWQb8nqUSwMKzmhMqzQ9xOMZbWixVKBohtjcV94vQCRIoWVsR2MNR3qYrJlDw4b1Q==
X-Received: by 2002:a17:902:34f:b029:ef:3d14:1c27 with SMTP id 73-20020a170902034fb02900ef3d141c27mr6296909pld.65.1621365242262;
        Tue, 18 May 2021 12:14:02 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id u23sm2943943pfn.106.2021.05.18.12.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 12:14:01 -0700 (PDT)
Date:   Tue, 18 May 2021 19:13:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v4 5/5] KVM: LAPIC: Narrow the timer latency between
 wait_lapic_expire and world switch
Message-ID: <YKQR9rq9WNT6dauh@google.com>
References: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
 <1621339235-11131-5-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621339235-11131-5-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 18, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Let's treat lapic_timer_advance_ns automatic tuning logic as hypervisor
> overhead, move it before wait_lapic_expire instead of between wait_lapic_expire 
> and the world switch, the wait duration should be calculated by the 
> up-to-date guest_tsc after the overhead of automatic tuning logic. This 
> patch reduces ~30+ cycles for kvm-unit-tests/tscdeadline-latency when testing 
> busy waits.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
