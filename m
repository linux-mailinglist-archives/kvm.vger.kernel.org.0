Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFE46C8776
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 22:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjCXV1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 17:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjCXV1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 17:27:18 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AC7199D7
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 14:27:17 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n13-20020a170902d2cd00b001a22d27406bso81597plc.13
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 14:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679693237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6zePKddV/iwqym9bgYlEazTH1FsVa1YzF3bKPGXvyUE=;
        b=TPLvUusFr04aY1T8sG+B11UMeVGSvt3rYDLfC+ZDclob/dEbEDc+HS2AMxlgy8GJ6c
         yF9p4G8EY3b9xXqA0mjA6XXvfzwxsYOsZw4QCZBQ1X/FKmrGmKg6i39HGfImcXuJJoTy
         EdPIGSymDbNdzX1EA0vaAZm4KiQZbUZgaoOTMFRMBPmfzbSHimw4Fhg76gxYdRLg+o5y
         0WHD5fLeSOQ41C41WYtOoow8OZioEc/lbQGhWf+hXCZOjxn8CA8k/0JBLVpyz7sCHsYK
         HDY7xVfSswAjRVXv4O3AhGyB6LcCDgyDikHDD6AJRCrxMB53rBbzFR+cFmgLuPPCvzkP
         qjrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679693237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6zePKddV/iwqym9bgYlEazTH1FsVa1YzF3bKPGXvyUE=;
        b=RKvgRK+FvjQ/EJYOYA0k4yTqGWXXj8kaLupCEBhwWyKrx/6btLwgkilebYaDzm7qnB
         gyl0E5I4a0ZYnTwvfFYAJzosdkc+tV9IITftKtSREVqSZXovBftUX3Sx3DtsMdyG22i7
         4AGwbv5xfJGCMAiH6xLsKlLGXjP/Dmymp2TKZViYx/cE7vME6jxcQYH+Cti4NdaqeMvc
         9j0K0ZEQRA2IxIfccnGn7HV3rhTqNAhTatvbbuGqw8aMp0M6VSg8Z5vRSkvQbYVOZM4h
         zyjeT19/80eKuSy4/SR2lZJ6aOSDRJU9YRTMynBL8dGOSVJZBpSwU4S+AI5ILXIS+tbK
         p6+g==
X-Gm-Message-State: AAQBX9elk3coQ0dG3OAZa9MFO++VqbtGGQK93TG3fK5CmjXSsUiow6ce
        iRzskRefZ6AWDNOV8x9hDhWEYxmXCUY=
X-Google-Smtp-Source: AKy350aqGWsdWjWwegqoLWfvcdbn6k4rDZFiOq/lDmEEoy5VQtVIcuZTzkPUDGTRpSoVgjf+URb5P6CmVQ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fa12:b0:23b:3426:bc5e with SMTP id
 cm18-20020a17090afa1200b0023b3426bc5emr1279659pjb.4.1679693237539; Fri, 24
 Mar 2023 14:27:17 -0700 (PDT)
Date:   Fri, 24 Mar 2023 14:27:16 -0700
In-Reply-To: <167969137156.2756401.15618241992481271147.b4-ty@google.com>
Mime-Version: 1.0
References: <20230227180601.104318-1-ackerleytng@google.com> <167969137156.2756401.15618241992481271147.b4-ty@google.com>
Message-ID: <ZB4VtIPZjDGwuPOc@google.com>
Subject: Re: [PATCH v2 1/1] KVM: selftests: Adjust VM's initial stack address
 to align with SysV ABI spec
From:   Sean Christopherson <seanjc@google.com>
To:     pbonzini@redhat.com, shuah@kernel.org, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Cc:     erdemaktas@google.com, vannapurve@google.com, sagis@google.com,
        mail@maciej.szmigiero.name
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 24, 2023, Sean Christopherson wrote:
> On Mon, 27 Feb 2023 18:06:01 +0000, Ackerley Tng wrote:
> > Align the guest stack to match calling sequence requirements in
> > section "The Stack Frame" of the System V ABI AMD64 Architecture
> > Processor Supplement, which requires the value (%rsp + 8), NOT %rsp,
> > to be a multiple of 16 when control is transferred to the function
> > entry point. I.e. in a normal function call, %rsp needs to be 16-byte
> > aligned _before_ CALL, not after.
> > 
> > [...]
> 
> Applied to kvm-x86 selftests, thanks!
> 
> [1/1] KVM: selftests: Adjust VM's initial stack address to align with SysV ABI spec
>       https://github.com/kvm-x86/linux/commit/1982754bd2a7

Force pushed to selftests 'cause I had a goof, this now:

        KVM: selftests: Adjust VM's initial stack address to align with SysV ABI spec
        https://github.com/kvm-x86/linux/commit/8264e85560e5
