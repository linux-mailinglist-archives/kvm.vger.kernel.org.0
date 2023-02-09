Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2D1690824
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 13:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjBIMDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 07:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjBIMD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 07:03:28 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74D15A927;
        Thu,  9 Feb 2023 03:53:17 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675943595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pY9zAd1l8y+Bm/m/UuwMgzuWE+lLn5l+0+v5lQcS9qw=;
        b=tlNaVcyPOtXLwPGHRTm6O7UY2im01uatObMYNvQKk2myFUbbhAJBf++Yk1VREgSTWFCsXH
        qC1pHLzNS7HmFhbchdoZ2uLdxV0ovhwKYYQxite2U03F5iwSEkf0e7p+ou7UkdFMSE8j+Y
        NV7AAm5m5tZ2FbavtSsMnXXRBKRm3gOyppeciiFoTcKxTpnDTyAI8zp859C152UNCHakYs
        dXzTLnLZfr01OypA/8x+NLGP/yVZKjEGusuwFS0AXWJ2flTl+14IRip5sVGi3yvADKeET5
        MkiKJuOpj8JvRDJstar15uFzojS7t/G+iv1XMBxPH9bMttXXZ24knYwHzoD/Vw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675943595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pY9zAd1l8y+Bm/m/UuwMgzuWE+lLn5l+0+v5lQcS9qw=;
        b=hijKko/lrjMibWv5cwx6eGZnH7BCXBZcdtAR7PdElOO66poEx5bpSdihHmhgcskBA86Ec4
        Lp7peswMfogoeUDA==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, paulmck@kernel.org
Cc:     kim.phillips@amd.com, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
Subject: Re: [External] Re: [PATCH v7 0/9] Parallel CPU bringup for x86_64
In-Reply-To: <f07b371ae2eb11f541c665b488b3d4b6bf1a81b3.camel@infradead.org>
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
 <20230209035300.GA3216394@paulmck-ThinkPad-P17-Gen-1>
 <8e2f03e2-9517-aeb4-df60-b36ef3ff3a75@bytedance.com>
 <f07b371ae2eb11f541c665b488b3d4b6bf1a81b3.camel@infradead.org>
Date:   Thu, 09 Feb 2023 12:53:14 +0100
Message-ID: <87357f2gyd.ffs@tglx>
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

On Thu, Feb 09 2023 at 11:03, David Woodhouse wrote:
> This one also fixes it for me. If we're happy with this approach, I'll
> work it into Thomas's original patch (and hopefully eventually he'll be
> happy enough with it and the commit message that he'll give us his
> Signed-off-by for it.)

I'm happy enough by now, but I'm not sure how much of the original patch
is still left. Also you did the heavy lifting of making it work and
writing the nice changelog. So please make this:

From: David Woodhouse <dwmw2@infradead.org>

Co-developed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>

> I could probably add a Co-developed-by: tglx for that first x2apic
> patch in the series too, but then it would *also* need his SoB and I
> didn't want to be owed two, so I just pasted his suggested code and
> didn't credit him.

That's what Suggested-by: is for. For that I don't owe you anything. :)

Thanks

        tglx
