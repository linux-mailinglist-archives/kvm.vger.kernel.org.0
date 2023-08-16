Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62AB77E0CE
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 13:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244747AbjHPLvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 07:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244838AbjHPLvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 07:51:00 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71112110
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 04:50:52 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-319559fd67dso4853326f8f.3
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 04:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1692186651; x=1692791451;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oCvU0Ug+xdDOoTLa/wDMgfx5JmtWD0ldcx5VrnTX1HA=;
        b=T79TdcwanC1IiY26itVj/+U/RShtuVKUortlAJlJr31AvW/7eWpDmE0V0HgV2hXt77
         ln4aw9bElT7EsfVkod/7KEYPiytlI4ESGwuRa9JEWUiKCN7H4qwAhSCJVrW1qctxYpG9
         khWAK18RTNbdRrph1oagKBWLd3miq5pEIZTtfNQKaJ/tBN0DpCUS+fAcHWCyTjCnNKc9
         IYiUu86rE2oP+aBknd9eejC+NxRsvfpnACSAuoD33jF9BopQRo0Ibgnpmlc72HQrYhcU
         JahnP5y0YBZkXka9pAcNfRRt+/d4QHWO4CO1573Eekj3PQG5n+UoeeE5DL41lCkSw1PC
         XGvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692186651; x=1692791451;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oCvU0Ug+xdDOoTLa/wDMgfx5JmtWD0ldcx5VrnTX1HA=;
        b=Qv2lQHtbVDbhMvlj89B2m/SoRHQy8pQ/M1qcrOANFa47WQsRVo62T+onfNpLIH3pz2
         IZh/PKCY0r7NEPXaoj4iQtpViT/o74zT+dNM2DVmncl3aK1Qa0mzXZ2iHZoS/CxD+NuC
         xGjNMMVMhKKfiKEP1vvgPJAYvWq6dN+cmwKHg24zgd0PoqXJQn8QpLkU4gatSKiFX4Kt
         TH2v/DmYUDxtBlEMC/Ge9qzWJjUf65Smyg42xgB2cd0mFD9HaWK7hF1RDJgLEitnFBTe
         DZ06irsqpJJ+M948nqL1M/z2ADmfDNOnM0CFR/x7YpPRXwNDr4FFcPxXCV6KTt2UAHe2
         5pbg==
X-Gm-Message-State: AOJu0YwABLJXJm1cFhYhokPvkKJAG1wjB9Pr/xw59+AP6D9zLHeMYi6g
        Py+TIdcb9taYCEBFEYq6qG01cj4Lf2XrbPG1GdA=
X-Google-Smtp-Source: AGHT+IHVe6uY8fdgOquhNu15esW4k/kM0UZZsKPV6wxMFcNfVcu62bPofgGFGvDsciceOmsP/eIUkQ==
X-Received: by 2002:a5d:4d09:0:b0:317:6a07:83a7 with SMTP id z9-20020a5d4d09000000b003176a0783a7mr1196572wrt.38.1692186650843;
        Wed, 16 Aug 2023 04:50:50 -0700 (PDT)
Received: from ?IPV6:2003:f6:af41:7300:ce8c:9d6:7fc5:132b? (p200300f6af417300ce8c09d67fc5132b.dip0.t-ipconnect.de. [2003:f6:af41:7300:ce8c:9d6:7fc5:132b])
        by smtp.gmail.com with ESMTPSA id t18-20020adff612000000b00317b0155502sm21169936wrp.8.2023.08.16.04.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 04:50:50 -0700 (PDT)
Message-ID: <57644fdf-27aa-0f13-ea23-c938626343ac@grsecurity.net>
Date:   Wed, 16 Aug 2023 13:50:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups and new testscases
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20230622211440.2595272-1-seanjc@google.com>
 <105d31d9-7e3d-c78d-6878-37d50376f6f5@grsecurity.net>
 <ZNuc8kq57/HhvBn6@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZNuc8kq57/HhvBn6@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.08.23 17:42, Sean Christopherson wrote:
> On Tue, Aug 15, 2023, Mathias Krause wrote:
>> On 22.06.23 23:14, Sean Christopherson wrote:
>>> Please pull a variety of (mostly) x86 changes.  There's one non-x86 change to
>>> fix a bug in processing "check" entries in unittests.cfg files.  The majority
>>> of the x86 changes revolve around nSVM, PMU, and emulator tests.
>>>
>>> The following changes since commit 02d8befe99f8205d4caea402d8b0800354255681:
>>>
>>>   pretty_print_stacks: modify relative path calculation (2023-04-20 10:26:06 +0200)
>>>
>>> are available in the Git repository at:
>>>
>>>   https://github.com/kvm-x86/kvm-unit-tests.git tags/kvm-x86-2023.06.22
>>>
>>> for you to fetch changes up to e3a9b2f5490e854dfcccdde4bcc712fe928b02b4:
>>>
>>>   x86/emulator64: Test non-canonical memory access exceptions (2023-06-12 11:06:19 -0700)
>>>
>>> ----------------------------------------------------------------
>>> [...]
>>
>> Ping! What happened to this one?
> 
> Got ignored for so long that it became stale[*] :-/

:(

> I'll work on generating a new pull request this week.
> 
> [*] https://lore.kernel.org/all/ff259694-eb1b-771a-faaf-b8119b899615@redhat.com

Looks like, all that's needed is to drop commit 5f15933dccae ("x86: Link
with "-z noexecstack" to suppress irrelevant linker warnings"), as it
was handled more generic in 63707aafb908 ("Link with "-z noexecstack" to
avoid warning from newer versions of ld").

Thanks,
Mathias
