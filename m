Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA82D7B64BF
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 10:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239453AbjJCIzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 04:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239429AbjJCIzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 04:55:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90835A9
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 01:55:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 29CDF1F8A4;
        Tue,  3 Oct 2023 08:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696323303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgMoKJDMA7P7Mr4hrLvpcSMZxVY3kCnXlTr03aMlWF4=;
        b=0OnvUE6ShndjTjhIBaEdUfx0PrYNzW1YY9K7ei7srY4/iBOBRTtgL0T2/Cr1NnGjCoyABL
        MWZaXSfH8G0S6SfedLOFafzwldk7p6t8s3IKlERjfrCWusi9LHAICxVJ1+SPzmBbr54QvI
        amGjeNTYP3ftBoqFM2KosN56Y9NfIbs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696323303;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgMoKJDMA7P7Mr4hrLvpcSMZxVY3kCnXlTr03aMlWF4=;
        b=drjUcmwK7x6XrG778/bt03UPkQFr0oqy1gESXwcL4OhFV4xJfcf5R55/mvgnNd1eJI4YDY
        w5KizEQyshzVe4Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B6006139F9;
        Tue,  3 Oct 2023 08:55:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JKgaKubWG2VRPgAAMHmgww
        (envelope-from <cfontana@suse.de>); Tue, 03 Oct 2023 08:55:02 +0000
Message-ID: <39bac54e-be9f-f425-81be-62395633ad13@suse.de>
Date:   Tue, 3 Oct 2023 10:55:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 3/5] accel: Declare AccelClass::[un]realize_cpu() handlers
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20230915190009.68404-1-philmd@linaro.org>
 <20230915190009.68404-4-philmd@linaro.org>
From:   Claudio Fontana <cfontana@suse.de>
In-Reply-To: <20230915190009.68404-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/23 21:00, Philippe Mathieu-Daudé wrote:
> Currently accel_cpu_realize() only performs target-specific
> realization. Introduce the [un]realize_cpu fields in the
> base AccelClass to be able to perform target-agnostic
> [un]realization of vCPUs.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Just thinking, for the benefit of the reader trying to understand the code later on,
maybe putting in a "target_" in there somewhere in the function name?
like "realize_cpu_target", vs "realize_cpu_generic" ?

Ciao,

C

> ---
>  include/qemu/accel.h |  2 ++
>  accel/accel-common.c | 21 +++++++++++++++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/include/qemu/accel.h b/include/qemu/accel.h
> index 23254c6c9c..7bd9907d2a 100644
> --- a/include/qemu/accel.h
> +++ b/include/qemu/accel.h
> @@ -43,6 +43,8 @@ typedef struct AccelClass {
>      bool (*has_memory)(MachineState *ms, AddressSpace *as,
>                         hwaddr start_addr, hwaddr size);
>  #endif
> +    bool (*realize_cpu)(CPUState *cpu, Error **errp);
> +    void (*unrealize_cpu)(CPUState *cpu);
>  
>      /* gdbstub related hooks */
>      int (*gdbstub_supported_sstep_flags)(void);
> diff --git a/accel/accel-common.c b/accel/accel-common.c
> index cc3a45e663..6d427f2b9d 100644
> --- a/accel/accel-common.c
> +++ b/accel/accel-common.c
> @@ -122,15 +122,32 @@ void accel_cpu_instance_init(CPUState *cpu)
>  bool accel_cpu_realize(CPUState *cpu, Error **errp)
>  {
>      CPUClass *cc = CPU_GET_CLASS(cpu);
> +    AccelState *accel = current_accel();
> +    AccelClass *acc = ACCEL_GET_CLASS(accel);
>  
> -    if (cc->accel_cpu && cc->accel_cpu->cpu_realizefn) {
> -        return cc->accel_cpu->cpu_realizefn(cpu, errp);
> +    /* target specific realization */
> +    if (cc->accel_cpu && cc->accel_cpu->cpu_realizefn
> +        && !cc->accel_cpu->cpu_realizefn(cpu, errp)) {
> +        return false;
>      }
> +
> +    /* generic realization */
> +    if (acc->realize_cpu && !acc->realize_cpu(cpu, errp)) {
> +        return false;
> +    }
> +
>      return true;
>  }
>  
>  void accel_cpu_unrealize(CPUState *cpu)
>  {
> +    AccelState *accel = current_accel();
> +    AccelClass *acc = ACCEL_GET_CLASS(accel);
> +
> +    /* generic unrealization */
> +    if (acc->unrealize_cpu) {
> +        acc->unrealize_cpu(cpu);
> +    }
>  }
>  
>  int accel_supported_gdbstub_sstep_flags(void)

