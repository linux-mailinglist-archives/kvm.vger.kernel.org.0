Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0A869DB2D
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 08:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbjBUH1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 02:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbjBUH1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 02:27:23 -0500
Received: from vulcan.natalenko.name (vulcan.natalenko.name [104.207.131.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D07244BC;
        Mon, 20 Feb 2023 23:27:16 -0800 (PST)
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 71BE4123AAF7;
        Tue, 21 Feb 2023 08:27:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1676964433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UktBiYkkeez87hMqM48Li63kPXU3FfbLk8UmzQ2RKWw=;
        b=QZC4Pw9o8MidWlTN/5L02j+LoMK6F2ufXZBjCK4usO7euEBOakN9aSoXgJap+ITrXS+acc
        rKXItmNG7yzx3G4PdBlbSCKQZpp9pjxSJOLXeyxUbu6xwHtgoNVIhJiqHouMgFXRfE2TkY
        EZyNZ8kvJVi7N//V3luu7IT/3pqfezc=
MIME-Version: 1.0
Date:   Tue, 21 Feb 2023 08:27:13 +0100
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
        liangma@liangbit.com, Piotr Gorski <lucjan.lucjanov@gmail.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
In-Reply-To: <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2668799.mvXUDI8C0e@natalenko.name>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
 <2668869.mvXUDI8C0e@natalenko.name>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
 <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
 <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
Message-ID: <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
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

On 21.02.2023 00:30, David Woodhouse wrote:
> Oleksandr, please could you show the output of 'cpuid' after a
> successful resume?  I'm particularly looking for this part...
> 
> 
> $ sudo cpuid | grep -A1 1/ebx
>    miscellaneous (1/ebx):
>       process local APIC physical ID = 0x0 (0)
> --
>    miscellaneous (1/ebx):
>       process local APIC physical ID = 0x2 (2)
> ...

For me this command doesn't produce any output. Also, no output from the 
command Kim used in response to you. With no `grep` it just dumps a 
table of raw hex data.

It's `msr-tools` 1.3-4 from Arch. Should I run this command on a patched 
kernel booted with `no_parallel_bringup`, or on unpatched kernel (if 
that makes any difference)?

-- 
   Oleksandr Natalenko (post-factum)
