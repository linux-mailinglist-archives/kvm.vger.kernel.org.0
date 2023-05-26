Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC41712EA1
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 23:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236757AbjEZVDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 17:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjEZVC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 17:02:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA52BB
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:02:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8337ade1cso2996252276.2
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685134977; x=1687726977;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ufnMS1Vm02MeRbYAvMDbXJsJyhih3Q3FgRsGIe7SZJI=;
        b=tJmZie6+O3NUGdni/zS5mUSTo1rD3YuGNvroh/1eIQUpe9UlPFHyONHu3dGyIQBxC1
         /nHIBa7Fn3E1xTDwVElUxEeCqUfg6uV2dJnnzC+bVgo5Zx5E4lM77lissoPNdjeblOyw
         kLF+ZvaPJjhx4dS4W5LtXqyl8B5lsnZQ0gZk/I5XygLZVdQllPD03WXKy4ohqC1g8zFt
         GE4uwsHtF/h/i5ixScY30wqcuQKp5rRb16lo/fL14PQBY5bc5FGbZuzSQ7bHD6xrJ9U0
         e3/PEsUV/ap1D7Ex9+xDeBN+fK2Kov9HmQN37C2fFunFHk7qtAQY/XJhJK6aKo/10qaV
         MlHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685134977; x=1687726977;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ufnMS1Vm02MeRbYAvMDbXJsJyhih3Q3FgRsGIe7SZJI=;
        b=bJ4NLQO/Jnf/8TS4h/AUuIhcgmnkG98iZH+/1FV+lB5pXVGC5LWPDdRV0G/wJvVh0o
         dHLPRwwJlG1xWW5+Qm1PJDDLFJpU034IxWhJ0uBkXpw0Fn++E/OgOGY3YYB7Vh1mZviU
         NwrzgUwPw3FDMh3CVpMnzhO5OhvOTbTVMeSBcjTQEGSA5wSK9Nn7WFZ5pEBrLWccmcmm
         AORAoRPXCcwTocpJqld6W9WmAlWd/ROV15jxPjsYo+uUyPV8N/CIdswwzQVupj7I8Iuw
         JAmpzjRm05gKmh/u9gUPpiKlPjm9C1AFZW0RDTBcmIYluP0oVE2JR1qN0fXqhHg55c5O
         ZUWw==
X-Gm-Message-State: AC+VfDw73N0BGcpr9RaR9UFLCxnM8ePk3ekEKiJCnZNUSNoSXtf6Rgmr
        cvySh7Nu+17JQyeUWwxlMX26yeqtta4=
X-Google-Smtp-Source: ACHHUZ6ASVlqD07OuxfwODsa/5um2cgNGfdfAFK6MKgqU5ov9o9ANzLYFw7pk1sAvWfCfuHsJ2QoMBqbXqQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8211:0:b0:bad:14ac:f22e with SMTP id
 q17-20020a258211000000b00bad14acf22emr1153044ybk.5.1685134977083; Fri, 26 May
 2023 14:02:57 -0700 (PDT)
Date:   Fri, 26 May 2023 14:02:55 -0700
In-Reply-To: <bce4b387-638d-7f3c-ca9b-12ff6e020bad@vultr.com>
Mime-Version: 1.0
References: <f023d927-52aa-7e08-2ee5-59a2fbc65953@gameservers.com>
 <ZGzoUZLpPopkgvM0@google.com> <44ba516b-afe0-505d-1a87-90d489f9e03f@gameservers.com>
 <bce4b387-638d-7f3c-ca9b-12ff6e020bad@vultr.com>
Message-ID: <ZHEefxsu5E3BsPni@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     brak@gameservers.com
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023, Brian Rak wrote:
>=20
> On 5/24/2023 9:39 AM, Brian Rak wrote:
> >=20
> > On 5/23/2023 12:22 PM, Sean Christopherson wrote:
> > > The other thing that would be helpful would be getting kernel stack
> > > traces of the
> > > relevant tasks/threads.=EF=BF=BD The vCPU stack traces won't be inter=
esting,
> > > but it'll
> > > likely help to see what the fallocate() tasks are doing.
> > I'll see what I can come up with here, I was running into some
> > difficulty getting useful stack traces out of the VM
>=20
> I didn't have any luck gathering guest-level stack traces - kaslr makes i=
t
> pretty difficult even if I have the guest kernel symbols.

Sorry, I was hoping to get host stack traces, not guest stack traces.  I am=
 hoping
to see what the fallocate() in the *host* is doing.

Another datapoint that might provide insight would be seeing if/how KVM's p=
age
faults stats change, e.g. look at /sys/kernel/debug/kvm/pf_* multiple times=
 when
the guest is stuck.

Are you able to run modified host kernels?  If so, the easiest next step, a=
ssuming
stack traces don't provide a smoking gun, would be to add printks into the =
page
fault path to see why KVM is retrying instead of installing a SPTE.
