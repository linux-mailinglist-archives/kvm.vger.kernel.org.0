Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F0853168B
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238828AbiEWQ0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 12:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbiEWQ0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 12:26:45 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8244D249
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:26:42 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ntAt9-0007jE-Vj; Mon, 23 May 2022 18:26:36 +0200
Message-ID: <58e76b42-22a7-3b54-e175-a3d01579525f@maciej.szmigiero.name>
Date:   Mon, 23 May 2022 18:26:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, kvm <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
References: <be14c1e895a2f452047451f050d269217dcee6d9.1653071510.git.maciej.szmigiero@oracle.com>
 <CABgObfZfV66MN11=xEjwH0PE944-OTcAZkSpWEcJeK=1EYWJnw@mail.gmail.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH] target/i386/kvm: Fix disabling MPX on "-cpu host" with
 MPX-capable host
In-Reply-To: <CABgObfZfV66MN11=xEjwH0PE944-OTcAZkSpWEcJeK=1EYWJnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.05.2022 10:54, Paolo Bonzini wrote:
> On Fri, May 20, 2022 at 8:33 PM Maciej S. Szmigiero
> <mail@maciej.szmigiero.name> wrote:
>>
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> Since KVM commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled")
>> it is not possible to disable MPX on a "-cpu host" just by adding "-mpx"
>> there if the host CPU does indeed support MPX.
>> QEMU will fail to set MSR_IA32_VMX_TRUE_{EXIT,ENTRY}_CTLS MSRs in this case
>> and so trigger an assertion failure.
>>
>> Instead, besides "-mpx" one has to explicitly add also
>> "-vmx-exit-clear-bndcfgs" and "-vmx-entry-load-bndcfgs" to QEMU command
>> line to make it work, which is a bit convoluted.
>>
>> Sanitize MPX-related bits in MSR_IA32_VMX_TRUE_{EXIT,ENTRY}_CTLS after
>> setting the vCPU CPUID instead so such workarounds are no longer necessary.
> 
> Can you use feature_dependencies instead? See for example
> 
>      {
>          .from = { FEAT_7_0_EBX,             CPUID_7_0_EBX_RDSEED },
>          .to = { FEAT_VMX_SECONDARY_CTLS,    VMX_SECONDARY_EXEC_RDSEED_EXITING },
>      },

The "feature_dependencies" way seems to work fine too,
and it definitely looks neater.

Thanks for the pointer, will post v2 in a moment.

> Paolo
> 

Thanks,
Maciej
