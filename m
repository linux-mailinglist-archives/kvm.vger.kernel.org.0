Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27971279747
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 08:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIZGeT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 26 Sep 2020 02:34:19 -0400
Received: from mx21.baidu.com ([220.181.3.85]:56744 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726119AbgIZGeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Sep 2020 02:34:19 -0400
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id ECEB7FAE2883F6BB7F2D;
        Sat, 26 Sep 2020 14:34:13 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Sat, 26 Sep 2020 14:34:13 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.1979.006; Sat, 26 Sep 2020 14:34:13 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH][v2] KVM: x86/mmu: fix counting of rmap entries in
 pte_list_add
Thread-Topic: [PATCH][v2] KVM: x86/mmu: fix counting of rmap entries in
 pte_list_add
Thread-Index: AQHWkWY/97lZ61TipkSN3Fiq4WPPSKl5DRqAgAFtjrA=
Date:   Sat, 26 Sep 2020 06:34:13 +0000
Message-ID: <83a9d7fe8a364083974571ff51a809ca@baidu.com>
References: <1600837138-21110-1-git-send-email-lirongqing@baidu.com>
 <20200925164332.GA31528@linux.intel.com>
In-Reply-To: <20200925164332.GA31528@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.197.252]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2020-09-26 14:34:13:904
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



+AD4- -----Original Message-----
+AD4- From: Sean Christopherson +AFs-mailto:sean.j.christopherson+AEA-intel.com+AF0-
+AD4- Sent: Saturday, September 26, 2020 12:44 AM
+AD4- To: Li,Rongqing +ADw-lirongqing+AEA-baidu.com+AD4-
+AD4- Cc: kvm+AEA-vger.kernel.org+ADs- x86+AEA-kernel.org
+AD4- Subject: Re: +AFs-PATCH+AF0AWw-v2+AF0- KVM: x86/mmu: fix counting of rmap entries in
+AD4- pte+AF8-list+AF8-add
+AD4- 
+AD4- On Wed, Sep 23, 2020 at 12:58:58PM +-0800, Li RongQing wrote:
+AD4- +AD4- counting of rmap entries was missed when desc-+AD4-sptes is full and
+AD4- +AD4- desc-+AD4-more is NULL
+AD4- +AD4-
+AD4- +AD4- and merging two PTE+AF8-LIST+AF8-EXT-1 check as one, to avoids the extra
+AD4- +AD4- comparison to give slightly optimization
+AD4- 
+AD4- Please write complete sentences, and use proper capitalization and
+AD4- punctuation.
+AD4- It's not a big deal for short changelogs, but it's crucial for readability of larger
+AD4- changelogs.
+AD4- 
+AD4- E.g.
+AD4- 
+AD4-   Fix an off-by-one style bug in pte+AF8-list+AF8-add() where it failed to account
+AD4-   the last full set of SPTEs, i.e. when desc-+AD4-sptes is full and desc-+AD4-more
+AD4-   is NULL.
+AD4- 
+AD4-   Merge the two +ACI-PTE+AF8-LIST+AF8-EXT-1+ACI- checks as part of the fix to avoid an
+AD4-   extra comparison.
+AD4- 
+AD4- +AD4- Suggested-by: Sean Christopherson +ADw-sean.j.christopherson+AEA-intel.com+AD4-
+AD4- 
+AD4- No need to give me credit, I just nitpicked the code, identifying the bug and the
+AD4- fix was all you. :-)
+AD4- 
+AD4- Thanks for the fix+ACE-
+AD4- 
+AD4- +AD4- Signed-off-by: Li RongQing +ADw-lirongqing+AEA-baidu.com+AD4-
+AD4- 
+AD4- Paolo,
+AD4- 
+AD4- Although it's a bug fix, I don't think this needs a Fixes / Cc:stable.  The bug
+AD4- only results in rmap recycling being delayed by one rmap.  Stable kernels can
+AD4- probably live with an off-by-one bug given that RMAP+AF8-RECYCLE+AF8-THRESHOLD is
+AD4- completely arbitrary. :-)
+AD4- 
+AD4- Reviewed-by: Sean Christopherson +ADw-sean.j.christopherson+AEA-intel.com+AD4-
+AD4- 

Thank you very much , I will send V3

-Li
