Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F29C70E1C7
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 18:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbjEWQW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 12:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237711AbjEWQWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 12:22:54 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A361B1
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 09:22:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1ae4a0b5a90so41505765ad.1
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 09:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684858963; x=1687450963;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PNHCUppAMmM7GKqBt6zRAnVXYLdUPmYe/rZeobiUH1Q=;
        b=jHL3C/UhRc3qi7X4MyIUymwIPYodJSqI4yGXsntiUc0MEBkBVJRC87BiHc39UqRMxt
         R2xvDs0GDsx/JsQYjEhwRvp3iXDy4X1qQWO/Bd+ns9o/E/zzgntOWyctNx07AHz4qBWL
         2nUKMCVfuTn+L66Pu6lQNWiX3HO2pJR9glXVbuRbVEYPEM704kHzX4GKQKExxn0OQLGu
         d5F1rRA1tfdhU6ETh/EsaPdFi1jXqeoBOti513crKKBPZYjPcRYS1ezbVnpNs4M/QpNU
         LRaIG0ItpIUjy7CTW3wTDe0YXKoc1lAmbkirctmjPPh48IiQ0wsVu3Qi55Fc8YJRgHDA
         X75g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684858963; x=1687450963;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PNHCUppAMmM7GKqBt6zRAnVXYLdUPmYe/rZeobiUH1Q=;
        b=A4k/M4RwIdvBzANIiCze9/1KaJf7EGzc2lsJYfI7B3kgK4m3iYtWUjBpwzgzllAzYE
         V8GJB8+cIXQZ52C3sV3JL2FN29mYNHui+8NEL/g1b/Tfgh7Qphdkf4dS+afIGSzb9D8s
         pszVRSblscxQO2/7ytMg2gfpYIc815lnLy0WAcDer0NKvxE26TKtrzFNR+PNg5auJTrU
         QM0XAdV8nP2kEa08lpFLItVIjzdCGL9npfjJ8KxluihHT1Y1FSJD0wGWyMJegztgjU6X
         RrwduAODOPuvvIQNE4jSiokRyOQRgj0D7jdC6eEqU50XJw6Roz7LvIk0drkj0cY9uUAj
         aQIA==
X-Gm-Message-State: AC+VfDwc8t9D4+yQoA2Dvt09FHUU2K9rih1wA8LvPmISVygmCAdfkNbT
        I+u7iSwD4VdJ0b7ERAvGNqMglNTVMEI=
X-Google-Smtp-Source: ACHHUZ70ulYSvy715Dw24df5yN2+4BwEyc2z7ZpRFKwrErIeMvjnOZV1O2habwLrj9F7E6WGvpgbKnpcVnk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:7c4:b0:1ac:618c:a703 with SMTP id
 ko4-20020a17090307c400b001ac618ca703mr3559477plb.10.1684858963641; Tue, 23
 May 2023 09:22:43 -0700 (PDT)
Date:   Tue, 23 May 2023 09:22:41 -0700
In-Reply-To: <f023d927-52aa-7e08-2ee5-59a2fbc65953@gameservers.com>
Mime-Version: 1.0
References: <f023d927-52aa-7e08-2ee5-59a2fbc65953@gameservers.com>
Message-ID: <ZGzoUZLpPopkgvM0@google.com>
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

Nit, this isn't deadlock.  It may or may not even be a livelock AFAICT.  Th=
e vCPUs
are simply stuck and not making forward progress, _why_ they aren't making =
forward
progress is unknown at this point (obviously :-) ).

