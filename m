Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D7D69EC92
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 02:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjBVBw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 20:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBVBw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 20:52:27 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 312552CC40;
        Tue, 21 Feb 2023 17:52:25 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8DxE4RZdfVj2WcDAA--.1440S3;
        Wed, 22 Feb 2023 09:52:25 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxf+RXdfVjKFA4AA--.2780S3;
        Wed, 22 Feb 2023 09:52:24 +0800 (CST)
Subject: Re: [PATCH v2 06/29] LoongArch: KVM: Implement vcpu create and
 destroy interface
To:     Paolo Bonzini <pbonzini@redhat.com>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-7-zhaotianrui@loongson.cn>
 <cbd95763-ec38-63f7-89bf-c8b01aa7df77@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <abfa3fbc-e234-d0ab-ec35-90d9c251bf79@loongson.cn>
Date:   Wed, 22 Feb 2023 09:52:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <cbd95763-ec38-63f7-89bf-c8b01aa7df77@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxf+RXdfVjKFA4AA--.2780S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvdXoWrKFyDXr1fKw17tr15Gw4rKrg_yoWxtFbEvw
        47t3s3Gr4rZFWjyrn8J3ZxZrn3Gr45Zr15Gw1ruF45WF4jyFW7Jrs7t34xu343Gw4ayrs8
        Cws0yasFvr9FvjkaLaAFLSUrUUUUnb8apTn2vfkv8UJUUUU8wcxFpf9Il3svdxBIdaVrn0
        xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUO
        17kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3w
        AFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK
        6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7
        xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8JVW8Jr1ln4kS
        14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
        1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv
        67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
        AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE
        7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I
        0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAI
        cVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcV
        CF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Dl1DUUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年02月21日 01:53, Paolo Bonzini 写道:
> On 2/20/23 07:57, Tianrui Zhao wrote:
>> +    vcpu->arch.guest_eentry = (unsigned long)kvm_context->kvm_eentry;
>> +    vcpu->arch.vcpu_run = kvm_context->kvm_enter_guest;
>> +    vcpu->arch.handle_exit = _kvm_handle_exit;
>
> Here as well, whatever is constant must not be stored in struct 
> kvm_arch_vcpu.
>
> Paolo

Thanks,  we use this in vcpu_arch because the vcpu_arch is used as 
argument in switch.S' methods, we can quickly access the guest_eentry 
and handle_exit by using the  KVM_ARCH_GEENTRY, KVM_ARCH_HANDLE_EXIT 
offsets. If we change to global variable ,  we should relocate it in 
switch.S and may lead  to lower accessing speed.

