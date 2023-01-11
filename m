Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D74665E69
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 15:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbjAKOvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 09:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbjAKOv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 09:51:27 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB44819C13;
        Wed, 11 Jan 2023 06:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673448687; x=1704984687;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n45m5Cnc0XyVGw5+Aet7GY6rtwRDVDBECQftBvbXgXQ=;
  b=vpaXd1zk80KE4p8yk8PMktTvaB/u6R9704H/R+vv7jdWLDghFNFQ46Sd
   /YzWOsuE+hNTROLGtV50G5nu179qFS4JSZeduSbqJHNsar047+kzTnE9m
   LjE0+jI+QL741z3r3b92TBnNs/vKS2j6IB8YtNAtZHOOjo5Hjkz/OJnzu
   Y=;
X-IronPort-AV: E=Sophos;i="5.96,317,1665446400"; 
   d="scan'208";a="281733609"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 14:51:20 +0000
Received: from EX13D31EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com (Postfix) with ESMTPS id 0446E40D7E;
        Wed, 11 Jan 2023 14:51:16 +0000 (UTC)
Received: from EX19D024EUA002.ant.amazon.com (10.252.50.224) by
 EX13D31EUA002.ant.amazon.com (10.43.165.238) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 11 Jan 2023 14:51:15 +0000
Received: from [10.220.99.6] (10.43.161.114) by EX19D024EUA002.ant.amazon.com
 (10.252.50.224) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.7; Wed, 11 Jan
 2023 14:51:01 +0000
Message-ID: <65f056ed-68ab-2541-7c83-3f1712e597ce@amazon.com>
Date:   Wed, 11 Jan 2023 16:50:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH RFC v7 14/64] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-15-michael.roth@amd.com>
From:   Sabin Rapan <sabrapan@amazon.com>
In-Reply-To: <20221214194056.161492-15-michael.roth@amd.com>
X-Originating-IP: [10.43.161.114]
X-ClientProxiedBy: EX13D49UWC001.ant.amazon.com (10.43.162.217) To
 EX19D024EUA002.ant.amazon.com (10.252.50.224)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxNC4xMi4yMDIyIDIxOjQwLCBNaWNoYWVsIFJvdGggd3JvdGU6Cj4gKyNpZmRlZiBDT05G
SUdfQU1EX01FTV9FTkNSWVBUCj4gKyMgZGVmaW5lIERJU0FCTEVfU0VWX1NOUCAgICAgICAwCj4g
KyNlbHNlCj4gKyMgZGVmaW5lIERJU0FCTEVfU0VWX1NOUCAgICAgICAoMSA8PCAoWDg2X0ZFQVRV
UkVfU0VWX1NOUCAmIDMxKSkKPiArI2VuZGlmCj4gKwoKV291bGQgaXQgbWFrZSBzZW5zZSB0byBz
cGxpdCB0aGUgU0VWLSogZmVhdHVyZSBmYW1pbHkgaW50byB0aGVpciBvd24KY29uZmlnIGZsYWco
cykgPwpJJ20gdGhpbmtpbmcgaW4gdGhlIGNvbnRleHQgb2YgU0VWLVNOUCBydW5uaW5nIG9uIHN5
c3RlbXMgd2l0aApUcmFuc3BhcmVudCBTTUUgZW5hYmxlZCBpbiB0aGUgYmlvcy4gSW4gdGhpcyBj
YXNlLCBlbmFibGluZwpDT05GSUdfQU1EX01FTV9FTkNSWVBUIHdpbGwgYWxzbyBlbmFibGUgU01F
IGluIHRoZSBrZXJuZWwsIHdoaWNoIGlzIGEKYml0IHN0cmFuZ2UgYW5kIG5vdCBuZWNlc3Nhcmls
eSB1c2VmdWwuCkNvbW1pdCA0ZTJjODc5NDlmMmIgKCJjcnlwdG86IGNjcCAtIFdoZW4gVFNNRSBh
bmQgU01FIGJvdGggZGV0ZWN0ZWQKbm90aWZ5IHVzZXIiKSBoaWdobGlnaHRzIGl0LgoKLS0KU2Fi
aW4uCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3Rl
cmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElh
c2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0
cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

