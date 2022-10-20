Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE3A606839
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 20:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiJTSbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 14:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJTSbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 14:31:31 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2774203575
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666290680; x=1697826680;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+EV3+BIE0oQ+CtIIMi7skgLBzrdfg11hs/RU8pkuczw=;
  b=q8w7WWE7yRI/KCpCRz0ZzHb4Oa9TigOX1JWwLcK6vCBSVFGZH3wStli9
   Z6pncjFtGDr9VFGmmtOwxgstyTmrI01o6e1H6V+YPWmucLJKWMZSTFxPg
   UiMGoIl4bJLO9XcCp/hoBXzv3pQHp6/AvDELZ1aKGjkUXxdx8tMo4u5sq
   A=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 18:31:14 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com (Postfix) with ESMTPS id 5E7D720346A;
        Thu, 20 Oct 2022 18:31:14 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 20 Oct 2022 18:31:09 +0000
Received: from [10.95.67.64] (10.43.161.58) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.15; Thu, 20 Oct
 2022 18:31:07 +0000
Message-ID: <590c9312-a21f-8569-9da3-34508300afcc@amazon.com>
Date:   Thu, 20 Oct 2022 20:31:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        <kvm@vger.kernel.org>, Xiao Guangrong <guangrong.xiao@gmail.com>,
        "Chandrasekaran, Siddharth" <sidcha@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
 <20190205210137.1377-11-sean.j.christopherson@intel.com>
 <20190813100458.70b7d82d@x1.home> <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home> <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com> <20190815092324.46bb3ac1@x1.home>
 <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
 <20190820200318.GA15808@linux.intel.com>
 <20200626173250.GD6583@linux.intel.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <20200626173250.GD6583@linux.intel.com>
X-Originating-IP: [10.43.161.58]
X-ClientProxiedBy: EX13D37UWC004.ant.amazon.com (10.43.162.212) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMjYuMDYuMjAgMTk6MzIsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4gL2Nhc3QgPHRo
cmVhZCBuZWNyb21hbmN5Pgo+IAo+IE9uIFR1ZSwgQXVnIDIwLCAyMDE5IGF0IDAxOjAzOjE5UE0g
LTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6CgpbLi4uXQoKPiBJIGRvbid0IHRoaW5r
IGFueSBvZiB0aGlzIGV4cGxhaW5zIHRoZSBwYXNzLXRocm91Z2ggR1BVIGlzc3VlLiAgQnV0LCB3
ZQo+IGhhdmUgYSBmZXcgdXNlIGNhc2VzIHdoZXJlIHphcHBpbmcgdGhlIGVudGlyZSBNTVUgaXMg
dW5kZXNpcmFibGUsIHNvIEknbQo+IGdvaW5nIHRvIHJldHJ5IHVwc3RyZWFtaW5nIHRoaXMgcGF0
Y2ggYXMgd2l0aCBwZXItVk0gb3B0LWluLiAgSSB3YW50ZWQgdG8KPiBzZXQgdGhlIHJlY29yZCBz
dHJhaWdodCBmb3IgcG9zdGVyaXR5IGJlZm9yZSBkb2luZyBzby4KCkhleSBTZWFuLAoKRGlkIHlv
dSBldmVyIGdldCBhcm91bmQgdG8gdXBzdHJlYW0gb3IgcmV3b3JrIHRoZSB6YXAgb3B0aW1pemF0
aW9uPyBUaGUgCndheSBJIHJlYWQgY3VycmVudCB1cHN0cmVhbSwgYSBtZW1zbG90IGNoYW5nZSBz
dGlsbCBhbHdheXMgd2lwZXMgYWxsIApTUFRFcywgbm90IG9ubHkgdGhlIG9uZXMgdGhhdCB3ZXJl
IGNoYW5nZWQuCgoKVGhhbmtzLAoKQWxleAoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBH
ZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVu
ZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10
c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpV
c3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

