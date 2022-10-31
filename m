Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7F161404A
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 22:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJaV7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 17:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiJaV7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 17:59:42 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031AA13F22
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 14:59:42 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id j12so11933415plj.5
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 14:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VMa6OA0v7jfout5U9TdSDd4S5HfDdj3m6w2lBNERhDI=;
        b=ZAfw+ZvowvbWkb/PqgPQNuXTURpLM7nQO9LAFmEsIVej48e/VL62fU76WAfx4wBBKX
         M/nqBak0k9yQlxUdnpK2OLG0LnneV9SVDNDiddvP9uYXGfio3xy1aJRhDppmDJmWLip1
         ohCEeXzcFovcQ5ssWxMLvMEMDtmfLwKh+escnFqmmuIkb7gd2jv3rOHdSwlGcU3MX/mt
         2W1XtmGsz5mokaaJj3fIQ9N8LMtyfHwD+pwQ7ct5l6sKZSJiHVUMoO3VZ2SG6vBdGb5V
         T+0AICXx9W3ac7xCWXE/fRjMtZAtvntNf6/817DLkqzu/MerVoEyL6pYsbE2fyU7MpqV
         MeQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMa6OA0v7jfout5U9TdSDd4S5HfDdj3m6w2lBNERhDI=;
        b=SqXQugYqh6QZ1atj0d531+xjf7wg/cUL1eBVSBJ8+FYXhJ2vOJHEYbXfKx6f6lySB6
         XBPifJTssiLegzaMN/bFqftM37zNb7eOeL6NK3y/f0LT87OFXX6pG31FFp0FMFzitEii
         FR3g3KuelNIA4SJYnOApUKhrCD6a0XVm18nCm6cJ1wyqPdjQxV9hk54Qf1LeqrHU1Jno
         7XTC0dSFSLl7Bf0ITgZKruDz17nnYINOUiWnNg+MBbigw5rI/FFOfEgmZhJgNYQm3W09
         hzebdh+XxuV81lumhyVYSqNrSKa2VZemi85criMN6wTtk9aYw1TY8ZjPuDBP9HntUINY
         L2vQ==
X-Gm-Message-State: ACrzQf3sUEOcugwdLHKKAaP339qGZMFFDYwcwJgiMvvZfJISc2LNC4bP
        JEU/B6+EJOJd0iUxoOLjNCDXcg==
X-Google-Smtp-Source: AMsMyM49MTGeZvhCrvRWx1zEZCy8qCrVXikxXPY6oWqlionUqvxKkIhtQ9QAbJ5amLX8TPOZWnZRLA==
X-Received: by 2002:a17:902:f68c:b0:186:dfca:a444 with SMTP id l12-20020a170902f68c00b00186dfcaa444mr16046636plg.151.1667253581381;
        Mon, 31 Oct 2022 14:59:41 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709027b9600b0017f7628cbddsm4908678pll.30.2022.10.31.14.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 14:59:40 -0700 (PDT)
Date:   Mon, 31 Oct 2022 21:59:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Jayaramappa, Srilakshmi" <sjayaram@akamai.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "suleiman@google.com" <suleiman@google.com>,
        "Hunt, Joshua" <johunt@akamai.com>
Subject: Re: KVM: x86: snapshotted TSC frequency causing time drifts in vms
Message-ID: <Y2BFSZ1ExLiOIIi9@google.com>
References: <a49dfacc8a99424a94993171ba2955a0@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a49dfacc8a99424a94993171ba2955a0@akamai.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022, Jayaramappa, Srilakshmi wrote:
> Hi,
> 
> We were recently notified of significant time drift on some of our virtual
> machines. Upon investigation it was found that the jumps in time were larger
> than ntp was able to gracefully correct. After further probing we discovered
> that the affected vms booted with tsc frequency equal to the early tsc
> frequency of the host and not the calibrated frequency.
> 
> There were two variables that cached tsc_khz - cpu_tsc_khz and max_tsc_khz.
> Caching max_tsc_khz would cause further scaling of the user_tsc_khz when the
> vcpu is created after the host tsc calibrabration and kvm is loaded before
> calibration. But it appears that Sean's commit "KVM: x86: Don't snapshot
> "max" TSC if host TSC is constant" would fix that issue. [1]
> 
> The cached cpu_tsc_khz is used in 1. get_kvmclock_ns() which incorrectly sets
> the factors hv_clock.tsc_to_system_mul and hv_clock.shift that estimate
> passage of time.  2. kvm_guest_time_update()
> 
> We came across Anton Romanov's patch "KVM: x86: Use current rather than
> snapshotted TSC frequency if it is constant" [2] that seems to address the
> cached cpu_tsc_khz  case. The patch description says "the race can be hit if
> and only if userspace is able to create a VM before TSC refinement
> completes". We think as long as the kvm module is loaded before the host tsc
> calibration happens the vms can be created anytime and they will have the
> problem (confirmed this by shutting down an affected vm and relaunching it -
> it continued to experience time issues). VMs need not be created before tsc
> refinement.
> 
> Even if kvm module loads and vcpu is created before the host tsc refinement
> and have incorrect time estimation on the vm until the tsc refinement, the
> patches referenced here would subsequently provide the correct factors to
> determine time. And any error in time in that small interval can be corrected
> by ntp if it is running on the guest. If there was no ntp, the error would
> probably be negligible and would not accumulate.
> 
> There doesn't seem to be any response on the v6 of Anton's patch. I wanted to
> ask if there is further changes in progress or if it is all set to be merged?

Drat, it slipped through the cracks.

Paolo, can you pick up the below patch?  Oobviously assuming you don't spy any
problems.

It has a superficial conflict with commit 938c8745bcf2 ("KVM: x86: Introduce
"struct kvm_caps" to track misc caps/settings"), but otherwise applies cleanly.

> [2] https://lore.kernel.org/all/20220608183525.1143682-1-romanton@google.com/
