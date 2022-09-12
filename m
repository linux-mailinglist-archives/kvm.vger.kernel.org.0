Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BE35B6188
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 21:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiILTOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 15:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiILTOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 15:14:08 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1830A3E769
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 12:14:08 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33d9f6f4656so83222077b3.21
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 12:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date;
        bh=Fno6gIXBiBlAH78g3UuzD4cVFpS7y5j/e4Outfn0aJw=;
        b=A+Wr2BVE3Be52H9Q7cBW1ynKhNTnYPPh3h0uRJT0qVb79zteo13tOc7PteSHcEin/E
         34eP3nnnJrLW+w9v6ANVLN74a4fVu4Ugp8a2H/pCGf6/X/1UxtIxAlYEE3zq/Gfvcxl4
         UXrnV6PJ1L+bw6w8QX6Ur/K18/llSF5yZRaSr91Yrfb0pDUp0wn9lTI0wd+zNSGt7Xil
         0o0eOMu/Ek8qjvDjFDXpGBffrqteXSazWsgwJAIqo3KvwWYspkCQMjjn13/QpYf5z6Yb
         k7SAIM4HZjRFODbeh7v8MeLqMScN4OQQ2WMcFi13O8bE6P0MZrhFKlQz6yrCatMCU8ML
         exFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Fno6gIXBiBlAH78g3UuzD4cVFpS7y5j/e4Outfn0aJw=;
        b=vIopLoCwUSxu2rG1jhfNCxI1rPZzqo8kmb/38ktQgfJwf+b74LORRxYUdQyPPLi0d2
         +NNwF9yS/SSKPBUpi13dcToeOLwon80id7SkJ2lroDnn8rdeMQ/3k3XkskXxD1+AB8Qp
         v8tSCOjgTgpGpDjpo15XbCPAEWbcbMORoWhPtb9QFNWC7nLgtHK6o6dUO60TMv9GhNI5
         vjhj6LUHLebWp30tcGLYCFBIN/CxXUFIAQeetoTvRkzVQ/fPHEfyjCZS4y2y+D8YYdAf
         Obolt/L/yOkAYvxyQO0XrY+C/LySJymv5Iy6x8IMslHm6kPHglrWwwT8ZDJcCaRGdHYl
         slTg==
X-Gm-Message-State: ACgBeo1B8tZEiqSXJtQs2zTZ1IGVENumnAvfBdiPgXER+juuWaBo+42y
        T8lYl62Z2wKCeSb8QE1QJgA44riZd/0siro5/g==
X-Google-Smtp-Source: AA6agR6W07os6JwvNrVwkYWqbS2goC8qQ1rgcYTvkHlT42yK0XJcojX3F7uc+aHGRtbCaiveZNWgl5FzOSLaaJOEcQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:c241:0:b0:336:f5a6:2e36 with SMTP
 id t1-20020a81c241000000b00336f5a62e36mr24202612ywg.123.1663010047230; Mon,
 12 Sep 2022 12:14:07 -0700 (PDT)
Date:   Mon, 12 Sep 2022 19:14:06 +0000
In-Reply-To: <Yxt2JHYiE6A3pTbE@google.com> (message from David Matlack on Fri,
 9 Sep 2022 10:21:40 -0700)
Mime-Version: 1.0
Message-ID: <gsntfsgwpfr5.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 2/3] KVM: selftests: randomize which pages are written
 vs read
From:   Colton Lewis <coltonlewis@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Matlack <dmatlack@google.com> writes:

> On Fri, Sep 09, 2022 at 12:42:59PM +0000, Colton Lewis wrote:
>> @@ -248,6 +247,7 @@ static void run_test(enum vm_guest_mode mode, void  
>> *arg)
>>   	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
>>   		vcpu_last_completed_iteration[vcpu_id] = -1;

>> +	perf_test_set_write_percent(vm, 100);

> This is a very important line of code and it's not very clear why it's
> here to a random reader. Please a comment here so someone doesn't have
> to go through the same confusion/debugging we went through to figure out
> why this is necessary. e.g.

>          /*
>           * Use 100% writes during the population phase to ensure all
>           * memory is actually populated and not just mapped to the zero
>           * page. The prevents expensive copy-on-write faults from
>           * occurring during the dirty memory iterations below, which
>           * would pollute the performance results.
>           */
>          perf_test_set_write_percent(vm, 100);

> Aside from that,

> Reviewed-by: David Matlack <dmatlack@google.com>


Will do.
