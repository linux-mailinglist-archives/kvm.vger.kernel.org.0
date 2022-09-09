Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87ABD5B3AB4
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 16:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiIIOat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 10:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiIIOar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 10:30:47 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07595B2D9E
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 07:30:47 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id 9so1942269plj.11
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 07:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=HHn8jhAtrQiPGUCIVas2II/hNvRlT3vNWLm6EYu5sNo=;
        b=cJhsvrIvCcb/NTJzsx56jD+NRCxQJEZthQwh5R2zWmUeop1rLTeSkhrVWI8pxZD5od
         0CuKvHerL90OO6/MIjGAZC50AZIJ/ZCDlPWji6c0VKwUNJmvY+Y0L0zFyVJManZs6axd
         LSSD6rvRgN/gAiqZ6vDTbLrTUfgW+bfBJise8wBSVoQynCrIHMDaf+kjMVwSajVUKBdI
         pInBMdJ7otDZWfPOK/94cARsU7nPb6dD7q5bNDYnuf1ohhxwovysWlrRA3/PUVBkWmQd
         lyYV5496tvzJoujonNoaoc5sj6IivFnOQAEY8FNRAaCBcdJ6F4OrQC2fvPyaMPSeC36S
         dwTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=HHn8jhAtrQiPGUCIVas2II/hNvRlT3vNWLm6EYu5sNo=;
        b=bVvZ1u5E0fo1AKrR4cypFoQKdu4Ca7KlwYMACnswBAVYAUzkbjih0MDIqhChhqAm57
         dlCdhoPmDReGgB2np8SqqvC/VEg2sM0JBOzmZGloSipLlCstpe01iesh87S1SCatV9b9
         FSEPrmrYU/xdZVjQW3iSKXWDKBzOcGDp0m25om+qai0cisWixLH4DMrTqwZtclAEGgVG
         36/Zb9rHaPrIwJJzY+52WnQ5YNJnQg7iwxG56A3RtIoXq4Lyz/IzjryC9Mi+IW/b7QtW
         jLy+28R6/3sM9jEOrl4vM9OOuXMDmJgdrx512RAhfXuprBu0MQbhJht9Kkdro0/oUo4T
         EHuA==
X-Gm-Message-State: ACgBeo1ju3e3x2EbRut9BiuCXpbdBBAE5LYMerNIZF9d0sx22ohDF7Gs
        I+MiitPYmJGYm9O5rhT3u8Ajug==
X-Google-Smtp-Source: AA6agR64weNYZsHpQoAMv9y4AxCn4e3dGkTfitdim7W+HVS3ebAfVmFf2ZvVeXKLe4+0IDGCIJYrsA==
X-Received: by 2002:a17:902:d502:b0:177:f287:269d with SMTP id b2-20020a170902d50200b00177f287269dmr8464000plg.140.1662733846443;
        Fri, 09 Sep 2022 07:30:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p7-20020a170902e74700b00172709064besm613741plf.46.2022.09.09.07.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 07:30:46 -0700 (PDT)
Date:   Fri, 9 Sep 2022 14:30:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Message-ID: <YxtOEgJhe4EcAJsE@google.com>
References: <20220909104506.738478-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909104506.738478-1-eesposit@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022, Emanuele Giuseppe Esposito wrote:
> KVM is currently capable of receiving a single memslot update through
> the KVM_SET_USER_MEMORY_REGION ioctl.
> The problem arises when we want to atomically perform multiple updates,
> so that readers of memslot active list avoid seeing incomplete states.
> 
> For example, in RHBZ https://bugzilla.redhat.com/show_bug.cgi?id=1979276

I don't have access.  Can you provide a TL;DR?

> we see how non atomic updates cause boot failure, because vcpus
> will se a partial update (old memslot delete, new one not yet created)
> and will crash.

Why not simply pause vCPUs in this scenario?  This is an awful lot of a complexity
to take on for something that appears to be solvable in userspace. 

And if the issue is related to KVM disallowing the toggling of read-only (can't see
the bug), we can likely solve that without needing a new ioctl() that allows
userspace to batch an arbitrary number of updates.
