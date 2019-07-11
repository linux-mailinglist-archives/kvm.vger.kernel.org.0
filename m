Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C5766238
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 01:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfGKX1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 19:27:49 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35882 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbfGKX1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 19:27:49 -0400
Received: by mail-pl1-f195.google.com with SMTP id k8so3824969plt.3
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 16:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/+IMUuzU4bJjWGZu3tMhD7AFBy8JA4qbmJISAAjHN6c=;
        b=hHNGHyTla7zovXAfvzskcrb9chgL/WpRSJ6M9R8zNgp2yFS2ExReVOIbQQEAb0emAg
         0CxGpZhRdc+IC0Qb3Nz4KWaidAHoE1PIFNs1X5DomGtBURhAhcQ+9s21oAwz3IpvKreg
         dR7jAWEzoWRNPjUMq7SIwy99fUb+LkXp1Xm1hE5RiYWxmo7LDFOTZqlNHlFMa//e8mgx
         r4kgwxwrsJPAp/bU35NxM/SA7ucS0LQ7jt1TzI9TPsWorzg5FOBhOQDGaKxJOZ9V5+er
         7mjZGr5XfwUVaeku4iU0kQ85gjdhO2SMj08t/Cw25WkGB6HY0QlgWohyaNfMSifRxlZL
         4+1w==
X-Gm-Message-State: APjAAAUDnir7WoU2ciEeN10TPXtAHG3h5eZZllp6Dso5bDsmpXMg0Cuv
        H2N//V1cIOK1r39cKVpnfgaakA==
X-Google-Smtp-Source: APXvYqwTSEd3cyW8a2t67TneIHn/6jEsrVcdXGR07SPuCWzhDaFUmWCaDOgkRAgLAvGKXnmO/hls4A==
X-Received: by 2002:a17:902:be0a:: with SMTP id r10mr7109505pls.51.1562887669036;
        Thu, 11 Jul 2019 16:27:49 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x22sm8480939pff.5.2019.07.11.16.27.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 16:27:48 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
Date:   Fri, 12 Jul 2019 07:27:36 +0800
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Xu <zhexu@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] tscdeadline_latency: Check condition
 first before loop
Message-ID: <20190711232736.GD7847@xz-x1>
References: <20190711071756.2784-1-peterx@redhat.com>
 <20190711073335.GC7847@xz-x1>
 <20190711140553.GB7645@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190711140553.GB7645@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 11, 2019 at 07:05:53AM -0700, Sean Christopherson wrote:
> Ensuring the first hlt lands in an interrupt shadow should prevent getting
> into a halted state after the timer has been disabled, e.g.:
> 
>     irq_disable();
>     test_tsc_deadline_timer();
> 
>     do {
>         safe_halt();
>     } while (!hitmax && table_idx < size);

Yes seems better, thanks for the suggestion (though I'll probably also
need to remove the hidden sti in start_tsc_deadline_timer).

Is safe_halt() really safe?  I mean, IRQ handler could still run
before HLT right after STI right?  Though no matter what I think it's
fine for this test case because we'll skip the first IRQ after all.
Just curious.

Thanks,

-- 
Peter Xu
