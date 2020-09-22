Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB255273A50
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 07:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgIVFjh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 22 Sep 2020 01:39:37 -0400
Received: from mx21.baidu.com ([220.181.3.85]:33906 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726727AbgIVFjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 01:39:37 -0400
X-Greylist: delayed 960 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2020 01:39:36 EDT
Received: from BC-Mail-Ex32.internal.baidu.com (unknown [172.31.51.26])
        by Forcepoint Email with ESMTPS id E2624EB6634B22EB3038;
        Tue, 22 Sep 2020 13:23:31 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex32.internal.baidu.com (172.31.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Tue, 22 Sep 2020 13:23:31 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.1979.006; Tue, 22 Sep 2020 13:23:31 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH] KVM: x86/mmu: fix counting of rmap entries in
 pte_list_add
Thread-Topic: [PATCH] KVM: x86/mmu: fix counting of rmap entries in
 pte_list_add
Thread-Index: AQHWkAIUCKvT3+Qn7Eqh6aADIGdDIKly+A+AgAEostA=
Date:   Tue, 22 Sep 2020 05:23:31 +0000
Message-ID: <0aef7e63d9324a21850c219255540541@baidu.com>
References: <1600684166-32430-1-git-send-email-lirongqing@baidu.com>
 <20200921194043.GA25005@linux.intel.com>
In-Reply-To: <20200921194043.GA25005@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.1]
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



+AD4- -----Original Message-----
+AD4- From: Sean Christopherson +AFs-mailto:sean.j.christopherson+AEA-intel.com+AF0-
+AD4- Sent: Tuesday, September 22, 2020 3:41 AM
+AD4- To: Li,Rongqing +ADw-lirongqing+AEA-baidu.com+AD4-
+AD4- Cc: kvm+AEA-vger.kernel.org+ADs- x86+AEA-kernel.org
+AD4- Subject: Re: +AFs-PATCH+AF0- KVM: x86/mmu: fix counting of rmap entries in
+AD4- pte+AF8-list+AF8-add
+AD4- 
+AD4- On Mon, Sep 21, 2020 at 06:29:26PM +-0800, Li RongQing wrote:
+AD4- +AD4- counting of rmap entries was missed when desc-+AD4-sptes is full and
+AD4- +AD4- desc-+AD4-more is NULL
+AD4- +AD4-
+AD4- +AD4- Signed-off-by: Li RongQing +ADw-lirongqing+AEA-baidu.com+AD4-
+AD4- +AD4- ---
+AD4- +AD4-  arch/x86/kvm/mmu/mmu.c +AHw- 1 +-
+AD4- +AD4-  1 file changed, 1 insertion(+-)
+AD4- +AD4-
+AD4- +AD4- diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c index
+AD4- +AD4- a5d0207e7189..8ffa4e40b650 100644
+AD4- +AD4- --- a/arch/x86/kvm/mmu/mmu.c
+AD4- +AD4- +-+-+- b/arch/x86/kvm/mmu/mmu.c
+AD4- +AD4- +AEAAQA- -1280,6 +-1280,7 +AEAAQA- static int pte+AF8-list+AF8-add(struct kvm+AF8-vcpu +ACo-vcpu, u64
+AD4- +ACo-spte,
+AD4- +AD4-  		if (desc-+AD4-sptes+AFs-PTE+AF8-LIST+AF8-EXT-1+AF0-) +AHs-
+AD4- +AD4-  			desc-+AD4-more +AD0- mmu+AF8-alloc+AF8-pte+AF8-list+AF8-desc(vcpu)+ADs-
+AD4- +AD4-  			desc +AD0- desc-+AD4-more+ADs-
+AD4- +AD4- +-			count +-+AD0- PTE+AF8-LIST+AF8-EXT+ADs-
+AD4- 
+AD4- Kind of a nit, but what do you think about merging the two PTE+AF8-LIST+AF8-EXT-1
+AD4- check?  For me, that makes the resulting code more obviously correct, and it
+AD4- might be slightly more performant as it avoids the extra comparison, though
+AD4- the compiler may be smart enough to optimize that away without help.
+AD4- 
+AD4- 		while (desc-+AD4-sptes+AFs-PTE+AF8-LIST+AF8-EXIT-1+AF0-) +AHs-
+AD4- 			count +-+AD0- PTE+AF8-LIST+AF8-EXT+ADs-
+AD4- 
+AD4- 			if (+ACE-desc-+AD4-more) +AHs-
+AD4- 				desc-+AD4-more +AD0- mmu+AF8-alloc+AF8-pte+AF8-list+AF8-desc(vcpu)+ADs-
+AD4- 				desc +AD0- desc-+AD4-more+ADs-
+AD4- 				break+ADs-
+AD4- 			+AH0-
+AD4- 			desc +AD0- desc-+AD4-more+ADs-
+AD4- 		+AH0-
+AD4- 

Ok, I will send V2 as you suggested

Thanks

-Li
