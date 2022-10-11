Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B97A5FBDDD
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 00:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiJKWZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 18:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJKWZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 18:25:12 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77BFB87A
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:25:10 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id q12-20020a5d834c000000b006bc2cb1994aso4343760ior.15
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZfWbA6aAAbFz71lRfJOTb58ebJNdKFUs+Kea3dTenVQ=;
        b=Nk8QxFFvnC3AMI2e2BnD/DqKKW6m1OerkazE/sN0/u3WIjFTH+AVl4s+3XToNGdnvt
         kf5acfqAjD1RMqiyZCNg9L26agN/Vx/NOr9KqcLVjUAfUn7B+rqECpog4xQ6Sem8+p9m
         OBwAJy9cJvxWPq8nJfNssDeY6eua6IrkTbV5Y5Xd/YjigYt271ZHdPjPrEwby6uob8IP
         FHfg2qz7LpR+VaLm5R57a7N7i3f7gpqqWc2+bGywidoPIYJcEw7E8OK2p3CRhkvXvhrC
         w8WqmJQlI+IyQd6eeEn+tFRxmjRoWvSRkED7OjDZ56i/9ryrgCIJaZAp8v+C+WfP1SDm
         KA2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfWbA6aAAbFz71lRfJOTb58ebJNdKFUs+Kea3dTenVQ=;
        b=vJRhODzI4GCQ3TV71aEmzXwr7RdLGNg7G3n/JICILOZ1f4PBWxEaeuxjwSbAst1gJL
         PoYLSa4Z5kg+2m78dgltxStkGP8QCLBpIzmSM2oUTp8CqhS361oUixwX2h+2F9ZYawsu
         6yzaoQRznbEFczmjMMQv1WtlPCjLeqCPiooHQ4a3ZwtMqAp/YL1OG1/VttFEWAlHgrUc
         sC/YySmAYRCCEnteIf9+ps/aSjPtCy4YHRxhwvpxdRL4Sauv2ZCmHMoTyJOuutXtdKk3
         2qjN/aePcLyEP5e/KcFSJprgXiXnvuiTPjDdhT+Ef926UuUzbf1/Od5tZ+mcMZUWpGTy
         y0bg==
X-Gm-Message-State: ACrzQf191Gp4PMfLme5HvGpAcROBt7RN9zt2sfXpApEMicRPqC/T9Loh
        CUb793gOSafzODYP5oRu5BTRDxY1BZBcgWrVpA==
X-Google-Smtp-Source: AMsMyM5lSbItdbpglTRi2+UQX0tdfaK2Ss4FJrNQ2PDbfEd86LqOJV7progjK81ReDJ8NtlWkia6NyuCq7mtSU7hSg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:1686:b0:35a:2566:6786 with
 SMTP id f6-20020a056638168600b0035a25666786mr14326979jat.180.1665527110221;
 Tue, 11 Oct 2022 15:25:10 -0700 (PDT)
Date:   Tue, 11 Oct 2022 22:25:09 +0000
In-Reply-To: <Y0W0V5hsTkKLg59D@google.com> (message from Sean Christopherson
 on Tue, 11 Oct 2022 18:22:15 +0000)
Mime-Version: 1.0
Message-ID: <gsnt7d162e2i.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 3/3] KVM: selftests: randomize page access order
From:   Colton Lewis <coltonlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Oct 11, 2022, Colton Lewis wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> > Ya, I'm trippling (quadrupling?) down on my suggestion to improve the
>> > APIs.  Users
>> > should not be able to screw up like this, i.e. shouldn't need comments
>> > to warn
>> > readers, and adding another call to get a random number shouldn't  
>> affect
>> > unrelated
>> > code.

>> Previous calls to PRNGs always affect later calls to PRNGs. That's how
>> they work.

> Ya, that's not the type of bugs I'm worried about.

>> This "screw up" would be equally likely with any API because the caller
>> always needs to decide if they should reuse the same random number or  
>> need a
>> new one.

> I disagree, the in/out parameter _requires_ the calling code to store the  
> random
> number in a variable.  Returning the random number allows consuming the  
> number
> without needing an intermediate variable, e.g.

> 	if (random_bool())
> 		<do stuff>

> which makes it easy to avoid an entire class of bugs.

Yes, but it's impossible to do this without hidden global state at the
implementation level. That sacrifices reentrancy and thread-safety.

Maybe that's an acceptable sacrifice, but I'd prefer an obvious pitfall
over a subtle one.
