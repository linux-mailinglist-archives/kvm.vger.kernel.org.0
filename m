Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529FC54F1F5
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 09:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380597AbiFQH2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 03:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbiFQH23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 03:28:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7115C2FFE2
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 00:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655450889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TfwWmf6pndQ83NMYFfQo/NU9rMgkJupydsAN7k3Ml00=;
        b=Sa2eEVAgU5rsAKv6ZNRsIBK9Me5soik7afFvmVfCVSMvq6/5GVIzjI5EBSRjDADxH58I9a
        05iTNOPAF4t4YzNRXZ/oXS+FwB6L8f9MdNeZGbac2qpNyJN8MkTBUsr7BTU/e2sCqRgqk7
        zIZAS7Wfa2aAUqBHhsLUQiMTQFDPz08=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-VxGsnwUmNPK0EiHY8cBKvQ-1; Fri, 17 Jun 2022 03:28:04 -0400
X-MC-Unique: VxGsnwUmNPK0EiHY8cBKvQ-1
Received: by mail-ed1-f70.google.com with SMTP id cy18-20020a0564021c9200b0042dc7b4f36fso2749816edb.4
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 00:28:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TfwWmf6pndQ83NMYFfQo/NU9rMgkJupydsAN7k3Ml00=;
        b=VZSjYKwMxi6ZH7TXE443hcgFX+VGmTdeZ2EWZtcN+UD7OwVbZzERY3k1K/eRzAj3CS
         98YMkOfu2iL0pzG8L3kb9WDmzMHB0AtjWA4jcZGBynFV7ultb+RPqJFIai+l5R3qiIL6
         OQKRQEe2iynxbgz6g6ZQODZkCzRnjZlqlqA6hZjoHBLu340pImu1nYCEcncOxXL77SJZ
         MNir4483V+Zisi4qVY5dcPOTdMgfhRcDas3rCJchDQq6iPURA+OQYaj8uPAtQWGKTkjp
         LI661qQIRpljJOmnoBTJ2TN8sHYToDAYpJ/hvsVJljd3UhOJ4oKbTsHQosx2En/cEHs+
         z1ug==
X-Gm-Message-State: AJIora8MYMsNpbNWiYdQFBJySmDIQovrHYgps4CDC/xSuQwcoejXmu6u
        joRSDmpDzEom3VlDHtA5ZSUsqjtZreYKaa+ZbnC4bKBTiWtRT14L9ha6aeZHNQOyeGtOLg5gRfJ
        gPxeHYY6rb1m8
X-Received: by 2002:aa7:c744:0:b0:42d:f68f:13de with SMTP id c4-20020aa7c744000000b0042df68f13demr10725897eds.294.1655450883308;
        Fri, 17 Jun 2022 00:28:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tKxJhbjxu1gQEDYzXe7aBUKjZhwikhFKlF31X4MiTyfLwkpvElCJYDyCHPMnrvEcQLcQ8oEA==
X-Received: by 2002:aa7:c744:0:b0:42d:f68f:13de with SMTP id c4-20020aa7c744000000b0042df68f13demr10725866eds.294.1655450883047;
        Fri, 17 Jun 2022 00:28:03 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id 7-20020a170906328700b006f3ef214db7sm1810644ejw.29.2022.06.17.00.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 00:28:02 -0700 (PDT)
Date:   Fri, 17 Jun 2022 09:28:00 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "'oliver.upton@linux.dev'" <oliver.upton@linux.dev>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] selftests: KVM: Handle compiler optimizations in ucall
Message-ID: <20220617072800.cvqb4wmafxdi3knq@gator>
References: <3e73cb07968d4c92b797781b037c2d45@AcuMS.aculab.com>
 <20220615185706.1099208-1-rananta@google.com>
 <20220616120232.ctkekviusrozqpru@gator>
 <33ca91aeb5254831a88e187ff8d9a2c2@AcuMS.aculab.com>
 <20220616162557.55bopzfa6glusuh5@gator>
 <7b1040c48bc9b2986798322c336660ab@linux.dev>
 <2ec9ecbfb13d422ab6cda355ff011c9f@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ec9ecbfb13d422ab6cda355ff011c9f@AcuMS.aculab.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 09:54:16PM +0000, David Laight wrote:
> From: oliver.upton@linux.dev
> > Sent: 16 June 2022 19:45
> 
> > 
> > June 16, 2022 11:48 AM, "David Laight" <David.Laight@aculab.com> wrote:
> > > No wonder I was confused.
> > > It's not surprising the compiler optimises it all away.
> > >
> > > It doesn't seem right to be 'abusing' WRITE_ONCE() here.
> > > Just adding barrier() should be enough and much more descriptive.
> > 
> > I had the same thought, although I do not believe barrier() is sufficient
> > on its own. barrier_data() with a pointer to uc passed through
> > is required to keep clang from eliminating the dead store.
> 
> A barrier() (full memory clobber) ought to be stronger than
> the partial one than barrier_data() generates.
> 
> I can't quite decide whether you need a barrier() both sides
> of the 'magic write'.
> Plausibly the compiler could discard the on-stack data
> after the barrier() and before the 'magic write'.
> 
> Certainly putting the 'magic write' inside a asm block
> that has a memory clobber is a more correct solution.

Indeed, since the magic write is actually a guest MMIO write, then
it should be using writeq().

Thanks,
drew

