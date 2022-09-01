Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03BC85A9AFB
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 16:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbiIAO4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 10:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiIAO4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 10:56:01 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536A443E70
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 07:55:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F115122675;
        Thu,  1 Sep 2022 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662044157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tB56p3j1BY/z2s6+t+ncGm95Cx02S/7xpeAXAlovp1Y=;
        b=Zy+14pGvDa+IEV66Lk9hf+9Os7t/uZIbRCu1YX1NZ3BRZPa1E6ced1yGqyDusIZ6FaHv8D
        zQvNNrorGL9lWwkq1hzcRrMTZEJSJ9nKywmcgVgiNY9b8vyKBLw+8IRvkXbkwn82YQZesl
        fgtdJz7PJD59a2GdqhdBo6wD6N1I8F4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662044158;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tB56p3j1BY/z2s6+t+ncGm95Cx02S/7xpeAXAlovp1Y=;
        b=GFJ9aD3YfH8SPhlgoT5zJB7zkXXCWGg+E7tb5w6IQL1Gzc+sKJYlGtjS4d7j6TKa76pkF8
        trBolLXprkVAjrCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6E33C13A79;
        Thu,  1 Sep 2022 14:55:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FN+rF/3HEGOBagAAMHmgww
        (envelope-from <cfontana@suse.de>); Thu, 01 Sep 2022 14:55:57 +0000
Message-ID: <cd14d1d5-3484-f1db-9473-9db7929789f3@suse.de>
Date:   Thu, 1 Sep 2022 16:55:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 0/2] expose host-phys-bits to guest
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>
References: <20220831125059.170032-1-kraxel@redhat.com>
 <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
From:   Claudio Fontana <cfontana@suse.de>
In-Reply-To: <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/22 08:07, Xiaoyao Li wrote:
> On 8/31/2022 8:50 PM, Gerd Hoffmann wrote:
>> When the guest (firmware specifically) knows how big
>> the address space actually is it can be used better.
>>
>> Some more background:
>>    https://bugzilla.redhat.com/show_bug.cgi?id=2084533
> 
> QEMU enables host-phys-bits for "-cpu host/max" in 
> host_cpu_max_instance_init();

No, in host_cpu_max_instance_init the default for host-phys-bits is set to on.

You can still get the phys bits adjusted if you set the property to on manually for other cpu models.

> 
> I think the problem is for all the named CPU model, that they don't have 
> phys_bits defined. Thus they all have "cpu->phys-bits == 0", which leads 
> to cpu->phys_bits = TCG_PHYS_ADDR_BITS (36 for 32-bits build and 40 for 
> 64-bits build)
> 
> Anyway, IMO, guest including guest firmware, should always consult from 
> CPUID leaf 0x80000008 for physical address length. Tt is the duty of 
> userspace VMM, here QEMU, to ensure VM's host physical address length 
> not exceeding host's. If userspace VMM cannot ensure this, guest is 
> likely hitting problem.
> 
>> This is a RfC series exposes the information via cpuid.
>>
>> take care,
>>    Gerd
>>
>> Gerd Hoffmann (2):
>>    [hack] reserve bit KVM_HINTS_HOST_PHYS_BITS
>>    [RfC] expose host-phys-bits to guest
>>
>>   include/standard-headers/asm-x86/kvm_para.h | 3 ++-
>>   target/i386/cpu.h                           | 3 ---
>>   hw/i386/microvm.c                           | 6 +++++-
>>   target/i386/cpu.c                           | 3 +--
>>   target/i386/host-cpu.c                      | 4 +++-
>>   target/i386/kvm/kvm.c                       | 1 +
>>   6 files changed, 12 insertions(+), 8 deletions(-)
>>
> 
> 

