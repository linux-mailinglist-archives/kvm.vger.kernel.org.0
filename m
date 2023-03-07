Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74396AE814
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 18:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCGRM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 12:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjCGRMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 12:12:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4067599659
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 09:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678208742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OMp5CS3WyQQRgGmWIRtAf3rhbAWIQqY19k/zVdZ/qyI=;
        b=f6ZE8F6hOd/+IpA0MjuZarbTvO/9q/8qiY1KGk+IoMd1zbMaqmJvK1IUFdk3gg3d/T1kVR
        +YPxztrqBxp3yI1GCXuwDFM9doPYnFjx1DXXZgJwueQ1BRgJELDkVfXXjQucqmtsdC4CsE
        DC5cfvc/iEoxaIXrQZtqITXMdYCkLW8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-30gskanPONSc-JvUP8Y7DQ-1; Tue, 07 Mar 2023 12:05:40 -0500
X-MC-Unique: 30gskanPONSc-JvUP8Y7DQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C77A1100F90F;
        Tue,  7 Mar 2023 17:05:37 +0000 (UTC)
Received: from localhost (unknown [10.39.193.188])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80E4AC15BA0;
        Tue,  7 Mar 2023 17:05:37 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Andrea Bolognani <abologna@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 1/2] arm/kvm: add support for MTE
In-Reply-To: <CAFEAcA-Q6hzgW-B52X5XEtZsvBX64qSr9wSKizLVYu58mPdXKw@mail.gmail.com>
Organization: Red Hat GmbH
References: <20230228150216.77912-1-cohuck@redhat.com>
 <20230228150216.77912-2-cohuck@redhat.com>
 <CABJz62OHjrq_V1QD4g4azzLm812EJapPEja81optr8o7jpnaHQ@mail.gmail.com>
 <874jr4dbcr.fsf@redhat.com>
 <CABJz62MQH2U1QM26PcC3F1cy7t=53_mxkgViLKjcUMVmi29w+Q@mail.gmail.com>
 <87sfeoblsa.fsf@redhat.com>
 <CAFEAcA8z9mS55oBySDYA6PHB=qcRQRH1Aa4WJidG8B=n+6CyEQ@mail.gmail.com>
 <87cz5rmdlg.fsf@redhat.com>
 <CAFEAcA-Q6hzgW-B52X5XEtZsvBX64qSr9wSKizLVYu58mPdXKw@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 07 Mar 2023 18:05:36 +0100
Message-ID: <877cvsh4pr.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 02 2023, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Thu, 2 Mar 2023 at 14:29, Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> On Thu, Mar 02 2023, Peter Maydell <peter.maydell@linaro.org> wrote:
>> > I think having MTE in the specific case of KVM behave differently
>> > to how we've done all these existing properties and how we've
>> > done MTE for TCG would be confusing. The simplest thing is to just
>> > follow the existing UI for TCG MTE.
>> >
>> > The underlying reason for this is that MTE in general is not a feature
>> > only of the CPU, but also of the whole system design. It happens
>> > that KVM gives us tagged RAM "for free" but that's an oddity
>> > of the KVM implementation -- in real hardware there needs to
>> > be system level support for tagging.
>>
>> Hm... the Linux kernel actually seems to consider MTE to be a cpu
>> feature (at least, it lists it in the cpu features).
>>
>> So, is your suggestion to use the 'mte' prop of the virt machine to mean
>> "enable all prereqs for MTE, i.e. allocate tag memory for TCG and enable
>> MTE in the kernel for KVM"? For TCG, we'll get MTE for the max cpu
>> model; for KVM, we'd get MTE for host (== max), but I'm wondering what
>> should happen if we get named cpu models and the user specifies one
>> where we won't have MTE (i.e. some pre-8.5 one)?
>
> I think we can probably cross that bridge when we get to it,
> but I imagine the semantics would be "cortex-foo plus MTE"
> (in the same way that -cpu cortex-foo,+x,-y can add and
> subtract features from a baseline).

While implementing this, I realized another thing that I had managed to
miss before: With tcg, we'll start out with mte=3 and downgrade to mte=0
if we don't have tag memory. With kvm, enabling mte can at most give us
the mte version that the host exposes, so setting mte=on for the machine
might give as well mte=2 in the end [which I still need to implement by
querying the host support, I guess.] This means we have slightly
different semantics for tcg and kvm; but more importantly, we need to
implement something for compat handling.

The Linux kernel distinguishes between 'mte' and 'mte3', and KVM exposes
the MTE cap if mte >=2. Do we need two props as well? If yes, what about
tcg?