On Tue, May 23, 2023, Brian Rak wrote:
> We've been hitting an issue lately where KVM guests (w/ qemu) have been
> getting stuck in a loop of EPT_VIOLATIONs, and end up requiring a guest
> reboot to fix.
>=20
> On Intel machines the trace ends up looking like:
>=20
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465404: kvm_entry:=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD vcpu 1, rip
> 0xffffffffc0771aa2
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465405: kvm_exit:=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD reason
> EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465405: kvm_page_fa=
ult:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vcpu 1 rip
> 0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465406: kvm_inj_vir=
q:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =
IRQ 0xec
> [reinjected]
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465406: kvm_entry:=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD vcpu 1, rip
> 0xffffffffc0771aa2
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465407: kvm_exit:=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD reason
> EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465407: kvm_page_fa=
ult:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vcpu 1 rip
> 0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465408: kvm_inj_vir=
q:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =
IRQ 0xec
> [reinjected]
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465408: kvm_entry:=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD vcpu 1, rip
> 0xffffffffc0771aa2
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465409: kvm_exit:=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD reason
> EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465410: kvm_page_fa=
ult:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vcpu 1 rip
> 0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465410: kvm_inj_vir=
q:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =
IRQ 0xec
> [reinjected]
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465410: kvm_entry:=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD vcpu 1, rip
> 0xffffffffc0771aa2
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465411: kvm_exit:=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD reason
> EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465412: kvm_page_fa=
ult:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vcpu 1 rip
> 0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465413: kvm_inj_vir=
q:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =
IRQ 0xec
> [reinjected]
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465413: kvm_entry:=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD vcpu 1, rip
> 0xffffffffc0771aa2
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465414: kvm_exit:=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD reason
> EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465414: kvm_page_fa=
ult:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vcpu 1 rip
> 0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465415: kvm_inj_vir=
q:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =
IRQ 0xec
> [reinjected]
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465415: kvm_entry:=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD vcpu 1, rip
> 0xffffffffc0771aa2
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465417: kvm_exit:=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD reason
> EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-2386625 [094] 6598425.465417: kvm_page_fa=
ult:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vcpu 1 rip
> 0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
>=20
> on AMD machines, we end up with:
>=20
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055571: kvm_page_faul=
t:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vcpu 0 rip
> 0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055571: kvm_entry:=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD vcpu 0, rip
> 0xffffffffb172ab2b
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055572: kvm_exit:=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD reason EXIT_NPF
> rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055572: kvm_page_faul=
t:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vcpu 0 rip
> 0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055573: kvm_entry:=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD vcpu 0, rip
> 0xffffffffb172ab2b
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055574: kvm_exit:=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD reason EXIT_NPF
> rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055574: kvm_page_faul=
t:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vcpu 0 rip
> 0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055575: kvm_entry:=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD vcpu 0, rip
> 0xffffffffb172ab2b
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055575: kvm_exit:=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD reason EXIT_NPF
> rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055576: kvm_page_faul=
t:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vcpu 0 rip
> 0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055576: kvm_entry:=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD vcpu 0, rip
> 0xffffffffb172ab2b
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055577: kvm_exit:=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD reason EXIT_NPF
> rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055577: kvm_page_faul=
t:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vcpu 0 rip
> 0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055578: kvm_entry:=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD vcpu 0, rip
> 0xffffffffb172ab2b
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055579: kvm_exit:=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD reason EXIT_NPF
> rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055579: kvm_page_faul=
t:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vcpu 0 rip
> 0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
> =EF=BF=BD=EF=BF=BD =EF=BF=BDCPU-14414 [063] 3039492.055580: kvm_entry:=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD vcpu 0, rip
> 0xffffffffb172ab2b

