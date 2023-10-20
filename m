Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B067D1960
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 00:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjJTW4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 18:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjJTW4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 18:56:37 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB7991
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:56:35 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7be940fe1so20199137b3.2
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697842595; x=1698447395; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dNY4ZF2n8N6ah98yjA9kQ3X3A+H1xwxHdfH72nN4Guw=;
        b=F9Oy77UIUgGjzE5W9CQizQXuktkOPXYnJDGUNgIoR4/SsXktgzXiL+858DhY+ALhzo
         7J9iUUhNJ0pEB96e4m1IFhdcGQ0RNEJ2cuAM5yUevr6wNEDO0IUxypOEpi0AYpTCYB4F
         t1/PD3sff3r8Zd4R4Jnb3kgKVJi6Uw7/Z2tHhNj0cILTBKurt7ZdoPYo3QkUyUuEuIXu
         PoasIMqT7SIUIzaqsttJeNAFpP56tiqGUIhxa38aeU/4KIIMrMIYowrx+Svbxiu1pRfM
         j0SRjPLkHcH1eJnpOWD1AhcoZkHHKnxTZLcumoYPyagbe//21UtJw0NyWQXMwA0jnnVb
         TafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697842595; x=1698447395;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dNY4ZF2n8N6ah98yjA9kQ3X3A+H1xwxHdfH72nN4Guw=;
        b=u1XOvkh2tpUs0/sfavVXgpe42rS4TTBa1ukodzcmKc+sTmNCB95J9jIWrsZovCQmcl
         blsVRoF3zMJsaQ/FDlc91it9DvAPXlj4KNdg0sECcC2rQcZ76FtB7MQri18CdyVx+TlM
         2PwUdAIfzG3ve0xN5Zo8o+OU506GdXtXVlFDYh8424dt2puqzR0ePMqZmqlhA7AQOUyH
         B8Eo65Bed1IFO4ghclugPQ6efKRxLc5w63gTROXn5PHVq17ZS5aG+g5Bz8z5uUYjbHZg
         7ryiJF8czs5m7oUICWNmTz0Drc3iHj8G6gkFnbfKK+l+Qjsi2zogzkdgoUZoYIDFmnz+
         vm1A==
X-Gm-Message-State: AOJu0YwOd7/Ki0+NRuIXykOvr6skn25hKNjkcpdhVMY/6v1NktmCgkjw
        e0EUao53C/Dkr7IEDZq/3C400pl3fNg=
X-Google-Smtp-Source: AGHT+IET9c6hZPBVLliJvCmhk1QBWwviBGvU9pPCX4bujwtZP6q2g6GvqykQWyc1v+/c7/p+Iw++DaFPAko=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:928e:0:b0:59b:f493:813d with SMTP id
 j136-20020a81928e000000b0059bf493813dmr75633ywg.1.1697842594914; Fri, 20 Oct
 2023 15:56:34 -0700 (PDT)
Date:   Fri, 20 Oct 2023 15:56:19 -0700
In-Reply-To: <20231001213637.76686-1-dongli.zhang@oracle.com>
Mime-Version: 1.0
References: <20231001213637.76686-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <169766221626.1905946.10575066014082098174.b4-ty@google.com>
Subject: Re: [PATCH 1/1] KVM: x86: remove always-false condition in kvmclock_sync_fn
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, Dongli Zhang <dongli.zhang@oracle.com>
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 01 Oct 2023 14:36:37 -0700, Dongli Zhang wrote:
> The 'kvmclock_periodic_sync' is a readonly param that cannot change after
> bootup.
> 
> The kvm_arch_vcpu_postcreate() is not going to schedule the
> kvmclock_sync_work if kvmclock_periodic_sync == false.
> 
> As a result, the "if (!kvmclock_periodic_sync)" can never be true if the
> kvmclock_sync_work = kvmclock_sync_fn() is scheduled.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: remove always-false condition in kvmclock_sync_fn
      https://github.com/kvm-x86/linux/commit/2081a8450ef8

--
https://github.com/kvm-x86/linux/tree/next
