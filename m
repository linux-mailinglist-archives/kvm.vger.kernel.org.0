Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7CEC135B22
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 15:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731551AbgAIONw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 9 Jan 2020 09:13:52 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:40256 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728951AbgAIONw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 09:13:52 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-175-aevZXyfFPaql_ZCdCCrlLw-1; Thu, 09 Jan 2020 14:13:49 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 9 Jan 2020 14:13:48 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 9 Jan 2020 14:13:48 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sean Christopherson' <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: x86/mmu: Fix a benign Bitwise vs. Logical OR mixup
Thread-Topic: [PATCH] KVM: x86/mmu: Fix a benign Bitwise vs. Logical OR mixup
Thread-Index: AQHVxbk8+XHUyW1VS0SOYvyU0+7JlafiXjig
Date:   Thu, 9 Jan 2020 14:13:48 +0000
Message-ID: <c716f793e22e4885a3dee3c91f93e517@AcuMS.aculab.com>
References: <20200108001859.25254-1-sean.j.christopherson@intel.com>
In-Reply-To: <20200108001859.25254-1-sean.j.christopherson@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: aevZXyfFPaql_ZCdCCrlLw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson
> Sent: 08 January 2020 00:19
> 
> Use a Logical OR in __is_rsvd_bits_set() to combine the two reserved bit
> checks, which are obviously intended to be logical statements.  Switching
> to a Logical OR is functionally a nop, but allows the compiler to better
> optimize the checks.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7269130ea5e2..72e845709027 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3970,7 +3970,7 @@ __is_rsvd_bits_set(struct rsvd_bits_validate *rsvd_check, u64 pte, int level)
>  {
>  	int bit7 = (pte >> 7) & 1, low6 = pte & 0x3f;
> 
> -	return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) |
> +	return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) ||
>  		((rsvd_check->bad_mt_xwr & (1ull << low6)) != 0);

Are you sure this isn't deliberate?
The best code almost certainly comes from also removing the '!= 0'.
You also don't want to convert the expression result to zero.

So:
	return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) | (rsvd_check->bad_mt_xwr & (1ull << low6));
The code then doesn't have any branches to get mispredicted.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

