Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43883665CFD
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 14:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbjAKNuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 08:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjAKNuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 08:50:00 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38921C7E;
        Wed, 11 Jan 2023 05:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673444999; x=1704980999;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=T4VLwb+WAEhKP27vGcXiylUrNAmmuEI1ccEYWHt8Qec=;
  b=Ra/PmN25pRyquOGRjfAQVmnV+bZMLuPl7xAquLVbZkzcqVUT3XjEinK5
   Rk95o+h1EJ/BByVoEQZ0I8eKBsAv3rwvTc1k5RKYgix4q2XUvSQhYKVSi
   DLDA8Gu1uc3ItYlWC8UYkXAOZKuWUgZmfT+hiMGP9GTgdfxL3D2zYYYXd
   s=;
X-IronPort-AV: E=Sophos;i="5.96,317,1665446400"; 
   d="scan'208";a="285546276"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 13:49:56 +0000
Received: from EX13D40EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id C212381180;
        Wed, 11 Jan 2023 13:49:45 +0000 (UTC)
Received: from EX19D024EUA002.ant.amazon.com (10.252.50.224) by
 EX13D40EUA004.ant.amazon.com (10.43.165.178) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 11 Jan 2023 13:49:44 +0000
Received: from [10.220.99.6] (10.43.161.114) by EX19D024EUA002.ant.amazon.com
 (10.252.50.224) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.7; Wed, 11 Jan
 2023 13:49:30 +0000
Message-ID: <3c9d5c84-7b54-e12e-f6ba-a73f66e0b094@amazon.com>
Date:   Wed, 11 Jan 2023 15:49:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH RFC v7 49/64] KVM: SVM: Introduce ops for the post gfn map
 and unmap
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
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-50-michael.roth@amd.com>
From:   Sabin Rapan <sabrapan@amazon.com>
In-Reply-To: <20221214194056.161492-50-michael.roth@amd.com>
X-Originating-IP: [10.43.161.114]
X-ClientProxiedBy: EX13D40UWC002.ant.amazon.com (10.43.162.191) To
 EX19D024EUA002.ant.amazon.com (10.252.50.224)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxNC4xMi4yMDIyIDIxOjQwLCBNaWNoYWVsIFJvdGggd3JvdGU6Cj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS9zdm0vc3ZtLmggYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5oCj4gaW5kZXgg
YTRkNDhjM2UwZjg5Li5hZWYxM2MxMjBmMmQgMTAwNjQ0Cj4gLS0tIGEvYXJjaC94ODYva3ZtL3N2
bS9zdm0uaAo+ICsrKyBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmgKPiBAQCAtMTAwLDYgKzEwMCw3
IEBAIHN0cnVjdCBrdm1fc2V2X2luZm8gewo+ICAgICAgICAgYXRvbWljX3QgbWlncmF0aW9uX2lu
X3Byb2dyZXNzOwo+ICAgICAgICAgdTY0IHNucF9pbml0X2ZsYWdzOwo+ICAgICAgICAgdm9pZCAq
c25wX2NvbnRleHQ7ICAgICAgLyogU05QIGd1ZXN0IGNvbnRleHQgcGFnZSAqLwo+ICsgICAgICAg
c3BpbmxvY2tfdCBwc2NfbG9jazsKCkxvb2tzIGxpa2UgYSBsZWZ0b3ZlciBmcm9tIHY2IHNlcmll
cy4KCi0tClNhYmluLgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIu
TC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAy
LCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFu
aWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

