Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70ED568F127
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 15:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbjBHOtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 09:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjBHOtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 09:49:03 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4784ABD3
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 06:48:56 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id g13so14699556ple.10
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 06:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FFBEpHVyO7uaEXohEkZMXZFRiWaMnYer0SJSyNE2OQo=;
        b=hMOdPggyeGwA8nIQGyI3lk8r6madEiHE1tfQILTzxCiy1S7kUMUVaOhyHsVp06goap
         xu3OTi4hYwWjZUQvyadbZEP3tCnJkNTADf3pcXG10U3Bg6jMDXlkGMHqGqVwwoskxqZD
         tawgXU9UGZ0cqOWkVEH3kiqEmuD8kla7MXmbwv9628VLynYNqSAJDTBK375CkOiEJXju
         sdjTjOye77/aoufgQyQHZ+ZVVxHUrUPnqxX8duSqU938FVPItqp/CwL5e/cVkwmZk/MT
         owWkEI8ueZFmAdHcW1jyYhtr52ME/ScfkE4iQ6i34E9szGx+u+4lnFOthBjNQywWGZ1M
         jM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FFBEpHVyO7uaEXohEkZMXZFRiWaMnYer0SJSyNE2OQo=;
        b=QKG5lmghZnPB+Aw9kwKLUjHYbjCeerWFL9awEgyU0uDjGl8BBAq24/OGcDZjRFFiaz
         biFBuw3wplw2mFiKL8FsKPxHcP+NkdGcB9rFa2etiTgd+FJs3SB4aLKTOjYJd/kW5WHT
         fr3eG9H2oLEXzNJtVX1o9mBPjLeNQBEIvykAnvgQse29Q4ylOynmshrEacUQsBrT9U1N
         d4E2BCJptEZO1x9XHu2WK09lZrwNdouiMjYCMfzI5dyQIrvMS5+bRoYNL56me1LehN4N
         GzqtIf2BzlaA6TW9KrNbkBAUzuH6Jx9U3g+6Y5b+E3FaPsAGEIvG7CgJ+IWLsaW5WaTq
         gjdQ==
X-Gm-Message-State: AO0yUKVtk2Y/fSqvMrIpiJkdhfeMvJtcX+5EV+NrbjTQhZQ+mgczfATp
        Y9HEuZeszRmrRG8e2C/VA6IO4w==
X-Google-Smtp-Source: AK7set+p35lGTvN8xsFLL4fqhMTQyitTRsLEsTPZ+gHzxMmxq7tY2+fV/RaR4t2O3sr/KKtToUrGwQ==
X-Received: by 2002:a17:902:e74e:b0:198:af50:e4e9 with SMTP id p14-20020a170902e74e00b00198af50e4e9mr240153plf.15.1675867735657;
        Wed, 08 Feb 2023 06:48:55 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l2-20020a170902ec0200b00199019e247csm7680677pld.207.2023.02.08.06.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 06:48:55 -0800 (PST)
Date:   Wed, 8 Feb 2023 14:48:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v2 3/6] KVM: x86: Remove the KVM_GET_NR_MMU_PAGES ioctl
Message-ID: <Y+O2U/x7zHzeVV6e@google.com>
References: <20230208140105.655814-1-thuth@redhat.com>
 <20230208140105.655814-4-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208140105.655814-4-thuth@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 08, 2023, Thomas Huth wrote:
> The KVM_GET_NR_MMU_PAGES ioctl is quite questionable on 64-bit hosts
> since it fails to return the full 64 bits of the value that can be
> set with the corresponding KVM_SET_NR_MMU_PAGES call. Its "long" return
> value is truncated into an "int" in the kvm_arch_vm_ioctl() function.
> 
> Since this ioctl also never has been used by userspace applications
> (QEMU, Google's internal VMM, kvmtool and CrosVM have been checked),
> it's likely the best if we remove this badly designed ioctl before
> anybody really tries to use it.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
