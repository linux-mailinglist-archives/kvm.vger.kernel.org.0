Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E2D69DC58
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 09:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbjBUIpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 03:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbjBUIpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 03:45:01 -0500
Received: from vulcan.natalenko.name (vulcan.natalenko.name [104.207.131.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF78234E1;
        Tue, 21 Feb 2023 00:44:58 -0800 (PST)
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 15F41123AD1B;
        Tue, 21 Feb 2023 09:44:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1676969094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FIC5lZ3as9dPKws7ocPjtZcSjnJaB0fJKP8YCUvjRyo=;
        b=BclCujBF1iHRmI1ZsL+BoarWPqxvHzzvE71lqQyOszq4YLBmPuL+67RqACIfbxlQxUO+sS
        MBVFNZ2OsboKr7oTCpxZWrx7WiWZGpOn/YNmqJa7cF6Ic4U80F2GBJrpdNsF3FHR4d1icp
        Ul09+sWKh8vOxFyb6mcCBKXB6oHsMTI=
MIME-Version: 1.0
Date:   Tue, 21 Feb 2023 09:44:53 +0100
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Kim Phillips <kim.phillips@amd.com>, tglx@linutronix.de,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Piotr Gorski <piotrgorski@cachyos.org>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
In-Reply-To: <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2668799.mvXUDI8C0e@natalenko.name>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
 <2668869.mvXUDI8C0e@natalenko.name>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
 <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
 <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
 <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
 <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
 <3d8ed6e157df10c5175c636de0e21849@natalenko.name>
 <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org>
 <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name>
 <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org>
Message-ID: <ce731b5a4a53680b4840467977b33d9a@natalenko.name>
X-Sender: oleksandr@natalenko.name
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.02.2023 09:35, David Woodhouse wrote:
> On Tue, 2023-02-21 at 09:25 +0100, Oleksandr Natalenko wrote:
>> 
>> 
>> Right, sorry. Here it is: http://ix.io/4oLq
> 
> $ echo `grep ^00000001 4oLq  | cut -c36-37`
> 00 02 04 06 08 0a 0c 0e 10 12 14 16 18 1a 1c 1e 01 03 05 07 09 0b 0d 0f
> 11 13 15 17 19 1b 1d 1f
> 
> Well they look sane enough. All even APIC IDs and then all the odd ones
> is a topology that isn't massively surprising.
> 
> Does it match what you get *before* suspend/resume?

Yes, the output is completely the same after a fresh boot and after a 
suspend/resume cycle.

> Obviously we could stick our fingers in our ears and go "la la la" and
> just disable it for non-X2APIC, for AMD without X2APIC, or perhaps
> disable it on *resume* but still use it at boot. But I'd really like to
> understand what's going on and not do voodoo. Thanks for helping!

-- 
   Oleksandr Natalenko (post-factum)
