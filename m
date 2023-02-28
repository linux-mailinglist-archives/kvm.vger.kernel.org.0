Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCEB6A58D1
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjB1MFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjB1MFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:05:44 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D382DE62;
        Tue, 28 Feb 2023 04:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Tb8v3gSrxOz35jzMapCnQ0G/8W1+t6kLfHHktPU3mD4=; b=VIsdJCJXi1xMa1zI7F3s3Pliy0
        HXitXrg+XyBOf9eICMwNy3L8y3AtwLggejHxMxrL7XfK80/0MXxMA/DQqUDAbRxVbHiN4Nu3PbxzX
        w8IGouuc9WMEeTri671NblotNzLe7WcGcTfk3F1w7Ow7Z7aT5bp1ld9hTxH/LC/0hwXOQRBBNFqqk
        rrsqnin7gJ9ZF74MyYK2HiEMeKQtGgdjh3EWejV5NcV3QrBOy1n+L12tOZ4JoKl3Nv8c7W7j0ndEc
        dJnG7bSC1a2hIxqWvWXggjafWSPKymCzn+3rR4BBNdlNLv9ML42EY3Zn7CJttGIc03R5sMDLU8Ns/
        W0s+kYcQ==;
Received: from [152.254.196.162] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1pWyiv-000Bgy-K1; Tue, 28 Feb 2023 13:04:49 +0100
Message-ID: <174e3a17-31bb-d74c-6248-23558fc2b5ee@igalia.com>
Date:   Tue, 28 Feb 2023 09:04:39 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v12 00/11] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Usama Arif <usama.arif@bytedance.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, brgerst@gmail.com,
        dave.hansen@linux.intel.com, fam.zheng@bytedance.com,
        hewenliang4@huawei.com, "H. Peter Anvin" <hpa@zytor.com>,
        kim.phillips@amd.com, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, liangma@liangbit.com,
        mimoja@mimoja.de, oleksandr@natalenko.name,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, piotrgorski@cachyos.org,
        punit.agrawal@bytedance.com, rcu@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        simon.evans@bytedance.com, Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>, x86@kernel.org
References: <3ca3b60e-47a2-640a-cad3-e3e110d3aaf7@igalia.com>
 <8b0cc6fa-8d40-7401-b8f9-559b5db3e8c9@molgen.mpg.de>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <8b0cc6fa-8d40-7401-b8f9-559b5db3e8c9@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/2023 07:13, Paul Menzel wrote:
> Dear Guilherme,
> 
> 
> Am 27.02.23 um 22:39 schrieb Guilherme G. Piccoli:
> 
>> I've tested it on Steam Deck (with and without the "no_parallel_bringup"
>> parameter), it works fine - also tested S3/deep sleep-resume cycle.
>>
>> Feel free to add (to the series):
>> Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> Thank you for testing the series. It’d be great if you could share the 
> timing differences.
> 
> […]
> 
> 
> Kind regards,
> 
> Paul

Hi Paul!

The results...weren't so great, I felt no difference heh
Which is also not bad, it seems the series favors big SMP systems, Deck
has only 8 CPUs.

But maybe the way I measured is not ideal? I just compared timestamps on
dmesg from the first SMP message up to the one that says the boot of
secondary CPUs is complete. Do you have a better suggestion? I can try
things here.

Cheers,


Guilherme
