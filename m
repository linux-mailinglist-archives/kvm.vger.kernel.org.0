Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B4C17886E
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 03:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387553AbgCDChP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 3 Mar 2020 21:37:15 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3030 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387400AbgCDChO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 21:37:14 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id D3FC07D40D7113628DF7;
        Wed,  4 Mar 2020 10:37:08 +0800 (CST)
Received: from dggeme701-chm.china.huawei.com (10.1.199.97) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 4 Mar 2020 10:37:06 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme701-chm.china.huawei.com (10.1.199.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 4 Mar 2020 10:37:06 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Wed, 4 Mar 2020 10:37:06 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Peter Xu <peterx@redhat.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: Avoid explictly fetch instruction in
 x86_decode_insn()
Thread-Topic: [PATCH] KVM: X86: Avoid explictly fetch instruction in
 x86_decode_insn()
Thread-Index: AdXxzU+9EdpZA476YkWRUZaXJe9EEg==
Date:   Wed, 4 Mar 2020 02:37:06 +0000
Message-ID: <05ca4e7e070844dd92e4f673a1bc15d9@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi:
Peter Xu <peterx@redhat.com> writes:
>insn_fetch() will always implicitly refill instruction buffer properly when the buffer is empty, so we don't need to explicitly fetch it even if insn_len==0 for x86_decode_insn().
>
>Signed-off-by: Peter Xu <peterx@redhat.com>
>---
> arch/x86/kvm/emulate.c | 5 -----
> 1 file changed, 5 deletions(-)
>
>diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c index dd19fb3539e0..04f33c1ca926 100644
>--- a/arch/x86/kvm/emulate.c
>+++ b/arch/x86/kvm/emulate.c
>@@ -5175,11 +5175,6 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
> 	ctxt->opcode_len = 1;
> 	if (insn_len > 0)
> 		memcpy(ctxt->fetch.data, insn, insn_len);
>-	else {
>-		rc = __do_insn_fetch_bytes(ctxt, 1);
>-		if (rc != X86EMUL_CONTINUE)
>-			goto done;
>-	}
> 
> 	switch (mode) {
> 	case X86EMUL_MODE_REAL:

Looks good, thanks. But it seems we should also take care of the comment in __do_insn_fetch_bytes(), as we do not
load instruction at the beginning of x86_decode_insn() now, which may be misleading:
		/*
         * One instruction can only straddle two pages,
         * and one has been loaded at the beginning of
         * x86_decode_insn.  So, if not enough bytes
         * still, we must have hit the 15-byte boundary.
         */
        if (unlikely(size < op_size))
                return emulate_gp(ctxt, 0);
