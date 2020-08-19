Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADC424A8B5
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 23:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgHSVqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 17:46:31 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:7054 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHSVq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 17:46:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1597873586; x=1629409586;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=8yNDh/opgTq3MOkRXljbjOdyBIIBWdSe+NfyiDr9uJc=;
  b=hbJllX8Ta7QfGUIFnScaf7sATGV4R0t2YDm5n7VhqIY4+HXJfwYYGDr5
   m6qW+fOU7CgmZ2SGwE6se+PUedGSd7GWFSeYZG8srXaqAiODguE0+Zf8/
   sTi6Jo/QkVUhdT5bDAFURTzr1eNjm50DLVxME3ETpApJei8yJT2lr4KtV
   s=;
X-IronPort-AV: E=Sophos;i="5.76,332,1592870400"; 
   d="scan'208";a="68104990"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 19 Aug 2020 21:46:08 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 86BCBA256F;
        Wed, 19 Aug 2020 21:46:03 +0000 (UTC)
Received: from EX13D01EUA003.ant.amazon.com (10.43.165.113) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 21:46:02 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D01EUA003.ant.amazon.com (10.43.165.113) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 21:46:01 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1497.006;
 Wed, 19 Aug 2020 21:46:00 +0000
From:   "Graf (AWS), Alexander" <graf@amazon.de>
To:     Jim Mattson <jmattson@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] Allow user space to restrict and augment MSR
 emulation
Thread-Topic: [PATCH v4 0/3] Allow user space to restrict and augment MSR
 emulation
Thread-Index: AQHWdnIgDTv6kcTSi0aUujnOWdtoeA==
Date:   Wed, 19 Aug 2020 21:46:00 +0000
Message-ID: <B0FD5408-E2C1-444C-AFCE-7C622EA75F66@amazon.de>
References: <20200803211423.29398-1-graf@amazon.com>,<CALMp9eRHmhmKP21jmBr13n3DvttPg9OQEn5Zn0LxyiKiq2uTkA@mail.gmail.com>
In-Reply-To: <CALMp9eRHmhmKP21jmBr13n3DvttPg9OQEn5Zn0LxyiKiq2uTkA@mail.gmail.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 19.08.2020 um 23:27 schrieb Jim Mattson <jmattson@google.com>:
> =

>> On Mon, Aug 3, 2020 at 2:14 PM Alexander Graf <graf@amazon.com> wrote:
>> =

>> While tying to add support for the MSR_CORE_THREAD_COUNT MSR in KVM,
>> I realized that we were still in a world where user space has no control
>> over what happens with MSR emulation in KVM.
>> =

>> That is bad for multiple reasons. In my case, I wanted to emulate the
>> MSR in user space, because it's a CPU specific register that does not
>> exist on older CPUs and that really only contains informational data that
>> is on the package level, so it's a natural fit for user space to provide
>> it.
>> =

>> However, it is also bad on a platform compatibility level. Currrently,
>> KVM has no way to expose different MSRs based on the selected target CPU
>> type.
>> =

>> This patch set introduces a way for user space to indicate to KVM which
>> MSRs should be handled in kernel space. With that, we can solve part of
>> the platform compatibility story. Or at least we can not handle AMD spec=
ific
>> MSRs on an Intel platform and vice versa.
>> =

>> In addition, it introduces a way for user space to get into the loop
>> when an MSR access would generate a #GP fault, such as when KVM finds an
>> MSR that is not handled by the in-kernel MSR emulation or when the guest
>> is trying to access reserved registers.
>> =

>> In combination with the allow list, the user space trapping allows us
>> to emulate arbitrary MSRs in user space, paving the way for target CPU
>> specific MSR implementations from user space.
> =

> This is somewhat misleading. If you don't modify the MSR permission
> bitmaps, as Aaron has done, you cannot emulate *arbitrary* MSRs in
> userspace. You can only emulate MSRs that kvm is going to intercept.
> Moreover, since the set of intercepted MSRs evolves over time, this
> isn't a stable API.

Yeah, I wrote up a patch today to do the passthrough bitmap masking dynamic=
ally, partly based on Aaron's patches. I have not verified it yet though an=
d will need to clean up SVM as well. I'll see how far I get with it for the=
 rest of the week.

Special MSRs like EFER also irritate me a bit. We can't really trap on them=
 - most code paths just know they're handled in kernel. Maybe I'll add some=
 sanity checks as well...


Alex




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



