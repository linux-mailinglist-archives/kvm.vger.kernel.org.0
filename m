Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC6D1BCF8A
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 00:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgD1WNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 18:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725934AbgD1WNt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 18:13:49 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2CCC03C1AC
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 15:13:49 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u11so66831iow.4
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 15:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nt1cm16K5Y36Xh/ags5IlFDGPPNWI9tqZabQEk0lerk=;
        b=Pnjpc69a03aDBq/qhh2OAOK7R1vgOqgfEJpswJa4LrY0v9Mh4scs+TIZeMJ0a6XMen
         LhdW4Q9sQnXEozRdiuE07iBai0lTC9DGkjZ/rl5ODoasbAjHr7+Fo18rj5zn7s+40gNz
         iAvuQe2iImsfmV+sc1Ksjpa0s9JUBBMGSVGq0564FHWLONLCkA+bl7Hjy0c89Dvw9pSY
         LVU2xYmjBErDnRx3hFdMNDEX1aSi7sffi2hbUCTOAHzDMdm1pKnLo86JPq3gPdZfZAqY
         CP7PHW4+A/cda9B40s2k9nWBNneJLIKMn+i7aY7Q4zJGS8399VEZVJjtKcNxd9cc6MX1
         kzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nt1cm16K5Y36Xh/ags5IlFDGPPNWI9tqZabQEk0lerk=;
        b=CnM25tdZzpVpxH7GpsGV85FoVNJDmiKAcb62ftA5tM16VsCtsBYqdJP2Pf+SmYJi5o
         R7lhn4o/h6e25OdMk3Wcq0SQauoFpHhW7PO37aJVBfDjVsqwp0vZlLtFRoKCMCOwtcIR
         E3VgIjZlFr233CpH6dKeillbT77CouJpLqAMcbwbFXpAqEAdLdSV1/A9jo4ZHK4ujCh5
         10JV3gHlSkLzwAtn07SRz5Ygb5FXT3oJdvOOn5eu/URwxdCTyBp2e1RN3QnnA0aD2yto
         4+c9eEwXlmlNC53MY/4ci8P6ZZ3aLYIWM1OPG8J1CTmXOS+WrCeGBHOivbSTNCYBv3P5
         VM0w==
X-Gm-Message-State: AGi0PuYNdqTCahCiMw+GlS/NUu4Q8qHt9nj25Xa6OlR7cq0jcg1xVkz6
        FWUYenYKBptLMq5sxbt9XRvn9xt86p4DHIghNqMrBQ==
X-Google-Smtp-Source: APiQypKr1XjkmQooE/lzZ/u45HwY4nKIHKWQktaVIhq1vSY/3xMLN9btT4nz5s5h8EBpad7gV6FTGcaNJpohL6Cfzxg=
X-Received: by 2002:a05:6638:bd0:: with SMTP id g16mr27868146jad.48.1588112028205;
 Tue, 28 Apr 2020 15:13:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-14-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-14-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 15:13:37 -0700
Message-ID: <CALMp9eQ0hpZ8MBmCCEXQHKFxyeFzRbJ3+OmaTe2cMwtkp2AKGA@mail.gmail.com>
Subject: Re: [PATCH 13/13] KVM: VMX: Use vmx_get_rflags() to query RFLAGS in vmx_interrupt_blocked()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Use vmx_get_rflags() instead of manually reading vmcs.GUEST_RFLAGS when
> querying RFLAGS.IF so that multiple checks against interrupt blocking in
> a single run loop only require a single VMREAD.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
