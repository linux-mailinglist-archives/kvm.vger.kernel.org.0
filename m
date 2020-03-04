Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF0C117936A
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 16:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgCDPdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 10:33:00 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44162 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726579AbgCDPdA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Mar 2020 10:33:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583335979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DvMXhwaYEf1u8lhU5yD2w5KVrzZ7oi00fPBDP3UuBlI=;
        b=GBHUMHBh7yTr7vU2MGu2KD8z89c7/hYwY2SqLvcrQlgipbnqpDBZP1lTkwMJ8A/a+eW6C9
        FZ5HTuQZmuduH1jfC3LPS01KFDB+2oMobK+NTkq3O3EJnhGl0/OnQJsq1fNRafw/CYKfBu
        TK+YNWMwUSjk/6eNlvekE+39vDQzloI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363--IdcTAfXMkqymAUsE7VHdQ-1; Wed, 04 Mar 2020 10:32:57 -0500
X-MC-Unique: -IdcTAfXMkqymAUsE7VHdQ-1
Received: by mail-qv1-f71.google.com with SMTP id h17so1180476qvc.18
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 07:32:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DvMXhwaYEf1u8lhU5yD2w5KVrzZ7oi00fPBDP3UuBlI=;
        b=kvv/87vMQ66dfF7EWSpXBY9bf7C6RJCvZ8Mo+aqL3Z696xamTdHbDKwx9WIQ0Co2jr
         +qnZ5U1AsjqdxkmXDmapTsB6QYeqB4WJg6gb5VoPJ6KdLvezOV7A9x1jZYOKt31/Cwqv
         1cmKcHP/QrcPsS2cxnTMWdoWsAeJPOB/f5ikgmembNsNcnP9T+9MjKcceyggTI6Gdwkk
         h0+IKzv3grBTEDd3ykjm3oUVd+0O6FcaHLdw6mJPm7n+MeJ395KQQQS4HLaKndaSS1q6
         oVRydia1U+EeyNBqA5zG2rd7K3CnW5WvnKnN5SZvdDfaCt9IXTTrpgO0JeUDqH9WIHj8
         CC7g==
X-Gm-Message-State: ANhLgQ3p2GU7xr5/sTcTwDgTTa4+NaUVgmXxDqEDigidtOShvRoaVwbT
        d5zQOFlJRqt2YBIIA5q/oTByVUrMVzplcRtS9TWVuUclz1juq17Yf2kf/s+4RhIPJYBLWp+OYAi
        RKlLeHzgSn8Gf
X-Received: by 2002:a05:6214:16c3:: with SMTP id d3mr2510371qvz.244.1583335976572;
        Wed, 04 Mar 2020 07:32:56 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsWlCEhg5A5OIWwDFtxlNHlAgmp4hY10amevunpEqVD30iTAynmKtqHiq8Z/L6AG/8livfJPg==
X-Received: by 2002:a05:6214:16c3:: with SMTP id d3mr2510339qvz.244.1583335976173;
        Wed, 04 Mar 2020 07:32:56 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id c13sm8350268qtv.37.2020.03.04.07.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 07:32:55 -0800 (PST)
Date:   Wed, 4 Mar 2020 10:32:53 -0500
From:   Peter Xu <peterx@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: Avoid explictly fetch instruction in
 x86_decode_insn()
Message-ID: <20200304153253.GB7146@xz-x1>
References: <05ca4e7e070844dd92e4f673a1bc15d9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <05ca4e7e070844dd92e4f673a1bc15d9@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 04, 2020 at 02:37:06AM +0000, linmiaohe wrote:
> Hi:
> Peter Xu <peterx@redhat.com> writes:
> >insn_fetch() will always implicitly refill instruction buffer properly when the buffer is empty, so we don't need to explicitly fetch it even if insn_len==0 for x86_decode_insn().
> >
> >Signed-off-by: Peter Xu <peterx@redhat.com>
> >---
> > arch/x86/kvm/emulate.c | 5 -----
> > 1 file changed, 5 deletions(-)
> >
> >diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c index dd19fb3539e0..04f33c1ca926 100644
> >--- a/arch/x86/kvm/emulate.c
> >+++ b/arch/x86/kvm/emulate.c
> >@@ -5175,11 +5175,6 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
> > 	ctxt->opcode_len = 1;
> > 	if (insn_len > 0)
> > 		memcpy(ctxt->fetch.data, insn, insn_len);
> >-	else {
> >-		rc = __do_insn_fetch_bytes(ctxt, 1);
> >-		if (rc != X86EMUL_CONTINUE)
> >-			goto done;
> >-	}
> > 
> > 	switch (mode) {
> > 	case X86EMUL_MODE_REAL:
> 
> Looks good, thanks. But it seems we should also take care of the comment in __do_insn_fetch_bytes(), as we do not
> load instruction at the beginning of x86_decode_insn() now, which may be misleading:
> 		/*
>          * One instruction can only straddle two pages,
>          * and one has been loaded at the beginning of
>          * x86_decode_insn.  So, if not enough bytes
>          * still, we must have hit the 15-byte boundary.
>          */
>         if (unlikely(size < op_size))
>                 return emulate_gp(ctxt, 0);

Right, thanks for spotting that (even if the patch to be dropped :).

I guess not only the comment, but the check might even fail if we
apply the patch. Because when the fetch is the 1st attempt and
unluckily that acrosses one page boundary (because we'll only fetch
until either 15 bytes or the page boundary), so that single fetch
could be smaller than op_size provided.

Thanks,

-- 
Peter Xu

