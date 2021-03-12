Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C4B339323
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 17:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbhCLQY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 11:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbhCLQYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 11:24:11 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABAFC061574
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 08:24:11 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so10967354pjb.0
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 08:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bE70lieAUx+BTAMDnz9dg0E68xb/a/mhccrXfC0cpdw=;
        b=oxUZ8pvzjRN5xUUX8cR6ebAFTI5Y1Kd/HUZDgVWYpWhKZdRsG94k10ZY3yFngpp2pN
         OdA6TbyQqOekF+7aVoaBe50TKtmTqg1MFv1B/7rT4RXWYU9m9LMpMNwhC40/PnNma4fo
         WudOjfaf+3+piK2a3Y1HxHAaIkioO0vI/oSH0yONMrDFBFk10F+PzZ7MvtaBpJqbrh5p
         4MLRdRKthKfay5UNOP35gjTinIp0Y1FlZB9zOjUjsURXdIgY/cu+Xwt1sR/s00Cisw4M
         mfeCJP5hTIRTTwZZxl6MASmyT4bwINvTun1u1Y1zsW8Xi1YCn1CYGTwkHtTwKrhtsFED
         J6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bE70lieAUx+BTAMDnz9dg0E68xb/a/mhccrXfC0cpdw=;
        b=j8YfIwE6voFVvqWvhc3+Pa40OVCP+Iz9lDa8EiFX9ey0PejL8E1e/43muuWFUPJZep
         oggNKNrzCuYiJyK4v9vKdEkaW1mB4W32jRL3jhxUl6Bvve897GIQXK4BoeoE8BqxUa8/
         ct4ANhvg+KLa8dvkfG0uKvqLgu0vLtap073GuZoB+e+I8JKVu6mTqhJ703sN8JyPWkDl
         HO8E28jhQEL/ZvKzd0WVXck00s3MyZ2iguUlYHv08DQ9Py936VoiqVmmT8vqPi5vFpnG
         HLtItRNLBBRPtbqpYflGj5wqsiirg+aD8c5yoN4oeiu6r9fzCYbBbdl8n/XiZ9mAb/kv
         P9Tg==
X-Gm-Message-State: AOAM530iYhGvvp6RFi9Gq6VDEXbEnTmhcr8qzuwZU3F2RO8C/6vi6+uC
        27CWeXl09NWsPIrNua/9T12KPhMTqxDkeg==
X-Google-Smtp-Source: ABdhPJxIXVBPkb6K/0yPAWF6I+x7vz2QuAjrdYSrGlhmh/b86lqZfZxbxKXU76ofEskJcTdVvdidMg==
X-Received: by 2002:a17:90a:68cf:: with SMTP id q15mr15197779pjj.231.1615566250569;
        Fri, 12 Mar 2021 08:24:10 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id j26sm5796690pfa.35.2021.03.12.08.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:24:09 -0800 (PST)
Date:   Fri, 12 Mar 2021 08:24:03 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Fix RCU usage when atomically zapping
 SPTEs
Message-ID: <YEuVo2p5jJUPghI/@google.com>
References: <20210311231658.1243953-1-bgardon@google.com>
 <20210311231658.1243953-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311231658.1243953-4-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021, Ben Gardon wrote:
> Fix a missing rcu_dereference in tdp_mmu_zap_spte_atomic.
> 
> Reported-by: kernel test robot <lkp@xxxxxxxxx>

s/xxxxxxxxx/intel.com

Reviewed-by: Sean Christopherson <seanjc@google.com>

> Signed-off-by: Ben Gardon <bgardon@google.com>
