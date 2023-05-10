Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F916FE679
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 23:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjEJVvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 17:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjEJVvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 17:51:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B5249C0
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 14:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683755458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bhfyLDZL2Wy4NLwhyKEfa0N1V5Lq+EA3KLNXjKgrsmI=;
        b=W+j3B8rVNhZVOSGdVTT4eVGOlcOO52pn+oSNO8qpp7FYP+V7NdIrLQHkoxqsIJVpz052Kr
        pIwSB1+rkFpRuJdnPjlDb4BAvx/7dhtSb5bPbTLpRM9Bc4UA+zKld0JJu9suC4zwm+lTZX
        E+FXOqrJiyd5DZQ74J/2ZpqL52Zprm8=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-dFAd1P1yNtqgk4nruH7xwQ-1; Wed, 10 May 2023 17:50:57 -0400
X-MC-Unique: dFAd1P1yNtqgk4nruH7xwQ-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-51b5133ad4dso757459a12.0
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 14:50:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683755451; x=1686347451;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bhfyLDZL2Wy4NLwhyKEfa0N1V5Lq+EA3KLNXjKgrsmI=;
        b=KHKjYQlX4SRTz0WIweddjfkinZEk968Vor9miRzwx67aqexQDuQtreV27emSuDcqJ0
         dK3yFRCNESyz6sCkU5BpQyc7iEM0Ndr/yc0+DYX5hI8IfMUHzYQf8YbwM/z9npbU9PNi
         BeSYJalvBoJ3oq/fIoiXAKmDYrN1uEkFcw5b7SY+kyMOJt2l2SaEcTGh9dXexw01Firy
         Oovc6n1gJtmx6HftOqaIdZuaM1puoOQdqNYhTBAkXCq14rEB0zcv7PkupqIYiZVyIpfh
         9efC79vgtLrcKtBo7qj9N8g9fe6QME14xOdpKPCqZLeaFYR1jYrfm6VR+ZYQkpMbizmB
         R3Uw==
X-Gm-Message-State: AC+VfDxe4cJSkD1tOYIQc5XSQfjZyNYbKudt+uaREV/d+YF2FUThtTkj
        fdEX+++N+UaHAR8aciCcwbN6FC8aokeCj9WcxpGoXwxi8NZgPZZGJiEhf/nadMvutvTeOorWTqU
        7NbD5LZJy+uwV
X-Received: by 2002:a17:90b:1b0c:b0:250:d8e1:d326 with SMTP id nu12-20020a17090b1b0c00b00250d8e1d326mr2953761pjb.0.1683755451084;
        Wed, 10 May 2023 14:50:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4vELi5N4iVjVE7aGE9xoE0xspdoTHNdsD0TLrBv982RL4blARiCA+cRxw/XcIAKdEaDuo4yw==
X-Received: by 2002:a17:90b:1b0c:b0:250:d8e1:d326 with SMTP id nu12-20020a17090b1b0c00b00250d8e1d326mr2953745pjb.0.1683755450617;
        Wed, 10 May 2023 14:50:50 -0700 (PDT)
Received: from x1n ([2001:4958:15a0:30:ea6e:cae6:2dab:2897])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090a9f0c00b0024e05b7ba8bsm17611209pjp.25.2023.05.10.14.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 14:50:49 -0700 (PDT)
Date:   Wed, 10 May 2023 14:50:48 -0700
From:   Peter Xu <peterx@redhat.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZFwRuCuYYMtuUFFA@x1n>
References: <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n>
 <ZFLRpEV09lrpJqua@x1n>
 <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
 <ZFQC5TZ9tVSvxFWt@x1n>
 <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n>
 <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Anish,

On Tue, May 09, 2023 at 01:52:05PM -0700, Anish Moorthy wrote:
> On Sun, May 7, 2023 at 6:23 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > I explained why I think it could be useful to test this in my reply to
> > Nadav, do you think it makes sense to you?
> 
> Ah, I actually missed your reply to Nadav: didn't realize you had sent
> *two* emails.
> 
> > While OTOH if multi-uffd can scale well, then there's a chance of
> > general solution as long as we can remove the single-queue
> > contention over the whole guest mem.
> 
> I don't quite understand your statement here: if we pursue multi-uffd,
> then it seems to me that by definition we've removed the single
> queue(s) for all of guest memory, and thus the associated contention.
> And we'd still have the issue of multiple vCPUs contending for a
> single UFFD.

Yes as I mentioned it's purely what I was curious and it also shows the
best result we can have if we go a more generic solution; it doesn't really
solve the issue immediately.

> 
> But I do share some of your curiosity about multi-uffd performance,
> especially since some of my earlier numbers indicated that multi-uffd
> doesn't scale linearly, even when each vCPU corresponds to a single
> UFFD.
> 
> So, I grabbed some more profiles for 32 and 64 vcpus using the following command
> ./demand_paging_test -b 512M -u MINOR -s shmem -v <n> -r 1 -c <1,...,n>
> 
> The 32-vcpu config achieves a per-vcpu paging rate of 8.8k. That rate
> goes down to 3.9k (!) with 64 vCPUs. I don't immediately see the issue
> from the traces, but safe to say it's definitely not scaling. Since I
> applied your fixes from earlier, the prefaulting isn't being counted
> against the demand paging rate either.
> 
> 32-vcpu profile:
> https://drive.google.com/file/d/19ZZDxZArhSsbW_5u5VcmLT48osHlO9TG/view?usp=drivesdk
> 64-vcpu profile:
> https://drive.google.com/file/d/1dyLOLVHRNdkUoFFr7gxqtoSZGn1_GqmS/view?usp=drivesdk
> 
> Do let me know if you need svg files instead and I'll try and figure that out.

Thanks for trying all these out, and sorry if I caused confusion in my
reply.

What I wanted to do is to understand whether there's still chance to
provide a generic solution.  I don't know why you have had a bunch of pmu
stack showing in the graph, perhaps you forgot to disable some of the perf
events when doing the test?  Let me know if you figure out why it happened
like that (so far I didn't see), but I feel guilty to keep overloading you
with such questions.

The major problem I had with this series is it's definitely not a clean
approach.  Say, even if you'll all rely on userapp you'll still need to
rely on userfaultfd for kernel traps on corner cases or it just won't work.
IIUC that's also the concern from Nadav.

But I also agree it seems to resolve every bottleneck in the kernel no
matter whether it's in scheduler or vcpu loading. After all you throw
everything into userspace.. :)

Considering that most of the changes are for -EFAULT traps and the 2nd part
change is very self contained and maintainable, no objection here to have
it.  I'll leave that to the maintainers to decide.

Thanks,

-- 
Peter Xu

