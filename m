Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A40179327
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 16:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgCDPSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 10:18:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43244 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729633AbgCDPSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 10:18:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583335118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GkHSzVp8bmma3Su8zlIo0I8lOwWNm++b2FMG0SY0gfM=;
        b=D9MLnwFrqobu+NEwHLn0zc/0H8gVVmMQW97ZTBMga778RJSgkMNIq1Q8MhLLoHaIWresM7
        cDU1EcTpNIhq3OMss7/Wi3judasgOKaj49h/zdpBmJtMl6fS/JQ72EtFrCVMswjI7D9nCK
        d5akjrkbXxBgBdatwDhmEz6th85Wamo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-8EMVuPjTMYaIExoeT4Gizg-1; Wed, 04 Mar 2020 10:18:28 -0500
X-MC-Unique: 8EMVuPjTMYaIExoeT4Gizg-1
Received: by mail-qk1-f197.google.com with SMTP id b22so1513307qkk.15
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 07:18:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GkHSzVp8bmma3Su8zlIo0I8lOwWNm++b2FMG0SY0gfM=;
        b=ukVxvIfxs1O7lrFDLgbAH0jrtCDSCwfh6AHkVNSh9y5Y11/tvHQbBK+Dw7DMqDQDNp
         1/FKIOn9kpL07Bj+u5b/gPgaWC1u0fiG4TMmbNnxGiRUV1MRkUQk/dvZgTQqAGl58SxQ
         UTDkOFgtvhke5IwHm3/3NrJXJ+bwPmCPiDpxft7dtSsNLmdn/vza6lP2at43B2d2s/1y
         WyviQjIJnlqAcFAGDX1AbojKcTBwkPaz9usB5Ynj03aGbc8ix60L2JPwTtFHlfbwARjR
         K582//zle77yOxl5ls0lZKGpJ5spunbr0PCXR9kqWvrtHpBhtNEe+7JxUZ/iVgLp7M0b
         d/Qw==
X-Gm-Message-State: ANhLgQ1QDWNyGsGMJM4GvjBDf/JTDJMkD9nZu8qP5D5G2wGPLhhW6DSm
        gnEOFusYwpN2WyJYrXM+8V2aKotLtieDgXwhz4CBGhNK2GROANIXfOY3eWEo2OG12YiQo5kFEXM
        0lPNN/hzM4jVI
X-Received: by 2002:aed:2ee5:: with SMTP id k92mr2767099qtd.373.1583335107421;
        Wed, 04 Mar 2020 07:18:27 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtQYGuhCn6y4jOYnVtHaVm1THfFPu8cJ2tiqlGcqwyccMi7LcH/Ht6thHqAW7lpUyEXX4OHAA==
X-Received: by 2002:aed:2ee5:: with SMTP id k92mr2767072qtd.373.1583335107167;
        Wed, 04 Mar 2020 07:18:27 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l184sm13906536qkc.107.2020.03.04.07.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 07:18:26 -0800 (PST)
Date:   Wed, 4 Mar 2020 10:18:25 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linmiaohe <linmiaohe@huawei.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: Avoid explictly fetch instruction in
 x86_decode_insn()
Message-ID: <20200304151825.GA7146@xz-x1>
References: <05ca4e7e070844dd92e4f673a1bc15d9@huawei.com>
 <593e16d8-1021-29ef-11d0-a72d762db057@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <593e16d8-1021-29ef-11d0-a72d762db057@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 04, 2020 at 08:30:49AM +0100, Paolo Bonzini wrote:
> On 04/03/20 03:37, linmiaohe wrote:
> > Hi:
> > Peter Xu <peterx@redhat.com> writes:
> >> insn_fetch() will always implicitly refill instruction buffer properly when the buffer is empty, so we don't need to explicitly fetch it even if insn_len==0 for x86_decode_insn().
> >>
> >> Signed-off-by: Peter Xu <peterx@redhat.com>
> >> ---
> >> arch/x86/kvm/emulate.c | 5 -----
> >> 1 file changed, 5 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c index dd19fb3539e0..04f33c1ca926 100644
> >> --- a/arch/x86/kvm/emulate.c
> >> +++ b/arch/x86/kvm/emulate.c
> >> @@ -5175,11 +5175,6 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
> >> 	ctxt->opcode_len = 1;
> >> 	if (insn_len > 0)
> >> 		memcpy(ctxt->fetch.data, insn, insn_len);
> >> -	else {
> >> -		rc = __do_insn_fetch_bytes(ctxt, 1);
> >> -		if (rc != X86EMUL_CONTINUE)
> >> -			goto done;
> >> -	}
> >>
> >> 	switch (mode) {
> >> 	case X86EMUL_MODE_REAL:
> 
> This is a a small (but measurable) optimization; going through
> __do_insn_fetch_bytes instead of do_insn_fetch_bytes is a little bit
> faster because it lets you mark the branch in do_insn_fetch_bytes as
> unlikely, and in general it allows the branch predictor to do a better job.

Ah I see, that makes sense.  Thanks!

-- 
Peter Xu

