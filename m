Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD9B6575E0
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 12:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbiL1LWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 06:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiL1LWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 06:22:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423F325FB;
        Wed, 28 Dec 2022 03:22:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDC02B81636;
        Wed, 28 Dec 2022 11:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C988C433EF;
        Wed, 28 Dec 2022 11:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672226533;
        bh=g/ko60RCUy62mgwJX+BHqh4+FybNochgcGqfnbFgn1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bkySoNrEPygYgl5QF2mbRvdQP90/TfV81MHuS96aaZXlQcngUJ3MnPH6eA7QDx4Th
         9qys9DmCGwyeY+hU2x+2CaIsq4ffMaWs2Andkc5MUnCRyhe2gJL1UT52VEPs78jq5D
         4F1Tuo0nQj1sMGDBh/MID5iNoErPu3cmtJOLrAi9mragNuaOC3UExlhvrMtXFgnRzt
         wrjQrwIdzHmXG2C/xHTzuK1MlUOE4h7gPaZmWOD7ADqmpxfpX3FjjQu/1lKSa6NQ2/
         OpnrZhXA+oWI8B3m33i+IQsklsKqkL22FNLezHwLuMeZmbP3lDV+wqKLg9C8uYzdJ+
         KTTyjywJXPOvw==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pAUVf-00FXTE-4f;
        Wed, 28 Dec 2022 11:22:11 +0000
MIME-Version: 1.0
Date:   Wed, 28 Dec 2022 11:22:10 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 00/50] KVM: Rework kvm_init() and hardware enabling
In-Reply-To: <20221227130249.1650197-1-pbonzini@redhat.com>
References: <20221227130249.1650197-1-pbonzini@redhat.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <9acea262dec3511e9cf63081506f0bd7@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, seanjc@google.com, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, mjrosato@linux.ibm.com, farman@linux.ibm.com, vkuznets@redhat.com, dwmw2@infradead.org, paul@xen.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, atishp@atishpatra.org, david@redhat.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, yuan.yao@intel.com, cohuck@redhat.com, isaku.yamahata@intel.com, philmd@linaro.org, farosas@linux.ibm.com, mpe@ellerman.id.au, kai.huang@intel.com, chao.gao@intel.com, tglx@linutronix.de
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-12-27 13:02, Paolo Bonzini wrote:
> Queued, thanks.  I will leave this in kvm/queue after testing 
> everything
> else and moving it to kvm/next; this way, we can wait for test results
> on other architectures.

Can you please make this a topic branch, and if possible based
on a released -rc? It would make it a lot easier for everyone.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