In both cases, the TDP fault (EPT violation on Intel, #NPF on AMD) is occur=
ring
when translating a guest paging structure.  I can't glean much from the AMD=
 case,
but in the Intel trace, the fault occurs during delivery of the timer inter=
rupt
(vector 0xec).  That may or may not be relevant to what's going on.

It's definitely suspicious that both traces show that the guest is stuck fa=
ulting
on a guest paging structure.  Purely from a probability perspective, the od=
ds of
that being a coincidence are low, though definitely not impossible.

> The qemu process ends up looking like this once it happens:
>=20
> =EF=BF=BD=EF=BF=BD =EF=BF=BD0x00007fdc6a51be26 in internal_fallocate64 (f=
d=3D-514841856, offset=3D16,
> len=3D140729021657088) at ../sysdeps/posix/posix_fallocate64.c:36
> =EF=BF=BD=EF=BF=BD =EF=BF=BD36=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD return=
 EINVAL;
> =EF=BF=BD=EF=BF=BD =EF=BF=BD(gdb) thread apply all bt
>=20
> =EF=BF=BD=EF=BF=BD =EF=BF=BDThread 6 (Thread 0x7fdbdefff700 (LWP 879746) =
"vnc_worker"):
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#0=EF=BF=BD futex_wait_cancelable (private=3D=
0, expected=3D0,
> futex_word=3D0x7fdc688f66cc) at ../sysdeps/nptl/futex-internal.h:186
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#1=EF=BF=BD __pthread_cond_wait_common (absti=
me=3D0x0, clockid=3D0,
> mutex=3D0x7fdc688f66d8, cond=3D0x7fdc688f66a0) at pthread_cond_wait.c:508
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#2=EF=BF=BD __pthread_cond_wait (cond=3Dcond@=
entry=3D0x7fdc688f66a0,
> mutex=3Dmutex@entry=3D0x7fdc688f66d8) at pthread_cond_wait.c:638
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#3=EF=BF=BD 0x0000563424cbd32b in qemu_cond_w=
ait_impl (cond=3D0x7fdc688f66a0,
> mutex=3D0x7fdc688f66d8, file=3D0x563424d302b4 "../../ui/vnc-jobs.c", line=
=3D248)
> at ../../util/qemu-thread-posix.c:220
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#4=EF=BF=BD 0x00005634247dac33 in vnc_worker_=
thread_loop (queue=3D0x7fdc688f66a0)
> at ../../ui/vnc-jobs.c:248
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#5=EF=BF=BD 0x00005634247db8f8 in vnc_worker_=
thread
> (arg=3Darg@entry=3D0x7fdc688f66a0) at ../../ui/vnc-jobs.c:361
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#6=EF=BF=BD 0x0000563424cbc7e9 in qemu_thread=
_start (args=3D0x7fdbdeffcf30) at
> ../../util/qemu-thread-posix.c:505
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#7=EF=BF=BD 0x00007fdc6a8e1ea7 in start_threa=
d (arg=3D<optimized out>) at
> pthread_create.c:477
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#8=EF=BF=BD 0x00007fdc6a527a2f in clone () at
> ../sysdeps/unix/sysv/linux/x86_64/clone.S:95
>=20
> =EF=BF=BD=EF=BF=BD =EF=BF=BDThread 5 (Thread 0x7fdbe5dff700 (LWP 879738) =
"CPU 1/KVM"):
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#0=EF=BF=BD 0x00007fdc6a51d5f7 in preadv64v2 =
(fd=3D1756258112,
> vector=3D0x563424b5f007 <kvm_vcpu_ioctl+103>, count=3D0, offset=3D0, flag=
s=3D44672)
> at ../sysdeps/unix/sysv/linux/preadv64v2.c:31
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#1=EF=BF=BD 0x0000000000000000 in ?? ()
>=20
> =EF=BF=BD=EF=BF=BD =EF=BF=BDThread 4 (Thread 0x7fdbe6fff700 (LWP 879737) =
"CPU 0/KVM"):
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#0=EF=BF=BD 0x00007fdc6a51d5f7 in preadv64v2 =
(fd=3D1755834304,
> vector=3D0x563424b5f007 <kvm_vcpu_ioctl+103>, count=3D0, offset=3D0, flag=
s=3D44672)
> at ../sysdeps/unix/sysv/linux/preadv64v2.c:31
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#1=EF=BF=BD 0x0000000000000000 in ?? ()
>=20
> =EF=BF=BD=EF=BF=BD =EF=BF=BDThread 3 (Thread 0x7fdbe83ff700 (LWP 879735) =
"IO mon_iothread"):
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#0=EF=BF=BD 0x00007fdc6a51bd2f in internal_fa=
llocate64 (fd=3D-413102080, offset=3D3,
> len=3D4294967295) at ../sysdeps/posix/posix_fallocate64.c:32
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#1=EF=BF=BD 0x000d5572b9bb0764 in ?? ()
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#2=EF=BF=BD 0x000000016891db00 in ?? ()
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#3=EF=BF=BD 0xffffffff7fffffff in ?? ()
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#4=EF=BF=BD 0xf6b8254512850600 in ?? ()
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#5=EF=BF=BD 0x0000000000000000 in ?? ()
>=20
> =EF=BF=BD=EF=BF=BD =EF=BF=BDThread 2 (Thread 0x7fdc693ff700 (LWP 879730) =
"qemu-kvm"):
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#0=EF=BF=BD 0x00007fdc6a5212e9 in ?? () from
> target:/lib/x86_64-linux-gnu/libc.so.6
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#1=EF=BF=BD 0x0000563424cbd9aa in qemu_futex_=
wait (val=3D<optimized out>,
> f=3D<optimized out>) at ./include/qemu/futex.h:29
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#2=EF=BF=BD qemu_event_wait (ev=3Dev@entry=3D=
0x5634254bd1a8 <rcu_call_ready_event>)
> at ../../util/qemu-thread-posix.c:430
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#3=EF=BF=BD 0x0000563424cc6d80 in call_rcu_th=
read (opaque=3Dopaque@entry=3D0x0) at
> ../../util/rcu.c:261
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#4=EF=BF=BD 0x0000563424cbc7e9 in qemu_thread=
_start (args=3D0x7fdc693fcf30) at
> ../../util/qemu-thread-posix.c:505
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#5=EF=BF=BD 0x00007fdc6a8e1ea7 in start_threa=
d (arg=3D<optimized out>) at
> pthread_create.c:477
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#6=EF=BF=BD 0x00007fdc6a527a2f in clone () at
> ../sysdeps/unix/sysv/linux/x86_64/clone.S:95
>=20
> =EF=BF=BD=EF=BF=BD =EF=BF=BDThread 1 (Thread 0x7fdc69c3a680 (LWP 879712) =
"qemu-kvm"):
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#0=EF=BF=BD 0x00007fdc6a51be26 in internal_fa=
llocate64 (fd=3D-514841856,
> offset=3D16, len=3D140729021657088) at ../sysdeps/posix/posix_fallocate64=
.c:36
> =EF=BF=BD=EF=BF=BD =EF=BF=BD#1=EF=BF=BD 0x0000000000000000 in ?? ()
>=20
> We first started seeing this back in 5.19, and we're still seeing it as o=
f
> 6.1.24 (likely later too, we don't have a ton of data for newer versions)=
.=EF=BF=BD
> We haven't been able to link this to any specific hardware.

Just to double check, this is the host kernel version, correct?  When you u=
pgraded
to kernel 5.19, did you change anything else in the stack?  E.g. did you up=
grade
QEMU at the same time?  And what kernel were you upgrading from?

> It appears to happen more often on Intel, but our sample size is much lar=
ger
> there.=EF=BF=BD Guest operating system type/version doesn't appear to mat=
ter.=EF=BF=BD This
> usually happens to guests with a heavy network/disk workload, but it can
> happen to even idle guests. This has happened on qemu 7.0 and 7.2 (upgrad=
ing
> to 7.2.2 is on our list to do).
>=20
> Where do we go from here?=EF=BF=BD We haven't really made a lot of progre=
ss in
> figuring out why this keeps happening, nor have we been able to come up w=
ith
> a reliable way to reproduce it.

Is it possible to capture a failure with the trace_kvm_unmap_hva_range,
kvm_mmu_spte_requested and kvm_mmu_set_spte tracepoints enabled?  That will=
 hopefully
provide insight into why the vCPU keeps faulting, e.g. should show if KVM i=
s
installing a "bad" SPTE, or if KVM is doing nothing and intentionally retry=
ing
the fault because there are constant and/or unresolve mmu_notifier events. =
 My
guess is that it's the latter (KVM doing nothing) due to the fallocate() ca=
lls
in the stack, but that's really just a guess.

The other thing that would be helpful would be getting kernel stack traces =
of the
relevant tasks/threads.  The vCPU stack traces won't be interesting, but it=
'll
likely help to see what the fallocate() tasks are doing.
