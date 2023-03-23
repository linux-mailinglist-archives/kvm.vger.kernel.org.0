Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D756C72D2
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjCWWNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjCWWNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:13:38 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5537D9B;
        Thu, 23 Mar 2023 15:13:25 -0700 (PDT)
Received: from [127.0.0.1] (dynamic-046-114-209-225.46.114.pool.telefonica.de [46.114.209.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4DDEE1EC063F;
        Thu, 23 Mar 2023 23:13:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1679609603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1rG8Vo4uESEgIx6SljIpoKKCeAOrhkkAIKpnzeWXL7Q=;
        b=iPuzgHJVUpBL5WXk4EVNvM5/Y2kYnz6B/KvW1lguZhVDRAWBHwCJRS1mNsBn5uFmsfy4tI
        lHrVnIk5xoFbkNCn/uc2rm0k4zGAgUugzFit6aQS0LJakDs5tvWfS/DF8un8OUnuyFwp7Z
        CJ/hNYhTyXd7JvC7BEQfZecCVBK6Yf4=
Date:   Thu, 23 Mar 2023 23:13:22 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "usama.arif@bytedance.com" <usama.arif@bytedance.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "brgerst@gmail.com" <brgerst@gmail.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "kim.phillips@amd.com" <kim.phillips@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "seanjc@google.com" <seanjc@google.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "piotrgorski@cachyos.org" <piotrgorski@cachyos.org>,
        "gpiccoli@igalia.com" <gpiccoli@igalia.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "Rapan, Sabin" <sabrapan@amazon.com>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v16 8/8] x86/smpboot: Allow parallel bringup for SEV-ES
User-Agent: K-9 Mail for Android
In-Reply-To: <19ec60aa-fa11-c44e-a6d1-9583f2e7707a@amd.com>
References: <20230321194008.785922-1-usama.arif@bytedance.com> <20230321194008.785922-9-usama.arif@bytedance.com> <20230322224735.GAZBuFh9ld6FuYEyoH@fat_crate.local> <2c3dd773-31ca-d4b1-78a2-b39f3785c7c5@amd.com> <751f572f940220775054dc09324b20b929d7d66d.camel@amazon.co.uk> <19ec60aa-fa11-c44e-a6d1-9583f2e7707a@amd.com>
Message-ID: <5D59D19F-8085-4638-96A2-4DCE00D2217E@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On March 23, 2023 7:28:38 PM GMT+01:00, Tom Lendacky <thomas=2Elendacky@amd=
=2Ecom> wrote:
>
>I agree=2E But once it's there, someone somewhere in the future may look =
and go, oh, I can call this=2E So I think it either needs a nice comment ab=
ove it about how it is currently used/called and what to do if it needs to =
be called from someplace other than head_64=2ES or the MSR needs to be save=
d/restored=2E

Or it could be __init and get discarded when the system is up=2E

--=20
Sent from a small device: formatting sucks and brevity is inevitable=2E 
