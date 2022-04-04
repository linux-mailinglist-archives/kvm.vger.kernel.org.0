Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49BF94F1C04
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379848AbiDDVVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380562AbiDDU3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 16:29:38 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F9C2DAB8;
        Mon,  4 Apr 2022 13:27:41 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nbTIS-0003aH-H2; Mon, 04 Apr 2022 22:27:32 +0200
Message-ID: <de73f4d1-7ec0-249b-5227-32ba78980c93@maciej.szmigiero.name>
Date:   Mon, 4 Apr 2022 22:27:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 6/8] KVM: SVM: Re-inject INTn instead of retrying the insn
 on "failure"
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-7-seanjc@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <20220402010903.727604-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2.04.2022 03:09, Sean Christopherson wrote:
> Re-inject INTn software interrupts instead of retrying the instruction if
> the CPU encountered an intercepted exception while vectoring the INTn,
> e.g. if KVM intercepted a #PF when utilizing shadow paging.  Retrying the
> instruction is architecturally wrong e.g. will result in a spurious #DB
> if there's a code breakpoint on the INT3/O, and lack of re-injection also
> breaks nested virtualization, e.g. if L1 injects a software interrupt and
> vectoring the injected interrupt encounters an exception that is
> intercepted by L0 but not L1.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ecc828d6921e..00b1399681d1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3425,14 +3425,24 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>   static void svm_inject_irq(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> +	u32 type;
>   
>   	WARN_ON(!gif_set(svm));
>   
> +	if (vcpu->arch.interrupt.soft) {

It should be possible to inject soft interrupts even with GIF masked,
looked at the relevant code at patch 3 from my series [1].

Thanks,
Maciej

[1]: https://lore.kernel.org/kvm/a28577564a7583c32f0029f2307f63ca8869cf22.1646944472.git.maciej.szmigiero@oracle.com/
