Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52321BF97B
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 15:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgD3N2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 09:28:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32841 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726577AbgD3N2M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 09:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588253290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VAxtXeE7jABzTDpf7SPMl48rHqhFXJS9keWJIiG3Vjk=;
        b=XnBvpZPaX23ipIbT3/M+ehzWlfOKvXOVyWFjKuX/MLCI5c8yd9IaSMCMeYUmr+hwR+7z0F
        Rc6DDH/fcE+O3oiTkCoLFGS3PEXWmCR9XuxB4uL7VBu61NChPqqmbXnvYLfTzrg46zZQQm
        3Brwr1zjH4SzgjRDTaRIP/BeEmOjgUU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-9to4yYSTMrqrmpSSgwSEqQ-1; Thu, 30 Apr 2020 09:28:09 -0400
X-MC-Unique: 9to4yYSTMrqrmpSSgwSEqQ-1
Received: by mail-qt1-f200.google.com with SMTP id q43so7026899qtj.11
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 06:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VAxtXeE7jABzTDpf7SPMl48rHqhFXJS9keWJIiG3Vjk=;
        b=SRX8pg32JavhPKfMmTj/9XmGNOi5XcZL4JKxmyaHShHNMbxdSGIuvyi3l9Oaz92wvd
         8dgXUKPHJnVxqY7zy4haV51SjZkgk0P0Fd/y+U8oIHLb7C28HoGZM9Bp3qQe2Dcj2uw8
         MOjpFuAnwSM4axTCrCTUkXEIWc3Kg+HF2IsZ+Ncz9UBz+XurFqVbKk26ybRSG66TPUPY
         sTdRYrn3XyOmnIcoRPtMTSs+dCYuJ/ckU8Fjxl+G1WQVIAbJZxRRX7J9Avbs+t3+wmtm
         jOuctIE6MzjviVPqjzZqnt807g9aTRJ2C3PigNe5jlBHwhlJ8YQUllePbNgd7ypIrwis
         J42Q==
X-Gm-Message-State: AGi0PuaBi45x+e3Kl3eA2hVu4RGfDSnC2vluzOEfVG2q5lUgV/aKhhTi
        Zz+pfzCW0cOGS2d1XJJkajMkuXe/Z6uRh12y+KHs2MvYvAmBCnTbfJtWBCn1LvE9pczhd01sUKK
        OcB9QyukyqYxR
X-Received: by 2002:a37:b141:: with SMTP id a62mr3469476qkf.135.1588253288516;
        Thu, 30 Apr 2020 06:28:08 -0700 (PDT)
X-Google-Smtp-Source: APiQypIfQeoTAzFa9+FkrkC/xFo4/XpcSAU+KiLE0SM26HDG/2LCq0fmh2kYaCiKeF3HdOmVYFBpdQ==
X-Received: by 2002:a37:b141:: with SMTP id a62mr3469441qkf.135.1588253288132;
        Thu, 30 Apr 2020 06:28:08 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id b42sm2186346qta.29.2020.04.30.06.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 06:28:07 -0700 (PDT)
Date:   Thu, 30 Apr 2020 09:28:05 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 3/6] KVM: x86: interrupt based APF page-ready event
 delivery
Message-ID: <20200430132805.GB40678@xz-x1>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-4-vkuznets@redhat.com>
 <20200429212708.GA40678@xz-x1>
 <87v9lhfk7v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87v9lhfk7v.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 30, 2020 at 10:31:32AM +0200, Vitaly Kuznetsov wrote:
> as we need to write to two MSRs to configure the new mechanism ordering
> becomes important. If the guest writes to ASYNC_PF_EN first to establish
> the shared memory stucture the interrupt in ASYNC_PF2 is not yet set
> (and AFAIR '0' is a valid interrupt!) so if an async pf happens
> immediately after that we'll be forced to inject INT0 in the guest and
> it'll get confused and linkely miss the event.
> 
> We can probably mandate the reverse sequence: guest has to set up
> interrupt in ASYNC_PF2 first and then write to ASYNC_PF_EN (with both
> bit 0 and bit 3). In that case the additional 'enable' bit in ASYNC_PF2
> seems redundant. This protocol doesn't look too complex for guests to
> follow.

Yep looks good.  We should also update the document too about the fact.

Thanks,

-- 
Peter Xu

