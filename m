Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F247B5B3A
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 21:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjJBTVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 15:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjJBTVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 15:21:31 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03A1B0
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 12:21:28 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a1df5b7830so1949957b3.1
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 12:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696274488; x=1696879288; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t6T5u8n63H32m/YuZ6al8a5T5YBKCODxao+/slOadeI=;
        b=JXPGgIgj8j3Xjygz/vPx2g+8u1uMbF82N3/mhYyEWpwbmpapRhLvPzJ97TFGF5KltE
         9pyfhggldqoSjmGEtRA1Jk+HpvubScXLHClP/wJw/JIzPT8+rUtDwV0WRoa2PXuPQoCV
         F2AVsRe+y8idstwiE/ZlH278Zufb1Li6el7AZFYvRRuBNXk/D6RYQTZBm0433NuMs85U
         gUPKd1VF0vXYX3yv5fA2Ch8EiC45XZrnEIweiLcHDj1Cxfit+oMFXmj0qpf06RIoZs8s
         VivfZFubWbF+f5pUKu7oQDcxI+YO7Ojd9QQ/ScAGsZ+kgy4uE7BUOlXXKVVU2k7PGuBH
         /UfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696274488; x=1696879288;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t6T5u8n63H32m/YuZ6al8a5T5YBKCODxao+/slOadeI=;
        b=b7bKTe8jzoMBPwthRPms9Eio6aNPQNqoU/sjpaQ2uljHVRbs1463fFXQsCAaYWsOt5
         peLo6kdPC5MdS5ncDO6ROlUx9MbMkfSODLW6RJaCX5ktWneRdEQpB8SzY+FT5zB+T656
         otLUWBfvpI3vxbs7Nbbwoutau/eImK3vKWPqAA1i6IvIHhVVKWyBPvBxctbDuW989l9F
         GRdf8dF+Z90ckMGVUHsOA9zzeUW0cDNDug3009ZGCrYu5vClvO7uxmkhgAJke6yyJzCO
         pzY4sQ5MFEQxuzb0mRZIDt/hjosqEcK460Ef4AaO6fi4kUYmvPwrdSxV7jr0NupApQLa
         U19w==
X-Gm-Message-State: AOJu0Yyxt+LTPV/OU9yoaunDDyVfrUECjMu8bRRuQnilcgOpn0ZEj/BG
        nwDkAGobo/tD0WZrWsY+qDGAQfjR48Q=
X-Google-Smtp-Source: AGHT+IHtmSpMO46KvblpohsWz6O2OSsiMptb0VeaGAhA3nbdHgcxj9vvtm/o9rpvvprle6yfo7JS3Vq54xM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2d12:0:b0:d7e:8dee:7813 with SMTP id
 t18-20020a252d12000000b00d7e8dee7813mr200701ybt.8.1696274487816; Mon, 02 Oct
 2023 12:21:27 -0700 (PDT)
Date:   Mon, 2 Oct 2023 12:21:26 -0700
In-Reply-To: <20231002115723.175344-1-mlevitsk@redhat.com>
Mime-Version: 1.0
References: <20231002115723.175344-1-mlevitsk@redhat.com>
Message-ID: <ZRsYNnYEEaY1gMo5@google.com>
Subject: Re: [PATCH v3 0/4] Allow AVIC's IPI virtualization to be optional
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023, Maxim Levitsky wrote:
> Hi!
> 
> This patch allows AVIC's ICR emulation to be optional and thus allows
> to workaround AVIC's errata #1235 by disabling this portion of the feature.
> 
> This is v3 of my patch series 'AVIC bugfixes and workarounds' including
> review feedback.

Please respond to my idea[*] instead of sending more patches.  I'm not opposed to
a different approach, but we need to have an actual discussion around the pros and
cons, and hopefully come to an agreement.  This cover letter doesn't even acknowledge
that there is an alternative proposal, let alone justify why the vcpu->loaded
approach was taken.

[*] https://lore.kernel.org/all/ZRYxPNeq1rnp-M0f@google.com
