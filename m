Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0D868DBFB
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 15:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjBGOq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 09:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbjBGOqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 09:46:22 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E353ABB;
        Tue,  7 Feb 2023 06:46:16 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675781175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mYcwiNRkqYiEAK/3nmQ7uDSqLo3/Th+onVnS48XcvnE=;
        b=AWM9Fz9ykG+NOLpHmna8RgAmHpC3Mrch9Tg5eb4BM2/AIbATLe66d5z8MhmzvuF9CyHfUF
        QtWy9ujdx1pl0rChsy32R/Q5Fi+NbkcUDyYi3JBVPEX0GcLzb2sYdAMWmdWxJ/SenRLh2c
        Hp+mgoLgMvpuzeVELWezN+9/lFZJUQ4d3B1PlFFTSe0UyxI86jG/IOoeX/VrEZ0KZYuvgm
        o8etd3BawuoXx7nUprWBFujtmsYN5Wu4uK1wVR3JhZiaamH+Rc4navsXkVWHLWCvVfnJM+
        slMGX2Yn40ZYgEQGgoqtuVT4m8+yA4dS6HT7HN6yxtzwKVMv9jf+Q//6m6fAXA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675781175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mYcwiNRkqYiEAK/3nmQ7uDSqLo3/Th+onVnS48XcvnE=;
        b=ZTn1hTvZbZjVBTIUdffK0D2gtJ8tKpF23PPPzaFoDa6IXbz6KEasYYkwDQ/CEKGZ+69Aj2
        0PcTIy6cKtycjCAg==
To:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "usama.arif@bytedance.com" <usama.arif@bytedance.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v6 07/11] x86/smpboot: Disable parallel boot for AMD CPUs
In-Reply-To: <cbd9e88e738dc0c479e87121ca82431731905c73.camel@amazon.co.uk>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-8-usama.arif@bytedance.com> <87sffiwd3t.ffs@tglx>
 <cbd9e88e738dc0c479e87121ca82431731905c73.camel@amazon.co.uk>
Date:   Tue, 07 Feb 2023 15:46:15 +0100
Message-ID: <87mt5pv8i0.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07 2023 at 09:52, David Woodhouse wrote:

> On Tue, 2023-02-07 at 01:09 +0100, Thomas Gleixner wrote:
>> On Thu, Feb 02 2023 at 21:56, Usama Arif wrote:
>>
>> -ENOCONTENT
>
>
> Yeah, I'm aware of the nonsense here too but when I'm actually writing
> a commit message, years of habit kick in and it doesn't occur to me to
> pointlessly repeat the words that are already there, one line up where
> it says "Disable parallel boot for AMD CPUs".
>
> I'm old and stupid, but eventually I'll start to remember that people
> nowadays like to gratuitously refuse to read those words, and they want
> them repeated in a different place.

I'm not asking for repeating information from the subject line but to
actually add a rationale. The WHY is the most important information of a
changelog, no?

> Bear with me...

I do, but that doesn't mean I'm giving you special treatment :)

Thanks,

        tglx
