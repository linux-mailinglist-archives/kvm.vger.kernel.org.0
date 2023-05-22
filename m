Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5F970BCE5
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 14:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbjEVMFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 08:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbjEVMFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 08:05:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C79099
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 05:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684757073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zqyo5rJ8j59rDGA94pvvhHY82P2NKop29y8JPKXIx9A=;
        b=TvpbmVS4Mct2+DAKHryrA0yuoP3s717bYPlPH220zIrNo9iO9hCY/TuByBvEHZ+6dX1od1
        sIOMe9LHzhyfJ9SZbwViEw7LEJazIfSDiI34yRK9WkSJkSqKbhEmh6mWPyedQAZxzwOONN
        Kvj66H9/bw1+ghBka7XnpVsHWtDWiuw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-5Qq3rbTSNVqd0y0Tzgym1w-1; Mon, 22 May 2023 08:04:30 -0400
X-MC-Unique: 5Qq3rbTSNVqd0y0Tzgym1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0ADF28007D9;
        Mon, 22 May 2023 12:04:30 +0000 (UTC)
Received: from localhost (unknown [10.39.194.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB3C2C58DC1;
        Mon, 22 May 2023 12:04:29 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Andrea Bolognani <abologna@redhat.com>
Subject: Re: [PATCH v7 0/1] arm: enable MTE for QEMU + kvm
In-Reply-To: <20230428095533.21747-1-cohuck@redhat.com>
Organization: Red Hat GmbH
References: <20230428095533.21747-1-cohuck@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 22 May 2023 14:04:28 +0200
Message-ID: <87v8gkzi5v.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 28 2023, Cornelia Huck <cohuck@redhat.com> wrote:

> Another open problem is mte vs mte3: tcg emulates mte3, kvm gives the guest
> whatever the host supports. Without migration support, this is not too much
> of a problem yet, but for compatibility handling, we'll need a way to keep
> QEMU from handing out mte3 for guests that might be migrated to a mte3-less
> host. We could tack this unto the mte property (specifying the version or
> max supported), or we could handle this via cpu properties if we go with
> handling compatibility via cpu models (sorting this out for kvm is probably
> going to be interesting in general.) In any case, I think we'll need a way
> to inform kvm of it.

Before I start to figure out the initialization breakage, I think it
might be worth pointing to this open issue again. As Andrea mentioned in
https://listman.redhat.com/archives/libvir-list/2023-May/239926.html,
libvirt wants to provide a stable guest ABI, not only in the context of
migration compatibility (which we can handwave away via the migration
blocker.)

The part I'm mostly missing right now is how to tell KVM to not present
mte3 to a guest while running on a mte3 capable host (i.e. the KVM
interface for that; it's more a case of "we don't have it right now",
though.) I'd expect it to be on the cpu level, rather than on the vm
level, but it's not there yet; we also probably want something that's
not fighting whatever tcg (or other accels) end up doing.

I see several options here:
- Continue to ignore mte3 and its implications for now. The big risk is
  that someone might end up implementing support for MTE in libvirt again,
  with the same stable guest ABI issues as for this version.
- Add a "version" qualifier to the mte machine prop (probably with
  semantics similar to the gic stuff), with the default working with tcg
  as it does right now (i.e. defaulting to mte3). KVM would only support
  "no mte" or "same as host" (with no stable guest ABI guarantees) for
  now. I'm not sure how hairy this might get if we end up with a per-cpu
  configuration of mte (and other features) with kvm.
- Add cpu properties for mte and mte3. I think we've been there before
  :) It would likely match any KVM infrastructure well, but we gain
  interactions with the machine property. Also, there's a lot in the
  whole CPU model area that need proper figuring out first... if we go
  that route, we won't be able to add MTE support with KVM anytime soon,
  I fear.

The second option might be the most promising, except for potential
future headaches; but a lot depends on where we want to be going with
cpu models for KVM in general.

