Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14445EF977
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 17:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbiI2PuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 11:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235025AbiI2PuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 11:50:06 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1F71F62B;
        Thu, 29 Sep 2022 08:50:01 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1odvnS-0005cZ-5r; Thu, 29 Sep 2022 17:49:58 +0200
Message-ID: <bd4d7463-a960-3c49-9c56-a8bd5c1ea7f0@maciej.szmigiero.name>
Date:   Thu, 29 Sep 2022 17:49:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US, pl-PL
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220927152241.194900-1-pbonzini@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH] KVM: allow compiling out SMM support
In-Reply-To: <20220927152241.194900-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.09.2022 17:22, Paolo Bonzini wrote:
> Some users of KVM implement the UEFI variable store through a paravirtual device
> that does not require the "SMM lockbox" component of edk2; allow them to
> compile out system management mode, which is not a full implementation
> especially in how it interacts with nested virtualization.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	The patch isn't pretty.  I could skip all the changes to add WARNs
> 	to called functions, but the point of adding the config symbol is
> 	to make sure that those functions, and all the baggage they bring,
> 	are dead.
> 

Out of curiosity: why the SMM support is so special that it's worth to
add a dedicated Kconfig entry for it?

After all, the current typical way to disable stuff (for testing, etc)
in KVM is to provide this possibility via a kvm module parameter.
This way it also can be switched on or off without having to rebuild the
kernel.

Looking at the patch it doesn't seem to disable that much of code (like,
significantly slim down the binary) and where it does disable something
it mostly relies on compiler dead code removal rather than explicit
#ifdefs (which would guarantee that the disabled code did not end in
the binary).

Thanks,
Maciej



