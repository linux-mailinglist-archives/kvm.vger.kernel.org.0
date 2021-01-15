Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FF32F84C2
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 19:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733168AbhAOSw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 13:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbhAOSw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 13:52:26 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66712C0613C1
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 10:51:46 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id z21so6587301pgj.4
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 10:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2ch/HrNBo6bzToTGSnl4rPPwVNGRB87UYiv3EcbSK1A=;
        b=YQICljedlfUn40WJz//j5+ER9vk1pScXgKsDDNe7FyYz5lsdeqQkqsTFs3I1x7ntX7
         XORtjdwUG8HeO2yy9ztInzXwlnAvitykLL5ct3WYSNFdYpMBltGFAyvNIvcsnZlYP289
         5zXy4qo4ROo3qeRLPlMjjoTWnr7dwKjTYR2Ou7Kv+3/RhzKCHhabnT/dCb5RThGC0OW8
         dToZpdK0ZcgjpT0GSzx13vKYO/WMr77V6Z9KJhNLZ+La21CEgk96ECFn/uvHeT5pgzuR
         syAbVm0++FXKjvN7WR1qaU6+3KJ6qo5x+LODk8nVTFqcB0hS2w2TmKVedjzeQh8iODjb
         wk0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2ch/HrNBo6bzToTGSnl4rPPwVNGRB87UYiv3EcbSK1A=;
        b=BK+5mVMIFbDaEVubKUXoC3BLEIz/YC9+9YLuwhOuqwOf/LE9BmEFLMPWmT6A/za6Bn
         Hix1gLYena8b7/hd8AwVfi/jmZ7XuPd8pBZSPV4mo/OQ7CJ/ycUylepfmQMtmrzSZco6
         fueKcDGJm9GUcDtbkfnr1lyr3LDILqgyLpBOz3Db2qpZDvTVhp1MLUXOipHAM3hh8YVI
         0y4agqgNhAOse4Lq8uXBbwd0tPsCndsF+pm7f+UJcjnk9TLjUcYmiPzp6s1xyK0D97zg
         roq8t6HHSDIYL72ikBWuetGo67wyTLJjW3GYxIJG1Dt24VfO6RCCBRyr76qGdE887zu2
         rqpw==
X-Gm-Message-State: AOAM531r4M+NZDjl9jcOJzKGKDnQwKWqo/vF0LyqKPUpJqlmOK3kO0/5
        msdNZpWhteHbsg3HPL6Rf7YAtg==
X-Google-Smtp-Source: ABdhPJzw+DF3EGhYkuUWWEp4oPb5WDMjMyG9DZjiwqyFa8uXr7OII9LofoGR6AruuCBiYif69f35xw==
X-Received: by 2002:a63:4923:: with SMTP id w35mr13774358pga.404.1610736705803;
        Fri, 15 Jan 2021 10:51:45 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a18sm8754939pfg.107.2021.01.15.10.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 10:51:45 -0800 (PST)
Date:   Fri, 15 Jan 2021 10:51:38 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Andi Kleen <andi@firstfloor.org>
Cc:     "Xu, Like" <like.xu@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
Message-ID: <YAHkOiQsxMfOMYvp@google.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <YACXQwBPI8OFV1T+@google.com>
 <f8a8e4e2-e0b1-8e68-81d4-044fb62045d5@intel.com>
 <YAHXlWmeR9p6JZm2@google.com>
 <20210115182700.byczztx3vjhsq3p3@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115182700.byczztx3vjhsq3p3@two.firstfloor.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021, Andi Kleen wrote:
> > I'm asking about ucode/hardare.  Is the "guest pebs buffer write -> PEBS PMI"
> > guaranteed to be atomic?
> 
> Of course not.

So there's still a window where the guest could observe the bad counter index,
correct?
