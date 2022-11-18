Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0E862FBA4
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 18:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiKRRbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 12:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242338AbiKRRap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 12:30:45 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1678C7BF
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 09:30:43 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id k15so5522394pfg.2
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 09:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SwkAtffLjdQduV0MKvvRKOL3cpkGGuwyJ11Kt3f536U=;
        b=k0IfwVeBNN3NoM3Fb0QAW+W7FSnbJCNXNofOuSfFuUmkul6Mg4Ah8mW/y+pEjQFgSB
         Toy6EFRUl43yW466qTgvz3DFw5di+Of0tO7BJQYg1cX0qpK5zYLpoOslvcAfogVe0SAU
         2yrpFgXTMKGt0Lf8HOh5bZ2V9Uo0LfARjDUR33zkS//23UPKHF+4nyao7HgtPZs27gW/
         dkl/foMD8Zlz5WrOCNIsye3pq1ng65hEnE3UW+p6Xlyn+PJ0IAP9cO0Sr2/57G9GV2cr
         OzfoaSwRYabGbCUluXE5GAw9ncHAIYUnia9ixZF88X+BBpFTA7kiIZc8T0kS7kxqRPhZ
         NRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SwkAtffLjdQduV0MKvvRKOL3cpkGGuwyJ11Kt3f536U=;
        b=hSVLZPS/A5oaYGpl2mbVIr9l+YAm6TdB6TM+MNCRWTJbyJ5X8uXai92GWSdNGg9H/z
         g90tilrHEB/+UzhGsLgzEJm64vINRmq2p8nZ76K2edKuUU6L3dqL4DM8rgar8NjDIp6S
         mgiTk7nko1gxXgNsdM6DRz4eFCP2gTEv9woPLfYMFdzDIggPGGROll6GZ++SJhum1PjN
         NDvxtHFlsprUXz9vxY5zJf2L6tIHkPesoZPCgNBMmwhyfuepOPCFsRwDT1xmAvMKYcBD
         C9yrk/pFhmT5QXEInJROsgw8R13iJZGsngdF2JT2mg1SR91cLeD4KcL8kTifTGYrj2df
         Db/g==
X-Gm-Message-State: ANoB5pmD5GTBk+vEapEnCmWnB8DmhctSRMpEM1Bqg8yTCh6RyRKxw/F5
        4HnP8wKH8j7FWgQGUdRk5U1aqw==
X-Google-Smtp-Source: AA0mqf62SPQhcqhP/08SoNMgiQllQeFcDcY6FpBzOIimmtQ8t5VnkcCX4/0mpQ2mBPwN+K6QJu4/Uw==
X-Received: by 2002:a63:f152:0:b0:476:a612:abd7 with SMTP id o18-20020a63f152000000b00476a612abd7mr7395973pgk.241.1668792642477;
        Fri, 18 Nov 2022 09:30:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p16-20020a170902e75000b00176dc67df44sm3978038plf.132.2022.11.18.09.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 09:30:42 -0800 (PST)
Date:   Fri, 18 Nov 2022 17:30:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: account allocation in generic version of
 kvm_arch_alloc_vm()
Message-ID: <Y3fBPl1YJHuQwLG+@google.com>
References: <Y3aay2u2KQgiR0un@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3aay2u2KQgiR0un@p183>
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

Nit, please capitalize "KVM:" in the shortlog.

On Thu, Nov 17, 2022, Alexey Dobriyan wrote:
> This is persistent allocation and arch-specific versions account it.

The justification isn't that "x86 does it", e.g. the x86 code could be wrong.
The justification is that the allocation is tied to the current task as opposed
to being a KVM-wide allocation.  It's worth calling out that x86 already accounts
its allocation, but that should be a footnote, not the reason for converting the
generic allocation.

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---

With a reworded changelog,

Reviewed-by: Sean Christopherson <seanjc@google.com>
