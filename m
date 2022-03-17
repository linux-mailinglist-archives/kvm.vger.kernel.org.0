Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D344DC6FD
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 13:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbiCQM4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 08:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbiCQM4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 08:56:08 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9ACE6C57;
        Thu, 17 Mar 2022 05:54:17 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nUpdu-0003Ys-Jj; Thu, 17 Mar 2022 13:54:14 +0100
Message-ID: <d541b534-8b83-b566-56eb-ea8baa7c998e@leemhuis.info>
Date:   Thu, 17 Mar 2022 13:54:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Content-Language: en-US
To:     James Turner <linuxkernel.foss@dmarc-none.turner.link>
Cc:     Alex Deucher <alexdeucher@gmail.com>,
        "Lazar, Lijo" <lijo.lazar@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
References: <87ee57c8fu.fsf@turner.link>
 <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
 <87a6ftk9qy.fsf@dmarc-none.turner.link> <87zgnp96a4.fsf@turner.link>
 <fc2b7593-db8f-091c-67a0-ae5ffce71700@leemhuis.info>
 <CADnq5_Nr5-FR2zP1ViVsD_ZMiW=UHC1wO8_HEGm26K_EG2KDoA@mail.gmail.com>
 <87czkk1pmt.fsf@dmarc-none.turner.link>
 <BYAPR12MB46140BE09E37244AE129C01A975C9@BYAPR12MB4614.namprd12.prod.outlook.com>
 <87sftfqwlx.fsf@dmarc-none.turner.link>
 <BYAPR12MB4614E2CFEDDDEAABBAB986A0975E9@BYAPR12MB4614.namprd12.prod.outlook.com>
 <87ee4wprsx.fsf@turner.link> <4b3ed7f6-d2b6-443c-970e-d963066ebfe3@amd.com>
 <87pmo8r6ob.fsf@turner.link>
 <5a68afe4-1e9e-c683-e06d-30afc2156f14@leemhuis.info>
 <CADnq5_MCKTLOfWKWvi94Q9-d5CGdWBoWVxEYL3YXOpMiPnLOyg@mail.gmail.com>
 <87pmnnpmh5.fsf@dmarc-none.turner.link>
 <CADnq5_NG_dQCYwqHM0umjTMg5Uud6zC4=MiscH91Y9v7mW9bJA@mail.gmail.com>
 <092b825a-10ff-e197-18a1-d3e3a097b0e3@leemhuis.info>
 <877d96to55.fsf@dmarc-none.turner.link> <87lexdw8gd.fsf@turner.link>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <87lexdw8gd.fsf@turner.link>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1647521657;08da124f;
X-HE-SMSGID: 1nUpdu-0003Ys-Jj
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.03.22 19:33, James Turner wrote:
>
>> My understanding at this point is that the root problem is probably
>> not in the Linux kernel but rather something else (e.g. the machine
>> firmware or AMD Windows driver) and that the change in f9b7f3703ff9
>> ("drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)") simply
>> exposed the underlying problem.

FWIW: that in the end is irrelevant when it comes to the Linux kernel's
'no regressions' rule. For details see:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/Documentation/admin-guide/reporting-regressions.rst
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/Documentation/process/handling-regressions.rst

That being said: sometimes for the greater good it's better to not
insist on that. And I guess that might be the case here.

> I'm not sure where to go from here. This issue isn't much of a concern> for me anymore, since blacklisting `amdgpu` works for my machine. At>
this point, my understanding is that the root problem needs to be fixed>
in AMD's Windows GPU driver or Dell's firmware, not the Linux kernel.
If> any of the AMD developers on this thread would like to forward it to
the> AMD Windows driver team, I'd be happy to work with AMD to fix the
issue> properly.
In that case I'll drop it from the list of regressions, unless what I
wrote above makes you change your mind.

#regzbot invalid: firmware issue exposed by kernel change, user seems to
be happy with a workaround

Thx everyone who participated in handling this.

Ciao, Thorsten

