Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A235C76B9E3
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 18:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbjHAQst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 12:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjHAQso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 12:48:44 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7320D210E
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 09:48:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 193821F37F;
        Tue,  1 Aug 2023 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690908522; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lWB4OxoNL4zke6nToTfy8HwF+ManI7/k360H2pA3+rM=;
        b=RtZ6LKUrTc/pokJ7IK0o+vtt4UPHiqifpf2zfO4PMTtmrYhrCG4m3QF+XdUXfwrlQtN7j0
        9na5LKY4eOELxxMXSCZ8PgHh+F7QeVHvPkzbYtFR0UOhXY9raKOlJVjKxeJgYaVUkNay/I
        PVfG5ED6EC5Gi2bSyjOQ+/ttrNwYfro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690908522;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lWB4OxoNL4zke6nToTfy8HwF+ManI7/k360H2pA3+rM=;
        b=osUs2P7H/5oypgGThiIpIKUJyWEn+9LrkEncOBd24uCThVsRSdGyujyvnvrJbLeaUhyo7x
        KOOfupL81o/OZODA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 422FC13919;
        Tue,  1 Aug 2023 16:48:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Rb2xDWk3yWRsLQAAMHmgww
        (envelope-from <cfontana@suse.de>); Tue, 01 Aug 2023 16:48:41 +0000
Message-ID: <3a14456d-244c-ce8f-9d1c-8bcdb75de81c@suse.de>
Date:   Tue, 1 Aug 2023 18:48:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH 04/19] memory: Introduce
 memory_region_can_be_private()
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-5-xiaoyao.li@intel.com>
From:   Claudio Fontana <cfontana@suse.de>
In-Reply-To: <20230731162201.271114-5-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/31/23 18:21, Xiaoyao Li wrote:
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  include/exec/memory.h | 9 +++++++++
>  softmmu/memory.c      | 5 +++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 61e31c7b9874..e119d3ce1a1d 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -1679,6 +1679,15 @@ static inline bool memory_region_is_romd(MemoryRegion *mr)
>   */
>  bool memory_region_is_protected(MemoryRegion *mr);
>  
> +/**
> + * memory_region_can_be_private: check whether a memory region can be private

The name of the function is not particularly informative,

> + *
> + * Returns %true if a memory region's ram_block has valid gmem fd assigned.

but in your comment you describe more accurately what it does, why not make it the function name?

bool memory_region_has_valid_gmem_fd()

> + *
> + * @mr: the memory region being queried
> + */
> +bool memory_region_can_be_private(MemoryRegion *mr);


bool memory_region_has_valid_gmem_fd()


Thanks,

C

> +
>  /**
>   * memory_region_get_iommu: check whether a memory region is an iommu
>   *
> diff --git a/softmmu/memory.c b/softmmu/memory.c
> index 4f8f8c0a02e6..336c76ede660 100644
> --- a/softmmu/memory.c
> +++ b/softmmu/memory.c
> @@ -1855,6 +1855,11 @@ bool memory_region_is_protected(MemoryRegion *mr)
>      return mr->ram && (mr->ram_block->flags & RAM_PROTECTED);
>  }
>  
> +bool memory_region_can_be_private(MemoryRegion *mr)
> +{
> +    return mr->ram_block && mr->ram_block->gmem_fd >= 0;
> +}
> +
>  uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
>  {
>      uint8_t mask = mr->dirty_log_mask;

